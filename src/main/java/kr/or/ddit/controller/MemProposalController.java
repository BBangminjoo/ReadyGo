package kr.or.ddit.controller;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import kr.or.ddit.security.CustomUser;
import kr.or.ddit.service.MemProposalService;
import kr.or.ddit.util.ArticlePage;
import kr.or.ddit.vo.ProposalVO;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/member")
public class MemProposalController {

    @Inject
    MemProposalService memProposalService;

    // 로그인한 사용자의 mbrId를 가져오는 메서드
    private String getLoggedInMbrId() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        CustomUser userDetails = (CustomUser) authentication.getPrincipal();
        return userDetails.getUsername(); // CustomUser에 mbrId 필드가 있다고 가정
    }

    @GetMapping("/memPro")
    public ModelAndView memProList(ModelAndView mav,
    		@RequestParam(value="currentPage",required=false, defaultValue="1")Integer currentPage,
    		@RequestParam(value="dateInput1",required=false, defaultValue="") String dateInput1,
    		@RequestParam(value="dateInput2",required=false, defaultValue="") String dateInput2,
    		@RequestParam(value="keywordInput",required=false, defaultValue="")String keywordInput) {
    	String mbrId = getLoggedInMbrId(); // 로그인된 사용자 ID
    	
//    	SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
//        Date DateStart = null; // 초기화
//        Date DateEnd = null; // 초기화

    	Map<String, Object> map = new HashMap<String,Object>();
        map.put("mbrId", mbrId);
        map.put("currentPage", currentPage);
        map.put("keywordInput", keywordInput);
        map.put("dateInput1", dateInput1);
        map.put("dateInput2", dateInput2);
        
        // 받은 제안 목록
        List<ProposalVO> memProVOList = this.memProposalService.memProList(map);
        
        // 전체 행의 수
        int total = this.memProposalService.getTotal(map);
        
       // 페이지네이션 객체
        ArticlePage<ProposalVO> articlePage = new ArticlePage<ProposalVO>(total, currentPage, 7, memProVOList, map);
        
        mav.addObject("mbrId",mbrId);
        mav.addObject("articlePage", articlePage);
        // 뷰 리졸버
        mav.setViewName("member/mypage/memPro");
    	
    	return mav;
    	
    }

    
    
}
