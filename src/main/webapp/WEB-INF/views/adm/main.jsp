<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<script type="text/javascript" src="/resources/ckeditor5/ckeditor.js"></script>
<script type="text/javascript" src="/resources/js/sweetalert2.js"></script>
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

.container {
    width: 80%;
    margin: 0 auto;
    margin-left: 400px;
    padding-right: 300px;
}

table {
    width: 100%;
    border-collapse: collapse;
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

.codeAddForm input[type="text"] {
    width: 150px; /* 입력창과 버튼을 맞추기 위해 계산 */
    padding: 10px;
    border: 1px solid #ccc;
    border-radius: 4px;
}

.search-button {
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
    padding: 10px 20px;
    border: 1px solid #FD5D6C;
    border-radius: 4px;
    cursor: pointer;
    background-color: #FD5D6C;
    color: white;
    transition: background-color 0.3s, color 0.3s; 
}

.filter-button:hover {
    background-color: white;
    color: #FD5D6C;
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
	background-color: rgba(253, 93, 108, 0.7) !important;
	color: white;
}

table thead th, table tbody td {
    padding: 10px;
    font-size: 14px;
    border-bottom: 1px solid #ddd;
}
table tbody tr:hover {
    background-color: rgba(253, 93, 108, 0.1);
    transition: background-color 0.3s ease;
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
    margin-top: 20px;
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
	width: 765px;
    padding: 10px;
    border: 1px solid #ccc;
    border-radius: 4px;
    margin-bottom: 10px;
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

/* 여기서부터 새로작성한거 */
.flex-container1, .flex-container2 {
    display: flex;
    justify-content: space-between;
    gap: 20px; 
    height: 370px;
    margin-top: 20px;
}

.table1, .table2, .table3, .table4 {
    width: 48%; 
    margin-top: 20px;
}
header{
	margin-bottom: 25px;
}
.table-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: -15px !important;
}

.add-btn {
    font-size: 24px;
    cursor: pointer;
    color: black;
    margin-right: 10px;
}

#fast {
    height: 80px;
    border: 1px solid #B6B6B6;
    border-radius: 20px;
    display: flex;
    justify-content: space-evenly;
    align-items: center;
    margin: 0 auto;
    width:1100px;
}
#inquiry-wait, #sing-wait, #report-mem, #report-board {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
}
.v-line {
    border-left: 1px solid #B6B6B6;
    height: 70px; 
}
.num{
	font-size: 30px;
	margin-bottom: 0px;
}
.fmtitle{
	margin-bottom: 0px;
} 

/* 공통 스크롤 스타일 */
.scrollable-table {
    width: 100%; 
    max-height: 300px; 
    overflow-y: hidden;
}
.table-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 10px;
}

.add-btn {
    font-size: 24px;
    cursor: pointer;
    color: black;
    margin-right: 10px;
   	transition: all 0.3s ease 0s;
}

.add-btn:hover{
	color : #FD5D6C;
}

.scroll-content {
    overflow-y: scroll; 
    max-height: 300px; 
    -ms-overflow-style: none; /* IE 10+ */
    scrollbar-width: none; /* Firefox */
}

.scroll-content::-webkit-scrollbar {
    display: none; /* Chrome, Safari, Opera */
}

.board_a_default{
	color : black;
   	transition: all 0.3s ease 0s;
}
.board_a_default:hover{
	color : #FD5D6C;
	text-decoration: underline;
}
</style>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div class="container">
    <header>
        <h1>관리자님 어서오세요!</h1>
    </header>
	<!-- 요약보기 -->
	<div id="fast">
		<div id="inquiry-wait">
			<p class="fmtitle">문의 답변 대기</p>
			<p class="num"><a class="add-btn" href="/adm/inquiryBoard/admInquiryList">${inquiryTotal}</a></p>
		</div>
		<div class='v-line'></div>
		<div id="sing-wait">
			<p class="fmtitle">기업 승인 대기</p>
			<p class="num"><a class="add-btn" href="/adm/entApproval">${entSignTotal}</a></p>
		</div>
		<div class='v-line'></div>
		<div id="report-mem">
			<p class="fmtitle">신고된 회원 수</p>
			<p class="num"><a class="add-btn" href="/adm/memManage">${reportMemTotal}</a></p>
		</div>
		<div class='v-line'></div>
		<div id="report-board">
			<p class="fmtitle">신고된 게시글</p>
			<p class="num"><a class="add-btn" href="/adm/reportBoard">${reportBoardTotal}</a></p>
		</div>
	</div>    

	<!-- 컨테이너1 -->
    <div class="flex-container1">
        <!-- 공지 게시판 -->
        <div class="table1">
		    <div class="table-header">
		        <h5>공지 게시판</h5>
		        <h5><a class="add-btn" href="/adm/notice/admNoticeList">+</a></h5>
		    </div>
		    <table style="width: 100%; margin-top:20px;">
                  <thead>
                      <tr>
                          <th style="text-align: center; position: sticky; top: 0; font-size:18px; width:20%;">번호</th>
                          <th style="text-align: left; position: sticky; top: 0; font-size:18px; width:60%;">제목</th>
                          <th style="text-align: center; position: sticky; top: 0; font-size:18px; width:20%;">작성일</th>
                      </tr>
                  </thead>
            </table>
            <div class="scrollable-table">
                <div class="scroll-content">
                    <table style="width: 100%;">
                        <tbody>
                            <c:forEach var="noticeVO" items="${noticeVOList}">
                                <tr>
                                    <td style="text-align: center;width:20%;">${noticeVO.rnum}</td>
                                    <td style="text-align: left;width:60%;"><a class="board_a_default" href="/adm/notice/admNoticeDetail?seNo=3&pstSn=${noticeVO.pstSn}">${noticeVO.pstTtl}</a></td>
                                    <td style="text-align: center;width:20%;">${noticeVO.pstWrtDt}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- 문의 답변 -->
        <div class="table2">
		    <div class="table-header">
		        <h5>문의 답변</h5>
		        <h5><a class="add-btn" href="/adm/inquiryBoard/admInquiryList">+</a></h5>
		    </div>
            <table style="width: 100%; margin-top:20px;">
                <thead>
                    <tr>
                        <th style="text-align: center; font-size:18px;width:25%;">상태</th>
                        <th style="text-align: left; font-size:18px;width:55%;">제목</th>
                        <th style="text-align: center; font-size:18px;width:20%;">작성일</th>
                    </tr>
                </thead>
            </table>		    
            <div class="scrollable-table">
                <div class="scroll-content">
                    <table style="width: 100%;">
                        <tbody>
                            <c:forEach var="inquiryVO" items="${inquiryVOList}">
                                <tr>
                                    <td style="text-align: center;width:25%;">${inquiryVO.pstOthbcscope}</td>
                                    <td style="text-align: left;width:70%;"><a class="board_a_default" href="/adm/inquiryBoard/admInquiryDetail?seNo=4&pstSn=${inquiryVO.pstSn}">${inquiryVO.pstTtl}</a></td>
                                    <td style="text-align: center;width:20%;">${inquiryVO.pstWrtDt}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

	<!-- 컨테이너2 -->
    <div class="flex-container2">
        <div class="table3">
		    <div class="table-header" style="margin-top:20px;">
		        <h5>기업승인관리</h5>
		        <h5><a class="add-btn" href="/adm/entApproval">+</a></h5>
		    </div>
            <div class="scrollable-table">
                <div class="scroll-content">
                    <table style="width: 100%; margin-top:20px;">
                        <thead>
                            <tr>
                                <th style="text-align: center; font-size:18px;">기업이름</th>
                                <th style="text-align: center; font-size:18px;">대표자</th>
                                <th style="text-align: center; font-size:18px;">연락처</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="enterVO" items="${entVOList}">
                                <tr>
                                    <td style="text-align: center;">${enterVO.entNm}</td>
                                    <td style="text-align: center;"><a class="board_a_default" href="/adm/entApproval">${enterVO.entRprsntvNm}</a></td>
                                    <td style="text-align: center;">${enterVO.entManagerTelno}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- 신고된 게시글 -->
        <div class="table4">
         	<div class="table-header" style="margin-top:20px;">
		        <h5>신고된 게시글</h5>
		        <h5><a href="/adm/reportBoard" class="add-btn">+</a></h5>
		    </div>
            <div class="scrollable-table">
                <div class="scroll-content">
                    <table style="width: 100%;margin-top:20px;">
                        <thead>
                            <tr>
                                <th style="text-align: center; font-size:18px;">분류</th>
                                <th style="text-align: left; font-size:18px;">신고내용</th>
                                <th style="text-align: center; font-size:18px;">날짜</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="declarationVO" items="${declarationVOList}">
                                <tr>
                                    <td style="text-align: center;">${declarationVO.dclrField}</td>
                                    <td style="text-align: left;"><a class="board_a_default"href="/adm/reportBoard">${declarationVO.dclrCn}</a></td>
                                    <td style="text-align: center;">${declarationVO.dclrDt}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>



<script type="text/javascript">

$(document).ready(function() {
	
	
});
</script>

