<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<script type="text/javascript" src="/resources/ckeditor5/ckeditor.js"></script>
<sec:authentication property="principal" var="prc"/>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
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
    margin: 40px 0 30px;
}

input[type="text"] {
    width: 200px;
    padding: 10px;
    border: 1px solid #ccc;
    border-radius: 4px;
    margin-bottom: 10px;
}

.search-button,
.filter-button {
    padding: 10px 20px;
    border: 1px solid #FD5D6C;
    border-radius: 5px;
    cursor: pointer;
    background-color: white;
    color: #FD5D6C;
    transition: background-color 0.3s, color 0.3s; 
}

.filter-button:hover {
    background-color: #FD5D6C;
    color: white;
    border: 1px solid #FD5D6C; 
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

.page-item.active .page-link {
    color: #FD5D6C;
    background-color: rgba(253, 93, 108, 0.11);
    border-radius: 7px;
    border-color: #FD5D6C;
}
.fas {
	color: black;
}
.fas:hover{
	color: gray;
	text-decoration: underline;
}
.entNo{
    padding: 10px 20px;
    border: 1px solid #B5B5B5;
    border-radius: 5px;
    background-color: white;
 	color: #232323;
    transition: background-color 0.3s, color 0.3s; 
}

.entNo:hover{
   background: #ECECEC;
   color: #232323;
   border: 1px solid #B5B5B5;
}
table tbody tr:hover {
    background-color: rgba(253, 93, 108, 0.1);
    transition: background-color 0.3s ease;
}
.pagination-wrapper tbody tr:hover {
    background-color: initial;
}
</style>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<script type="text/javascript">
// 승인 버튼 클릭 시
// 승인 버튼 클릭 시
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
$(document).on("click", '.entOk', function() {
    const entId = $(this).closest('tr').find('td:first').text();
    Swal.fire({
        title: '정말 승인을 하시겠습니까?',
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
                url: '/adm/entOk',
                type: 'POST',
                data: { entId: entId },
                beforeSend: function(xhr) {
                    xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                },
                success: function(result) {
                    if (result > 0) {
                        Toast.fire({
              				icon:'success',
              				title:'가입 승인이 완료되었습니다.'
              			}).then(() => {
                            location.reload();
                        });
                    } else {
                        Swal.fire(
                            '승인 실패',
                            '승인에 실패했습니다.',
                            'error'
                        );
                    }
                },
                error: function() {
                    Swal.fire(
                        '서버 오류',
                        '서버에 문제가 발생했습니다.',
                        'error'
                    );
                }
            });
        }
    });
});

// 거절 버튼 클릭 시
$(document).on("click", '.entNo', function() {
    const entId = $(this).closest('tr').find('td:first').text();
    Swal.fire({
        title: '승인 거절하시겠습니까?',
        icon: 'question',
        showCancelButton: true,
        confirmButtonColor: 'white',
        cancelButtonColor: 'white',
        confirmButtonText: '예',
        cancelButtonText: '아니오',
    }).then((result) => {
        if (result.isConfirmed) {
            $.ajax({
                url: '/adm/entNo',
                type: 'POST',
                data: { entId: entId },
                beforeSend: function(xhr) {
                    xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                },
                success: function(result) {
                    if (result === 'success') {
                        Toast.fire({
              				icon:'success',
              				title:'가입 승인을 거절하셨습니다.'
              			}).then(() => {
                            location.reload();
                        });
                    } else {
                        Swal.fire(
                            '거절 실패',
                            '거절에 실패했습니다.',
                            'error'
                        );
                    }
                },
                error: function() {
                    Swal.fire(
                        '서버 오류',
                        '서버에 문제가 발생했습니다.',
                        'error'
                    );
                }
            });
        }
    });
});


$(document).on("click", '.entDetail', function() {
    const entId = $(this).closest('tr').find('td:first').text();
    
    $.ajax({
        url: '/adm/enterDetail',
        type: 'GET',
        data: { entId: entId },
        success: function(data) {
            if (data) {
                // 엔터프라이즈 상세 정보 채우기
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

                // 파일 링크 추가
				if (data.fileDetailVOList && data.fileDetailVOList.length > 0) {
				    let fileLinks = '';
				    data.fileDetailVOList.forEach(function(file) {
				        fileLinks += '<a href="' + file.filePathNm + '" target="_blank" download="' + file.orgnlFileNm + '">' +
				                     '<i class="fas fa-link mr-1">' + file.orgnlFileNm + ' (' + file.fileFancysize + ')</i></a><br>';
				    });
				    $('#modal-entBrNo').html(fileLinks); // 파일 링크 추가
				} else {
				    $('#modal-entBrNo').text('제출한 사업자 등록증이 없습니다.'); // 파일이 없을 때 처리
				}

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


</script>

<div class="container">
	<header>
		<h1>기업승인 관리</h1>
	</header>
	<table>
		<colgroup>
		    <col style="width: 20%;">
		    <col style="width: 20%;">
		    <col style="width: 20%;">
		    <col style="width: 20%;">
		    <col style="width: 10%;">
		    <col style="width: 10%;">
		</colgroup>
		<thead>
			<tr>
				<th style="text-align: center; font-size:18px;">아이디</th>
				<th style="text-align: center; font-size:18px;">대표자</th>
				<th style="text-align: center; font-size:18px;">기업 이름</th>
				<th style="text-align: center; font-size:18px;">제출정보</th>
				<th style="text-align: center; font-size:18px;">거절</th>
				<th style="text-align: center; font-size:18px;">승인</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="entVO" items="${articlePage.content}">
				<tr>
					<td style="text-align: center;">${entVO.entId}</td>
					<td style="text-align: center;">${entVO.entRprsntvNm}</td>
					<td style="text-align: center;">${entVO.entNm}</td>
					<td style="text-align: center;">
						<button class="filter-button entDetail">제출정보조회</button>
					</td>
					<td style="text-align: center;">
						<button class="filter-button entNo">거절</button>
					</td>
					<td style="text-align: center;">
						<button class="filter-button entOk">승인</button>
					</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
</div>

<div id="entDetailModal" class="modal" tabindex="-1" role="dialog">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">제출정보 조회</h5>
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
        <!-- 필요시 다른 필드 추가 -->
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
      </div>
    </div>
  </div>
</div>

<!--페이지네이션 -->
<div class="card-body table-responsive p-0" style="display: flex; justify-content: center;">
    <table style="margin-bottom: 30px;" class="pagination-wrapper">
        <tr>
            <td colspan="4" style="text-align: center; border-bottom: none;">
                <div class="dataTables_paginate" id="example2_paginate" style="display: flex; justify-content: center; margin-top: 20px;">
                    <ul class="pagination">
                        <!-- 맨 처음 페이지로 이동 버튼 -->
                        <c:if test="${articlePage.currentPage gt 1}">
                            <li class="paginate_button page-item first">
                                <a href="/adm/entApproval?currentPage=1"
                                   aria-controls="example2" data-dt-idx="0" tabindex="0" class="page-link">&lt;&lt;</a>
                            </li>
                        </c:if>

                        <!-- 이전 페이지 이동 버튼 -->
                        <c:if test="${articlePage.startPage gt 5}">
                            <li class="paginate_button page-item previous">
                                <a href="/adm/entApproval?currentPage=${articlePage.currentPage - 5}"
                                   aria-controls="example2" data-dt-idx="0" tabindex="0" class="page-link">&lt;</a>
                            </li>
                        </c:if>

                        <!-- 페이지 번호 -->
                        <c:forEach var="pNo" begin="${articlePage.startPage}" end="${articlePage.endPage}">
                            <li class="paginate_button page-item ${pNo == articlePage.currentPage ? 'active' : ''}">
                                <a href="/adm/entApproval?currentPage=${pNo}" aria-controls="example2" class="page-link">${pNo}</a>
                            </li>
                        </c:forEach>

                        <!-- 다음 페이지 이동 버튼 -->
                        <c:if test="${articlePage.endPage lt articlePage.totalPages}">
                            <li class="paginate_button page-item next">
                                <a href="/adm/entApproval?currentPage=${articlePage.currentPage + 5}"
                                   aria-controls="example2" data-dt-idx="7" tabindex="0" class="page-link">&gt;</a>
                            </li>
                        </c:if>

                        <!-- 맨 마지막 페이지로 이동 버튼 -->
                        <c:if test="${articlePage.currentPage lt articlePage.totalPages}">
                            <li class="paginate_button page-item last">
                                <a href="/adm/entApproval?currentPage=${articlePage.totalPages}"
                                   aria-controls="example2" data-dt-idx="7" tabindex="0" class="page-link">&gt;&gt;</a>
                            </li>
                        </c:if>        
                    </ul>
                </div>
            </td>
        </tr>
    </table>
</div>


