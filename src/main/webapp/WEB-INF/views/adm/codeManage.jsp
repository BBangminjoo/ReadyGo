<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<script type="text/javascript" src="/resources/ckeditor5/ckeditor.js"></script>
<sec:authentication property="principal" var="prc"/>
<script type="text/javascript" src="/resources/js/sweetalert2.js"></script>
<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/admAlert.css" />
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

.container {
    width: 80%;
    margin: 0 auto;
    margin-left: 400px;
}

table {
    width: 80%;
    border-collapse: collapse;
    margin-top: 20px;
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
}

.codeAddForm input[type="text"] {
    width: 150px; /* 입력창과 버튼을 맞추기 위해 계산 */
    padding: 10px;
    border: 1px solid #ccc;
    border-radius: 4px;
}

.search-button {
    padding: 10px 20px;
    border: 1px solid #FD5D6C;
    border-radius: 5px;
    cursor: pointer;
    background-color: white;
    color: #FD5D6C;
    width: 120px;
    margin-left: 10px; /* 입력창과 버튼 사이의 간격 */
}

.filter-button {
    padding: 10px 20px;
    border: 1px solid #FD5D6C;
    border-radius: 5px;
    background-color: white;
    color: #FD5D6C;
    transition: background-color 0.3s, color 0.3s; 
}

.filter-button:hover {
    background-color: #FD5D6C;
    color: white;
    border: 1px solid #FD5D6C; 
}

.filter-buttons {
    display: flex;
    justify-content: center;
    gap: 30px;
    margin-bottom: 20px;
}

colgroup col:nth-child(2) {
    width: 50%;
    text-align: left;
}

table thead {
	background-color: rgba(253, 93, 108, 0.7);
	color: white;
}

table thead th, table tbody td {
    padding: 10px;
    font-size: 14px;
    border-bottom: 1px solid #ddd;
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

.button-container {
    text-align: right;
    margin-top: 20px;
}

.free-title:hover {
    text-decoration: underline;
}

.ListTitle {
    color: black;
}

.ListTitle:hover {
    color: #FD5D6C;
    text-decoration: underline;
}

.pagination-container {
    display: flex;
    flex-direction: column;
    align-items: center;
    margin-top: 10px;
}

.page-link {
    color: black;
    border-radius: 7px;
    margin: 5px;
}

.page-item.active .page-link {
    color: #FD5D6C;
    background-color: rgba(253, 93, 108, 0.11);
    border-radius: 7px;
    border-color: #FD5D6C;
}

.cat {
    width: 100px;
    height: 45px;
}

.codeGrpEditForm {
    display: flex; /* Flexbox를 사용하여 가로 정렬 */
    gap: 10px; /* 요소 간의 간격을 설정 */
    margin-top: 10px; /* 위쪽 여백 추가 */
}
.editComCodeGrp{
    width: 150px;
    padding: 10px;
    border: 1px solid #ccc;
    border-radius: 4px;
}
.codeAddForm select {
    text-align: center; /* 가운데 정렬 */
    option {
        text-align: center; /* 옵션 텍스트 가운데 정렬 */
    }
}
.codeGrpUpdate, .codeGrpCancel{
	height: 46px;
}
.controls-wrapper {
    display: flex;
    justify-content: space-between;
    width: 100%;
}

.grp-code-manage, .codeAddGroup {
    flex: 1;
}

.codeAddGroup {
    display: flex;
    justify-content: flex-end;
    align-items: center;
}

.codeAddForm {
    display: none; /* Initially hidden, shown on button click */
}
.controls-wrapper {
    display: flex;
    align-items: center;
    justify-content: space-between;
    width: 100%;
}

.grp-code-manage {
    flex: 1; /* 유연하게 크기 조절 */
}

.codeAddGroup {
    display: flex;
    align-items: center;
}
.form-control {
	display: inline-block;
	height: 46px;
}
.codeChInput, .codeDescChInput{
    width: 122px !important;
    text-align: center;
    margin-bottom: 0px !important;
}
.codeGrpDel,.codeAddCancel,.codeGrpCancel,
.codeChCan,.codeDel{
    padding: 10px 20px;
    border: 1px solid #B5B5B5;
    border-radius: 5px;
    background-color: white;
 	color: #232323;
    transition: background-color 0.3s, color 0.3s; 
}

.codeGrpDel:hover,.codeAddCancel:hover,.codeGrpCancel:hover,
.codeChCan:hover,.codeDel:hover{
   background: #ECECEC;
   color: #232323;
   border: 1px solid #B5B5B5;
}
table tbody tr:hover {
    background-color: rgba(253, 93, 108, 0.1);
    transition: background-color 0.3s ease;
}
.codeAdd,.codeAddGroup{
	margin-top: 10px;
}
</style>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div class="container">
    <header>
        <h1>공통코드관리</h1>
    </header>
    <div class="head" >
		<form name="codeGrpDelForm" id="codeGrpDelForm"
			action="/adm/codeGrpDel" method="post">
		    <div class="controls-wrapper">
			<div class="grp-code-manage">
			<div>
				<div class="select-container" style="display: inline-block;">
					<!-- selectbox에서 comCodeGrp 값을 선택 -->
					<select class="form-control category" name="comCodeGrp" id="comCodeGrp" required
						onchange="location.href='${pageContext.request.contextPath}/adm/codeManage?currentPage=1&comCodeGrp=' + this.value">
						<option value="" selected disabled hidden>그룹코드 선택</option>
						<c:forEach var="codeGrpVO" items="${codeGrpVOList}">
							<option value="${codeGrpVO.comCodeGrp}">${codeGrpVO.comCodeGrpNm}
								(${codeGrpVO.comCodeGrp})</option>
						</c:forEach>
					</select>
				</div>
				<div class="button-container" style="display: inline-block;">
					<button type="button" class="filter-button codeGrpDel">삭제</button>
					<button type="button" class="filter-button codeGrpAdd">그룹코드추가</button>
				</div>
			</div>
			<sec:csrfInput />
		</div>
		</form>

		<form name="codeGrpAddForm" id="codeGrpAddForm" action="/adm/codeGrpAdd" method="post">
        <div class="codeGrpEditForm" style="display: none;">
            <input type="text" class="editComCodeGrp" id="comCodeGrp" name="comCodeGrp" placeholder="*그룹코드명" required>
            <input type="text" class="editComCodeGrpNm" id="comCodeGrpNm" name="comCodeGrpNm" placeholder="*그룹코드이름" required>
            <input type="text" class="editComCodeDesc" id="codeGrpDesc" name="codeGrpDesc" placeholder="*그룹코드설명" required>
            <button type="button" class="filter-button codeGrpCancel">취소</button>
            <button type="submit" class="filter-button codeGrpUpdate">추가</button>
        </div>
        <sec:csrfInput />
    </form>
    <div class="codeAddGroup" >
   	<button type="button" class="filter-button codeAdd" style="display: inline-block; margin-right: 340px;">코드추가</button>
	<form name="codeAddForm" id="codeAddForm" action="/adm/codeAdd"
		method="post">
		<div class="codeAddForm" style="display: none; margin-top: 10px; margin-right: 340px;">
			<select class="form-control editComCodeGrp" name="comCodeGrp" id="comCodeGrp" required>
				<option value="" selected disabled hidden>그룹코드 선택</option>
				<c:forEach var="codeGrpVO" items="${codeGrpVOList}">
					<option value="${codeGrpVO.comCodeGrp}">${codeGrpVO.comCodeGrpNm}
						(${codeGrpVO.comCodeGrp})</option>
				</c:forEach>
			</select> 
			<input type="text" class="editComCode" id="comCode" name="comCode" placeholder="*코드이름" required style="text-align: center;"> 
			<input type="text" class="editComCodeNm" id="comCodeNm" name="comCodeNm" placeholder="*코드이름(한글)" required style="text-align: center;"> 
			<input type="text" class="editComCodeDesc" id="comCodeDesc" name="comCodeDesc" placeholder="*코드설명" required style="text-align: center;"> 
			<input type="text" class="editUpperComCode" id="upperComCode" name="upperComCode" placeholder="상위 공통 코드" style="text-align: center;"> 
			<input type="text" class="editUpperComCodeGrp" id="upperComCodeGrp" name="upperComCodeGrp" placeholder="상위 공통 코드 그룹" style="text-align: center;">
			<button type="button" class="filter-button codeAddCancel">취소</button>
			<button type="submit" class="filter-button codeAddSubmit">추가</button>
		</div>
		<sec:csrfInput />
	</form>
	</div>
    </div>
	<table>
		<colgroup>
			<col>
			<col>
			<col>
			<col>
			<col>
		</colgroup>
		<thead>
			<tr>
				<th style="text-align: center; font-size:18px;">코드 이름</th>
				<th style="text-align: center; font-size:18px;">코드 이름(한글)</th>
				<th style="text-align: center; font-size:18px;">코드설명</th>
				<th style="text-align: center; font-size:18px;">삭제 / 수정</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="codeVO" items="${filteredCodeList}">
				<tr>
					<td style="text-align: center;">${codeVO.comCode}</td>
					<td style="text-align: center;"><div class="comCodeNmVal">${codeVO.comCodeNm}</div>
						<input type="text" placeholder="${codeVO.comCodeNm}" class="codeChInput" style="display: none;">
					</td>
					<td style="text-align: center;"><div class="comCodeDescVal">${codeVO.comCodeDesc}</div>
						<input type="text" placeholder="${codeVO.comCodeDesc}" class="codeDescChInput" style="display: none;">
					</td>
					<td style="text-align: center;">
						<button class="filter-button codeDel" data-id="${codeVO.comCode}">삭제</button>
						<button type="button" class="filter-button codeChForm">수정</button>
						<button type="button" class="filter-button codeChCan" style="display: none;">취소</button>
						<button type="button" class="filter-button codeCh" style="display: none;">변경</button>
					</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
<!-- 	페이지네이션시작 -->
<div class = "search-page">
	<div class="pagination-container" style="margin-right: 340px;">
		<div class="pagination">
			<c:if test="${articlePage.currentPage gt 1}">
				<li class="paginate_button page-item first">
					<a href="/adm/codeManage?currentPage=1&comCodeGrp=${param.comCodeGrp}&searchKeyword=${param.searchKeyword}"
					   aria-controls="example2" data-dt-idx="0" tabindex="0" class="page-link">&lt;&lt;</a>
				</li>
			</c:if>
			<c:if test="${articlePage.startPage gt 5}">
				<li class="paginate_button page-item previous"><a
					href="/adm/codeManage?currentPage=${articlePage.startPage-5}&comCodeGrp=${param.comCodeGrp}&searchKeyword=${param.searchKeyword}"
					class="page-link">&lt;</a></li>
			</c:if>
			<c:forEach var="pNo" begin="${articlePage.startPage}"
				end="${articlePage.endPage}">
				<c:choose>
					<c:when test="${pNo eq articlePage.currentPage}">
						<li class="paginate_button page-item active"><a
							href="/adm/codeManage?currentPage=${pNo}&comCodeGrp=${param.comCodeGrp}&searchKeyword=${param.searchKeyword}"
							class="page-link">${pNo}</a></li>
					</c:when>
					<c:otherwise>
						<li class="paginate_button page-item"><a
							href="/adm/codeManage?currentPage=${pNo}&comCodeGrp=${param.comCodeGrp}&searchKeyword=${param.searchKeyword}"
							class="page-link">${pNo}</a></li>
					</c:otherwise>
				</c:choose>
			</c:forEach>
			<c:if test="${articlePage.endPage lt articlePage.totalPages}">
				<li class="paginate_button page-item previous"><a
					href="/adm/codeManage?currentPage=${articlePage.startPage+5}&comCodeGrp=${param.comCodeGrp}&searchKeyword=${param.searchKeyword}"
					class="page-link">&gt;</a></li>
			</c:if>
			<c:if test="${articlePage.currentPage lt articlePage.totalPages}">
				<li class="paginate_button page-item last">
					<a href="/adm/codeManage?currentPage=${articlePage.totalPages}&comCodeGrp=${param.comCodeGrp}&searchKeyword=${param.searchKeyword}"
					   aria-controls="example2" data-dt-idx="7" tabindex="0" class="page-link">&gt;&gt;</a>
				</li>
			</c:if>
		</div>
	</div>

<!-- 검색창 -->
	<div class="search-container" style="margin-right: 340px;">
    <form id="filterForm" action="${pageContext.request.contextPath}/adm/codeManage" method="get" onsubmit="resetFilters()">
        <input type="hidden" name="currentPage" value="1"> <!-- 항상 1페이지로 설정 -->
        <input type="text" name="searchKeyword" placeholder="공통코드를 검색하세요" value="${param.searchKeyword}">
        <button type="submit" class="filter-button search-button">검색</button>
    </form>
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
	$(document).on("click", '.codeChForm', function() {
	    var currentRow = $(this).closest('tr'); // 현재 행(tr)을 선택
	    currentRow.find('.codeChInput').show(); // 코드명 input 필드 보이기
	    currentRow.find('.codeDescChInput').show(); // 코드 설명 input 필드 보이기
	    currentRow.find('.codeCh').show(); // 수정 버튼 보이기
	    currentRow.find('.codeChCan').show(); // 취소 버튼 보이기
	    currentRow.find('.comCodeNmVal').hide(); // 취소 버튼 보이기
	    currentRow.find('.comCodeDescVal').hide(); // 취소 버튼 보이기
	    $(this).siblings('.codeDel').hide();
	    $(this).hide(); // 현재 수정 버튼은 숨김 처리
	});

	$(document).on("click", '.codeChCan', function() {
	    var currentRow = $(this).closest('tr'); // 현재 행(tr)을 선택
	    currentRow.find('.codeChInput').hide(); // 코드명 input 필드 숨기기
	    currentRow.find('.codeDescChInput').hide(); // 코드 설명 input 필드 숨기기
	    currentRow.find('.codeCh').hide(); // 수정 버튼 숨기기
	    currentRow.find('.codeChForm').show(); // 수정 버튼 다시 보이기
	    currentRow.find('.comCodeNmVal').show(); // 취소 버튼 보이기
	    currentRow.find('.comCodeDescVal').show(); // 취소 버튼 보이기
	    $(this).siblings('.codeDel').show();
	    $(this).hide(); // 취소 버튼 숨기기
	});


    // URL에서 comCodeGrp 파라미터 값을 추출
    var urlParams = new URLSearchParams(window.location.search);
    var selectedCodeGrp = urlParams.get('comCodeGrp'); // URL에서 comCodeGrp 값 가져오기

    // SELECT 박스에서 comCodeGrp 값을 선택
    if (selectedCodeGrp) {
        $('#comCodeGrp').val(selectedCodeGrp);
    }
    
    $('.editComCodeGrp').on('change', function() {
        var selectedGrp = $(this).val();
        $('.editComCode').attr('placeholder', 'ex)'+selectedGrp + '001'); // 선택한 그룹 코드 + "001" 설정
    });
 // 코드 추가 버튼 클릭
    $(document).on("click", '.codeAdd', function() {
        var selectedCodeGrp = $('#comCodeGrp').val(); // 현재 선택된 그룹코드 가져오기
        if (selectedCodeGrp) {
            // 선택된 값이 있을 경우 코드 추가 폼의 그룹 코드 필드에 설정
            $('.codeAddForm #comCodeGrp').val(selectedCodeGrp);
        }
        $('.codeAddForm').show(); // 코드 추가 폼 보이기
        $('.grp-code-manage').hide(); // .grp-code-manage 숨기기
        $(this).hide(); // .codeAdd 버튼 숨기기
    });

    $(document).on("click", '.codeAddSubmit', function(e) {
        e.preventDefault(); // 기본 폼 제출 막기

        var selectedCodeGrp = $('#comCodeGrp').val(); // 추가 폼의 그룹 코드 값
        if (!selectedCodeGrp) {
            Toast.fire(
                '경고',
                '그룹코드를 선택해주세요.',
                'warning'
            );
            return;
        }

        $('#codeAddForm').submit(); // 선택된 값으로 폼 제출
    });
    
    // 코드 그룹 추가 버튼 클릭
    $(document).on("click", '.codeGrpAdd', function() {
        $('.codeGrpEditForm').show(); // 코드 그룹 폼 보이기
        $('.codeAdd').hide(); // .codeAdd 버튼 숨기기
        $('.codeGrpAdd').hide(); // .codeAdd 버튼 숨기기
        $('.codeGrpDel').hide(); // .codeAdd 버튼 숨기기
    });

    // 코드 추가 취소 버튼 클릭
    $(document).on("click", '.codeAddCancel', function() {
        $('.codeAddForm').hide(); // 코드 추가 폼 숨기기
        $('.grp-code-manage').show(); // .grp-code-manage 보이기
        $('.codeAdd').show(); // .codeAdd 버튼 보이기
    });

    // 코드 그룹 취소 버튼 클릭
    $(document).on("click", '.codeGrpCancel', function() {
        $('.codeGrpEditForm').hide(); // 코드 그룹 폼 숨기기
        $('.grp-code-manage').show(); // .grp-code-manage 보이기
        $('.codeAdd').show(); // .codeAdd 버튼 보이기
        $('.codeGrpAdd').show(); // .codeAdd 버튼 숨기기
        $('.codeGrpDel').show(); // .codeAdd 버튼 숨기기
    });
    
 // selectBox
    $('#comCodeGrp').on('change', function(event) {
        var selectedGroup = $(this).val();
        var currentPage = ${articlePage.currentPage}; // 현재 페이지 가져오기

        $.ajax({
            url: '/adm/getFilteredCodes',
            type: 'GET',
            data: { 
                comCodeGrp: selectedGroup,
                currentPage: currentPage // 현재 페이지도 함께 전달
            },
            success: function(data) {
                var tableBody = $('table tbody');
                tableBody.empty();

                $.each(data.filteredCodeList, function(_, codeVO) {
                    var row = '<tr>' +
                        '<td style="text-align: center;">' + codeVO.comCode + '</td>' +
                        '<td style="text-align: center;">' + codeVO.comCodeNm + '</td>' +
                        '<td style="text-align: center;">' + codeVO.comCodeDesc + '</td>' +
                        '<td style="text-align: center;">' +
                            '<button class="filter-button codeDel" data-id="' + codeVO.comCode + '">삭제</button>' +
                        '</td>' +
                    '</tr>';
                    tableBody.append(row);
                });
            },
            error: function(xhr, status, error) {
                console.error("Error: " + error);
            }
        });
    });

    $(document).on("click", '.codeCh', function() {
        const currentRow = $(this).closest('tr'); // 현재 행(tr)을 선택
        const comCode = currentRow.find('td:first').text(); // comCode 가져오기
        const comCodeNm = currentRow.find('.codeChInput').val(); // codeChInput에서 comCodeNm 가져오기
        const comCodeDesc = currentRow.find('.codeDescChInput').val(); // codeDescChInput에서 comCodeDesc 가져오기

        Swal.fire({
            title: '코드 이름과 설명을 변경하시겠습니까?',
            icon: 'question',
            showCancelButton: true,
            confirmButtonColor: 'white',
            cancelButtonColor: 'white',
            confirmButtonText: '예',
            cancelButtonText: '아니오',
             // 버튼 순서 거꾸로
        }).then((result) => {
            if (result.isConfirmed) {
                $.ajax({
                    url: '/adm/codeCodeCh',
                    type: 'POST',
                    data: {
                        comCode: comCode, // comCode 전달
                        comCodeNm: comCodeNm, // comCodeNm 전달
                        comCodeDesc: comCodeDesc // comCodeDesc 전달
                    },
                    beforeSend: function(xhr) {
                        xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                    },
                    success: function(response) {
                        if (response === "success") {
                            Toast.fire({
                  				icon:'success',
                  				title:'변경이 완료되었습니다.'
                  			}).then(() => {
                  				window.location.href = window.location.href;
                            });
                        } else {
                            Swal.fire(
                                '실패!',
                                '코드 이름 변경에 실패했습니다.',
                                'error'
                            );
                        }
                    },
                    error: function(xhr, status, error) {
                        Swal.fire(
                            '실패!',
                            '코드 이름 변경 실패: ' + error,
                            'error'
                        );
                    }
                });
            }
        });
    });

    // 코드 삭제
    $(document).on("click", '.codeDel', function() {
        const comCode = $(this).data('id');
        
        Swal.fire({
            title: '코드를 삭제하시겠습니까?',
            icon: 'error',
            showCancelButton: true,
            confirmButtonColor: 'white',
            cancelButtonColor: 'white',
            confirmButtonText: '예',
            cancelButtonText: '아니오',
             // 버튼 순서 거꾸로
        }).then((result) => {
            if (result.isConfirmed) {
                $.ajax({
                    url: '/adm/codeDel',
                    type: 'POST',
                    data: { comCode: comCode },
                    beforeSend: function(xhr) {
                        xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                    },
                    success: function(response) {
                        if (response === "success") {
                            Toast.fire({
                  				icon:'success',
                  				title:comCode+'가  삭제되었습니다.'
                  			}).then(() => {
                  				window.location.href = window.location.href;
                            });
                        } else {
                            Swal.fire(
                                '삭제 실패!',
                                '코드 삭제에 실패했습니다.',
                                'error'
                            );
                        }
                    },
                    error: function(xhr, status, error) {
                        Swal.fire(
                            '삭제 실패!',
                            '코드 삭제 실패: ' + error,
                            'error'
                        );
                    }
                });
            }
        });
    });

    // 코드 그룹 삭제
    $(document).on("click", '.codeGrpDel', function() {
        const selectedCodeGrp = $('#comCodeGrp').val();
        const selectedCodeGrpNm = $('#comCodeGrp option:selected').text();

        if (!selectedCodeGrp) {
            Swal.fire(
                '경고',
                '삭제할 카테고리를 선택하세요.',
                'warning'
            );
            return;
        }

        Swal.fire({
            title: selectedCodeGrpNm + ' 를 정말 삭제하시겠습니까?',
            icon: 'question',
            showCancelButton: true,
            confirmButtonColor: 'white',
            cancelButtonColor: 'white',
            confirmButtonText: '예',
            cancelButtonText: '아니오',
        }).then((result) => {
            if (result.isConfirmed) {
                Toast.fire({
      				icon:'success',
      				title: selectedCodeGrp+'가 삭제되었습니다.'
      			}).then(() => {
	                $('#codeGrpDelForm').submit();
                });
            }
        });
    });
});
</script>

