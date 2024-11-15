package kr.or.ddit.enter.entcontroller;

import java.io.IOException;
import java.io.OutputStream;
import java.security.Principal;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
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
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.lowagie.text.Document;
import com.lowagie.text.DocumentException;
import com.lowagie.text.Paragraph;
import com.lowagie.text.pdf.PdfWriter;

import kr.or.ddit.enter.entservice.EmailService;
import kr.or.ddit.enter.entservice.EnterRevenueService;
import kr.or.ddit.enter.entservice.EnterService;
import kr.or.ddit.enter.entservice.EnterServiceS;
import kr.or.ddit.mapper.MemResumeMapper;
import kr.or.ddit.mapper.UserMapper;
import kr.or.ddit.security.CustomUser;
import kr.or.ddit.service.PbancService;
import kr.or.ddit.util.ArticlePage;
import kr.or.ddit.util.GetUserUtil;
import kr.or.ddit.vo.ApplicantVO;
import kr.or.ddit.vo.CodeVO;
import kr.or.ddit.vo.EnterEmpYcntVO;
import kr.or.ddit.vo.EnterRevenueVO;
import kr.or.ddit.vo.EnterVO;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.PbancVO;
import kr.or.ddit.vo.ProposalVO;
import kr.or.ddit.vo.ResumeVO;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/enter")
public class EnterController {

	@Inject // 기업
	private EnterService enterService;

	@Inject // 기업
	EnterServiceS enterServiceS;
	
	@Inject // 채용 공고 관련 서비스
	private PbancService pbancService; 

	@Inject // 기업매출액
	private EnterRevenueService enterRevenueService;

	@Autowired 
	private ServletContext servletContext;

	@Inject
	BCryptPasswordEncoder bCryptPasswordEncoder;
	 
	@Autowired // 이메일 전송 
	private EmailService emailService; 

	@Inject
	UserMapper userMapper;	
	
	@Inject	// 회원 이력서
	MemResumeMapper memResumeMapper;
	
    @Inject
    GetUserUtil getUserUtil;
    
    
    //--------------------------------------------------------------------------------------------------------------------------
	
	/* 기업프로필 */
	@GetMapping("/profile")
	public String profile(@RequestParam("entId") String entId, Model model) {
		EnterVO enterVO = this.enterService.profile(entId); //기업 프로필 정보
		List<PbancVO> pbancList = pbancService.getPbancList(entId); //채용 공고 리스트
		List<EnterRevenueVO> revenueList = enterRevenueService.revenue(entId); // 매출액 리스트
		List revenueYearList = new ArrayList(); // 연도
		List revenueAmountList = new ArrayList(); // 매출액
		List<EnterEmpYcntVO> empYcntList = enterService.empYcnt(entId); // 연도별 입사자수
		List<String> entYmList = new ArrayList<>(); // 연월
		List entEmpYcntList = new ArrayList(); // 해당연도 전체사원수
		List entNewEmpList = new ArrayList(); // 입사자
		List entOutEmpList = new ArrayList(); // 퇴사자
		
		for (int i = 0; i < revenueList.size(); i++) { //매출액리스트뽑기
			revenueYearList.add(revenueList.get(i).getRevenueYear());
			revenueAmountList.add(revenueList.get(i).getRevenueAmount());
		}

		for (int i = 0; i < empYcntList.size(); i++) { //연도별입사자수
			entYmList.add(empYcntList.get(i).getEntYm());
			entEmpYcntList.add(empYcntList.get(i).getEntEmpYcnt());
			entNewEmpList.add(empYcntList.get(i).getEntNewemp());
			entOutEmpList.add(empYcntList.get(i).getEntOutemp());
		}
		
		model.addAttribute("enterVO", enterVO);// 기업 프로필 정보
		model.addAttribute("PbancVOList", pbancList);// 채용 공고 리스트 
		model.addAttribute("revenueList",revenueList); //매출액 전체 리스트
		model.addAttribute("revenueYearList", revenueYearList);// 연도
		model.addAttribute("revenueAmountList", revenueAmountList);// 매출액
		model.addAttribute("empYcntList", empYcntList);//사원수 전체 리스트
		model.addAttribute("entYmList", entYmList);//연월
		model.addAttribute("entEmpYcntList", entEmpYcntList);//해당연도 전체 사원수
		model.addAttribute("entNewEmpList", entNewEmpList);//입사자
		model.addAttribute("entOutEmpList", entOutEmpList);//퇴사자

		return "enter/info/mypage/profile";
	}
	
	/*매출액 추가*/
	@ResponseBody
	@RequestMapping("insertRevenues")
	public String insertRevenues(@RequestBody List<EnterRevenueVO> revenues) {
		log.info("revenues : "+revenues);
		int result = this.enterRevenueService.insertRevenues(revenues);
		if(result !=revenues.size()) {
			return "fail";
		}
		return "success";
	}
	
	/*매출액 수정*/
	@ResponseBody
	@RequestMapping("updateRevenues")
	public String updateRevenues(@RequestBody List<EnterRevenueVO> revenues) {
		log.info("revenuesupdate : "+revenues);
		int result = this.enterRevenueService.updateRevenues(revenues);
		if(result !=revenues.size()) {
			return "fail";
		}
		return "success";
	}
	
	/*입사자 추가*/
	@ResponseBody
	@RequestMapping("insertYcnt")
	public String insertYcnt(@RequestBody List<EnterEmpYcntVO> ycnt) {
		log.info("updateYcnt : "+ycnt);
		log.info("ycnt.size() : "+ycnt.size());
		int result = this.enterRevenueService.insertYcnt(ycnt);
		if(result !=ycnt.size()) {
			return "fail";
		}
		return "success";
	}
	
	/*입사자 수정*/
	@ResponseBody
	@RequestMapping("updateYcnt")
	public String updateYcnt(@RequestBody List<EnterEmpYcntVO> ycnt) {
		log.info("updateYcnt : "+ycnt);
		log.info("ycnt.size() : "+ycnt.size());
		int result = this.enterRevenueService.updateYcnt(ycnt);
		if(result !=ycnt.size()) {
			return "fail";
		}
		return "success";
	}
	
	//--------------------------------------------------------------------------------------------------------------------------
	
	/* 기업정보수정폼 */
	@GetMapping("/edit")
	public String edit(@RequestParam("entId") String entId, Model model) {

		EnterVO enterVO = this.enterService.edit(entId);
		List<CodeVO> indutyList = enterService.getIndutyList();// 업종
		List<CodeVO> entStleCdList = enterService.getEntStleCdList();// 기업형태
		
		log.info("enterVO : ", enterVO);
		log.info("indutyList : " + indutyList);

		model.addAttribute("enterVO", enterVO);
		model.addAttribute("indutyList", indutyList);
		model.addAttribute("entStleCdList", entStleCdList);

		return "enter/info/mypage/edit";
	}
	
	/*기업정보수정 비밀번호 체크*/
	@ResponseBody
	@PostMapping("/editChk")
	public boolean editChk(EnterVO entVO) {
		boolean chk = false;

		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		CustomUser customUser = (CustomUser) authentication.getPrincipal();
		String pwd = customUser.getEntVO().getEntPswd();
		log.info("getEntPswd1 : " + entVO.getEntPswd());
		if (bCryptPasswordEncoder.matches(entVO.getEntPswd(), pwd)) {
			log.info("getEntPswd2 : " + entVO.getEntPswd());
			chk = true;
		}
		return chk;
	}
	
	/*기업정보수정 실행*/
	@PostMapping("/editPost")
	public String editPost(@ModelAttribute EnterVO enterVO, HttpServletRequest request, Model model) {
		log.info("enterVO : " + enterVO);
		String entFndnYmd=enterVO.getEntFndnYmd().replace("-", "");
		String entManagerTelno=enterVO.getEntManagerTelno().replace("-","");
		String entFxnum=enterVO.getEntFxnum().replace("-","");
		String entBrno = enterVO.getEntBrno().replace("-","");
		enterVO.setEntFndnYmd(entFndnYmd);
		enterVO.setEntManagerTelno(entManagerTelno);
		enterVO.setEntFxnum(entFxnum);
		enterVO.setEntBrno(entBrno);
		int result = this.enterService.editPost(enterVO);
		return "redirect:/enter/edit?entId=" + enterVO.getEntId();
	}

	//--------------------------------------------------------------------------------------------------------------------------
	
	/* 비밀번호수정폼 */
	@GetMapping("/passEdit")
	public String passEdit(@RequestParam("entId") String entId, Model model) {

		EnterVO enterVO = this.enterService.passEdit(entId);
		model.addAttribute("enterVO", enterVO);
		log.info("enterVO ::: " + enterVO);
		return "enter/info/mypage/passEdit";
	}
	
	/*비밀번호수정 실행*/
	@PostMapping("/passEditPost")
	public String passEditPost(@ModelAttribute EnterVO enterVO, HttpServletRequest request, Model model) {
		String setpwd = bCryptPasswordEncoder.encode(enterVO.getEntPswd());
		enterVO.setEntPswd(setpwd);
		log.info("enterVO : " + enterVO);
		int result = this.enterService.passEditPost(enterVO);
		return "redirect:/enter/passEdit?entId=" + enterVO.getEntId();
	}
	
	//--------------------------------------------------------------------------------------------------------------------------
	
	/* 기업탈퇴 */
	@ResponseBody
	@PostMapping("/deleteAjax")
	public int deleteAjax(@RequestBody String entId) {
		log.info("deleteAjax -> entId : " + entId);
		int result = this.enterService.deleteAjax(entId);
		return result;
	}
	
	//--------------------------------------------------------------------------------------------------------------------------
	
	///enter/injae?entId=test01&currentPage=2&keywordInput=Abaqus,Amazon%20EMR,Amazon%20RDS
	/* 인재 */
	@GetMapping("/injae")
	public ModelAndView injae(ModelAndView mav,
			@RequestParam(value = "entId", required = false, defaultValue = "") String entId,
			@RequestParam(value = "keywordInput", required = false, defaultValue = "") String keyword,
			@RequestParam(value = "currentPage", required = false, defaultValue = "1") Integer currentPage) {

		//keyword : Abaqus,Amazon%20EMR,Amazon%20RDS
		log.info("injae->keyword.length : " + keyword.length());
		
		String[] keywordInput = null;
		
		if(keyword.length()>0) {//페이지네이션에서 왔을 때
			keywordInput = keyword.split(","); 
		}else {//최초 인재 메뉴를 클랙했을 때(keyword.length가 0이므로)
			keywordInput = null;
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("currentPage", currentPage);
		map.put("entId", entId);
		map.put("keyword", keywordInput);
		
		log.info("list->map : " + map);
		
		List<CodeVO> skillList = enterService.getSkillList(map); // 스킬 목록 가져오기
		List<MemberVO> getInjaeList = this.enterService.getInjaeList(map); //인재리스트
		List<MemberVO> recommendList = enterService.getRecommendList(map); // 추천인재
		List<PbancVO> pbancList = enterService.pbancList(map); // 스카우트 제안 - 해당기업 공고 꺼내기
		
		log.info("skillList : " + skillList);
		log.info("list -> getInjaeList : " + getInjaeList);

		int total = this.enterService.getTotalInjae(map); // 페이지네이션 전체 행의수

		// 페이지네이션 객체
		ArticlePage<MemberVO> articlePage = new ArticlePage<MemberVO>(total, currentPage, 5, getInjaeList, map);
		
		log.info("articlePage : " + articlePage);
		
		mav.addObject("total", total);
		mav.addObject("keyword", keyword);
		mav.addObject("skillList", skillList);// 스킬 목록 가져오기
		mav.addObject("getInjaeList", getInjaeList); //인재리스트
		mav.addObject("articlePage", articlePage);// 페이지네이션 + 인재리스트
		mav.addObject("recommendList", recommendList);// 추천인재
		mav.addObject("pbancList", pbancList); // 스카우트 제안 - 해당기업 공고 꺼내기

		// 뷰 리졸버
		mav.setViewName("enter/injaePage/injae");

		return mav;
	}
	
	
	/* 인재 */
	@PostMapping("/injaePost")
	public ModelAndView injaePost(ModelAndView mav,
			@RequestParam(value = "entId", required = false, defaultValue = "") String entId,
			@RequestParam(value = "keywordInput", required = false, defaultValue = "") String[] keywordInput,
			@RequestParam(value = "currentPage", required = false, defaultValue = "1") Integer currentPage) {
		
		//entId : test01
		log.info("entId : " + entId);
		//currentPage : 1
		log.info("currentPage : " + currentPage);
		
		///enter/injae?entId=test01&currentPage=2&keywordInput=[Ljava.lang.String;@3521116
		String keywordInputStr = String.join(",", keywordInput); 
		//Abaqus,Amazon EMR,Amazon RDS
		log.info("injaePost->keywordInputStr : " + keywordInputStr);
		
		for(String keyword : keywordInput) {
			//keyword! : Amazon EC2
			log.info("keyword! : " + keyword);
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("currentPage", currentPage);
		map.put("entId", entId);
		map.put("keyword", keywordInput);//String[]
		log.info("keyword : " + keywordInput);
		log.info("list->map : " + map);
		
		List<CodeVO> skillList = enterService.getSkillList(map); // 스킬 목록 가져오기
		log.info("injaePost -> skillList : " + skillList);
		List<MemberVO> getInjaeList = this.enterService.getInjaeList(map); //인재리스트*****
		log.info("injaePost -> getInjaeList : " + getInjaeList);
		List<MemberVO> recommendList = enterService.getRecommendList(map); // 추천인재
		log.info("injaePost -> recommendList : " + recommendList);
		List<PbancVO> pbancList = enterService.pbancList(map); // 스카우트 제안 - 해당기업 공고 꺼내기
		log.info("injaePost -> pbancList : " + recommendList);
		
		
		int total = this.enterService.getTotalInjae(map); // 페이지네이션 전체 행의수
		
		// 페이지네이션 객체
		ArticlePage<MemberVO> articlePage = new ArticlePage<MemberVO>(total, currentPage, 5, getInjaeList, map);
		
		mav.addObject("keyword", keywordInputStr);
		mav.addObject("skillList", skillList);// 스킬 목록 가져오기
		mav.addObject("getInjaeList", getInjaeList); //인재리스트
		mav.addObject("articlePage", articlePage);// 페이지네이션 + 인재리스트
		mav.addObject("recommendList", recommendList);// 추천인재
		mav.addObject("pbancList", pbancList); // 스카우트 제안 - 해당기업 공고 꺼내기
		mav.addObject("total", total); // 인재 - 전체행의수
		
		// 뷰 리졸버
		mav.setViewName("enter/injaePage/injae");
		
		return mav;
	}
	
	//--------------------------------------------------------------------------------------------------------------------------
	
	/* 공고관리 */
	@GetMapping("/pbanc")
	public ModelAndView pbanc(ModelAndView mav,
			@RequestParam(value = "entId", required = false, defaultValue = "") String entId,
			@RequestParam(value = "currentPage", required = false, defaultValue = "1") Integer currentPage,
			@RequestParam(value = "keywordInput", required = false, defaultValue = "") String keyword,
			@RequestParam(value = "dateInput", required = false, defaultValue = "") String date,
			@RequestParam(value = "gubun", required = false, defaultValue = "") String gubun,
			@RequestParam(value = "gubunDate", required = false, defaultValue = "") String gubunDate) {

		/* 페이징처리 */
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("entId", entId);
		map.put("currentPage", currentPage);
		map.put("keyword", keyword);
		map.put("date", date);
		map.put("gubun", gubun);
		map.put("gubunDate", gubunDate);

		int count = this.enterServiceS.pbCount(entId); //공고 총 개수 구하기
		int total = this.enterService.getTotalPbanc(map); // 전체 행의 수
		mav.addObject("total", total);
		List<PbancVO> pbancList = enterService.getPbancList(map);// 공고 리스트 

		log.info("list->map : " + map);
		log.info("pbancList : " + pbancList);

		// 페이지네이션 객체
		ArticlePage<PbancVO> articlePage = new ArticlePage<PbancVO>(total, currentPage, 5, pbancList, map);
		
		mav.addObject("count", count); //공고 총 개수 구하기
		mav.addObject("articlePage", articlePage); //페이지네이션 + 공고리스트
		mav.addObject("pbancList", pbancList); //공고리스트
		
		mav.setViewName("enter/pbancPage/pbancList/pbancFolder/pbanc"); // 뷰리졸버
		return mav;
	}
	
	//--------------------------------------------------------------------------------------------------------------------------
	
	/* 공고상세 + 스크랩 */
	@GetMapping("/pbancDetail")
	public String pbancDetail(Model model, Principal principal, 
			@RequestParam(value = "entId", required = false, defaultValue = "") String entId,
			@RequestParam(value = "mbrId", required = false, defaultValue = "") String mbrId,
	        @RequestParam("pbancNo") String pbancNo,
	        @RequestParam(value = "scrapped", required = false, defaultValue = "false") boolean scrapped) {

			// 로그인된 회원의 mbrId 가져오기
		 String	loggedInMbrId = getUserUtil.getLoggedInUserId();			
	    
		log.info("loggedInMbrId : " + loggedInMbrId);
	    Map<String, Object> map = new HashMap<String, Object>();
	    map.put("pbancNo", pbancNo);
	    map.put("scrapped", scrapped);
	    map.put("mbrId", mbrId);
	    map.put("loggedInMbrId", loggedInMbrId);
	    
	    EnterVO location = this.enterService.location(entId); //주소 정보를 가져옴
	    
	    // 최신 스크랩 수 가져오기
	    int scrapCount = enterService.getScrapCount(pbancNo);
	    map.put("isScrapped", !scrapped);  // 스크랩 상태 반전
	    map.put("scrapCount", scrapCount); // 최신 스크랩 수
	    
	    // 스크랩 여부 구하기
	    int scrap = this.enterService.getscrap(map);
	    log.info("scrap : " + scrap);
	    if(scrap >0) {
	    	model.addAttribute("scraped", true);
	    }else {
	    	model.addAttribute("scraped", false);	    	
	    }
	    
	    // 공고 상세 리스트 가져오기
	    PbancVO pbancDetailList = enterService.pbancDetailList(map); 
	    String tpbizCd = pbancDetailList.getTpbizCd();
	    String[] tpbizCdArray = tpbizCd.split(",");
	    List<String> tpbizCdList = Arrays.asList(tpbizCdArray);
	    log.info("tpbizCdList : " + tpbizCdList);
	    
	    
	    // 공고 복지 및 혜택 
	    String favorCn = pbancDetailList.getFavorCn();
	    String[] favorArray = favorCn.split(",");
	    List<String> favorList = Arrays.asList(favorArray);

	    // 공고 지역 
	    String powkCd = pbancDetailList.getPowkNm();
	    String[] powkArray = powkCd.split(",");
	    List<String> powkList = Arrays.asList(powkArray);
	    
	    // 필수조건
	    String requiredCn = pbancDetailList.getRequiredCn();
	    String[] requiredArray = requiredCn.split(",");
	    List<String> requiredList = Arrays.asList(requiredArray);	    
	    // 우대조건
	    String preferCn = pbancDetailList.getPreferCn();
	    String[] preferArray = preferCn.split(",");
	    List<String> preferList = Arrays.asList(preferArray);	    
	    
	    
	    // 공고 지역
	    List<CodeVO> powkCdList = enterService.getpowkCdList(); 
	    
	    List<ResumeVO> selectResumeVOList = this.memResumeMapper.selectResumeList(loggedInMbrId); // 회원 이력서 목록(모달용)가져오기
	    
	    /*공통코드Select*/
        List<CodeVO> getRecruitmentCD = this.userMapper.codeSelect("RCCA");    //모집분야:모집경력   
        List<CodeVO> getRcritJbttlCD = this.userMapper.codeSelect("RCJB");     //모집분야:직급/직책  
        List<CodeVO> getPbancEduCD = this.userMapper.codeSelect("ACSE");       //공고:학력  
        List<CodeVO> getPbancGenCD = this.userMapper.codeSelect("PBGE");       //공고:성별   
        List<CodeVO> getPbancAgeCD = this.userMapper.codeSelect("PBAG");       //공고:연령   
        List<CodeVO> getPbancSalaryCD = this.userMapper.codeSelect("PBSA");    //공고:연봉/급여   
        List<CodeVO> getPbancWorkstleCD = this.userMapper.codeSelect("WOST");  //공고:근무형태  
        List<CodeVO> getPbancWorkDayCD = this.userMapper.codeSelect("WODA");   //공고:근무요일 
        List<CodeVO> getPbancWorkHrCD = this.userMapper.codeSelect("WOHR");    //공고:근무시간 
        List<CodeVO> getPbancRprsDtyCD = this.userMapper.codeSelect("INSE");   //공고:대표직무 
        List<CodeVO> getPbancRcptMthdCD = this.userMapper.codeSelect("RCMT");  //공고:지원접수방법
        List<CodeVO> getPbancAppofeFormCD = this.userMapper.codeSelect("APFO");//공고:지원서양식
        List<CodeVO> getProcssCD = this.userMapper.codeSelect("PRPR");         //전형절차:전형절차   
        List<CodeVO> getTpbizCD = this.userMapper.codeSelect("CRDT");          //업종
        
        model.addAttribute("getRecruitmentCD",getRecruitmentCD);     		   //모집경력   
        model.addAttribute("getRcritJbttlCD",getRcritJbttlCD);                 //직급/직책   
        model.addAttribute("getPbancEduCD",getPbancEduCD);	                   //공고:학력  
        model.addAttribute("getPbancGenCD",getPbancGenCD);	                   //공고:성별
        model.addAttribute("getPbancAgeCD",getPbancAgeCD);	                   //공고:연령
        model.addAttribute("getPbancSalaryCD",getPbancSalaryCD);	           //공고:연봉/급여    
        model.addAttribute("getPbancWorkstleCD",getPbancWorkstleCD);	       //공고:근무형태    
        model.addAttribute("getPbancWorkDayCD",getPbancWorkDayCD);	           //공고:근무요일     
        model.addAttribute("getPbancWorkHrCD",getPbancWorkHrCD);	           //공고:근무시간    
        model.addAttribute("getPbancRprsDtyCD",getPbancRprsDtyCD);	           //공고:대표직무     
        model.addAttribute("getPbancRcptMthdCD",getPbancRcptMthdCD);	       //공고:지원접수방법     
        model.addAttribute("getPbancAppofeFormCD",getPbancAppofeFormCD);	   //공고:지원서양식
        model.addAttribute("getProcssCD",getProcssCD);	                       //전형절차   
        model.addAttribute("getTpbizCD",getTpbizCD);	                       //업종	
        
        model.addAttribute("pbancDetailList", pbancDetailList);                //공고 상세 리스트 가져오기
        model.addAttribute("selectResumeVOList",selectResumeVOList);	       //이력서 목록 가져오기(모달용)
        model.addAttribute("scrapCount", scrapCount);
	    model.addAttribute("isScrapped", !scrapped); 						   //스크랩 상태
	    model.addAttribute("tpbizCdList", tpbizCdList); 					   //공고업종
	    model.addAttribute("powkList", powkList); 					   		   //공고지역
	    model.addAttribute("powkCdList", powkCdList); 					   	   //공고지역
	    model.addAttribute("requiredList", requiredList); 					   	   //공고지역
	    model.addAttribute("preferList", preferList); 					   	   //공고지역
	    
	    model.addAttribute("favorList", favorList); 						   //복지및혜택
	    log.info("pbancDetailList : " + pbancDetailList);
	    model.addAttribute("location", location);
	    return "enter/pbancIUD/pbancS/pbancD/pbancDe/Pbanc/pbancDetail";  // 공고 상세 페이지로 이동
	}
	
	/*공고 상세 페이지 스크랩*/
	@ResponseBody
	@PostMapping("/scrapPost")
	public Map<String, Object> scrapPost(Model model,		
			@RequestParam(value = "entId", required = false, defaultValue = "") String entId,
			@RequestParam(value = "mbrId", required = false, defaultValue = "") String mbrId,
	        @RequestParam(value = "pbancNo", required = true) String pbancNo,
	        @RequestParam(value = "scrapped", required = false, defaultValue = "false") boolean scrapped) {
		log.info("scrapped : " + scrapped);
	    Map<String, Object> map = new HashMap<String, Object>();
	    map.put("entId", entId);
	    map.put("pbancNo", pbancNo);
	    map.put("mbrId", mbrId);
	    
	    // 스크랩 여부를 토글 처리
	    if (scrapped) {
	        // 스크랩 취소
	    	int result = enterService.cancelScrap(map);
	    } else {
	        // 스크랩 추가
	    	int result = enterService.addScrap(map);
	    }
	    // 최신 스크랩 수 가져오기
	    int scrapCount = enterService.getScrapCount(pbancNo);
	    map.put("scrapped", !scrapped);  // 스크랩 상태 반전
	    map.put("scrapCount", scrapCount); // 최신 스크랩 수
	    
		return map;
	}	
	
	/* 공고 수정 */
	@PostMapping("/pbancUpdate")
	public String pbancUpdate(@ModelAttribute PbancVO pbancVO) {
		
	    log.info("pbancUpdate -> pbancVO : " + pbancVO);
	    int result = 0;
	    result += this.enterService.pbancUpdate(pbancVO);
	    result += this.enterService.favorUpdate(pbancVO);
	    result += this.enterService.recruitmentUpdate(pbancVO);
	    result += this.enterService.procssUpdate(pbancVO);
	    result += this.enterService.fileUpdate(pbancVO);
	    result += this.enterService.tpbizUpdate(pbancVO);//공고업종
	    result += this.enterService.addrUpdate(pbancVO);//공고지역
	    result += this.enterService.privilegedUpdate(pbancVO);//공고필수조건
	    result += this.enterService.preferUpdate(pbancVO);//공고필수조건
	    log.info("pbancVO.pbancImgFile: " + pbancVO.getPbancImgFile());
	    return "redirect:/enter/pbancDetail?pbancNo=" + pbancVO.getPbancNo();
	}
	
	//--------------------------------------------------------------------------------------------------------------------------
	
	/* 공고삭제 */
	@ResponseBody
	@PostMapping("/pbancDelete")
	public int pbancDelete(@RequestBody Map<String,Object>value) {
		String entId = value.get("entId").toString();
		String pbancNo = value.get("pbancNo").toString();
		log.info("pbancDelete -> entId : " + entId);
		log.info("pbancDelete -> pbancNo : " + pbancNo);
	    Map<String, Object> map = new HashMap<String, Object>();
		    map.put("entId", entId);
		    map.put("pbancNo", pbancNo);		
		int result = this.enterService.pbancDelete(map);
		return result;
	}
	
	//--------------------------------------------------------------------------------------------------------------------------
	
	/* 공고등록폼*/
	@GetMapping("/pbancInsert")
	public String pbancInsert(Model model, @RequestParam("entId") String entId) {

		EnterVO enterVO = this.enterService.getEntInfor(entId);
		EnterVO location = this.enterService.location(entId); //주소 정보를 가져옴
	    
        /*공통코드Select*/
        List<CodeVO> getRecruitmentCD = this.userMapper.codeSelect("RCCA");    //모집분야:모집경력   
        List<CodeVO> getRcritJbttlCD = this.userMapper.codeSelect("RCJB");     //모집분야:직급/직책  
        List<CodeVO> getPbancEduCD = this.userMapper.codeSelect("ACSE");       //공고:학력  
        List<CodeVO> getPbancGenCD = this.userMapper.codeSelect("PBGE");       //공고:성별   
        List<CodeVO> getPbancAgeCD = this.userMapper.codeSelect("PBAG");       //공고:연령   
        List<CodeVO> getPbancSalaryCD = this.userMapper.codeSelect("PBSA");    //공고:연봉/급여   
        List<CodeVO> getPbancWorkstleCD = this.userMapper.codeSelect("WOST");  //공고:근무형태  
        List<CodeVO> getPbancWorkDayCD = this.userMapper.codeSelect("WODA");   //공고:근무요일 
        List<CodeVO> getPbancWorkHrCD = this.userMapper.codeSelect("WOHR");    //공고:근무시간 
        List<CodeVO> getPbancRprsDtyCD = this.userMapper.codeSelect("INSE");   //공고:대표직무 
        List<CodeVO> getPbancRcptMthdCD = this.userMapper.codeSelect("RCMT");  //공고:지원접수방법
        List<CodeVO> getPbancAppofeFormCD = this.userMapper.codeSelect("APFO");//공고:지원서양식
        List<CodeVO> getProcssCD = this.userMapper.codeSelect("PRPR");         //전형절차:전형절차   
        List<CodeVO> getTpbizCD = this.userMapper.codeSelect("CRDT");          //업종
	    List<CodeVO> powkCdList = enterService.getpowkCdList();                // 공고 지역
	    
        model.addAttribute("getRecruitmentCD",getRecruitmentCD);     		   //모집경력   
        model.addAttribute("getRcritJbttlCD",getRcritJbttlCD);                 //직급/직책   
        model.addAttribute("getPbancEduCD",getPbancEduCD);	                   //공고:학력  
        model.addAttribute("getPbancGenCD",getPbancGenCD);	                   //공고:성별
        model.addAttribute("getPbancAgeCD",getPbancAgeCD);	                   //공고:연령
        model.addAttribute("getPbancSalaryCD",getPbancSalaryCD);	           //공고:연봉/급여    
        model.addAttribute("getPbancWorkstleCD",getPbancWorkstleCD);	       //공고:근무형태    
        model.addAttribute("getPbancWorkDayCD",getPbancWorkDayCD);	           //공고:근무요일     
        model.addAttribute("getPbancWorkHrCD",getPbancWorkHrCD);	           //공고:근무시간    
        model.addAttribute("getPbancRprsDtyCD",getPbancRprsDtyCD);	           //공고:대표직무     
        model.addAttribute("getPbancRcptMthdCD",getPbancRcptMthdCD);	       //공고:지원접수방법     
        model.addAttribute("getPbancAppofeFormCD",getPbancAppofeFormCD);	   //공고:지원서양식
        model.addAttribute("getProcssCD",getProcssCD);	                       //전형절차 		
        model.addAttribute("getTpbizCD",getTpbizCD);	                       //업종		
        model.addAttribute("powkCdList",powkCdList);	                       //공고지역		
		
		model.addAttribute("enterVO", enterVO);	
		model.addAttribute("location", location);	
		return "enter/pbancIUD/pbancInsert";
	}

	/* 공고등록실행 */
	@PostMapping("/pbancInsertPost")
	public String pbancInsertPost(@ModelAttribute PbancVO pbancVO, String entId
								) {
		log.info("pbancInsertPost -> pbancVO : " + pbancVO);
		int result = 0;
		result += this.enterService.pbancInsertPost1(pbancVO); //pbanc 등록
		String pbancNo = pbancVO.getPbancNo();
		log.info("pbancNo : "+pbancNo);
		pbancVO.setPbancNo(pbancNo);
		result += this.enterService.pbancInsertPost2(pbancVO); //favor 등록
		result += this.enterService.pbancInsertPost3(pbancVO); //recruitment 등록
		result += this.enterService.pbancInsertPost4(pbancVO); //procss 등록
		result += this.enterService.pbancInsertPost5(pbancVO); //file 등록
		result += this.enterService.pbancInsertPost6(pbancVO); //업종 등록
		result += this.enterService.pbancInsertPost7(pbancVO); //지역 등록
		result += this.enterService.pbancInsertPost8(pbancVO); //필수 조건 등록
		result += this.enterService.pbancInsertPost9(pbancVO); //우대 조건 등록
		return "redirect:/enter/pbanc?entId="+pbancVO.getEntId();
	}	

	/*공고 등록 -> 임시저장 버튼 실행*/
	@PostMapping("/tempPbancSavePost")
	public String tempPbancSavePost(@ModelAttribute PbancVO pbancVO) {
		log.info("tempPbancSavePost -> pbancVO : " + pbancVO);
		int result = 0;
		result += this.enterService.pbancSavePost1(pbancVO); //pbanc 임시저장
		String pbancNo = pbancVO.getPbancNo();
		log.info("pbancNo : "+pbancNo);
		pbancVO.setPbancNo(pbancNo);
		if(pbancVO.getFavorList()!=null) {
			result += this.enterService.pbancInsertPost2(pbancVO); //favor 등록			
		}
		if(pbancVO.getRcritNm()!=null || pbancVO.getRcritJbttlCd()!=null || pbancVO.getRcritTask()!=null 
			|| pbancVO.getRcritDept()!=null || pbancVO.getPbancCareerCd()!=null || pbancVO.getRcritCnt()!=null) {
			result += this.enterService.pbancInsertPost3(pbancVO); //recruitment 등록			
		}
		if(pbancVO.getProcssCd()!=null) {
			result += this.enterService.pbancInsertPost4(pbancVO); //procss 등록			
		}
		MultipartFile[] multipartFiles = pbancVO.getEntPbancFile();
		log.info("예>? : "+multipartFiles.length);
		log.info("뭐여 : ? : "+Arrays.toString(multipartFiles));
		if (multipartFiles == null || multipartFiles.length == 0 || multipartFiles[0].isEmpty()) {
		}else {			
			result += this.enterService.pbancInsertPost5(pbancVO); //file 등록				
		}
		if(pbancVO.getTpbizCdList()!=null) {
			result += this.enterService.pbancInsertPost6(pbancVO); //업종 등록			
		}
		if(pbancVO.getPowkList()!=null) {
			result += this.enterService.pbancInsertPost7(pbancVO); //지역 등록			
		}
		if(pbancVO.getRequiredCnList()!=null) {
			result += this.enterService.pbancInsertPost8(pbancVO); //필수 조건 등록			
		}
		if(pbancVO.getPreferCnList()!=null) {
			result += this.enterService.pbancInsertPost9(pbancVO); //우대 조건 등록					
		}
		
		return "enter/pbancIUD/pbancInsert";
	}

	/* 공고임시저장 등록실행 */
	@PostMapping("/pbancTempInsertPost")
	public String pbancTempInsertPost(@ModelAttribute PbancVO pbancVO, String entId
			) {
		log.info("pbancTempInsertPost -> pbancVO : " + pbancVO);
		int result = 0;
		result += this.enterService.pbancTempInsertPost1(pbancVO);
		result += this.enterService.favorUpdate(pbancVO);
		result += this.enterService.recruitmentUpdate(pbancVO);
		result += this.enterService.procssUpdate(pbancVO);
		result += this.enterService.fileUpdate(pbancVO);
		result += this.enterService.tpbizUpdate(pbancVO);//공고업종
		result += this.enterService.addrUpdate(pbancVO);//공고지역
		result += this.enterService.privilegedUpdate(pbancVO);//공고필수조건
		result += this.enterService.preferUpdate(pbancVO);//공고필수조건
		return "redirect:/enter/pbanc?entId="+pbancVO.getEntId();
	}	
	
	/*공고 임시저장 페이지 -> 임시저장 버튼 실행*/
	@PostMapping("/retempPbancSavePost")
	public String retempPbancSavePost(@ModelAttribute PbancVO pbancVO) {
		log.info("tempPbancSavePost -> pbancVO : " + pbancVO);
		int result = 0;
		result += this.enterService.retempPbancSavePost1(pbancVO); //pbanc 임시저장
	    result += this.enterService.favorUpdate(pbancVO);
	    result += this.enterService.recruitmentUpdate(pbancVO);
	    result += this.enterService.procssUpdate(pbancVO);
	    result += this.enterService.fileUpdate(pbancVO);
	    result += this.enterService.tpbizUpdate(pbancVO);//공고업종
	    result += this.enterService.addrUpdate(pbancVO);//공고지역
	    result += this.enterService.privilegedUpdate(pbancVO);//공고필수조건
	    result += this.enterService.preferUpdate(pbancVO);//공고필수조건
	    log.info("pbancVO.pbancImgFile: " + pbancVO.getPbancImgFile());	
		
		return "enter/pbancIUD/pbancInsert";
	}
	
	//--------------------------------------------------------------------------------------------------------------------------
	
	/* 공고관리 : 임시저장페이지 */
	@GetMapping("/tempPbanc")
	public ModelAndView tempPbanc(ModelAndView mav,
			@RequestParam(value = "entId", required = false, defaultValue = "") String entId,
			@RequestParam(value = "currentPage", required = false, defaultValue = "1") Integer currentPage,
			@RequestParam(value = "keywordInput", required = false, defaultValue = "") String keyword,
			@RequestParam(value = "dateInput", required = false, defaultValue = "") String date,
			@RequestParam(value = "gubun", required = false, defaultValue = "") String gubun,
			@RequestParam(value = "gubunDate", required = false, defaultValue = "") String gubunDate) {
		
		/* 페이징처리 */
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("entId", entId);
		map.put("currentPage", currentPage);
		map.put("keyword", keyword);
		map.put("date", date);
		map.put("gubun", gubun);
		map.put("gubunDate", gubunDate);
		
		int count = this.enterServiceS.pbCount(entId); //공고 총 개수 구하기
		int total = this.enterService.getTotalTempPbanc(map); // 전체 행의 수
		mav.addObject("total", total);
		List<PbancVO> tempPbanc = enterService.tempPbanc(map);// 공고 리스트 
		
		log.info("list->map : " + map);
		log.info("tempPbanc : " + tempPbanc);
		
		// 페이지네이션 객체
		ArticlePage<PbancVO> articlePage = new ArticlePage<PbancVO>(total, currentPage, 5, tempPbanc, map);
		
		mav.addObject("count", count); //공고 총 개수 구하기
		mav.addObject("articlePage", articlePage); //페이지네이션 + 공고리스트
		mav.addObject("tempPbanc", tempPbanc); //공고리스트
		
		mav.setViewName("enter/pbancPage/pbancList/pbancFolder/tempPbanc"); // 뷰리졸버
		return mav;
	}
	
	/* 공고임시저장 페이지 -> 상세보기 -> 임시저장or등록폼*/
	@GetMapping("/pbancTempInsert")
	public String pbancTempInsert(Model model, @RequestParam("entId") String entId
									,@RequestParam("pbancNo") String pbancNo) {

		EnterVO enterVO = this.enterService.getEntInfor(entId);
		EnterVO location = this.enterService.location(entId); //주소 정보를 가져옴
	    
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("entId", entId);
		map.put("pbancNo", pbancNo);
		
		PbancVO pbancDetailList = enterService.pbancDetailList(map); 
		String tpbizCd = pbancDetailList.getTpbizCd();
		if(tpbizCd != null) {			
	    String[] tpbizCdArray = tpbizCd.split(",");
	    List<String> tpbizCdList = Arrays.asList(tpbizCdArray);
	    log.info("tpbizCdList : " + tpbizCdList);
	    model.addAttribute("tpbizCdList", tpbizCdList); 					   //공고업종
		}
	    
	    
	    // 공고 복지 및 혜택 
	    String favorCn = pbancDetailList.getFavorCn();
	    if(favorCn!=null) {
	    String[] favorArray = favorCn.split(",");
	    List<String> favorList = Arrays.asList(favorArray);
	    model.addAttribute("favorList", favorList); 					   	   //공고지역
	    }

	    // 공고 지역 
	    String powkCd = pbancDetailList.getPowkNm();
	    if(powkCd != null) {
	    String[] powkArray = powkCd.split(",");
	    List<String> powkList = Arrays.asList(powkArray);
	    model.addAttribute("powkList", powkList); 					   		   //공고지역
	    }
	    
	    // 필수조건
	    String requiredCn = pbancDetailList.getRequiredCn();
	    if(requiredCn!=null) {
	    String[] requiredArray = requiredCn.split(",");
	    List<String> requiredList = Arrays.asList(requiredArray);	
	    model.addAttribute("requiredList", requiredList); 					   	   //공고지역
	    }
	    // 우대조건
	    String preferCn = pbancDetailList.getPreferCn();
	    if(preferCn!=null) {
	    String[] preferArray = preferCn.split(",");
	    List<String> preferList = Arrays.asList(preferArray);
	    model.addAttribute("preferList", preferList);
	    }
	   
        /*공통코드Select*/
        List<CodeVO> getRecruitmentCD = this.userMapper.codeSelect("RCCA");    //모집분야:모집경력   
        List<CodeVO> getRcritJbttlCD = this.userMapper.codeSelect("RCJB");     //모집분야:직급/직책  
        List<CodeVO> getPbancEduCD = this.userMapper.codeSelect("ACSE");       //공고:학력  
        List<CodeVO> getPbancGenCD = this.userMapper.codeSelect("PBGE");       //공고:성별   
        List<CodeVO> getPbancAgeCD = this.userMapper.codeSelect("PBAG");       //공고:연령   
        List<CodeVO> getPbancSalaryCD = this.userMapper.codeSelect("PBSA");    //공고:연봉/급여   
        List<CodeVO> getPbancWorkstleCD = this.userMapper.codeSelect("WOST");  //공고:근무형태  
        List<CodeVO> getPbancWorkDayCD = this.userMapper.codeSelect("WODA");   //공고:근무요일 
        List<CodeVO> getPbancWorkHrCD = this.userMapper.codeSelect("WOHR");    //공고:근무시간 
        List<CodeVO> getPbancRprsDtyCD = this.userMapper.codeSelect("INSE");   //공고:대표직무 
        List<CodeVO> getPbancRcptMthdCD = this.userMapper.codeSelect("RCMT");  //공고:지원접수방법
        List<CodeVO> getPbancAppofeFormCD = this.userMapper.codeSelect("APFO");//공고:지원서양식
        List<CodeVO> getProcssCD = this.userMapper.codeSelect("PRPR");         //전형절차:전형절차   
        List<CodeVO> getTpbizCD = this.userMapper.codeSelect("CRDT");          //업종
	    List<CodeVO> powkCdList = enterService.getpowkCdList();                // 공고 지역
	    
        model.addAttribute("getRecruitmentCD",getRecruitmentCD);     		   //모집경력   
        model.addAttribute("getRcritJbttlCD",getRcritJbttlCD);                 //직급/직책   
        model.addAttribute("getPbancEduCD",getPbancEduCD);	                   //공고:학력  
        model.addAttribute("getPbancGenCD",getPbancGenCD);	                   //공고:성별
        model.addAttribute("getPbancAgeCD",getPbancAgeCD);	                   //공고:연령
        model.addAttribute("getPbancSalaryCD",getPbancSalaryCD);	           //공고:연봉/급여    
        model.addAttribute("getPbancWorkstleCD",getPbancWorkstleCD);	       //공고:근무형태    
        model.addAttribute("getPbancWorkDayCD",getPbancWorkDayCD);	           //공고:근무요일     
        model.addAttribute("getPbancWorkHrCD",getPbancWorkHrCD);	           //공고:근무시간    
        model.addAttribute("getPbancRprsDtyCD",getPbancRprsDtyCD);	           //공고:대표직무     
        model.addAttribute("getPbancRcptMthdCD",getPbancRcptMthdCD);	       //공고:지원접수방법     
        model.addAttribute("getPbancAppofeFormCD",getPbancAppofeFormCD);	   //공고:지원서양식
        model.addAttribute("getProcssCD",getProcssCD);	                       //전형절차 		
        model.addAttribute("getTpbizCD",getTpbizCD);	                       //업종		
        model.addAttribute("powkCdList",powkCdList);	                       //공고지역		
		
       
        
        
        
		model.addAttribute("enterVO", enterVO);	
		model.addAttribute("location", location);	
		model.addAttribute("pbancDetailList", pbancDetailList);	
		return "enter/pbancIUD/pbancTempInsert";
	}	
	
	//--------------------------------------------------------------------------------------------------------------------------
	
	/* 기업 지원자 관리 - 지원자 리스트 */
	@GetMapping("/listAplct")
	public ModelAndView listAplct(ModelAndView mav,
			@RequestParam(value = "entId", required = false, defaultValue = "") String entId,
			@RequestParam(value = "currentPage", required = false, defaultValue = "1") Integer currentPage,
			@RequestParam(value = "keywordInput", required = false, defaultValue = "") String keyword,
			@RequestParam(value = "dateInput", required = false, defaultValue = "") String date,
			@RequestParam(value = "gubun", required = false, defaultValue = "") String gubun,
			@RequestParam(value = "gubunSt", required = false, defaultValue = "") String gubunSt,
			@RequestParam(value = "gubunPbanc", required = false, defaultValue = "") String gubunPbanc,
			@RequestParam(value = "rsmNo", required = false, defaultValue = "") String rsmNo
			) {
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("currentPage", currentPage);
		map.put("entId", entId);
		map.put("keyword", keyword);
		map.put("date", date);
		map.put("gubun", gubun);
		map.put("gubunSt", gubunSt);
		gubunPbanc = gubunPbanc.replace("...", "");
		map.put("gubunPbanc", gubunPbanc);
		map.put("rsmNo", rsmNo);
		
		List<CodeVO> skillList = enterService.getSkillList(map); // 스킬 목록 가져오기
		List<ApplicantVO> aplctList = enterService.aplctList(map); // 지원자 목록
		List<PbancVO> entPbancList = enterService.entPbancList(map); // 공고꺼내기
		List<ProposalVO> proposalList = this.enterService.proposalList(map); //제안 아이디 꺼내기
		
		List<String> proposalNameList = new ArrayList<>();
		for (ProposalVO proposalVO : proposalList) {
			proposalNameList.add(proposalVO.getMbrId());
		}
		log.info("proposalNameList : " + proposalNameList);
		log.info("proposalNameListString : " + proposalNameList.toString());
		String proposalName = proposalNameList.toString();
		log.info("proposalName : " + proposalName);
		
		// 전체 행의 수
		int total = this.enterService.getTotalListAplct(map); //총지원자수
		
		// 페이지네이션 객체
		ArticlePage<ApplicantVO> articlePage = new ArticlePage<ApplicantVO>(total, currentPage, 5, aplctList, map);
	
		mav.addObject("total", total); //총지원자수
		mav.addObject("articlePage", articlePage);//페이지네이션 + 지원자리스트
		mav.addObject("skillList", skillList); // 스킬 목록 가져오기
		mav.addObject("aplctList", aplctList);// 지원자 목록
		mav.addObject("entPbancList", entPbancList);// 공고꺼내기
		mav.addObject("proposalName", proposalName);//제안 아이디 꺼내기
		// 뷰 리졸버
		mav.setViewName("enter/aplctPage/aplctList/aplctFolder/aplct/listAplct");

		return mav;
	}

	/* 지원자 상태 업데이트 */
	@ResponseBody
	@PostMapping("/updateAplctSt")
	public int updateAplctSt(@RequestParam("mbrId") String mbrId, @RequestParam("status") String status,
							 @RequestParam("pbancNo") String pbancNo,
							 @RequestParam("entId") String entId,
							 @RequestParam("intrvwCd")String intrvwCd) {

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("mbrId", mbrId);
		map.put("status", status); // 기업 아이디
		map.put("pbancNo", pbancNo);
		map.put("entId", entId);
		map.put("intrvwCd", intrvwCd);
		
		int result = this.enterService.updateAplctSt(map); 
		
		
		log.info("mbrId", mbrId);
		log.info("result -> ", result);

		return result;
	}

	/* 지원자리스트 엑셀 저장 
	 * excelAplct.xls 요청을 처리하는 메소드 */
	@RequestMapping(value = "excelAplct.xls", method = RequestMethod.GET)
	public void excelDownloadAplct(HttpServletResponse response,
								   @RequestParam(value = "entId", required = false, defaultValue = "") String entId) throws IOException {
		
		Map<String, Object> map = new HashMap<>();
		map.put("entId", entId);

		response.setContentType("application/vnd.ms-excel");
		response.setHeader("Content-Disposition", "attachment; filename=\"Aplct_list.xls\"");

		try (Workbook workbook = new HSSFWorkbook(); OutputStream out = response.getOutputStream()) {

			Sheet sheet = workbook.createSheet("Aplct List");

			// 헤더 작성
			String[] headers = { "지원자", "신입/경력", "이력서/자소서", "스킬", "공고명", "마감일", "지원 일자", "면접 일자", "지원자 상태" };
			Row headerRow = sheet.createRow(0);
			for (int i = 0; i < headers.length; i++) {
				Cell cell = headerRow.createCell(i);
				cell.setCellValue(headers[i]);
			}

			List<ApplicantVO> AplctListExcel = enterService.AplctListExcel(map);

			// 데이터 작성
			int rowIndex = 1;
			for (ApplicantVO aplct : AplctListExcel) {
				Row row = sheet.createRow(rowIndex++);
				row.createCell(0).setCellValue(aplct.getMbrNm()); // 지원자
				row.createCell(1).setCellValue(aplct.getRsmCareerCd()); // 신입/경력
				row.createCell(2).setCellValue(aplct.getRsmTtl()); // 이력서/자소서
				row.createCell(3).setCellValue(aplct.getSkCd()); // 스킬
				row.createCell(4).setCellValue(aplct.getPbancTtl()); // 공고명
				row.createCell(5).setCellValue(aplct.getPbancDdlnDt()); // 마감일
				row.createCell(6).setCellValue(aplct.getAplctAppymds()); // 지원일
				row.createCell(7).setCellValue(aplct.getIntrvwYmd()); // 면접일
				row.createCell(8).setCellValue(aplct.getAplctPrcsStatCdNm()); // 면접상태
			}

			// 엑셀 파일을 response의 OutputStream에 씀
			workbook.write(out);
			out.flush();
		}
	}

	//--------------------------------------------------------------------------------------------------------------------------
	
	/* 스카우트 제안 페이지 */
	/// enter/scout?entId=test01&gubun=RCCA02
	@GetMapping("/scout")
	public ModelAndView scout(ModelAndView mav,
			@RequestParam(value = "entId", required = false, defaultValue = "") String entId,
			@RequestParam(value = "currentPage", required = false, defaultValue = "1") Integer currentPage,
			@RequestParam(value = "keywordInput", required = false, defaultValue = "") String keyword,
			@RequestParam(value = "dateInput", required = false, defaultValue = "") String date,
			@RequestParam(value = "gubun", required = false, defaultValue = "") String gubun) {

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("entId", entId); // 기업 아이디
		map.put("currentPage", currentPage);
		map.put("keyword", keyword);
		map.put("date", date);
		map.put("gubun", gubun);// 신입/경력 구분

		log.info("list->map : " + map);

		// 지원자 목록
		List<ProposalVO> scoutList = enterService.scoutList(map);
		log.info("scoutList : "+ scoutList);
		mav.addObject("scoutList", scoutList);

		// 전체 행의 수(조건이 있다면 조건도 포함하여야 함)
		int total = this.enterService.getTotal(map);
		log.info("total : " + total);

		// 페이지네이션 객체
		ArticlePage<ProposalVO> articlePage = new ArticlePage<ProposalVO>(total, currentPage, 5, scoutList, map);
		mav.addObject("articlePage", articlePage);
	
		mav.addObject("total", total); //총제안수
		// 뷰 리졸버
		mav.setViewName("enter/scoutPage/scout");

		return mav;
	}

	/* 스카우트 제안 엑셀 저장 */
	// excel.xls 요청을 처리하는 메소드
	@RequestMapping(value = "excel.xls", method = RequestMethod.GET)
	public void excelDownload(HttpServletResponse response,
			@RequestParam(value = "entId", required = false, defaultValue = "") String entId) throws IOException {
		response.setContentType("application/vnd.ms-excel");
		response.setHeader("Content-Disposition", "attachment; filename=\"scout_list.xls\"");

		try (Workbook workbook = new HSSFWorkbook(); OutputStream out = response.getOutputStream()) {

			Sheet sheet = workbook.createSheet("Scout List");

			// 헤더 작성
			String[] headers = { "제안 인재", "나이", "신입/경력", "제안 제목", "제안 일자", "제안 공고 제목", "제안 내용", "제안 첨부파일명" };
			Row headerRow = sheet.createRow(0);
			for (int i = 0; i < headers.length; i++) {
				Cell cell = headerRow.createCell(i);
				cell.setCellValue(headers[i]);
			}

			Map<String, Object> map = new HashMap<>();
			map.put("entId", entId);

			List<ProposalVO> scoutListExcel = enterService.scoutListExcel(map);

			// 데이터 작성
			int rowIndex = 1;
			for (ProposalVO scout : scoutListExcel) {
				Row row = sheet.createRow(rowIndex++);
				row.createCell(0).setCellValue(scout.getMbrNm()); // 이름
				row.createCell(1).setCellValue(scout.getMbrBrdt() == null ? "" : scout.getMbrBrdt().toString()); // 나이
				row.createCell(2).setCellValue(scout.getRsmCareerCd()); // 신입/경력
				row.createCell(3).setCellValue(scout.getPropseTtl()); // 제안 제목
				row.createCell(4).setCellValue(scout.getPropseDates() == null ? "" : scout.getPropseDates().toString()); // 제안
																															// 일자
				row.createCell(5).setCellValue(scout.getPropseTtl()); // 제안 공고 제목
				row.createCell(6).setCellValue(scout.getPropseCn()); // 제안 내용
				row.createCell(7).setCellValue(scout.getPropseFile() == null ? "" : scout.getPropseFile()); // 제안 첨부파일명
			}

			// 엑셀 파일을 response의 OutputStream에 씀
			workbook.write(out);
			out.flush();
		}
	}

	// 스카우트 제안 메일
	@PostMapping("/sendScoutEmail")
	public String sendScoutEmail(
				@RequestParam("title") String title, 
				@RequestParam(value = "jobPost", required = false, defaultValue = "") String jobPost,
				@RequestParam("content") String content, 
				@RequestParam("recipientEmail") String recipientEmail,
				@RequestParam("mbrId") String mbrId,
				@RequestParam(value = "entId", required = false, defaultValue = "") String entId,
				@RequestParam("file") MultipartFile[] file) {
		// 이메일 제목과 내용 설정
		String subject = "스카우트 제안 : " + title;
		
		String message = "";
		if(jobPost.equals("")) {
			message = "제안 내용 : " + content;
		}else {
			message = "제안 공고명 : " + jobPost + "\n\n제안 내용 : " + content;
		}

		log.info("subject"+subject);
		log.info("message"+message);

		Map<String, Object> map = new HashMap<>();
		map.put("subject", subject);
		map.put("message", message);
		map.put("title", title);
		map.put("jobPost",jobPost);
		map.put("content", content);
		map.put("recipientEmail", recipientEmail);
		map.put("mbrId", mbrId);
		map.put("entId", entId);
		map.put("file", file);

		try {
			// recipientEmail을 사용하여 이메일 전송
			emailService.sendEmail(map);
			return "enter/scoutPage/scout";
		} catch (Exception e) {
			e.printStackTrace();
			return "enter/scoutPage/scout" + e.getMessage();
		}
	}


}
