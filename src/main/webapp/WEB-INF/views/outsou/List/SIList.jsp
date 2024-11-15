<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags"
	prefix="sec"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<!-- 외주 css 파일 -->
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/resources/css/outsou/list.css" />

<script type="text/javascript">

$(function() {


    // 인기순 클릭 시
    $("#btnRdcnt").on("click", function() {
        $("#ord").val('rdcnt'); // 'rdcnt'로 정렬 설정
        $("#searchForm").submit(); // 폼 제출
    });

    // 등록순 클릭 시
    $("#btnWrtde").on("click", function() {
        $("#ord").val('wrtde'); // 'wrtde'로 정렬 설정
        $("#searchForm").submit(); // 폼 제출
    });

});
</script>


<div class="submainAll">
	<div class="catnm">
	<!-- 
	action 이 생략 : 현재 URL을 재요청
	method가 생략 : get
	
	/outsou/SIList?outordMlsfc=OULC01-001&currentPage=1&srvcLevelCd=&srvcTeamscaleCd=&ord=rdcnt
	 -->
	<form id="searchForm" method="GET" action="/outsou/SIList">
		 <input type="hidden" name="outordMlsfc" value="${param.outordMlsfc}" />
	    <input type="hidden" name="currentPage" value="${param.currentPage}" />
	    <input type="hidden" id="ord" name="ord" value="${param.ord}" />
	    	
		    <c:choose>
		        <c:when test="${param.outordMlsfc == 'OULC02-001'}">
		        	   <p>국내자기소개서</p>
		        </c:when>
		        <c:when test="${param.outordMlsfc == 'OULC02-002'}">
		          	 <p>해외자기소개서</p>
		        </c:when>
		        <c:when test="${param.outordMlsfc == 'OULC02-003'}">
		            <p>대학입시</p>
		        </c:when>
		        <c:otherwise>
		            <p>자기소개서</p>
		        </c:otherwise>
	    </c:choose>


		<div class="ArryOP">
			<!--정렬
			인기순 클릭
			 - jquery로 <input type="text" id="ord" .. 요소에 접근하여 value를 rdcnt로 변경
			 - <form id="searchForm"> 요소에 접근하여 submit
			등록순 클릭
			 - jquery로 <input type="text" id="ord" .. 요소에 접근하여 value를 wrtde로 변경
			 - <form id="searchForm"> 요소에 접근하여 submit
			 -->
			<input type="button" class="trigger-btn" id="btnRdcnt" name="btnRdcnt" value="인기순"/><!-- 파라미터에 &ord=rdcnt -->
			<input type="button" class="trigger-btn" id="btnWrtde" name="btnWrtde" value="등록순"/><!-- 파라미터에 &ord=wrtde -->
		</div>
	</form>
	</div>
</div>


<div class="newtboxAll">
	<div class="newtbox">
		<!-- 게시글 목록 -->
		<c:forEach var="getDetailVO" items="${articlePage.content}">
			<div class="item_box">
				<div class="plus"></div>
				<a class="item_thum"
					href="/outsou/detail?outordNo=${getDetailVO.outordNo}"> <img
					src="${getDetailVO.outordMainFile}"
					alt="${getDetailVO.outordMainFile}" class="product-image" id="pImg" />
				</a> <a class="item_tit"
					href="/outsou/detail?outordNo=${getDetailVO.outordNo}">
					${getDetailVO.outordTtl} </a>
				<div class="item_info_wrap clear">
					<div class="item_info">
						<hr class="outhr">
						<p class="price">
							<fmt:formatNumber pattern="#,###"
								value="${getDetailVO.outordAmt}" />원
						</p>
					</div>
				</div>
			</div>
		</c:forEach>
	</div>
</div>

<!-- 페이지 처리 -->
<!-- 페이지네이션 -->
<div class="card-body table-responsive p-0"
	style="display: flex; justify-content: center;">
<table style="margin-bottom: 30px;">
	<tr>
		<td colspan="4" style="text-align: center;">
			<div class="dataTables_paginate" id="example2_paginate"
				style="display: flex; justify-content: center; margin-top: 20px;">
				<ul class="pagination">
					
					<!-- 
					param : outordMlsfc=OULC01-001
					 -->
					
					<!-- 맨 처음 페이지로 이동 버튼 -->
					<c:if test="${articlePage.currentPage gt 1}">
						<li class="paginate_button page-item first"><a
							href="/outsou/SIList?outordMlsfc=${param.outordMlsfc}&ord=${param.ord}"
							aria-controls="example2" data-dt-idx="0" tabindex="0"
							class="page-link">&lt;&lt;</a></li>
					</c:if>

					<!-- 이전 페이지 버튼 -->
					<c:if test="${articlePage.startPage gt 1}">
						<li class="paginate_button page-item previous"
							id="example2_previous"><a
							href="/outsou/SIList?outordMlsfc=${param.outordMlsfc}&currentPage=${(articlePage.startPage - 1) lt 1 ? 1 : (articlePage.startPage - 1)}&ord=${param.ord}"
							aria-controls="example2" data-dt-idx="0" tabindex="0"
							class="page-link">&lt;</a></li>
					</c:if>

					<!-- 페이지 번호 -->
					<c:forEach var="pNo" begin="${articlePage.startPage}"
						end="${articlePage.endPage}">
						<li
							class="paginate_button page-item ${pNo == articlePage.currentPage ? 'active' : ''}">
							<a
							href="/outsou/SIList?outordMlsfc=${param.outordMlsfc}&currentPage=${pNo}&ord=${param.ord}"
							aria-controls="example2" class="page-link">${pNo}</a>
						</li><!-- SRLE01_SRLE02_SRLE03 -->
					</c:forEach>

					<!-- 다음 페이지 버튼 -->
					<c:if test="${articlePage.endPage lt articlePage.totalPages}">
						<li class="paginate_button page-item next" id="example2_next">
							<a
							href="/outsou/SIList?outordMlsfc=${param.outordMlsfc}&currentPage=${articlePage.startPage+5}&ord=${param.ord}"
							aria-controls="example2" data-dt-idx="7" tabindex="0"
							class="page-link">&gt;</a>
						</li>
					</c:if>

					<!-- 맨 마지막 페이지로 이동 버튼 -->
					<c:if
						test="${articlePage.currentPage lt articlePage.totalPages}">
						<li class="paginate_button page-item last"><a
							href="/outsou/SIList?outordMlsfc=${param.outordMlsfc}&currentPage=${articlePage.totalPages}&ord=${param.ord}"
							aria-controls="example2" data-dt-idx="7" tabindex="0"
							class="page-link">&gt;&gt;</a></li>
					</c:if>

					</ul>
				</div>
			</td>
		</tr>
	</table>
</div>













