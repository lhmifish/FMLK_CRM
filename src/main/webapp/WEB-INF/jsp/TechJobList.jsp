<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="pragma" content="no-cache" />
<meta http-equiv="cache-control" content="no-cache" />
<title>技术工作表</title>
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/loading.css?v=2">
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/animate.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/showbox.css" />
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/flatpickr.material_blue.min.css">
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/xcConfirm.css?v=2010" />
<link href='http://fonts.googleapis.com/css?family=Roboto'
	rel='stylesheet' type='text/css'>
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/css.css?v=1990" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/select4.css?v=1999" />
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.2.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/select3.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/xcConfirm.js"></script>
<script src="${pageContext.request.contextPath}/js/changePsd.js"></script>
<script src="${pageContext.request.contextPath}/js/loading.js"></script>
<script src="${pageContext.request.contextPath}/js/request.js?v=2"></script>
<style type="text/css">
a:link {
	color: #000
} /* 未访问的链接 */
a:hover {
	color: #FF00FF
} /* 鼠标移动到链接上 */
</style>
<script type="text/javascript">
	var userNum;
	var dayNum;
	var userArr;
	var jobArrP;
	var jobArrA;
	var jobArrA_previous;
	var year;
	var month;
	var DayOfWeek;
	var startWeekStr;
	var timer;
	var len;//滚轮长度
	var sId;
	var host;
	var requestReturn;
	var arrCompany;
	
	$(document)
	.ready(
			function() {
				sId = "${sessionId}";
				host = "${pageContext.request.contextPath}";
				if (sId == null || sId == "") {
					parent.location.href = host + "/page/login";
				} else {
					var w = document.documentElement.clientWidth;
					document.getElementById('scrollBody').style.width = (w - 200)
							+ "px";
					getYearList();
					arrCompany = new Array();
					getArrCompany(true)
					getUserList(year, month);
					if (parseInt(startWeekStr.split("/")[1]) == month) {
						var position = (startWeekStr.split("/")[2] - 1) * 140 - 1;
						$('#scrollBody').scrollLeft(position);
					}
					$("#year").select2({});
					$("#month").select2({});
				}
			});
	
	function getYearList(){
    	var yearStr = ""
    	var monthStr = ""
    	for(var i=2019;i<2050;i++){
    		yearStr+='<option value="'+i+'">'+i+'年</option>';
    	}
    	$("#year").empty();
		$("#year").append(yearStr);
		for(var i=1;i<13;i++){
			i=i<10?"0"+i:i;
			monthStr+='<option value="'+i+'">'+parseInt(i)+'月</option>'
    	}
		$("#month").empty();
		$("#month").append(monthStr);
    	var da = new Date();
		year = da.getFullYear();
		month = da.getMonth() + 1;
		dayNum = new Date(year, month, 0).getDate();//当月天数
		DayOfWeek = (da.getDay() == 0) ? 7 : da.getDay();
		startWeekStr = formatDate(
				new Date(year, month - 1, da.getDate()
						- DayOfWeek + 1)).substring(0, 10);//当前周第一天
		$("#year").val(year);
		month = month < 10 ? "0" + month : month;
		$("#month").val(month);
    }
	
	function getUserList(year, month) {
		var params = {
			"dpartId" : 101,
			"date" : year + "/" + month + "/1",
			"name" : "",
			"nickName" : "",
			"jobId" : "",
			"isHide" : true
		}
		get("userList", params, false);
		if (requestReturn.result == "error") {
			alert(requestReturn.error);
		} else {
			var str = '<tr id="corner" style="height:25px;color: #a10333;width: 120px;"><td><Strong>姓名/日期</Strong></td></tr>';
			var data2 = requestReturn.data.userlist;
			userNum = data2.length;
			userArr = new Array();
			for ( var i in data2) {
				str += '<tr style="width: 140px;height:38px;" id="tr_'+i+'" ><td><strong>'
						+ data2[i].name + '</strong></td></tr>';
				userArr.push(data2[i].UId + "#" + data2[i].name);
			}
			$("#tb1").empty();
			$("#tb1").append(str);
			getTableList();
		}
	}

	function formatDate(date) {
		var myyear = date.getFullYear();
		var mymonth = date.getMonth() + 1;
		var myweekday = date.getDate();
		var hour = date.getHours();
		var minute = date.getMinutes();
		if (mymonth < 10) {
			mymonth = "0" + mymonth;
		}
		if (myweekday < 10) {
			myweekday = "0" + myweekday;
		}
		return (myyear + "/" + mymonth + "/" + myweekday + " " + hour + ":" + minute);
	}

	function getList() {
		year = $("#year").val();
		month = $("#month").val();
		dayNum = new Date(year, month, 0).getDate();
		getUserList(year, month);
		var da = new Date();
		var thisMonth = da.getMonth() + 1;
		var thisYear = da.getFullYear();
		if (thisMonth == month && thisYear == year) {
			var position = (startWeekStr.split("/")[2] - 1) * 140 - 1;
			$('#scrollBody').scrollLeft(position);
		} else {
			$('#scrollBody').scrollLeft(1);
		}
	}

	function updateNewArr(arr) {
		jobArrA = new Array();
		for (var i = 0; i < arr.length; i++) {
			var isExist = false;
			for (var j = 0; j < jobArrA_previous.length; j++) {
				if (arr[i] == jobArrA_previous[j]) {
					isExist = true;
					break;
				}
			}
			if (!isExist) {
				jobArrA.push(arr[i]);
			}
		}
		return jobArrA;
	}
	
	function loading() {
		$('body').loading({
			loadingWidth : 160,
			title : '请稍等!',
			name : 'test',
			discription : '加载中',
			direction : 'column',
			type : 'origin',
			originDivWidth : 30,
			originDivHeight : 30,
			originWidth : 6,
			originHeight : 6,
			smallLoading : false,
			loadingMaskBg : 'rgba(0,0,0,0.2)'
		});
	}

	function closeLoading() {
		removeLoading('test');
	}
	
	/* 获取客户 */
	function getArrCompany(isFmlkShare) {
		var params = {
			"salesId" : 0,
			"companyName" : "",
			"isFmlkShare" : isFmlkShare
		}
		get("companyList", params, false)
		if (requestReturn.result == "error") {
			alert(requestReturn.error);
		} else {
			var data = requestReturn.data.companylist;
			if (data.length > 0) {
				for ( var i in data) {
					arrCompany[data[i].companyId] = data[i].companyName;
				}
				if (isFmlkShare) {
					isFmlkShare = false;
					getArrCompany(isFmlkShare);
				}
			}
		}
	}
	
	function getTableList() {
		var str = '<tr style="width: 100%; float: left; height: 25px;background-color: #eee;">';
		for (var i = 0; i < dayNum; i++) {
			str += '<td style="width: 140px; height: 25px;"><Strong>' + (i + 1)
					+ '日</Strong></td>';
		}
		str += '</tr>';
		for (var j = 0; j < userNum; j++) {
			var str2 = '<tr style="width: 100%; float: left; height: 38px; overflow-y: hidden;">';
			for (var k = 0; k < dayNum; k++) {
				str2 += '<td style="width: 140px;height: 38px;" id="'
						+ j
						+ "_"
						+ k
						+ '">'
						+ '<input id="'
						+ j
						+ "_"
						+ k
						+ '_1" type="text" style="border:0px;font-size:12px;text-indent:1px;height:30px" '
						+ 'disabled="disabled" >'
						+ '<input id="'
						+ j
						+ "_"
						+ k
						+ '_2" type="text" style="border:0px;font-size:12px;text-indent:1px;height:30px;display:none" '
						+ 'disabled="disabled" >'
						+ '</td>'
			}
			str2 += '</tr>';
			str = str + str2;
		}
		document.getElementById("tb2").style.width = dayNum * 140 + 'px';
		$("#tb2").empty();
		$("#tb2").append(str);
		loading();
		setTimeout(function() {
			getJobList();
		}, 500);
	}
	
	function getJobList() {
		var params = {
				"year" : year,
				"month" : month,
				"userId" : 0
			}
		get("getJobList", params, false);
		if (requestReturn.result == "error") {
			closeLoading();
			alert(requestReturn.error);
		} else {
			var data2 = requestReturn.data.joblist;
			params.companyId = "";
			get("visitRecordList", params, false);
			if (requestReturn.result == "error") {
				closeLoading();
				alert(requestReturn.error);
			} else {
				
				var data = requestReturn.data.visitRecordList;
				//合并
				if (data.length > 0) {
					for ( var t in data) {
					    job = {}
						job.jobDescriptionP = arrCompany[data[t].companyId];
						job.date = data[t].visitDate;
						job.userId = data[t].salesId;
						job.time = "";
						data2.push(job);
					}
				}
				if (data2.length > 0) {
					for ( var i in data2) {
						    var jobDescriptionP = data2[i].jobDescriptionP;
							var time = data2[i].time;
							var date = data2[i].date;
							var day;
							if(date.indexOf(".")>-1){
								day = parseInt(date.split(".")[2]) - 1;
							}else{
								day = parseInt(date.split("/")[2]) - 1;
							}
							var isFind = false;
							var line;
							for ( var j in userArr) {
								if (data2[i].userId == userArr[j].split("#")[0]) {
									isFind = true;
									line = j;
									break;
								}
							}
							if (isFind) {
								var mId = line + "_" + day + "_1";
								var tId = line + "_" + day + "_2";
								var mTd = line + "_" + day;
								var mTitle = userArr[line].split("#")[1]+" "
										+ parseInt(month) + "月" + parseInt(day + 1)
										+ "日\n";
								if (jobDescriptionP != "" && jobDescriptionP != undefined) {
									var previousValue = $("#" + mId).val();
									var newValue;
									if (previousValue != ""
											&& previousValue != null && previousValue.indexOf(jobDescriptionP) == -1) {
										newValue = previousValue + ";"+ jobDescriptionP;
									} else {
										newValue = jobDescriptionP;
									}
									if(newValue.indexOf("%") != -1){
										if(newValue.split("%")[0]==newValue.split("%")[1]){
											newValue = newValue.split("%")[0].trim() + ";"
										}else{
											newValue = newValue.replace("%",";").trim()
										}
									}
									$("#" + mId).val(newValue==";"?"":newValue);
								}
								$("#" + tId).val($("#" + mId).val().replace(";", "#").trim());
								var tTitle = $("#" + tId).val().replace(
										new RegExp("#", "g"), '\n');
								mTitle = mTitle + tTitle;

								$("#" + mId).val() != "" ? $("#" + mId).css({
									"background-color" : "green",
									"color" : "white"
								}) : "";
								document.getElementById(mTd).setAttribute("title",
										mTitle);
							}
					}
				}
				closeLoading();
			}
		}
	}
</script>
</head>
<body>
	<div id="pageAll" style="margin-bottom: 30px;">

		<div style="width: 100%; margin: 10px">
			<Strong
				style="text-align: center; margin-left: 50px; width: 150px; margin-right: 50px">查询：</Strong>
			<select class="selCss" style="width: 100px;" id="year"></select>
			<span style="margin-right: 30px"></span>
			<select class="selCss" style="width: 80px;" id="month"></select> 
			<a class="addA" onClick="getList()">跳转</a>
		</div>

		<div
			style="width: 120px; float: left; background-color: #eee; height: auto; margin-top: 10px; margin-left: 20px; margin-bottom: 20px;">
			<table id="tb1"
				style="width: 100%; text-align: center; height: auto;" border="1">
			</table>
		</div>
		<div id="scrollBody"
			style="overflow: auto; float: left; height: auto; margin-top: 10px; margin-right: 20px; margin-bottom: 20px;">
			<table id="tb2"
				style="width: 6200px; text-align: center; overflow: auto;">
			</table>
		</div>
	</div>
</body>
</html>
