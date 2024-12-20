package kr.or.ddit.enter.entservice.impl;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.mapper.EnterMapper;
import kr.or.ddit.security.CustomUser;
import kr.or.ddit.util.GetUserUtil;
import kr.or.ddit.util.UploadController;
import kr.or.ddit.enter.entservice.*;
import kr.or.ddit.vo.ApplicantVO;
import kr.or.ddit.vo.CodeVO;
import kr.or.ddit.vo.EnterEmpYcntVO;
import kr.or.ddit.vo.EnterVO;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.PbancVO;
import kr.or.ddit.vo.ProposalVO;
import lombok.extern.slf4j.Slf4j;

@Transactional
@Slf4j
@Service
public class EnterServiceImpl implements EnterService {
    
    @Inject //파일 처리
    private UploadController uploadController;
   
	@Inject 
	private EnterMapper enterMapper;
	
	@Inject
	GetUserUtil getUserUtil;
	
	/*기업 프로필 시작*/
	@Override
	public EnterVO profile(String entId) { //기업프로필
		return this.enterMapper.profile(entId);
	}
	@Override
	public List<EnterEmpYcntVO> empYcnt(String entId) { // 기업 프로필 연도별 입사자수
		return this.enterMapper.empYcnt(entId);
	}
	@Override
	public List<CodeVO> getIndutyList() { // 기업프로필- 업종리스트
		return this.enterMapper.getIndutyList();
	}
	/*기업 프로필 끝*/
	
	
	/*기업정보수정 시작*/
	@Override
	public EnterVO edit(String entId) { // 기업정보수정폼
		return this.enterMapper.edit(entId);
	}
	@Override
	public List<CodeVO> getEntStleCdList() { // 기업정보수정 - 기업형태리스트
		return this.enterMapper.getEntStleCdList();
	}
	@Override
	public int editPost(EnterVO enterVO) { // 기업정보수정실행 합친거
		log.info("EnterServiceImpl->editPost->enterVO : " + enterVO);
		
		int result = 0;
		EnterVO enterVO2 = enterMapper.selectOne(enterVO.getEntId());
		// 0) 파일 업로드 처리
		MultipartFile[] uploadFile1 = enterVO.getEntBrFileFile();
		MultipartFile[] uploadFile2 = enterVO.getEntLogoFile();
		  
	   //공통 멀티이미지업로드 메소드 호출
       //return값 : FILE_GROUP.FILE_GROUP_NO의 값
	   //사업자 등록증 파일처리
		if (uploadFile1 == null || uploadFile1.length == 0 || uploadFile1[0].isEmpty()) {
			log.info("새로운 파일이 업로드되지 않았습니다.");
			enterVO.setEntBrFile(enterVO2.getEntBrFile());
			
		} else {
			String fileGroupNo = this.uploadController.multiImageUpload(uploadFile1, "/enter/brFile");
			// 새로운 파일 업로드 처리
			log.info("editPost->fileGroupSn : " + fileGroupNo);
			
			// 새로운 파일 그룹 번호 설정
			enterVO.setEntBrFile(fileGroupNo);
		}
		//로고 파일처리
		if (uploadFile2 == null || uploadFile2.length == 0 || uploadFile2[0].isEmpty()) {
			log.info("새로운 파일이 업로드되지 않았습니다.");
			enterVO.setEntLogo(enterVO2.getEntLogo());
			
		} else {
			// 새로운 파일 업로드 처리
			String fileGroupNo2 = this.uploadController.multiImageUpload(uploadFile2, "/enter/logoFile");
			log.info("editPost->fileGroupSn : " + fileGroupNo2);
			
			// 새로운 파일 그룹 번호 설정
			enterVO.setEntLogo(fileGroupNo2);
		}
	  
	  
	  result += this.enterMapper.editPost1(enterVO);
	  
	  Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
      CustomUser customUser = (CustomUser) authentication.getPrincipal();
      customUser.setEntVO(enterMapper.selectOne(enterVO.getEntId()));
		
		return result;
	}
	
	@Override
	public EnterVO passEdit(String entId) {//비밀번호수정
		return this.enterMapper.passEdit(entId);
	}
	
	@Override
	public int passEditPost(EnterVO enterVO) { //비밀번호수정실행
		int result = 0;
		result += this.enterMapper.passEditPost(enterVO);
		
		getUserUtil.getEntVO().setEntPswd(enterVO.getEntPswd());
		return result;
	}
	/*기업정보수정 끝*/
	
	
	/*기업탈퇴시작*/ 
	@Override
	public int deleteAjax(String entId) {
		return this.enterMapper.deleteAjax(entId);
	}
	/*기업탈퇴끝*/
	
	
	/*인재 시작*/
	@Override
	public List<CodeVO> getSkillList(Map<String, Object> map) { //인재-스킬
		return this.enterMapper.getSkillList(map);
	}
	@Override
	public List<MemberVO> getInjaeList(Map<String, Object> map) {// 인재 리스트
		return this.enterMapper.getInjaeList(map);
	}
	@Override
	public int getTotalInjae(Map<String, Object> map) {//인재 페이지네이션
		return this.enterMapper.getTotalInjae(map);
	}
	@Override
	public List<MemberVO> getRecommendList(Map<String, Object> map) { // 기업추천인재
		return this.enterMapper.getRecommendList(map);
	}
	/*인재 끝*/
	
	
	/*공고관리 시작*/
	@Override
	public List<PbancVO> getPbancList(Map<String, Object> map) {// 기업공고관리
		return this.enterMapper.getPbancList(map);
	}
	@Override
	public int getTotal(Map<String, Object> map) {//공고관리 페이지네이션
	    return enterMapper.getTotal(map);
	}
	@Override
	public PbancVO pbancDetailList(Map<String, Object> map) {//공고상세
		return enterMapper.pbancDetailList(map);
	}
	@Override
	public int pbancDelete(Map<String, Object> map) {//공고삭제
		return this.enterMapper.pbancDelete(map);
	}	
	@Override
	public List<PbancVO> tempPbanc(Map<String, Object> map) {//공고임시저장
		return this.enterMapper.tempPbanc(map);
	}	
	@Override
	public int getTotalTempPbanc(Map<String, Object> map) {//임시저장페이지네이션
		return this.enterMapper.getTotalTempPbanc(map);
	}
	/*공고관리 끝*/
	
	/*공고 스크랩 시작*/
	@Override
	public int cancelScrap(Map<String, Object> map) {//스크랩취소
		return enterMapper.cancelScrap(map);
	}
	@Override
	public int addScrap(Map<String, Object> map) {
		return enterMapper.addScrap(map);
	}
	@Override
	public int getScrapCount(String pbancNo) {
		return enterMapper.getScrapCount(pbancNo);
	}
	//스크랩 회원 여부 
	@Override
	public int getscrap(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return this.enterMapper.getscrap(map);
	}
	/*공고 스크랩 끝*/
	
	
	/*공고 수정 1~8 시작*/
	@Override
	public int pbancUpdate(PbancVO pbancVO) {
		return this.enterMapper.pbancUpdate(pbancVO);
	}
	@Override
	public int favorUpdate(PbancVO pbancVO) { //복지및혜택
		
		int result = 0; 
		this.enterMapper.favorDelete(pbancVO);
		
		List<String> favorList = pbancVO.getFavorList();
		
		for(String  favorCn : favorList) {
			pbancVO.setFavorCn(favorCn);
			result += this.enterMapper.favorUpdate(pbancVO);
		}
		return result;		
	}
	
	@Override
	public int recruitmentUpdate(PbancVO pbancVO) {
		return this.enterMapper.recruitmentUpdate(pbancVO);
	}
	@Override
	public int procssUpdate(PbancVO pbancVO) {
		int result = 0;
		result+=this.enterMapper.procssDelete(pbancVO);
		result+=this.enterMapper.procssUpdate(pbancVO);
		return result;
	}
	@Override
	public int fileUpdate(PbancVO pbancVO) { // 공고 파일 업로드
	    int result = 0;

	    // 기존의 파일 그룹 정보를 가져옴
	    MultipartFile[] multipartFiles = pbancVO.getEntPbancFile();
	    
	    if (multipartFiles == null || multipartFiles.length == 0 || multipartFiles[0].isEmpty()) {
	        log.info("새로운 파일이 업로드되지 않았습니다.");
	        
	        // 새로운 파일이 없으면 기존 파일 그룹 번호를 유지
	        pbancVO.setFileGroupSn(pbancVO.getPbancImgFile()); // 기존 파일 그룹 번호 설정
	        log.info("pbancVO.setFileGroupSn : " + pbancVO.getFileGroupSn());
	    } else {
	        // 새로운 파일이 업로드된 경우 파일 그룹 번호 갱신
	        String fileGroupSn = this.uploadController.multiImageUpload(multipartFiles, "/enter/logoFile");
	        
	        if (fileGroupSn == null || fileGroupSn.isEmpty()) {
	            log.error("파일 업로드에 실패했습니다.");
	            return 0; // 업로드 실패 시 반환
	        }
	        
	        log.info("mainFile->fileGroupSn : " + fileGroupSn);
	        pbancVO.setFileGroupSn(fileGroupSn); // 새로 업로드된 파일 그룹 번호 설정
	    }

	    // 파일 정보 업데이트
	    result += this.enterMapper.fileUpdate(pbancVO);
	    
	    return result;
	}	
	
	@Override
	public int tpbizUpdate(PbancVO pbancVO) {//공고업종수정
		int result = 0;
		
		List<String> tpbizCdList = pbancVO.getTpbizCdList();
		this.enterMapper.tpbizDelete(pbancVO);
		for (String tpbizCd : tpbizCdList) {
			pbancVO.setTpbizCd(tpbizCd);
			log.info("pbancVO : "+ pbancVO.getTpbizCd());
			result += this.enterMapper.tpbizUpdate(pbancVO);
		}
		
		return result;
	}
	@Override
	public int addrUpdate(PbancVO pbancVO) {//공고지역수정
		int result = 0;
		
		List<String> powkList = pbancVO.getPowkList();
		this.enterMapper.powkDelete(pbancVO); //공고지역삭제후 수정 실행
		for (String powkCd : powkList) {
			pbancVO.setPowkCd(powkCd);
			log.info("pbancVO : "+ pbancVO.getPowkCd());
			result += this.enterMapper.addrUpdate(pbancVO);
		}
		
		return result;		
	}	
	@Override
	public List<CodeVO> getpowkCdList() { //공고지역대장
		return this.enterMapper.getpowkCdList();
	}
	@Override
	public int privilegedUpdate(PbancVO pbancVO) {//공고필수조건수정
		int result = 0; 
		
		this.enterMapper.privilegedDelete(pbancVO);
		List<String> requiredCnList = pbancVO.getRequiredCnList();
		
		for(String  requiredCn : requiredCnList) { //필수조건수정
			pbancVO.setRequiredCn(requiredCn);
			result += this.enterMapper.privilegedUpdate(pbancVO);
		}
		return result;	
	}
	@Override
	public int preferUpdate(PbancVO pbancVO) {//공고우대조건수정
		int result = 0; 
		
		this.enterMapper.preferDelete(pbancVO);
		List<String> perferCnList = pbancVO.getPreferCnList();
		
		for(String  perferCn : perferCnList) {//우대조건수정
			pbancVO.setPreferCn(perferCn);
			result += this.enterMapper.preferUpdate(pbancVO);
		}
		return result;	
	}
	/*공고 수정 1~8 끝*/	
	
	
	/*공고 등록폼 시작*/
	@Override
	public EnterVO getEntInfor(String entId) { //공고등록 sec1 기업정보 조회
		return this.enterMapper.getEntInfor(entId);
	}
	@Override
	public EnterVO location(String entId) { // 카카오맵
		return this.enterMapper.location(entId);
	}	
	/*공고 등록폼 끝*/
	
	/*공고등록시작*/
	@Override
	public int pbancInsertPost1(PbancVO pbancVO) { // pbanc 등록
		return this.enterMapper.pbancInsertPost1(pbancVO);
	}
	@Override
	public int pbancInsertPost2(PbancVO pbancVO) { // favor 등록
		int result = 0; 
		
		List<String> favorList = pbancVO.getFavorList();
		
		for(String  favorCn : favorList) {
			pbancVO.setFavorCn(favorCn);
			result += this.enterMapper.pbancInsertPost2(pbancVO);
		}
		return result;
	}
	
	@Override
	public int pbancInsertPost3(PbancVO pbancVO) { // recruitment 등록
		return this.enterMapper.pbancInsertPost3(pbancVO);
	}
	@Override
	public int pbancInsertPost4(PbancVO pbancVO) { // procsse 등록
		return this.enterMapper.pbancInsertPost4(pbancVO);
	}
	
	@Override
	public int pbancInsertPost5(PbancVO pbancVO) { // file 등록
	    int result = 0;

	    // 기존의 파일 그룹 정보를 가져옴
	    MultipartFile[] multipartFiles = pbancVO.getEntPbancFile();
	    
	    if (multipartFiles == null || multipartFiles.length == 0 || multipartFiles[0].isEmpty()) {
	        log.info("새로운 파일이 업로드되지 않았습니다.");
	        // 새로운 파일이 없으면 기존 파일 그룹 번호를 유지
	        pbancVO.setFileGroupSn(pbancVO.getPbancImgFile()); // 기존 파일 그룹 번호 설정
	    } else {
	        // 새로운 파일이 업로드된 경우 파일 그룹 번호 갱신
	        String fileGroupSn = this.uploadController.multiImageUpload(multipartFiles, "/enter/logoFile");
	        
	        if (fileGroupSn == null || fileGroupSn.isEmpty()) {
	            log.error("파일 업로드에 실패했습니다.");
	            return 0; // 업로드 실패 시 반환
	        }
	        
	        log.info("mainFile->fileGroupSn : " + fileGroupSn);
	        pbancVO.setFileGroupSn(fileGroupSn); // 새로 업로드된 파일 그룹 번호 설정
	    }

	    // 파일 정보 업데이트
	    result += this.enterMapper.pbancInsertPost5(pbancVO);
	    
	    return result;
	}		
	@Override
	public int pbancInsertPost6(PbancVO pbancVO) { // 업종 등록
		int result = 0;
		
		List<String> tpbizCdList = pbancVO.getTpbizCdList();
		for (String tpbizCd : tpbizCdList) {
			pbancVO.setTpbizCd(tpbizCd);
			log.info("pbancVO : "+ pbancVO.getTpbizCd());
			result += this.enterMapper.pbancInsertPost6(pbancVO);
		}
		
		return result;
	}
	
	@Override
	public int pbancInsertPost7(PbancVO pbancVO) { // 지역 등록
		int result = 0;
		
		List<String> powkList = pbancVO.getPowkList();
		for (String powkCd : powkList) {
			pbancVO.setPowkCd(powkCd);
			result += this.enterMapper.pbancInsertPost7(pbancVO);
		}
		
		return result;	
	}	
	
	@Override
	public int pbancInsertPost8(PbancVO pbancVO) {//필수조건등록
		int result = 0; 
		
		List<String> requiredCnList = pbancVO.getRequiredCnList();
		
		for(String  requiredCn : requiredCnList) { //필수조건수정
			pbancVO.setRequiredCn(requiredCn);
			result += this.enterMapper.pbancInsertPost8(pbancVO);
		}
		return result;	
	}
	@Override
	public int pbancInsertPost9(PbancVO pbancVO) {//우대조건등록
		int result = 0; 
		
		List<String> perferCnList = pbancVO.getPreferCnList();
		
		for(String  perferCn : perferCnList) {//우대조건수정
			pbancVO.setPreferCn(perferCn);
			result += this.enterMapper.pbancInsertPost9(pbancVO);
		}
		return result;	
	}
	
	
	
	/*공고등록끝*/
	
	/*공고 등록 -> 공고 임시저장 버튼 실행  시작*/
	@Override
	public int pbancSavePost1(PbancVO pbancVO) {//공고임시저장 실행:pbanc
		return this.enterMapper.pbancSavePost1(pbancVO);
	}
	@Override
	public int pbancSavePost2(PbancVO pbancVO) {//공고임시저장 실행:favor
		return this.enterMapper.pbancSavePost2(pbancVO);
	}
	@Override
	public int pbancSavePost3(PbancVO pbancVO) {//공고임시저장 실행:recruitment
		return this.enterMapper.pbancSavePost3(pbancVO);
	}
	@Override
	public int pbancSavePost4(PbancVO pbancVO) {//공고임시저장 실행:procss
		return this.enterMapper.pbancSavePost4(pbancVO);
	}
	@Override
	public int pbancSavePost5(PbancVO pbancVO) {//공고임시저장 실행:file
	    int result = 0;

	    // 기존의 파일 그룹 정보를 가져옴
	    MultipartFile[] multipartFiles = pbancVO.getEntPbancFile();
	    
	    if (multipartFiles == null || multipartFiles.length == 0 || multipartFiles[0].isEmpty()) {
	        log.info("새로운 파일이 업로드되지 않았습니다.");
	        
	        // 새로운 파일이 없으면 기존 파일 그룹 번호를 유지
	        pbancVO.setFileGroupSn(pbancVO.getFileGroupSn()); // 기존 파일 그룹 번호 설정
	    } else {
	        // 새로운 파일이 업로드된 경우 파일 그룹 번호 갱신
	        String fileGroupSn = this.uploadController.multiImageUpload(multipartFiles, "/enter/logoFile");
	        
	        if (fileGroupSn == null || fileGroupSn.isEmpty()) {
	            log.error("파일 업로드에 실패했습니다.");
	            return 0; // 업로드 실패 시 반환
	        }
	        
	        log.info("mainFile->fileGroupSn : " + fileGroupSn);
	        pbancVO.setFileGroupSn(fileGroupSn); // 새로 업로드된 파일 그룹 번호 설정
	    }

	    // 파일 정보 업데이트
	    result += this.enterMapper.pbancSavePost5(pbancVO);
	    
	    return result;		
	}
	
	
	@Override
	public int pbancSavePost6(PbancVO pbancVO) {//공고임시저장 실행:업종
		return this.enterMapper.pbancSavePost6(pbancVO);
	}	
	
	/*공고 등록 -> 공고 임시저장 버튼 실행  끝*/
	
	@Override
	public int pbancTempInsertPost1(PbancVO pbancVO) { //공고 임시저장 -> 등록
		return this.enterMapper.pbancTempInsertPost1(pbancVO);
	}	
	
	@Override
	public int retempPbancSavePost1(PbancVO pbancVO) {//공고임시저장 페이지 -> 공고임시저장 버튼 실행
		return this.enterMapper.retempPbancSavePost1(pbancVO);
	}
	
	
	
	/*스카우트 제안 시작*/
	@Override
	public List<ProposalVO> scoutList(Map<String, Object> map) { // 스카우트 제안 리스트
	    // currentPage가 null이거나 비어있다면 기본값 설정
	    if (map.get("currentPage") == null) {
	    	map.put("currentPage", 1);
	    }
		return this.enterMapper.scoutList(map);
	}
	//스카우트 리스트 엑셀
	@Override
	public List<ProposalVO> scoutListExcel(Map<String, Object> map) {
		return this.enterMapper.scoutListExcel(map);
	}
	@Override
	public int getTotalPbanc(Map<String, Object> map) {//스카우트제안 페이지네이션
		return this.enterMapper.getTotalPbanc(map);
	}
	@Override
	public List<PbancVO> pbancList(Map<String, Object> map) {//스카우트 제안 - 공고
		return this.enterMapper.pbancList(map);
	}
	/*스카우트 제안 끝*/
	
	
	/*지원자 리스트 시작*/
	@Override
	public int updateAplctSt(Map<String, Object> map) { // 지원자상태저장
		int result = 0;
		
		result +=this.enterMapper.updateAplctSt(map);
		int cnt = this.enterMapper.intrvwChk(map);
		if(map.get("status").equals("APST02")) {
			if(cnt==0) {
				this.enterMapper.updateAplctIntrvw(map);				
			}
		}
		
		return result;
	}
	@Override
	public List<ApplicantVO> AplctListExcel(Map<String, Object> map) { //지원자리스트엑셀
		return this.enterMapper.AplctListExcel(map);
	}
	@Override
	public List<ApplicantVO> aplctList(Map<String, Object> map) {// 지원자리스트
		return this.enterMapper.aplctList(map);
	}
	@Override
	public int getTotalListAplct(Map<String, Object> map) {//지원자리스트 페이지네이션
		return this.enterMapper.getTotalListAplct(map);
	}
	@Override
	public List<PbancVO> entPbancList(Map<String, Object> map) { //공고꺼내기
		return this.enterMapper.entPbancList(map);
	}
	@Override
	public List<ProposalVO> proposalList(Map<String, Object> map) { //제안 아이디 꺼내기
		return this.enterMapper.proposalList(map);
	}
	/*지원자 리스트 끝*/
	@Override
	public List<MemberVO> getInjaeList2(Map<String, Object> map) {
		return this.enterMapper.getInjaeList2(map);
	}
	







	

	




	
	

	


	

}
