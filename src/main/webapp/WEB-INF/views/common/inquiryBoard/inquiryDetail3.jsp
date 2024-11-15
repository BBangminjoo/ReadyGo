<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<script type="text/javascript" src="/resources/ckeditor5/ckeditor.js"></script>
<script type="text/javascript" src="/resources/js/sweetalert2.js"></script>
<sec:authentication property="principal" var="prc"/>
<script type="text/javascript">
document.querySelector('#registForm').addEventListener('submit', function(event) {
    const selectElement = document.querySelector('#pstOthbcscope');
    const selectedValue = selectElement.value;
    
    if (selectedValue === "") {
        alert('공개범위를 선택해주세요.');
        event.preventDefault(); // 폼 제출을 막습니다
    }
});


$(function(){
// 	console.log(${memVO.mbrWarnCo});
// 	if(${memVO.mbrWarnCo} > 4){
// 		location.href = "/";
// 	};
// 	console.log(${memVO.mbrWarnCo});
    // CKEditor 글 복제
    $(".ck-blurred").keydown(function(){
        $("#pstCn").val(window.editor.getData());
    });

    $("#uploadFile").on("change", handleImg);

    $(".ck-blurred").focusout(function(){
        $("#perDet").val(window.editor.getData());
    });

});
ClassicEditor.create(document.querySelector('#pstCnTemp'))
.then(editor => {
    editor.enableReadOnlyMode('#pstCnTemp');
    window.editor = editor;
    
    // 폼 제출 전 CKEditor의 내용을 textarea에 동기화
    document.querySelector('#registForm').addEventListener('submit', function(event) {
        document.querySelector('#pstCn').value = editor.getData();
    });
})
.catch(error => {
    console.error(error);
});

$(document).ready(function(){
// 	console.log(${memVO.mbrWarnCo});
// 	if(${memVO.mbrWarnCo} > 4){
// 		location.href = "/";
// 	};
// 	console.log(${memVO.mbrWarnCo});
    // 댓글 등록 버튼 클릭 시
    $('#submitComment').on("click", function(event) {
        event.preventDefault(); // 폼 제출 막기
        
        const commentContent = $('#commentContent').val();  // 댓글 내용
        const pstSn = $('#pstSn').val();  // 게시글 번호
        
        if (commentContent === "") {
            alert("댓글을 입력하세요.");
            return;
        }

        // Ajax로 댓글 등록 요청
        $.ajax({
            url: '/common/inquiryBoard/registReplyPost',
            type: 'POST',
            data: {
                commentContent: commentContent,
                pstSn: pstSn
            },
            success: function(response) {
                loadComments(); // 성공 시 댓글 목록 갱신
                $('#commentContent').val(''); // 댓글 입력창 초기화
            },
            error: function(xhr, status, error) {
                alert('댓글 등록 실패: ' + error);
            }
        });
    });
    // 댓글 목록 로딩
    function loadComments() {
        const pstSn = $('#pstSn').val();

        $.ajax({
            url: '/common/inquiryBoard/replyList',
            type: 'GET',
            data: { pstSn: pstSn },
            success: function(response) {
                $('#commentsList').html(response); // 댓글 목록 업데이트
            },
            error: function(xhr, status, error) {
                alert('댓글 목록 로딩 실패: ' + error);
            }
        });
    }

    // 페이지 로드 시 댓글 목록 불러오기
    loadComments();
});
</script>
<style>
body {
    margin: 0;
    padding: 0;
    font-family: pretendard;
    background-color: #fff;
}

.container2 {
    width: 1000px;
    margin: 0 auto;
}

h1 {
    font-size: 28px;
    font-weight: bold;
    padding-top: 20px;
    color: black;
}

.Content {
    width: 100%;
    height: auto;
    border-radius: 20px;
    margin-top: 30px;
    border-top: 3px solid #24D59E;
    border-bottom: 3px solid #24D59E;
}

.cn-detail {
    margin-left: 20px;
    margin-bottom: 20px;
}

.btn {
    background: white;
    color: #24D59E;
    border: 1px solid #24D59E;
    width: 100px;
    transition: all 0.3s ease 0s;
    display: flex;
    justify-content: center;
    align-items: center;
    padding: 8px 15px;
    border-radius: 5px;
}

.btn:hover {
    background-color: #24D59E;
    color: white;
}

.button-container {
    display: flex;
    justify-content: space-between;
    margin-top: 20px;
}

.button-group-right {
    display: flex;
    gap: 10px;
}

.comment-section {
    margin-top: 30px;
}

.comment-input {
    display: flex;
    justify-content: space-between;
    margin-bottom: 10px;
}

.comment-input textarea {
    width: 90%;
    height: 50px;
    padding: 10px;
    border: 1px solid #ccc;
    border-radius: 8px;
    resize: none;
}

.comment-input button {
    width: 100px;
    height: 50px;
    margin-left: 10px;
}

.comment-list {
    border-top: 1px solid #ccc;
    margin-top: 20px;
}

.comment-list .comment-item {
    padding: 10px;
    border-bottom: 1px solid #eee;
    position: relative;
}
.btn-Del{
   width: 100px;
    display: flex;
    justify-content: center;
    align-items: center;
    text-align: center;
   padding: 8px 15px;
    border-radius: 5px;
    font-size: 14px;
    background: white;
   color: #232323;
   border: 1px solid #B5B5B5;
   transition: all 0.3s ease 0s;
}
.btn-Del:hover{
   background: #ECECEC;
   color: #232323;
   border: 1px solid #B5B5B5;
}
.btn-replyDel {
    position: absolute;
    right: 0;
    top: 10px;
    background-color: #24D59E;
    color: white;
    border-radius: 8px;
    width: 80px;
    height: 30px;
    transition: background-color 0.3s, color 0.3s;
}

.comment-list .comment-item p {
    margin: 0;
}

.comment-buttons {
    display: flex;
    gap: 10px;
}

.edit-comment-form {
    display: flex;
    gap: 10px;
    align-items: center;
    margin-top: 5px;
}

.btn-save-edit,
.btn-cancel-edit,
.btn-edit-comment,
.btn-delete-comment {
    padding: 5px 10px;
    font-size: 14px;
    height: 30px;
    width: 70px;
}
</style>

<div class="container2">
    <header>
        <h1>문의 게시판</h1>
    </header>
    <div class="title-group">
        <div class="content-group">
        <form name="deletePost" id="deletePost" action="/common/inquiryBoard/deletePost" method="post">
            <div class="Content">
                <div class="cn-detail">
                    <p style="font-weight: bold;font-size: 30px;"><br>[${boardVO.pstOthbcscope}]&nbsp;${boardVO.pstTtl}</p>
       					<c:choose>
							<c:when test = "${boardVO.mbrId == 'admin'}">
								<c:if test="${boardVO.pstMdfcnDt != null}">
								<p>★관리자(${boardVO.pstMdfcnDt}(수정함))<br>조회수:${boardVO.pstInqCnt}<hr></p>
								</c:if>
								<c:if test="${boardVO.pstMdfcnDt == null}">
								<p>★관리자(${boardVO.pstWrtDt})<br>조회수:${boardVO.pstInqCnt}<hr></p>
								</c:if>
							</c:when>
						<c:otherwise>
							<c:if test="${boardVO.pstMdfcnDt != null}">
							<p>${boardVO.mbrId}(${boardVO.pstMdfcnDt}(수정함))<br>조회수:${boardVO.pstInqCnt}<hr></p>
							</c:if>
							<c:if test="${boardVO.pstMdfcnDt == null}">
							<p>${boardVO.mbrId}(${boardVO.pstWrtDt})<br>조회수:${boardVO.pstInqCnt}<hr></p>
							</c:if>
						</c:otherwise>
						</c:choose>
                    <p>${boardVO.pstCn}</p>
                </div>
            </div>
            <!-- 버튼 배치 -->
		    <div class="button-container">
		        <!-- 공지 목록 버튼 (왼쪽 정렬) -->
		        <button type="button" class="btn btn-List" onclick="location.href='/common/inquiryBoard/inquiryList'">목록</button>
		        <!-- 수정 및 삭제 버튼 그룹 (오른쪽 정렬) -->
		        <div class="button-group-right">
    				<c:if test="${prc eq 'anonymousUser'}">
				        <!-- 아무것도 표시하지 않음 -->
				    </c:if>
					    <!-- 로그인한 사용자인 경우 -->
				    <c:if test="${prc ne 'anonymousUser'}">
				        <!-- 로그인한 사용자와 게시글 작성자가 같을 때만 수정/삭제 버튼을 표시 -->
				        <c:if test="${prc.username == boardVO.mbrId}">
				            <button type="button" class="btn btn-Del">삭제</button>
				        	<button type="button" class="btn btn-Edit" onclick="location.href='/common/inquiryBoard/inquiryUpdate?seNo=${boardVO.seNo}&pstSn=${boardVO.pstSn}'">수정</button>
				            <input type="hidden" name="pstSn" id="pstSn" value="${boardVO.pstSn}">
			            </c:if>
		            </c:if>
		        </div>
		    </div>
            <sec:csrfInput/>
        </form>
        </div>
    </div>

    <!-- 댓글 입력창 및 목록 섹션 -->
    <div class="comment-section">
        <!-- 댓글 목록 -->
        <div id="commentsList">
            <c:if test="${empty commentsList}">
            	<c:choose>
            		<c:when test="${boardVO.mbrId =='admin'}"></c:when>
            		<c:otherwise>
		            <p>답변이 등록되지 않았습니다.</p>
		            </c:otherwise>
	            </c:choose>
	        </c:if>
		    <c:forEach var="comment" items="${commentsList}">
            <div class="comment-item" data-cmnt-no="${comment.cmntNo}">
				    <p>
                     <c:choose>
                         <c:when test="${comment.mbrId == 'admin'}">
                             <strong style="background-color:  rgba(36, 213, 158, 0.11);">★관리자</strong>(${comment.cmntRegDt})
                         </c:when>
                         <c:otherwise>
                             <strong>${comment.mbrId}</strong>(${comment.cmntRegDt})
                         </c:otherwise>
                     </c:choose>
				    </p>
					<div class="button-group-right">
					    <p class="comment-content">${comment.cmntCn}</p>
					    <div class="comment-buttons">
					        <c:if test="${prc ne 'anonymousUser' and prc.username == comment.mbrId}">
					            <button type="button" class="btn btn-delete-comment" data-id="${comment.cmntNo}">삭제</button>
					            <button type="button" class="btn btn-edit-comment" data-id="${comment.cmntNo}">수정</button>
					        </c:if>
					    </div>
					</div>

	                <!-- 댓글 수정 폼-->
	                <div class="edit-comment-form" style="display: none;">
			            <input type="text" class="edit-comment-text" value="${comment.cmntCn}">
			            <button type="button" class="btn btn-save-edit">저장</button>
			            <button type="button" class="btn btn-cancel-edit">취소</button>
			        </div>
		        </div>
		        </c:forEach>
            </div>
</div>
</div>
<script type="text/javascript">
$(document).ready(function(){
    $('.btn-Del').on('click', function() {
        Swal.fire({
            title: '게시글을 삭제하시겠습니까?',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: '삭제',
            cancelButtonText: '취소',
            reverseButtons: true
        }).then((result) => {
            if (result.isConfirmed) {
                $('#deletePost').submit();
            }
        });
    });
    // 댓글 수정 버튼 클릭 시
    $(document).on("click", '.btn-edit-comment', function() {
        const commentItem = $(this).closest('.comment-item');
        commentItem.find('.comment-content').hide(); // 댓글 내용 숨기기
        commentItem.find('.edit-comment-form').show(); // 수정 폼 표시하기
    });

    // 댓글 수정 저장 버튼 클릭 시
    $(document).on("click", '.btn-save-edit', function() {
        const commentItem = $(this).closest('.comment-item');
        const cmntNo = commentItem.data('cmnt-no');
        const pstSn = $('#pstSn').val();
        const cmntCn = commentItem.find('.edit-comment-text').val();

        $.ajax({
            url: '/common/inquiryBoard/updateComment',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify({
                cmntNo: cmntNo,
                pstSn: pstSn,
                cmntCn: cmntCn
            }),
            beforeSend: function(xhr) {
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
            },
            success: function(response) {
                if (response === "success") {
                    commentItem.find('.comment-content').text(cmntCn).show(); // 댓글 내용 업데이트 및 표시
                    commentItem.find('.edit-comment-form').hide(); // 수정 폼 숨기기
                } else {
                    alert('댓글 수정 실패');
                }
            },
            error: function(xhr, status, error) {
                alert('댓글 수정 실패: ' + error);
            }
        });
    });

    // 댓글 수정 취소 버튼 클릭 시
    $(document).on("click", '.btn-cancel-edit', function() {
        const commentItem = $(this).closest('.comment-item');
        commentItem.find('.comment-content').show(); // 댓글 내용 표시
        commentItem.find('.edit-comment-form').hide(); // 수정 폼 숨기기
    });

    // 댓글 삭제 버튼 클릭 시
    $(document).on("click", '.btn-delete-comment', function() {
        if (confirm('댓글을 삭제하시겠습니까?')) {
            const cmntNo = $(this).data('id');
            const pstSn = $('#pstSn').val();
            
            $.ajax({
                url: '/common/inquiryBoard/deleteComment',
                type: 'POST',
                data: {
                    cmntNo: cmntNo,
                    pstSn: pstSn
                },
                beforeSend: function(xhr) {
                    xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                },
                success: function(response) {
                    if (response === "success") {
                        location.reload(); // 댓글 삭제 후 목록 갱신.. 리로드로할게...
                    } else {
                        alert('댓글 삭제 실패');
                    }
                },
                error: function(xhr, status, error) {
                    alert('댓글 삭제 실패: ' + error);
                }
            });
        }
    });
});

ClassicEditor.create(document.querySelector('#pstCnTemp'))
    .then(editor => {
        editor.enableReadOnlyMode('#pstCnTemp');
        window.editor = editor;
        
        // 폼 제출 전 CKEditor의 내용을 textarea에 동기화
        document.querySelector('#registForm').addEventListener('submit', function(event) {
            document.querySelector('#pstCn').value = editor.getData();
        });
    })
    .catch(error => {
        console.error(error);
    });
</script>
