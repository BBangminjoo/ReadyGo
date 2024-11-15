<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/security/tags"
	prefix="sec"%>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>

<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/alert.css" />
<!-- 로그인한 회원의 정보 가져오기  -->
<sec:authorize access="isAuthenticated()">
	<sec:authentication property="principal.memVO" var="memVO" />
</sec:authorize>
<!-- 외주 css 파일 -->
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/resources/css/outsou/detail.css" />
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script><!-- 웹소켓 -->
<script>
var Toast = Swal.mixin({
	toast: true,
	position: 'center',
	showConfirmButton: false,
	timer: 3000
});

$(function() {
		
		// 더보기 텍스트 클릭시 이벤트
		$(".more-text").on("click",function() {
				$(this).parent().find(".text-wrapper").css('display','inline-block');
				$(this).parent().find("#more-text").hide(); //더보기 가리기
				$(this).parent().find("#less-text").show(); //쥴이기 보이기
			})
		// 줄이기 텍스트 클릭시 이벤트
		$(".less-text").on("click",function() {
			$(this).parent().find(".text-wrapper").css('display','-webkit-box');
			$(this).parent().find("#more-text").show(); //더보기 가리기
			$(this).parent().find("#less-text").hide(); //쥴이기 보이기
		})
		// 더보기 텍스트 클릭시 이벤트
		$(".more-text").on("click",function() {
			$(this).parent().find(".img-wrapper").css('display','inline-block');
			$(this).parent().find("#more-text").hide(); //더보기 가리기
			$(this).parent().find("#less-text").show(); //쥴이기 보이기
		})
		// 줄이기 텍스트 클릭시 이벤트
		$(".less-text").on("click",function() {
			$(this).parent().find(".img-wrapper").css('display',
					'-webkit-box');
			$(this).parent().find("#more-text").show(); //더보기 가리기
			$(this).parent().find("#less-text").hide(); //쥴이기 보이기
		})

		// jQuery로 접기/펼치기 기능
	    $('.collapsible').click(function() {
	        const content = $(this).next('.collapsible-content');
	        const arrow = $(this).find('.arrow'); // 화살표 span을 찾음
	
	        content.slideToggle(); // 내용을 슬라이드로 보이거나 숨김
	        arrow.text(arrow.text() === '▲' ? '▼' : '▲'); // 화살표 모양을 변경
	    });

		//가격정보  보이기 
		$(".prcont").on("click",function() {
			$(".tab-contentAll").hide();
			$(".price_content").show();
			$(".prcont").css("background-color", "#24D59E").css("color", "#fff").css("border-bottom","2px solid #24D59E");
			$(".active").css("background-color", "#ffffff").css("color", "#24D59E").css("border-bottom","2px solid #ffffff");
		})
		//상세 정보 보이기 
		$(".active").on("click",function() {
				$(".tab-contentAll").show();
				$(".price_content").hide();
				$(".active").css("background-color", "#24D59E").css("color", "#fff").css("border-bottom","2px solid #24D59E");
				$(".prcont").css("background-color", "#ffffff").css("color", "#24D59E").css("border-bottom","2px solid #ffffff");
		})

		//가격 설명 설정을 위함	
		$(document).ready(function() {
			// 문장을 불러와서 줄바꿈을 <br>로 변환
			let container = $(".text-container");
			let text = container.html();

			// 줄바꿈(\n)을 <br>로 변환
			let updatedText = text.replace(/\n/g, "<br>");

			// 첫 번째 줄을 추출
			let firstLineEndIndex = updatedText.indexOf('<br>'); // 첫 번째 줄 끝에 <br>이 있는지 확인
			let firstLine = '';
			let remainingText = '';

			if (firstLineEndIndex !== -1) {
				// <br>이 존재할 때, 첫 번째 줄을 가져오고 나머지 텍스트 분리
				firstLine = updatedText.substring(0,firstLineEndIndex); // 첫 번째 줄 추출
				remainingText = updatedText.substring(firstLineEndIndex); // 나머지 텍스트 추출
			} else {
				// <br>이 없으면 전체 텍스트를 첫 번째 줄로 처리
				firstLine = updatedText;
			}

			// remainingText에서 '.'이나 '-'를 기준으로 줄바꿈을 허용하기 위해 <wbr> 태그 추가
		    remainingText = remainingText.replace(/(\.|-)/g, '$1<wbr>');
			// 첫 번째 줄만 굵게 처리한 후 다시 HTML 설정
			container.html('<strong>' + firstLine + '</strong>'+ 
					'<span style="word-break: keep-all;">' + remainingText + '</span>');
		});
		
		
		
		//수정하기 버튼 클릭시 
		$("#savebtn").on("click", function() {
			Swal.fire({
		        title: '수정하시겠습니까? ',
		        icon: 'question',
		        showCancelButton: true,
		        confirmButtonColor: 'white',
		        cancelButtonColor: 'white',
		        confirmButtonText: '예',
		        cancelButtonText: '아니오'
		    }).then((result) => {
		        // 사용자가 "예"를 선택했을 경우에만 동작
		        if (result.isConfirmed) {
		            // 외주 번호를 URL 파라미터로 함께 전달
		            let outordNo = '${outsouVO.outordNo}';  // JSP에서 외주 번호를 올바르게 전달받아야 합니다.
		            window.location.href = "/outsou/updatePost?outordNo=" + outordNo;
		        }
		    });
		});
							

		//삭제하기
		$("#cancel").on("click", function() {
			Swal.fire({
				  title: '삭제하시겠습니까?',
				  icon: 'question',
				  showCancelButton: true,
				  confirmButtonColor: 'white',
				  cancelButtonColor: 'white',
				  confirmButtonText: '예',
				  cancelButtonText: '아니오',
				  reverseButtons: false, // 버튼 순서 거꾸로
				}).then((result) => {
					if (result.isConfirmed) {
					    let formData = new FormData();
					    
					    let outsouNo = $("#outordNo").val(); // 외주 번호 값을 가져옴
					    console.log("outordNo -> ", outsouNo); // 값 확인용 로그
					    
					    formData.append("outordNo", outsouNo); // 올바르게 변수 outsouNo를 사용
			
					    $.ajax({
					        url: "/outsou/deletePost",
					        processData: false,
					        contentType: false,
					        data: formData,
					        type: "post",
					        dataType: "json",
					        beforeSend: function(xhr) {
					            xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}"); // CSRF 토큰 설정
					        },
					        success: function(result) {
					            console.log("result : ", result);
					            
					            if (result > 0) {
						  				Toast.fire({
						  					icon:'success',
						  					title:'삭제가 완료되었습니다.  '
						  				});
						  				
						  				//3초 후 이동 
						  				setTimeout(function(){
						  					 window.location.href = "/outsou/main";
						  				},3000);  
					            } else {
					                alert("삭제되지 않았습니다.");
					            }
					        },
					        error: function(xhr, status, error) {
					            console.error("AJAX 요청 실패: ", status, error);
					            alert("삭제 요청 중 오류가 발생했습니다.");
					        }
					    });
					}

			});
		});	
	// 스크롤 이벤트 감지하여 일정 높이 이상 스크롤되면 Top 버튼 표시
	$(window).scroll(function() {
		if ($(this).scrollTop() > 200) {
			$('#topBtn').fadeIn();
		} else {
			$('#topBtn').fadeOut();
		}
	});
	
	// Top 버튼 클릭 시 페이지 상단으로 부드럽게 이동
	$('#topBtn').click(function() {
		$('html, body').animate({
			scrollTop : 0
		}, 'slow');
		return false;
	});

	
	
});
</script>

<input type="text" value="${memVO.mbrId}" style="display: none;" />
<div class="detail">
	<form name="deleteForm" id="deleteForm" action="/outsou/deletePost" method="post">
	<!-- hidden input을 사용하여 삭제할 outordNo를 전달 -->
    <input type="hidden" name="outordNo" id="outordNo" value="${outsouVO.outordNo}" />
    
    <button id="topBtn" class="top-btn" style="display:none; position:fixed; bottom:20px; right:260px;">TOP ▲</button>
		<div class="dettit">
			<p>
				${outsouVO.outordLclsfNm} >  
				<c:if test="${outsouVO.outordMlsfc == 'OULC01-001' || outsouVO.outordMlsfc == 'OULC01-002' || outsouVO.outordMlsfc == 'OULC01-003'}">
					<a href="/outsou/WebList">웹제작</a> > 
				</c:if>
				<c:if test="${outsouVO.outordMlsfc == 'OULC01-004' || outsouVO.outordMlsfc == 'OULC01-005' || outsouVO.outordMlsfc == 'OULC01-006'}">
					<a href="/outsou/PGList">프로그램</a> > 
				</c:if>
				<c:if test="${outsouVO.outordMlsfc == 'OULC01-007' || outsouVO.outordMlsfc == 'OULC01-008' || outsouVO.outordMlsfc == 'OULC01-009'}">
					<a href="/outsou/DataList">데이터</a> > 
				</c:if>
				<c:if test="${outsouVO.outordMlsfc == 'OULC01-010' || outsouVO.outordMlsfc == 'OULC01-011' || outsouVO.outordMlsfc == 'OULC01-012' || outsouVO.outordMlsfc == 'OULC01-013'}">
					<a href="/outsou/AIList">AI</a> > 
				</c:if>
				<c:if test="${outsouVO.outordMlsfc == 'OULC01-014' || outsouVO.outordMlsfc == 'OULC01-015' || outsouVO.outordMlsfc == 'OULC01-016'}">
					<a href="/outsou/JobList">직무직군</a> > 
				</c:if>
				<c:if test="${outsouVO.outordMlsfc == 'OULC02-001' || outsouVO.outordMlsfc == 'OULC02-002' || outsouVO.outordMlsfc == 'OULC03-003'}">
					<a href="/outsou/SIList">자기소개서</a> > 
				</c:if>
				${outsouVO.outordMlsfcNm}
<%-- 				<p>조회수 중가 :${outsouVO.outordRdcnt} </p> --%>
			</p>
		</div>

		<div class="detcontent">
			<!-- 상품정보 -->
			<div class="left-section">
				<!-- /////////// 메인 이미지 시작 ///////////// 
			, fileDetailVOList=[
		 		FileDetailVO(fileGroupSn=null, gubun=MAIN, fileSn=0, orgnlFileNm=null, strgFileNm=null, filePathNm=/upload/outsou/mainFile/2024/09/25/da95d79e-09a4-4b21-8098-264c36b59c5d_이미지 등록.png, fileSz=0, fileExtnNm=null, fileMime=null, fileFancysize=null, fileStrgYmd=null, fileDwnldCnt=0), FileDetailVO(fileGroupSn=null, gubun=DETAIL, fileSn=0, orgnlFileNm=null, strgFileNm=null, filePathNm=/upload/outsou/detailFile/2024/09/25/24f913b1-a57e-482e-89e0-3f8a7ace9324_404.jpg, fileSz=0, fileExtnNm=null, fileMime=null, fileFancysize=null, fileStrgYmd=null, fileDwnldCnt=0), FileDetailVO(fileGroupSn=null, gubun=DETAIL, fileSn=0, orgnlFileNm=null, strgFileNm=null, filePathNm=/upload/outsou/detailFile/2024/09/25/657dae26-e9c4-443a-a89d-f4632fde1627_500.jpg, fileSz=0, fileExtnNm=null, fileMime=null, fileFancysize=null, fileStrgYmd=null, fileDwnldCnt=0), FileDetailVO(fileGroupSn=null, gubun=DETAIL, fileSn=0, orgnlFileNm=null, strgFileNm=null, filePathNm=/upload/outsou/detailFile/2024/09/25/f95035ca-3e9d-40f3-bbca-e85aa9c9c6eb_ReadyUp-로고.png, fileSz=0, fileExtnNm=null, fileMime=null, fileFancysize=null, fileStrgYmd=null, fileDwnldCnt=0), FileDetailVO(fileGroupSn=null, gubun=DETAIL, fileSn=0, orgnlFileNm=null, strgFileNm=null, filePathNm=/upload/outsou/detailFile/2024/09/25/30cf28a1-f1e5-4a04-a1b4-8e289901fd71_scj.jpg, fileSz=0, fileExtnNm=null, fileMime=null, fileFancysize=null, fileStrgYmd=null, fileDwnldCnt=0), FileDetailVO(fileGroupSn=null, gubun=DETAIL, fileSn=0, orgnlFileNm=null, strgFileNm=null, filePathNm=/upload/outsou/detailFile/2024/09/25/83fd8508-5ca1-41c8-9f59-4dc68dae2bb3_sjh.jpg, fileSz=0, fileExtnNm=null, fileMime=null, fileFancysize=null, fileStrgYmd=null, fileDwnldCnt=0), FileDetailVO(fileGroupSn=null, gubun=DETAIL, fileSn=0, orgnlFileNm=null, strgFileNm=null, filePathNm=/upload/outsou/detailFile/2024/09/25/e1f99653-0268-42ea-9fe5-7c1d98f34764_외주 상세페이지 이미지.jpg, fileSz=0, fileExtnNm=null, fileMime=null, fileFancysize=null, fileStrgYmd=null, fileDwnldCnt=0)], fileGroupNo=null)
			-->
				<div class="mainimg">
					<!-- outsouVO.fileDetailVOList : List<FileDetailVO> -->
					<img src="${outsouVO.outordMainFile}"
						alt="${outsouVO.outordMainFile}" class="product-mainimage" id="pImg" />
					
				</div>
				<!-- /////////// 메인 이미지 끝 ////////////// -->
				<div class="tabs">
					<div class="tab-button active">제품 상세 설명</div>
					<div class="tab-button prcont">가격 정보</div>
				</div>
				<!-- 가격 제외 정보  -->
				<div class="tab-contentAll">
					<!-- 서비스 설명 (더보기/접기) -->
					<div class="tab-content">
						<h3>서비스 설명</h3>
						<div id="serviceDescFull" class="text-wrapper">
							<span class="text">${outsouVO.outordExpln}</span>
						</div>
						<input type="button" id="more-text" class="morebtn more-text"
							value="더보기" /> <input type="button" id="less-text"
							class="lessbtn less-text" value="접기" />

					</div>
					<!-- 서비스제공절차, 요구사항 (더보기/접기) -->
					<div class="tab-content">
						<div id="serviceDescFull" class="text-wrapper">
							<div class="sacont">
								<h3>서비스 제공 절차</h3>
								<span class="text">${outsouVO.outordProvdprocss}</span>
							</div>
							<div class="sacont">
								<h3>의뢰인 준비사항</h3>
								<span class="text">${outsouVO.outordDmndmatter}</span>
							</div>
							<!-- db에 저장 되어 있는 부분만 불러오기  -->

							<!-- 여러개인 경우 ? -->
							<div class="sacont">
								<!-- 기술수준 시작 -->
								<c:if test="${outsouVO.outordLclsf=='OULC01' && outsouVO.osDevalVO.srvcLevelNm != null}">
									<h5>기술 수준</h5>
									<div class="code">
										<div class="osdevalcode">
											<span><c:out value="${outsouVO.osDevalVO.srvcLevelNm}" /></span>
										</div>
									</div>
								</c:if>
								<!-- 팀 규모 -->
								<c:if test="${outsouVO.outordLclsf=='OULC01' && outsouVO.osDevalVO.srvcTeamscaleCd != null}">
									<h5>팀 규모</h5>
									<div class="code">
										<div class="osdevalcode">
											<span><c:out value="${outsouVO.osDevalVO.srvcTeamscaleNm}" /></span>
										</div>
									</div>
								</c:if>
								<!-- 개발언어 시작 -->
								<c:if test="${outsouVO.outordLclsf=='OULC01' && outsouVO.osDevalVO.osdeLangVOList[0].srvcLangNm != null}">
									<h5>개발 언어</h5>
									<div class="code">
										<c:forEach var="osdeLangVO" items="${outsouVO.osDevalVO.osdeLangVOList}"> 
								            <!-- srvcLangNm을 쉼표로 분리하여 반복 처리 -->
								            <c:set var="langList" value="${fn:split(osdeLangVO.srvcLangNm, ',')}" />
								            <c:forEach var="lang" items="${langList}">
								                <div class="osdevalcode">
								                    <span>${fn:trim(lang)}</span> <!-- 각 언어 개별 출력 -->
								                </div>
								            </c:forEach>
								        </c:forEach> 
										</div>
 								</c:if> 
 								<!-- 데이터 베이스 시작 -->
<%-- 								<c:if test="${osdeDatabaseVO.srvcDatabaseCd != null}"> --%>
								<c:if test="${outsouVO.outordLclsf=='OULC01'&& outsouVO.osDevalVO.osdeDatabaseVOList[0].srvcDatabaseNm != null}">
									<h5>데이터 베이스</h5>
									<div class="code">
										<c:forEach var="osdeDatabaseVO" items="${outsouVO.osDevalVO.osdeDatabaseVOList}"> 
								            <!-- srvcLangNm을 쉼표로 분리하여 반복 처리 -->
								            <c:set var="DBList" value="${fn:split(osdeDatabaseVO.srvcDatabaseNm, ',')}" />
								            <c:forEach var="DataBase" items="${DBList}">
								                <div class="osdevalcode">
								                    <span>${fn:trim(DataBase)}</span> <!--  개별 출력 -->
								                </div>
								            </c:forEach>
								        </c:forEach> 
										</div>
 								</c:if>
<%--  								</c:if> --%>
<!-- 								<!--클라우드 시작 -->
								<c:if test="${outsouVO.outordLclsf=='OULC01' && outsouVO.osDevalVO.osdeCludVOList[0].srvcCludNm != null}">
									<h5>클라우드</h5>
									<div class="code">
										<c:forEach var="osdeCludVO" items="${outsouVO.osDevalVO.osdeCludVOList}">
											<!-- srvcLangNm을 쉼표로 분리하여 반복 처리 -->
											<c:set var="cludList"
												value="${fn:split(osdeCludVO.srvcCludNm, ',')}" />
											<c:forEach var="clud" items="${cludList}">
												<div class="osdevalcode">
													<span>${fn:trim(clud)}</span>
													<!--  개별 출력 -->
												</div>
											</c:forEach>
										</c:forEach>
									</div>
								</c:if>
							</div>
						</div>
						<input type="button" id="more-text" class="morebtn more-text"
							value="더보기" /> <input type="button" id="less-text"
							class="lessbtn less-text" value="접기" />

					</div>
					<!-- 이미지(더보기/접기) -->
					<c:if test="${outsouVO.outordDetailFile!=null }">
						<div class="tab-content">
							<div id="refImageFull" class="img-wrapper">
								<c:forEach var="fileDetail" items="${outsouVO.fileDetailVOList}">
								 <c:if test="${fileDetail.filePathNm != '1'}">
									<img src="${fileDetail.filePathNm}" alt="Detail Image"
										class="product-detailimage" id="pImg" />
								</c:if>
								</c:forEach>
							</div>
							<input type="button" id="more-text" class="morebtn more-text"
								value="더보기" /> <input type="button" id="less-text"
								class="lessbtn less-text" value="줄이기" />
						</div>
					</c:if>

					<!-- 환불 규정 (접기/펼치기) -->
					<div class="tab-content2">
					    <h4 class="collapsible">
					        환불 규정 <span class="arrow">▼</span>
					    </h4>
					    <div class="collapsible-content" style="display: none;">
					        ${outsouVO.outordRefndregltn}
					    </div>
					</div>

				</div>
				<!--  가격 정보  -->
				<div class="price_content">
					<h3>가격 정보</h3>
					<div class="main_price">
						<div class="price1">
							<div class="price1_1">
								<span><fmt:formatNumber pattern="#,###"
										value="${outsouVO.outordAmt}" /></span>원 (VAT 포함)

								<p class="text-container">${outsouVO.outordAmtExpln}</p>
							</div>
							<div class="sedetail">
								<ul class="service-details">
									<c:if test="${outsouVO.osDevalVO.srvcFileprovdyn eq '1'}">
										<li>소스코드 제공 <span>&#10003;</span></li>
									</c:if>
									<c:if test="${outsouVO.osDevalVO.srvcSklladit != null}">
										<li>기능 추가 가능 수 <span>${outsouVO.osDevalVO.srvcSklladit}</span></li>
									</c:if>
									<c:if test="${outsouVO.osDevalVO.srvcJobpd != null}">
										<li>제작 소요일 <span>${outsouVO.osDevalVO.srvcJobpdNm}</span></li>
									</c:if>
									<c:if test="${outsouVO.osDevalVO.srvcUpdtnmtm != null }">
										<li>수정 가능 횟수<span>${outsouVO.osDevalVO.srvcUpdtnmtmNm}</span></li>
									</c:if>
								</ul>
							</div>
						</div>
						<div>
							<!-- 작성한 사람은 보일 필요가 없다고 생각하여 안보이게 처리함 -->
							<c:if test="${memVO.mbrId != outsouVO.mbrId}">					
							<a
								href="../outsou/paydetail?outordNo=${outsouVO.outordNo}">
								<button type="button" class="purchase-button1">구매하기</button>
							</a>
							</c:if>
						</div>
					</div>
				</div>
			</div>

			<div class="right-sectionAll">
			<div class="right-section">
				<div class="service-info">
					<h3>${outsouVO.outordTtl}</h3>
					<p class="title"><a href="/member/profile?mbrId=${outsouVO.mbrId}">${outsouVO2.mbrNm} &nbsp;&nbsp;&nbsp;(<fmt:formatDate value="${outsouVO.outordWrtde}" pattern="yyy.MM.dd"/>)</a></p>
					<hr>
					<div class="price">
						<span><fmt:formatNumber pattern="#,###"
								value="${outsouVO.outordAmt}" /></span>원
						<p>(VAT 포함)</p>
					</div>
					<p class="text-container">${outsouVO.outordAmtExpln}</p>
					<ul class="service-details">
						<c:if test="${outsouVO.osDevalVO.srvcFileprovdyn=='1'}">
							<li>소스코드 제공 <span>&#10003;</span></li>
						</c:if>
						<c:if test="${outsouVO.osDevalVO.srvcFileprovdyn != null}">
							<li>기능 추가 가능 <span>&#10003;</span></li>
						</c:if>
						<c:if test="${outsouVO.osDevalVO.srvcJobpd != null}">
							<li>제작 소요일 <span>${outsouVO.osDevalVO.srvcJobpdNm}</span></li>
						</c:if>
						<c:if test="${outsouVO.osDevalVO.srvcUpdtnmtm != null}">
							<li>수정 가능 횟수<span>${outsouVO.osDevalVO.srvcUpdtnmtmNm}</span></li>
						</c:if>
					</ul>
					<!-- 작성한 사람은 보일 필요가 없다고 생각하여 안보이게 처리함 -->
					<c:if test="${memVO.mbrId != outsouVO.mbrId}">
					<a href="../outsou/paydetail?outordNo=${outsouVO.outordNo}">
						<button type="button" class="purchase-button">구매하기</button>
					</a>
					</c:if>
				</div>
				<!-- 나중에 설정 로그인 사람과 작성자의 아이디를 비교 둘이 같을 떄만 보이게 함   -->
				<c:if test="${memVO.mbrId == outsouVO.mbrId}">
					<div id="editBox">
						<p>
							<input type="button" id="cancel" value="삭제" /> 
							<input type="button" id="savebtn" value="수정" />
						</p>
					</div>
				</c:if>
			</div>
			
			</div>
		</div>
		<sec:csrfInput/>
	</form>
</div>