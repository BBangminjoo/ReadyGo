<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags"
	prefix="sec"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<sec:authorize access="isAuthenticated()">
	<sec:authentication property="principal.memVO" var="memVO" />
</sec:authorize>
<sec:authorize access="isAuthenticated()">
	<sec:authentication property="principal.entVO" var="entVO" />
</sec:authorize>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>

<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/alert.css" /> 
<script src="http://code.jquery.com/jquery-latest.min.js" type="text/javascript"></script>
<script src="https://cdn.iamport.kr/js/iamport.payment-1.1.5.js"></script>
<!-- 외주 css 파일 -->
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/resources/css/outsou/paydetail.css" />

<script type="text/javascript">
$(function(){

	
	let selectedPaymentMethod = null;

	 // 로그인 상태를 확인하는 변수
    let isLoggedIn = <c:out value="${pageContext.request.userPrincipal != null}" />;
	
	
    // 결제 방법 버튼 클릭 시 해당 방법을 선택
    $(".methods .btn").on("click", function() {
	    $(".methods .btn").removeClass("selected"); // 기존 선택 제거
	    $(this).addClass("selected"); // 선택된 방법 강조
	    
	    if ($(this).is("input")) {
	        // input 요소일 경우 val() 사용
	        selectedPaymentMethod = $(this).val();
	    } else if ($(this).is("button")) {
	        // button의 경우, 이미지 alt 속성이나 버튼의 텍스트를 사용
	        selectedPaymentMethod = $(this).find("img").attr("alt") || $(this).text().trim();
	    }
	    
	    console.log("선택된 결제 방법: " + selectedPaymentMethod);
	});
    

    // 결제하기 버튼 클릭 시 처리
    $(".payBtn").on("click", function() {
    	
    	// 로그인하지 않은 경우 안내 메시지 표시 후 로그인 페이지로 이동
        if (!isLoggedIn) {
        	 Swal.fire({
                 title: '로그인 후 이용가능합니다. \n 로그인 하시겠습니까?',
                 icon: 'question',
                 showCancelButton: true,
                 confirmButtonColor: 'white',
                 cancelButtonColor: 'white',
                 confirmButtonText: '예',
                 cancelButtonText: '아니오',
                 reverseButtons: false, // 버튼 순서 거꾸로
             }).then((result) => {
                 if (result.isConfirmed) {
                     window.location.href = "/security/login"; // 로그인 페이지로 리다이렉트
                 }
             });
             return; // 로그인하지 않았을 경우 아래 로직 실행 방지
        }
    	
        if (!selectedPaymentMethod) {
            alert("결제 방법을 선택해주세요.");
            return;
        }

        // 카카오페이 선택 시
        if (selectedPaymentMethod === "카카오 페이") {
            let data = {
                title: "${outsouVO.outordTtl}",  // 상품명
                price: "${outsouVO.outordAmt}", // 결제 금액
                outordNo: "${outsouVO.outordNo}", // 외주 번호
                mbrId: "${memVO.mbrId}", // 로그인한 회원의 아이디
                setleMn: selectedPaymentMethod  // 선택한 결제수단
            };
            
            console.log("data : ", data);

            $.ajax({
                url: "/outsou/pay/ready",  // 카카오페이 결제 준비 API
                contentType: 'application/json',
                data: JSON.stringify(data),
                type: "POST",
                dataType: "json",
                beforeSend: function(xhr) {
                    xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                },
                success: function(result) {
                    console.log("카카오페이 결제 준비 완료: ", result);
                    
                    localStorage.setItem("tid", result.tid);
                    
                    if (result.next_redirect_pc_url) {
                        window.open(result.next_redirect_pc_url, "kakaopay_pop", "width = 500, height = 600, top = 100, left = 750, location = no"); // 카카오페이 결제 페이지로 리디렉션
                    }
                },
                error: function(err) {
                    console.error("카카오페이 결제 준비 실패: ", err);
                    alert("카카오페이 결제 준비 중 오류가 발생했습니다.");
                }
            });
        } else {
            alert(selectedPaymentMethod + " 결제 준비 중입니다.");
        }
    });
    
    
    
    
	
})


</script>


<div>
	<div class="layout">
		<div class="dettit">
			<h2>결제하기</h2>
		</div>

		<div class="detcontent">
			<!-- main -->
			<div class="main">
				<!-- 주문내역 -->
				<div class="info">
					<p class="title1">주문 내역</p>

					<div class="summary">
						<div class="thumbnail">
							<c:forEach var="fileDetailVO"
								items="${outsouVO.fileDetailVOList}">
								<c:if test="${fileDetailVO.gubun=='MAIN'}">
									<img src="${fileDetailVO.filePathNm}"
										alt="${fileDetailVO.filePathNm}" class="border-radius"
										id="pImg" />
								</c:if>
							</c:forEach>
						</div>

						<div class="description">
							<div class="seller">
								<div>
								<img class="seller_img"src="${outsouVO.outordMainFile}"
									alt="${outsouVO.outordMainFile}">
								</div>
								<div>
								<p class="title">${outsouVO.outordTtl}</p>
									<div class="seller1">
										<p class="title"><a href="/member/profile?mbrId=${outsouVO.mbrId}">&nbsp;&nbsp;&nbsp;${outsouVO2.mbrNm}</a></p>
										<p>&nbsp;&nbsp;&nbsp;(<fmt:formatDate value="${outsouVO.outordWrtde}" pattern="yyy.MM.dd"/>)</p>
									</div>
								</div>
							</div>
						</div>
					</div>

					<div class="tableAll">
						<table class="table">
							<thead style=" margin-top: none;" >
								<tr>
									<th class="tit" style="width: 80% ;" >기본항목</th>
									<th class="right" style="width: 20%;">금액</th>
								</tr>
							</thead>
							<tbody >
								<tr>
									<td>${outsouVO.outordTtl}</td>
									<td class="right"><fmt:formatNumber pattern="#,###"
											value="${outsouVO.outordAmt}" />원</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>

				<!-- 결제 방법  -->
				<div class="payment">
					<p class="title1">결제 방법</p>
					<div class="methods">
						<div>
							<input type="button" class="btn" id="AccountTransfer" name="AccountTransfer" style="width: 150px; height: 60px" value="실시간 계좌이체" />
						</div>
						<div>
							<input type="button" class="btn" id="card" name="card" style="width: 150px; height: 60px" value="신용카드" />
						</div>
						<div>
							<input type="button" class="btn" id="Bank" name="Bank" style="width: 150px; height: 60px" value="무통장 입금" />
						</div>
						<div>
							<input type="button" class="btn" id="phone" name="phone" style="width: 150px; height: 60px" value="휴대폰" />
						</div>
						<div>
						    <button type="button" class="btn" id="apibtn" style="width: 150px; height: 60px; padding: 0; border: none; background: none;">
						        <img alt="카카오 페이" src="../resources/icon/카카오페이.png" style="width: 130px; height: 50px;" />
						    </button>
						</div>
					</div>
				</div>


				<div>
					<!-- 세금 계산서 박스 -->
					<div class="billAll">
						<div class="checkbox-wrapper">
							<div class="checkbox">
								<div class="label2">세금계산서 관련 안내 사항</div>
							</div>
						</div>

						<div class="bill">
							<ul class="descriptions">
								<li>주문 금액에 대한 세금계산서는 거래 주체인 전문가가 직접 발행하며, 세금계산서 발행 가능한 사업자
									전문가의 서비스 구매 시에만 신청하실 수 있습니다.</li>
								<li>본 서비스는 사업자 전문가의 서비스이므로 세금계산서 2종을 모두 신청하고 매입세액공제받을 수
									있습니다.</li>
								<li>세금계산서는 구매 확정일(거래 완료일)을 기준으로 발행됩니다.</li>
								<li>실시간 계좌이체, 무통장입금 선택 시 신청한 '현금영수증'은 매입세액공제가 불가합니다.</li>
								<li>신용카드 선택 시 발행된 '카드전표'는 결제에 대한 증빙용으로만 사용하실 수 있으며, 매입세액공제가
									불가합니다.</li>
							</ul>
						</div>
					</div>
				</div>


			</div>

			<!-- summary -->
			<div class="summary-main">
				<div class="summaryAll">
					<div class="price-wrapper">
						<div class="price-wrapper1">
			<c:if test="${outsouVO.outordLclsf == 'OULC01'}">
							<div class="label">
								<p>제공서비스</p>
							</div>

							<ul class="service-details">
							    <c:choose>
							        <c:when test="${outsouVO.osDevalVO.srvcFileprovdyn eq '1'}">
							            <li>소스코드 제공 <span>&#10003;</span></li>
							        </c:when>
							    </c:choose>
							
							    <c:choose>
							        <c:when test="${outsouVO.osDevalVO.srvcSklladit != null}">
							            <li>기능 추가 수량 <span>${outsouVO.osDevalVO.srvcSklladit}</span></li>
							        </c:when>
							    </c:choose>
							
							    <c:choose>
							        <c:when test="${outsouVO.osDevalVO.srvcJobpd != null}">
							            <li>제작 소요일 <span>${outsouVO.osDevalVO.srvcJobpdNm}</span></li>
							        </c:when>
							    </c:choose>
							
							    <c:choose>
							        <c:when test="${outsouVO.osDevalVO.srvcUpdtnmtm != null}">
							            <li>수정 가능 횟수 <span>${outsouVO.osDevalVO.srvcUpdtnmtmNm}</span></li>
							        </c:when>
							    </c:choose>
							</ul>
							<!-- divider -->
							<div class="divider"></div>
				</c:if>
							<div class="total-wrapper">
								<ul class="service-details2">
									<li>결제 금액<span><fmt:formatNumber pattern="#,###"
												value="${outsouVO.outordAmt}" />원</span></li>
								</ul>
							</div>
						</div>
						<div class="agreement-wrapper">
							<div class="agreement-text">위 내용을 확인하였고, 결제에 동의합니다.</div>
						</div>
						<!--  로그인하지 않았으면 로그인 하도록 안내  -->
						<!-- 결제하는 화면으로 이동 -->
						<div class="plainAll">
							<button class="payBtn">결제하기</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>