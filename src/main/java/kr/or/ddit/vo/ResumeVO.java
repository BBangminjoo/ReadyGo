package kr.or.ddit.vo;

import java.util.Date;
import java.util.List;

import javax.validation.constraints.Pattern;
import javax.validation.constraints.Size;

import org.hibernate.validator.constraints.Email;
import org.hibernate.validator.constraints.NotBlank;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.annotation.JsonIgnore;

import lombok.Data;

@Data
public class ResumeVO {
    private int rnum;

    private String mbrId;
    private String rsmNo;
    @NotBlank(message = "이력서 제목은 필수입니다.")
    @Size(max = 100, message = "이력서 제목은 100자를 초과할 수 없습니다.")
    private String rsmTtl;
    @NotBlank(message = "공개 범위 코드는 필수입니다.")
    private String rsmRlsscopeCd;
    @NotBlank(message = "경력 코드는 필수입니다.")
    private String rsmCareerCd;
    @Size(max = 100, message = "메모는 100자를 초과할 수 없습니다.")
    private String rsmMemo;
    @NotBlank(message = "작성일은 필수입니다.")
    @Pattern(regexp = "^\\d{4}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[01])$", message = "날짜 형식이 올바르지 않습니다. (YYYY-MM-DD)")
    private String rsmWrtYmd;
    @Pattern(regexp = "^\\d{4}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[01])$", message = "날짜 형식이 올바르지 않습니다. (YYYY-MM-DD)")
    private String rsmMdfcnYmd;
    private Date rsmDelYn;
    private String rsmFile;
    @NotBlank(message = "회원 이름은 필수입니다.")
    @Size(max = 5, message = "회원 이름은 5자를 초과할 수 없습니다.")
    private String mbrNm;
    @NotBlank(message = "성별 구분 코드는 필수입니다.")
    private String mbrSexdstncd;
    @Size(max = 200, message = "주소는 200자를 초과할 수 없습니다.")
    private String mbrAddr;
    @Size(max = 100, message = "상세 주소는 100자를 초과할 수 없습니다.")
    private String mbrAddrDtl;
    @Email(message = "올바른 이메일 형식이 아닙니다.")
    private String mbrEml;
    @Pattern(regexp = "^\\d{3}-\\d{4}-\\d{4}$", message = "올바른 휴대폰번호 형식이 아닙니다.")
    private String mbrPhone;
    @Pattern(regexp = "^\\d{2,3}-\\d{3,4}-\\d{4}$", message = "올바른 전화번호 형식이 아닙니다.")
    private String mbrTelno;
    @Pattern(regexp = "^\\d{5}$", message = "올바른 우편번호 형식이 아닙니다.")
    private String mbrZip;
    private String mbrBrdt;
    private String rsmCrdtCd;
    private String rsmSalCd;
    private int rsmSn;
    private String rsmRlsscopeCdNm;
    private String rsmCareerCdNm;
    private String rsmCrdtCdNm;
    private String rsmSalCdNm;
    private String mbrSexdstncdNm;
    private String rsmRsmFile;
    private String rsmCnt;
    
    private String academicInfo;
    private String careerInfo;
    private String skillInfo;
    private String activityInfo;
    private String certificateInfo;
    private String portfolioInfo;
    private String coverLetterInfo;
    
    @JsonIgnore
    private MultipartFile[] uploadFile;
    private List<FileDetailVO> fileDetailVOList;
    
    private List<RsmAcademicVO> rsmAcademicVOList;
    private List<RsmCareerVO> rsmCareerVOList;
    private List<RsmSkillVO> rsmSkillVOList;
    private List<RsmExpactEDCVO> rsmExpactEDCVOList;
    private List<RsmCertificateVO> rsmCertificateVOList;
    private List<RsmPortfolioVO> rsmPortfolioVOList;
    private List<RsmClVO> rsmClVOList;
    
}
