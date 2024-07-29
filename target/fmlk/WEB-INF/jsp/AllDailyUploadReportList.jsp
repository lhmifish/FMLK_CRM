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
<title>所有日报</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/showbox.css" />
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/flatpickr.material_blue.min.css">
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.2.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/jweixin-1.0.0.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/flatpickr.js"></script>
<script src="${pageContext.request.contextPath}/js/getObjectList.js"></script>
<style>
.mask-layer-loading {
	position: fixed;
	width: 100%;
	height: 100%;
	z-index: 999999;
	top: 0;
	left: 0;
	text-align: center;
	display: none;
}

.mask-layer-loading i, .mask-layer-loading img {
	text-align: center;
	color: #000000;
	font-size: 50px;
	position: relative;
	top: 50%;
}

input:-webkit-autofill, textarea:-webkit-autofill, select:-webkit-autofill
	{
	background-color: rgba(217, 217, 217, 0.29);
}

input {
	border: 0;
	background: #fff;
}

body {
	max-width: 640px;
	color: #444;
}
/*独立*/
.form {
	margin-top: 10px;
	width: 100%;
	background-color: #F5F5F5
}

.form div {
	background-color: #FFF;
}

.form p {
	height: 12px;
	line-height: 18px;
	margin-left: 5px;
	font-size: 12px;
}

.form img {
	width: 15px;
	height: 15px;
	position: relative;
	top: 6px;
	margin-right: 5px;
}

.form .mes {
	margin-left: 25px;
	border-bottom: 2px solid #F5F5F5;
}

.form .mes2 {
	margin-left: 10px;
	border-bottom: 2px solid #F5F5F5;
	height: auto;
	line-height: 13px;
}

.form .mes3 {
	margin-left: 10px;
	border-bottom: 2px solid #F5F5F5;
	height: auto;
	line-height: 13px;
}

.form .button-submit {
	height: 80px;
	line-height: 80px;
	text-align: center;
	background-color: #F5F5F5;
}

.button-submit button {
	position: fixed;
	bottom: 0;
	z-index: 9999;
	width: 100%;
	max-width: 640px;
	height: 40px;
	background-color: #459BFE;
	color: #FFF;
	border: 0;
}

select { /*很关键：将默认的select选择框样式清除*/
	appearance: none;
	-moz-appearance: none;
	-webkit-appearance: none;
	/*在选择框的最右侧中间显示小箭头图片*/
	background: url("${pageContext.request.contextPath}/image/arrow.png")
		no-repeat scroll right center transparent;
	/*为下拉小箭头留出一点位置，避免被文字覆盖*/
	padding-right: 14px;
	border: 0;
	width: 95%;
}
/*清除ie的默认选择框样式清除，隐藏下拉箭头*/
select::-ms-expand {
	display: none;
}

#pickdate {
	border: 0;
	width: 95%;
	background: url("./images/images/gd/arrow.png") no-repeat scroll right
		center transparent;
}

.evaluate_right {
	float: left;
	width: 100%;
	height: 100%;
}

.evaluate_right .rate_content {
	border: 0;
	background: #fff;
}

.evaluate_right_three {
	height: 50px;
	width: 60px;
	line-height: 55px;
	background: #fff;
}

.evaluate_right_imgs {
	margin-top: 17px;
}

.evaluate_right_four {
	margin-top: 23px;
}

.evaluate_right_two {
	bottom: -17px;
}

.evaluate_right .input-file {
	width: 50px;
	height: 50px;
}

.test .right_imgs li {
	float: left;
	display: block;
	height: 50px;
	width: 50px;
	background: no-repeat center center;
	background-size: cover;
	margin-right: 5px;
	position: relative;
}

.right_imgs li>span {
	position: absolute;
	cursor: pointer;
	text-align: center;
	top: -5px;
	right: -5px;
	width: 13px;
	height: 13px;
	line-height: 13px;
	z-index: 3;
	font-size: 12px;
	background-color: #000;
	opacity: .8;
	filter: alpha(opacity = 80);
	color: #FFF;
	text-decoration: none;
	border-radius: 50%;
	display: block;
}

ul, ol, li {
	list-style: none;
	padding: 0;
	margin: 0;
}

#dt {
	margin: 30px auto;
	height: 28px;
	padding: 0 6px;
	border: 1px solid #ccc;
	outline: none;
}
/*独立*/
</style>
<script type="text/javascript">
	var arrayId;
	var host;
	
	$(document).ready(function() {
		host = "${pageContext.request.contextPath}";
		document.getElementById("date").flatpickr({
			defaultDate : formatDate(new Date()).substring(0, 10),
			dateFormat : "Y/m/d",
			enableTime : false,
			onChange : function(dateObj, dateStr) {
				getAllDailyUploadReportList();
			}
		});
		getAllDailyUploadReportList();
	});

	function getUser(nName) {
		var user;
		$.ajax({
			url : host + "/getUserByNickName",
			type : 'GET',
			data : {
				"nickName" : nName
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

	function getCompany(mCompanyId) {
		var company;
		$.ajax({
			url : host + "/getCompanyByCompanyId",
			type : 'GET',
			data : {
				"companyId" : mCompanyId
			},
			cache : false,
			async : false,
			success : function(returndata) {
				company = eval("(" + returndata + ")").company[0];
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
		return company;
	}

	function getProject(mProjectId) {
		var project;
		$.ajax({
			url : host + "/getProjectByProjectId",
			type : 'GET',
			data : {
				"projectId" : mProjectId
			},
			cache : false,
			async : false,
			success : function(returndata) {
				project = eval("(" + returndata + ")").project[0];
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
		return project;
	}

	function getAllDailyUploadReportList() {
		var date = $("#date").val();
		arrayId = new Array();
		$
				.ajax({
					url : host + "/getAllDailyUploadReportList",
					type : 'GET',
					cache : false,
					data : {
						"date" : date
					},
					success : function(returndata) {
						var data = eval("(" + returndata + ")").dailyuploadreportlist;
						var str2 = '';
						for ( var i in data) {
							arrayId.push(data[i].id);
							str2 += '<div style="width: 97%; border: 1px solid black; margin: 5px; height: auto" onclick="editDailyUploadReport('
									+ i
									+ ')">'
									+ '<p class="mes2"><strong style="font-size: 16px;">'
									+ getUser(data[i].userName).name
									+ '</strong></p>'
									+ '<p class="mes2"><strong>时间：</strong>'
									+ data[i].date
									+ '&emsp;'
									+ data[i].time
									+ '</p>'
									+ '<p class="mes2"><strong>项目名称：</strong>'
									+ getProject(data[i].crmNum).projectName
									+ '</p>'
									+ '<p class="mes3"><strong>客户公司：</strong>'
									+ getCompany(data[i].client).companyName
									+ '</p>'
									+ '<p class="mes3"><strong>工作内容：</strong>'
									+ data[i].jobContent + '</p></div>';
						}
						$("#list").empty();
						$("#list").append(str2);
					},
					error : function(XMLHttpRequest, textStatus, errorThrown) {
					}
				});
	}

	function editDailyUploadReport(a) {
		/* window.location.href = "https://open.weixin.qq.com/connect/oauth2/authorize?appid=wxfca99e2643b26241&redirect_uri=crm.lanstarnet.com%3a8082%2fdailyUploadProject%2fpage%2feditDailyUploadReport%2f"
				+ arrayId[a]
				+ "&response_type=code&scope=snsapi_base&agentid=1000009#wechat_redirect"; */
	}
</script>
</head>


<body class="body-gray" style="margin: auto;">
	<div class="form">
		<div class="top" style="width: 100%">
			<div style="width: 100%; margin-bottom: 5px;">
				<Strong style="margin-left: 5px">日期：</Strong> <input type="text"
					id="date" style="width: 120px" />
				<div id="dd"></div>
			</div>
			<div id="list" style="width: 100%;"></div>
		</div>
	</div>

</body>
</html>