<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags"
	prefix="sec"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!-- 기업정보수정css -->
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/resources/css/enter/passEdit.css" />
<!-- jquery -->
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<script type="text/javascript" src="/resources/js/sweetalert2.js"></script>

<script>
//전역함수
//e : onchange 이벤트
var Toast = Swal.mixin({
toast: true,
position: 'center',
showConfirmButton: false,
timer: 3000
});

let passChk = false;
$(function() {
	var auth = $("#authval").val();
    console.log("User Authorities: ", auth);

    if (auth.indexOf("ROLE_MEMBER") !== -1) {
        alert("회원으로 접근할 수 없습니다.");
        location.href="/";
    }else if (auth.indexOf("ROLE_ADMIN") !== -1) {
        alert("관리자로 접근할 수 없습니다.");
        document.getElementById('logoutBtn').submit();
    }
    
$("#detailChkBtn").on("click",function() {
	let formData = new FormData();
	let entId = $("#entId").val();
	let entPswds = $("#entPswds").val();
	console.log("entId : " + entId);
	console.log("entPswds : " + entPswds);
	formData.append("entId", entId);
	formData.append("entPswd", entPswds);
	$.ajax({
		url : "/enter/editChk",
		processData : false,
		contentType : false,
		data : formData,
		type : "post",
		dataType : "text",
		beforeSend : function(xhr) {
			xhr.setRequestHeader("${_csrf.headerName}",
					"${_csrf.token}");
		},
		success : function(result) {
			console.log("result : " + result);
			if (result == "false") {
				Toast.fire({
					icon : 'error',
					title : '비밀번호를 다시 입력해주세요!',
					 // 커스텀 클래스 추가
				    customClass: {
				        popup: 'my-custom-popup'  // CSS에서 정의한 클래스 이름
				    }  
				});
				return;
			}
			Toast.fire({
				icon : 'success',
				title : '비밀번호 일치!',
					 // 커스텀 클래스 추가
				    customClass: {
				        popup: 'my-custom-popup'  // CSS에서 정의한 클래스 이름
				    }  
			}).then(() => {
			    // 다음 작업 실행
			    console.log("SweetAlert가 끝났습니다. 다음 동작을 수행합니다.");
			$("#chkchk").attr("hidden", true);
			$(".all").attr("hidden", false);
			});
		}
	})
});
// 기존 비밀번호변경 확인버튼
$("#chkBtnn").on("click",function() {
	let formData = new FormData();
	let entId = $("#entId").val();
	let entPswd = $("#currentPassword").val();
	console.log("entId : " + entId);
	console.log("entPswd : " + entPswd);
	formData.append("entId", entId);
	formData.append("entPswd", entPswd);
	$.ajax({
		url : "/enter/editChk",
		processData : false,
		contentType : false,
		data : formData,
		type : "post",
		dataType : "text",
		beforeSend : function(xhr) {
			xhr.setRequestHeader("${_csrf.headerName}",
					"${_csrf.token}");
		},
		success : function(result) {
			console.log("result : " + result);
			// success, error, warning, info, question
			if (result == "false") {
				Toast.fire({
					icon : 'error',
					title : '비밀번호 불일치!'
				});
				return;
			}
			Toast.fire({
				icon : 'success',
				title : '비밀번호 일치!'
			})
			$("#enterPswd").attr("readonly",false);
			$("#confirmPswd").attr("readonly",false);
		}
	})
});
$("#save").on("click", function(e) {
    e.preventDefault();  // 기본 폼 제출 동작 방지

    // 비밀번호와 비밀번호 확인 필드 값 가져오기
    let password = $("#enterPswd").val();
    let confirmPassword = $("#confirmPswd").val();

    // 비밀번호 일치 여부 확인
    if (password !== confirmPassword) {
        // 일치하지 않으면 경고 메시지 표시
			Toast.fire({
				icon:'error',
				title:'새 비밀번호와 확인 비밀번호가 서로 일치하지 않습니다.',
				 // 커스텀 클래스 추가
			    customClass: {
			        popup: 'my-custom-popup'  // CSS에서 정의한 클래스 이름
			    }  
			});
        return;  // 서버로 요청하지 않고 함수 종료
    }

    // 비밀번호가 일치하면 서버로 요청 진행
    let formData = new FormData($("#passEdit")[0]);  // 비밀번호 수정 폼 데이터
    if(passChk){
	    $.ajax({
	        url: $("#passEdit").attr("action"),  // 폼의 action URL
	        type: "post",
	        data: formData,
	        processData: false,
	        contentType: false,
	        beforeSend: function(xhr) {
	            xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
	        },
	        success: function(response) {
	            // 성공적으로 처리되었을 경우 alert 표시
				Toast.fire({
					icon:'success',
					title:'비밀번호 수정 성공!',
					 // 커스텀 클래스 추가
				    customClass: {
				        popup: 'my-custom-popup'  // CSS에서 정의한 클래스 이름
				    }  
				}).then(function() {
	                  window.location.reload();  // 필요에 따라 페이지 새로고침
	            });
	        },
	        error: function(error) {
				Toast.fire({
					icon:'error',
					title:'비밀번호 수정 실패!',
					 // 커스텀 클래스 추가
				    customClass: {
				        popup: 'my-custom-popup'  // CSS에서 정의한 클래스 이름
				    }  
				});
	        }
	    });
    }else{
			Toast.fire({
				icon:'error',
				title:'8~16자의 영문(대소문자), 숫자, 특수문자(!@#$%^&*)를 혼합하여 입력해주세요.',
				 // 커스텀 클래스 추가
			    customClass: {
			        popup: 'my-custom-popup'  // CSS에서 정의한 클래스 이름
			    }  
			});
    }
});

});
$(function() {
	// 취소 버튼 클릭
	$("#cancel").on("click", function() {
		// 비밀번호 입력란과 확인란 초기화
		$("#currentPassword").val("");
		$("#enterPswd").val("");
		$("#confirmPswd").val("");
		$("#checkPw").html("");
		location.reload();
	});

// 새 비밀번호와 확인 비밀번호 일치 여부 확인
	$(document).ready(function() {

	    // 새 비밀번호와 확인 비밀번호 일치 여부 확인 및 유효성 검사
	    $("#enterPswd, #confirmPswd").on("keyup", function() {
	        let password = $("#enterPswd").val();
	        let confirmPassword = $("#confirmPswd").val();
	        
	        // 비밀번호 정규식: 8~16자의 영문(대소문자), 숫자, 특수문자 포함
	        let passwordPattern = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{8,16}$/;
	        // 새 비밀번호 유효성 검사
	        if (!passwordPattern.test(password)) {
	            $("#checkPw1").html("<p>비밀번호는 8~16자의 영문(대소문자), 숫자, <br>특수문자(!@#$%^&*)를 혼합하여 입력해주세요.</p>")
	                         .css("color", "red");
	        } else {
	            // 비밀번호 형식이 올바른 경우 에러 메시지 제거
	            $("#checkPw1").html(""); 
	            passChk=true;
	        }

	        // 새 비밀번호와 확인 비밀번호가 일치하는지 확인	        	
		        if (password === confirmPassword && confirmPassword !== "") {
		            $("#checkPw").html("비밀번호 일치").css("color", "#24D59E");
		        } else if (confirmPassword !== "") {
		            $("#checkPw").html("비밀번호 불일치").css("color", "red");
		        } else {
		            $("#checkPw").html(""); // 확인란이 비어있을 경우 메시지 숨김
		        }
	    });
	});
});

</script>
<div hidden="hidden">
	<form id="logoutBtn" action="/logout" method="post">
        	<button type="submit">로그아웃</button>
         <sec:csrfInput />
      </form>
</div>
<sec:authorize access="isAuthenticated()">
	    	<sec:authentication property="principal.authorities" var="userAuthorities" />
	    	<input id="authval" type="hidden" value="${userAuthorities}">
			<sec:authentication property="principal" var="prc"/>		           
</sec:authorize>
<div id="chkchk">
	<form action="/enter/editChk" method="post">
		<div>
			<div>
				<img class="chkImg" src="../resources/images/logo.png" />
				<p class="chkP">
					&nbsp;&nbsp;기업의 정보를 안전하게 보호하기 위해 <br>다시 한 번 인증을 진행해 주시기 바랍니다.
				</p>
			</div>
			<div>
				<input type="password" placeholder="비밀번호를 입력해주세요." id="entPswds"
					name="entPswd" />
			</div>
			<div>
				<button type="button" class="chkbtn" id="detailChkBtn">확인</button>
			</div>
		</div>
		<sec:csrfInput />
	</form>
</div>
<br>
<div class="all" hidden="hidden">
	<input type="hidden" id="entId" value="${enterVO.entId}" />
	<div class="container1">
		<br>
		<br>
		<div class="passContainer">
			<form action="/enter/editChk" method="post">
				<h3>비밀번호 수정</h3>
				<div class="form-group">
					<label for="currentPassword">기존 비밀번호</label>
					 <input type="password" 
						id="currentPassword" class="edit-control"
						placeholder="기존 비밀번호를 입력하세요." required>
					<button type="button" class="chkbtnn" id="chkBtnn">확인</button>
				</div>
				<sec:csrfInput />
			</form>
			
			<form name="passEdit" id="passEdit" action="/enter/passEditPost?entId=${enterVO.entId}" method="post">
			<div class="form-group">
			    <div style="flex-direction: column;">
			        <div style="display: flex;">
			            <label for="entPswd">새 비밀번호</label> 
			            <input type="password" id="enterPswd" name="entPswd" class="edit-control"
			                   placeholder="새 비밀번호를 입력하세요." required>
			        </div>
			        <div style="margin-left: 195px;">
			            <span id="checkPw1"></span> 
			        </div>
			    </div>
			</div>
			<div class="form-group">
			    <label for="confirmPswd">새 비밀번호 확인</label> 
			    <input type="password" id="confirmPswd" class="edit-control"
			           placeholder="비밀번호를 한 번 더 입력하세요." required>
			    <p id="checkalert">
			        <span id="checkPw"></span> 
			    </p>
			</div>
				<div class="btn-group">
					<!-- 버튼 중앙 정렬 -->
					<div class="button1">
						<input type="button" id="cancel" value="취소" />
					</div>
					<div class="button1">
						<input type="submit" id="save" value="저장" />
					</div>
				</div>
				<sec:csrfInput />
			</form>
			</div>
	</div>
</div>
