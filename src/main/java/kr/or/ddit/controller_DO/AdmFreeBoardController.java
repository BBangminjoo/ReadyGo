package kr.or.ddit.controller_DO;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.beans.factory.annotation.Autowired;
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

import kr.or.ddit.mapper.FileDetailMapper;
import kr.or.ddit.mapper.UserMapper;
import kr.or.ddit.security.SocketHandler;
import kr.or.ddit.service_DO.FreeBoardService;
import kr.or.ddit.service_DO.NotificationService;
import kr.or.ddit.util.ArticlePage;
import kr.or.ddit.vo.BoardVO;
import kr.or.ddit.vo.CodeVO;
import kr.or.ddit.vo.CommentVO;
import kr.or.ddit.vo.FileDetailVO;
import kr.or.ddit.vo.NotificationVO;
import lombok.extern.slf4j.Slf4j;

@RequestMapping("/adm/freeBoard")
@Slf4j
@Controller
public class AdmFreeBoardController {

	@Inject
	FreeBoardService freeBoardService;
	
	@Autowired
	UserMapper userMapper;
	
	@Inject
	FileDetailMapper fileDetailMapper;
	
	@Inject
	NotificationService notificationService;
	
    @Autowired
    private SocketHandler socketHandler;
	
	@GetMapping("/admFreeRegist")
	public String admRegist(Model model) {
	    List<CodeVO> codeVOList = userMapper.codeSelect("NOCA");
	    log.info("codeVOList", codeVOList);
	    
	    model.addAttribute("codeVOList", codeVOList);
	    
	    return "adm/freeBoard/admFreeRegist";
	}

	
	@PostMapping("/admRegistPost")
	public String admRegistPost(@ModelAttribute BoardVO boardVO) {
	    // 로그인한 사용자 정보 가져오기
	    Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
	    String mbrId = authentication.getName();  // 로그인한 사용자 이름 (id)
	    
	    // boardVO의 작성자(writer) 필드에 로그인한 사용자 설정
	    boardVO.setMbrId(mbrId);
	    
	    String fileGroupSn = this.fileDetailMapper.getFileGroupSn();
	    boardVO.setFileGroupSn(fileGroupSn);  
	    
	    log.info("registPost->boardVO : " + boardVO);
	    int result = this.freeBoardService.admRegistPost(boardVO);
	    log.info("registPost->result : " + result);
	    
	    return "redirect:/adm/freeBoard/admFreeDetail?seNo=3"+ "&pstSn=" + boardVO.getPstSn();
	}
	
	@RequestMapping(value="/admFreeList", method=RequestMethod.GET)
	public ModelAndView admList(ModelAndView mav,
	        @RequestParam(value="currentPage", required=false, defaultValue="1") int currentPage,
	        @RequestParam(value="pstOthbcscope", required=false, defaultValue="") String pstOthbcscope,
	        @RequestParam(value="searchKeyword", required=false, defaultValue="") String searchKeyword) {
        List<CodeVO> codeVOList = userMapper.codeSelect("FBOD");
        log.info("codeVOList", codeVOList);
        mav.addObject("codeVOList", codeVOList);
	    Map<String, Object> map = new HashMap<>();
	    map.put("currentPage", currentPage);
	    map.put("pstOthbcscope", pstOthbcscope);
	    map.put("searchKeyword", "%" + searchKeyword + "%"); 

	    log.info("list->map : " + map);
	    
	    List<BoardVO> boardVOList = this.freeBoardService.admList(map);
	    
	    int total = this.freeBoardService.getTotal(map);
	    mav.addObject("pstOthbcscope", pstOthbcscope);
	    mav.addObject("searchKeyword", searchKeyword);	    
	    // JSP로 전달하기 위해 Model 객체에 boardVOList 저장
	    mav.addObject("boardVOList", boardVOList);

        // 페이지네이션 객체
        ArticlePage<BoardVO> articlePage = new ArticlePage<>(total, currentPage, 10, boardVOList, searchKeyword, pstOthbcscope);
	    log.info("articlePage : " + articlePage);

	    mav.addObject("articlePage", articlePage);
	    mav.setViewName("adm/freeBoard/admFreeList");

	    return mav;
	}




	@GetMapping("/admFreeDetail")
	public String admDetail(@RequestParam("pstSn") String pstSn, Model model) {
	    log.info("detail=> getpstSn : "+pstSn);
	    List<CodeVO> codeVOList = userMapper.codeSelect("WARN");
	    log.info("codeVOList", codeVOList);
	    
	    model.addAttribute("codeVOList", codeVOList);

	    // 상세정보 가져오기
	    BoardVO boardVO = this.freeBoardService.admDetail(pstSn);
	    model.addAttribute("boardVO", boardVO);
	    
	    // 댓글 목록 가져오기
	    List<CommentVO> commentsList = this.freeBoardService.getComments(pstSn);
	    model.addAttribute("commentsList", commentsList);

	    // 파일 상세 정보 가져오기
	    List<FileDetailVO> fileDetails = this.freeBoardService.getFileDetailsByPstSn(pstSn);
	    model.addAttribute("fileDetails", fileDetails);  // 파일 상세 정보 추가
	    
        // 로그인한 사용자 ID 가져오기
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String mbrId = authentication.getName();
        model.addAttribute("loggedInUser", mbrId);
	    
	    return "adm/freeBoard/admFreeDetail";  
	}
	
	@PostMapping("/registReplyPost")
	public String registReplyPost(@RequestParam("commentContent") String commentContent, @RequestParam("pstSn") String pstSn) {
	    // 로그인한 사용자 정보 가져오기
	    Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
	    String mbrId = authentication.getName();  // 로그인한 사용자 이름 (id)

	    // 댓글 등록 VO 객체 생성
	    CommentVO commentVO = new CommentVO();
	    commentVO.setCmntCn(commentContent);
	    commentVO.setPstSn(pstSn);
	    commentVO.setMbrId(mbrId);
	    commentVO.setCmntDelYn("1");

	    // 댓글 등록
	    int result = this.freeBoardService.registComment(commentVO);
	    log.info("registReplyPost->result : " + result);
	    if (result > 0) {
	        String boardWriter = freeBoardService.getBoardWriter(pstSn); // 게시글 작성자 ID
	        log.info("게시글 작성자 ID: " + boardWriter);

	        // WebSocket 메시지 포맷
	        String websocketMessage = String.format("★관리자가 작성하신 자유게시글에 댓글을 달았습니다!"); // 제목은 적절하게 가져와서 사용
	        // 현재 URL
            String currentUrl = "/common/freeBoard/freeDetail?pstSn=" + pstSn;
	        // WebSocket 세션 체크 후 메시지 전송
	        log.info("boardWriter: " + boardWriter);
	        log.info("현재 등록된 세션 목록: " + socketHandler.getUserSessionsMap().keySet());

	        if(!boardWriter.equals(mbrId)) {
		        if (socketHandler.getUserSessionsMap().containsKey(boardWriter)) {
		            socketHandler.sendMessageToUser(boardWriter, websocketMessage);
		        } else {
		            log.warn("WebSocket 세션을 찾을 수 없음, 사용자: " + boardWriter);
		            log.info("현재 등록된 세션 목록: " + socketHandler.getUserSessionsMap().keySet());
		        }
		        //알림 저장
		        NotificationVO notificationVO = new NotificationVO();
		        notificationVO.setCommonId(boardWriter); // 게시글 작성자 ID
		        notificationVO.setNtcnCn(websocketMessage); // 알림 메시지 내용
		        notificationVO.setNtcnUrl(currentUrl); // 알림과 연결된 URL
		        this.notificationService.sendAlram(notificationVO);  // 알림 저장	        
	        }
	    }
	    // 댓글 등록 후 상세로 이동
	    return "redirect:/adm/freeBoard/admFreeDetail?pstSn=" + pstSn;
	}
    @PostMapping("/updateComment")
    @ResponseBody
    public String updateComment(@RequestBody CommentVO commentVO) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String mbrId = authentication.getName();

        // 댓글 수정 처리
        commentVO.setMbrId(mbrId);
        int result = this.freeBoardService.updateComment(commentVO);
        return result > 0 ? "success" : "fail";
    }
    
    @PostMapping("/deleteComment")
    @ResponseBody
    public String deleteComment(@RequestParam("cmntNo") String cmntNo, @RequestParam("pstSn") String pstSn) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String mbrId = authentication.getName();

        // 댓글 삭제 처리
        int result = this.freeBoardService.deleteComment(cmntNo, pstSn, mbrId);
        return result > 0 ? "success" : "fail";
    }
    @PostMapping("/deleteCommentAdm")
    @ResponseBody
    public String deleteCommentAdm(@RequestParam("cmntNo") String cmntNo, @RequestParam("pstSn") String pstSn) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String mbrId = authentication.getName();
    	// 댓글 삭제 처리
    	int result = this.freeBoardService.deleteCommentAdm(cmntNo, pstSn);
    	return result > 0 ? "success" : "fail";
    }
    
	@PostMapping("/deletePost")
	public String deletePost(@RequestParam("pstSn") String pstSn) {
	    log.info("deletePost -> getpstSn : " + pstSn);
	    
	    // 게시글 삭제
	    int result = freeBoardService.deletePost(pstSn); // 서비스에서 게시글 삭제
	    if (result > 0) {
	        log.info("게시글 삭제 성공");
	    } else {
	        log.info("게시글 삭제 실패");
	    }
	    
	    return "redirect:/adm/freeBoard/admFreeList"; // 삭제 후 목록 페이지로 리디렉션
	}
	

	@GetMapping("/admFreeUpdate")
	public String update(@RequestParam("pstSn") String pstSn, Model model) {
	    log.info("update => get pstSn : " + pstSn);
	    List<CodeVO> codeVOList = userMapper.codeSelect("NOCA");
	    log.info("codeVOList", codeVOList);
	    
	    // 게시글 상세 정보 가져오기
	    BoardVO boardVO = this.freeBoardService.getPostDetails(pstSn);
	    model.addAttribute("boardVO", boardVO);
	    model.addAttribute("codeVOList", codeVOList);
	    String fileGroupSn = this.fileDetailMapper.getFileGroupSn();
	    model.addAttribute(fileGroupSn);
	    // 파일 상세 정보 가져오기
	    List<FileDetailVO> fileDetails = this.freeBoardService.getFileDetailsByPstSn(pstSn);
	    model.addAttribute("fileDetails", fileDetails);  // 파일 상세 정보 추가
	    return "adm/freeBoard/admFreeUpdate";  // 수정 페이지로 이동
	}
	
	@PostMapping("/updatePost")
	public String updatePost(@ModelAttribute BoardVO boardVO) {
	    log.info("updatePost -> boardVO : " + boardVO);

	    String fileGroupSn = this.fileDetailMapper.getFileGroupSn();
	    boardVO.setFileGroupSn(fileGroupSn);  
	    // 수정된 데이터 업데이트
	    int result = this.freeBoardService.updatePost(boardVO);
	    
	    return "redirect:/adm/freeBoard/admFreeDetail?seNo=3&pstSn=" + boardVO.getPstSn();

	}
}
