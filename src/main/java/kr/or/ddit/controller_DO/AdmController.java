package kr.or.ddit.controller_DO;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
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

import kr.or.ddit.mapper.AdminMapper;
import kr.or.ddit.mapper.UserMapper;
import kr.or.ddit.service_DO.AdminService;
import kr.or.ddit.service_DO.InquiryBoardService;
import kr.or.ddit.service_DO.NoticeService;
import kr.or.ddit.util.ArticlePage;
import kr.or.ddit.util.ArticlePage;
import kr.or.ddit.vo.BoardVO;
import kr.or.ddit.vo.CodeGrpVO;
import kr.or.ddit.vo.CodeVO;
import kr.or.ddit.vo.CommentVO;
import kr.or.ddit.vo.DeclarationVO;
import kr.or.ddit.vo.EnterVO;
import kr.or.ddit.vo.FileDetailVO;
import kr.or.ddit.vo.MemberVO;
import lombok.extern.slf4j.Slf4j;

@RequestMapping("/adm")
@Slf4j
@Controller
public class AdmController {

	@Autowired
	UserMapper userMapper;
	
	@Inject
	AdminMapper adminMapper;
	
	@Inject
	AdminService adminService;
	
	@Inject
	NoticeService noticeService;

	@Inject
	InquiryBoardService inquiryService;
	
	@GetMapping("/main")
	public String main(Model model) {
		Map<String, Object> map = new HashMap<>();
		//게시글 수
		int entSignTotal = this.adminService.mainEntSignTotal();
		int inquiryTotal = this.adminService.mainInquiryTotal();
		int reportMemTotal = this.adminService.mainReportMemTotal();
		int reportBoardTotal = this.adminService.mainReportBoardTotal();
		
		model.addAttribute("entSignTotal",entSignTotal);
		model.addAttribute("inquiryTotal",inquiryTotal);
		model.addAttribute("reportMemTotal",reportMemTotal);
		model.addAttribute("reportBoardTotal",reportBoardTotal);
		//게시글
		List<BoardVO> noticeVOList = this.adminService.mainNoticeList();
		List<BoardVO> inquiryVOList = this.adminService.mainInquiryList();
		List<EnterVO> entVOList = this.adminService.mainEntList();
		List<DeclarationVO> declarationVOList = adminService.mainReportList();
		
		model.addAttribute("noticeVOList",noticeVOList);
		model.addAttribute("inquiryVOList",inquiryVOList);
		model.addAttribute("entVOList",entVOList);
		model.addAttribute("declarationVOList",declarationVOList);
		
		return "adm/main";
	}
	//회원관리페이지
	@GetMapping("/memManage")
	public String memManage() {
	    return "adm/memManage"; 
	}

	//회원리스트
	@GetMapping("/memList")
	public ResponseEntity<?> getMember(@RequestParam("currentPage") int currentPage,
	                                   @RequestParam("searchKeyword") String searchKeyword) {
	    int size = 10;
	    int startRow = (currentPage - 1) * size + 1;
	    int endRow = currentPage * size;
	    List<CodeVO> codeVOList = userMapper.codeSelect("WAMA");
	    Map<String, Object> memMap = new HashMap<>();
	    memMap.put("startRow", startRow);
	    memMap.put("endRow", endRow);
	    memMap.put("searchKeyword", "%" + searchKeyword + "%");

	    int memTotal = adminService.memTotal(memMap);
	    List<MemberVO> memberVOList = adminService.memList(memMap);

	    ArticlePage<MemberVO> page = new ArticlePage<>(memTotal, currentPage, size, memberVOList);
	    page.setCodeVOList(codeVOList);
	    
	    return ResponseEntity.ok(page);
	}

	@GetMapping("/entList")
	public ResponseEntity<?> getEnter(@RequestParam("currentPage") int currentPage,
	                                   @RequestParam("searchKeyword") String searchKeyword) {
	    int size = 10;
	    int startRow = (currentPage - 1) * size + 1;
	    int endRow = currentPage * size;

	    Map<String, Object> entMap = new HashMap<>();
	    entMap.put("startRow", startRow);
	    entMap.put("endRow", endRow);
	    entMap.put("searchKeyword", "%" + searchKeyword + "%");

	    int entTotal = adminService.entTotal(entMap);
	    List<EnterVO> enterVOList = adminService.entList(entMap);

	    ArticlePage<EnterVO> page = new ArticlePage<>(entTotal, currentPage, size, enterVOList);

	    return ResponseEntity.ok(page);
	}
	
	@GetMapping("/reportList")
	public ResponseEntity<?> getReport(@RequestParam("currentPage") int currentPage,
	                                   @RequestParam("searchKeyword") String searchKeyword) {
	    int size = 10;
	    int startRow = (currentPage - 1) * size + 1;
	    int endRow = currentPage * size;
	    List<CodeVO> codeVOList = userMapper.codeSelect("WAMA");
	    Map<String, Object> reportMap = new HashMap<>();
	    reportMap.put("startRow", startRow);
	    reportMap.put("endRow", endRow);
	    reportMap.put("searchKeyword", "%" + searchKeyword + "%");
	    
	    int reportTotal = adminService.reportTotal(reportMap);
	    List<DeclarationVO> declarationVOList = adminService.reportList(reportMap);

	    ArticlePage<DeclarationVO> page = new ArticlePage<>(reportTotal, currentPage, size, declarationVOList);
	    page.setCodeVOList(codeVOList);

	    return ResponseEntity.ok(page);
	}

	@PostMapping("/reportLimit")
	@ResponseBody
	public String reportLimit(@RequestParam String comCode, @RequestParam String mbrId) {
	    Map<String, Object> paramMap = new HashMap<>();
	    paramMap.put("comCode", comCode);
	    paramMap.put("mbrId", mbrId);
	    
	    // adminService.reportLimit 메서드가 영향을 받은 행(row)의 수를 반환한다고 가정
	    int result = adminService.reportLimit(paramMap);
	    
	    // 영향을 받은 행이 0보다 크면 성공, 그렇지 않으면 실패
	    return result > 0 ? "success" : "fail";
	}

	//기업승인관리
	//기업승인관리
	//기업승인관리
	@GetMapping("/entApproval")
	public ModelAndView entApproval(@RequestParam(value="currentPage", required=false, defaultValue="1") int currentPage) {
	    // 페이징 처리를 위한 파라미터 맵 설정
	    Map<String, Object> map = new HashMap<>();
	    map.put("currentPage", currentPage);

	    // 목록 조회
	    List<EnterVO> entVOList = this.adminService.enterList(map);

	    // 목록 데이터 로그로 확인
	    log.info("entVOList: " + entVOList);

	    int total = this.adminService.mainEntSignTotal();

	    ArticlePage<EnterVO> articlePage = new ArticlePage<>(total, currentPage, 10, entVOList);

	    ModelAndView mav = new ModelAndView("adm/entApproval");
	    mav.addObject("articlePage", articlePage);

	    log.info("articlePage: " + articlePage);

	    return mav;
	}




	
	@PostMapping("/entOk")
	@ResponseBody
	public int entOk(@RequestParam("entId") String entId) {
	    return adminService.entOk(entId); // 승인 처리
	}


	@PostMapping("/entNo")
	@ResponseBody
	public String entNo(@RequestParam("entId") String entId) {
	    return adminService.entNo(entId) > 0 ? "success" : "fail"; // 거절 처리
	}
	
	@GetMapping("/enterDetail")
	@ResponseBody
	public EnterVO getEnterDetail(@RequestParam("entId") String entId) {
	    EnterVO enterDetail = adminService.getEnterDetail(entId);
	    return enterDetail;
	}

	@GetMapping("/enterAllDetail")
	@ResponseBody
	public EnterVO enterAllDetail(@RequestParam("entId") String entId) {
		// 쿼리를 실행하여 엔터프라이즈 상세 정보를 가져옴
		EnterVO enterAllDetail = adminMapper.enterAllDetail(entId);
		return enterAllDetail;
	}
	@GetMapping("/memAllDetail")
	@ResponseBody
	public MemberVO memAllDetail(@RequestParam("mbrId") String mbrId) {
		MemberVO memAllDetail = adminMapper.memAllDetail(mbrId);
		return memAllDetail;
	}



	
	//코드관리 사이트
	@GetMapping("/codeManage")
	public ModelAndView codeManage(
	    @RequestParam(value="comCodeGrp", required=false, defaultValue="") String comCodeGrp,
	    @RequestParam(value="comCodeGrpNm", required=false, defaultValue="") String comCodeGrpNm,
	    @RequestParam(value="comCodeGrpDesc", required=false, defaultValue="") String comCodeGrpDesc,
	    @RequestParam(value="currentPage", required=false, defaultValue="1") int currentPage,
	    @RequestParam(value="searchKeyword", required=false, defaultValue="") String searchKeyword,
	    ModelAndView mav) {
	    
	    Map<String, Object> map = new HashMap<>();
	    map.put("currentPage", currentPage);
	    map.put("searchKeyword", "%" + searchKeyword + "%"); 
	    map.put("comCodeGrp", comCodeGrp);
	    map.put("comCodeGrpNm", comCodeGrpNm);
	    map.put("comCodeGrpDesc", comCodeGrpDesc);

	    // 전체 공통 코드 목록을 조회하여 comCodeGrp
	    List<CodeVO> codeGrpVOList = adminMapper.codeAllSelect(map);
	    mav.addObject("codeGrpVOList", codeGrpVOList);

	    // 선택한 comCodeGrp에 해당하는 데이터를 필터링하여 가져옴 (페이징 포함)
	    List<CodeVO> filteredCodeList = adminMapper.codeSelect(map); 
	    mav.addObject("filteredCodeList", filteredCodeList);

	    int total = this.adminService.getTotal(map);
	    
	    // 검색 키워드를 포함한 페이징 처리
	    ArticlePage<CodeVO> articlePage = new ArticlePage<>(total, currentPage, 10, filteredCodeList, comCodeGrp);
	    
	    mav.addObject("articlePage", articlePage);
	    mav.setViewName("adm/codeManage");

	    return mav;
	}

	@GetMapping("/getFilteredCodes")
	@ResponseBody
	public Map<String, Object> getFilteredCodes(@RequestParam("comCodeGrp") String comCodeGrp, @RequestParam("currentPage") int currentPage) {
	    Map<String, Object> result = new HashMap<>();

	    // 선택된 comCodeGrp에 해당하는 코드 필터링
	    Map<String, Object> paramMap = new HashMap<>();
	    paramMap.put("comCodeGrp", comCodeGrp);
	    paramMap.put("currentPage", currentPage);
	    
	    List<CodeVO> filteredCodeList = adminMapper.codeSelect(paramMap);
	    result.put("filteredCodeList", filteredCodeList);
	    
	    return result;
	}

	 //그룹코드추가
	@PostMapping("/codeGrpAdd")
	public String codeGrpAdd(@ModelAttribute CodeGrpVO codeGrpVO, RedirectAttributes redirectAttributes) {
	    // 그룹 코드 추가 로직 수행
	    int result = this.adminService.codeGrpAdd(codeGrpVO);

	    redirectAttributes.addAttribute("comCodeGrp", codeGrpVO.getComCodeGrp());
	    redirectAttributes.addAttribute("currentPage", 1); 

	    return "redirect:/adm/codeManage";
	}

	 
	 //그룹코드 삭제
	 @PostMapping("/codeGrpDel")
    public String codeGrpDel(@ModelAttribute CodeGrpVO codeGrpVO) {
		 
		 int result = this.adminService.codeGrpDel(codeGrpVO);

        return "redirect:/adm/codeManage";
    }

	// 코드 추가
	 @PostMapping("/codeAdd")
	 public String codeAdd(@ModelAttribute CodeVO codeVO, RedirectAttributes redirectAttributes) {
	     // 코드 추가 로직 수행
	     int result = this.adminService.codeAdd(codeVO);

	     // 리다이렉트 시 comCodeGrp 파라미터와 currentPage를 함께 전달
	     redirectAttributes.addAttribute("comCodeGrp", codeVO.getComCodeGrp());
	     redirectAttributes.addAttribute("currentPage", 1); // 필요한 경우 페이지 번호 설정

	     return "redirect:/adm/codeManage";
	 }


	 //코드삭제
	 @PostMapping("/codeDel")
	 @ResponseBody
	 public String codeDel(@RequestParam("comCode") String comCode) {
	     // 서비스 호출하여 코드 삭제
	     int result = adminService.codeDel(comCode);

	     return result > 0 ? "success" : "fail";
	 }
	 
	 @PostMapping("/codeCodeCh")
	 @ResponseBody
	 public String codeCodeCh(@RequestParam("comCode") String comCode, 
			 				@RequestParam("comCodeNm") String comCodeNm,
			 				@RequestParam("comCodeDesc") String comCodeDesc) {
	     Map<String, Object> paramMap = new HashMap<>();
	     paramMap.put("comCode", comCode);
	     paramMap.put("comCodeNm", comCodeNm);
	     paramMap.put("comCodeDesc", comCodeDesc);

	     int result = adminService.codeCodeCh(paramMap); // paramMap을 전달
	     
	     return result > 0 ? "success" : "fail";
	 }


	 //신고커뮤니티관리
	 //신고커뮤니티관리
	 @RequestMapping(value="/reportBoard", method=RequestMethod.GET)
	 public ModelAndView reportBoardList(ModelAndView mav,
	     @RequestParam(value="currentPage", required=false, defaultValue="1") int currentPage) {
	     // 페이징 관련 파라미터를 담을 맵 생성
	     Map<String, Object> map = new HashMap<>();
	     List<CodeVO> codeVOList = userMapper.codeSelect("WAMA");
	     map.put("currentPage", currentPage);
	     int pageSize = 10;  // 페이지 당 보여줄 항목 수
	     map.put("pageSize", pageSize);
	     // 신고 목록 데이터 조회
	     List<DeclarationVO> reportBoardVOList = adminService.reportBoardList(map);

	     int total = adminService.mainReportBoardTotal();

	     ArticlePage<DeclarationVO> articlePage = new ArticlePage<>(total, currentPage, pageSize, reportBoardVOList);

	     mav.addObject("codeVOList",codeVOList);
	     mav.addObject("reportBoardVOList", reportBoardVOList);
	     mav.addObject("articlePage", articlePage);

	     mav.setViewName("adm/reportBoard");

	     return mav;
	 }

	 
	 @PostMapping("/boardReport")
	 @ResponseBody
	 public String boardReport(@RequestParam String comCode, @RequestParam String mbrId) {
	     Map<String, Object> paramMap = new HashMap<>();
	     paramMap.put("comCode", comCode);
	     paramMap.put("mbrId", mbrId);
	     
	     // adminService.boardReport 메서드가 영향을 받은 행(row)의 수를 반환한다고 가정
	     int result = adminService.boardReport(paramMap);
	     
	     // 영향을 받은 행이 0보다 크면 성공, 그렇지 않으면 실패
	     return result > 0 ? "success" : "fail";
	 }


	@PostMapping("reportBoardDel")
	@ResponseBody
	public String reportBoardDel(@RequestParam("dclrNo") String dclrNo) {
		int result = adminService.reportBoardDel(dclrNo); 
		return result > 0 ? "success" : "fail"; 
	}

}
