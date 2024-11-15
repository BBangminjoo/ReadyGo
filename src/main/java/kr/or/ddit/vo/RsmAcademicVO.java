package kr.or.ddit.vo;

import lombok.Data;

@Data
public class RsmAcademicVO {
	private String acbgNo;
	private String rsmNo;
	private String acbgSeCd;	//학력 구분 코드
	private String acbgRcognacbgCd; //학력 인정학력 코드
	private String acbgSchlNm; //학력 학교명
	private String acbgMjrNm;  // 학력 전공명
	private String acdmcrGrdtnSeCd; // 학력 졸업 구분 코드
	private String acbgMtcltnym; //학력 입학년월
	private String acbgGrdtnym; //학력 졸업년월
	private String acbgPntCd; //학력 학점 코드
	private String acbgPnt; //학력 학점
	
	private String acbgSeCdNm; //학력 학점
	private String acbgRcognacbgCdNm; //학력 인정학력 코드
	private String acdmcrGrdtnSeCdNm; //학력 졸업 구분 코드
	private String acbgPntCdNm; //학력 학점 코드
} 
