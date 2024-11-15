package kr.or.ddit.mapper;

import java.util.List;
import java.util.Map;

import kr.or.ddit.vo.PbancVO;
import kr.or.ddit.vo.ScheduleVO;
import kr.or.ddit.vo.ScrapVO;

public interface CalendarMapper {
	
	//스크랩 목록
	List<PbancVO> scrapList(Map<String, Object> map);
	
	//캘린더 표시정보(스크랩)
	List<PbancVO> calendarList(String mbrId);
	
	//일정 목록
	List<ScheduleVO> scheduleList(Map<String, Object> map);
	
	//캘린더 표시정보(일정)
	List<ScheduleVO> calendarList2(String mbrId);
	
	//일정 등록
	int scheduleInsert(Map<String, Object> map);
	
	//일정 삭제
	int deleteEvent(Map<String, Object> map);
	


}
