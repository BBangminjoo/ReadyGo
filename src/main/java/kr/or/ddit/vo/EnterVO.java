package kr.or.ddit.vo;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;
import lombok.ToString;

@Data
public class EnterVO {
	private String userType;		//권한번호
	private String entId; 			//기업아이디
	private String entPswd; 		//기업비밀번호
	private String entNm; 			//기업명
	private String entManagerTelno; //담당자연락처
	private String entMail;			//기업메일
	private String entFxnum;		//팩스번호
	private String entAddr;			//기본주소
	private String entAddrDetail;	//상세주소
	private String entZip;			//우편번호
	private String entLogo;			//기업로고
	private String entLogos;			//기업로고
	private String entRprsntvNm;	//대표자이름
	private String entStleCd;		//기업형태
	private int entEmpCnt;			//사원수
	private String entFndnYmd;		//설립일자
	private String entFndnYmds;		//설립일자
	private String entHmpgUrl;		//기업홈페이지URL
	private String entBrno;			//사업자등록번호
	private String entBrFile;		//사업자등록증파일
	private String enabled;			//기업상태코드
	private String tpbizSeCd; 		//업종구분코드
	private String entRprsrgn; 		//지역구분코드
	private String entMailApppswd;  //앱 비밀번호
	private int rnum;
	private String revenueAmount;   //매출액
	private String entStleCdNm; 	//기업형태명
	private String tpbizSeCdNm; 	//업종명
	private String entRprsrgnNm; 	//기업 대표지역명
	private String entCityNm; 		//기업 대표도시명
	private List<UserAuthVO> userAuthVOList;	//권한
	
	// ENTER : PBANC = N : N
	  @ToString.Exclude
	private List<PbancVO> pbancVOList;			//공고
	
    // MultipartFile
    private MultipartFile[] entLogoFile;		//로고
    private MultipartFile[] entBrFileFile;		//파일업로드
    private MultipartFile[] uploadFile;			//파일업로드
    
    private List<CodeVO> codeVOList;			//공통코드

    private List<FileDetailVO> fileDetailVOList;//사업자등록증
    private String fileGroupNo; 				//파일업로드
}
