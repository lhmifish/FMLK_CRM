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
<title>飞默利凯共享陪护床</title>
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/css.css?v=1990" />
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.2.1.min.js"></script>

<script type="text/javascript">
	var limitStr = "";
	var str = "";
	$(document)
			.ready(
					function() {
						var host = "${pageContext.request.contextPath}";
						var str;
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
						getClientList()
					});

	function getClientList() {
		$
				.ajax({
					url : "${pageContext.request.contextPath}/clientList",
					type : 'GET',
					data : {},
					cache : false,
					async : false,
					success : function(returndata) {
						var data = eval("(" + returndata + ")").clientList;

						for ( var i in data) {
							str += "<a style='font-size: 18px; line-height: 35px'>"
									+ data[i].clientName + "</a>";
							if (i < 30) {
								limitStr += "<a style='font-size: 18px; line-height: 35px'>"
										+ data[i].clientName + "</a>";
							}
						}
						if(data.length>30){
							limitStr += "<a style='font-size: 14px; line-height: 35px;color:red' onclick='showMore()'>显示更多...</a>";
						}
						if(data.length != 30){
							str += "<a style='font-size: 14px; line-height: 35px;color:red' onclick='showLimit()'>收起...</a>";
						}
						$("#clientView").empty();
						$("#clientView").append(limitStr);
					},
					error : function(XMLHttpRequest, textStatus, errorThrown) {
					}
				});
	}

	function showMore() {
		$("#clientView").empty();
		$("#clientView").append(str);
	}
	
	function showLimit(){
		$("#clientView").empty();
		$("#clientView").append(limitStr);
	}
</script>
</head>

<body style="margin: 0; background-color: #fff">
	<div id="mDiv2"
		style="width: 100%; height: auto; display: flex; flex-direction: column; align-items: center; font-size: 0">
	</div>
</body>
</html>