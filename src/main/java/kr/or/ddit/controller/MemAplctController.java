package kr.or.ddit.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import kr.or.ddit.mapper.UserMapper;
import kr.or.ddit.security.CustomUser;
import kr.or.ddit.service.MemAplctService;
import kr.or.ddit.util.ArticlePage;
import kr.or.ddit.vo.ApplicantVO;
import kr.or.ddit.vo.CodeVO;
import kr.or.ddit.vo.NotificationVO;
import kr.or.ddit.vo.PbancVO;
import kr.or.ddit.vo.ScrapVO;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/member")
public class MemAplctController {

    @Inject
    MemAplctService memAplctService;
    
    @Inject
    UserMapper userMapper;
    

    // 로그인한 사용자의 mbrId를 가져오는 메서드
    private String getLoggedInMbrId() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        CustomUser userDetails = (CustomUser) authentication.getPrincipal();
        return userDetails.getUsername(); // CustomUser에 mbrId 필드가 있다고 가정
    }

    // 입사 지원 목록
    @GetMapping("/aplctList")
    public ModelAndView aplctList(ModelAndView mav,
    		@RequestParam(value="currentPage",required=false, defaultValue="1")Integer currentPage,
    		@RequestParam(value="state",required=false, defaultValue="") String state,
    		@RequestParam(value="dateInput1",required=false, defaultValue="") String dateInput1,
    		@RequestParam(value="dateInput2",required=false, defaultValue="") String dateInput2,
    		@RequestParam(value="keywordInput",required=false, defaultValue="")String keywordInput) {
        String mbrId = getLoggedInMbrId(); // 로그인된 사용자 ID
        Map<String, Object> map = new HashMap<String,Object>();
        map.put("mbrId", mbrId);
        map.put("currentPage", currentPage);
        map.put("keywordInput", keywordInput);
        map.put("dateInput1", dateInput1);
        map.put("dateInput2", dateInput2);
        map.put("state", state);
        // 입사 지원 목록
        List<ApplicantVO> aplctVOList = this.memAplctService.aplctList(map);
       
        // 지원 상태 공통 코드
        List<CodeVO> apstVOList = userMapper.codeSelect("APST");
        
        // 전체 행의 수
        int total = this.memAplctService.getTotal(map);
        // 상태 미평가 행의 수
        int getNotTotal = this.memAplctService.getNotTotal(mbrId);
	    // 상태 서류합격 행의 수
        int getDocTotal = this.memAplctService.getDocTotal(mbrId);
	    // 상태 최종합격 행의 수
        int getFinTotal = this.memAplctService.getFinTotal(mbrId);
        // 상태 불합격 행의 수
        int getBadTotal = this.memAplctService.getBadTotal(mbrId);
        
        // 페이지네이션 객체
        ArticlePage<ApplicantVO> articlePage = new ArticlePage<ApplicantVO>(total, currentPage, 5, aplctVOList, map);
        
        mav.addObject("mbrId", mbrId);
        mav.addObject("aplctVOList", aplctVOList);
        mav.addObject("articlePage", articlePage);
        mav.addObject("apstVOList", apstVOList);
        mav.addObject("getNotTotal", getNotTotal);
        mav.addObject("getDocTotal", getDocTotal);
        mav.addObject("getFinTotal", getFinTotal);
        mav.addObject("getBadTotal", getBadTotal);
        
        // 뷰 리졸버
        mav.setViewName("member/mypage/aplctList");
        
        
        return mav;
    }

    // 입사 지원 관리
    @GetMapping("/aplctManage")
    public ModelAndView aplctManage(ModelAndView mav,
    		@RequestParam(value="currentPage",required=false, defaultValue="1")Integer currentPage,
    		@RequestParam(value="dateInput1",required=false, defaultValue="") String dateInput1,
    		@RequestParam(value="dateInput2",required=false, defaultValue="") String dateInput2,
    		@RequestParam(value="keywordInput",required=false, defaultValue="")String keywordInput) {
        String mbrId = getLoggedInMbrId(); // 로그인된 사용자 ID
        Map<String, Object> map = new HashMap<String,Object>();
        map.put("mbrId", mbrId);
        map.put("currentPage", currentPage);
        map.put("keywordInput", keywordInput);
        map.put("dateInput1", dateInput1);
        map.put("dateInput2", dateInput2);
        
        // 입사 지원 목록
        List<ApplicantVO> aplctVOList = this.memAplctService.aplctManage(map);
        // 입사 지원 취소 항목
        List<CodeVO> cancelList = this.memAplctService.cancelList();

        // 전체 행의 수
        int total = this.memAplctService.getManTotal(map);
        
        // 페이지네이션 객체
        ArticlePage<ApplicantVO> articlePage = new ArticlePage<ApplicantVO>(total, currentPage, 7, aplctVOList, map);
        
        
        mav.addObject("mbrId", mbrId);
        mav.addObject("cancelList",cancelList);
        mav.addObject("articlePage", articlePage);
        // 뷰 리졸버
        mav.setViewName("member/mypage/aplctManage");
        
        return mav;
    }
    
    // 입사 지원
    @ResponseBody
    @PostMapping("/aplctAdd")
    public int aplctAdd(@ModelAttribute ApplicantVO applicantVO) {
    	
    	Map<String, Object> map = new HashMap<String, Object>();
    	map.put("mbrId", applicantVO.getMbrId());
    	map.put("pbancNo", applicantVO.getPbancNo());
    	
    	// 중복 체크
    	ApplicantVO aplctChk = this.memAplctService.aplctChk(map);
    	if (aplctChk != null) {
           
            log.info("이미 지원한 공고입니다.");
            return -1;
        }
    	
    	int result = this.memAplctService.aplctAdd(applicantVO);
    	log.info("result->aplctAdd"+result);
    	
    	return result;
    }
    
    // 특정 공고 입사 지원 취소 사유 update
    @PostMapping("/aplctDelete")
    @ResponseBody
    public int aplctDelete(@RequestBody Map<String, Object> map) {
    	int result = this.memAplctService.aplctDelete(map);
    	
    	return result;
    }
    
    // 내가 스크랩한 공고 조회
    @GetMapping("/scrap")
    public ModelAndView scrap(ModelAndView mav,
    						@RequestParam(value="currentPage", required=false, defaultValue = "1") Integer currentPage,
    						@RequestParam(value="state", required=false, defaultValue = "") String state,
    						@RequestParam(value="keywordInput", required=false, defaultValue = "") String keywordInput) {
    	String mbrId = getLoggedInMbrId();
    	
        Map<String, Object> map = new HashMap<String,Object>();
        map.put("mbrId", mbrId);
        map.put("currentPage", currentPage);
        map.put("state", state);
        map.put("keywordInput", keywordInput);
        
        List<PbancVO> scrapVOList = this.memAplctService.scrapList(map);
        log.info("scrapVOList :" + scrapVOList);
        int total = this.memAplctService.getScrapTotal(map);
        
        // 페이지네이션 객체
        ArticlePage<PbancVO> articlePage = new ArticlePage<PbancVO>(total, currentPage, 5, scrapVOList, map);
        
        mav.addObject("mbrId", mbrId);
        mav.addObject("articlePage", articlePage);
        mav.addObject("scrapVOList",scrapVOList);
        
        mav.setViewName("member/mypage/scrap");
        
        return mav;
    	
    }
    
    // 공고 스크랩 추가
    @ResponseBody
    @PostMapping("/addScrap")
    public int addScrap(@RequestBody ScrapVO scrapVO) {
    	
    	int result = this.memAplctService.addScrap(scrapVO);
    	log.info("result->addScrap : " + result);
    	
    	return result;
    }
    
    
    // 스크랩한 공고 삭제
    @ResponseBody
    @PostMapping("/delScrap")
    public int delScrap(@RequestBody Map<String, Object> map) {
    	
    	int result = this.memAplctService.delScrap(map);
    	log.info("result->delScrap : " + result);
    	
    	return result;
    	
    }
  
    
}
