<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>上传每日excel/月统计</title>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.2.1.min.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery.jqprint-0.3.js"></script>
<script src="http://www.jq22.com/jquery/jquery-migrate-1.2.1.min.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jszip.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/FileSaver.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/excel-gen.js"></script>

<script type="text/javascript">
	$(document).ready(function() {
		getDate();
		queryMonthReportList(0);
	});

	function queryList() {
		queryMonthReportList($('#departmentSel').val());
	}

	function queryMonthReportList(dept) {
		var tDate = $('#year').val() + "/" + $('#month').val();
		$
				.ajax({
					url : "${pageContext.request.contextPath}/monthList",
					type : 'GET',
					data : {
						"date" : tDate,
						"department" : dept
					},
					cache : false,
					success : function(returndata) {
						var str = '';
						var scheduleStr;
						var scheduleAll = 0;
						var dailyReportStr;
						var dailyReportAll = 0;
						var weekReportStr;
						var weekReportAll = 0;
						var nextWeekPlanStr;
						var nextWeekPlanAll = 0;
						var crmUploadStr;
						var crmUploadAll = 0;
						var projectReportStr;
						var projectReportAll = 0;
						var noSignInStr;
						var noSignInAll = 0;
						var noSignOutStr;
						var noSignOutAll = 0;
						var lateTimeStr;
						var lateTimeAll = 0;
						var overWorkTimeStr;
						var overWorkTimeAll = 0.0;
						var overWorkTimeStr4H;
						var overWorkTimeAll4H = 0.0;
						var adjustRestTimeStr;
						var adjustRestTimeAll = 0.0;
						var vacationOverWorkTimeStr;
						var vacationOverWorkTimeAll = 0.0;
						var festivalOverWorkTimeStr;
						var festivalOverWorkTimeAll = 0.0;
						var nameStr;
						var deductStr;
						var deductAll = 0;
						var thisMonthTotalStr;
						var thisMonthTotalAll = 0.0;

						var data = eval("(" + returndata + ")").monthlist;
						for ( var i in data) {
							var schedule = data[i].scheduleT;
							if (schedule != "0") {
								scheduleStr = '<td style="width:5%;color:red;background:yellow"><a>'
										+ schedule + '</a></td>'
								scheduleAll += parseInt(schedule);
							} else {
								scheduleStr = '<td style="width:5%"><a>'
										+ schedule + '</a></td>'
							}

							var dailyReport = data[i].dailyReportT;
							if (dailyReport != "0") {
								dailyReportStr = '<td style="width:5%;color:red;background:yellow"><a>'
										+ dailyReport + '</a></td>'
								dailyReportAll += parseInt(dailyReport);
							} else {
								dailyReportStr = '<td style="width:5%"><a>'
										+ dailyReport + '</a></td>'
							}

							var weekReport = data[i].weekReportT;
							if (weekReport != "0") {
								weekReportStr = '<td style="width:5%;color:red;background:yellow"><a>'
										+ weekReport + '</a></td>'
								weekReportAll += parseInt(weekReport);
							} else {
								weekReportStr = '<td style="width:5%"><a>'
										+ weekReport + '</a></td>'
							}

							var projectReport = data[i].projectReportT;
							if (projectReport != "0") {
								projectReportStr = '<td style="width:6%;color:red;background:yellow"><a>'
										+ projectReport + '</a></td>'
								projectReportAll += parseInt(projectReport);
							} else {
								projectReportStr = '<td style="width:6%"><a>'
										+ projectReport + '</a></td>'
							}

							var noSignIn = data[i].noSignIn;
							if (noSignIn != "0") {
								noSignInStr = '<td style="width:6%;color:red;background:yellow"><a>'
										+ noSignIn + '</a></td>'
								noSignInAll += parseInt(noSignIn);
							} else {
								noSignInStr = '<td style="width:6%"><a>'
										+ noSignIn + '</a></td>'
							}

							var noSignOut = data[i].noSignOut;
							if (noSignOut != "0") {
								noSignOutStr = '<td style="width:6%;color:red;background:yellow"><a>'
										+ noSignOut + '</a></td>'
								noSignOutAll += parseInt(noSignOut);
							} else {
								noSignOutStr = '<td style="width:6%"><a>'
										+ noSignOut + '</a></td>'
							}

							var nextWeekPlan = data[i].nextWeekPlanT;
							if (nextWeekPlan != "0") {
								nextWeekPlanStr = '<td style="width:6%;color:red;background:yellow"><a>'
										+ nextWeekPlan + '</a></td>'
								nextWeekPlanAll += parseInt(nextWeekPlan);
							} else {
								nextWeekPlanStr = '<td style="width:6%"><a>'
										+ nextWeekPlan + '</a></td>'
							}

							var crmUpload = data[i].crmUploadT;
							if (crmUpload != "0") {
								crmUploadStr = '<td style="width:6%;color:red;background:yellow"><a>'
										+ crmUpload + '</a></td>'
								crmUploadAll += parseInt(crmUpload);
							} else {
								crmUploadStr = '<td style="width:6%"><a>'
										+ crmUpload + '</a></td>'
							}
							//2018/03/20
							var lateTime = data[i].isLate;
							if (lateTime != "0") {
								lateTimeStr = '<td style="width:6%;color:blue;background:pink"><a>'
										+ lateTime + '</a></td>'
								lateTimeAll += parseInt(lateTime);
							} else {
								lateTimeStr = '<td style="width:6%"><a>0</a></td>'
							}

							var deductAll2 = (parseInt(schedule)
									+ parseInt(dailyReport)
									+ parseInt(weekReport)
									+ parseInt(nextWeekPlan)
									+ parseInt(crmUpload) + parseInt(projectReport))
									* 50
									+ (parseInt(noSignIn) + parseInt(noSignOut))
									* 200 + parseInt(lateTime) * 30;
							if (deductAll2 != 0) {
								deductStr = '<td style="width:6%;color:red;background:yellow"><a>'
										+ deductAll2 + '</a></td>'
								deductAll += parseInt(deductAll2);
							} else {
								deductStr = '<td style="width:6%"><a>0</a></td>'
							}

							var tName = data[i].name;
							var deptId = getUserDept(tName);
							if (deptId == 1) {
								nameStr = '<td style="width:6%;color:white;background:green"><a>'
										+ tName + '</a></td>'
							} else if (deptId == 2) {
								nameStr = '<td style="width:6%;color:white;background:brown"><a>'
										+ tName + '</a></td>'
							} else if (deptId == 3) {
								nameStr = '<td style="width:6%;color:white;background:blue"><a>'
										+ tName + '</a></td>'
							} else if (deptId == 4) {
								nameStr = '<td style="width:6%;color:white;background:black"><a>'
										+ tName + '</a></td>'
							}
							////
							var ThisMonthTotalVal = getThisMonthTotal(
									data[i].name, tDate)[0];
							if(ThisMonthTotalVal<0){
								ThisMonthTotalVal = 0.0;
							}
							thisMonthTotalStr = '<td style="width:6%;color:white;background:orange"><a>'
								+ ThisMonthTotalVal + '</a></td>'
							thisMonthTotalAll += parseFloat(ThisMonthTotalVal);
							
							str += '<tr style="color: #000;width: 100%;">'
								+ nameStr + scheduleStr + dailyReportStr
								+ weekReportStr + nextWeekPlanStr
								+ crmUploadStr + projectReportStr
								+ noSignInStr + noSignOutStr + deductStr
								+ lateTimeStr + '</tr>';
						}

						str += '<tr style="color: #000;width: 100%;">'
								+ '<td style="width:6%;"><a>总数</a></td>'
								+ '<td style="width:5%;color:red;background:yellow"><a>'
								+ scheduleAll
								+ '</a></td>'
								+ '<td style="width:5%;color:red;background:yellow"><a>'
								+ dailyReportAll
								+ '</a></td>'
								+ '<td style="width:5%;color:red;background:yellow"><a>'
								+ weekReportAll
								+ '</a></td>'
								+ '<td style="width:6%;color:red;background:yellow"><a>'
								+ nextWeekPlanAll
								+ '</a></td>'
								+ '<td style="width:6%;color:red;background:yellow"><a>'
								+ crmUploadAll
								+ '</a></td>'
								+ '<td style="width:6%;color:red;background:yellow"><a>'
								+ projectReportAll
								+ '</a></td>'
								+ '<td style="width:6%;color:red;background:yellow"><a>'
								+ noSignInAll
								+ '</a></td>'
								+ '<td style="width:6%;color:red;background:yellow"><a>'
								+ noSignOutAll
								+ '</a></td>'
								+ '<td style="width:6%;color:red;background:yellow"><a>'
								+ deductAll
								+ '</a></td>'
								+ '<td style="width:6%;color:blue;background:pink"><a>'
								+ lateTimeAll
								+ '</a></td>'
								/* + '<td style="width:6%;color:blue;background:pink"><a>'
								+ overWorkTimeAll
								+ '</a></td>'
								+ '<td style="width:6%;color:blue;background:pink"><a>'
								+ overWorkTimeAll4H
								+ '</a></td>'
								+ '<td style="width:6%;color:blue;background:pink"><a>'
								+ adjustRestTimeAll
								+ '</a></td>'
								+ '<td style="width:6%;color:blue;background:pink"><a>'
								+ vacationOverWorkTimeAll
								+ '</a></td>'
								+ '<td style="width:6%;color:blue;background:pink"><a>'
								+ festivalOverWorkTimeAll
								+ '</a></td>'
								+ '<td style="width:6%;color:white;background:orange"><a>'
								+ thisMonthTotalAll + '</a></td>' */
								+'</tr>';
						$("#tb").empty();
						$("#tb").append(str);
					},
					error : function(XMLHttpRequest, textStatus, errorThrown) {
					}
				});
	}

	function getThisMonthTotal(_name, _date) {
		var arrayThisMonthTotal = new Array();
		$.ajax({
			url : "${pageContext.request.contextPath}/getThisMonthTotal",
			type : 'GET',
			async : false,
			data : {
				"date" : _date,
				"name" : _name
			},
			cache : false,
			success : function(returndata) {
				arrayThisMonthTotal
						.push(eval("(" + returndata + ")").thisMonthTotal);

			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});

		return arrayThisMonthTotal;
	}

	function addDailyReport() {

		var emptyFile;
		try {
			emptyFile = new File([ "" ], "filename");
		} catch (exception) {
			try {
				emptyFile = new Blob([ "" ], "filename");
			} catch (exception) {
				alert("unable to create empty file");
				return;
			}
		}
		var myFile = document.getElementById("myfile").files[0];
		var formData = new FormData();
		formData.append('myFile', myFile ? myFile : emptyFile);

		$.ajax({
			url : "${pageContext.request.contextPath}/addDailyReport",
			type : 'POST',
			cache : false,
			processData : false,
			contentType : false,
			data : formData,
			success : function(returndata) {
				alert(returndata);
				
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});

	}

	function getDate() {
		var date = new Date();
		var y = date.getFullYear()
		var m = date.getMonth() + 1;
		$('#year').find("option[value=" + y + "]").attr("selected", true);
		$('#month').find("option[value=" + m + "]").attr("selected", true);
	}

	function printTable() {
		$("#div1").jqprint();
	}

	function getUserDept(userName) {
		var depId;
		$.ajax({
			url : "${pageContext.request.contextPath}/getUserByUserName",
			type : 'GET',
			data : {
				"userName" : userName
			},
			cache : false,
			async : false,
			success : function(returndata) {
				depId = eval("(" + returndata + ")").user[0].departmentId;
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
		return depId;
	}

	function outputExcelTable() {
		var tr1 = $("#tb2 tr:eq(0)");
		tr1.appendTo("#outTb");
		for (var i = 0; i < document.getElementById("tb").rows.length; i++) {
			var tr2 = $("#tb tr").eq(i).clone();
			tr2.appendTo("#outTb");
		}
		new ExcelGen({
			"src_id" : "outTb"
		}).generate();
	}
</script>
</head>
<body>
	<form action="#">
		<div
			style="width: 100%; top: 0; left: 0; right: 0; height: auto; border: #D4DFE5 2px solid;">

			<table width="100%" height="auto" border="0">
				<tr>
					<td style="height: 20px; width: 100px">上传Excel</td>
					<td style="height: 30px; width: 200px"><input type="file"
						name="myfile" id="myfile" style="width: 200px"
						accept="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet, application/vnd.ms-excel" />
					</td>
					<td style="height: 30px; width: auto"><input type="button"
						id="btnSubmit" value="上传" onclick="addDailyReport()" /></td>
				</tr>
			</table>
			<table width="100%" height="auto" border="0">
				<tr>
					<td style="height: 20px; width: 100px">月统计</td>
					<td style="height: 30px; width: 100px"><select
						id="departmentSel" style="width: 100px">
							<option value="0">所有部门</option>
							<option value="1">技术部</option>
							<option value="2">销售部</option>
							<option value="3">行政部</option>
							<option value="4">研发部</option>
					</select></td>
					<td style="height: 30px; width: 100px"><select id="year"
						style="width: 100px">
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
					</select></td>

					<td style="height: 30px; width: 100px"><select id="month"
						style="width: 100px">
							<option value="1">1月</option>
							<option value="2">2月</option>
							<option value="3">3月</option>
							<option value="4">4月</option>
							<option value="5">5月</option>
							<option value="6">6月</option>
							<option value="7">7月</option>
							<option value="8">8月</option>
							<option value="9">9月</option>
							<option value="10">10月</option>
							<option value="11">11月</option>
							<option value="12">12月</option>
					</select></td>
					<td style="height: 30px; width: auto"><input type="button"
						value="查询" onclick="queryList()" /></td>

					<td style="height: 30px; float: right; margin-right: 20px;"><input
						type="button" value="导出excel表格" onclick="outputExcelTable()" /></td>
					<td
						style="height: 30px; width: auto; float: right; margin-right: 20px;"><input
						type="button" value="打印" onclick="printTable()" /></td>
				</tr>

			</table>

			<div id="div1">
				<table id="tb2"
					style="width: 100%; text-align: center; height: auto; table-layout: fixed"
					border="1">
					<tr style="width: 100%;">
						<td style="width: 6%;">姓名</td>
						<td style="width: 5%">日程</td>
						<td style="width: 5%">日报</td>
						<td style="width: 5%">周报</td>
						<td style="width: 6%">下周计划</td>
						<td style="width: 6%">crm上传</td>
						<td style="width: 6%">项目报告</td>
						<td style="width: 6%">未签到</td>
						<td style="width: 6%">未签退</td>
						<td style="width: 6%">扣款总额</td>
						<td style="width: 6%">迟到</td>
						<!-- <td style="width: 6%">加班</td>
						<td style="width: 6%">加班>4H</td>
						<td style="width: 6%">请假</td>
						<td style="width: 6%">放假加班</td>
						<td style="width: 6%">国定加班</td>
						<td style="width: 6%">累计加班</td> -->
					</tr>
				</table>
				<table
					style="width: 100%; background: #fff; border-collapse: collapse; border-spacing: 0; margin: 0; padding: 0; text-align: center; table-layout: fixed"
					id="tb" border="1">
				</table>
				<table id="outTb" style="display: none"></table>
			</div>
		</div>
	</form>
</body>
</html>