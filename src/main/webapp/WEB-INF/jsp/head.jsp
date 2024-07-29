<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title>
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/public.css?v=2019" />
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.2.1.min.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/public.js"></script>
<script src="${pageContext.request.contextPath}/js/request.js?v=4"></script>
<script src="${pageContext.request.contextPath}/js/getObject.js?v=5"></script>
</head>

<style type="text/css">
body::-webkit-scrollbar {
	display:none;
}

html {
	-ms-overflow-style: none;
	/*火狐下隐藏滚动条*/
	overflow: -moz-scrollbars-none;
}

a:hover {
	color: #FF00FF
} /* 鼠标移动到链接上 */
</style>

<script type="text/javascript">
	var sId;
	var uId;
	var host;
	var requestReturn;

	$(document)
			.ready(
					function() {
						sId = "${sessionId}";
						host = "${pageContext.request.contextPath}";
						if (sId == null || sId == "") {
							window.location.href = host + "/page/login";
						} else {
							var user = getUser("nickName",sId);
							uId = user.UId;
							document.getElementById('p1').innerHTML = user.name;
							updateTime();
						}
					});
	
	function updateTime() {
		document.getElementById('label').innerHTML = formatDate(new Date());
		setTimeout("updateTime()", 1000);
	}

	function formatDate(date) {
		var myyear = date.getFullYear();
		var mymonth = date.getMonth() + 1;
		var myweekday = date.getDate();
		var hour = date.getHours();
		var minute = date.getMinutes();
		var second = date.getSeconds();
		if (mymonth < 10) {
			mymonth = "0" + mymonth;
		}
		if (myweekday < 10) {
			myweekday = "0" + myweekday;
		}
		if (second<10){
			second = "0" + second;
		}
		return (myyear + "/" + mymonth + "/" + myweekday + " " + hour + ":" + minute + ":" + second);
	}

	function logOut() {
		parent.location.href = host + "/page/login";
	}
	
	function ResetPsd(){
		parent.ResetPsd(uId);
	}
</script>

<body style="overflow-y:hidden">
	<!-- 头部 -->
	<div class="head" style="background-image: url(${pageContext.request.contextPath}/assets/images/main-slider/bannerTwo.jpg);">
		<div class="headL">
			<img class="headLogo"
				src="${pageContext.request.contextPath}/assets/images/logo_new_2020_11_9.png" style="width:230px"/>
		</div>
		<div style="width: 400px; height: 100%; float: left;">
			<p style="padding-top: 30px; margin-left:30px;font-size: 32px; font-family: Microsoft YaHei; font-weight: bold;">飞默利凯服务平台</p>
		</div>
		<div class="headR" style="padding-top: 20px">
			<p class="p1">
			    <label style="color: black;">欢迎您, <strong id="p1"
					style="font-size: 16px; color: brown"></strong></label><a
					style="font-size: 12px; margin-left: 20px; text-decoration: underline;color: black;"
					onClick="logOut()">退出</a><a
					style="font-size: 12px; margin-left: 20px; text-decoration: underline;color: black;"
					onClick="ResetPsd()">修改密码</a>
			</p>
			<br/>
			<p class="p2">
			    <label style="color: brown;font-weight: bold;">version:20240729</label>
				<label style="color: black;margin-left:20px;">当前时间：</label><label
					style="color: black; font-size: 12px;" id="label"></label>
			</p>
		</div>
	</div>
	
</body>
</html>