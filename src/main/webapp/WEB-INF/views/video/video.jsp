<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>  
<script type="text/javascript">

$(function() {

	$("#createBtn").on('click',function() {
			value = $("#createvalue").val();
			val = $('#createurlId').val();
			var obj = {value : value , val:val};
			var jsonObj = JSON.stringify(obj);
			
			console.log(val);
			console.log(value);
			console.log(jsonObj);

			$.ajax({
				url : "/video/createroom",
				type : "POST",
				data : jsonObj,
				contentType : "application/json;charset=UTF-8",
				dataType : "json",
				beforeSend:function(xhr){
					xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
				},
				success : function(res) {
					var list = res.data.list;
					var html = "";
					console.log(list[1]);

					for (var i = 0; i < list.length; i++) {
						html += "<tr>";
						html += "<td>"+(list.length - i)+ "</td>";
						html += "<td id='roomId' style='display:none'>"+ list[i].roomId+ "</td>";
						html += "<td>"+ list[i].roomTitle+"</td>";
						html += "<td>"+ list[i].endDate+"</td>";
						html += "<td><button id='delBtn' class='btn btn-warning'>삭제하기</button></td>";
						html += "<td><span class='btn btn-primary' id='modalBtn' data-toggle='modal' data-target='#exampleModalCenter"+list[i].roomId+"'><button type='button' class='btn_con'>참여</button></span></td>"
						html += "</tr>";
					}
					$('#myRoomList').html('');
					$('#myRoomList').html(html);
					$('#createValue').val('');
					alert("방 생성이 완료되었습니다.");
						}
			})
	})
	
	$(document).on('click', '#delBtn', function() {
			value = $(this).closest('tr').find('#roomId').text();
			var obj = {value : value};
			var jsonObj = JSON.stringify(obj);
			
			console.log(value);
			console.log(jsonObj);

			$.ajax({
				url : "/video/deleteroom",
				type : "POST",
				data : jsonObj,
				contentType : "application/json;charset=UTF-8",
				dataType : "json",
				beforeSend:function(xhr){
					xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
				},
				success : function(res) {
					var list = res.data.list;
					var html = "";
					console.log(list[1]);

					for (var i = 0; i < list.length; i++) {
						html += "<tr>";
						html += "<td>"+(list.length - i)+ "</td>";
						html += "<td id='roomId' style='display:none'>"+ list[i].roomId+ "</td>";
						html += "<td>"+ list[i].roomTitle+"</td>";
						html += "<td>"+ list[i].endDate+"</td>";
						html += "<td><button id='delBtn' class='btn btn-warning'>삭제하기</button></td>";
						html += "<td><span class='btn btn-primary' id='modalBtn' data-toggle='modal' data-target='#exampleModalCenter"+list[i].roomId+"'><button type='button' class='btn_con'>참여</button></span></td>";
						html += "</tr>";
					}
					alert("방 삭제 완료되었습니다.");
					$('#myRoomList').html('');
					$('#myRoomList').html(html);
					$('#createValue').val('');
					location.reload();
						}
			})
	})
	
	$(document).on('click', '#conBtn', function() {
			value = $(this).closest('tr').find('#roomId').text();
			var obj = {value : value};
			var jsonObj = JSON.stringify(obj);
			
			console.log(value);
			console.log(jsonObj);

			$.ajax({
				url : "/video/connectroom",
				type : "POST",
				data : jsonObj,
				contentType : "application/json;charset=UTF-8",
				dataType : "json",
				beforeSend:function(xhr){
					xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
				},
				success : function(res) {
					console.log(res)
					window.open(res.data.url);
				}
			})
	})
	
	
	
})
</script>
</head>
<body>
	<div class="row">
		<div class="col">
			<input type="text" class="form form-control" id="createvalue"/>
		</div>
		<div class="col">
			<input type="text" class="form form-control" id="createurlId">
		</div>
		<div class="col">
			<input type="button" id="createBtn" class="btn btn-primary" value="생성"/>
		</div>
		
	</div>
	<div class="col-xl-12 col-lg-12 col-sm-12 layout-spacing" style="margin-top:3%">
		<div class="widget-content widget-content-area br-6">
			<h3 class="table-header" algin="center">ROOM</h3>
			<br>
			<div class="table-responsive mb-4">
				<table id="roomTable" class="table table-hover" style="width:100%">
					<thead>
						<tr>
							<th>방 번호</th>
							<th>방 이름</th>
							<th>방 종료일시</th>
							<th></th>
						</tr>
					</thead>
					<c:set var="roomListlength" value="${fn:length(roomList.data.list)}"/>
					<c:set value="${roomListLength}" var="num"/>
					<tbody id="myRoomList">
						<c:forEach var="roomList" items="${roomList.data.list}">
							<tr>
								<c:set value="${num-1}" var="num"/>
								<td><c:out value="${num+1}"/></td>
								<td id="roomId" style="display: none">${roomList.roomId}</td>
								<td>${roomList.roomTitle}</td>
								<td>${roomList.endDate}</td>
								<td><button id="delBtn" class="btn btn-warning">삭제하기</button>
								</td>
								<td><span class="btn btn-primary" id="modalBtn" data-toggle="modal" data-target="#exampleModalCenter${roomList.roomId}">
									<button type='button' id="conBtn" class='btnCon btn-primary'>참여</button>
								</span></td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
		</div>
	</div>
</body>
</html>