<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="pragma" content="no-cache" />
<meta http-equiv="cache-control" content="no-cache" />
<title>所有人考勤数据</title>
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/css.css?v=1990" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/select4.css?v=1997" />
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/calendar.css" />
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.2.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/select3.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery.jqprint-0.3.js"></script>
<script src="http://www.jq22.com/jquery/jquery-migrate-1.2.1.min.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/validation.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/calendar.js"></script>
<script src="${pageContext.request.contextPath}/js/changePsd.js"></script>
<script
	src="${pageContext.request.contextPath}/js/jquery.table2excel.js"></script>
<script src="${pageContext.request.contextPath}/js/request.js?v=3"></script>
<script src="${pageContext.request.contextPath}/js/commonUtils.js"></script>
<style type="text/css">
a:hover {
	color: #FF00FF
} /* 鼠标移动到链接上 */
::-webkit-scrollbar {
	display: none;
}

html {
	-ms-overflow-style: none;
	/*火狐下隐藏滚动条*/
	overflow: -moz-scrollbars-none;
}
</style>
<script type="text/javascript">
	var sId;
	var queryType;
	var isPermissionEdit;
	var mRoleId;
	var host;
	var requestReturn;
	var list;//数据列表

	$(document)
			.ready(
					function() {
						sId = "${sessionId}";
						host = "${pageContext.request.contextPath}";
						if (sId == null || sId == "") {
							parent.location.href = host+"/page/login";
						} else {
							mRoleId = null;
							getUserPermissionList();
							var year = new Date().getFullYear();
							var month = new Date().getMonth() + 1;
							month = month < 10 ? "0" + month : month;
							$("#year").val(year);
							$("#month").val(month);
							queryType = 1;
							initDate();
							getUserList(true);
							getUserWorkAttendanceList();
							$("#year").select2({});
							$("#month").select2({});
							$("#userId").select2({});
							$("#queryType").select2({});

						}
					});

	function getUserPermissionList() {
		var params = {"nickName" : sId}
		get("getUserPermissionList",params,false)
		if(requestReturn.result == "error"){
			alert(requestReturn.error);
		}else{
			var data = requestReturn.data.permissionSettingList;
			isPermissionEdit = false;
			for ( var i in data) {
				if (data[i].permissionId == 74 ||  data[i].permissionId == 79) {
					//查看所有人&查看部门
					isPermissionEdit = true;
					break;
				}
			}
			if (!isPermissionEdit) {
				toErrorPage();
			} else {
				$('#body').show();
			}
		}
	}
	
	function getUser() {
		var user;
		var params = {"nickName" : sId}
		get("getUserByNickName",params,false)
		if(requestReturn.result == "error"){
			alert(requestReturn.error);
		}else{
			user = requestReturn.data.user[0];
		}
		return user;
	}

	function getUserList(mIsHide) {
		mRoleId = getUser().roleId;
		var dpartId = 99;
		if(mRoleId==3 || mRoleId==4){
			//销售部经理&副经理
			dpartId = 2
		}else if(mRoleId==19){
			//客服部经理
			dpartId = 9
		}else if(mRoleId==14){
			//运维部经理
			dpartId = 8
		}	
		var params = {
				"dpartId" : dpartId,
				"date" : "",
				"name" : "",
				"nickName" : "",
				"jobId" : "",
				"isHide" : mIsHide
		}		
		get("userList",params,false)
		if(requestReturn.result == "error"){
			alert(requestReturn.error);
		}else{
			var str = '';
			var data2 = requestReturn.data.userlist;
			for ( var i in data2) {
				//if((mRoleId==3 || mRoleId==4)&&)
				if((mRoleId==3 || mRoleId==4) && data2[i].departmentId==2){
					//销售
					str += '<option value="'+data2[i].nickName+'">'+ data2[i].name + '</option>';
				}else if(mRoleId==19 && data2[i].departmentId==9){
					//客服
					str += '<option value="'+data2[i].nickName+'">'+ data2[i].name + '</option>';
				}else if(mRoleId==14 && data2[i].departmentId==8){
					//运维
					str += '<option value="'+data2[i].nickName+'">'+ data2[i].name + '</option>';
				}else if(mRoleId==10 && data2[i].departmentId==1){
					//技术
					str += '<option value="'+data2[i].nickName+'">'+ data2[i].name + '</option>';
				}else if(mRoleId==9 || mRoleId==11 || mRoleId==12 || mRoleId==13){
					//总经理，管理员，副总，行政主管
					str += '<option value="'+data2[i].nickName+'">'+ data2[i].name + '</option>';
				}
			}
			$("#userId").empty();
			$("#userId").append(str);
		}
	}

	function getUserWorkAttendanceList() {
		var date2;
		if(queryType == 1){
			date2 = $('#mmDate').val();
		}else{
			date2 = "";
		}		
		var params={
				"date" : $("#year").val() + "/" + $("#month").val(),
				"nickName" : $("#userId").val(),
				"date2" : date2	
		}
		list = new Array();
		get("getUserWorkAttendanceList",params,false)		
		if(requestReturn.result == "error"){
			alert(requestReturn.error);
		}else{
			var str = "";
			var data = requestReturn.data.dailylist;
			if (data.length == 0) {
				str += '<tr style="width: 100%"><td style="width: 100%;color:red;font-size: 12px; height: 35px;">月数据还没有录入</td></tr>';
			} else {
				for (var i in data) {
					if((mRoleId==3 || mRoleId==4) && data[i].roleId>=3 && data[i].roleId<=5){
						list.push(data[i]);
					}else if(mRoleId==19 && (data[i].roleId==18 || data[i].roleId==19)){
						list.push(data[i]);
					}else if(mRoleId==14 && (data[i].roleId==14 || data[i].roleId==17)){
						list.push(data[i]);
					}else if(mRoleId==10 && data[i].roleId <= 2){
						list.push(data[i]);
					}else if(mRoleId==9 || mRoleId==11 || mRoleId==12 || mRoleId==13){
						list.push(data[i]);
					}
				}
				if(list.length == 0){
					str += '<tr style="width: 100%"><td style="width: 100%;color:red;font-size: 12px; height: 35px;">月数据还没有录入</td></tr>';
				}else{
					var first_column = "";
					for(var i in list){
						if (queryType == 1) {
							first_column = '<td style="width:7%;height: 50px;" class="tdColor2">'
									+ '<input type="text"  id="name'
									+ i
									+ '" style="font-size: 12px;border:none;width:98%;text-align:center;background-color:#fff" '
									+ 'value="'
									+ list[i].name
									+ '" disabled="disabled"/></td>';
							$("#coloum_name").show();
							$("#coloum_date").hide();
						} else {
							first_column = '<td style="width:7%;height: 50px;" class="tdColor2">'
									+ '<input type="text"  id="date'
									+ i
									+ '" style="font-size: 12px;border:none;width:98%;text-align:center;background-color:#fff" '
									+ 'value="'
									+ list[i].date
									+ '" disabled="disabled"/></td>';
							$("#coloum_date").show();
							$("#coloum_name").hide();
						}
						
						var scheduleTd = "";
						if (list[i].schedule == "未发") {
							scheduleTd = '<td style="width:14%; height: 50px;" class="tdColor2">'
									+ '<textarea type="text" style="font-size: 12px;border:none;width:98%;text-align:center;color:red;resize:none;height:50px;" id="schedule'
									+ i
									+ '">未发</textarea></td>';
						} else {
							scheduleTd = '<td style="width:14%; height: 50px;" class="tdColor2">'
									+ '<textarea type="text" style="font-size: 12px;border:none;width:98%;text-align:center;resize:none;height:50px;" id="schedule'
									+ i
									+ '">'
									+ list[i].schedule
									+ '</textarea></td>';
						}
						
						var dailyReportTd = "";
						if (list[i].dailyReport == "未发") {
							dailyReportTd = '<td style="width:4%; height: 50px" class="tdColor2">'
									+ '<input type="text" style="font-size: 12px;border:none;width:98%;text-align:center;color:red" id="dailyReport'
									+ i
									+ '" value="未发" /></td>';
						} else {
							dailyReportTd = '<td style="width:4%; height: 50px" class="tdColor2">'
									+ '<input type="text" style="font-size: 12px;border:none;width:98%;text-align:center" id="dailyReport'
									+ i
									+ '" value="'
									+ list[i].dailyReport
									+ '" /></td>';
						}
						
						var signTd = "";
						if (new RegExp('未签到').test(list[i].sign)
								|| new RegExp('未签退').test(list[i].sign)) {
							signTd = '<td style="width:40%;height: 50px;" class="tdColor2">'
									+ '<textarea type="text" style="font-size: 12px;border:none;width:98%;text-align:center;color:red;resize:none;height:50px;" id="sign'
									+ i
									+ '">'
									+ list[i].sign
									+ '</textarea></td>';
						} else {
							signTd = '<td style="width:40%;height: 50px;" class="tdColor2">'
									+ '<textarea type="text" style="font-size: 12px;border:none;width:98%;text-align:center;resize:none;height:50px;" id="sign'
									+ i
									+ '">'
									+ list[i].sign
									+ '</textarea></td>';
						}
						
						var remarkTd = '<td style="width:15%;height:50px;" class="tdColor2">'
							+ '<textarea type="text" style="font-size: 12px;border:none;width:98%;text-align:center;resize:none;height:50px;" id="remark'
							+ i
							+ '">'
							+ list[i].remark
							+ '</textarea></td>';
						
						var overWorkTimeTd = "";
						if (data[i].overWorkTime != 0) {
							overWorkTimeTd = '<td style="width:4%;height: 50px;" class="tdColor2">'
									+ '<input type="text" style="font-size: 12px;border:none;width:98%;text-align:center;color:blue" id="overWorkTime'
									+ i
									+ '" value="'
									+ data[i].overWorkTime
									+ '" /></td>';
						} else {
							overWorkTimeTd = '<td style="width:4%;height: 50px;" class="tdColor2">'
									+ '<input type="text" style="font-size: 12px;border:none;width:98%;text-align:center;" id="overWorkTime'
									+ i + '"/></td>';
						}

                        var adjustRestTimeTd = "";
						if (data[i].adjustRestTime != 0) {
							adjustRestTimeTd = '<td style="width:4%;height: 50px;" class="tdColor2">'
									+ '<input type="text" style="font-size: 12px;border:none;width:98%;text-align:center;color:red" id="adjustRestTime'
									+ i
									+ '" value="'
									+ data[i].adjustRestTime
									+ '" /></td>';
						} else {
							adjustRestTimeTd = '<td style="width:4%;height: 50px;" class="tdColor2">'
									+ '<input type="text" style="font-size: 12px;border:none;width:98%;text-align:center;" id="adjustRestTime'
									+ i + '"/></td>';
						}
						
						var festivalOverWorkTimeTd = "";
						if (data[i].festivalOverWorkTime != 0) {
							festivalOverWorkTimeTd = '<td style="width:4%;font-size: 12px; height: 50px;color:red" class="tdColor2">'
									+ '<input type="text" style="font-size: 12px;border:none;width:98%;text-align:center;color:blue" id="festivalOverWorkTime'
									+ i
									+ '" value="'
									+ data[i].festivalOverWorkTime
									+ '" /></td>';
						} else {
							festivalOverWorkTimeTd = '<td style="width:4%;font-size: 12px; height: 50px;" class="tdColor2">'
									+ '<input type="text" style="font-size: 12px;border:none;width:98%;text-align:center;" id="festivalOverWorkTime'
									+ i + '"/></td>';
						}
						
						
						
						var isLateTd = "";
						if (data[i].isLate == 1) {
							isLateTd = '<td style="width:4%;height: 50px;" class="tdColor2">'
									+ '<input type="text" style="font-size: 12px;border:none;width:98%;text-align:center;color:red" id="isLate'
									+ i + '" value="迟到"/></td>';
						} else {
							isLateTd = '<td style="width:4%;height: 50px;" class="tdColor2">'
									+ '<input type="text" style="font-size: 12px;border:none;width:98%;text-align:center;" id="isLate'
									+ i + '"/></td>';
						}
						var operationTd = "";
						if(sId=="super.admin"){
							operationTd = '<img title="编辑" style="vertical-align:middle" class="operation" src="../image/update.png" onclick="editWorkAttendance('+ i + ')"/>';
						}
						str += '<tr style="width:100%">'
							+ first_column
							+ scheduleTd
							+ dailyReportTd
							+ signTd
							+ remarkTd
							+ overWorkTimeTd
							+ adjustRestTimeTd
							+ festivalOverWorkTimeTd
							+ isLateTd
							+ '<td style="width:4%;font-size: 12px; height: 50px;" class="tdColor2">'
							+ operationTd
							+ '</td></tr>';
					}
				}
			}
			$("#tb").empty();
			$("#tb").append(str);
		}
	}

	function printTable() {
		$("#div1").jqprint();
	}

	function dlDailyUploadReport() {
		var tYear = $("#year").val();
		var nickName = $("#userId").val();
		var params = {
				"nickName" : nickName,
				"year" : tYear	
		}
		get("getUserYearUploadReportList",params,false)
		if(requestReturn.result == "error"){
			alert(requestReturn.error);
		}else{
			var data = requestReturn.data.yearuploadreportlist;
			if (data.length > 0) {
				var tab_text = "<table style='display:none' id='table1'>";
				for ( var i in data) {
					tab_text += "<tr>"
					tab_text += "<td>" + data[i].date + "</td>";
					tab_text += "<td>" + data[i].time + "</td>";
					tab_text += "<td>" + data[i].client + "</td>";
					tab_text += "<td>" + data[i].crmNum + "</td>";
					tab_text += "<td>" + data[i].jobContent
							+ "</td>";
					tab_text += "</tr>";
				}
				tab_text += "</table>";
				$("#div2").append(tab_text);

				$('#table1').table2excel(
						{
							filename : nickName + "_" + tYear + "_"
									+ ".xls"
						});
				$("#div2").empty();
			}else{
				alert("当年没有该员工的日报数据");
			}
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

	function initDate() {
		$('#mmDate').val(formatDate(new Date()).substring(0, 10));
		$('#dd').calendar({
			trigger : '#mmDate',
			zIndex : 999,
			format : 'yyyy/mm/dd',
			onSelected : function(view, date, data) {
			},
			onClose : function(view, date, data) {
				$('#mmDate').val(formatDate(date).substring(0, 10));
			}
		});
	}

	function changeQueryType(type) {
		queryType = type;
		if (type == 1) {
			$("#mSpan2").show();
			$("#mSpan1").hide();
			$("#dlbtn").hide();
		} else {
			$("#dlbtn").show();
			$("#mSpan1").show();
			$("#mSpan2").hide();
		}
	}

	function getUserName(tNickName) {
		var uName = "";
		var params = {"nickName" : tNickName}
		get("getUserByNickName",params,false)
		if(requestReturn.result == "error"){
			alert(requestReturn.error);
		}else{
			var data = requestReturn.data.user;
			uName = data[0].name;
		}
		return uName;
	}

	function editWorkAttendance(num) {
		var name;
		var date;
		if (queryType == 1) {
			//按日期查询
			name = $("#name" + num).val();
			date = $('#mmDate').val();
		} else {
			//按人员查询
			date = $("#date" + num).val();
			name = getUserName($("#userId").val());
		}
		var schedule = $("#schedule" + num).val().trim();
		var dailyReport = $("#dailyReport" + num).val().trim();
		//	var weekReport = $("#weekReport" + num).val().trim();
		//	var nextWeekPlan = $("#nextWeekPlan" + num).val().trim();
		//	var projectReport = $("#projectReport" + num).val().trim();
		var sign = $("#sign" + num).val().trim();
		var remark = $("#remark" + num).val().trim();
		var overWorkTime = $("#overWorkTime" + num).val().trim();
		overWorkTime = (overWorkTime == "") ? 0 : overWorkTime;
		var adjustRestTime = $("#adjustRestTime" + num).val().trim();
		adjustRestTime = (adjustRestTime == "") ? 0 : adjustRestTime;
		var festivalOverWorkTime = $("#festivalOverWorkTime" + num).val()
				.trim();
		festivalOverWorkTime = (festivalOverWorkTime == "") ? 0
				: festivalOverWorkTime;
		var isLate = $("#isLate" + num).val().trim();
		var patten1 = /^[0-9]+(.[0-9]{1})?$/.test(overWorkTime);
		var patten2 = /^[0-9]+(.[0-9]{1})?$/.test(adjustRestTime);
		var patten3 = /^[0-9]+(.[0-9]{1})?$/.test(festivalOverWorkTime);

		if (!patten1 || !patten2 || !patten3) {
			alert("加班或请假输入格式不正确");
			return;
		}

		if (isLate == "") {
			isLate = 0;
		} else if (isLate == "迟到") {
			isLate = 1;
		} else {
			alert("迟到栏只能空着或者填迟到");
			return;
		}

		$.ajax({
			url : "${pageContext.request.contextPath}/editWorkAttendance",
			type : 'POST',
			cache : false,
			data : {
				"name" : name,
				"date" : date,
				"schedule" : schedule,
				"dailyReport" : dailyReport,
				//	"weekReport" : weekReport,
				//	"nextWeekPlan" : nextWeekPlan,
				//	"projectReport" : projectReport,
				"sign" : sign,
				"remark" : remark,
				"overWorkTime" : overWorkTime,
				"adjustRestTime" : adjustRestTime,
				"festivalOverWorkTime" : festivalOverWorkTime,
				"isLate" : isLate
			},
			success : function(returndata) {
				var data = eval("(" + returndata + ")").errcode;
				if (data == 0) {
					alert("编辑成功");
				} else {
					alert("编辑失败");
				}
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
	}
	
	function changeCheck(){
		var isChecked = $("#dismissCheck").attr("checked");
		getUserList(!isChecked);
		getUserWorkAttendanceList();
	}

</script>
</head>

<body id="body" style="display: none">
	<div id="pageAll">
		<div class="pageTop">
			<div class="page">
				<img src="../image/coin02.png" /><span><a href="#">首页</a>&nbsp;-&nbsp;<a
					href="#">考勤管理</a>&nbsp;-</span>&nbsp;所有人考情数据
			</div>
		</div>

		<div class="page">
			<!-- vip页面样式 -->
			<div class="vip">
				<div class="conform">
					<form>
						<div class="cfD">
							<Strong style="margin-right: 30px">查询条件：</Strong><select
								id="queryType" class="selCss" style="width: 80px;"
								onChange="javascript:changeQueryType(this.value)">
								<option value="1">日期</option>
								<option value="2">人员</option>
							</select><a style="margin-right: 15px"></a><span style="display: none"
								id="mSpan1"><select class="selCss" id="userId"
								style="width: 80px;" /></select><a style="margin-right: 20px"></a><select
								class="selCss" style="width: 80px;" id="year">
									<option value="2018">2018年</option>
									<option value="2019">2019年</option>
									<option value="2020">2020年</option>
									<option value="2021">2021年</option>
									<option value="2022">2022年</option>
									<option value="2023">2023年</option>
									<option value="2024">2024年</option>
									<option value="2025">2025年</option>
									<option value="2026">2026年</option>
									<option value="2027">2027年</option>
									<option value="2028">2028年</option>
									<option value="2029">2029年</option>
									<option value="2030">2030年</option>
									<option value="2031">2031年</option>
									<option value="2032">2032年</option>
									<option value="2033">2033年</option>
									<option value="2034">2034年</option>
									<option value="2035">2035年</option>
									<option value="2036">2036年</option>
									<option value="2037">2037年</option>
									<option value="2038">2038年</option>
									<option value="2039">2039年</option>
									<option value="2040">2040年</option>
									<option value="2031">2041年</option>
									<option value="2032">2042年</option>
									<option value="2033">2043年</option>
									<option value="2034">2044年</option>
									<option value="2035">2045年</option>
									<option value="2036">2046年</option>
									<option value="2037">2047年</option>
									<option value="2038">2048年</option>
									<option value="2039">2049年</option>
									<option value="2040">2050年</option>
							</select><a style="margin-right: 20px"></a><select class="selCss"
								style="width: 80px;" id="month">
									<option value="01">1月</option>
									<option value="02">2月</option>
									<option value="03">3月</option>
									<option value="04">4月</option>
									<option value="05">5月</option>
									<option value="06">6月</option>
									<option value="07">7月</option>
									<option value="08">8月</option>
									<option value="09">9月</option>
									<option value="10">10月</option>
									<option value="11">11月</option>
									<option value="12">12月</option>
							</select></span><span id="mSpan2"><input type="text" id="mmDate"
								style="width: 90px" class="input3"><span id="dd"
								style="margin-left: -65px"></span></span>
							<input type="checkbox" style="margin-left:20px" id="dismissCheck" onclick="changeCheck()"/><a style="margin-left:5px">包含离职人员</a>
                            <a class="addA"
								style="width: 120px" onClick="getUserWorkAttendanceList()">搜索</a>
							<a class="addA" style="width: 120px" onClick="printTable()">打印表单</a>
							<a class="addA" style="width: 120px; display: none"
								onClick="dlDailyUploadReport()" id="dlbtn">年度日报下载</a> <label
								id="label" style="font-size: 12px;"></label>
						</div>
					</form>
				</div>
				<!-- vip 表格 显示 -->
				<div class="conShow" style="margin-bottom: 30px" id="div1">
					<table border="1" style="width: 100%" id="titleTab">
						<tr style="width: 100%">
							<td style="width: 7%; font-size: 12px; height: 35px;"
								class="tdColor" id="coloum_name">姓名</td>
							<td
								style="width: 7%; font-size: 12px; height: 50px; display: none"
								class="tdColor" id="coloum_date">日期</td>
							<td style="width: 14%; font-size: 12px; height: 50px;"
								class="tdColor">日程</td>
							<td style="width: 4%; font-size: 12px; height: 50px;"
								class="tdColor">日报</td>
							<!-- <td style="width: 4%; font-size: 12px; height: 50px;"
								class="tdColor">周报</td>
							<td style="width: 4%; font-size: 12px; height: 50px;"
								class="tdColor">下周计划</td>
							<td style="width: 4%; font-size: 12px; height: 50px;"
								class="tdColor">项目报告</td> -->
							<td style="width: 40%; font-size: 12px; height: 50px;"
								class="tdColor">签到/签退</td>
							<td style="width: 15%; font-size: 12px; height: 50px;"
								class="tdColor">备注</td>
							<td style="width: 4%; font-size: 12px; height: 50px;"
								class="tdColor">加班</td>
							<td style="width: 4%; font-size: 12px; height: 50px;"
								class="tdColor">请假</td>
							<td style="width: 4%; font-size: 12px; height: 50px;"
								class="tdColor">法定节日加班</td>
							<td style="width: 4%; font-size: 12px; height: 50px;"
								class="tdColor">迟到</td>
							<td style="width: 4%; font-size: 12px; height: 50px;"
								class="tdColor">操作</td>
						</tr>
					</table>
					<table id="tb" border="1" style="width: 100%">
					</table>
				</div>
				<div id="div2"></div>
				<!-- vip 表格 显示 end-->
			</div>
			<!-- vip页面样式end -->
		</div>

	</div>

</body>
</html>