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
<title>飞默利凯共享陪护产品</title>
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

		/* var str;
		for (var i = 1; i < 8; i++) {
			var srcUrl = host + "/image/fmlk0" + i + ".jpg";
			if (i != 6) {
				str += "<image src='" + srcUrl
						+ "' style='width:100%'></image>";
			} else {
				str += "<div id='clientView' style='width:100%;background-image:url("
						+ srcUrl
						+ ");height:auto;background-size:100% auto;display:flex;flex-direction:column;align-items: center;'></div>"
			}
		}
		$("#mDiv2").empty();
		$("#mDiv2").append(str);
		getClientList() */
	});

	function backPage() {
		alert("返回")
	}
	
	function goTo(type){
		var url = ""
			switch (type) {
			case 'Y':
				url = "wpaFmlkProductYDetailPage";
				break;
			case 'C':
				url = "wpaFmlkProductCDetailPage";
				break;
			case 'L':
				url = "wpaFmlkProductLDetailPage";
				break;
			case 'P':
				url = "wpaFmlkProductPDetailPage";
				break;
			case 'B':
				url = "wpaFmlkProductBDetailPage";
				break;
			default:
				break;
			}
		url = host + "/page/" + url;
		window.location.href = url;
	}
</script>
</head>

<body style="margin: 0; background-color: #fff;display:flex;flex-direction: column;">
	<div
		style="position:fixed;width: 100%; height: 50px; display: flex; align-items: center; flex-direction: row; align-items: center; background-color: #5EC7CE;">
		<div
			style="width: 20%; height: 100%; display: flex; flex-direction: row; align-items: center;visibility:hidden"
			onclick="backPage()">
			<img style="width: 24px; height: 24px;margin-left:20px"
				src="${pageContext.request.contextPath}/image/ic_back.png"></img>
		</div>
		<div
			style="width: 60%; height: 100%; display: flex; flex-direction: row; align-items: center; justify-content: center; font-size: 18px; color: #fff"
			id="titleView"></div>
		<div style="width: 20%; height: 100%;"></div>
	</div>
	<div id="mDiv2"
		style="width: 100%; display: flex; flex-direction: column; align-items: center; font-size: 0;margin-top:50px">
		<div style="margin-top:30px;padding:0 20px;display: flex; flex-direction: column; align-items: center;color:#333" onclick="goTo('Y')">
		<image style="width:100%" src="${pageContext.request.contextPath}/image/wpa/product/Y.png"></image>
		<text style="margin-top:20px;font-size:16px;font-weight:400">智能座椅式共享陪护床</text>
		</div>
		<div style="margin-top:30px;padding:0 20px;display: flex; flex-direction: column; align-items: center;color:#333" onclick="goTo('C')">
		<image style="width:100%" src="${pageContext.request.contextPath}/image/wpa/product/C.png"></image>
		<text style="margin-top:20px;font-size:16px;font-weight:400">立式折叠共享陪护床</text>
		</div>
		<div style="margin-top:30px;padding:0 20px;display: flex; flex-direction: column; align-items: center;color:#333" onclick="goTo('L')">
		<image style="width:100%" src="${pageContext.request.contextPath}/image/wpa/product/L.png"></image>
		<text style="margin-top:20px;font-size:16px;font-weight:400">共享轮椅</text>
		</div>
		<div style="margin-top:30px;padding:0 20px;display: flex; flex-direction: column; align-items: center;color:#333" onclick="goTo('P')">
		<image style="width:100%" src="${pageContext.request.contextPath}/image/wpa/product/P.png"></image>
		<text style="margin-top:20px;font-size:16px;font-weight:400">共享急救推床</text>
		</div>
		<div style="margin-top:30px;padding:0 20px;display: flex; flex-direction: column; align-items: center;color:#333" onclick="goTo('B')">
		<image style="width:100%" src="${pageContext.request.contextPath}/image/wpa/product/B.png"></image>
		<text style="margin-top:20px;font-size:16px;font-weight:400">共享充电宝</text>
		</div>
		<div style="margin-top:170px;padding:0 90px;display: flex; flex-direction: column; align-items: center;margin-bottom:45px">
		<image style="width:100%" src="${pageContext.request.contextPath}/image/wpa/product/bottomImg.png"></image>
		</div>
	</div>
</body>
</html>