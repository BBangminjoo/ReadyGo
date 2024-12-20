<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec"	uri="http://www.springframework.org/security/tags"%>
<script>
document.addEventListener('DOMContentLoaded', function () {
    var navMainLinks = document.querySelectorAll('.nav-item.nav_main .nav-link');
    var navSubLinks = document.querySelectorAll('.nav-item.nav_sub .nav-link');
    var currentUrl = window.location.pathname; // 현재 페이지 URL 가져오기

    // 상위 메뉴 (nav_main) 항목 클릭 시 active 처리
    navMainLinks.forEach(function (link) {
        // 상위 메뉴 클릭 시 처리
        link.addEventListener('click', function () {
            // 모든 상위 메뉴와 하위 메뉴의 active 클래스 제거
            navMainLinks.forEach(function (item) {
                item.parentNode.classList.remove('active');
            });
            navSubLinks.forEach(function (item) {
                item.parentNode.classList.remove('active');
            });

            // 클릭된 상위 메뉴에 active 클래스 추가
            this.parentNode.classList.add('active');
        });

        // 현재 페이지가 상위 메뉴에 해당하는 경우 active 처리
        if (link.getAttribute('href') === currentUrl) {
            link.parentNode.classList.add('active');
        }
    });

    // 하위 메뉴 (nav_sub) 항목 클릭 시 active 처리 및 상위 메뉴 열기
    navSubLinks.forEach(function (link) {
        if (link.getAttribute('href') === currentUrl) {
            link.parentNode.classList.add('active'); // 하위 메뉴 활성화
            var parentMenu = link.closest('.nav-item'); // 상위 메뉴 찾기
            if (parentMenu) {
                parentMenu.classList.add('menu-open'); // 상위 메뉴 열기
                parentMenu.querySelector('.nav-link').classList.add('active'); // 상위 메뉴 활성화
            }
        }

        // 하위 메뉴 클릭 시 처리
        link.addEventListener('click', function () {
            // 모든 상위 메뉴와 하위 메뉴의 active 클래스 제거
            navMainLinks.forEach(function (item) {
                item.parentNode.classList.remove('active');
            });
            navSubLinks.forEach(function (item) {
                item.parentNode.classList.remove('active');
            });

            // 클릭된 하위 메뉴에 active 클래스 추가
            this.parentNode.classList.add('active');

            // 클릭된 하위 메뉴의 상위 메뉴를 열고, 상위 메뉴에도 active 클래스 추가
            var parentMenu = this.closest('.nav-item');
            if (parentMenu) {
                parentMenu.classList.add('menu-open'); // 상위 메뉴 열기
                parentMenu.querySelector('.nav-link').classList.add('active'); // 상위 메뉴 활성화
            }
        });
    });
});

</script>

<style>
/* 클릭된 nav_main 항목의 스타일 */
.nav-sidebar .nav-item.nav_main.active .nav-link {
    color: #FD5D6C !important; /* 클릭된 nav_main 항목의 글자색 */
    background-color: rgba(253, 93, 108, 0.15) !important; /* 클릭된 nav_main 항목의 배경색 */
}

/* 클릭된 nav_sub 항목의 스타일 */
.nav-sidebar .nav-item.nav_sub.active .nav-link {
    color: #FD5D6C !important; /* 클릭된 nav_sub 항목의 글자색 */
    background-color: rgba(253, 93, 108, 0.15) !important; /* 클릭된 nav_sub 항목의 배경색 */
}

/* nav_main 항목이 열렸을 때 하위 메뉴 보이게 하기 */
.nav-item.menu-open > .nav-treeview {
    display: block;
}

.nav-item {
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
    color: #FD5D6C !important; /* hover 상태 색상 */
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

.nav_sub {
    text-align: center;
}

</style>

<aside class="main-sidebar sidebar-dark-primary elevation-4">

	<!-- Sidebar -->
	<div class="sidebar">
		<!-- Sidebar user panel (optional) -->
		<div class=" mt-3 pb-3 ">
		</div>
			<div class="image">
				<a href="/adm/main"><img src="/resources/icon/ReadyGo-로고(핑크).png"
					alt="Logo"></a>
			</div>

		<!-- Sidebar Menu -->
		<nav class="mt-2">
			<ul class="nav nav-pills nav-sidebar flex-column"
				data-widget="treeview" role="menu" data-accordion="false">
				<!-- Add icons to the links using the .nav-icon class
               with font-awesome or any other icon font library -->
				<li class="nav-item menu-open"><a href="#" class="nav-link"> 
					<img src="/resources/icon/회원관리.png" alt="icon">
						<p class="nav_main">
							회원 관리 <i class="fas fa-angle-left right"></i>
						</p>
				</a>
					<ul class="nav nav-treeview">
						<li class="nav-item nav_sub">
							<a href="/adm/memManage"class="nav-link">
								<p>일반회원 이용제한</p>
							</a>
						</li>
					</ul>
				</li>
				<li class="nav-item nav_main"><a href="/adm/entApproval" class="nav-link"> 
					<img src="/resources/icon/기업승인관리.png" alt="icon">
						<p>
							기업 승인 관리
						</p>
					</a>
				</li>			
				<li class="nav-item nav_main"><a href="/adm/codeManage" class="nav-link"> 
					<img src="/resources/icon/공통코드관리.png" alt="icon">
						<p>
							공통 코드 관리
						</p>
					</a>
				</li>				
				<li class="nav-item menu-open"><a href="#" class="nav-link"> 
					<img src="/resources/icon/커뮤니티 관리.png" alt="icon">
						<p class="nav_main">
							커뮤니티 관리 <i class="fas fa-angle-left right"></i>
						</p>
				</a>
					<ul class="nav nav-treeview">
						<li class="nav-item nav_sub">
							<a href="/adm/notice/admNoticeList"class="nav-link">
								<p>공지 게시판</p>
							</a>
						</li>
						<li class="nav-item nav_sub">
							<a href="/adm/freeBoard/admFreeList"class="nav-link">
								<p>자유 게시판</p>
							</a>
						</li>
						<li class="nav-item nav_sub">
							<a href="/adm/inquiryBoard/admInquiryList"class="nav-link">
								<p>문의 게시판</p>
							</a>
						</li>
						<li class="nav-item nav_sub">
							<a href="/adm/faqBoard/admFaqList"class="nav-link">
								<p>FAQ 게시판</p>
							</a>
						</li>
						<li class="nav-item nav_sub">
							<a href="/adm/review/reviewList"class="nav-link">
								<p>외주 리뷰 게시판</p>
							</a>
						</li>
						<li class="nav-item nav_sub">
							<a href="/adm/reportBoard"class="nav-link">
								<p>신고 게시판</p>
							</a>
						</li>		
					</ul>
				</li>
			</ul>
		</nav>
		<!-- /.sidebar-menu -->
	</div>
	<div class="nav-item" style="position: absolute; right: 0px; bottom: 0px; display: flex; justify-content: space-between;">
		<form action="/logout" method="post">
			<button type="submit" style="background-color: white; color: #828282; border: none; margin: 25px;">로그아웃</button>
			<sec:csrfInput />
		</form>
	</div>
	<!-- /.sidebar -->
</aside>