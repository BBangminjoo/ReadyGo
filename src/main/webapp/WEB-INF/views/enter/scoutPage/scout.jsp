<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>스카우트 제안</title>
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/resources/css/enter/scout.css" />
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>

</head>
<body>
	<sec:authentication property="principal" var="prc" />
	<div class="announcement-container">
        <div style="display: flex;align-items: flex-end;margin-bottom: 10px;">
        	<h2>스카우트 제안</h2>
        	<p class="total">전체  <b>${total}</b></p>
        </div>
				<c:if test="${not empty scoutList}">
					<p>
						*&nbsp;스카우트를 제안받은 인재가 ${scoutList[0].entNm}에 입사
						지원을 하면 [ 지원자 관리 > <a href="/enter/listAplct?entId=${prc.username}"
							target="_blank" class="go-listAplct">지원자 리스트</a> ] 에서 구별된 배경색으로
						표시됩니다.
					</p>
				</c:if>
		<div class="search-box">
			<!-- 셀렉트 박스 -->
			<div class="sel-cls">
				<div class="select-search">
<!-- 					<select name="gubun" class="gubun-select"> -->
<!-- 						<option value="" selected disabled>신입/경력</option> -->
<!-- 						<option value="">전체</option> -->
<!-- 						<option value="RSCA01">신입</option> -->
<!-- 						<option value="RSCA02">경력</option> -->
<!-- 					</select> -->
					
						<select name="gubun" class="gubun-select">
							<option value="" disabled selected style="display:none;">신입/경력 선택</option>
							<option value="" >신입/경력</option>
							<option value="신입" <c:if test="${param.gubun eq '신입'}">selected</c:if>>신입</option>
							<option value="경력" <c:if test="${param.gubun eq '경력'}">selected</c:if>>경력</option>
						</select>					
				</div>
			</div>
			<!-- 검색  -->
			<form action="/enter/scout" method="get">
				<div class="search">
					<input type="hidden" id="entId" name="entId"
						value="${prc.username}" /> <input type="text" id="keywordInput"
						name="keywordInput" placeholder="지원자명 입력" /> 
						<button type="button" id="proposal-date">제안일자 입력</button>
						<input type="date" id="dateInput" name="dateInput" disabled />
					<button type="submit">검색</button>
					<sec:csrfInput />
				</div>
			</form>
			<!-- 검색 -->
		</div>
		
		<table>
			<thead>
				<a href="./excel.xls?entId=${prc.username}" class="excel-cls">
					<input type="hidden" id="entId" name="entId" value="${entId}">
					<img src="../resources/icon/download.png" class="scout-down-img"/>excel
				</a>
				<tr style="background: #ECECEC; border-top: 2px solid #232323;">
					<th style="width: 100px;">번호</th>
					<th class="th-left" style="width: 200px;">인재</th>
					<th class="th-left" style="width: 350px; padding: 6px;">제목</th>
					<th>제안일자</th>
					<th style="width: 100px;">제안서</th>
					<th style="width: 100px;">프로필</th>
				</tr>
			</thead>
			<tbody>
				<c:if test="${not empty articlePage.content}">
				<!-- articlePage.content : List<ProposalVO> -->
				<c:forEach var="proposalVO" items="${articlePage.content}"
					varStatus="status">
					<tr>
						<td style="text-align: center;">${proposalVO.rnum}</td>
						<td>
							<div class="aplctIN">
								<div class="aplctImg">
									<c:if test="${proposalVO.fileGroupSn eq null}">
										<img src="../resources/icon/인재.png">									
									</c:if>
									<c:if test="${proposalVO.fileGroupSn ne null}">
										<img src="${proposalVO.fileGroupSn}" alt="img">
									</c:if>
								</div>
								<div class="aplctName">
									<div class="title">${proposalVO.mbrNm}</div>
									<div class="sub">${proposalVO.mbrBrdt}세 ·
										${proposalVO.rsmCareerCd}</div>
								</div>
							</div>
						</td>
						<td>
							<div class="title">${proposalVO.propseTtl}</div>
						</td>
						<td class="ymd">${proposalVO.propseDates}</td>
						<td class="td-btn">
							<div class="btn">
								<button class="scout-button"
									data-title="${proposalVO.propseTtl}"
									data-jobpost="${proposalVO.propsePbancTtl}"
									data-content="${proposalVO.propseCn}"
									data-file="${proposalVO.fileGroupSn}">제안서</button>
							</div>
						</td>

						<td class="td-btn">
							<div class="btn">
								<button class="profileGo">
									<a class="go" href="/member/profile?mbrId=${proposalVO.mbrId}" target="_blank">프로필 </a>
								</button>
							</div>
						</td>
					</tr>
				</c:forEach>
				</c:if>
				<c:if test="${empty articlePage.content}">
					<tr><td colspan="6">검색 조건이 없습니다.</td></tr>
				</c:if>
			</tbody>
           <tfoot>
			    <tr style="border-bottom: 2px solid #232323;"></tr>
			</tfoot>			
		</table>
		<!-- 페이지네이션 -->
		<div class="card-body table-responsive p-0"
			style="display: flex; justify-content: center;">
			<table>
				<tr>
					<td class="pageTable" colspan="4" style="text-align: center;">
						<div class="dataTables_paginate" id="example2_paginate"
							style="display: flex; justify-content: center;">
							<ul class="pagination">

								<!-- 맨 처음 페이지로 이동 버튼 -->
								<c:if test="${articlePage.currentPage gt 1}">
									<li class="paginate_button page-item first"><a
										href="/enter/scout?entId=${prc.username}&currentPage=1"
										aria-controls="example2" data-dt-idx="0" tabindex="0"
										class="page-link">&lt;&lt;</a></li>
								</c:if>

								<!-- 이전 페이지 버튼 -->
								<c:if test="${articlePage.startPage gt 1}">
									<li class="paginate_button page-item previous"
										id="example2_previous"><a
										href="/enter/scout?entId=${prc.username}&currentPage=${(articlePage.startPage - 1) lt 1 ? 1 : (articlePage.startPage - 1)}"
										aria-controls="example2" data-dt-idx="0" tabindex="0"
										class="page-link">&lt;</a></li>
								</c:if>

								<!-- 페이지 번호 -->
								<c:forEach var="pNo" begin="${articlePage.startPage}"
									end="${articlePage.endPage}">
									<li
										class="paginate_button page-item ${pNo == articlePage.currentPage ? 'active' : ''}">
										<a
										href="/enter/scout?entId=${prc.username}&currentPage=${pNo}"
										aria-controls="example2" class="page-link">${pNo}</a>
									</li>
								</c:forEach>

								<!-- 다음 페이지 버튼 -->
								<c:if test="${articlePage.endPage lt articlePage.totalPages}">
									<li class="paginate_button page-item next" id="example2_next">
										<a
										href="/enter/scout?entId=${prc.username}&currentPage=${articlePage.startPage+5}"
										aria-controls="example2" data-dt-idx="7" tabindex="0"
										class="page-link">&gt;</a>
									</li>
								</c:if>

								<!-- 맨 마지막 페이지로 이동 버튼 -->
								<c:if
									test="${articlePage.currentPage lt articlePage.totalPages}">
									<li class="paginate_button page-item last"><a
										href="/enter/scout?entId=${prc.username}&currentPage=${articlePage.totalPages}"
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

	<!-- 모달 창 시작-->
	<div id="scoutModal" class="modal" style="display: none;">
		<div class="modal-content">
						<div style="display: flex;justify-content: space-between;
          					  background: linear-gradient(to right, #2CCFC3, #24D59E);height: 100px;border-top-left-radius: 8px; border-top-right-radius: 8px; ">
				<h2 class="scout-h2">스카우트 제안서</h2>
				<span class="close">&times;</span>
			</div>

			<c:if test="${not empty scoutList}">
				<div class="scout-div">
					<label for="title" class="scout-title"><span
						style="color: red;">*</span> 스카우트 제안 제목</label> 
						<input type="text" id="title"  disabled readonly>
				</div>

				<div class="scout-div">
					<label for="jobPost" class="scout-title">&nbsp;&nbsp;&nbsp;스카우트 제안 공고 </label> 
					<input type="text" id="jobPost"  disabled readonly>
				</div>

				<div class="scout-div">
					<label for="content" class="scout-title"><span
						style="color: red;">*</span> 스카우트 제안 내용 </label>
					<textarea id="content"  disabled readonly></textarea>
				</div>

				<div class="scout-div">
					<label for="file" class="scout-title">&nbsp;&nbsp;&nbsp;스카우트 제안 첨부파일</label> 
					<input type="file" id="file"style="display: none;" />
					<!-- 기본 파일 선택 숨김 -->
					<div id="file-name" class="file-name"></div>
					<!-- 파일명 표시용 요소 -->
				</div>
			</c:if>

			<div
				style="display: flex; justify-content: center; margin-top: 30px;">
				<input type="button" id="ok-btn" value="확인" />
			</div>
		</div>
	</div>
	<!-- 모달창 끝 -->
</body>
<script type="text/javascript">
	$(function() {
		//<select name="gubun"
		$("select[name='gubun']").on("change", function() {
			//this : <select name="gubun"
			let gubun = $(this).val();
			let entId = "${param.entId}"; //test01 또는 null

			console.log("gubun : ", gubun);
			console.log("entId : ", entId);

			// /enter/scout?entId=test01&gubun=new
			// param : entId=test01&gubun=new
			//요청URI를 새로 요청
			location.href = "/enter/scout?entId=" + entId + "&gubun=" + gubun;
		});

	});
	
    document.getElementById("proposal-date").addEventListener("click", function() {
        var dateInput = document.getElementById("dateInput");
        dateInput.disabled = false;  // 버튼 클릭 시 dateInput 활성화
        dateInput.focus();  // 활성화 후 바로 포커스 이동
    });
	//모달 제어
	document.addEventListener("DOMContentLoaded", function() {
		var modal = document.getElementById("scoutModal");
		var scoutButtons = document.querySelectorAll(".scout-button");
		var closeBtn = document.querySelector(".close");
		var okButton = document.getElementById("ok-btn");
		var fileInput = document.getElementById("file");
		var fileNameElement = document.getElementById("file-name");

		// 스카우트 제안서 버튼 클릭 시 모달 열기
		scoutButtons.forEach(function(button) {
			button.addEventListener("click", function() {
				// 모달에 데이터 설정
				document.getElementById("title").value = button
						.getAttribute("data-title");
				document.getElementById("jobPost").value = button
						.getAttribute("data-jobpost");
				document.getElementById("content").placeholder = button
						.getAttribute("data-content");

				// DB에서 가져온 파일명 설정
				var fileName = button.getAttribute("data-file");
				if (fileName) {
					fileInput.style.display = "none"; // 파일 선택 버튼 숨기기
					fileNameElement.innerText = fileName; // 파일명 표시
				} else {
					fileInput.style.display = "none"; // 파일 선택 버튼 보이기
					fileNameElement.innerText = "선택된 파일 없음"; // 기본 메시지 표시
				}

				// 모달 표시
				modal.style.display = "block";
			});
		});

		// 모달 닫기
		closeBtn.onclick = function() {
			modal.style.display = "none";
		}

		// 확인 버튼 클릭 시 모달 닫기
		okButton.onclick = function() {
			modal.style.display = "none";
		}

		// 모달 외부 클릭 시 모달 닫기
		window.onclick = function(event) {
			if (event.target == modal) {
				modal.style.display = "none";
			}
		}
	});
	
	$(document).ready(function(){
	    $(".excel-cls").click(function(){
	        // 서버에 GET 요청을 보내서 엑셀 파일 다운로드
	        window.location.href = '/enter/excel.xls?entId=${prc.username}';
	    });
	});
	
</script>
</html>
