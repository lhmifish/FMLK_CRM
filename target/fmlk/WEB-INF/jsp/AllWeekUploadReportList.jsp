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
<title>所有周报</title>


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
<script src="${pageContext.request.contextPath}/js/getObjectList.js?v=2024"></script>
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
/*独立*/
</style>
<script type="text/javascript">
	var arrayId;
	var arrayDur;
	var startWeekStr;
	var endWeekStr;
	var host;
	var sId;
	var arrCompany;
	var arrProject;

	$(document).ready(function() {
		sId = "${mUserId}";
		host = "${pageContext.request.contextPath}";
		refreshDate(formatDate(new Date()).substring(0, 10));
		document.getElementById("date").flatpickr({
			defaultDate : formatDate(new Date()).substring(0, 10),
			dateFormat : "Y/m/d",
			enableTime : false,
			onChange : function(dateObj, dateStr) {
				refreshDate(dateStr);
				getAllWeekUploadReportList();
			}
		});
		arrCompany = {};
		arrProject = {};
		getArrCompany(true);
	});

	function getArrCompany(isFmlkShare) {
		var xhr = createxmlHttpRequest();
		xhr.open("GET", host + "/companyList?salesId=0&companyName=&isFmlkShare="+isFmlkShare, true);
		xhr.onreadystatechange = function() {
			if (this.readyState == 4) {
				var data = eval("(" + xhr.responseText + ")").companylist;
				for ( var i in data) {
					arrCompany[data[i].companyId] = data[i].companyName;
				}
				if(isFmlkShare){
					getArrCompany(false)	
				}else{
					getArrProject(isFmlkShare);
				}
			}
		};
		xhr.send();
	}

	function getArrProject(isFmlkShare) {
		var xhr = createxmlHttpRequest();
		xhr.open("GET",host+ "/projectList?companyId=&projectName=&salesId=0&projectType=0&productStyle=0&isFmlkShare="+isFmlkShare,
						true);
		xhr.onreadystatechange = function() {
			if (this.readyState == 4) {
				var data = eval("(" + xhr.responseText + ")").projectList;
				for ( var i in data) {
					arrProject[data[i].projectId] = data[i].projectName;
				}
				if(!isFmlkShare){
					getArrProject(true)
				}else{
					getAllWeekUploadReportList();
				}
			}
		};
		xhr.send();
	}

	function getAllWeekUploadReportList() {
		var today = formatDate(new Date()).substring(0, 10);
		var xhr = createxmlHttpRequest();
		xhr.open("GET", host + "/userList?date=" + today
				+ "&dpartId=99&name=&nickName=&jobId=&isHide=true", true);
		xhr.onreadystatechange = function() {
			if (this.readyState == 4) {
				var data2 = eval("(" + xhr.responseText + ")").userlist;
				$.ajax({
							url : "${pageContext.request.contextPath}/getAllWeekUploadReportList",
							type : 'GET',
							cache : false,
							data : {
								"startDate" : startWeekStr,
								"endDate" : endWeekStr
							},
							success : function(returndata) {
								var data = eval("(" + returndata + ")").weekuploadreportlist;
								var str2 = '';
								if (returndata.length > 0) {
									for ( var j in data2) {
										var nName = data2[j].nickName;
										arrayDur = new Array();
										for ( var i in data) {
											if (sId == "lv.zhong" || sId == "lu.haiming") {
												if (data[i].userName == data2[j].nickName) {
													arrayDur.push(data[i]);
												}
											} else {
												if (data[i].userName == nName
														&& nName == sId) {
													arrayDur.push(data[i]);
												}
											}
										}
										if (arrayDur.length > 0) {
											str2 += '<div style="width: 97%; border: 1px solid black; margin: 5px; height: auto" >'
													+ '<p class="mes2"><strong style="font-size: 16px;">'
													+ getUser(arrayDur[0].userName).name
													+ '</strong></p>'
													+ '<p class="mes" ><strong>周总结：</strong></p><p class="mes3" style="height:auto">';
											for ( var k in arrayDur) {
												var tProject = (arrProject[arrayDur[k].crmNum]==undefined || arrProject[arrayDur[k].crmNum]== null)?"":arrProject[arrayDur[k].crmNum];			
												str2 += arrayDur[k].date
														+ '&ensp;&ensp;&ensp;'
														+ arrayDur[k].time
														+ '<br/>客户：'
														+ arrCompany[arrayDur[k].client]
														+ '<br/>项目：'
														+ tProject
														+ '<br/>内容：'
														+ arrayDur[k].jobContent
														+ '<br/><br/>';
											}

											str2 += '</p></div>';

										}

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

	function editWeekUploadReport(c) {
		window.location.href = "https://open.weixin.qq.com/connect/oauth2/authorize?appid=wxfca99e2643b26241&redirect_uri=crm.lanstarnet.com%3a8082%2fdailyUploadProject%2fpage%2feditWeekUploadReport%2f"
				+ arrayId[c]
				+ "&response_type=code&scope=snsapi_base&agentid=1000009#wechat_redirect";
	}

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

	function showFloatPage(mDiv, mTitle) {
		$('#mBody').css({
			'position' : 'fixed'
		});
		window.wxc.xcConfirm(mDiv, {
			title : mTitle
		}, {
			onOk : function() {
				$('#mBody').css({
					'position' : 'static'
				});
			}
		});
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
</script>
</head>


<body class="body-gray" style="margin: auto;" id="mBody">
	<div class="form">
		<div class="top" style="width: 100%">
			<div style="width: 100%; margin-bottom: 5px;">
				<Strong style="margin-left: 5px">选择日期：</Strong> <input type="text"
					id="date" style="width: 80px;" /> <%-- <label style="margin-left:10px">${mUserId}</label>  --%>
			</div>
			<div style="width: 100%; margin-bottom: 5px;">
				<Strong style="margin-left: 5px">周报日期：</Strong> <input type="text"
					id="startDate" style="width: 80px;" />至 <input type="text"
					id="endDate" style="width: 80px; margin-left: 5px" />
			</div>
			<div id="list" style="width: 100%;"></div>
		</div>
	</div>

</body>
</html>