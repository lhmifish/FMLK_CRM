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
<title></title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/select4.css?v=2000" />
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/css.css?v=1990" />
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/material_blue_2.css">
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.2.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/jweixin-1.0.0.js"></script>
<script src="${pageContext.request.contextPath}/js/getObjectList.js"></script>
<script src="${pageContext.request.contextPath}/js/select3.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/flatpickr_v4.js?v=1990"></script>


<script type="text/javascript">
	var host;
	var baseUrl;
	var type;//1.用户押金协议2.用户服务协议3.法律条款与隐私协议
	var agreementUrl;
	var mTitle;

	$(document).ready(function() {
		host = "${pageContext.request.contextPath}";
		baseUrl = "http://mobile-api.family-care.cn/";
		type = "${type}";
		switch (parseInt(type)) {
		case 1:
			agreementUrl = "mobile/content/deposit";
			mTitle = "用户押金协议";
			break;
		case 2:
			agreementUrl = "mobile/content/agreements";
			mTitle = "用户服务协议";
			break;
		case 3:
			agreementUrl = "mobile/content/lawprivacy";
			mTitle = "法律条款与隐私协议";
			break;
		default:
			agreementUrl = "";
			mTitle = "";
			break;
		}
		document.title = mTitle;
		getContent();
	});

	function getContent() {
		console.log("111");
		var xhr = createxmlHttpRequest();
		xhr.open("POST", baseUrl + agreementUrl, true);
		console.log(baseUrl + agreementUrl);
		xhr.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
		xhr.onreadystatechange = function() {
			if (xhr.readyState === 4) {
				if (xhr.status == 200) {
					console.log(xhr.responseText);
					var data = eval("(" + xhr.responseText + ")").content;
					document.getElementById("body").innerHTML = data;
				}
			}
		};
		xhr.send();
	}
</script>
</head>
<body style="margin: auto; background-color: #fff" id="body">

</body>
</html>