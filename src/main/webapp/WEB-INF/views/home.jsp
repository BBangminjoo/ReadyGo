<%@page import="java.net.URLDecoder"%>
<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false"%>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/alert.css" />
<c:if test="${not empty alertMessage}">
    <script type="text/javascript">
        console.log("Alert message: ${alertMessage}");
        
        // SweetAlert로 경고창 띄우기
        Swal.fire({
            icon: 'warning',  // 아이콘 모양 (warning, success, error 등 선택 가능)
            title: '경고',
            html: "${alertMessage}",  // 서버에서 전달한 경고 메시지
            confirmButtonText: '확인',  // 확인 버튼 텍스트
        });
    </script>
</c:if>
<script>
$(function() {
const $slides = $('.slides'); // 전체 슬라이드 컨테이너
const $slideImg = $('.slides li'); // 모든 슬라이드들
let currentIdx = 0; // 현재 슬라이드 index
const slideCount = $slideImg.length/2; // 슬라이드 개수
const $prev = $('.prev'); // 이전 버튼
const $next = $('.next'); // 다음 버튼
const slideWidth = 1060; // 한개의 슬라이드 넓이
const slideMargin = 40; // 슬라이드간의 margin 값

// 전체 슬라이드 컨테이너 넓이 설정
$slides.css('width', (slideWidth + slideMargin) * slideCount + 'px');

function moveSlide(num) {
  $slides.css('left', -num * (slideWidth + slideMargin) + 'px');
  currentIdx = num;
}

$prev.on('click', function () {
  if (currentIdx !== 0) moveSlide(currentIdx - 1);
});

$next.on('click', function () {
  if (currentIdx !== slideCount - 1) {
    moveSlide(currentIdx + 1);
  }
});

// 스크롤 이벤트를 감지하여 일정 높이 이상 스크롤되면 버튼 표시
$(window).scroll(function() {
    if ($(this).scrollTop() > 200) { // 200px 이상 스크롤 시 버튼 보이기
        $('#topBtn').fadeIn();
    } else {
        $('#topBtn').fadeOut();
    }
});

// Top 버튼 클릭 시 페이지 상단으로 부드럽게 이동
$('#topBtn').click(function() {
    $('html, body').animate({ scrollTop: 0 }, 'slow'); // 페이지 상단으로 이동
    return false;
});

$(".overlayBtn1").on("click", function() {
    // a 태그의 href 속성 값을 가져옴
    var pbancNo = $(this).val();
    
    // 새 창에서 해당 링크로 이동
    window.open("/enter/pbancDetail?pbancNo=" + pbancNo, '_blank');
});

$(".overlayBtn2").on("click", function() {
    // a 태그의 href 속성 값을 가져옴
    var entId = $(this).val();
    
    // 새 창에서 해당 링크로 이동
    window.open("/enter/profile?entId=" + entId, '_blank');
});

});
</script>
<button id="topBtn" class="top-btn" style="display:none; position:fixed; bottom:80px; right:280px;">TOP ▲</button>
<div class="mainRow">
	<!-- /// 메인 시작 /// -->
	<div class="col-md-12" style="width: 100%;">
		<div id="main">
			<div id="mainSlide" class="carousel slide carousel-fade" data-bs-ride="carousel">
				<div class="carousel-indicators">
					<button type="button" data-bs-target="#mainSlide"
						data-bs-slide-to="0" class="active" aria-current="true"
						aria-label="Slide 1"></button>
					<button type="button" data-bs-target="#mainSlide"
						data-bs-slide-to="1" aria-label="Slide 2"></button>
					<button type="button" data-bs-target="#mainSlide"
						data-bs-slide-to="2" aria-label="Slide 3"></button>
					<button type="button" data-bs-target="#mainSlide"
						data-bs-slide-to="3" aria-label="Slide 4"></button>
					<button type="button" data-bs-target="#mainSlide"
						data-bs-slide-to="4" aria-label="Slide 5"></button>
				</div>
				<div class="carousel-inner">
					<div class="carousel-item active">
						<div id="flexDiv">
						<img src="../../resources/images/main/mainSlide1.png" class="d-block w100"
							alt="...">
						<h1 class="line" style="top: 90px; left:400px;">주식회사 셀로닉스</h1>
						<h1 class="line" style="top: 140px; left:320px;">기술 지원부 SI팀 IT개발 채용</h1>
						<button value="0008" id="pbancDetail1" class="overlayBtn1">←───  공고 상세보기</button>
						<button value="enter17" class="overlayBtn2">기업정보 보기  ───→</button>
						</div>
					</div>
					<div class="carousel-item">
						<div id="flexDiv">
						<img src="../../resources/images/main/mainSlide2.png" class="d-block w100"
							alt="...">
						<h1 class="line" style="top: 90px; left:400px;">(주)인지이솔루션</h1>
						<h1 class="line" style="top: 140px; left:310px;">리튬팩 전문기업 신입사원 모집</h1>
						<button value="0032" class="overlayBtn1">←───  공고 상세보기</button>
						<button value="enter52" class="overlayBtn2">기업정보 보기  ───→</button>
						</div>
					</div>
					<div class="carousel-item">
						<div id="flexDiv">
						<img src="../../resources/images/main/mainSlide3.png" class="d-block w100"
							alt="...">
						<h1 class="line" style="top: 90px; left:425px;">셀바스헬스케어</h1>
						<h1 class="line" style="top: 140px; left:385px;">하드웨어 개발자 채용</h1>
						<button value="0030" class="overlayBtn1">←───  공고 상세보기</button>
						<button value="enter11" class="overlayBtn2">기업정보 보기  ───→</button>
						</div>
					</div>
					<div class="carousel-item">
						<div id="flexDiv">
						<img src="../../resources/images/main/mainSlide4.png" class="d-block w100"
							alt="...">
							<h1 class="line" style="top: 90px; left:400px;">(주)아이비전웍스</h1>
							<h1 class="line" style="top: 140px; left:340px;">백엔드/프론트엔드 개발자</h1>
						<button value="0017" class="overlayBtn1">←───  공고 상세보기</button>
						<button value="enter10" class="overlayBtn2">기업정보 보기  ───→</button>
						</div>
					</div>
					<div class="carousel-item">
						<div id="flexDiv">
						<img src="../../resources/images/main/mainSlide5.jpg" class="d-block w100"
							alt="...">
						<h1 class="line" style="top: 90px; left:480px;">대덕그룹</h1>
						<h1 class="line" "line" style="top: 140px; left:360px;">JAVA 개발자 신입 채용</h1>
						<button value="0002" class="overlayBtn1">←───  공고 상세보기</button>
						<button value="dd1021" class="overlayBtn2">기업정보 보기  ───→</button>
						</div>
					</div>
				</div>
				<button class="carousel-control-prev" type="button"
					data-bs-target="#mainSlide" data-bs-slide="prev">
					<span class="carousel-control-prev-icon" aria-hidden="true"></span>
					<span class="visually-hidden">Previous</span>
				</button>
				<button class="carousel-control-next" type="button"
					data-bs-target="#mainSlide" data-bs-slide="next">
					<span class="carousel-control-next-icon" aria-hidden="true"></span>
					<span class="visually-hidden">Next</span>
				</button>
			</div>

			<!-- 두 번째 슬라이드  -->
			<div id="sildeBtn">
			<h4>ReadyGo 바로가기</h4>
				<p class="controller">
					<span class="prev">&lang;</span> 
					<span class="next">&rang;</span>
				</p>
			</div>
			<div id="slideShow">
				
				<ul class="slides">
					<li><a href="/common/freeBoard/freeList"><img src="../../resources/images/main/boardBanner.png" alt=""></a></li>
					<li><a href="/enter/main"><img src="../../resources/images/main/enterBanner.png" alt=""></a></li>
					<li><a href="#"><img src="../../resources/images/main/codingTestBanner.png" alt=""></a></li>
					<li><a href="/common/jobTools/spellingCheck"><img src="../../resources/images/main/jobToolBanner.png" alt=""></a></li>
					<li><a href="/outsou/main"><img src="../../resources/images/main/outsouBanner.png" alt=""></a></li>
					<li><a href="/member/injae"><img src="../../resources/images/main/injaeBanner.png" alt=""></a></li>
				</ul>
				
			</div>

			<h4>추천 공고</h4>
			<table class="table custom-table">
				<tbody>
					<c:forEach var="pbancVO" items="${pbancVOList}" varStatus="stat">
						<c:if test="${stat.index % 4 == 0}">
							<tr>
						</c:if>
								<td style="width:25%">
	 							<a target="_blank" href="enter/pbancDetail?pbancNo=${pbancVO.pbancNo}">
	 							<img class="pbancImg" src="${pbancVO.pbancImgFile}" /> <!-- 이미지 -->
	 							</a>
	 							<span class="entNm">
	 								${pbancVO.entNm} <!-- 기업명 -->
	 							</span><br>
								<a target="_blank" href="enter/pbancDetail?pbancNo=${pbancVO.pbancNo}"><b>${pbancVO.pbancTtl}</b></a><br> <!-- 제목 -->
								<span class="smallDetail">
	 								${pbancVO.pbancTpbizNm}<br> <!-- 공고업종 -->
	 								<c:if test="${pbancVO.pbancRprsrgnNm != '세종' && pbancVO.pbancRprsrgnNm != '전국'}">
	 								${pbancVO.pbancRprsrgnNm}
	 								</c:if>
	 								${pbancVO.pbancCityNm}&nbsp; ·&nbsp;
	 								${pbancVO.pbancCareerCdNm}</span>
								</td>
						<c:if test="${stat.index % 4 == 3 || stat.last}">
							</tr>
						</c:if>
					</c:forEach>

				</tbody>
			</table>
		</div>
	</div>
</div>


<style>

.mainRow { 
	margin: 20px 20% 0px 20%; 
}
#main{
	width : 1100px;
}

.carousel-item img {  
	
    width: 100%; /* 원하는 고정 너비 1100 */  
    height: 40%; /* 원하는 고정 높이 */  
    object-fit: cover; /* 이미지 비율 유지하며 공간에 맞게 조정 */  
} 
#flexDiv{
	position: relative;
	display: flex;
    flex-direction: column; /* 수직 정렬 */
    justify-content: center; /* 수평 가운데 정렬 */
    align-items: center; /* 수직 가운데 정렬 */
    z-index: 1; /* 뒤쪽 배치 */
}
.overlayBtn1{
	position: absolute; /* 버튼을 절대 위치로 설정 */
    top: 230px; /* 원하는 위치 조정 */
    left: 300px; /* 원하는 위치 조정 */
    background-color: transparent;
    border: 2px solid #fff;
    padding: 12px 40px; /* 여백 설정 */
    cursor: pointer; /* 커서 모양 설정 */
    font-size: 16px; /* 글자 크기 설정 */
    color : white;
    z-index: 100; /* 앞쪽에 위치 */
}
.overlayBtn2{
	position: absolute; /* 버튼을 절대 위치로 설정 */
    top: 230px; /* 원하는 위치 조정 */
    left: 560px; /* 원하는 위치 조정 */
    background-color: transparent;
    border: 2px solid #fff;
    padding: 12px 40px; /* 여백 설정 */
    cursor: pointer; /* 커서 모양 설정 */
    font-size: 16px; /* 글자 크기 설정 */
    color : white;
    z-index: 100; /* 앞쪽에 위치 */
}
.overlayBtn:hover {
    background-color: #fff; /* 호버 시 배경색을 흰색으로 변경 */
    color: #000; /* 호버 시 텍스트 색상을 검은색으로 변경 */
}
.carousel-item .line{
	position: absolute;
    color : white;
    font-weight: 700;
    z-index: 1000; /* 앞쪽에 위치 */
}
h4{
	margin : 30px 0 5px 10px;
}
#sildeBtn{
	position: relative;
	height : 30px;
	margin-bottom : 10px;
}

/* 보여줄 구간의 높이와 넓이 설정 */
#slideShow{
  width: 1100px;
  height: 150px;
  position: relative;
  overflow: hidden;   
  /*리스트 형식으로 이미지를 일렬로 
  정렬할 것이기 때문에, 500px 밖으로 튀어 나간 이미지들은
  hidden으로 숨겨줘야됨*/
}


.slides{
  position: absolute;
  left: 0;
  top: 0;
  width: 3300px; /* 슬라이드할 사진과 마진 총 넓이 */
  transition: left 0.5s ease-out; 
  /*ease-out: 처음에는 느렸다가 점점 빨라짐*/
}

/* 홀수의 슬라이드에만 마진주기 */
.slides li:nth-child(odd) {
  margin-right: 40px;
}

.slides li{
  float: left;
}
 .slides img { 
  border-radius: 15px; /* 위쪽 모서리만 둥글게 */
 } 

.controller span{
  position:absolute;
  float : right;
  background-color: transparent;
  color: black;
  text-align: center;
  border-radius: 50%;
  border : 1px solid #A7A7A7;
  padding: 5px 15px;
   top: -40%; 
  font-size: 1.3em;
  cursor: pointer;
  z-index: 100; /* 앞쪽에 위치 */
}

/* 이전, 다음 화살표에 마우스 커서가 올라가 있을때 */
.controller span:hover{
  background-color: rgba(128, 128, 128, 0.11);
}

.prev{
  left: 995px;
}

.next{
  right: 10px;
}


.custom-table {
    border-collapse: collapse !important;/* 테두리 겹침 방지 */
}
.custom-table td {
	padding : 10px 10px 10px 10px;
    border : none !important; /* 세로선 제거 */
    margin : 10px 0;
}

.pbancImg{
	width: 100%;
	height: 100%;
    aspect-ratio: 2 / 1; /* CSS Aspect Ratio 사용 */
    object-fit: cover; /* 이미지 비율 유지하며 공간에 맞게 조정 */  
    transition: transform 0.3s ease; /* 부드러운 전환 효과 */
    border-radius: 5px;
    border: 1px solid #D9D9D9 !important;
     outline: none; 
    
}
.pbancImg:hover{
	transform: scale(1.1); /* 10% 확대 */
}
.smallDetail {
	font-size: 0.8em;
	color : #A7A7A7;

}
.entNm{
	font-size: 0.9em;
	color : #666363;
}

.top-btn {
	background: white;
   width: 65px;
   height: 40px;
   padding: 4px;   
   font-size: 14px;
   border: 1px solid #666363;
   border-radius: 5px;
}
.top-btn:hover {
   background: #ECECEC;
}

</style>
