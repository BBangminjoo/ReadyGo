package kr.or.ddit.controller;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import kr.or.ddit.service.PbancService;
import kr.or.ddit.util.ArticlePage;
import kr.or.ddit.vo.CodeVO;
import kr.or.ddit.vo.PbancVO;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/common")
public class PbancController {
	
	@Autowired
	PbancService pbancService;
	
	// /common/pbancList?selCity=WRGN04-001%2CWRGN04-002%2CWRGN04-003&selJob=INSE20%2CINSE25&selKeyword=2024#
	@RequestMapping(value="/pbancList",method=RequestMethod.GET)
	public ModelAndView list(ModelAndView mav,
			@RequestParam(value="currentPage",required=false,defaultValue="1") int currentPage,
			@RequestParam(value="order",required=false,defaultValue="pbancNo") String order,
			@RequestParam(value="selCity", required=false) String[] selCity, 
		    @RequestParam(value="selJob", required=false) String[] selJob, 
		    @RequestParam(value="selKeyword", required=false,defaultValue="") String keyword 
			) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("currentPage", currentPage);
		map.put("order", order);
		log.info("list->map : " + map);
		
		// 선택된 도시와 직업 로그 출력
	    if (selCity != null) {
	    	//Selected Cities: [WRGN04-001, WRGN04-002, WRGN04-003]
	        log.info("Selected Cities: " + Arrays.toString(selCity)); // 선택된 도시 출력
	    } else {
	        selCity = new String[] {}; // 모든 도시를 사용하기 위해 빈 배열로 설정
	    }
	    
	    if (selJob != null) {
	    	//Selected Jobs: [INSE20, INSE25]
	        log.info("Selected Jobs: " + Arrays.toString(selJob)); // 선택된 직업 출력
	    } else {
	        selJob = new String[] {}; // 모든 직업을 사용하기 위해 빈 배열로 설정
	    }
	    
	    // 2024
	    log.info("keyword: " + keyword); // 선택된 키워드 출력
	    
	    // 선택된 도시와 직업을 map에 추가
	    map.put("selCity", Arrays.asList(selCity)); // List로 변환하여 추가
	    map.put("selJob", Arrays.asList(selJob)); // List로 변환하여 추가
	    map.put("keyword", keyword); // 키워드 추가
		
	    //*******map : {currentPage=1, keyword=, selCity=[WRGN04-001, WRGN04-002, WRGN04-003], selJob=[INSE02, INSE03], order=pbancNo}
	    log.info("map : " + map);
	    
	    //*** 목록에 보여질 리스트
		List<PbancVO> pbancVOList = this.pbancService.list(map);
		List<CodeVO> regionList = this.pbancService.regionList();
		List<CodeVO> jobList = this.pbancService.jobList();
		log.info("pbancList : " + pbancVOList);
		log.info("regionList : " + regionList);
		log.info("jobList : " + jobList);
		

		int total = this.pbancService.getTotal(map);
		log.info("list->total : " + total);
		
		ArticlePage<PbancVO> articlePage = 
			new ArticlePage<PbancVO>(total, currentPage, 10, pbancVOList);
		log.info("articlePage : " + articlePage);

		mav.addObject("articlePage", articlePage);
		mav.addObject("regionList", regionList);
		mav.addObject("jobList", jobList);
		mav.addObject("total", total);
		mav.addObject("selCity", Arrays.asList(selCity));
		mav.addObject("selJob", Arrays.asList(selJob));
		mav.addObject("keyword", keyword);
		
		// /WEB-INF/view/common/pbancList.jsp
		mav.setViewName("common/pbancList");
		
		return mav;
	}
	
	// AJAX 요청 처리 메서드
    @GetMapping("/cityList")
    public ResponseEntity<List<CodeVO>> getCityList(
            @RequestParam(value = "comCode", required = false, defaultValue = "WRGN01") String comCode) {
        
        List<CodeVO> cityList = this.pbancService.cityList(comCode);
		log.info("cityList : " + cityList);
        return ResponseEntity.ok(cityList);
    }
	
}