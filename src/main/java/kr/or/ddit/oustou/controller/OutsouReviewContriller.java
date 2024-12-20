package kr.or.ddit.oustou.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.ddit.mapper.FileDetailMapper;
import kr.or.ddit.mapper.UserMapper;
import kr.or.ddit.oustou.service.OutsouReviewService;
import kr.or.ddit.security.SocketHandler;
import kr.or.ddit.service_DO.FreeBoardService;
import kr.or.ddit.service_DO.NotificationService;
import kr.or.ddit.util.ArticlePage;
import kr.or.ddit.util.GetUserUtil;
import kr.or.ddit.vo.BoardVO;
import kr.or.ddit.vo.CodeVO;
import kr.or.ddit.vo.CommentVO;
import kr.or.ddit.vo.DeclarationVO;
import kr.or.ddit.vo.FileDetailVO;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.NotificationVO;
import kr.or.ddit.vo.OsAplyVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/outsou")
public class OutsouReviewContriller {
	
	@Autowired
	OutsouReviewService outsouReviewService;

	//공통코드를 가져오기 위함
	@Autowired
	UserMapper userMapper;
	
	//사용자의 정보?를 가져오기 위함
	@Inject
	GetUserUtil getUserUtil;
	
	//파일을 가져오기 위한 
	@Inject
	FreeBoardService freeBoardService;
	
	@Inject
	NotificationService notificationService;
	
    @Autowired
    private SocketHandler socketHandler;
    
	//리뷰 리스트 페이지
	@RequestMapping(value="/reviewList",method=RequestMethod.GET)
	public ModelAndView reviewList(ModelAndView mav,
			@RequestParam(value = "currentPage", required = false, defaultValue = "1") Integer currentPage,   
	        @RequestParam(value = "order", required = false) String order,
	        RedirectAttributes redirectAttributes) {

	    // 파라미터 맵 설정 (정렬을 위한 값 포함)
	    Map<String, Object> map = new HashMap<>();
	    map.put("currentPage", currentPage);
	    map.put("order", order);

	    // 리뷰 게시글 리스트와 전체 페이지 수 가져오기
	    List<BoardVO> getReviewList = outsouReviewService.getReviewList(map); // 리뷰 게시글 리스트 
	    int total = outsouReviewService.getTotal(map); // 페이지네이션을 위한 전체 행의 수

	    // 페이지네이션 객체 생성
	    ArticlePage<BoardVO> articlePage = new ArticlePage<>(total, currentPage, 10, getReviewList, map);
	    mav.addObject("articlePage", articlePage); // 페이지네이션 정보 추가

	    // 로그인한 사용자 정보 가져오기
	    Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
	    String mbrId = authentication.getName();
	    
	    // 사용자가 구입한 상품 릐 리스트를가져오기
	    List<OsAplyVO> osAplyVOList = this.outsouReviewService.reviewRegist(mbrId);
	    mav.addObject("osAplyVOList", osAplyVOList); // 구입한 상품 가져오기 
	    
	    
	    // 사용자가 구입한 상품이 있는지 여부 확인
	    boolean hasPurchasedItems = (osAplyVOList != null && !osAplyVOList.isEmpty());
	    mav.addObject("hasPurchasedItems", hasPurchasedItems);
	    
	    // 로그인한 사용자 아이디와 경고 횟수 처리
	    if (authentication != null && authentication.isAuthenticated() && !(authentication instanceof AnonymousAuthenticationToken)) {
	        mav.addObject("loggedInUser", mbrId);  // 로그인한 사용자 아이디 추가
	        MemberVO memVO = getUserUtil.getMemVO();
            if(memVO == null) {
            	mav.setViewName("outsou/review/reviewList");
            }else {
		        // 로그인한 사용자의 경고 횟수를 체크 (경고 횟수가 4번을 넘으면 리다이렉트)
		        memVO = getUserUtil.getMemVO();
		        if (memVO.getMbrWarnCo() > 4) {
		            redirectAttributes.addFlashAttribute("alertMessage", "게시판 제한자입니다.");
		            return new ModelAndView("redirect:/"); // 경고가 많으면 홈으로 리다이렉트
		        }
		    }
	    }

	    // 뷰 설정s
	    mav.setViewName("outsou/review/reviewList");
	    return mav;
	}

	
	//리뷰 등록 폼
	@GetMapping("/reviewRegist")
	public String reviewregist(Model model) {
		 // 로그인한 사용자 정보 가져오기
	    Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
	    String mbrId = authentication.getName();  // 로그인한 사용자 이름 (id)
		
	    //로그인한 회원이 구입한 상품(즉, 결제상품에 아이디가 있는 경우 보여주는데 리뷰를 작성하지 않은 상품만 보여 )
		 List<OsAplyVO> osAplyVOList = this.outsouReviewService.reviewRegist(mbrId);
		 
		 model.addAttribute("osAplyVOList", osAplyVOList);
		
		return "outsou/review/reviewRegist";
	}
	
	//리뷰 등록 실행
	@PostMapping("/reviewRegistPost")
	public String reviewRegistPost(@ModelAttribute BoardVO boardVO,  @RequestParam("outordNo") String outordNo) {
		// 로그인한 사용자 정보 가져오기
	    Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
	    String mbrId = authentication.getName();  // 로그인한 사용자 이름 (id)
	    
	    // boardVO의 작성자(writer) 필드에 로그인한 사용자 설정
	    boardVO.setMbrId(mbrId);
	    
	    log.info("registPost->boardVO : " + boardVO);
	    
	    int result = this.outsouReviewService.reviewRegistPost(boardVO, outordNo);
	    log.info("registPost->result : " + result);
	    
	    return "redirect:/outsou/reviewDetail?seNo=5"+ "&pstSn=" + boardVO.getPstSn();
	    
	}
	
	
	///리뷰 상세냐용
	@GetMapping("/reviewDetail") 
	public String reviewDetail(@RequestParam("pstSn") String pstSn, Model model) {
		
		log.info("detail=> getpstSn : "+pstSn);
		
		//신고 내용을 가져오기 위한 코드 
	    List<CodeVO> codeVOList = userMapper.codeSelect("WARN");
	    log.info("codeVOList", codeVOList);

	    // 상세정보 가져오기
	    BoardVO boardVO = this.outsouReviewService.reviewDetail(pstSn);
	    log.info("boardVO", boardVO);
	    
	    
	    // 댓글 목록 가져오기
	    List<CommentVO> commentsList = this.outsouReviewService.getComments(pstSn);

	    // 파일 상세 정보 가져오기
	    List<FileDetailVO> fileDetails = this.outsouReviewService.getFileDetailsByPstSn(pstSn);
	    model.addAttribute("codeVOList", codeVOList); // 신고내용코드 가져오기 
	    model.addAttribute("commentsList", commentsList); //댓글 목록
	    model.addAttribute("fileDetails", fileDetails);  // 파일 상세 정보 추가
	    model.addAttribute("boardVO", boardVO); //상세정보를 가져오기 
				   
	    
	 // 로그인한 사용자 ID 가져오기
	    Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
	    String loggedInUser = "anonymousUser";  // 기본 값 설정
	    
	    if (authentication != null && authentication.isAuthenticated() && !(authentication instanceof AnonymousAuthenticationToken)) {
	        loggedInUser = authentication.getName();
	        model.addAttribute("loggedInUser", loggedInUser);
	    }
	    
	    //게시판제한 경고 및 비로그인은 접근가능
	    if (authentication != null && authentication.isAuthenticated() && !(authentication instanceof AnonymousAuthenticationToken)) {
	        loggedInUser = authentication.getName();
	        model.addAttribute("loggedInUser", loggedInUser);
	        MemberVO memVO = getUserUtil.getMemVO();
	        if(memVO == null) {
	        	return "outsou/review/reviewDetail";  
	        }else {
		        // 로그인한 사용자의 경고 횟수를 체크
		        memVO = getUserUtil.getMemVO();
			    if(memVO.getMbrWarnCo() > 4) {
			    	model.addAttribute("alertMessage", "게시판 제한자입니다");
			    	return "home";
			    }
	        }
	    }
	    
    	return "outsou/review/reviewDetail";
	}
	
	
	//수정 폼
	@GetMapping("/reviewUpdate")
	public String reviewUpdate(@RequestParam("pstSn") String pstSn, Model model) {
		
		// 로그인한 사용자 정보 가져오기
	    Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
	    String mbrId = authentication.getName();  // 로그인한 사용자 이름 (id)
	    
	    
	    //로그인한 회원이 구입한 상품(즉, 결제상품에 아이디가 있는 경우 보여줌 )
		List<OsAplyVO> osAplyVOList = this.outsouReviewService.reviewRegist(mbrId);
		 
	    // 게시글 정보 가져오기
	    BoardVO boardVO = outsouReviewService.reviewDetail(pstSn);
	    log.info("boardVO --> "+ boardVO);
	    
	 // 파일 상세 정보 가져오기
	    List<FileDetailVO> fileDetails = this.outsouReviewService.getFileDetailsByPstSn(pstSn);
	    
	    
	    
	    //로그인한 사용자 ID 가져오기
	  String loggedInUser = "anonymousUser";  // 기본 값 설정

	  if (authentication != null && authentication.isAuthenticated() && !(authentication instanceof AnonymousAuthenticationToken)) {
  			loggedInUser = authentication.getName();
  			model.addAttribute("loggedInUser", loggedInUser);
	        // 게시글 작성자와 로그인한 사용자가 같은지 확인
	        if (!loggedInUser.equals(boardVO.getMbrId())) {
	            // 작성자가 아닌경우 List로 보내기
	            return "redirect:/outsou/reviewList";
	        }

	    }else {
	        // 비로그인 사용자 로그인창으로
	        return "redirect:/security/login";
	    }
	  
	    model.addAttribute("fileDetails", fileDetails);  // 파일 상세 정보 추가
	    model.addAttribute("osAplyVOList", osAplyVOList); //구매한 상품
	    model.addAttribute("boardVO", boardVO); //상세정보를 가져오기 
	  
	    return "outsou/review/reviewUpdata";  // 수정 화면으로 이동
	}
	
	
	//게시글 수정 실행 (동기방식)
	@PostMapping("/reviewUpdatePost")
	public String reviewUpdatePost(@ModelAttribute BoardVO boardVO) {
		
		log.info("reviewUpdatePost -->> boardVO : " + boardVO );
		
		int result = this.outsouReviewService.reviewUpdatePost(boardVO);
		log.info("reviewUpdatePost -->> result : " + result );
		
		return "redirect:/outsou/reviewDetail?pstSn="+boardVO.getPstSn();
	}
	
	
	//게시글 삭제
	@PostMapping("/reviewDeletePost")
	public String reviewDeletePost(@RequestParam("pstSn") String pstSn) {
	    log.info("reviewDeletePost -> getpstSn : " + pstSn);
	    
	    // 게시글 삭제
	    int result = this.outsouReviewService.reviewDeletePost(pstSn); 
	    if (result > 0) {
	        log.info("게시글 삭제 성공");
	    } else {
	        log.info("게시글 삭제 실패");
	    }
	    
	    return "redirect:/outsou/reviewList"; // 삭제 후 목록 페이지로 리디렉션
	}
	
	
	@PostMapping("/boardReport")
	@ResponseBody
	public String boardReport(@RequestBody DeclarationVO declarationVO) {
	    int result = freeBoardService.boardReport(declarationVO); 
	    return result > 0 ? "success" : "fail"; 
	}
	
	//
	
	
	/*      댓글  부분            */
	
	//댓글등록
	@PostMapping("/registReplyPost")
	public String registReplyPost(@RequestParam("commentContent") String commentContent, @RequestParam("pstSn") String pstSn) {
	    Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
	    String mbrId = authentication.getName();  // 로그인한 사용자 이름

	    CommentVO commentVO = new CommentVO();
	    commentVO.setCmntCn(commentContent);
	    commentVO.setPstSn(pstSn);
	    commentVO.setMbrId(mbrId);
	    commentVO.setCmntDelYn("1");

	    int result = this.outsouReviewService.registComment(commentVO);
	    log.info("registReplyPost->result : " + result);
	    
	    if (result > 0) {
	        String boardWriter = freeBoardService.getBoardWriter(pstSn); // 게시글 작성자 ID
	        log.info("게시글 작성자 ID: " + boardWriter);

	        // WebSocket 메시지 포맷
	        String websocketMessage = String.format("%s님이 작성하신 리뷰게시글에 댓글을 달았습니다!", mbrId); // 제목은 적절하게 가져와서 사용
	        // 현재 URL
            String currentUrl = "/outsou/reviewDetail?seNo=5&pstSn=" + pstSn;
	        // WebSocket 세션 체크 후 메시지 전송
	        log.info("boardWriter: " + boardWriter);
	        log.info("현재 등록된 세션 목록: " + socketHandler.getUserSessionsMap().keySet());

	        if (socketHandler.getUserSessionsMap().containsKey(boardWriter)) {
	            socketHandler.sendMessageToUser(boardWriter, websocketMessage);
	        } else {
	            log.warn("WebSocket 세션을 찾을 수 없음, 사용자: " + boardWriter);
	            log.info("현재 등록된 세션 목록: " + socketHandler.getUserSessionsMap().keySet());
	        }
	        
	        //알림 저장
	        NotificationVO notificationVO = new NotificationVO();
	        notificationVO.setCommonId(boardWriter); 
	        notificationVO.setNtcnCn(websocketMessage); // 알림 메시지 내용
	        notificationVO.setNtcnUrl(currentUrl); // 알림과 연결된 URL

	        this.notificationService.sendAlram(notificationVO);  // 알림 저장	        

	    }


	    return "redirect:/outsou/reviewDetail?pstSn=" + pstSn;
	}
	//댓글 수정
	@PostMapping("/updateComment")
    @ResponseBody
    public String updateComment(@RequestBody CommentVO commentVO) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String mbrId = authentication.getName();

        // 댓글 수정 처리
        commentVO.setMbrId(mbrId);
        int result = this.outsouReviewService.updateComment(commentVO);
        return result > 0 ? "success" : "fail";
    }
    
	//댓글 삭제
    @PostMapping("/deleteComment")
    @ResponseBody
    public String deleteComment(@RequestParam("cmntNo") String cmntNo, @RequestParam("pstSn") String pstSn) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String mbrId = authentication.getName();

        // 댓글 삭제 처리
        int result = this.outsouReviewService.deleteComment(cmntNo, pstSn, mbrId);
        return result > 0 ? "success" : "fail";
    }
    
	
}
