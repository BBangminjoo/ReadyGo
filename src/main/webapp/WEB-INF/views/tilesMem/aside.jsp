<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script>
document.addEventListener('DOMContentLoaded', function () {
    var navMainLinks = document.querySelectorAll('.nav-item.nav_main .nav-link');
    var navSubLinks = document.querySelectorAll('.nav-item.nav_sub .nav-link');

    // nav_main 항목에 클릭 이벤트 리스너 추가
    navMainLinks.forEach(function (link) {
        link.addEventListener('click', function () {
            // 모든 nav_main 항목에서 'active' 클래스 제거
            navMainLinks.forEach(function (item) {
                item.parentNode.classList.remove('active');
            });

            // 모든 nav_sub 항목에서 'active' 클래스 제거
            navSubLinks.forEach(function (item) {
                item.parentNode.classList.remove('active');
            });

            // 클릭된 nav_main 항목에 'active' 클래스 추가
            this.parentNode.classList.add('active');
        });
    });

    // nav_sub 항목에 클릭 이벤트 리스너 추가
    navSubLinks.forEach(function (link) {
        link.addEventListener('click', function () {
            // 모든 nav_main 항목에서 'active' 클래스 제거
            navMainLinks.forEach(function (item) {
                item.parentNode.classList.remove('active');
            });

            // 모든 nav_sub 항목에서 'active' 클래스 제거
            navSubLinks.forEach(function (item) {
                item.parentNode.classList.remove('active');
            });

            // 클릭된 nav_sub 항목에 'active' 클래스 추가
            this.parentNode.classList.add('active');
        });
    });
});
</script>

<style>
.nav-item{
    font-family: pretendard;
}
/* 기본 사이드바 스타일 */
.main-sidebar {
    background-color: #ffffff !important;
}

.nav-sidebar .nav-link {
    color: #000000 !important;
}

.nav-treeview {
    background-color: #ffffff !important;
}

.nav-treeview .nav-link {
    color: #000000 !important;
}

.nav-sidebar .nav-link:hover {
    color: #2CCFC3 !important; /* hover 상태 색상 */
}

/* 클릭된 nav_main 항목의 스타일 */
.nav-sidebar .nav-item.nav_main.active .nav-link {
    color: #2CCFC3 !important; /* 클릭된 nav_main 항목의 글자색 */
    background-color: rgba(44, 207, 195, 0.11) !important; /* 클릭된 nav_main 항목의 배경색 */
}

/* 클릭된 nav_sub 항목의 스타일 */
.nav-sidebar .nav-item.nav_sub.active .nav-link {
    color: #2CCFC3 !important; /* 클릭된 nav_sub 항목의 글자색 */
    background-color: rgba(44, 207, 195, 0.11) !important; /* 클릭된 nav_sub 항목의 배경색 */
}

/* 기본 nav_sub 항목의 스타일 */
.nav-sidebar .nav-item.nav_sub .nav-link {
    color: #000000 !important; /* 기본 글자색 */
    background-color: #ffffff !important; /* 기본 배경색 */
}

/* 기본 nav_main 항목의 스타일 */
.nav-sidebar .nav-item.nav_main .nav-link {
    color: #000000 !important; /* 기본 글자색 */
    background-color: #ffffff !important; /* 기본 배경색 */
}

.nav_sub{
	text-align: center;
}
p{
	color: #232323;
	font-weight: 500;
}

</style>

<aside class="main-sidebar sidebar-dark-primary elevation-4">

	<!-- Sidebar -->
	<div class="sidebar">
		<!-- Sidebar user panel (optional) -->
		<div class=" mt-3 pb-3 ">
		</div>
			<div class="image">
				<a href="/">
					<img src="/resources/images/logo.png" alt="Logo" style="width: 170px;height: 70px;">
<!-- 				<img src="/resources/images/찐레디고.gif" style="width: 145px;height: 82px;margin-left: 15px;margin-top: -10px;"> -->
				</a>
			</div>

		<!-- Sidebar Menu -->
		<nav class="mt-2">
			<ul class="nav nav-pills nav-sidebar flex-column" style="margin-top: 32px;"
				data-widget="treeview" role="menu" data-accordion="false">
				<!-- Add icons to the links using the .nav-icon class
               with font-awesome or any other icon font library -->

				<li class="nav-item nav_main">
				<a href="/member/profile?mbrId=${memberVO.mbrId}" class="nav-link"> 
					<img src="/resources/icon/프로필.png" alt="icon" style="width: 34px;height: 34px;">
						<p>
							&nbsp;&nbsp;내 프로필 
						</p>
					</a>
				</li>
				<li class="nav-item nav_list"><a href="#" class="nav-link"> 
					<img src="/resources/icon/캘린더.png" alt="icon" style="width: 31px; height: 29px; position: relative; left: 2px; margin-right: 2px;">
						<p class="nav_main">
							&nbsp;&nbsp;스크랩/일정 캘린더 <i class="fas fa-angle-left right"></i>
						</p>
				</a>
					<ul class="nav nav-treeview">
						<li class="nav-item nav_sub">
							<a href="/member/scrap?mbrId=${memVO.mbrId}" class="nav-link">
								<p>스크랩한 공고</p>
							</a>
						</li>
						<li class="nav-item nav_sub">
							<a href="/member/calendar?mbrId=${memVO.mbrId}"class="nav-link">
								<p>나의 일정</p>
							</a>
						</li>
					</ul>
				</li>
				<li class="nav-item nav_list"><a href="#" class="nav-link"> 
					<img src="/resources/icon/이력서.png" alt="icon" style="width: 31px; height: 29px; position: relative; left: 2px; margin-right: 2px;">
						<p class="nav_main">
							&nbsp;&nbsp;이력서/자소서 <i class="fas fa-angle-left right"></i>
						</p>
				</a>
					<ul class="nav nav-treeview">
						<li class="nav-item nav_sub">
							<a href="/member/resume"class="nav-link">
								<p>이력서 관리</p>
							</a>
						</li>
						<li class="nav-item nav_sub">
							<a href="/member/cover"class="nav-link">
								<p>자소서 관리</p>
							</a>
						</li>
					</ul>
				</li>
				<li class="nav-item"><a href="#" class="nav-link"> 
					<img src="/resources/icon/입사지원아이콘.png" alt="icon" style="width: 31px; height: 29px; position: relative; left: 2px; margin-right: 2px;">
						<p class="nav_main nav_list" id="ep">
							&nbsp;&nbsp;입사지원 <i class="fas fa-angle-left right"></i>
						</p>
				</a>
					<ul class="nav nav-treeview">
						<li class="nav-item nav_sub">
							<a href="/member/aplctList?mbrId=${memberVO.mbrId}"class="nav-link">
								<p>입사 지원 현황</p>
							</a>
						</li>
						<li class="nav-item nav_sub">
							<a href="/member/aplctManage?mbrId=${memberVO.mbrId}"class="nav-link">
								<p>입사 지원 관리</p>
							</a>
						</li>
					</ul>
				</li>
				<li class="nav-item nav_main">
				<a href="/member/memPro?mbrId=${memberVO.mbrId}" class="nav-link"> 
					<img src="/resources/icon/받은제안아이콘.png" alt="icon" style="width: 31px; height: 29px; position: relative; left: 2px; margin-right: 2px;">
						<p>
							&nbsp;&nbsp;받은 제안 
						</p>
					</a>
				</li>
				<li class="nav-item"><a href="#" class="nav-link"> 
					<img src="/resources/icon/면접아이콘.png" alt="icon" style="width: 31px; height: 29px; position: relative; left: 2px; margin-right: 2px;">
						<p class="nav_main nav_list">
							&nbsp;&nbsp;면접 <i class="fas fa-angle-left right"></i>
						</p>
					</a>
					<ul class="nav nav-treeview">
						<li class="nav-item nav_sub">
							<a href="/member/interView?mbrId=${memberVO.mbrId}"class="nav-link">
								<p>면접 현황</p>
							</a>
						</li>
						<li class="nav-item nav_sub">
							<a href="/member/video?mbrId=${memberVO.mbrId}"class="nav-link">
								<p>화상 면접</p>
							</a>
						</li>
					</ul>
				</li>
				<li class="nav-item nav_list"><a href="#" class="nav-link"> 
					<img src="/resources/icon/작성글.png" alt="icon" style="width: 31px; height: 29px; position: relative; left: 2px; margin-right: 2px;">
						<p class="nav_main">
							&nbsp;&nbsp;작성글관리 <i class="fas fa-angle-left right"></i>
						</p>
				</a>
					<ul class="nav nav-treeview">
						<li class="nav-item nav_sub">
							<a href="/member/myFreeBoard?mbrId=${memberVO.mbrId}"class="nav-link">
								<p>자유 게시판</p>
							</a>
						</li>
						<li class="nav-item nav_sub">
							<a href="/member/myInquiryBoard?mbrId=${memberVO.mbrId}"class="nav-link">
								<p>문의 게시판</p>
							</a>
						</li>
					</ul>
				</li>
				<li class="nav-item nav_list"><a href="#" class="nav-link"> 
					<img src="/resources/icon/외주.png" alt="icon" style="width: 29px; height: 29px; position: relative; left: 2px; margin-right: 2px;">
						<p class="nav_main">
							&nbsp;&nbsp;외주 관리 <i class="fas fa-angle-left right"></i>
						</p>
				</a>
					<ul class="nav nav-treeview">
						<li class="nav-item nav_sub">
							<a href="/member/memOutsouList?mbrId=${memberVO.mbrId}"class="nav-link">
								<p>등록한 외주 목록</p>
							</a>
						</li>
						<li class="nav-item nav_sub">
							<a href="/member/setleList?mbrId=${memberVO.mbrId}"class="nav-link">
								<p>결제한 외주 목록</p>
							</a>
						</li>
					</ul>
				</li>
				<li class="nav-item nav_main">
					<a href="/member/memAlram?mbrId=${memberVO.mbrId}"class="nav-link">
					<img src="/resources/icon/알림아이콘.png" alt="icon" style="width: 31px; height: 29px; position: relative; left: 2px; margin-right: 2px;">
						<p>&nbsp;&nbsp;알림</p>
					</a>
				</li>
				<li class="nav-item nav_main">
					<a href="/chat/memChatList"class="nav-link">
					<img src="/resources/icon/채팅.png" alt="icon" style="width: 30px; height: 30px; position: relative; left: 4px; margin-right: 2px;">
						<p>&nbsp;&nbsp;채팅</p>
					</a>
				</li>
				<li class="nav-item nav_main">
					<a href="/member/recentViewList" class="nav-link"> 
					<img src="/resources/icon/최근본.png" alt="icon" style="width: 31px; height: 31px; position: relative; left: 4px; margin-right: 2px; bottom:1px;">
						<p>
							&nbsp;&nbsp;최근 본 공고
						</p>
					</a>
				</li>
				<li class="nav-item nav_main">
					<a href="/member/detail?mbrId=${memberVO.mbrId}" class="nav-link"> 
					<img src="/resources/icon/수정.png" alt="icon" style="width: 36px; height: 36px; position: relative; left: 2px; margin-right: -3px;">
						<p>
							&nbsp;&nbsp;개인정보 수정
						</p>
					</a>
				</li>
			</ul>
		</nav>
		<!-- /.sidebar-menu -->
	</div>
	<!-- /.sidebar -->
</aside>