<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="renderer" content="webkit" />
<meta http-equiv="X-UA-COMPATIBLE" content="IE=edge,chrome=1" />
<meta name="viewport"
	content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=no" />
<meta name="apple-mobile-web-app-capable" content="yes" />
<meta name="apple-mobile-web-app-status-bar-style" content="black" />
<meta name="format-detection" content="telephone=no" />
<meta http-equiv="pragma" content="no-cache" />
<meta http-equiv="cache-control" content="no-cache" />
<title>共享充电宝</title>
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/css.css?v=1990" />
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.2.1.min.js"></script>

<script type="text/javascript">
	var limitStr = "";
	var str = "";
	var host = "";
	$(document).ready(function() {
		host = "${pageContext.request.contextPath}";
		document.getElementById('titleView').innerHTML = document.title
		var str;
		for (var i = 1; i <= 5; i++) {
			var srcUrl = host + "/image/wpa/B/充电宝0" + i + ".jpg";
			str += "<image src='" + srcUrl
						+ "' style='width:100%'></image>";
			
		}
		$("#mDiv2").empty();
		$("#mDiv2").append(str);
	});

</script>
</head>

<body style="margin: 0; background-color: #fff;display:flex;flex-direction: column;">
	<div
		style="width: 100%; height: 50px; display: flex; align-items: center; flex-direction: row; align-items: center; background-color: #5EC7CE;position:fixed">
		<div
			style="width: 20%; height: 100%; display: flex; flex-direction: row; align-items: center;"
			onclick="history.back(-1);">
			<img style="width: 24px; height: 24px;margin-left:20px"
				src="${pageContext.request.contextPath}/image/ic_back.png"></img>
		</div>
		<div
			style="width: 60%; height: 100%; display: flex; flex-direction: row; align-items: center; justify-content: center; font-size: 18px; color: #fff"
			id="titleView"></div>
		<div style="width: 20%; height: 100%;"></div>
	</div>
	<div id="mDiv2" style="width:100%;display: flex; flex-direction: column;font-size: 0;margin-top:50px">
		
	</div>
</body>
</html>