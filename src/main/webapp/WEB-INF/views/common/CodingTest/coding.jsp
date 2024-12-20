<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<link rel="shortcut icon" href="#">
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
	#editor {
		height: 800px !important;
 		font-size: 15px;
	}
	
	#desc {
		height: 800px;
		font-size: 15px;
	}
</style>
</head>
<body>
 	<div style="display:flex;">
 		<div style="flex:0 0 30%;">
 			<div id="desc">
 				<b>문제 설명</b><br>
				수많은 마라톤 선수들이 마라톤에 참여하였습니다. 단 한 명의 선수를 제외하고는 모든 선수가 마라톤을 완주하였습니다.<br>
				<br>
				마라톤에 참여한 선수들의 이름이 담긴 배열 args와 완주한 선수들의 이름이 담긴 배열 completion이 주어질 때, 완주하지 못한 선수의 이름을 return 하도록 solution 함수를 작성해주세요.<br>
				<br>
				<b>제한사항</b><br>
				마라톤 경기에 참여한 선수의 수는 1명 이상 100,000명 이하입니다.<br>
				completion의 길이는 participant의 길이보다 1 작습니다.<br>
				참가자의 이름은 1개 이상 20개 이하의 알파벳 소문자로 이루어져 있습니다.<br>
				참가자 중에는 동명이인이 있을 수 있습니다.<br>
				<br>
				<b>입출력 예</b><br>
				<br>
				<b>예제 #1</b><br>
				args : ["leo", "kiki", "eden"]<br>
				completion : ["eden", "kiki"]<br>
				return : "leo"<br>
				"leo"는 참여자 명단에는 있지만, 완주자 명단에는 없기 때문에 완주하지 못했습니다.<br>
				<br>
				<b>예제 #2</b><br>
				args : ["mislav", "stanko", "mislav", "ana"]<br>
				completion : ["stanko", "ana", "mislav"]<br>
				return : "mislav"<br>
				"mislav"는 참여자 명단에는 두 명이 있지만, 완주자 명단에는 한 명밖에 없기 때문에 한명은 완주하지 못했습니다.<br>
				<br>
				출저 : 프로그래머스
			</div>
 			<div style="margin-top:20px;">
				<button onclick="send_compiler();" style="width: 200px; height: 100px; vertical-align:top;">Run</button>
				<button onclick="show_answer();" style="width: 200px; height: 100px; vertical-align:top;">답 보기</button>
				<div style="margin:5px 0 0 20px;">
					<div>결과: <span id="result"></span></div>
					<div>경과시간: <span id="performance"></span> m/s</div>
				</div>
			</div>
 		</div>
 		<div style="flex:0 0 70%;">
 			<div id="editor"></div>
			<div style="display:flex; margin-top:20px;">
				<div>출력:</div>
				<div id="output" style="flex:1 1 auto; padding-left:10px;">실행 결과가 여기에 표시됩니다.</div>
			</div>
 		</div>
	</div>
	
	
	<script src="https://cdnjs.cloudflare.com/ajax/libs/ace/1.2.3/ace.js"></script>
	<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
	<script>
		var editor = ace.edit("editor");
		$(function() {
			editor.setTheme("ace/theme/pastel_on_dark");
			editor.getSession().setMode("ace/mode/java");
			editor.setOptions({ maxLines: 1000 });
			
			$.ajax({
				url: "/resources/static/source/source_return_byte_array",
				beforeSend:function(xhr){
					xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
				},
				success: function(data) {
					editor.setValue(data, data.length);
				},
				error: function(err) {
					console.log(err);
				}
			})
		})
		
		function send_compiler() {
			$.ajax({
				type: "post",
				url: "/common/compile",
				data: JSON.stringify({"code" : editor.getValue()}),
				dataType : "json", 
				contentType: 'application/json',
				beforeSend:function(xhr){
					xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
				},
				success: function(data) {
					if(data.result == "성공") {
						$("#output").css("color", "#000");
						$("#result").css("color", "#000");
					}else {
						$("#output").css("color", "#f00");
						$("#result").css("color", "#f00");
					}
					
					$("#output").html(data.SystemOut != null ? data.SystemOut.replace(/\n/g, "<br>") : "");
					$("#performance").text(data.performance);
					$("#result").text(data.result);
				},
				error: function(err) {
					console.log(err);
					if(err.responseJSON != null) {
						alert("처리 중 문제가 발생했습니다.\n관리자에게 문의해주세요.\nerr status : " + err.responseJSON.status);
					}else {
						alert("다시 시도해주세요.");
					}
				}
			})
		}
		
		function show_answer() {
			$.ajax({
				url: "/resources/static/source/source_return_byte_array_answer",
				success: function(data) {
					editor.setValue(data, data.length);
				},
				error: function(err) {
					console.log(err);
				}
			})
		}
	</script>
</body>
</html>