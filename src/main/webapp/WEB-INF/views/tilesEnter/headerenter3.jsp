<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
	<meta charset="utf-8">
<!--     <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"> -->

   <link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/Project-Noonnu/noonfonts_2107@1.1/Pretendard.css">

    <title>Cyborg - Awesome HTML5 Template</title>

    <!-- Bootstrap core CSS -->
    <link href="resources/css/bootstrap.min.css" rel="stylesheet">
<!-- Additional CSS Files -->
    <link rel="stylesheet" href="../resources/assets/css/fontawesome.css">
    <link rel="stylesheet" href="../resources/assets/css/templatemo-cyborg-gaming.css">
    <link rel="stylesheet" href="../resources/assets/css/owl.css">
    <link rel="stylesheet" href="../resources/assets/css/animate.css">
    <link rel="stylesheet"href="https://unpkg.com/swiper@7/swiper-bundle.min.css"/>

<script>
$(function(){
	$.ajax({
        url: '/notification/getAlramCnt',  // 서버에서 알림 목록을 가져오는 API
        method: 'GET',
        dataType: 'json',
        success: function(result) {
            var notificationCount = result;
	
            // 알림 갯수 표시
            if (notificationCount > 0) {
            	$('#notificationBadge').show().text(notificationCount);
        		console.log("성공");
            } else {
            	$('#notificationBadge').hide().text(0);
        		console.log("실패");
            }
        },
        error: function() {
            console.error('알림 갯수를 가져오는 데 실패했습니다.');
        }
    });
	
	// 로그인 상태를 나타내는 변수
    let isLoggedIn = true; // 로그인 상태 (true 또는 false로 설정)

    let userId = ""; // 로그인된 사용자 ID (실제 ID를 가져오는 로직으로 대체 가능)

    const nav = $('.navEnter');
    console.log(nav);
 
</script>
<!-- ***** Header Area Start ***** -->
  <header class="header-area header-sticky">
    <div class="container">
        <div class="row">
            <div class="col-12">
                <nav class="main-nav" style="margin-left:500px;">
                    <!-- ***** Logo Start ***** -->
                    <a href="#" class="logo">
                        <img src="../resources/images/logo.png" alt="">
                    </a>
                    <!-- ***** Logo End ***** -->
                    <!-- ***** Search End ***** -->
                    <div class="search-input">
				         <nav id="enterMenuParent">
							<ul id="enterMenu">
								<li class="menuDetail"><a href="#">공고관리</a></li>
								<li class="menuDetail"><a href="#">지원자관리</a></li>
								<li class="menuDetail"><a href="#">스카우트제안</a></li>
								<li class="menuDetail"><a href="#">인재</a></li>
							</ul>
						</nav>
                    </div>
                    
                    <!-- ***** Search End ***** -->
                    <!-- ***** Menu Start ***** -->
                    <ul class="navEnter" style="display:flex;">
                      <sec:authorize access="isAuthenticated()">
		                <p style="color: white; overflow: auto;">
						    <sec:authentication property="principal.memVO" var="memVO"/>
					    </p>
		                <p style="color: white; overflow: auto;">
						    <sec:authentication property="principal.entVO" var="entVO"/>
					    </p>
					    <c:if test="${memVO != null}">
			                <li class="iconSize">
				                <a href="#">
				                    <img src="../resources/images/Chat.png" alt="채팅 아이콘" />
				                </a>
				            </li>
				            <li class="iconSize">
				                <a href="#">
				                    <img src="../resources/images/inform.png" alt="알림 아이콘" />
				                </a>
				            </li>
				            <form action="/logout" method="post">
				            	<button type="submit" id="logoutBtn">로그아웃</button>
					            <sec:csrfInput />
				            </form>
					            <li id="headerUser"><a href="#">${memVO.mbrNm} <img src="../resources/assets/images/profile-header.jpg" alt=""></a></li>
					            <li><a href="#">기업서비스</a></li>
					    </c:if>
					    <c:if test="${entVO != null}">
			                <li class="iconSize" style="padding:10px;">
				                <a href="#">
				                    <img src="../resources/images/Chat.png" alt="채팅 아이콘" />
				                </a>
				            </li>
				            <li class="iconSize">
				                <a href="#">
				                    <img src="../resources/images/inform.png" alt="알림 아이콘" />
				                </a>
				            </li>
				            <!-- 웹소켓알림 -->
							<li class="iconSize dropdown">
							    <a href="#" id="notificationIcon" class="nav-link" aria-expanded="false">
							        <img src="../../resources/images/inform.png" alt="알림 아이콘" />
							        <c:if test="${not empty alramList}">
							            <span class="badge badge-warning navbar-badge" id="notificationBadge">띵</span>
							        </c:if>
							    </a>
							    <div class="dropdown-menu dropdown-menu-lg dropdown-menu-right" id="notificationDropdown">
									<c:forEach var="alram" items="${alramList}">
									    <div class="notification-item">
									    	<div class="alarmTitle">알림</div>
									    	<div class="alarmDate"><span class="dat"></span><fmt:formatDate value="${alram.ntcnYmd}" pattern="yyyy.MM.dd hh:mm:ss"/></div>
									        <a href="${alram.ntcnUrl}" class="dropdown-item notify-link">
									            ${alram.ntcnCn}
									        </a>
									        <button class="alramDel">x</button>
									        <input type="hidden" class="ntcnNo" value="${alram.ntcnNo}" />
									    </div>
									</c:forEach>
							    </div>
							</li>

							<!-- 웹소켓 알림끝 -->
				            <form action="/logout" method="post">
				            	<button type="submit" id="logoutBtn">로그아웃</button>
					            <sec:csrfInput />
				            </form>
					            <li id="headerUser"><a href="#">${entVO.entNm} <img src="../resources/assets/images/profile-header.jpg" alt=""></a></li>
					            <li><a href="#">기업서비스</a></li>
					    </c:if>
		                </sec:authorize>
                    </ul>                       
                    <a class='menu-trigger'>
                        <span>Menu</span>
                    </a>
                    <!-- ***** Menu End ***** -->
                </nav>
                <hr/>
            </div>
        </div>
    </div>
 </header>
 <script>
function formatDate(timestamp) {
    const date = new Date(timestamp);
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    const hours = String(date.getHours()).padStart(2, '0');
    const minutes = String(date.getMinutes()).padStart(2, '0');
    const seconds = String(date.getSeconds()).padStart(2, '0');

    return year+`.`+month+`.`+day+` `+ hours+`:`+minutes+`:`+seconds;
}
// 클릭할 때 알림 목록을 토글하는 스크립트
$(document).ready(function() {
    // 알림 아이콘 클릭 시 열고 닫기 기능
    $('#notificationIcon').on('click', function(e) {
        e.preventDefault();
        var dropdown = $('#notificationDropdown');

        $.ajax({
            url: '/notification/list',  // 서버에서 알림 목록을 반환하는 API
            method: 'GET',
            dataType: 'json',
            beforeSend: function(xhr) {
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
            },
            success: function(response) {
                var dropdown = $('#notificationDropdown');
                dropdown.empty();  // 기존 알림 목록 비우기
                if (response.length > 0) {
                    // 알림이 있을 경우 배지를 보여줌
                    dropdown.append('<div class="alarmTitle">알림</div>');
                    dropdown.append('<div class="alarm-actions" style="display: flex; justify-content: space-between;">' + 
                            '<a href="#" class="dropdown-item dropdown-footer" id="alramAllDel">전체삭제</a>' +
                            '<a href="/member/memAlram?mbrId=" class="dropdown-item dropdown-footer" id="alramList" style="text-align:right;">알림목록</a>' +
                            '</div>');
                    var notificationCount = response.length;
                    $('#notificationBadge').show().text(notificationCount);
                    $.each(response, function(index, alram) {
                        dropdown.append(
                            	'<div class="alarmDate"><span class="dat"></span> '+formatDate(alram.ntcnYmd) +'</div>'+
                                '<div class="boxbox"><div><a data-ntcn-no="'+alram.ntcnNo+'" href="'+alram.ntcnUrl+'" class="dropdown-item dropdown-footer notify-link">' + 
                                alram.ntcnCn + 
                                '<input type="hidden" id="ntcnNo" name="ntcnNo" value="' + alram.ntcnNo + '" />' +
                                '</div><div><button data-ntcn-no="'+alram.ntcnNo+'" id="alramDel">x</button></div>' + 
                                '</a></div>'
                        );
                    });
                } else {
                    // 알림이 없을 경우 배지를 숨김
                    $('#notificationBadge').hide().text(0);
                    dropdown.append('<a href="#" class="dropdown-item dropdown-footer">알림이 없습니다.</a>');
                }
                // 알림 목록을 열고 닫기 토글
                dropdown.toggleClass('show');
            },
            error: function() {
                console.error('알림 목록을 불러오는 데 실패했습니다.');
            }
        });
    });

    // 드롭다운 외부 클릭 시 닫기 기능
    $(document).on('click', function(e) {
        var dropdown = $('#notificationDropdown');

        if (!$(e.target).closest('#notificationIcon').length && !$(e.target).closest('#notificationDropdown').length) {
            dropdown.removeClass('show');
        }
    });
    $(document).on('click', '.notify-link', function(e) {
        e.preventDefault(); // 기본 동작 막기 (바로 이동되지 않도록)

        // 알림의 ntcnNo 값 가져오기
        var ntcnNo = $(this).data('ntcnNo');
        var targetUrl = $(this).attr('href');
        // AJAX 요청으로 알림 삭제하기
        $.ajax({
            url: '/notification/alramDel',  // 알림 삭제 처리하는 API 엔드포인트
            method: 'POST',
            data: {
                ntcnNo: ntcnNo  // 삭제할 알림 번호 전달
            },
            beforeSend: function(xhr) {
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");  // CSRF 토큰 설정
            },
            success: function(response) {
                if (response === 'success') {
                    $(e.target).closest('a').remove();
                    // 알림 삭제 후 해당 URL로 이동
                    window.location.href = targetUrl;
                } else {
                    alert('알림 삭제 중 오류가 발생했습니다.');
                }
            },
            error: function() {
                alert('알림 삭제 중 오류가 발생했습니다.');
            }
        });
    });
    $(document).on('click', '#alramDel', function(e) {
    	e.stopPropagation();
        e.preventDefault();
        
        // 클릭된 버튼의 해당 알림 번호 가져오기
//         var ntcnNo = $(this).siblings('input#ntcnNo').val();
		var ntcnNo = $(this).data("ntcnNo");
        $.ajax({
            url: '/notification/alramDel',  // 알림 삭제 처리하는 API 엔드포인트
            method: 'POST',
            data: {
                ntcnNo: ntcnNo  // 삭제할 알림 번호 전달
            },
            beforeSend: function(xhr) {
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");  // CSRF 토큰 설정
            },
            success: function(response) {
                if (response === 'success') {
                    // 성공적으로 삭제한 후 해당 알림 항목 제거
                    $(e.target).closest('a').remove();

                    // 남은 알림 목록을 다시 불러와서 갯수 확인
                    $.ajax({
                        url: '/notification/list',  // 서버에서 알림 목록을 반환하는 API
                        method: 'GET',
                        dataType: 'json',
                        success: function(response) {
                            var dropdown = $('#notificationDropdown');
                            dropdown.empty();  // 기존 알림 목록 비우기
                            
                            if (response.length > 0) {
                            	 // 전체 삭제 버튼 추가
                                dropdown.append('<div class="alarmTitle">알림</div>');
                                dropdown.append('<div class="alarm-actions" style="display: flex; justify-content: space-between;">' + 
                                        '<a href="#" class="dropdown-item dropdown-footer" id="alramAllDel">전체삭제</a>' +
                                        '<a href="/member/memAlram?mbrId=" class="dropdown-item dropdown-footer" id="alramList" style="text-align:right;">알림목록</a>' +
                                        '</div>');
                                // 알림이 있으면 알림 목록을 추가하고 배지 표시
                                var notificationCount = response.length;
                                $('#notificationBadge').show().text(notificationCount);
                                $.each(response, function(index, alram) {
                                    dropdown.append(
                                        	'<div class="alarmDate"><span class="dat"></span> '+formatDate(alram.ntcnYmd) +'</div>'+
                                        '<div class="boxbox"><div><a data-ntcn-no="'+alram.ntcnNo+'" href="'+alram.ntcnUrl+'" class="dropdown-item dropdown-footer notify-link">' + 
                                        alram.ntcnCn + 
                                        '<input type="hidden" id="ntcnNo" name="ntcnNo" value="' + alram.ntcnNo + '" />' +
                                        '</div><div><button data-ntcn-no="'+alram.ntcnNo+'" id="alramDel">x</button></div>' + 
                                        '</a></div>'
                                    );
                                });
                            } else {
                                // 알림이 없으면 배지를 숨기고 "알림이 없습니다" 메시지 추가
                                $('#notificationBadge').hide().text(0);
                                dropdown.append('<a href="#" class="dropdown-item dropdown-footer">알림이 없습니다.</a>');
                            }
                        },
                        error: function() {
                            console.error('알림 목록 갱신 중 오류가 발생했습니다.');
                        }
                    });
                } else {
                    alert('알림 삭제 중 오류가 발생했습니다.');
                }
            },
            error: function() {
                alert('알림 삭제 중 오류가 발생했습니다.');
            }
        });
    });

    $(document).on('click', '#alramAllDel', function(e) {
        e.preventDefault(); // 기본 동작 막기

        $.ajax({
            url: '/notification/alramAllDel',
            type: 'POST',
            beforeSend: function(xhr) {
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");  // CSRF 토큰 설정
            },
            success: function(response) {
                if (response === "success") {
                    $('#notificationDropdown').empty().append(
                            '<a href="#" class="dropdown-item dropdown-footer">알림이 없습니다.</a>'
                        );
                    $('#notificationBadge').hide().text(0); // 배지 숨기기
                } else if (response === "fail") {
                    alert("알림 삭제에 실패했습니다.");
                } else {
                    alert("오류가 발생했습니다.");
                }
            },
            error: function(xhr, status, error) {
                alert("서버와 통신 중 오류가 발생했습니다. " + error);
            }
        });
    });


});
</script>
<style>
#alramAllDel,#alramList {
    color: #2f2f2f;
    text-decoration: none; 
    padding: 5px;
    display: inline-block;
    background-color: transparent;
}

#alramAllDel:hover, #alramList:hover {
    color: #24D59E;
    background-color: transparent; 
    text-decoration: none; 
}

#alramAllDel:active, #alramList:active {
    color: #24D59E; 
    background-color: transparent; 
    text-decoration: none; 
}
.boxbox{
	display: flex;
	flex-direction: row;
	justify-content: space-between;
	background-color: #00bc8c0a;
	border-radius: 8px;
	margin-bottom: 15px;

}
.notify-link:hover{
	border-radius: 8px;
}
.notify-link{
	display: flex;
	flex-direction: row;
	justify-content: space-between;
	border-radius: 8px;
}
.dat{
	display: inline-block;
    top: 7px;
    left: 0;
    width: 7px;
    height: 7px;
    border: 2px solid #96a0b5;
    border-radius: 50%;
    box-sizing: border-box;
    content: "";
}
.alarmDate{
	font-size: 12px;
	font-weight: 500;
	color: #96a0b5;
}
/*  알림 내용 */
.alarmCon{
	display: flex;
	flex-direction: column;
	margin-bottom: 15px;
}
#alramAllDel:hover{
	background-color: #fff;
}
/* 알림 제목 텍스트 */
.alarmTitle{
	font-size: 24px;
	font-weight: 600;
	margin-bottom: 20px;
}
/* 알림 창 */
.dropdown-menu-right{
	overflow: hidden;
    position: absolute;
    top: 49px;
    right: -319px;
    padding: 23px 26px 23px 26px;
    max-width: 400px;
    width: 376px;
    height: 720px;
    border: 1px solid #d7dce5;
    border-radius: 16px;
    box-sizing: border-box;
    background-color: #fff;
    box-shadow: 2px 6px 16px 0 rgba(17, 42, 128, 0.08);
    text-align: left;
    overflow: overlay;
}
 .dropdown-menu-right::-webkit-scrollbar {
    width: 10px;
  }
  .dropdown-menu-right::-webkit-scrollbar-thumb {
    background-color: #24D59E;
    border-radius: 10px;
    background-clip: padding-box;
    border: 2px solid transparent;
  }
  .dropdown-menu-right::-webkit-scrollbar-track {
    background-color: #b6ffe9;
    border-radius: 10px;
    box-shadow: inset 0px 0px 5px white;
  }


/*알림 버튼 링크 분리*/
.notification-item {
    display: flex;                  /* flexbox로 일렬 정렬 */
    align-items: center;            /* 세로 중앙 정렬 */
    justify-content: space-between; /* 양쪽 끝으로 정렬 */
    padding: 5px 10px;
    border-bottom: 1px solid #eee;  /* 항목 간의 구분선 */
}

.notification-item a {
    flex: 1;                        /* 링크가 가능한 넓이만큼 차지하도록 */
    text-decoration: none;          /* 링크 밑줄 제거 */
    color: #333;                    /* 링크 색상 */
    padding-right: 10px;            /* 링크와 삭제 버튼 사이에 여백 추가 */
}

.notification-item button {
    background: none;               /* 배경 없애기 */
    border: none;                   /* 테두리 없애기 */
    color: red;                     /* 버튼 색상 (원하는 색상으로 변경 가능) */
    cursor: pointer;                /* 클릭 가능한 마우스 포인터 */
    font-size: 16px;                /* 버튼 크기 설정 */
    padding: 0;
}

/* 알림 박스 스타일 */
.socket-alert {
    position: fixed;
    top: 20px;
    right: 20px;
    z-index: 9999;
    background-color: #24D59E; /* 알림 배경색 (초록색) */
    color: #fff; /* 텍스트 색상 */
    padding: 15px 20px;
    border-radius: 8px;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1); /* 그림자 효과 */
    font-size: 16px;
    font-family: 'Pretendard', sans-serif;
    opacity: 0;
    transition: opacity 0.3s ease, transform 0.3s ease;
    transform: translateY(-20px);
}

/* 알림 박스 표시할 때 */
.socket-alert.visible {
    opacity: 1;
    transform: translateY(0);
}

/* 알림 박스 숨길 때 */
.socket-alert.hidden {
    opacity: 0;
    transform: translateY(-20px);
    transition: opacity 0.3s ease, transform 0.3s ease;
}
/*알림여기까지*/
.logo img{
	height : 70px;
}

.iconSize img{
	width:30px;
	height:30px;
}
#enterMenuParent{
	width: 800px;
}
#enterMenu{/*기업 헤더 메뉴*/
	display: flex;
	justify-content: space-around;
	margin-top: 30px;
	width: 600px;
	
}
.menuDetail{
	width: 150px;
}
</style>



