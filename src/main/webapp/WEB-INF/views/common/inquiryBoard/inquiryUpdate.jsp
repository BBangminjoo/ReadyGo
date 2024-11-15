<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<script type="text/javascript" src="/resources/ckeditor5/ckeditor.js"></script>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>

<!-- css 파일 -->
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/resources/css/board/Regist_Update.css" />


<script type="text/javascript">

</script>

<div class="registAll">
	<!-- 등록 정보 전체 -->
	<div class="regist">
		<div class="registTitle">
			<h2>문의 게시글 수정</h2>
		</div>

		<div class="smRegust">
			<div class="size">
				<form name="registForm" id="registForm" action="/common/inquiryBoard/updatePost" method="post">
					<div class="title-group">
						<div class="cat_main">
							<select class="form-control category" name="pstOthbcscope"
								id="pstOthbcscope" required>
								<option value="" selected disabled hidden>공개범위 선택</option>
								<c:forEach var="codeVO" items="${codeVOList}">
									<c:choose>
										<c:when test="${codeVO.comCodeNm == boardVO.pstOthbcscope}">
											<option value="${codeVO.comCodeNm}" selected>${codeVO.comCodeNm}</option>
										</c:when>
										<c:otherwise>
											<option value="${codeVO.comCodeNm}">${codeVO.comCodeNm}</option>
										</c:otherwise>
									</c:choose>
								</c:forEach>
							</select>
						</div>
						<input type="text" class="input-title" placeholder="제목을 작성해주세요"
							name="pstTtl" id="pstTtl" value="${boardVO.pstTtl}">
					</div>
					<div class="content-group">
						<div id="pstCnTemp" name="pstCnTemp">
							<textarea id="pstCn" name="pstCn"></textarea>
						</div>
					</div>
					<input type="hidden" name="pstSn" value="${boardVO.pstSn}">
					<div id="editBox">
						<p>
							<a href="/common/inquiryBoard/inquiryList"><input type="button" class="cancel" value="취소" /> </a>
							<input type="submit" id="savebtn" value="등록" />
						</p>
					</div>
					
						<!-- css가 잘 안먹어서 바꿈  -->
<!-- 					<div class="button-container"> -->
<!-- 						<button type="button" class="faq-btn btn-list" -->
<!-- 							onclick="location.href='/common/inquiryBoard/inquiryList'">취소</button> -->
<!-- 						<button type="submit" class="faq-btn btn-regist">수정</button> -->
<!-- 					</div> -->
					<sec:csrfInput />
				</form>
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
ClassicEditor.create(document.querySelector('#pstCnTemp'), { 
    placeholder: '\n 내용을 작성해주세요 \n\n * 등록한 글은 사용자 아이디로 등록됩니다. \n * 문의 내용을 상세히 적어주시면 더 명확한 답변을 해드릴 수 있습니다.',
    ckfinder: {
        uploadUrl: '/image/upload?${_csrf.parameterName}=${_csrf.token}'  // 파일 업로드 경로
    }
})
.then(editor => { 
    window.editor = editor;
    
    editor.setData('${boardVO.pstCn}');	//입력된 값 넣는 곳!
    
    // 폼 제출 전 CKEditor의 내용을 textarea에 동기화
    document.querySelector('#registForm').addEventListener('submit', function(event) {
        document.querySelector('#pstCn').value = editor.getData();
    });
})
.catch(err => { console.error(err.stack); });
</script>
