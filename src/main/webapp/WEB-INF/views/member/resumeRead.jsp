<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<link rel="stylesheet"
	href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
<link rel="stylesheet"
	href="/resources/css/member/resume.css" />

<script
	src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="/resources/js/jquery.min.js"></script>
<script src="/resources/js/sweetalert2.js"></script>
<script src="/resources/js/html2canvas.js"></script>
<script src="/resources/js/jspdf.min.js"></script>
<script>
var Toast = Swal.mixin({
	toast: true,
    position: 'center',
    showConfirmButton: false,
    timer: 3000
});
const rsmCareerVOList = ${rsmCareerVOListJson};
const rsmExpactEDCVOListJson = ${rsmExpactEDCVOListJson};
function calculateAge(birthdateNumber) {
    // 생년월일을 숫자로 받음 (예: 20240518)
    const birthdateString = birthdateNumber.toString();

    // 연, 월, 일을 추출
    const year = parseInt(birthdateString.substring(0, 4), 10);
    const month = parseInt(birthdateString.substring(4, 6), 10) - 1; // 월은 0부터 시작하므로 -1
    const day = parseInt(birthdateString.substring(6, 8), 10);

    // 생년월일을 Date 객체로 생성
    const birthdate = new Date(year, month, day);
    
    // 현재 날짜 가져오기
    const today = new Date();
    
    // 나이 계산
    let age = today.getFullYear() - birthdate.getFullYear();
    
    // 아직 생일이 지나지 않았으면 나이에서 1을 뺌
    const monthDiff = today.getMonth() - birthdate.getMonth();
    if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < birthdate.getDate())) {
        age--;
    }

    return age;
}
function calculateCareer(entDay, firDay) {
    if (!entDay) {
        return 0;
    }
	const entDayStr = entDay.toString();
	
	let fyear = "";
	let fMonth = "";
	if(firDay){
	    const firDayStr = firDay.toString();
	    fYear = parseInt(firDay.substring(0, 4), 10);
	    fMonth = parseInt(firDay.substring(4, 6), 10) - 1;
		
	}

    // 입사일 연도와 월
    const eYear = parseInt(entDay.substring(0, 4), 10);
    const eMonth = parseInt(entDay.substring(4, 6), 10) - 1; // 월은 0부터 시작하므로 -1

    // 퇴사일 연도와 월
    if(!firDay){
    	const today = new Date();
    	fYear = parseInt(today.getFullYear().toString());
    	fMonth = parseInt(today.getMonth().toString()) + 1; 
    }

    // 경력 계산: 퇴사일과 입사일 간의 차이를 월 단위로 계산
    let career = (fYear - eYear) * 12 + (fMonth - eMonth);
    
    return career;
}
$(function(){
	// 다운로드 버튼 클릭 이벤트 설정
	$("#downloadBtn").on("click", function() {
	    // HTML 요소를 캔버스로 변환
	    html2canvas($("#frame")[0], {
	        scale: 1.5  // 해상도를 1,5배로 증가
	    }).then(function(canvas) {
	        // 캔버스를 PNG 이미지 데이터로 변환
	        const imgData = canvas.toDataURL('image/png');
	        
	        // A4 용지 크기 설정
	        const imgWidth = 190;  // 이미지 가로 길이(mm) / A4 기준 210mm
	        const pageHeight = imgWidth * 1.414;  // A4 용지 비율 적용
	        const imgHeight = canvas.height * imgWidth / canvas.width;
	        let heightLeft = imgHeight;
	        
	        // PDF 문서 설정
	        const margin = 11;  // 여백 설정(mm)
	        const doc = new jsPDF('p', 'mm');  // 세로방향, 단위는 밀리미터
	        let position = 0;
	        
	        // 첫 페이지 생성
	        doc.addImage(imgData, 'PNG', margin, position, imgWidth, imgHeight);
	        heightLeft -= pageHeight;
	        
	        // 내용이 한 페이지를 초과할 경우 추가 페이지 생성
	        while (heightLeft >= 20) {  // 최소 20mm 이상일 때만 새 페이지 생성
	            position = heightLeft - imgHeight;
	            doc.addPage();
	            doc.addImage(imgData, 'PNG', margin, position, imgWidth, imgHeight);
	            heightLeft -= pageHeight;
	        }
	        
	        // PDF 파일 저장
	        doc.save("${resumeVO.rsmTtl }");
	    }).catch(function(error) {
	        console.error('PDF 생성 중 오류 발생:', error);
	    });
	});
	let birth = ${resumeVO.mbrBrdt};
	let age = calculateAge(birth);
	$("#age").text(age);
	
	let careerMonth = 0;

    // 경력 데이터를 루프 돌면서 각 경력의 개월 수를 합산
    for(let i = 0; i < rsmCareerVOList.length; i++){
    	careerMonth += calculateCareer(rsmCareerVOList[i].careerJncmpYmd, rsmCareerVOList[i].careerRetireYmd);
    }
    let years = Math.floor(careerMonth / 12);
    let months = careerMonth % 12;    
    let careerStr = ""
    if(years > 0){
    careerStr += years+"년 "
    }
    careerStr += months+"개월";
    // 계산한 총 경력 개월 수를 #careerMonth 요소에 삽입
    $("#careerMonth").text(careerStr);
    
	let actMonth = 0;

    // 경력 데이터를 루프 돌면서 각 경력의 개월 수를 합산
    for(let i = 0; i < rsmExpactEDCVOListJson.length; i++){
    	actMonth += calculateCareer(rsmExpactEDCVOListJson[i].actBeginYmd, rsmExpactEDCVOListJson[i].actEndYmd);
    }
    let years1 = Math.floor(actMonth / 12);
    let months1 = actMonth % 12;    
    let actStr = ""
    if(years1 > 0){
    	actStr += years1+"년 ";
    }
    if(months1 > 0){
    	actStr += months1+"개월";
    }
    // 계산한 총 경력 개월 수를 #careerMonth 요소에 삽입
    $("#actMonth").text(actStr);
    
})
</script>
<c:set var="formattedPhone" value="${fn:substring(resumeVO.mbrPhone, 0, 3)}-${fn:substring(resumeVO.mbrPhone, 3, 7)}-${fn:substring(resumeVO.mbrPhone, 7, 11)}" />
<button type="button" id="downloadBtn">이력서 다운로드</button>
<div id="main">
	<div id="frame" style="padding-right: 30px;">
		<div class="row" id="basicInfo">
			<div class="basText-l" >
				<div class="font-15 bold-5 gray">
					<div class="resumeTop">
						<b class="font-24 bold-7 black">${resumeVO.mbrNm }</b> <span class="font-14 bold-7 hili">${resumeVO.rsmCareerCdNm }</span>
					</div>
					<div class="margin-bottom-3">
						${resumeVO.mbrBrdt.substring(0,4)} ${resumeVO.mbrSexdstncdNm } (<b id="age"></b>세)&nbsp;&nbsp; |&nbsp;&nbsp;
						 희망사항(${resumeVO.rsmCrdtCdNm } · ${resumeVO.rsmSalCdNm })
					</div>
					<div class="bold-4 margin-bottom-2">
						이메일 &nbsp;&nbsp;<b class="black">${resumeVO.mbrEml }</b>&nbsp;&nbsp; |&nbsp;&nbsp; 휴대폰 &nbsp;&nbsp;<b class="black">${formattedPhone }</b>
					</div>
					<div class="bold-4">
						주소 &nbsp;&nbsp;<b class="black">(${resumeVO.mbrZip}) ${resumeVO.mbrAddr }</b>
					</div>
				</div>
			</div>
			<div class="basImg">
				<img src="/upload${resumeVO.fileDetailVOList[0].filePathNm.substring(51)}">
			</div>
		</div>
		<div class="margin-bottom-3">
			<p class="bold-7 font-16">업무 능력</p>
			<div class="basText-xl">
				<c:forEach var="VO" items="${rsmSkillVOList}" varStatus="stut" >
					<span class="skill">${VO.skCdNm }</span>
				</c:forEach>
			</div>
		</div>
		
		<div class="infoBox col margin-bottom-3">
			<div class="title font-22">학력 &nbsp;<b class="font-14 green bold-5">${rsmAcademicVOList[0].acbgRcognacbgCdNm} ${rsmAcademicVOList[0].acdmcrGrdtnSeCdNm}</b></div>
			<c:forEach var="VO" items="${rsmAcademicVOList}" varStatus="stut" >
				<div class="row conBox">
						<div class="basText-xs font-15 margin-rigth-1">
							<div class="margin-bottom-1 ">
							<c:if test="${VO.acbgMtcltnym!=null }">
								${VO.acbgMtcltnym.substring(0,4)}.${VO.acbgMtcltnym.substring(4,6)} 
									~ 
							</c:if>
								<c:if test="${VO.acbgGrdtnym!=null }">
									${VO.acbgGrdtnym.substring(0,4) }.${VO.acbgGrdtnym.substring(4,6) }
								</c:if>
							</div>
							<div class="gray font-14 ">
								${VO.acdmcrGrdtnSeCdNm }
							</div>
						</div>
						<div class="basText-xl ">
							<div class="margin-bottom-3 font-18 bold-7 ">
								<b class="margin-rigth-2">${VO.acbgSchlNm }${VO.acbgRcognacbgCdNm }</b><b class="gray font-14 bold-5">${VO.acbgMjrNm }</b>
							</div>
							<c:if test="${VO.acbgPnt!=null }">
								<div class="margin-bottom-1">
									 <b class="gray font-14 bold-5">학점</b> &nbsp;&nbsp;<b class="black font-14 bold-5">${VO.acbgPnt } / ${VO.acbgPntCdNm }</b>
								</div>
							</c:if>
						</div>
				</div>
			</c:forEach>
		</div>
		<div class="infoBox col margin-bottom-3">
			<div class="title font-22 margin-rigth-2">경력 &nbsp;<b id="careerMonth" class="font-14 green bold-5"></b></div>
			<c:forEach var="VO" items="${rsmCareerVOList}" varStatus="stut" >
				<div class="row conBox">
					<div class="basText-xs font-15 margin-rigth-1">
						<div class="margin-bottom-1">
							${VO.careerJncmpYmd.substring(0,4)}.${VO.careerJncmpYmd.substring(4,6)} 
							<c:choose>
								<c:when test="${VO.careerRetireYmd != null }">
									~ ${VO.careerRetireYmd.substring(0,4) }.${VO.careerRetireYmd.substring(4,6) }
								</c:when>
								<c:otherwise>
									~ 재직중
								</c:otherwise>
							</c:choose>
						</div>
						<c:set var="retireYear" value="${VO.careerRetireYmd.substring(0,4)}"/>
						<c:set var="jncmpYear" value="${VO.careerJncmpYmd.substring(0,4)}"/>
						<c:set var="retireMonth" value="${VO.careerRetireYmd.substring(4,6)}"/>
						<c:set var="jncmpMonth" value="${VO.careerJncmpYmd.substring(4,6)}"/>
						
						<c:if test="${VO.careerRetireYmd != null && 
						              (retireYear - jncmpYear) * 12 + 
						              (retireMonth - jncmpMonth) > 0}">
						    <div class="gray font-14 bold-4">
						        ${ (retireYear - jncmpYear) * 12 + (retireMonth - jncmpMonth) } 개월
						    </div>
						</c:if>

					</div>
					<div class="basText-xl">
						<div class="margin-bottom-3 font-18 bold-7 ">
							<b class="margin-rigth-2">${VO.careerEntNm }</b><b class="gray font-14 bold-5">${VO.careerDept } · ${VO.careerDtyCdNm } · ${VO.careerJbgdCdNm }</b>
						</div>
						<div class="margin-bottom-2">
							${VO.careerTask }
						</div>
						<div class="font-15 bold-5 gray">
							<c:if test="${VO.careerWorkRgnCdNm !=null }">
								근무지역 &nbsp; (${VO.careerWorkRgnCdNm })
							</c:if>
						</div>
					</div>
				</div>
			</c:forEach>
		</div>
		<div class="infoBox col margin-bottom-3">
			<div class="title font-22 margin-rigth-2">경험/활동/교육 &nbsp;<b id="actMonth" class="font-14 green bold-5"></b></div>
			<c:forEach var="VO" items="${rsmExpactEDCVOList}" varStatus="stut" >
				<div class="row conBox" >
					<div class="basText-s font-15 margin-rigth-1">
						<div>
							${VO.actBeginYmd.substring(0,4)}.${VO.actBeginYmd.substring(4,6)}.${VO.actBeginYmd.substring(6,8)}
							<c:choose>	
								<c:when test="${VO.actEndYmd != null }">
									~ ${VO.actEndYmd.substring(0,4) }.${VO.actEndYmd.substring(4,6) }.${VO.actEndYmd.substring(6,8)}
								</c:when>
								<c:otherwise>
									~ 활동중
								</c:otherwise>
							</c:choose>
							<c:set var="endYear" value="${VO.actEndYmd.substring(0,4)}"/>
							<c:set var="beginYear" value="${VO.actBeginYmd.substring(0,4)}"/>
							<c:set var="endMonth" value="${VO.actEndYmd.substring(4,6)}"/>
							<c:set var="beginMonth" value="${VO.actBeginYmd.substring(4,6)}"/>
							
							<c:if test="${VO.actEndYmd != null && 
							              (endYear - beginYear) * 12 + 
							              (endMonth - beginMonth) > 0}">
							    <div class="gray font-14 bold-4">
							        ${ (endYear - beginYear) * 12 + (endMonth - beginMonth) } 개월
							    </div>
							</c:if>

						</div>
					</div>
					<div class="basText-xl">
						<div class="margin-bottom-3 font-18 bold-7 ">
							<b class="margin-rigth-2">${VO.actNm}</b><b class="gray font-14 bold-5">${VO.actEngn}</b><b class="badge margin-rigth-2">${VO.actSeCdNm }</b>
						</div>
						<div class="basText-xl">${VO.actCn }</div>
					</div>
				</div>
			</c:forEach>
		</div>
		<div class="infoBox col margin-bottom-3">
			<div class="title font-22 margin-rigth-2">자격증</div>
			<c:forEach var="VO" items="${rsmCertificateVOList}" varStatus="stut" >
				<div class="row conBox">
					<div class="basText-xs font-15 margin-rigth-2">
						${VO.crtfctAcqsYm.substring(0,4) }.${VO.crtfctAcqsYm.substring(4,6) }
					</div>
					<div class="basText-l margin-right-1 font-18 bold-7" >
						<b class="margin-rigth-2">${VO.crtfctNm }</b> &nbsp;
						<b class="black font-14 bold-5 ">
							<c:if test="${VO.crtfctAcqsSeCd == 'CLW001'}">
								<c:if test="${VO.crtfctScr != null}">
									${VO.crtfctScr}점
								</c:if>
								${VO.crtfctAcqsSeNm} &nbsp; &nbsp; | &nbsp; &nbsp;
							</c:if>
							<c:if test="${VO.crtfctAcqsSeCd == 'CLW002'}">
								<c:if test="${VO.crtfctScr != null}">
									${VO.crtfctScr}점
								</c:if>
								${VO.crtfctAcqsYnNm}
							</c:if>
						</b>
						 
						<b class="gray font-14 bold-5">${VO.crtfctPblcnoffic}</b>
					<b class="badge margin-rigth-2">${VO.crtfctAcqsSeCdNm }</b>
				</div>
			</div>
			</c:forEach>
		</div>
		<div class="infoBox col margin-bottom-3">
			<div class="title font-22 margin-rigth-2">포트폴리오</div>
			<c:forEach var="VO" items="${rsmPrtVOList}" varStatus="stut" >
				<div class="row conBox">
					<div class="basText-l margin-right-1 font-18 bold-7" >
						<b class="badge margin-rigth-1">${VO.prtSeCdNm }</b>
						<b class="margin-rigth-2">${VO.prtTtl }</b>
					</div>
					<div class="basText-l margin-right-1 font-18 bold-7 margin-bottom-2" >
						<b class="black font-14 bold-5 "><a href="${VO.prtUrl }">${VO.prtUrl }</a></b>
						<c:forEach var="fileVO" items="${VO.fileDetailVOList }" varStatus="stut" >
							<b class="black font-14 bold-5 "><a href="/download?fileName=${fileVO.filePathNm }">${fileVO.orgnlFileNm }</a></b><br />
						</c:forEach>
					</div>
				</div>
			</c:forEach>
		</div>
		<div class="infoBox col margin-bottom-3">
			<div class="title font-22 margin-rigth-2">자기소개서</div>
			<c:forEach var="VO" items="${rsmClVOList}" varStatus="stut" >
				<div class="row conBox">
					<div class="basText-xl">
						<div class="margin-bottom-3">
							<b class="margin-bottom-3 font-18 bold-7">${VO.clTtl }</b>
						</div>
						<div>
							${VO.clCn }
						</div>
					</div>
				</div>
			</c:forEach>
		</div>
	</div>
</div>
