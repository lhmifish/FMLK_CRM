<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="pragma" content="no-cache" />
<meta http-equiv="cache-control" content="no-cache" />
<title>个人月统计数据</title>
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
<style type="text/css">
a:hover {
	color: #FF00FF
} /* 鼠标移动到链接上 */
</style>
<script type="text/javascript">
	var sId;
	var isPermissionView;

	$(document)
			.ready(
					function() {
						sId = "${sessionId}";
						if (sId == null || sId == "") {
							parent.location.href = "${pageContext.request.contextPath}/page/login";
						} else {
							getUserPermissionList();
							var year = new Date().getFullYear();
							$("#year").val(year);
							getUserMonthReportList();
							$("#year").select2({});
						}
					});

	function getUserPermissionList() {
		$
				.ajax({
					url : "${pageContext.request.contextPath}/getUserPermissionList",
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
							if (data[i].permissionId == 73) {
								isPermissionView = true;
								break;
							}
						}
						if (!isPermissionView) {
							window.location.href = "${pageContext.request.contextPath}/page/error";
						} else {
							$('#body').show();
						}
					},
					error : function(XMLHttpRequest, textStatus, errorThrown) {
					}
				});
	}

	function getUserMonthReportList() {
		var year = $("#year").val();
		$
				.ajax({
					url : "${pageContext.request.contextPath}/getUserMonthReportList",
					type : 'GET',
					data : {
						"year" : year,
						"nickName" : sId,
						"month" : ""
					},
					cache : false,
					async : false,
					success : function(returndata) {
						var str = "";
						var data = eval("(" + returndata + ")").monthlist;
						if (data.length == 0) {
							str += '<tr style="width: 100%"><td style="width: 100%;color:red;font-size: 12px; height: 35px;">月数据还没有录入</td></tr>';
						} else {
							for (var i = 0; i < data.length; i++) {
								var sign = parseInt(parseInt(data[i].noSignIn)
										+ parseInt(data[i].noSignOut));
								var monthAccumulateData = getMonthAccumulateData(data[i].month);

								var accumulateOverWorkTime = monthAccumulateData
										.split("#")[0];
								var accumulateYearVacation = monthAccumulateData
										.split("#")[1];
								var overWorkTime4H = monthAccumulateData
										.split("#")[2];

								var scheduleTd = "";
								var dailyReportTd = "";
								var weekReportTd = "";
								var nextWeekPlanTd = "";
								var projectReportTd = "";
								var signTd = "";
								var isLateTd = "";
								var overWorkTimeTd = "";
								var adjustRestTimeTd = "";
								var festivalOverWorkTimeTd = "";
								var accumulateOverWorkTimeTd = "";
								var accumulateYearVacationTd = "";

								if (data[i].scheduleT != 0) {
									scheduleTd = '<td style="width:10%;font-size: 12px; height: 35px;color:red;" class="tdColor2">'
											+ data[i].scheduleT + '</td>';
								} else {
									scheduleTd = '<td style="width:10%;font-size: 12px; height: 35px;" class="tdColor2">'
											+ data[i].scheduleT + '</td>';
								}

								if (data[i].dailyReportT != 0) {
									dailyReportTd = '<td style="width:10%;font-size: 12px; height: 35px;color:red;" class="tdColor2">'
											+ data[i].dailyReportT + '</td>';
								} else {
									dailyReportTd = '<td style="width:10%;font-size: 12px; height: 35px;" class="tdColor2">'
											+ data[i].dailyReportT + '</td>';
								}

								if (data[i].weekReportT != 0) {
									weekReportTd = '<td style="width:7%;font-size: 12px; height: 35px;color:red;" class="tdColor2">'
											+ data[i].weekReportT + '</td>';
								} else {
									weekReportTd = '<td style="width:7%;font-size: 12px; height: 35px;" class="tdColor2">'
											+ data[i].weekReportT + '</td>';
								}

								if (data[i].nextWeekPlanT != 0) {
									nextWeekPlanTd = '<td style="width:8%;font-size: 12px; height: 35px;color:red;" class="tdColor2">'
											+ data[i].nextWeekPlanT + '</td>';
								} else {
									nextWeekPlanTd = '<td style="width:8%;font-size: 12px; height: 35px;" class="tdColor2">'
											+ data[i].nextWeekPlanT + '</td>';
								}

								if (data[i].projectReportT != 0) {
									projectReportTd = '<td style="width:8%;font-size: 12px; height: 35px;color:red;" class="tdColor2">'
											+ data[i].projectReportT + '</td>';
								} else {
									projectReportTd = '<td style="width:8%;font-size: 12px; height: 35px;" class="tdColor2">'
											+ data[i].projectReportT + '</td>';
								}

								if (sign != 0) {
									signTd = '<td style="width:10%;font-size: 12px; height: 35px;color:red;" class="tdColor2">'
											+ sign + '</td>';
								} else {
									signTd = '<td style="width:10%;font-size: 12px; height: 35px;" class="tdColor2">'
											+ sign + '</td>';
								}

								if (data[i].isLate != 0) {
									isLateTd = '<td style="width:10%;font-size: 12px; height: 35px;color:red;" class="tdColor2">'
											+ data[i].isLate + '</td>';
								} else {
									isLateTd = '<td style="width:10%;font-size: 12px; height: 35px;" class="tdColor2">'
											+ data[i].isLate + '</td>';
								}

								if (data[i].overWorkTime != 0) {
									/* overWorkTimeTd = '<td style="width:10%;font-size: 12px; height: 35px;color:blue;" class="tdColor2">'
											+ overWorkTime4H
											+ "/"
											+ (data[i].overWorkTime-overWorkTime4H) + '</td>'; */
									overWorkTimeTd = '<td style="width:10%;font-size: 12px; height: 35px;color:blue;" class="tdColor2">'
										+ (data[i].overWorkTime-overWorkTime4H) + '</td>';

								} else {
									/* overWorkTimeTd = '<td style="width:10%;font-size: 12px; height: 35px;" class="tdColor2">'
											+ overWorkTime4H
											+ "/"
											+ (data[i].overWorkTime-overWorkTime4H) + '</td>'; */
									overWorkTimeTd = '<td style="width:10%;font-size: 12px; height: 35px;" class="tdColor2">'
										+ (data[i].overWorkTime-overWorkTime4H) + '</td>';
								}

								if (data[i].adjustRestTime != 0) {
									adjustRestTimeTd = '<td style="width:10%;font-size: 12px; height: 35px;color:red;" class="tdColor2">'
											+ data[i].adjustRestTime + '</td>';
								} else {
									adjustRestTimeTd = '<td style="width:10%;font-size: 12px; height: 35px;" class="tdColor2">'
											+ data[i].adjustRestTime + '</td>';
								}

								if (data[i].festivalOverWorkTime != 0) {
									festivalOverWorkTimeTd = '<td style="width:10%;font-size: 12px; height: 35px;color:blue;" class="tdColor2">'
											+ data[i].festivalOverWorkTime
											+ '</td>';
								} else {
									festivalOverWorkTimeTd = '<td style="width:10%;font-size: 12px; height: 35px;" class="tdColor2">'
											+ data[i].festivalOverWorkTime
											+ '</td>';
								}

								if (accumulateOverWorkTime > 0) {
									accumulateOverWorkTimeTd = '<td style="width:10%;font-size: 12px; height: 35px;color:blue;" class="tdColor2">'
											+ accumulateOverWorkTime + '</td>';
								} else if (accumulateOverWorkTime < 0) {
									accumulateOverWorkTimeTd = '<td style="width:10%;font-size: 12px; height: 35px;color:red;" class="tdColor2">'
											+ accumulateOverWorkTime + '</td>';
								} else {
									accumulateOverWorkTimeTd = '<td style="width:10%;font-size: 12px; height: 35px;" class="tdColor2">'
											+ accumulateOverWorkTime + '</td>';
								}

								if (accumulateYearVacation != 0) {
									accumulateYearVacationTd = '<td style="width:10%;font-size: 12px; height: 35px;color:blue;" class="tdColor2">'
											+ accumulateYearVacation + '</td>';
								} else {
									accumulateYearVacationTd = '<td style="width:10%;font-size: 12px; height: 35px;" class="tdColor2">'
											+ accumulateYearVacation + '</td>';
								}

								str += '<tr style="width: 100%"><td style="width:10%;font-size: 12px; height: 35px;" class="tdColor2">'
										+ data[i].month
										+ '月</td>'
										+ scheduleTd
										+ dailyReportTd
									//	+ weekReportTd
									//	+ nextWeekPlanTd
									//	+ projectReportTd
										+ signTd
										+ isLateTd
										+ overWorkTimeTd
										+ adjustRestTimeTd
										+ festivalOverWorkTimeTd
										+ accumulateOverWorkTimeTd
										+ accumulateYearVacationTd + '</tr>';
							}
						}
						$("#tb").empty();
						$("#tb").append(str);
					},
					error : function(XMLHttpRequest, textStatus, errorThrown) {
					}
				});

	}

	function getMonthAccumulateData(mMonth) {
		var mReturndata = null;
		if (mMonth < 10) {
			mMonth = "0" + mMonth;
		}
		$
				.ajax({
					url : "${pageContext.request.contextPath}/getMonthAccumulateData",
					type : 'GET',
					data : {
						"date" : $("#year").val() + "/" + mMonth,
						"nickName" : sId,
					},
					cache : false,
					async : false,
					success : function(returndata) {
						var accumulateOverWorkTime = eval("(" + returndata
								+ ")").accumulateOverWorkTime;
						var accumulateYearVacation = eval("(" + returndata
								+ ")").accumulateYearVacation;
						var overWorkTime4H = eval("(" + returndata + ")").overWorkTime4H;
						mReturndata = accumulateOverWorkTime + "#"
								+ accumulateYearVacation + "#" + overWorkTime4H;
					},
					error : function(XMLHttpRequest, textStatus, errorThrown) {
					}
				});
		return mReturndata;
	}

	function printTable() {
		$("#div1").jqprint();
	}
</script>
</head>

<body id="body" style="display: none">
	<div id="pageAll">
		<div class="pageTop">
			<div class="page">
				<img src="../image/coin02.png" /><span><a href="#">首页</a>&nbsp;-&nbsp;<a
					href="#">考勤管理</a>&nbsp;-</span>&nbsp;个人月统计数据
			</div>
		</div>

		<div class="page">
			<!-- vip页面样式 -->
			<div class="vip">
				<div class="conform">
					<form>
						<div class="cfD">
							<Strong style="margin-right: 30px">查询条件：</Strong><select
								class="selCss" style="width: 100px;" id="year">
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
							</select><a class="addA" style="width: 120px"
								onClick="getUserMonthReportList()">搜索</a> <a class="addA"
								style="width: 120px" onClick="printTable()">打印表单</a><label
								id="label" style="font-size: 12px;"></label>
						</div>
					</form>
				</div>
				<!-- vip 表格 显示 -->
				<div class="conShow" style="margin-bottom: 30px" id="div1">
					<table border="1" style="width: 100%">
						<tr style="width: 100%">
							<td style="width: 10%; font-size: 12px; height: 35px;"
								class="tdColor">月份</td>
							<td style="width: 10%; font-size: 12px; height: 35px;"
								class="tdColor">日程</td>
							<td style="width: 10%; font-size: 12px; height: 35px;"
								class="tdColor">日报</td>
							<!-- <td style="width: 7%; font-size: 12px; height: 35px;"
								class="tdColor">周报</td> -->
							<!-- <td style="width: 8%; font-size: 12px; height: 35px;"
								class="tdColor">下周计划</td> -->
							<!-- <td style="width: 8%; font-size: 12px; height: 35px;"
								class="tdColor">项目计划/报告</td> -->
							<td style="width: 10%; font-size: 12px; height: 35px;"
								class="tdColor">未签到/未签退</td>
							<td style="width: 10%; font-size: 12px; height: 35px;"
								class="tdColor">迟到</td>
							<td style="width: 10%; font-size: 12px; height: 35px;"
								class="tdColor">可调休加班</td>
							<td style="width: 10%; font-size: 12px; height: 35px;"
								class="tdColor">请假</td>
							<td style="width: 10%; font-size: 12px; height: 35px;"
								class="tdColor">法定节日加班</td>
							<td style="width: 10%; font-size: 12px; height: 35px;"
								class="tdColor">累计剩余调休</td>
							<td style="width: 10%; font-size: 12px; height: 35px;"
								class="tdColor">累计剩余年假</td>
						</tr>
					</table>
					<table id="tb" border="1" style="width: 100%">
					</table>
				</div>
				<!-- vip 表格 显示 end-->
			</div>
			<!-- vip页面样式end -->
		</div>

	</div>

</body>
</html>