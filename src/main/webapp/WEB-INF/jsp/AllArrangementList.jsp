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
<title>所有日程</title>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/showbox.css" />
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/flatpickr.material_blue.min.css">
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/xcConfirm.css" />
<link href='http://fonts.googleapis.com/css?family=Roboto'
	rel='stylesheet' type='text/css'>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.2.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/jweixin-1.0.0.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/flatpickr.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/xcConfirm.js"></script>
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
	margin-left: 10px;
	height: 13px;
	line-height: 13px;
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
	height: 100px;
	line-height: 13px;
	overflow: scroll;
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

.verticalAlign {
	vertical-align: top;
	display: inline-block;
	height: 100%;
	margin-left: -1px;
}

.xcConfirm .popBox {
	background-color: #ffffff;
	width: 320px;
	height: 480px;
	margin-left: -160px;
	border-radius: 5px;
	font-weight: bold;
	color: #535e66;
	top: 180px;
}

.xcConfirm .popBox .ttBox {
	height: 20px;
	line-height: 20px;
	border-bottom: solid 1px #eef0f1;
	padding: 10px 20px;
}

.xcConfirm .popBox .ttBox .tt {
	font-size: 12px;
	display: block;
	height: 15px;
}

.xcConfirm .popBox .txtBox {
	margin: 5px 5px;
	height: 380px;
	overflow: hidden;
}

.xcConfirm .popBox .btnGroup .sgBtn {
	margin-top: 10px;
	margin-right: 10px;
}

.xcConfirm .popBox .txtBox p {
	height: 400px;
	margin: 5px;
	line-height: 16px;
	overflow-x: hidden;
	overflow-y: auto;
}

.xcConfirm .popBox .sgBtn {
	display: block;
	cursor: pointer;
	width: 95px;
	height: 25px;
	line-height: 25px;
	text-align: center;
	color: #FFFFFF;
	border-radius: 5px;
	font-size: 12px;
}

</style>
<script type="text/javascript">

var startWeekStr;
var endWeekStr;
var host;
var todayStr;
var arrayDur;
var sId;

$(document).ready(function() {
	sId = "${mUserId}";
	host = "${pageContext.request.contextPath}";
	todayStr = formatDate(new Date()).substring(0, 10);
	refreshDate(todayStr);
	document.getElementById("date").flatpickr({
		defaultDate : formatDate(new Date()).substring(0, 10),
		dateFormat : "Y/m/d",
		enableTime : false,
		onChange : function(dateObj, dateStr) {
			refreshDate(dateStr);
			getThisArrangementList();
		}
	});
	getThisArrangementList();
});

function changeDate(){
	
	
	
}

function refreshDate(d) {
	var newDa3 = new Date(Date.parse(d));
	var DayOfWeek3 = (newDa3.getDay() == 0) ? 7 : newDa3.getDay();
	startWeekStr = formatDate(
			new Date(newDa3.getFullYear(), newDa3.getMonth(), newDa3
					.getDate()
					- DayOfWeek3 + 1)).substring(0, 10);
	endWeekStr = formatDate(
			new Date(newDa3.getFullYear(), newDa3.getMonth(), newDa3
					.getDate()
					+ (6 - DayOfWeek3 + 1))).substring(0, 10);
	$("#startDate").val(startWeekStr);
	$("#endDate").val(endWeekStr);
}

function getUser(uId) {
	var user;
	$.ajax({
		url : host + "/getUserById",
		type : 'GET',
		data : {
			"uId" : uId
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

function getThisArrangementList(){
	var xhr = createxmlHttpRequest();
    xhr.open("GET", host + "/userList?date=" + todayStr
			+ "&dpartId=99&name=&nickName=&jobId=&isHide=true", true);
	xhr.onreadystatechange = function() {
		if (this.readyState == 4) {
		//	alert(xhr.responseText);
			var data2 = eval("(" + xhr.responseText + ")").userlist;
			$
					.ajax({
						url : host + "/getAllWeekPlan",
						type : 'GET',
						cache : false,
						data : {
							"startDate" : startWeekStr,
							"endDate" : endWeekStr
						},
						success : function(returndata) {
							var data = eval("(" + returndata + ")").joblist;
							var str2 = '';
							for ( var j in data2) {
								var uName = data2[j].name;
								var uUid = data2[j].UId;
								var uNickName = data2[j].nickName;
								
								arrayDur = new Array();
								for ( var i in data) {
									if(sId=="lv.zhong" || sId=="sun.ke" || sId=="yang.huifang" || sId=="gong.zhiping"|| sId=="lu.haiming" || sId=="wang.fan"){
										if (data[i].userId == uUid) {
											arrayDur.push(data[i]);
										}
									}else{
										if (data[i].userId == uUid && uNickName == sId) {
											arrayDur.push(data[i]);
										}
									}
								}
								if (arrayDur.length > 0) {
									str2 += '<div style="width: 97%; border: 1px solid black; margin: 5px; height: auto" >'
											+ '<p class="mes2"><strong style="font-size: 16px;">'
											+ uName
											+ '</strong></p>'
											+ '<p class="mes" ><strong>周计划：</strong></p><p class="mes3" style="height:auto">';
									for ( var k in arrayDur) {
										str2 += arrayDur[k].date
												+ '&ensp;&ensp;&ensp;'
												+ arrayDur[k].time
												+ '<br/>事件：'
												+ arrayDur[k].jobDescriptionP
												+ '<br/><br/>';
									}

									str2 += '</p></div>';

								}

							}
							$("#list").empty();
							$("#list").append(str2);
						},
						error : function(XMLHttpRequest, textStatus,
								errorThrown) {
						}
					});

		}
	};
	xhr.send();
	
}


</script>
</head>


<body class="body-gray" style="margin: auto;" id="mBody">
	<div class="form">
		<div class="top" style="width: 100%">
		    <div style="width: 100%; margin-bottom: 5px;">
				<Strong style="margin-left: 5px">选择日期：</Strong> <input type="text"
					id="date" style="width: 80px;" />
			</div>
			<div style="width: 100%; margin-bottom: 5px;" onclick="changeDate">
				<Strong style="margin-left: 5px">日程日期：</Strong> <input type="text"
					id="startDate" style="width: 80px;" readonly="readonly"/>至 <input type="text"
					id="endDate" style="width: 80px; margin-left: 5px" readonly="readonly"/>
			</div>
			<div id="list" style="width: 100%;"></div>
		</div>
	</div>

</body>
</html>