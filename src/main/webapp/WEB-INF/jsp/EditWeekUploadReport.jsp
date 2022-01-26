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
<title>周报</title>


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
	height: 20px;
	line-height: 20px;
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

/*独立*/
</style>
<script type="text/javascript">
	var startWeekStr3;//周报的前一周
	var endWeekStr3;
	var divLastWeekReport;
	var divThisDailyUploadReport;
	var id;//周报id
	var uName;//周报用户
	var isThisWeek;

	$(document).ready(
			function() {
				var uID = "${mUserId}";//访问用户id
				id = "${mId}";//周报id
				getUserName(uID);
                getData(id);
				getOtherInfo();
			});

	function getUserName(uid) {

		$.ajax({
			url : "${pageContext.request.contextPath}/getUserName",
			type : 'GET',
			data : {
				"uID" : uid
			},
			cache : false,
			async : false,
			success : function(returndata) {
				var data = eval("(" + returndata + ")").user;
				uName = data[0].name;
			}
		});
	}
	
	function getData(id){
		$.ajax({
			url : "${pageContext.request.contextPath}/getWeekUploadReport2",
			type : 'GET',
			cache : false,
			async : false,
			data : {
				"id" : id
			},
			success : function(returndata) {
				var data = eval("(" + returndata + ")").weekuploadreport;
				$(document).attr("title", data[0].userName + "的周报");
				$("#user").val(data[0].userName);
				$("#date").val(data[0].startDate);
				$("#date2").val(data[0].endDate);
				$("#weekReport").val(data[0].weekReport);
				
				var d1 = new Date(Date.parse(data[0].startDate));
				var d2 = new Date(Date.parse(data[0].endDate));
				var dNow = new Date();
				isThisWeek = new Boolean();
				if(dNow<=d2 && dNow>=d1){
					isThisWeek = true;
				}else{
					isThisWeek = false;
					//不给编辑
				}
				
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
	}

	function getOtherInfo() {
		var newDa3 = new Date(Date.parse($("#date").val()));
		var DayOfWeek3 = (newDa3.getDay() == 0) ? 7 : newDa3.getDay();
		startWeekStr3 = formatDate(new Date(newDa3.getFullYear(), newDa3
				.getMonth(), newDa3.getDate() - DayOfWeek3 + 1 - 7));
		endWeekStr3 = formatDate(new Date(newDa3.getFullYear(), newDa3
				.getMonth(), newDa3.getDate() + (6 - DayOfWeek3 + 1) - 7));
		$
				.ajax({
					url : "${pageContext.request.contextPath}/getOtherInfo",
					type : 'GET',
					data : {
						"date" : $("#date").val(),
						"date2" : $("#date2").val(),
						"lastDate" : startWeekStr3,//当前周报的前一周
						"lastDate2" : endWeekStr3,
						"userName" : $("#user").val()
					},
					cache : false,
					async : false,
					success : function(returndata) {
						var errorCode = eval("(" + returndata + ")").errcode;
                        var data = eval("(" + returndata + ")").dailyuploadreportlist;
						var str2 = '';
						for ( var i in data) {
							str2 += '<div style="width: 97%; border: 1px solid black; margin: 5px; height: auto">'
									+ '<p style="margin-left: 10px;border-bottom: 2px solid #F5F5F5;height: auto;line-height: 13px;font-size: 12px;">'
									+ '<strong>'
									+ data[i].userName
									+ '</strong></p>'
									+ '<p style="margin-left: 10px;border-bottom: 2px solid #F5F5F5;height: auto;line-height: 13px;font-size: 12px;">'
									+ '<strong>时间：</strong>'
									+ data[i].date
									+ '&emsp;'
									+ data[i].time
									+ '</p>'
									+ '<p style="margin-left: 10px;border-bottom: 2px solid #F5F5F5;height: auto;line-height: 13px;font-size: 12px;">'
									+ '<strong>工作类型：</strong>'
									+ data[i].jobType
									+ '<strong>&emsp;CRM编号：</strong>'
									+ data[i].crmNum
									+ '</p>'
									+ '<p style="margin-left: 10px;border-bottom: 2px solid #F5F5F5;height: auto;line-height: 13px;font-size: 12px;">'
									+ '<strong>项目名称：</strong>'
									+ getProjectName(data[i].crmNum)
									+ '</p>'
									+ '<p style="margin-left: 10px;border-bottom: 2px solid #F5F5F5;height: auto;line-height: 13px;font-size: 12px;">'
									+ '<strong>客户公司：</strong>'
									+ data[i].client
									+ '<strong>&emsp;客户联系人：</strong>'
									+ data[i].clientUser
									+ '</p>'
									+ '<p style="margin-left: 10px;border-bottom: 2px solid #F5F5F5;height: auto;line-height: 13px;font-size: 12px;">'
									+ '<strong>工作内容：</strong>'
									+ data[i].jobContent
									+ '</p>'
									+ '<p style="margin-left: 10px;border-bottom: 2px solid #F5F5F5;height: auto;line-height: 13px;font-size: 12px;">'
									+ '<strong>后续支持：</strong>'
									+ data[i].laterSupport
									+ '</p>'
									+ '<p style="margin-left: 10px;border-bottom: 2px solid #F5F5F5;height: auto;line-height: 13px;font-size: 12px;">'
									+ '<strong>备注：</strong>'
									+ data[i].remark + '</p></div>';
						}
					
						divThisDailyUploadReport = '<div style="width: 100%; margin-bottom: 50px;">' + str2 + '</div>';

						if (errorCode == 0) {
							//有周报
							var data2 = eval("(" + returndata + ")").weekuploadreport;
							var lineNum = data2[0].weekReport.split("\n").length;
							lineNum = 5*lineNum;
							divLastWeekReport = "<div><textarea id='weekReport2' style='border: 0; width: 95%' rows='"
									+ lineNum
									+ "'>"
									+ data2[0].weekReport
									+ "</textarea></div>";
						} else if (errorCode == 2) {
							//没有周报
							divLastWeekReport = "<div><textarea id='weekReport2' style='border: 0; width: 95%;color:red'>上周未上传周报</textarea></div>";
						}
					},
					error : function(XMLHttpRequest, textStatus, errorThrown) {
					}
				});
	}

	function editWeekReport() {
		var userName = $("#user").val();
		var weekReport = $("#weekReport").val();
		var startDate = $("#date").val();
		var endDate = $("#date2").val();
		

		if(uName != userName){
			alert("这不是你的周报，你不能编辑");
			return;
		}
		
		if(isThisWeek == false){
			alert("当前时间不在周报修改的时间");
			return;
		}
		
		if (weekReport == "") {
			alert("周总结内容不能为空");
			return;
		}

		$.ajax({
			url : "${pageContext.request.contextPath}/editWeekUploadReport",
			type : 'POST',
			cache : false,
			data : {
				"id" : id,
				"userName" : userName,
				"startDate" : startDate,
				"endDate" : endDate,
				"weekReport" : weekReport
			},
			cache : false,
			success : function(returndata) {
				var data = eval("(" + returndata + ")").errcode;
				if (data == 0) {
					alert("编辑成功");
					setTimeout(function() {
						//这个可以关闭安卓系统的手机  
						document.addEventListener('WeixinJSBridgeReady',
								function() {
									WeixinJSBridge.call('closeWindow');
								}, false);
						//这个可以关闭ios系统的手机  
						WeixinJSBridge.call('closeWindow');
					}, 500)
				} else {
					alert("编辑失败");
				}

			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
	}

	function formatDate(date) {
		var myyear = date.getFullYear();
		var mymonth = date.getMonth() + 1;
		var myweekday = date.getDate();
		if (mymonth < 10) {
			mymonth = "0" + mymonth;
		}
		if (myweekday < 10) {
			myweekday = "0" + myweekday;
		}
		return (myyear + "/" + mymonth + "/" + myweekday);
	}

	function getProjectName(crmNum) {
		if (crmNum != "") {
			var projectName;
			$.ajax({
				url : "${pageContext.request.contextPath}/getProjectName",
				type : 'GET',
				data : {
					"crmNum" : crmNum
				},
				cache : false,
				async : false,
				success : function(returndata) {
					var errorCode = eval("(" + returndata + ")").errcode;
					if (errorCode == 0) {
						projectName = eval("(" + returndata + ")").projectName;
					} else {
						projectName = "";
					}
				},
				error : function(XMLHttpRequest, textStatus, errorThrown) {
				}
			});
			return projectName;
		} else {
			return "";
		}
	}

	function showLastWeekUploadReport() {
		$('#mBody').css({'position':'fixed'});
		window.wxc.xcConfirm(divLastWeekReport, {
			title : $("#user").val() + " " + startWeekStr3 + " 至 "
					+ endWeekStr3 + " 周总结"
		},{onOk:function(){
			 $('#mBody').css({'position':'static'});
		}});
	}

	function showThisDailyUploadReport() {
		$('#mBody').css({'position':'fixed'});
		window.wxc.xcConfirm(divThisDailyUploadReport, {
			title : $("#user").val() + " " + $("#date").val() + " 至 " + $("#date2").val()
					+ " 日报"
		},{onOk:function(){
			 $('#mBody').css({'position':'static'});
		}});
	}
</script>
</head>


<body class="body-gray" style="margin: auto;" id="mBody">
	<div class="form">
		<div class="top" style="width: 100%;margin-bottom: 50px;">
			<p style="display: none">工作类型</p>
			<p class="mes" style="display: none">
				<input type="text" id="user" />
			</p>

			<p>
				<a style="color: red">* </a>日期
			</p>
			<p class="mes">
				<input id="date" style="width: 100px;" disabled="disabled" /> 至 <input
					id="date2" style="width: 100px; margin-left: 5px"
					disabled="disabled">
			</p>

			<p>
				<a style="color: red">* </a>本周周总结<a style="margin-left: 55px"
					href="javascript:void(0)"
					onclick="showLastWeekUploadReport();return false;">上周周总结</a> <a
					style="margin-left: 25px" href="javascript:void(0)"
					onclick="showThisDailyUploadReport();return false;">本周日报</a>

			</p>
			<div class="mes">
				<textarea placeholder="周总结" id="weekReport"
					style="border: 0; width: 95%" rows="27"></textarea>
			</div>
			
		</div>

	</div>

	<div class="button-submit">
		<button type="button" onclick="editWeekReport();"
			class="btn btn-primary">提交</button>
	</div>
</body>
</html>