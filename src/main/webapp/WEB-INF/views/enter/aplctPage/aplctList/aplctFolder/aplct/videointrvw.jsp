<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>면접관리 > 화상면접방 생성</title>
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/resources/css/enter/videointrvw.css" />
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>

<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/alert.css" />
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<script type="text/javascript">
var Toast = Swal.mixin({
	toast: true,
	position: 'center',
	showConfirmButton: false,
	timer: 3000
	});



//모달 제어
document.addEventListener("DOMContentLoaded", function() {
    var modal = document.getElementById("scoutModal");
    var calButtons = document.querySelectorAll(".cal-btn");
    var closeBtn = document.querySelector(".close");
    var cancelButton = document.getElementById("cancel-btn");

    // 모든 "스카우트 제안하기" 버튼에 클릭 이벤트 추가
    calButtons.forEach(function(button) {
        button.addEventListener("click", function() {
            modal.style.display = "block";
        });
    });

    // 닫기 버튼 클릭 시 모달 닫기
    closeBtn.onclick = function() {
    	 $('#scoutModal').find('input[type="text"], input[type="password"], input[type="number"], input[type="datetime-local"], input[type="hidden"]').val('');
         
         // 기본값이 있는 필드 초기화 (예: 최대 인원수)
         $('#vcrMaxjoincount').val(4); // 기본값 4로 초기화
        modal.style.display = "none";
    }

    // 취소 버튼 클릭 시 모달 닫기
    cancelButton.onclick = function() {
    	 $('#scoutModal').find('input[type="text"], input[type="password"], input[type="number"], input[type="datetime-local"], input[type="hidden"]').val('');
         
         // 기본값이 있는 필드 초기화 (예: 최대 인원수)
         $('#vcrMaxjoincount').val(4); // 기본값 4로 초기화
        modal.style.display = "none";
    }

    // 모달 외부 클릭 시 모달 닫기
    window.onclick = function(event) {
        if (event.target == modal) {
        	 $('#scoutModal').find('input[type="text"], input[type="password"], input[type="number"], input[type="datetime-local"], input[type="hidden"]').val('');
             
             // 기본값이 있는 필드 초기화 (예: 최대 인원수)
             $('#vcrMaxjoincount').val(4); // 기본값 4로 초기화
            modal.style.display = "none";
        }
    }
});


$(function() {
var entId = $("#entId").val();
	$(document).on('click', '#canBtn', function() {
		
		// Swal.fire 사용하여 수정 확인창 표시
		Swal.fire({
		    title: '삭제하시겠습니까?',
		    icon: 'error',
		    showCancelButton: true,
		    confirmButtonColor: 'white',
		    cancelButtonColor: 'white',
		    confirmButtonText: '예',
		    cancelButtonText: '아니오'
		}).then((result) => {
		    if (result.isConfirmed) {
		    	vcrRoomid = $(this).closest('tr').find('#vcrRoomid').val();
				vcrNo = $(this).closest('tr').find('#vcrNo').val();
					var obj = {vcrRoomid : vcrRoomid,vcrNo:vcrNo};
					var jsonObj = JSON.stringify(obj);
					
					console.log(vcrRoomid);
					console.log(vcrNo);
					console.log(jsonObj);

					$.ajax({
						url : "/video/deleteroom",
						type : "POST",
						data : jsonObj,
						contentType : "application/json;charset=UTF-8",
						dataType : "json",
						beforeSend:function(xhr){
							xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
						},
						success : function(res) {
							console.log(res);
							if(res>0){
								Toast.fire({
						            icon: 'success',
						            title: '삭제 완료!',
						            customClass: {
								        popup: 'my-custom-popup'  // CSS에서 정의한 클래스 이름
								    } 
						            
						        });						
							}else{
								Toast.fire({
									icon:'error',
									title:'삭제 실패',
						            customClass: {
								        popup: 'my-custom-popup'  // CSS에서 정의한 클래스 이름
								    } 
								});
							}
							location.href="/enter/videointrvw?entId="+entId;
								}
					})
		        
		    } else {
		        // 수정 취소 시
		        Toast.fire({
		            icon: 'error',
		            title: '삭제 취소!',
		            customClass: {
				        popup: 'my-custom-popup'  // CSS에서 정의한 클래스 이름
				    } 
		        });
		    }
		});
		
		
		
		
	})
	
	$(document).on('click', '.btnopen', function() {
			value = $(this).closest('tr').find('#vcrRoomid').val();
			entId = $('#entId').val();
			var obj = {value : value,entId:entId};
			var jsonObj = JSON.stringify(obj);
			
			console.log(value);
			console.log(jsonObj);
			
			
			Swal.fire({
				  title: '입장하시겠습니까?',
				  icon: 'question',
				  showCancelButton: true,
				  confirmButtonColor: 'white',
				  cancelButtonColor: 'white',
				  confirmButtonText: '예',
				  cancelButtonText: '아니오',
				  reverseButtons: false, // 버튼 순서 거꾸로
				}).then((result) => {
				  if (result.isConfirmed) {
					  $.ajax({
							url : "/video/connectroom",
							type : "POST",
							data : jsonObj,
							contentType : "application/json;charset=UTF-8",
							dataType : "json",
							beforeSend:function(xhr){
								xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
							},
							success : function(res) {
								console.log(res)
								window.open(res.data.url);
							}
						})
			          
				  }
				})	
	})
	
	$('#vcrStart').on('change',function(){
		let d = $('#vcrStart').val();
		vcrDate=d.substr(0,10);
		console.log(d);
		$("#vcrDate").val(vcrDate);
		let sdate = new Date(d);
		// 문자열을 Date 객체로 변환
		const date = new Date(sdate);

		// 연도, 월, 일, 시, 분 추출
		const year = date.getFullYear();
		const month = (date.getMonth() + 1).toString().padStart(2, '0'); // 월은 0부터 시작하므로 1을 더해줌
		const day = date.getDate().toString().padStart(2, '0');
		const hours = date.getHours().toString().padStart(2, '0');
		const minutes = date.getMinutes().toString().padStart(2, '0');

		// yyyyMMdd 형식으로 변환
		const formattedDate = year+"-"+month+"-"+day+" "+hours+":"+minutes;
		console.log(formattedDate);
		$("#vcrStartdateNo").val(formattedDate);
		
		
		const sdateString = sdate.toString();
		sdate = sdateString.replace("GMT","");
		sdate = sdate.substring(0,30).trim();
		sdate = encodeURIComponent(sdate);
		console.log(sdate);
		$("#vcrStartdate").val(sdate);
	})
	
	$('#vcrEnd').on('change', function() {
   		 // Date 객체로 변환
   		let ed = $('#vcrEnd').val();
	    let edate = new Date(ed);
	    
	    const date = new Date(edate);

		// 연도, 월, 일, 시, 분 추출
		const year = date.getFullYear();
		const month = (date.getMonth() + 1).toString().padStart(2, '0'); // 월은 0부터 시작하므로 1을 더해줌
		const day = date.getDate().toString().padStart(2, '0');
		const hours = date.getHours().toString().padStart(2, '0');
		const minutes = date.getMinutes().toString().padStart(2, '0');

		// yyyyMMdd 형식으로 변환
		const formattedDate = year+"-"+month+"-"+day+" "+hours+":"+minutes;
		console.log(formattedDate);
		$("#vcrEnddateNo").val(formattedDate);	    
	    
		const edateString = edate.toString();
		edate = edateString.replace("GMT","");
		edate = edate.substring(0,30).trim();
		edate = encodeURIComponent(edate);
		console.log(edate);
	    $("#vcrEnddate").val(edate);
	})
	
	
	$("select[name='gubun']").on("change", function() {
		//this : <select name="gubun"
		let gubun = $(this).val();
		let entId = "${param.entId}"; //test01 또는 null

		console.log("gubun : ", gubun);
		console.log("entId : ", entId);

		// /enter/scout?entId=test01&gubun=new
		// param : entId=test01&gubun=new
		//요청URI를 새로 요청
		location.href = "/enter/videointrvw?entId=" + entId + "&gubun=" + gubun;
	});
	
	
	$(document).on("click", "#submit-btn", function(event) {
		event.preventDefault(); // 기본 폼 전송 방지
		$("#scoutForm").attr("action", "/video/videointrvwPost");

		// Swal.fire 사용하여 수정 확인창 표시
		Swal.fire({
		    title: '등록하시겠습니까?',
		    icon: 'question',
		    showCancelButton: true,
		    confirmButtonColor: 'white',
		    cancelButtonColor: 'white',
		    confirmButtonText: '예',
		    cancelButtonText: '아니오'
		}).then((result) => {
		    if (result.isConfirmed) {
		        // 수정 확인 시 폼 전송
		       
		        Toast.fire({
		            icon: 'success',
		            title: '등록 완료!',
		            customClass: {
				        popup: 'my-custom-popup'  // CSS에서 정의한 클래스 이름
				    } 
		        }).then((result) => {
		        	 $("#scoutForm").submit();
		    	});
		    } else {
		        // 수정 취소 시
		        Toast.fire({
		            icon: 'error',
		            title: '등록 취소!',
		            customClass: {
				        popup: 'my-custom-popup'  // CSS에서 정의한 클래스 이름
				    } 
		        });
		    }
		});
		});
	
	
	
	
})
</script>
</head>
<body>

	<sec:authentication property="principal" var="prc" />
	<div class="announcement-container">
		<div
				style="display: flex; align-items: baseline; margin-bottom: 10px;">
			<div><h2 style="margin: 0px 0px 0px;">화상면접방 관리</h2></div>
			<div><p class="total">전체  <b>${total}</b></p></div>
		</div>
		<div class="search-box">
			<!-- 셀렉트 박스 -->
			<div class="sel-cls">
				<div class="select-search">
					<select name="gubun" class="gubun-select" onchange="filterApplicants3()">
						<option value=""selected disabled>면접 구분선택</option>
						<option value="" <c:if test="${param.gubun eq ''}">selected</c:if>>면접 구분</option>
					
						<option value="complete" <c:if test="${param.gubun eq 'complete'}">selected</c:if>>면접 완료</option>
						<option value="inProgress"<c:if test="${param.gubun eq 'inProgress'}">selected</c:if>>면접 진행중</option>
						<option value="inComplete"<c:if test="${param.gubun eq 'inComplete'}">selected</c:if>>면접 진행전</option>
					</select>
				</div>			

			</div>
			<!-- 검색  -->
			<form action="/enter/videointrvw" method="get">
				<div class="search">
					<input type="hidden" id="entId" name="entId"
						value="${prc.username}" />
					<input type="text" id="keywordInput" name="keywordInput"
						placeholder="방제목 입력" />
					<div class="select-search">
						<select name="dataInputType" class="gubun-select">
							<option value="" <c:if test="${param.dataInputType eq ''}">selected</c:if>>면접 일자</option>
							<option value="start" <c:if test="${param.dataInputType eq 'start'}">selected</c:if>>시작시간</option>
							<option value="end"<c:if test="${param.dataInputType eq 'end'}">selected</c:if>>마감시간</option>
						</select>
					</div>
					<input type="date" id="dateInput" name="dateInput"
						placeholder="면접일 선택" />
					<button type="submit">검색</button>
					<sec:csrfInput />
				</div>
			</form>
			<!-- 검색 -->
		</div>

		<table>
			<thead>
				<tr style="background: #f3f3f3; border-top: 2px solid #232323;">
					<th >번호</th>
					<th class="pbTitle" >공고제목</th>
					<th class="leftTitle">화상방 제목</th>
					<th >시간</th>
					<th >화상방 상태</th>
					<th >삭제</th>
					<th >입장</th>
				</tr>
			</thead>
			<tbody>
			<c:if test="${not empty articlePage.content}">
			<c:forEach varStatus="stat" var="videoRoomVO" items="${articlePage.content}">
				<tr>
					
					
					<td class="th-center"><input type="hidden" id="vcrNo" name="vcrNo" value="${videoRoomVO.vcrNo}"/>
						<input type="hidden" id="vcrRoomid" name="vcrRoomid" value="${videoRoomVO.vcrRoomid}"/>${videoRoomVO.rnum}
					</td>
					<td class="th-center" style="text-align: left;">${videoRoomVO.pbancTtl}</td>
					<td>
						<div class="aplctIN">
							<div class="aplctName">
								<div>${videoRoomVO.vcrTitle}</div>
							</div>
						</div>
					</td>
					<td style="text-align: center;">
								<div class="aplctTp">시작 : ${videoRoomVO.vcrStartdate} </div>
								<div class="aplctTp">마감 : ${videoRoomVO.vcrEnddate} </div>
<%-- 							<p>접속중인 인원 : 0/${videoRoomVO.vcrMaxjoincount} </p> --%>
					</td>
					<td>
						<p style="text-align: center;font-size:14px;color:#212529">${videoRoomVO.status}</p>
					</td>
					<td style="text-align: center;">
						<button class="btndel" id="canBtn" type="button">삭제</button>
					</td>
					<td style="text-align: center;">
						<button class="btnopen" type="button">입장</button>						
					</td>
				</tr>
			</c:forEach>
			</c:if>
			<c:if test="${empty articlePage.content}">
				<tr><td colspan="7">검색 조건이 없습니다.</td></tr>
			</c:if>
			</tbody>
           <tfoot>
			</tfoot>
			
		</table>
		<div class="btnclass">
        		<button class="cal-btn">화상면접방 생성</button>
		</div>
		<!-- 페이지네이션 -->
		<div class="card-body table-responsive p-0"
			style="display: flex; justify-content: center;">
			<table>
				<tr>
					<td class="pageTable" colspan="4" style="text-align: center;">
						<div class="dataTables_paginate" id="example2_paginate"
							style="display: flex; justify-content: center; margin-top: -40px;">
							<ul class="pagination">

								<!-- 맨 처음 페이지로 이동 버튼 -->
								<c:if test="${articlePage.currentPage gt 1}">
									<li class="paginate_button page-item first"><a
										href="/enter/videointrvw?entId=${prc.username}&currentPage=1"
										aria-controls="example2" data-dt-idx="0" tabindex="0"
										class="page-link">&lt;&lt;</a></li>
								</c:if>

								<!-- 이전 페이지 버튼 -->
								<c:if test="${articlePage.startPage gt 1}">
									<li class="paginate_button page-item previous"
										id="example2_previous"><a
										href="/enter/videointrvw?entId=${prc.username}&currentPage=${(articlePage.startPage - 1) lt 1 ? 1 : (articlePage.startPage - 1)}"
										aria-controls="example2" data-dt-idx="0" tabindex="0"
										class="page-link">&lt;</a></li>
								</c:if>

								<!-- 페이지 번호 -->
								<c:forEach var="pNo" begin="${articlePage.startPage}"
									end="${articlePage.endPage}">
									<li
										class="paginate_button page-item ${pNo == articlePage.currentPage ? 'active' : ''}">
										<a
										href="/enter/videointrvw?entId=${prc.username}&currentPage=${pNo}"
										aria-controls="example2" class="page-link">${pNo}</a>
									</li>
								</c:forEach>

								<!-- 다음 페이지 버튼 -->
								<c:if test="${articlePage.endPage lt articlePage.totalPages}">
									<li class="paginate_button page-item next" id="example2_next">
										<a
										href="/enter/videointrvw?entId=${prc.username}&currentPage=${articlePage.startPage+5}"
										aria-controls="example2" data-dt-idx="7" tabindex="0"
										class="page-link">&gt;</a>
									</li>
								</c:if>

								<!-- 맨 마지막 페이지로 이동 버튼 -->
								<c:if
									test="${articlePage.currentPage lt articlePage.totalPages}">
									<li class="paginate_button page-item last"><a
										href="/enter/videointrvw?entId=${prc.username}&currentPage=${articlePage.totalPages}"
										aria-controls="example2" data-dt-idx="7" tabindex="0"
										class="page-link">&gt;&gt;</a></li>
								</c:if>

							</ul>
						</div>
					</td>
				</tr>
			</table>
		</div>
		<!-- 페이지네이션 끝 -->
		
		</div>
		<!-- 모달 창 구조 -->
				<div id="scoutModal" class="modal" style="display: none;">
					<div class="modal-content">
						<div class="modal-header">
							<div>
								<p class="fast-list">화상방 생성</p>
							</div>
							<div>
								<span class="close">&times;</span>
							</div>
						</div>
						<form id="scoutForm" action="/video/videointrvwPost" method="post">
							<input type="hidden" id="entId"name="entId" value="${prc.username}" >
							<div class="content-input">
								<div>
									<label for="vcrTitle" class="scout-title">
									<span class="red">*</span> 공고 선택</label>
									<select id="pbancNo" name="pbancNo" class="vidInput">
										<option value="" disabled selected>공고를 선택해주세요.</option>
										<!-- 공고 리스트를 JSP에서 동적으로 추가 -->
										<c:forEach var="pbanc" items="${pbancList}">
											<option value="${pbanc.pbancNo}">${pbanc.pbancTtl}</option>
										</c:forEach>
									</select>
								</div>
								<div>
									<label for="vcrTitle" class="scout-title">
									 <span class="red">*</span> 화상방 제목</label>
									<input type="text" id="vcrTitle" name="vcrTitle" class="vidInput">
								</div>
								<div style="display: flex; align-items: center;">
									<div style="display: flex; flex-direction: column;">
										<label for="vcrRoomurlid" id="vcrRoomurlids" class="scout-title">
										<span class="red">*</span> 화상방 경로</label>
										<input type="text" id="vcrRoomurlid" name="vcrRoomurlid" class="vidInput">
									</div>
									<input type="button" id="vcrRoomurlidchk" value="중복검사">
								</div>
								
								<div style="display: flex;flex-direction: row;justify-content: space-between;">
									<div style="width: 240px;">
										<label for="vcrMaxjoincount" class="scout-title">
										<span class="red">*</span> 면접 최대 인원(최소4)</label>
										<input type="number" id="vcrMaxjoincount" name="vcrMaxjoincount" value="4" class="vidInput">
									</div>
									<div style="display: flex; flex-direction: column;">
										<label for="vcrPasswd" id="vcrPasswds" class="scout-title">
										<span class="red">*</span> 비밀번호</label>
										<input type="password" id="vcrPasswd" name="vcrPasswd" class="vidInput">
									</div>
								</div>
								
								<div style="display: flex; flex-direction: row;justify-content: space-between;">
									<div style="margin-right:20px;">
										<label for="vcrStartdate" class="scout-title">
										<span class="red">*</span> 시작일자/시간</label>
										<input type="datetime-local" id="vcrStart" name="vcrStart" class="vidInput">
										<input type="hidden" id="vcrStartdateNo" name="vcrStartdateNo">
										<input type="hidden" id="vcrStartdate" name="vcrStartdate">
									</div>
									<div>
										<label for="vcrEnddate" class="scout-title">
										<span class="red">*</span> 종료일자/시간</label>
										<input type="datetime-local" id="vcrEnd" name="vcrEnd" class="vidInput">
										<input type="hidden" id="vcrEnddateNo" name="vcrEnddateNo">
										<input type="hidden" id="vcrEnddate" name="vcrEnddate">
									</div>
									<input id="vcrDate" name="vcrDate" type="hidden">
								</div>
						 		<div
									style="display: flex; justify-content: space-evenly; margin-top: 50px;">
									<button type="button" id="cancel-btn">취소</button>
									<button type="submit" id="submit-btn">등록</button>
								</div>
							</div>
							<sec:csrfInput />
						</form>
					</div>
				</div>
</body>
</html>
