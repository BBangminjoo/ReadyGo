package kr.or.ddit.vo;

import lombok.Data;

@Data
public class CodeVO {
	private String comCode;
	private String comCodeGrp;
	private String comCodeNm;
	private String comCodeDesc;
	private String useYn;
	private String upperComCode;
	private String upperComCodeGrp;
	
	private String upperComCodeNm; // 상위 지역 코드 이름 추가
	private int rnum;
	
	private String mbrId;
}
