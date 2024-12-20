package kr.or.ddit.service.impl;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mapper.EnterListMapper;
import kr.or.ddit.service.EnterListService;
import kr.or.ddit.vo.CodeVO;
import kr.or.ddit.vo.EnterVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class EnterListServiceImpl implements EnterListService {
	
	@Autowired
	private EnterListMapper enterListMapper;
	
	//기업리스트
	@Override
	public List<EnterVO> list(Map<String, Object> map) {
		return this.enterListMapper.list(map);
	}

	//전체 행 갯수
	@Override
	public int getTotal(Map<String, Object> map) {
		return this.enterListMapper.getTotal(map);
	}


}
