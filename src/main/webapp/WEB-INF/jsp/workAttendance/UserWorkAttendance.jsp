<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="pragma" content="no-cache" />
<meta http-equiv="cache-control" content="no-cache" />
<title>个人考勤数据</title>
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/css.css?v=1990" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/select4.css?v=1997" />
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.2.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/select3.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery.jqprint-0.3.js"></script>
<script src="http://www.jq22.com/jquery/jquery-migrate-1.2.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/changePsd.js"></script>
<script
	src="${pageContext.request.contextPath}/js/jquery.table2excel.js"></script>
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
	var isPermissionView;
	var mUrl;

	$(document)
			.ready(
					function() {
						sId = "${sessionId}";
						mUrl = "${pageContext.request.contextPath}";
						if (sId == null || sId == "") {
							parent.location.href = mUrl+"/page/login";
						} else {
							getUserPermissionList();
							var year = new Date().getFullYear();
							var month = new Date().getMonth() + 1;
							month = month < 10 ? "0" + month : month;
							$("#year").val(year);
							$("#month").val(month);
							getUserWorkAttendanceList();
							$("#year").select2({});
							$("#month").select2({});
						}
					});

	function getUserPermissionList() {
		$
				.ajax({
					url : mUrl+"/getUserPermissionList",
					type : 'GET',
					data : {
						"nickName" : sId
					},
					cache : false,
					async : false,
					success : function(returndata) {
						var data = eval("(" + returndata + ")").permissionSettingList;
						isPermissionView = false;
						for ( var i in data) {
							if (data[i].permissionId == 72) {
								isPermissionView = true;
								break;
							}
						}
						if (!isPermissionView) {
							window.location.href = mUrl+"/page/error";
						} else {
							$('#body').show();
						}
					},
					error : function(XMLHttpRequest, textStatus, errorThrown) {
					}
				});
	}

	function dlDailyUploadReport() {
		var tYear = $("#year").val();
		var nickName = sId;
		$
				.ajax({
					url : mUrl+"/getUserYearUploadReportList",
					type : 'GET',
					data : {
						"nickName" : nickName,
						"year" : tYear
					},
					cache : false,
					async : false,
					success : function(returndata) {
						var data = eval("(" + returndata + ")").yearuploadreportlist;
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
						} else {
							alert("当年没有你的日报数据");
						}
					}
				});
	}

	function getUserWorkAttendanceList() {
		var date = $("#year").val() + "/" + $("#month").val();
		$
				.ajax({
					url : mUrl+"/getUserWorkAttendanceList",
					type : 'GET',
					data : {
						"date" : date,
						"nickName" : sId,
						"date2" : ""
					},
					cache : false,
					async : false,
					success : function(returndata) {
						var str = "";
						var data = eval("(" + returndata + ")").dailylist;
						if (data.length == 0) {
							str += '<tr style="width: 100%"><td style="width: 100%;color:red;font-size: 12px; height: 35px;">月数据还没有录入</td></tr>';
						} else {
							for ( var i in data) {
								var schedule = data[i].schedule;
								var dailyReport = data[i].dailyReport;
								var weekReport = data[i].weekReport;
								var nextWeekPlan = data[i].nextWeekPlan;
								var projectReport = data[i].projectReport;
								var sign = data[i].sign;
								var overWorkTime = data[i].overWorkTime;
								var adjustRestTime = data[i].adjustRestTime;
								var festivalOverWorkTime = data[i].festivalOverWorkTime;
								var isLate = data[i].isLate;

								var scheduleTd = "";
								var dailyReportTd = "";
								var weekReportTd = "";
								var nextWeekPlanTd = "";
								var projectReportTd = "";
								var signTd = "";
								var overWorkTimeTd = "";
								var adjustRestTimeTd = "";
								var festivalOverWorkTimeTd = "";
								var isLateTd = "";

								if (schedule == "未发") {
									scheduleTd = '<td style="width:18%;font-size: 12px; height: 35px;color:red" class="tdColor2">未发</td>';
								} else {
									scheduleTd = '<td style="width:18%;font-size: 12px; height: 35px;" class="tdColor2">'
											+ schedule + '</td>';
								}

								if (dailyReport == "未发") {
									dailyReportTd = '<td style="width:4%;font-size: 12px; height: 35px;color:red" class="tdColor2">'
											+ dailyReport + '</td>';
								} else {
									dailyReportTd = '<td style="width:4%;font-size: 12px; height: 35px;" class="tdColor2">'
											+ dailyReport + '</td>';
								}

								if (weekReport == "未发") {
									weekReportTd = '<td style="width:4%;font-size: 12px; height: 35px;color:red" class="tdColor2">'
											+ weekReport + '</td>';
								} else {
									weekReportTd = '<td style="width:4%;font-size: 12px; height: 35px;" class="tdColor2">'
											+ weekReport + '</td>';
								}

								if (nextWeekPlan == "未发") {
									nextWeekPlanTd = '<td style="width:4%;font-size: 12px; height: 35px;color:red" class="tdColor2">'
											+ nextWeekPlan + '</td>';
								} else {
									nextWeekPlanTd = '<td style="width:4%;font-size: 12px; height: 35px;" class="tdColor2">'
											+ nextWeekPlan + '</td>';
								}

								if (projectReport == "未发") {
									projectReportTd = '<td style="width:4%;font-size: 12px; height: 35px;color:red" class="tdColor2">'
											+ projectReport + '</td>';
								} else {
									projectReportTd = '<td style="width:4%;font-size: 12px; height: 35px;" class="tdColor2">'
											+ projectReport + '</td>';
								}

								if (new RegExp('未签到').test(sign)
										|| new RegExp('未签退').test(sign)) {
									signTd = '<td style="width:40%;font-size: 12px; height: 35px;color:red" class="tdColor2">'
											+ sign + '</td>';
								} else {
									signTd = '<td style="width:40%;font-size: 12px; height: 35px;" class="tdColor2">'
											+ sign + '</td>';
								}

								if (overWorkTime != 0) {
									overWorkTimeTd = '<td style="width:4%;font-size: 12px; height: 35px;color:blue" class="tdColor2">'
											+ overWorkTime + '</td>';
								} else {
									overWorkTimeTd = '<td style="width:4%;font-size: 12px; height: 35px;" class="tdColor2"></td>';

								}

								if (adjustRestTime != 0) {
									adjustRestTimeTd = '<td style="width:4%;font-size: 12px; height: 35px;color:red" class="tdColor2">'
											+ adjustRestTime + '</td>';
								} else {
									adjustRestTimeTd = '<td style="width:4%;font-size: 12px; height: 35px;" class="tdColor2"></td>';
								}

								if (festivalOverWorkTime != 0) {
									festivalOverWorkTimeTd = '<td style="width:4%;font-size: 12px; height: 35px;color:blue" class="tdColor2">'
											+ festivalOverWorkTime + '</td>';
								} else {
									festivalOverWorkTimeTd = '<td style="width:4%;font-size: 12px; height: 35px;" class="tdColor2"></td>';
								}

								if (isLate == 1) {
									isLateTd = '<td style="width:4%;font-size: 12px; height: 35px;color:red" class="tdColor2">迟到</td>';
								} else {
									isLateTd = '<td style="width:4%;font-size: 12px; height: 35px;" class="tdColor2"></td>';
								}

								str += '<tr style="width:100%"><td style="width:7%;font-size: 12px; height: 35px;" class="tdColor2">'
										+ data[i].date
										+ '</td>'
										+ scheduleTd
										+ dailyReportTd
										//	+ weekReportTd
										//	+ nextWeekPlanTd
										//	+ projectReportTd
										+ signTd
										+ '<td style="width:15%;font-size: 12px; height: 35px;" class="tdColor2">'
										+ data[i].remark
										+ '</td>'
										+ overWorkTimeTd
										+ adjustRestTimeTd
										+ festivalOverWorkTimeTd
										+ isLateTd
										+ '</tr>';
							}
						}
						$("#tb").empty();
						$("#tb").append(str);
					},
					error : function(XMLHttpRequest, textStatus, errorThrown) {
					}
				});

	}

	function printTable() {
		$("#div1").jqprint();
	}
	
	function showTable(){
		var tYear = $("#year").val();
		var tMonth = $("#month").val();
		window.open(mUrl+"/page/noRecordExplainPage?year="+tYear+"&month="+tMonth);  
	}
</script>
</head>

<body id="body" style="display: none">
	<div id="pageAll">
		<div class="pageTop">
			<div class="page">
				<img src="../image/coin02.png" /><span><a href="#">首页</a>&nbsp;-&nbsp;<a
					href="#">考勤管理</a>&nbsp;-</span>&nbsp;个人考情数据
			</div>
		</div>

		<div class="page">
			<!-- vip页面样式 -->
			<div class="vip">
				<div class="conform">
					<form>
						<div class="cfD">
							<Strong style="margin-right: 30px">查询条件：</Strong><select
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
							</select><span style="margin-right: 20px"></span><select class="selCss"
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
							</select><a class="addA" style="width: 120px"
								onClick="getUserWorkAttendanceList()">搜索</a> <a class="addA"
								style="width: 120px" onClick="printTable()">打印表单</a> <a
								class="addA" style="width: 120px;"
								onClick="dlDailyUploadReport()" id="dlbtn">年度日报下载</a> <a
								class="addA" style="width: 120px;"
								onClick="showTable()" id="showbtn">缺漏打卡说明</a><label
								id="label" style="font-size: 12px;"></label>
						</div>
					</form>
				</div>
				<!-- vip 表格 显示 -->
				<div class="conShow" style="margin-bottom: 30px" id="div1">
					<table border="1" style="width: 100%">
						<tr style="width: 100%">
							<td style="width: 7%; font-size: 12px; height: 35px;"
								class="tdColor">日期</td>
							<td style="width: 18%; font-size: 12px; height: 35px;"
								class="tdColor">日程</td>
							<td style="width: 4%; font-size: 12px; height: 35px;"
								class="tdColor">日报</td>
							<!-- <td style="width: 4%; font-size: 12px; height: 35px;"
								class="tdColor">周报</td> -->
							<!-- <td style="width: 4%; font-size: 12px; height: 35px;"
								class="tdColor">下周计划</td> -->
							<!-- <td style="width: 4%; font-size: 12px; height: 35px;"
								class="tdColor">项目报告</td> -->
							<td style="width: 40%; font-size: 12px; height: 35px;"
								class="tdColor">签到/签退</td>
							<td style="width: 15%; font-size: 12px; height: 35px;"
								class="tdColor">备注</td>
							<td style="width: 4%; font-size: 12px; height: 35px;"
								class="tdColor">加班</td>
							<td style="width: 4%; font-size: 12px; height: 35px;"
								class="tdColor">请假</td>
							<td style="width: 4%; font-size: 12px; height: 35px;"
								class="tdColor">法定节日加班</td>
							<td style="width: 4%; font-size: 12px; height: 35px;"
								class="tdColor">迟到</td>
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