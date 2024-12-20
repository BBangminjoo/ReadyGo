<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<script type="text/javascript" src="/resources/js/sweetalert2.js"></script>
<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/admAlert.css" />
<sec:authentication property="principal" var="prc"/>
<!-- 비로그인 또는 로그인한 사용자가 'admin'이 아닐 때 접근 금지 메시지를 표시하거나 리디렉션 -->
<sec:authorize access="!isAuthenticated() or principal.username != 'admin'">
    <script>
    Swal.fire({
        icon: 'warning',
        title: '접근 권한이 없습니다',
        showConfirmButton: false,
        timer: 2000 
    }).then(() => {
        window.location.href = "/"; 
    });
    </script>
</sec:authorize>
<!-- 외주 css 파일 -->
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/resources/css/board/admReviewmain.css" />
<script type="text/javascript">
$(document).ready(function() {
    $('.boardRegist').on('click', function(event) {
        var prcUsername = '${prc != "anonymousUser" ? prc.username : "anonymousUser"}';

        if (prcUsername === "anonymousUser") {
            event.preventDefault(); // 기본 폼 제출 막기
            Swal.fire({
                title: '로그인 후 작성 할 수 있습니다.',
                text: "로그인 페이지로 이동하시겠습니까?",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: 'white',
    	        cancelButtonColor: 'white',
                confirmButtonText: '이동',
                cancelButtonText: '취소',
              }).then((result) => {
                if (result.isConfirmed) {
                  window.location.href = "/security/login"
                }
              })
            return;
        } else {
            window.location.href = '/adm/review/reviewRegist';
        }
    });
    
 // select 박스 값 변경 시 폼 제출
    $('#selCategory').on('change', function() {
        $("#searchForm").submit(); // 폼 제출
	    });
	
	    // 페이지 로드 시 select 박스 값 유지 (JSTL로 처리)
	    var urlParams = new URLSearchParams(window.location.search);
	    var selectedOrder = urlParams.get('order');
	    if (selectedOrder) {
	        $('#selCategory').val(selectedOrder); // select 박스 값 설정
	    }
	
    
 
})
 
</script>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<div class="inquiryRow">
	<div class="registTitle">
		<h1>리뷰 게시판</h1>
	</div>
	<div class="sortingALl">
		<div class="count">
				<p id="count">
					전체&nbsp;&nbsp;<span id="total">${articlePage.total}</span>
				</p>
			<br>
		</div>
		<form id="searchForm" action="/adm/review/reviewList" method="GET">
		    
		    <div class="sorting">
		        <select id="selCategory" name="order">
		            <option value="" selected disabled>선택해주세요</option>
		            <option value="rnum" >최신순</option>
		            <option value="views">조회순</option>
		        </select>
		    </div>
		</form>
	</div>
	<div class="card_body table_responsive p_0">
		<table>
			<thead>
				<tr style="background:#f3f3f3; border-top: 2px solid #232323;">
					<th class="number" style="width: 10%;">번호</th>
					<th class="mainImg" style="width: 15%;">구입한 상품</th>
					<th class="mainImg" style="width: 2%;"></th>
					<th class="contTitle" style="width: 33%;">제목</th>
					<th class="write" style="width: 15%;">작성일자</th>
					<th class="write" style="width: 15%;">작성자</th>
					<th class="cnt" style="width: 10%;">조회수</th>
				</tr>
			</thead>
			<c:forEach var="boardVO" items="${articlePage.content}"	varStatus="stat">
				<tbody>
					<tr style="border-bottom: 1px solid #ddd;">
						<td class="number">${boardVO.rnum}</td>
						<td class="entLogo"><a
							href="/adm/review/reviewDetail?seNo=5&pstSn=${boardVO.pstSn}"> <img
								class="outaouMainImg" src="${boardVO.outordMainFile}"
								alt="${boardVO.outordMainFile}" /></a></td>
						<td>
							<c:if test="${not empty boardVO.pstFile}">
							    <img class="FileLink"src="/resources/icon/FileLink.png" alt="파일첨부">
							</c:if>
						</td>
						<td class="ContTitle">
						<a href="/adm/review/reviewDetail?seNo=5&pstSn=${boardVO.pstSn}">${boardVO.pstTtl}</a>
						</td>
						<td class="write">${boardVO.pstWrtDt}</td>
						<td class="write">${boardVO.mbrId}</td>
						<td class="cnt">${boardVO.pstInqCnt}</td>
					</tr>
				</tbody>
			</c:forEach>
			<tfoot>
					<tr></tr>
				</tfoot>
		</table>

			<!-- ///////////////////// 페이징 ///////////////////// -->
		<div class="card-body table-responsive p-0"  style="display: flex; justify-content: center;">
			<table style="border-bottom: none;">
				<tr>
					<td colspan="4" style="text-align: center;">
						<div class="dataTables_paginate" id="example2_paginate"
							style="display: flex; justify-content: center; margin-top: 20px;">
							<ul class="pagination">

								<!-- 맨 처음 페이지로 이동 버튼 -->
								<c:if test="${articlePage.currentPage gt 1}">
									<li class="paginate_button page-item first"><a
										href="/adm/review/reviewList?currentPage=1&order=${param.order}"
										aria-controls="example2" data-dt-idx="0" tabindex="0"
										class="page-link">&lt;&lt;</a></li>
								</c:if>

								<!-- 이전 페이지 버튼 -->
								<c:if test="${articlePage.startPage gt 1}">
									<li class="paginate_button page-item previous"
										id="example2_previous"><a
										href="/adm/review/reviewList?currentPage=${(articlePage.startPage - 1) lt 1 ? 1 : (articlePage.startPage - 1)}&order=${param.order}"
										aria-controls="example2" data-dt-idx="0" tabindex="0"
										class="page-link">&lt;</a></li>
								</c:if>

								<!-- 페이지 번호 -->
								<c:forEach var="pNo" begin="${articlePage.startPage}"
									end="${articlePage.endPage}">
									<li
										class="paginate_button page-item ${pNo == articlePage.currentPage ? 'active' : ''}">
										<a
										href="/adm/review/reviewList?currentPage=${pNo}&order=${param.order}"
										aria-controls="example2" class="page-link">${pNo}</a>
									</li>
								</c:forEach>

								<!-- 다음 페이지 버튼 -->
								<c:if test="${articlePage.endPage lt articlePage.totalPages}">
									<li class="paginate_button page-item next" id="example2_next">
										<a
										href="/adm/review/reviewList?currentPage=${articlePage.startPage+5}&order=${param.order}"
										aria-controls="example2" data-dt-idx="7" tabindex="0"
										class="page-link">&gt;</a>
									</li>
								</c:if>

								<!-- 맨 마지막 페이지로 이동 버튼 -->
								<c:if
									test="${articlePage.currentPage lt articlePage.totalPages}">
									<li class="paginate_button page-item last"><a
										href="/adm/review/reviewList?currentPage=${articlePage.totalPages}&order=${param.order}"
										aria-controls="example2" data-dt-idx="7" tabindex="0"
										class="page-link">&gt;&gt;</a></li>
								</c:if>

							</ul>
						</div>
					</td>
				</tr>
			</table>
		</div>
	</div>

</div>












