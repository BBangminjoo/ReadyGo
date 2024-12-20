package kr.or.ddit.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.vo.ApplicantVO;
import kr.or.ddit.vo.CodeVO;
import kr.or.ddit.vo.ProposalVO;

public interface MemProposalService {
	
	// 받은 제안 목록 조회
	public List<ProposalVO> memProList(Map<String, Object>map);
	
	// 받은 제안 전체 행의 수 조회
	public int getTotal(Map<String, Object> map);
    
}
