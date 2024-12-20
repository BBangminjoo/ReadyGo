<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>   
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>   

<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
<link rel="stylesheet" href="<%=request.getContextPath() %>/resources/css/member/aplctList.css" />
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script> 
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<script>
$(function(){
  $(".aplctPrcsStatCd").each(function() {
    let aplctPrcsNm = $(this).text().trim(); 
    
    if (aplctPrcsNm === '미평가') {
      $(this).css({
        'color': '#666363',
        'background-color': 'rgb(244 244 244)',
        'width':'70px',
        'height':'38.4px',
        'display': 'inline-block',
        'padding-top':'9px',
      });
    } 
    else if(aplctPrcsNm === '서류합격'){
	  $(this).css({
        'color': '#24D59E',
        'background-color': '#e8faf8;',
        'width':'70px',
        'height':'38.4px',
	  });
    }
    else if(aplctPrcsNm === '최종합격'){
	  $(this).css({
        'color': '#24D59E',
        'background-color': '#e8faf8;',
        'width':'70px',
        'height':'38.4px',
	  });
    }
    else{
    	 $(this).css({
	        'color': 'rgb(255 112 112)',
	        'background-color': 'rgb(255 150 150 / 29%)',
	        'width':'70px',
	        'height':'38.4px',
    	});
      }
    
  });
  
//   $(".pbanc-ttl").on("click",function(){
// 	  var pbancNo = $(this).data("pbancno");
// 	  window.location.href = '/enter/pbancDetail?pbancNo=' + pbancNo; 
//   })
  
//pdf다운로드
	//data-rsm-no="24"
	//클래스 속성의 값이 pdfDownAlink인 요소들 중에서 클릭한 바로 그 요소(this)의 data
	$(".pdfDownAlink").on("click",function(){
		let rsmNo = $(this).data("rsmNo");
		var popup = window.open('', '이력서 보기', 'width=1,height=1');
		//밖으로 꺼낸 폼의 text박스의 값으로 대입
		$("#frmRsmNo").val(rsmNo);
		//<form id="frm"
		$("#frm").attr("target", '이력서 보기');
		$("#frm").submit();
	});
});

</script>
<form id="frm" action="/member/resumeDownload" method="post">
	<input type="hidden" name="rsmNo" id="frmRsmNo" value="" />
	<sec:csrfInput/>
</form>
<br>
<div class="container"  style="position: relative; bottom: 35px;">
	<p id="h3">입사 지원 현황</p>
	<br><br>
	<p id="count">전체&nbsp;&nbsp;<span id="total">${articlePage.total}</span></p><br>
	<div class="row" id="topbox">
		<div class="box" id="fir">미평가<p class="num">${getNotTotal}</p></div>
		<div class="box" id="ing">서류합격<p class="num2">${getDocTotal}</p></div>
		<div class="box" id="fin">최종합격<p class="num3">${getFinTotal}</p></div>
		<div class="box" id="bad">불합격<p class="num4">${getBadTotal}</p></div>
	</div>
	<div id="filter">
		
		<form id="filterForm" action="/member/aplctList" method="GET" style="height: 55px;">
		<select id="apstSel" name="state">
			<option value="" <c:if test="${param.state==''}">selected</c:if> selected>전체</option>
			<c:forEach var="apstCd" items="${apstVOList}">
				<option value="${apstCd.comCode}"
				 <c:if test="${param.state==apstCd.comCode}">selected</c:if>>${apstCd.comCodeNm}</option>
			</c:forEach>
		</select>
		<div style="position: relative; right: 310px; top: 40px;">
			<input type="date" id="dateInput1" name="dateInput1">&nbsp;~&nbsp;

			<input type="date" id="dateInput2" name="dateInput2">
		</div>	
			<div style="position: relative; top: 1px;">
				<input type="text" id="keywordInput" name="keywordInput"
					placeholder="검색" value="${param.keywordInput}">
				<button class="search" type="submit">검색</button>
				<span class="material-symbols-outlined" id="sricon">search</span>
			</div>
		</form>
	</div>
	<div class="card-body table-responsive p-0">
				<table class="table table-hover text-nowrap">
				<thead>
					<tr>
						<th>지원일자</th>
						<th class="entNm" style="font-size: 16px;">기업명</th>
						<th class="aplct">지원내역</th>
						<th>지원상태</th>
					</tr>
				</thead>
				<tbody>
				<c:choose>
				<c:when test="${not empty articlePage.content}">
				<c:forEach var="aplctVO" items="${articlePage.content}" varStatus="stat">
					<tr style="border-bottom: 1px solid #dee2e6;">
						<td class="appymd"><fmt:formatDate value="${aplctVO.aplctAppymd}" pattern="yyyy.MM.dd"/></td>
						<td class="entNm">${aplctVO.entNm}</td>
						
						<td class="aplct">
						<span class="pbanc-ttl" data-pbancno="${aplctVO.pbancNo}">
						<a target="_blank" href="/enter/pbancDetail?pbancNo=${aplctVO.pbancNo}">${aplctVO.pbancTtl}</a></span><br>
							<span class="material-symbols-outlined">clinical_notes</span>
							<span>
							<a id="aplcont1" class="pdfDownAlink" data-rsm-no="${aplctVO.rsmNo}">${aplctVO.rsmTtl}</a></span>
										   &nbsp;&nbsp;&nbsp;
					        <span class="material-symbols-outlined">clinical_notes</span>
					        <span>
								<c:choose>
		                            <c:when test="${not empty aplctVO.fileDetailVOList}">
		                                <c:forEach var="file" items="${aplctVO.fileDetailVOList}">
		                                   <a href="/download?fileName=${file.filePathNm}">
							                    <span id="aplcont2">${file.orgnlFileNm}</span>
							                </a>
		                                </c:forEach>
		                            </c:when>
		                            <c:otherwise>
		                                <span id="aplcont2">-</span>
		                            </c:otherwise>
	                       	    </c:choose>
					        </span>
								&nbsp;&nbsp;&nbsp;
							<span id="aplcont3">지원분야 : ${aplctVO.rcritNm}</span>			   
						</td>
						
						<td><span id="aplctPrcsStatCd" class="aplctPrcsStatCd">${aplctVO.aplctPrcsNm}</span></td>
					</tr>
					</c:forEach>
					</c:when>
				<c:otherwise>
					<tr>
						<td id="noSrc"colspan="4">검색 결과가 없습니다.</td>
					</tr>
				</c:otherwise>
			</c:choose>
				</tbody>
				<c:if test="${not empty articlePage.content}">
				<tfoot>
					<tr>
						<td colspan="4" style="text-align: center; border-top: 1px solid #232323">
							<div class="dataTables_paginate" id="example2_paginate"
								style="display: flex; justify-content: center; margin-top:20px;">
								<ul class="pagination">
													<br>
								<!-- 맨 처음 페이지로 이동 버튼 -->
								<c:if test="${articlePage.currentPage gt 1}">
								    <li class="paginate_button page-item first">
								        <a href="/member/aplctList?mbrId=${param.mbrId}&currentPage=1&keywordInput=${param.keywordInput}&state=${param.state}&dateInput1=${param.dateInput1}&dateInput2=${param.dateInput2}"
								           aria-controls="example2" data-dt-idx="0" tabindex="0" class="page-link">&lt;&lt;</a>
								    </li>
								</c:if>

									<!-- 이전 페이지 버튼 -->
									<c:if test="${articlePage.startPage gt 1}">
									    <li class="paginate_button page-item previous" id="example2_previous">
									         <a href="/member/aplctList?mbrId=${param.mbrId}&currentPage=${(articlePage.startPage - 1) lt 1 ? 1 : (articlePage.startPage - 1)}&currentPage=1&keywordInput=${param.keywordInput}&state=${param.state}&dateInput1=${param.dateInput1}&dateInput2=${param.dateInput2}"
									           aria-controls="example2" data-dt-idx="0" tabindex="0" class="page-link">&lt;</a>
									    </li>
									</c:if>
									
									<!-- 페이지 번호 -->
									<c:forEach var="pNo" begin="${articlePage.startPage}" end="${articlePage.endPage}">
									    <li class="paginate_button page-item ${pNo == articlePage.currentPage ? 'active' : ''}">
									        <a href="/member/aplctList?mbrId=${param.mbrId}&currentPage=${pNo}&currentPage=1&keywordInput=${param.keywordInput}&state=${param.state}&dateInput1=${param.dateInput1}&dateInput2=${param.dateInput2}" 
									        aria-controls="example2" class="page-link">${pNo}</a>
									    </li>
									</c:forEach>
									
									<!-- 다음 페이지 버튼 -->
									<c:if test="${articlePage.endPage lt articlePage.totalPages}">
									    <li class="paginate_button page-item next" id="example2_next">
									        <a href="/member/aplctList?mbrId=${param.mbrId}&currentPage=${articlePage.startPage+5}&currentPage=1&keywordInput=${param.keywordInput}&state=${param.state}&dateInput1=${param.dateInput1}&dateInput2=${param.dateInput2}"
									           aria-controls="example2" data-dt-idx="7" tabindex="0" class="page-link">&gt;</a>
									    </li>
									</c:if>
									
									<!-- 맨 마지막 페이지로 이동 버튼 -->
								<c:if test="${articlePage.currentPage lt articlePage.totalPages}">
								    <li class="paginate_button page-item last">
								        <a href="/member/aplctList?mbrId=${param.mbrId}&currentPage=${articlePage.totalPages}&currentPage=1&keywordInput=${param.keywordInput}&state=${param.state}&dateInput1=${param.dateInput1}&dateInput2=${param.dateInput2}"
								           aria-controls="example2" data-dt-idx="7" tabindex="0" class="page-link">&gt;&gt;</a>
								    </li>
								</c:if>

								</ul>
							</div>
						</td>
					</tr>
				</tfoot>
				</c:if>
		</table>
		</div>

</div>

