<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<script type="text/javascript" src="/resources/ckeditor5/ckeditor.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/admAlert.css" />
<sec:authentication property="principal" var="prc"/>
<!-- 비로그인 또는 로그인한 사용자가 'admin'이 아닐 때 접근 금지 메시지를 표시하거나 리디렉션 -->
<sec:authorize access="!isAuthenticated() or principal.username != 'admin'">
    <script>
    Swal.fire({
        icon: 'error',
        title: '접근 권한이 없습니다',
        showConfirmButton: false,
        timer: 2000 
    }).then(() => {
        window.location.href = "/"; 
    });
    </script>
</sec:authorize>
<style>
body {
    margin: 0;
    padding: 0;
    font-family: pretendard;
    background-color: #fff;
}

.container2 {
    width: 80%;
    margin: 0 auto;
    margin-left: 400px;
}

table {
    width: 80%;
    border-collapse: collapse;
    margin-top: 20px;
    background-color: #fff;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

h1 {
    font-size: 28px;
    font-weight: bold;
    text-align: left;
    padding-top: 20px;
}

.search-container {
    display: flex;
    justify-content: center;
    margin-bottom: 10px;
}

input[type="text"] {
    width: 200px;
    padding: 10px;
    border: 1px solid #ccc;
    border-radius: 4px;
    margin-bottom: 10px;
}

.search-button, .filter-button {
    padding: 10px 20px;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    background-color: #FD5D6C;
    color: white;
    width: 120px;
    margin-left: 10px; /* 입력창과 버튼 사이의 간격 */
}

.filter-button {
    border: 1px solid #FD5D6C;
}

.filter-button:hover {
    background-color: white;
    color: #FD5D6C;
    border: 1px solid #FD5D6C; 
}

.pagination {
    display: flex;
    justify-content: center;
    margin: 20px 0;
}

.pagination a {
    border: 1px solid #ddd;
    padding: 5px 10px;
    color: black;
    border-radius: 5px;
    text-decoration: none;
}

.pagination a.active {
    background-color: #FD5D6C;
    color: white;
}

.pagination a:hover:not(.active) {
    background-color: #ddd;
}

.pagination-container {
    display: flex;
    justify-content: center; /* 가운데 정렬 */
    list-style-type: none; /* 목록 스타일 제거 */
    padding: 0; /* 기본 패딩 제거 */
}

.flex-container {
    display: flex;
    justify-content: space-between;
    gap: 20px;
}

.table1, .table2, .table3 {
    width: 48%;
    border: none; 
}
.table3 h3 {
    font-size: 20px;
    color: #FD5D6C;
    padding: 15px;
}

.table1 tbody tr:hover,
.table2 tbody tr:hover,
.table3 tbody tr:hover {
    background-color: rgba(253, 93, 108, 0.1);
    transition: background-color 0.3s ease;
}
header{
    margin-bottom: 50px;
}

.list-button{
    background-color: white;
    border: none;
}

.search-container {
    display: flex;
    justify-content: space-between; /* 컨테이너 내 요소들을 양 끝과 중간으로 분산 배치 */
    width: 100%; /* 전체 너비를 사용하도록 설정 */
}

.search-container1, .search-container2 {
    width: 49%; /* 왼쪽 컨테이너들의 너비 */
}

.search-container3 {
    width: 49%; /* 오른쪽 컨테이너의 너비 */
}
.search-pages .flex-row {
    display: flex; /* Flexbox 사용 설정 */
    justify-content: space-around; /* 요소들을 균등하게 분배 */
    align-items: center; /* 중앙 정렬 */
    width: 100%; /* 전체 너비 사용 */
}

.search-page1, .search-page2, .search-page3 {
    flex: 1; /* 각 요소가 동등한 공간을 차지하도록 설정 */
}
.pagination a {
    color: #FD5D6C;
    border: 1px solid #FD5D6C;
    padding: 5px 10px;
    margin: 0 5px;
    text-decoration: none;
    border-radius: 5px;
}

.pagination a:hover {
    background-color: #FD5D6C;
    color: white;
}

/* 활성 페이지 */
.pagination a.active {
    background-color: #FD5D6C;
    color: white;
}

.graybtn {
		background: white;
		color: #232323;
		border: 1px solid #B5B5B5;
		transition: all 0.3s ease 0s;
		border-radius: 5px;
}
.graybtn:hover {
	background: #ECECEC;
	border: 1px solid #B5B5B5;
}

.category {
    display: block;
    width: 100%;
    font-size: 1rem;
    font-weight: 400;
    line-height: 1.5;
    color: #495057;
    background-color: #fff;
    background-clip: padding-box;
    border-radius: 5px;
    box-shadow: inset 0 0 0 transparent;
    transition: border-color .15s ease-in-out, box-shadow .15s ease-in-out;
}
/* 페이징 css 시작*/
.page-link {
    color: black; 
    border-radius: 7px; 
    margin: 5px;
}

/* 버튼 클릭했을 때! */
.pagination a {
    border: 1px solid #ddd;
    padding: 5px 10px;
    color: black;
    border-radius: 5px;
    text-decoration: none;
}
.pagination.active .page-link {
    color: #FD5D6C;
    background-color: rgba(253, 93, 108, 0.11);
    border-color: #FD5D6C;
    border-radius: 7px;
}
.table3{
	height: 595px;
}
/* 테이블 머리 스타일 */
table thead th {
	background-color: rgba(253, 93, 108, 0.7) !important;
    color: white;
    padding: 10px;
    text-align: center;
}

/* 테이블 본문 스타일 */
table tbody td {
    padding: 10px;
    text-align: center;
    border-bottom: 1px solid #ddd;
}
/* 신고 회원목록 스타일 */
.table3 h3 {
	background-color: rgba(253, 93, 108, 0.7) !important;
    color: white;
    padding: 10px;
    text-align: left;
    border-radius: 5px;
    margin-bottom: 10px;
}
.flex-container .memTab, .flex-container .entTab {
    display: inline-block;
    width: 10px;
}

.flex-container {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
}

.list-button {
    background-color: white;
    color: #FD5D6C;
    border: 2px solid #FD5D6C;
    padding: 10px 20px;
    font-size: 16px;
    border-radius: 5px;
    transition: all 0.3s ease;
    width: 120px;
    text-align: center;
    cursor: pointer;
}

.list-button:focus {
    background-color: #FD5D6C;
    color: white;
    outline: none;
}

.list-button:active {
    background-color: #FD5D6C;
    color: white;
    border-color: #FD5D6C;
}

.list-button:hover {
    background-color: #FD5D6C;
    color: white;
    border-color: #FD5D6C;
}
.table1, .table2{
	height:595px;
}
.Search1, .Search2 {
    display: flex;
    justify-content: space-between;
    align-items: center;
    width: 100%;
}

.memSelect, .entSelect {
    display: flex;
    gap: 20px; /* 버튼 사이의 간격을 조절할 수 있습니다 */
}
.Search3 {
    display: flex;
    align-items: center;
    justify-content: space-between;
}

form {
    display: flex;
    justify-content: flex-end;
}
.ent-list{
	margin-left: 112px;
	margin-bottom: 15px;
}
#filterForm,#filterForm2,#filterForm3{
	margin-right:150px;
}
#memSearch,#entSearch,.reportSearch{
	height: 46px;
	width: 77px;
	opacity: 0.7;
}
.reportSearch{
	margin-bottom: 10px;
}
#pagination1,#pagination2,#pagination3{
	margin-top: 20px;
}
</style>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div class="container2">
    <header>
        <h1>회원관리</h1>
        <h5>회원 이용제한</h5>
    </header>
    
    <!-- 회원목록과 신고 회원목록을 Flexbox로 정렬 -->
	<div class="flex-container">
		<!-- 회원목록 -->
			<div class="table1">
			<div class="Search1">
			    <div class="memSelect">
			        <div class="memTab">
			            <button type="button" class="list-button mem-list">회원</button>
			        </div>
			        <div class="entTab">
			            <button type="button" class="list-button ent-list" style="margin-left: 112px;">기업</button>
			        </div>
			    </div>
			    <form id="filterForm" method="get" onsubmit="return false;">
			        <input type="hidden" name="currentPage" value="1"> 
			        <input type="text" id="searchInput1" name="searchKeyword" placeholder="회원을 검색하세요">
			        <button id="memSearch" type="button" class="filter-button search-button">검색</button>
			    </form>
			</div>
			<table class="tableForm1">
				<colgroup>
					<col style="width: 10%; height:10px;">
					<col style="width: 6%;">
					<col style="width: 4%;">
					<col style="width: 10%;">
					<col style="width: 9%;">
					<col style="width: 6%;">
				</colgroup>
				<thead>
					<tr>
						<th style="text-align: center;">아이디</th>
						<th style="text-align: center;">이름</th>
						<th style="text-align: center;">경고</th>
						<th style="text-align: center;">정보조회</th>
						<th style="text-align: center;">제한선택</th>
						<th style="text-align: center;">제한</th>
					</tr>
				</thead>
				<tbody class="memberData">
				</tbody>
			</table>
		</div>
		<!-- 테이블 2 - 기업관리 -->
		<div class="table2" style="display: none;">
			<div class="Search2" style="display: none;">
			    <div class="entSelect">
			        <div class="memTab">
			            <button type="button" class="list-button mem-list">회원</button>
			        </div>
			        <div class="entTab">
			            <button type="button" class="list-button ent-list" style="margin-left: 112px;">기업</button>
			        </div>
			    </div>
			    <form id="filterForm2" method="get" onsubmit="return false;">
			        <input type="hidden" name="currentPage" value="1"> 
			        <input type="text" id="searchInput2" name="searchKeyword" placeholder="기업을 검색하세요">
			        <button id="entSearch" type="button" class="filter-button search-button">검색</button>
			    </form>
			</div>
			<table>
				<colgroup>
					<col style="width: 10%;">
					<col style="width: 10%;">
					<col style="width: 13%;">
					<col style="width: 10%;">
				</colgroup>
				<thead>
					<tr>
						<th style="text-align: center;">아이디</th>
						<th style="text-align: center;">기업</th>
						<th style="text-align: center;">대표자</th>
						<th style="text-align: center;">정보조회</th>
					</tr>
				</thead>
				<tbody class="entData">
				</tbody>
			</table>
		</div>
		<!-- 신고 회원목록 -->
		<div class="table3">
			<div class="Search3">
			    <h3 style="width:18%;">신고 회원목록</h3>
			    <form id="filterForm3" method="get" onsubmit="return false;" style="display: flex; align-items: center;">
			        <input type="hidden" name="currentPage" value="1">
			        <input type="text" id="searchInput3" name="searchKeyword" placeholder="신고된 회원을 검색하세요">
			        <button id="reportSearch" type="button" class="filter-button search-button reportSearch">검색</button>
			    </form>
			</div>
			<table>
				<colgroup>
					<col style="width: 9%;">
					<col style="width: 18%;">
					<col style="width: 12%;">
					<col style="width: 10%;">
					<col style="width: 5%;">
				</colgroup>
				<thead>
					<tr>
						<th style="text-align: center;">아이디</th>
						<th style="text-align: center;">신고내용</th>
						<th style="text-align: center;">신고분류</th>
						<th style="text-align: center;">제한선택</th>
						<th style="text-align: center;">제한</th>
					</tr>
				</thead>
				<tbody class="reportData">
				</tbody>
			</table>
		</div>
	</div>

<div class="search-pages">
	<div class="flex-row">
    <div class="search-container ">
        <!-- 페이지네이션1 -->
        <div class="search-page1">
			<div id="pagination1" class="pagination-container" style="margin-right: 450px; margin-bottom: 10px;">
			    <div class="pagination">
			        <c:if test="${articlePage.startPage > 1}">
			            <a href="#" class="page-link" data-page="${articlePage.startPage-1}">&lt;</a>
			        </c:if>
			        
			        <c:forEach var="pNo" begin="${articlePage.startPage}" end="${articlePage.endPage}">
			            <a href="#" class="page-link ${pNo == articlePage.currentPage ? 'active' : ''}" data-page="${pNo}">${pNo}</a>
			        </c:forEach>
			        
			        <c:if test="${articlePage.endPage < articlePage.totalPages}">
			            <a href="#" class="page-link" data-page="${articlePage.endPage+1}">&gt;</a>
			        </c:if>
			    </div>
			</div>
        </div>
        <!-- 페이지네이션2 -->
        <div class="search-page2 search-container2" style="display:none;">
            <div id="pagination2" class="pagination-container" style="display: none; margin-right: 450px; margin-bottom: 10px;">
		        <c:if test="${articlePage2.startPage > 1}">
		            <a href="#" class="page-link" data-page="${articlePage2.startPage-1}">&lt;</a>
		        </c:if>
		        
		        <c:forEach var="pNo" begin="${articlePage2.startPage}" end="${articlePage2.endPage}">
		            <a href="#" class="page-link ${pNo == articlePage2.currentPage ? 'active' : ''}" data-page="${pNo}">${pNo}</a>
		        </c:forEach>
		        
		        <c:if test="${articlePage2.endPage < articlePage2.totalPages}">
		            <a href="#" class="page-link" data-page="${articlePage2.endPage+1}">&gt;</a>
		        </c:if>
            </div>
        </div>
    </div>
	<!-- 페이지네이션3 -->
    <!-- 오른쪽 검색 컨테이너 -->
    <div class="search-container search-container3">
        <!-- 페이지네이션3 -->
        <div class="search-page3">
            <div id="pagination3" class="pagination-container" style="margin-right: 320px; margin-bottom: 10px;">
                <div class="pagination">
			        <c:if test="${articlePage3.startPage > 1}">
			            <a href="#" class="page-link" data-page="${articlePage3.startPage-1}">&lt;</a>
			        </c:if>
			        
			        <c:forEach var="pNo" begin="${articlePage3.startPage}" end="${articlePage3.endPage}">
			            <a href="#" class="page-link ${pNo == articlePage3.currentPage ? 'active' : ''}" data-page="${pNo}">${pNo}</a>
			        </c:forEach>
			        
			        <c:if test="${articlePage3.endPage < articlePage3.totalPages}">
			            <a href="#" class="page-link" data-page="${articlePage3.endPage+1}">&gt;</a>
			        </c:if>
                </div>
            </div>
        </div>
    </div>
</div>
</div>
</div>
<!-- 회원모달 -->
<div id="memDetailModal" class="modal" tabindex="-1" role="dialog">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">회원 정보</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <p><strong>아이디:</strong> <span id="modal-mbrId"></span></p>
        <p><strong>이름:</strong> <span id="modal-mbrNm"></span></p>
        <p><strong>전화번호:</strong> <span id="modal-mbrTel"></span></p>
        <p><strong>이메일:</strong> <span id="modal-mbrEmail"></span></p>
        <p><strong>주소:</strong> <span id="modal-mbrAddr"></span></p>
        <p><strong>상세 주소:</strong> <span id="modal-mbrAddrDtl"></span></p>
        <p><strong>우편번호:</strong> <span id="modal-mbrZip"></span></p>
        <p><strong>가입일자:</strong> <span id="modal-mbrJoinYmd"></span></p>
        <p><strong>경고횟수:</strong> <span id="modal-mbrWarnCo"></span></p>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
      </div>
    </div>
  </div>
</div>
<!-- 기업모달 -->
<div id="entDetailModal" class="modal" tabindex="-1" role="dialog">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">기업 정보</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <p><strong>아이디:</strong> <span id="modal-entId"></span></p>
        <p><strong>기업 이름:</strong> <span id="modal-entNm"></span></p>
        <p><strong>대표자 이름:</strong> <span id="modal-entRprsntvNm"></span></p>
        <p><strong>전화번호:</strong> <span id="modal-entTel"></span></p>
        <p><strong>이메일:</strong> <span id="modal-entEmail"></span></p>
        <p><strong>주소:</strong> <span id="modal-entAddr"></span></p>
        <p><strong>우편번호:</strong> <span id="modal-entZip"></span></p>
        <p><strong>사업자등록번호:</strong> <span id="modal-entBrNo"></span></p>
        <p><strong>팩스 번호:</strong> <span id="modal-entFxnum"></span></p>
        <p><strong>직원 수:</strong> <span id="modal-entEmpCnt"></span></p>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
      </div>
    </div>
  </div>
</div>

<script type="text/javascript">
$(document).ready(function() {
    var Toast = Swal.mixin({
        toast: true,
        position: 'center',
        showConfirmButton: false,
        timer: 1500,
        
        didOpen: (toast) => {
            toast.addEventListener('mouseenter', Swal.stopTimer);
            toast.addEventListener('mouseleave', Swal.resumeTimer);
        }
    });
    $('.mem-list').on('click', function() {
        switchTab('member');
        setActiveButton($(this)); // 버튼 활성화 상태 설정
    });

    // 기업 목록 버튼 클릭 이벤트
    $('.ent-list').on('click', function() {
        switchTab('enterprise');
        setActiveButton($(this)); // 버튼 활성화 상태 설정
    });

    // 활성화된 버튼을 설정하는 함수
    function setActiveButton(button) {
        // 모든 버튼에서 'active' 클래스 제거
        $('.list-button').removeClass('active');

        // 클릭된 버튼에 'active' 클래스 추가
        button.addClass('active');
    }
	$(document).on("click", '.memDetail', function() {
	    const mbrId = $(this).closest('tr').find('td:first').text();
	    
	    $.ajax({
	        url: '/adm/memAllDetail',
	        type: 'GET',
	        data: { mbrId: mbrId },
	        success: function(data) {
	            if (data) {
	                // 모달에 데이터 채우기
	                $('#modal-mbrId').text(data.mbrId);
	                $('#modal-mbrNm').text(data.mbrNm);
	                $('#modal-mbrTel').text(data.mbrTelno);
	                $('#modal-mbrEmail').text(data.mbrEml);
	                $('#modal-mbrAddr').text(data.mbrAddr);
	                $('#modal-mbrAddrDtl').text(data.mbrAddrDtl);
	                $('#modal-mbrZip').text(data.mbrZip);
	                $('#modal-mbrJoinYmd').text(data.mbrJoinYmd);
	                $('#modal-mbrWarnCo').text(data.mbrWarnCo);

	                // 모달 보여주기 (회원 모달)
	                $('#memDetailModal').modal('show');
	            } else {
	                alert('정보를 가져오는데 실패했습니다.');
	            }
	        },
	        error: function() {
	            alert('서버 오류');
	        }
	    });
	});

	
	
	$(document).on("click", '.entDetail', function() {
	    const entId = $(this).closest('tr').find('td:first').text();
	    
	    $.ajax({
	        url: '/adm/enterAllDetail',
	        type: 'GET',
	        data: { entId: entId },
	        success: function(data) {
	            if (data) {
	                // 모달에 데이터 채우기
	                $('#modal-entId').text(data.entId);
	                $('#modal-entNm').text(data.entNm);
	                $('#modal-entRprsntvNm').text(data.entRprsntvNm);
	                $('#modal-entTel').text(data.entManagerTelno);
	                $('#modal-entEmail').text(data.entMail);
	                $('#modal-entAddr').text(data.entAddr);
	                $('#modal-entZip').text(data.entZip);
	                $('#modal-entBrNo').text(data.entBrno);
	                $('#modal-entFxnum').text(data.entFxnum);
	                $('#modal-entEmpCnt').text(data.entEmpCnt);
	                // 추가로 필요한 필드들을 여기에 추가
	                
	                // 모달 보여주기
	                $('#entDetailModal').modal('show');
	            } else {
	                alert('정보를 가져오는데 실패했습니다.');
	            }
	        },
	        error: function() {
	            alert('서버 오류');
	        }
	    });
	});
	
	//신고 제한버튼
$(document).on('click', '.limit-btn', function() {
    var selectedComCode = $(this).closest('tr').find('.category').val(); // 선택된 comCode 값 가져오기
    var mbrId = $(this).closest('tr').find('td:first').text(); // 회원 아이디 가져오기
    var dclrNo = $(this).closest('tr').find('input[type="hidden"]').val(); // 해당 행의 dclrNo 값 가져오기

    if (selectedComCode) {
        if (selectedComCode === "WAMA04") {
            Swal.fire({
                title: '신고를 기각 하시겠습니까?',
                icon: 'question',
                showCancelButton: true,
                confirmButtonColor: 'white',
                cancelButtonColor: 'white',
                confirmButtonText: '예',
                cancelButtonText: '아니오'
                 // 버튼 순서 거꾸로
            }).then((result) => {
                if (result.isConfirmed) {
                    $.ajax({
                        url: '/adm/reportBoardDel',
                        type: 'POST',
                        data: {
                            dclrNo: dclrNo // 삭제할 dclrNo 값 전달
                        },
                        beforeSend: function(xhr) {
                            xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                        },
                        success: function(response) {
                            if (response === "success") {
                                Toast.fire({
                                    icon: 'success',
                                    title: '신고가 기각되었습니다.'
                                })
                                  location.reload(); // 삭제 후 페이지 새로고침
                            } else {
                                Swal.fire(
                                    '삭제 실패',
                                    '삭제에 실패했습니다.',
                                    'error'
                                );
                            }
                        },
                        error: function() {
                            Swal.fire(
                                '오류',
                                '서버 오류가 발생했습니다.',
                                'error'
                            );
                        }
                    });
                }
            });
        } else {
            Swal.fire({
                title: '회원 제한을 적용하시겠습니까?',
                icon: 'question',
                showCancelButton: true,
                confirmButtonColor: 'white',
                cancelButtonColor: 'white',
                confirmButtonText: '예',
                cancelButtonText: '아니오'
                 // 버튼 순서 거꾸로
            }).then((result) => {
                if (result.isConfirmed) {
                    $.ajax({
                        url: '/adm/reportLimit',
                        type: 'POST',
                        data: {
                            comCode: selectedComCode,
                            mbrId: mbrId
                        },
                        beforeSend: function(xhr) {
                            xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                        },
                        success: function(response) {
                            if (response === "success") {
                                Toast.fire({
                                    icon: 'success',
                                    title: '회원'+mbrId+'님에게 제한이 적용되었습니다.'
                                }).then(() => {
                                    // 첫 번째 AJAX 성공 후 자동으로 삭제 AJAX 요청을 실행
                                    $.ajax({
                                        url: '/adm/reportBoardDel',
                                        type: 'POST',
                                        data: {
                                            dclrNo: dclrNo // 삭제할 dclrNo 값 전달
                                        },
                                        beforeSend: function(xhr) {
                                            xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                                        },
                                        success: function(response) {
                                            if (response === "success") {
                                                   location.reload(); // 삭제 후 페이지 새로고침
                                            } else {
                                                Swal.fire(
                                                    '삭제 실패',
                                                    '삭제에 실패했습니다.',
                                                    'error'
                                                );
                                            }
                                        },
                                        error: function() {
                                            Swal.fire(
                                                '오류',
                                                '서버 오류가 발생했습니다.',
                                                'error'
                                            );
                                        }
                                    });
                                });
                            } else {
                                Swal.fire(
                                    '제한 적용 실패',
                                    '회원 제한 적용에 실패했습니다.',
                                    'error'
                                );
                            }
                        },
                        error: function() {
                            Swal.fire(
                                '오류',
                                '서버 오류가 발생했습니다.',
                                'error'
                            );
                        }
                    });
                }
            });
        }
    } else {
        Swal.fire(
            '제한 종류를 선택하세요.',
            '',
            'info'
        );
    }
});

// 신고 제한 버튼 (limit-btn2)
$(document).on('click', '.limit-btn2', function() {
    var selectedComCode = $(this).closest('tr').find('.category').val(); // 선택된 comCode 값 가져오기
    var mbrId = $(this).closest('tr').find('td:first').text(); // 회원 아이디 가져오기

    if (selectedComCode) {
        Swal.fire({
            title: '회원 제한을 적용하시겠습니까?',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: 'white',
            cancelButtonColor: 'white',
            confirmButtonText: '예',
            cancelButtonText: '아니오'
        }).then((result) => {
            if (result.isConfirmed) {
                $.ajax({
                    url: '/adm/reportLimit',
                    type: 'POST',
                    data: {
                        comCode: selectedComCode,
                        mbrId: mbrId
                    },
                    beforeSend: function(xhr) {
                        xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                    },
                    success: function(response) {
                        if (response === "success") {
                            Toast.fire({
                  				icon:'success',
                  				title: '회원'+mbrId+'님에게 제한이 적용되었습니다.'
                  			}).then(() => {
                                location.reload();
                            });
                        } else {
                            Swal.fire(
                                '제한 적용 실패',
                                '회원 제한 적용에 실패했습니다.',
                                'error'
                            );
                        }
                    },
                    error: function() {
                        Swal.fire(
                            '오류',
                            '서버 오류가 발생했습니다.',
                            'error'
                        );
                    }
                });
            }
        });
    } else {
        Swal.fire(
            '제한 종류를 선택하세요.',
            '',
            'info'
        );
    }
});
	
    // 초기 상태: 회원 목록을 기본으로 표시
    switchTab('member');

    // 회원 목록 버튼 클릭 이벤트
    $('.mem-list').on('click', function() {
        switchTab('member');
        setActiveButton($(this)); // 버튼 활성화 상태 설정
    });

    // 기업 목록 버튼 클릭 이벤트
    $('.ent-list').on('click', function() {
        switchTab('enterprise');
        setActiveButton($(this)); // 버튼 활성화 상태 설정
    });

    // 활성화된 버튼을 설정하는 함수
    function setActiveButton(button) {
        // 모든 버튼에서 'active' 클래스 제거
        $('.list-button').removeClass('active');

        // 클릭된 버튼에 'active' 클래스 추가
        button.addClass('active');
    }
    // 탭 전환 함수: member 또는 enterprise만 전환
    function switchTab(tab) {
        $('.table1, .table2').hide(); // 회원, 기업 목록 숨기기
        $('#pagination1, #pagination2').hide(); // 회원, 기업 페이지네이션 숨기기
        $('.search-page1, .search-page2').hide(); // 회원, 기업 검색창 숨기기
        $('.Search1, .Search2').hide(); // 회원, 기업 검색창 숨기기
        
        if (tab === 'member') {
            $('.table1').show(); // 회원 목록 표시
            $('#pagination1').show(); // 회원 페이지네이션 표시
            $('.search-page1').show(); // 회원 검색창 표시
            $('.Search1').show(); // 회원 검색창 표시
            loadMembers(1, ''); // 회원 목록 로드
        } else if (tab === 'enterprise') {
            $('.table2').show(); // 기업 목록 표시
            $('#pagination2').show(); // 기업 페이지네이션 표시
            $('.search-page2').show(); // 기업 검색창 표시
            $('.Search2').show(); // 기업 검색창 표시
            loadEnterprises(1, ''); // 기업 목록 로드
        }
    }

    // 회원 목록 불러오기
    function loadMembers(page, searchKeyword) {
        $.ajax({
            url: '/adm/memList',
            type: 'GET',
            data: { currentPage: page, searchKeyword: searchKeyword },
            success: function(response) {
                updateMemberTable(response.content, response.codeVOList);
                updatePagination('#pagination1', page, response.totalPages, 'member');
            }
        });
    }

    // 기업 목록 불러오기
    function loadEnterprises(page, searchKeyword) {
        $.ajax({
            url: '/adm/entList',
            type: 'GET',
            data: { currentPage: page, searchKeyword: searchKeyword },
            success: function(response) {
                updateEnterpriseTable(response.content);
                updatePagination('#pagination2', page, response.totalPages, 'enterprise');
            }
        });
    }

    // 신고된 회원 목록 불러오기
    function loadReports(page, searchKeyword) {
        $.ajax({
            url: '/adm/reportList',
            type: 'GET',
            data: { currentPage: page, searchKeyword: searchKeyword },
            success: function(response) {
                updateReportTable(response.content, response.codeVOList);
                updatePagination('#pagination3', page, response.totalPages, 'report');
            }
        });
    }

    // 회원 테이블 업데이트
	function updateMemberTable(members, codeVOList) {
	    var tableBody = $(".memberData");
	    tableBody.empty();
	    $.each(members, function(index, member) {
	        // select box 생성
	        var selectHTML = '<select class="category" name="comCode">';
	        selectHTML += '<option value="" disabled selected>제한 선택</option>';
	        $.each(codeVOList, function(idx, code) {
	            // WAMA04를 hidden 처리
	            if (code.comCode === 'WAMA04') {
	                selectHTML += '<option value="' + code.comCode + '" hidden>' + code.comCodeNm + '</option>';
	            } else {
	                selectHTML += '<option value="' + code.comCode + '">' + code.comCodeNm + '</option>';
	            }
	        });
	        selectHTML += '</select>';
	
	        var row = '<tr>' +
	            '<td style="text-align: center;">' + member.mbrId + '</td>' +
	            '<td style="text-align: center;">' + member.mbrNm + '</td>' +
	            '<td style="text-align: center;">' + member.mbrWarnCo + '</td>' +
	            '<td style="text-align: center;"><button class="graybtn memDetail">정보조회</button></td>' +
	            '<td style="text-align: center;">' + selectHTML + '</td>' + // select box 추가
	            '<td style="text-align: center;"><button class="graybtn limit-btn2">제한</button></td>' +
	            '</tr>';
	        tableBody.append(row);
	    });
	}

    // 기업 테이블 업데이트
    function updateEnterpriseTable(enters) {
        var tableBody = $(".entData");
        tableBody.empty();
        $.each(enters, function(index, enter) {
            var row = '<tr>' +
                '<td style="text-align: center;">' + enter.entId + '</td>' +
                '<td style="text-align: center;">' + enter.entNm + '</td>' +
                '<td style="text-align: center;">' + enter.entRprsntvNm + '</td>' +
                '<td style="text-align: center;"><button class="graybtn entDetail">정보조회</button></td>' +
                '</tr>';
            tableBody.append(row);
        });
    }

    // 신고된 회원 테이블 업데이트 (신고 회원 목록은 항상 표시)
    function updateReportTable(reports, codeVOList) {
        var tableBody = $(".reportData");
        tableBody.empty();
        $.each(reports, function(index, report) {
            var selectHTML = '<select class="category" name="comCode">';
            selectHTML += '<option value="" disabled selected>제한 선택</option>';
            $.each(codeVOList, function(idx, code) {
                selectHTML += '<option value="' + code.comCode + '">' + code.comCodeNm + '</option>';
            });
            selectHTML += '</select>';

            var row = '<tr>' +
            '<td style="text-align: center;">' + report.mbrId + '</td>' +
            '<td>' + report.dclrCn + '</td>' +
            '<td style="text-align: center;">' + report.dclrTp + '</td>' +
            '<td style="text-align: center;">' + selectHTML + '</td>' +
            '<td style="text-align: center;"><button class="graybtn limit-btn">제한</button></td>' +
            '<input type="hidden" id="dclrNo" name="dclrNo" value="' + report.dclrNo + '"/>' + 
            '</tr>';

            tableBody.append(row);
        });
    }

    // 페이지네이션 업데이트 함수
    function updatePagination(paginationId, currentPage, totalPages, tab) {
        var pagination = $(paginationId);
        pagination.empty();
        for (var i = 1; i <= totalPages; i++) {
            var pageLink = '<a href="#" class="page-link ' + (i === currentPage ? 'active' : '') + '" data-page="' + i + '">' + i + '</a>';
            pagination.append(pageLink);
        }

        $(paginationId + ' .page-link').on('click', function(e) {
            e.preventDefault();
            var page = $(this).data('page');
            if (tab === 'member') {
                loadMembers(page, $('#searchInput1').val());
            } else if (tab === 'enterprise') {
                loadEnterprises(page, $('#searchInput2').val());
            } else if (tab === 'report') {
                loadReports(page, $('#searchInput3').val());
            }
        });
    }

    // 검색 버튼 이벤트 설정
    $('#memSearch').on('click', function() {
        loadMembers(1, $('#searchInput1').val());
    });

    $('#entSearch').on('click', function() {
        loadEnterprises(1, $('#searchInput2').val());
    });

    $('#reportSearch').on('click', function() {
        loadReports(1, $('#searchInput3').val());
    });

    // 처음에 신고된 회원 목록을 로드
    loadReports(1, '');
});
</script>


