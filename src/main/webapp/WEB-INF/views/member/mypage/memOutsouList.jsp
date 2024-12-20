<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>   
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>   
<sec:authorize access="isAuthenticated()">
	<sec:authentication property="principal.memVO" var="priVO" />
</sec:authorize>
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
<link rel="stylesheet" href="<%=request.getContextPath() %>/resources/css/member/memOutsouList.css" />
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script> 
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<script type="text/javascript" src="/resources/js/sweetalert2.js"></script>
<script>
//sweetAlert 창 띄우기 변수
var Toast = Swal.mixin({
	    toast: true,
	    position: 'center',
	    showConfirmButton: false,
	    timer: 3000
	});
</script>

<br>
<div class="container" style="position: relative; bottom: 35px;">
   <p id="h3">등록한 외주 목록</p>
   <br><br>
<%--    <p>${setleVOList}</p> --%>
   <p id="count">전체&nbsp;&nbsp;<span id="total">${articlePage.total}</span></p><br>
   <div id="filter">
   		<form id="filterForm" action="/member/memOutsouList" method="GET">
   	
   		<div style="position: relative;top: 40px; right: 325px;">
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
                  <th class="outordTtl" style="left: 4px;">외주</th>
                  <th class="outordTtl"></th>
                  <th class="setleAmt">외주금액</th>
                  <th class="setleYmd">작성일자</th>
                  <th class="outordUpdde">수정일자</th>
                  <th class="outordUpdde">조회수</th>
               </tr>
            </thead>
            <tbody>
			<c:choose>
				 <c:when test="${not empty articlePage.content}">         
		            <c:forEach var="outsouVO" items="${articlePage.content}" varStatus="stat">
		               <tr style="border-bottom: 1px solid #dee2e6;"> 
		               		<td><img class="outImg" src="${outsouVO.outordMainFile}" alt="${outsouVO.outordMainFile}" style="width: 50%;"/></td>     
<!-- 		               		<td><img class="logo" src="/resources/images/member/토끼.jpg" alt="토끼.jpg"/></td>      -->
		               		<td style="text-align:left; position: relative; right: 30px;">
		               		<a target="_blank" id="outordTtl" href="/outsou/detail?outordNo=${outsouVO.outordNo}">${outsouVO.outordTtl}</a><br>   	
		               			<span class="outcont1">${outsouVO.outordLclsfNm}</span>&nbsp;&nbsp;<span class="outcont1">|</span>&nbsp;&nbsp;
		               			<span class="outcont1">${outsouVO.outordMlsfcNm}</span>
		               		</td>          
		               		<td id="selteAmt"><fmt:formatNumber value="${outsouVO.outordAmt}" pattern="#,###"/>원</td>          
		               		<td id="outordWrtde"><fmt:formatDate value="${outsouVO.outordWrtde}" pattern="yyyy.MM.dd"/></td>
		               		<td id="outordUpdde">
							    <c:choose>
							        <c:when test="${not empty outsouVO.outordUpdde}">
							            <fmt:formatDate value="${outsouVO.outordUpdde}" pattern="yyyy.MM.dd"/>
							        </c:when>
							        <c:otherwise>
							            -
							        </c:otherwise>
							    </c:choose>
							</td>
		               		<td id="outordRdcnt">${outsouVO.outordRdcnt}</td>
		               </tr>
		               </c:forEach>
               		</c:when>
               		<c:otherwise>
               		<tr>
						<td id="noSrc"colspan="6">검색 결과가 없습니다.</td>
					</tr>
               		</c:otherwise>
               </c:choose>  
            </tbody>
            <!-- ///////////////////// 페이징 ///////////////////// -->
            <c:if test="${not empty articlePage.content}">
            <tfoot>
               <tr>
                  <td colspan="6" style="text-align: center; border-top: 1px solid #666363;">
                    <div class="dataTables_paginate" id="example2_paginate"
							style="display: flex; justify-content: center; margin-top: 10px;">
							<ul class="pagination">
								<br>
								<!-- 맨 처음 페이지로 이동 버튼 -->
								<c:if test="${articlePage.currentPage gt 1}">
									<li class="paginate_button page-item first"><a
										href="/member/memOutsouList?mbrId=${param.mbrId}&currentPage=1&keywordInput=${param.keywordInput}&dateInput1=${param.dateInput1}&dateInput2=${param.dateInput2}"
										aria-controls="example2" data-dt-idx="0" tabindex="0"
										class="page-link">&lt;&lt;</a></li>
								</c:if>

								<!-- 이전 페이지 버튼 -->
								<c:if test="${articlePage.startPage gt 1}">
									<li class="paginate_button page-item previous"
										id="example2_previous"><a
										href="/member/memOutsouList?mbrId=${param.mbrId}&currentPage=${(articlePage.startPage - 1) lt 1 ? 1 : (articlePage.startPage - 1)}&keywordInput=${param.keywordInput}&dateInput1=${param.dateInput1}&dateInput2=${param.dateInput2}"
										aria-controls="example2" data-dt-idx="0" tabindex="0"
										class="page-link">&lt;</a></li>
								</c:if>

								<!-- 페이지 번호 -->
								<c:forEach var="pNo" begin="${articlePage.startPage}"
									end="${articlePage.endPage}">
									<li
										class="paginate_button page-item ${pNo == articlePage.currentPage ? 'active' : ''}">
										<a
										href="/member/memOutsouList?mbrId=${param.mbrId}&currentPage=${pNo}&keywordInput=${param.keywordInput}&dateInput1=${param.dateInput1}&dateInput2=${param.dateInput2}"
										aria-controls="example2" class="page-link">${pNo}</a>
									</li>
								</c:forEach>

								<!-- 다음 페이지 버튼 -->
								<c:if test="${articlePage.endPage lt articlePage.totalPages}">
									<li class="paginate_button page-item next" id="example2_next">
										<a
										href="/member/memOutsouList?mbrId=${param.mbrId}&currentPage=${articlePage.startPage+5}&keywordInput=${param.keywordInput}&dateInput1=${param.dateInput1}&dateInput2=${param.dateInput2}"
										aria-controls="example2" data-dt-idx="7" tabindex="0"
										class="page-link">&gt;</a>
									</li>
								</c:if>

								<!-- 맨 마지막 페이지로 이동 버튼 -->
								<c:if
									test="${articlePage.currentPage lt articlePage.totalPages}">
									<li class="paginate_button page-item last"><a
										href="/member/memOutsouList?mbrId=${param.mbrId}&currentPage=${articlePage.totalPages}&keywordInput=${param.keywordInput}&dateInput1=${param.dateInput1}&dateInput2=${param.dateInput2}"
										aria-controls="example2" data-dt-idx="7" tabindex="0"
										class="page-link">&gt;&gt;</a></li>
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

