package kr.or.ddit.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import kr.or.ddit.service.CommonListService;
import kr.or.ddit.util.ArticlePage;
import kr.or.ddit.vo.EnterVO;
import kr.or.ddit.vo.PbancVO;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/common")
public class CommonListController {
	@Autowired
	CommonListService commonListService;
	
	// /common/pbancList?selCity=WRGN04-001%2CWRGN04-002%2CWRGN04-003&selJob=INSE20%2CINSE25&selKeyword=2024#
	@RequestMapping(value="/commonList",method=RequestMethod.GET)
	public ModelAndView list(ModelAndView mav,
			@RequestParam(value="currentPage",required=false,defaultValue="1") int currentPage,
			@RequestParam(value="order",required=false,defaultValue="") String order,
		    @RequestParam(value="keyword", required=false,defaultValue="") String keyword 
			) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("currentPage", currentPage);
		map.put("order", order);
	    
	    // 2024
	    log.info("Keyword: " + keyword); // 선택된 키워드 출력
	    map.put("keyword", keyword); // 키워드 추가
		
	    //*******map : {currentPage=1, keyword=, order=pbancNo}
	    log.info("map : " + map);
	    
	    //*** 채용정보 리스트
		List<PbancVO> pbancVOList = this.commonListService.pbancList(map);
		log.info("pbancList : " + pbancVOList);
		
		//*** 채용정보 총 행 갯수
		int pbancTotal = this.commonListService.getPbancTotal(map);
		log.info("list->pbancTotal : " + pbancTotal);
		
		//채용정보 페이징
		ArticlePage<PbancVO> articlePage = 
			new ArticlePage<PbancVO>(pbancTotal, currentPage, 10, pbancVOList);
		log.info("articlePage : " + articlePage);
			
		mav.addObject("articlePage", articlePage);
		mav.addObject("keyword", keyword);
		mav.addObject("pbancTotal", pbancTotal);

		// /WEB-INF/view/common/commonList.jsp
		mav.setViewName("common/commonList");
		
		return mav;
	}
	
	@RequestMapping(value="/commonList2",method=RequestMethod.GET)
	public ModelAndView list2(ModelAndView mav,
			@RequestParam(value="currentPage",required=false,defaultValue="1") int currentPage,
			@RequestParam(value="order",required=false,defaultValue="") String order,
		    @RequestParam(value="keyword", required=false,defaultValue="") String keyword 
			) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("currentPage", currentPage);
		map.put("order", order);
	    
	    // 2024
	    log.info("Keyword: " + keyword); // 선택된 키워드 출력
	    map.put("keyword", keyword); // 키워드 추가
		
	    //*******map : {currentPage=1, keyword=, order=pbancNo}
	    log.info("map : " + map);
		
		 //*** 기업정보 리스트
		List<EnterVO> enterVOList = this.commonListService.enterList(map);
		log.info("enterVOList : " + enterVOList);
		
		//*** 기업정보 총 행 갯수
		int enterTotal = this.commonListService.getEnterTotal(map);
		log.info("list->enterTotal : " + enterTotal);
		
		//기업정보 페이징
		ArticlePage<EnterVO> articlePage = 
			new ArticlePage<EnterVO>(enterTotal, currentPage, 10, enterVOList);
		log.info("articlePage : " + articlePage);
			
		mav.addObject("articlePage", articlePage);
		mav.addObject("keyword", keyword);
		mav.addObject("enterTotal", enterTotal);

		// /WEB-INF/view/common/commonList2.jsp
		mav.setViewName("common/commonList2");
		
		return mav;
	}
}
