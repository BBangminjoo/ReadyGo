package kr.or.ddit.enter.entservice;

import java.util.List;
import java.util.Map;

import kr.or.ddit.vo.ApplicantVO;
import kr.or.ddit.vo.CodeVO;
import kr.or.ddit.vo.EnterEmpYcntVO;
import kr.or.ddit.vo.EnterVO;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.PbancVO;
import kr.or.ddit.vo.ProposalVO;

public interface EnterService {
	/*기업프로필*/	
	public EnterVO profile(String entId); // 기업 프로필 조회
	public List<EnterEmpYcntVO> empYcnt(String entId); // 기업 프로필 - 연도별 입사자수
	
	/*기업정보수정*/
	public EnterVO edit(String entId); // 기업정보수정 폼
	public List<CodeVO> getIndutyList(); // 기업 정보수정 - 업종리스트
	public List<CodeVO> getEntStleCdList(); // 기업 정보수정- 기업형태
	public int editPost(EnterVO enterVO); // 기업정보수정 실행
	public EnterVO passEdit(String entId); //비밀번호수정
	public int passEditPost(EnterVO enterVO); //비밀번호수정실행

	/*기업탈퇴*/
	public int deleteAjax(String entId);
	
	/*인재*/
	public List<CodeVO> getSkillList(Map<String, Object> map);// 인재-스킬
	public List<MemberVO> getInjaeList(Map<String, Object> map);// 인재리스트
	public List<MemberVO> getRecommendList(Map<String, Object> map); //기업추천인재
	public List<PbancVO> pbancList(Map<String, Object> map); //스카우트제안 - 공고 
	public int getTotalInjae(Map<String, Object> map);//페이지네이션
	
	/*공고관리*/
	public List<PbancVO> getPbancList(Map<String, Object> map);
	public int getTotalPbanc(Map<String, Object> map);//페이지네이션
	public PbancVO pbancDetailList(Map<String, Object> map);//공고상세페이지
	public int cancelScrap(Map<String, Object> map); //스크랩 취소
	public int addScrap(Map<String, Object> map); //스크랩  + 
	public int getScrapCount(String pbancNo); //스크랩 조회수
	public int getscrap(Map<String, Object> map);//스크랩 회원 상세 여부
	public int pbancDelete(Map<String, Object> map); //공고삭제
	
	public int pbancUpdate(PbancVO pbancVO); //공고 pbanc 수정
	public int favorUpdate(PbancVO pbancVO);//공고 favor 수정
	public int recruitmentUpdate(PbancVO pbancVO);//공고 recruit 수정
	public int procssUpdate(PbancVO pbancVO);//공고 procss 수정
	public int fileUpdate(PbancVO pbancVO);//공고 file수정
	public int tpbizUpdate(PbancVO pbancVO);//공고업종수정
	public int addrUpdate(PbancVO pbancVO);//공고지역수정
	public List<CodeVO> getpowkCdList();//공고지역대장
	public int privilegedUpdate(PbancVO pbancVO);//공고필수조건수정
	public int preferUpdate(PbancVO pbancVO);//공고우대조건수정
	
	public EnterVO getEntInfor(String entId); //공고 등록 sec1 기업정보 조회
	public int pbancInsertPost1(PbancVO pbancVO);//공고등록실행:pbanc
	public int pbancInsertPost2(PbancVO pbancVO);//공고등록실행:favor
	public int pbancInsertPost3(PbancVO pbancVO);//공고등록실행:recruitment
	public int pbancInsertPost4(PbancVO pbancVO);//공고등록실행:procss
	public int pbancInsertPost5(PbancVO pbancVO);//공고등록실행:file
	public int pbancInsertPost6(PbancVO pbancVO);//공고등록실행:업종
	public int pbancInsertPost7(PbancVO pbancVO);//공고등록실행:지역
	public int pbancInsertPost8(PbancVO pbancVO);//공고등록실행:필수
	public int pbancInsertPost9(PbancVO pbancVO);//공고등록실행:우대
	
	public EnterVO location(String entId); //카카오맵
	public List<PbancVO> tempPbanc(Map<String, Object> map);//임시저장
	public int getTotalTempPbanc(Map<String, Object> map);//임시저장 페이지네이션
	public int pbancSavePost1(PbancVO pbancVO); //공고임시저장 실행:pbanc
	public int pbancSavePost2(PbancVO pbancVO); //공고임시저장 실행:favor
	public int pbancSavePost3(PbancVO pbancVO); //공고임시저장 실행:recruitment
	public int pbancSavePost4(PbancVO pbancVO); //공고임시저장 실행:procss
	public int pbancSavePost5(PbancVO pbancVO); //공고임시저장 실행:file
	public int pbancSavePost6(PbancVO pbancVO); //공고임시저장 실행:업종
	public int pbancTempInsertPost1(PbancVO pbancVO);//공고임시저장 등록
	public int retempPbancSavePost1(PbancVO pbancVO);//공고임시저장페이지 -> 임시저장버튼 실행


	
	/*지원자리스트*/
	public List<ApplicantVO> aplctList(Map<String, Object> map);//지원자리스트
	public int updateAplctSt(Map<String, Object> map); //지원자상태 업데이트
	public int getTotalListAplct(Map<String, Object> map);//페이지네이션
	public List<ApplicantVO> AplctListExcel(Map<String, Object> map);//지원자리스트엑셀
	public List<PbancVO> entPbancList(Map<String, Object> map); //공고꺼내기
	public List<ProposalVO> proposalList(Map<String, Object> map); //제안 아이디 꺼내기
	
	/*스카우트 제안*/
	public List<ProposalVO> scoutList(Map<String, Object> map);//스카우트 리스트
	public int getTotal(Map<String, Object> map); //페이지네이션
	public List<ProposalVO> scoutListExcel(Map<String, Object> map);//스카우트리스트 엑셀
	public List<MemberVO> getInjaeList2(Map<String, Object> map);
	
	
	
	
	
	
	
	
	
	
	


	

}
