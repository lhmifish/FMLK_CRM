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
<title>日报</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/showbox.css" />
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.2.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/getObjectList.js"></script>
<style>
* {
	margin: 0;
	padding: 0;
	font-size: 13px;
	color: #333;
}

body {
	background: #f1f1f1;
}

.content {
	background: #Fff;
	position: relative;
}

.contailner {
	background: #fff;
}

.common {
	height: 65px;
	width: 90%;
	padding-top: 26px;
	margin-left: 10%;
	border-bottom: 1px solid #cbcbcc;
	line-height: 27px;
	position: relative;
}

.common p {
	color: #111;
}

.title span:nth-child(1) {
	text-align: left;
	font-size: 16px;
	margin-left: 10%;
	font-weight: bold;
	color: #000;
	border-bottom: 1px solid #cbcbcc;
}

.common .img-div {
	position: absolute;
	left: -30px;
	top: 35px;
}

.common .one-img {
	position: absolute;
	left: -27px;
	top: 38px;
}

.lang {
	position: absolute;
	height: 71px;
	background: #cbcbcc;
	width: 1px;
	top: 59px;
	left: 5.7%;
}

.lang:last-child {
	background: none;
}
</style>


<script type="text/javascript">
	var arrayId;
	var uID;
	
	var sId;
	var host;

	$(document).ready(function() {
		sId = "${mUserId}";
		host = "${pageContext.request.contextPath}";
		sId = "zheng.lu";
		
		$(document).attr("title", getUser().name + "的已上传日报");
		
		getUserName(uID);
		getList(sId);
	});
	
	function getUser() {
		var user;
		$.ajax({
			url : host + "/getUserByNickName",
			type : 'GET',
			data : {
				"nickName" : sId
			},
			cache : false,
			async : false,
			success : function(returndata) {
				user = eval("(" + returndata + ")").user[0];
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
		return user;
	}

	function getList(uid) {
		//	uid= "lu.haiming";
		arrayId = new Array();
		$
				.ajax({
					url : "${pageContext.request.contextPath}/getDailyUploadReportList/"
							+ uid + "/",
					type : 'GET',
					cache : false,
					data : {},
					success : function(returndata) {
						var str = '';
						var data = eval("(" + returndata + ")").dailyuploadreportlist;
						for ( var i in data) {
							var mDate = data[i].date;
							var mTime = data[i].time;
							str += '<div class="title" href="javascript:void(0)" onclick="editDailyUploadReport('
									+ i
									+ ');return false;"><span>'
									+ mDate
									+ ' ' + mTime + ' 日报</span></div>';
							arrayId.push(data[i].id);
						}
						$("#section").empty();
						$("#section").append(str);
					},
					error : function(XMLHttpRequest, textStatus, errorThrown) {
					}
				});
	}

	function editDailyUploadReport(a) {
		//	uID= "lu.haiming";
		window.location.href = "${pageContext.request.contextPath}/page/editDailyUploadReport/"
				+ uID + "/" + arrayId[a];
	}
</script>
</head>


<body class="body-gray" style="margin: auto;">
	<div class="content">
		<section class="contailner" id="section"></section>
	</div>
</body>
</html>