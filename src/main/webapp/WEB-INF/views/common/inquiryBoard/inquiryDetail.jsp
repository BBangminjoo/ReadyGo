<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="sec" 	uri="http://www.springframework.org/security/tags"%>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>

<!-- css 파일 -->
<link rel="stylesheet" 	href="<%=request.getContextPath()%>/resources/css/board/Detail.css" />
<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/alert.css" />

<script type="text/javascript" src="/resources/ckeditor5/ckeditor.js"></script>
<script type="text/javascript" src="/resources/js/sweetalert2.js"></script>
<sec:authentication property="principal" var="prc" />
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


<div class="container2">
	<div class="registTitle">
		<h2>문의 게시글</h2>
	</div>
	<div class="title-group">
		<div class="content-group">
			<form name="deletePost" id="deletePost" action="/common/inquiryBoard/deletePost" method="post">
				<div class="Content">
					<div class="rv-detail">
						<!--  제목 -->
						<div class="titlegroup">
							<div class="left" >
			                     <p style="font-weight: bold;  font-size: 30px;"> [${boardVO.pstOthbcscope}]&nbsp;${boardVO.pstTtl}</p>
		                  	</div>
						</div>
						<!--  제목 -->
						<!-- 작성자, 작성일, 조회수 -->
		                  <div class="reviewWit">
			                     <c:choose>
			                        <c:when test="${boardVO.mbrId == 'admin'}">
			                        <c:if test="${boardVO.pstMdfcnDt != null}">
				                        <div class="wit">
					                        <p>★관리자</p>
					                        <p>작성일&nbsp;:&nbsp;${boardVO.pstWrtDt}&nbsp;(수정됨)</p>
				                        </div>
			                        </c:if>
			                        
			                        <c:if test="${boardVO.pstMdfcnDt == null}">
				                        <div class="wit">
					                        <p>★관리자</p>
					                        <p>작성일&nbsp;:&nbsp;${boardVO.pstWrtDt}</p>
				                        </div>
			                        </c:if>
			                        </c:when>
			                     <c:otherwise>
			                      <c:if test="${boardVO.pstMdfcnDt != null}">
			                     	<div class="wit">
				                        <p>작성자&nbsp;:&nbsp;<a href="/member/profile?mbrId=${boardVO.mbrId}">${boardVO.mbrId}</a></p>
				                        <p>작성일&nbsp;:&nbsp; ${boardVO.pstWrtDt}&nbsp;(수정됨)</p>
			                        </div>
			                        </c:if>
			                        <c:if test="${boardVO.pstMdfcnDt == null}">
			                     	<div class="wit">
				                        <p>작성자&nbsp;:&nbsp;<a href="/member/profile?mbrId=${boardVO.mbrId}">${boardVO.mbrId}</a></p>
				                        <p>작성일&nbsp;:&nbsp; ${boardVO.pstWrtDt}</p>
			                        </div>
			                        </c:if>
			                        <div class="upDown">
			                     		<p>조회수&nbsp;:&nbsp;${boardVO.pstInqCnt}</p>
			                        </div>
			                     </c:otherwise>
			                     </c:choose>
		                  </div>
		                  <!-- 작성자, 작성일, 조회수 -->
							<div class="hr"></div>
							<!-- 리뷰내용 -->
							<div class="pstCn">${boardVO.pstCn}</div>
						</div> <!-- class="rv-detail -->
					</div> <!--  class="Content" -->
					
					<!-- 버튼 배치 -->
		            <div class="button-container">
		            <!-- 공지 목록 버튼 (왼쪽 정렬) -->
		            	<div id="editBox1">
		               		<a href="/common/inquiryBoard/inquiryList"><input type="button" id="savebtn" value="목록" /></a>
		               	</div>
		               	<!-- 수정 및 삭제 버튼 그룹 (오른쪽 정렬) -->
		               <div class="button-group-right">
		                  <!-- 비로그인 사용자 숨기기 -->
		                  <c:if test="${prc eq 'anonymousUser'}">
		                     <!-- 아무것도 표시하지 않음 -->
		                  </c:if>
		                  <!-- 로그인한 사용자일 때 -->
		                  <c:if test="${prc ne 'anonymousUser'}">
		                     <!-- 작성자일 때만 수정/삭제 버튼 표시 -->
		                     <c:if test="${prc.username == boardVO.mbrId}">
									<div id="editBox">
										<p>
											<input type="button" class="cancel" value="삭제" />
											<button type="button" id="savebtn" onclick="location.href='/common/inquiryBoard/inquiryUpdate?seNo=${boardVO.seNo}&pstSn=${boardVO.pstSn}'">수정</button>
										</p>
									</div>
		                     </c:if>
		                  </c:if>
		                  <input type="hidden" id="pstSn" name="pstSn" value="${boardVO.pstSn}" />
		               </div>
		            </div>
		            <!-- 버튼 배치 -->
					<sec:csrfInput />
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
									<strong style="background-color: rgba(36, 213, 158, 0.11);">★관리자</strong>(${comment.cmntRegDt})
	                         </c:when>
								<c:otherwise>
									<strong>${comment.mbrId}</strong>(${comment.cmntRegDt})
	                         </c:otherwise>
							</c:choose>
						</p>
						<div class="button-group-right">
							<p class="comment-content">${comment.cmntCn}</p>
							<div class="comment-buttons">
								<c:if
									test="${prc ne 'anonymousUser' and prc.username == comment.mbrId}">
									<button type="button" class="btn btn-delete-comment"
										data-id="${comment.cmntNo}">삭제</button>
									<button type="button" class="btn btn-edit-comment"
										data-id="${comment.cmntNo}">수정</button>
								</c:if>
							</div>
						</div>
	
						<!-- 댓글 수정 폼 시작-->
						<div class="edit-comment-form" style="display: none;">
							<input type="text" class="edit-comment-text"
								value="${comment.cmntCn}">
							<button type="button" class="btn btn-save-edit">저장</button>
							<button type="button" class="btn btn-cancel-edit">취소</button>
						</div>
						<!-- 댓글 수정 폼 끝-->
					</div>
				</c:forEach>
			</div>
			<!-- 댓글 목록 -->
		</div>
		<!-- 댓글 입력창 및 목록 섹션 -->
</div>
<script type="text/javascript">
$(document).ready(function(){
    $('.cancel').on('click', function() {
        Swal.fire({
            title: '게시글을 삭제하시겠습니까?',
            icon: 'error',
            showCancelButton: true,
            confirmButtonColor: 'white',
            cancelButtonColor: 'white',
            confirmButtonText: '예',
            cancelButtonText: '아니오',
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
