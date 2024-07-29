<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>日程表</title>
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/calendar.css" />
<link href='http://fonts.googleapis.com/css?family=Roboto'
	rel='stylesheet' type='text/css'>
<style type="text/css">
a {
	text-decoration: none;
}

ul, ol, li {
	list-style: none;
	padding: 0;
	margin: 0;
}

#demo {
	width: 300px;
	margin: 150px auto;
}

p {
	margin: 0;
}

#dt {
	margin: 30px auto;
	height: 28px;
	padding: 0 6px;
	border: 1px solid #ccc;
	outline: none;
}
</style>

<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.2.1.min.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/calendar.js"></script>
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
	var mName;
	var mDate;
	var mDate2;

	$(document)
			.ready(
					function() {
						var da = new Date();
						da.setTime(da.getTime() - 24 * 60 * 60 * 1000);
						var y = da.getFullYear()
						var m = da.getMonth() < 9 ? ("0" + (da.getMonth() + 1))
								: (da.getMonth() + 1);
						var d = da.getDate() < 10 ? ("0" + da.getDate()) : da
								.getDate();
						var yesterday = y + "/" + m + "/" + d;
						$('#date').val(yesterday);
						getDate();

						getUserList(0);
						getReportList();
						$('#dd')
								.calendar(
										{
											trigger : '#date',
											zIndex : 999,
											format : 'yyyy/mm/dd',
											onSelected : function(view, date,
													data) {
											},
											onClose : function(view, date, data) {
												var y1 = date.getFullYear();
												var m1 = date.getMonth() < 9 ? ("0" + (date
														.getMonth() + 1))
														: (date.getMonth() + 1);
												var d1 = date.getDate() < 10 ? ("0" + date
														.getDate())
														: date.getDate();
												$('#date').val(
														y1 + "/" + m1 + "/"
																+ d1);
											}
										});

					});

	function selDate() {
		getUserList($("#departmentSel").val());
	}

	function selDpart() {
		getUserList($("#departmentSel").val());
	}

	function getReportList() {
		if ($("#x1").css("display") == 'none') {
			mName = $('#name').val();
			mDate2 = $('#year').val() + "/" + $('#month').val();
			mDate = "";
		} else if ($("#x2").css("display") == 'none') {
			mName = "";
			mDate2 = "";
			mDate = $('#date').val();
		}

		$
				.ajax({
					url : "${pageContext.request.contextPath}/dailyList",
					type : 'GET',
					data : {
						"name" : mName,
						"date" : mDate,
						"date2" : mDate2
					},
					cache : false,
					success : function(returndata) {
						var str = '';
						var str1;
						var str2;
						var str3;
						var str4;
						var str5;
						var str6;
						var str7;
						var str8;
						var str9;
						var str10;
						var str11;
						var str12;

						var data = eval("(" + returndata + ")").dailylist;
						for ( var i in data) {
							var scheduleState = data[i].scheduleState;
							if (scheduleState != "正常") {
								str1 = '<td style="width:6%;color:red"><a>'
										+ scheduleState + '</a></td>'
							} else {
								str1 = '<td style="width:6%"><a>'
										+ scheduleState + '</a></td>'
							}
							var dailyReport = data[i].dailyReport;
							if (dailyReport == "未发") {
								str2 = '<td style="width:4%;color:red"><a>'
										+ dailyReport + '</a></td>'
							} else {
								str2 = '<td style="width:4%"><a>' + dailyReport
										+ '</a></td>'
							}

							var weekReport = data[i].weekReport;
							if (weekReport == "未发") {
								str3 = '<td style="width:4%;color:red"><a>'
										+ weekReport + '</a></td>'
							} else {
								str3 = '<td style="width:4%"><a>' + weekReport
										+ '</a></td>'
							}

							var nextWeekPlan = data[i].nextWeekPlan;
							if (nextWeekPlan == "未发") {
								str4 = '<td style="width:4%;color:red"><a>'
										+ nextWeekPlan + '</a></td>'
							} else {
								str4 = '<td style="width:4%"><a>'
										+ nextWeekPlan + '</a></td>'
							}

							var crmUpload = data[i].crmUpload;
							if (new RegExp('未上传').test(crmUpload)) {
								str5 = '<td style="width:4%;color:red"><a>'
										+ crmUpload + '</a></td>'
							} else {
								str5 = '<td style="width:4%"><a>' + crmUpload
										+ '</a></td>'
							}

							var projectReport = data[i].projectReport;
							if (projectReport == "未发") {
								str6 = '<td style="width:4%;color:red"><a>'
										+ projectReport + '</a></td>'
							} else {
								str6 = '<td style="width:4%"><a>'
										+ projectReport + '</a></td>'
							}

							var sign = data[i].sign;
							if (new RegExp('未签到').test(sign)
									|| new RegExp('未签退').test(sign)) {
								str7 = '<td style="width:20%;color:red;word-wrap:break-word;"><a>'
										+ sign + '</a></td>'
							} else {
								str7 = '<td style="width:20%;word-wrap:break-word;"><a>'
										+ sign + '</a></td>'
							}

							var overWorkTime = data[i].overWorkTime;
							if (overWorkTime != 0) {
								str8 = '<td style="width:4%;"><a>'
										+ overWorkTime + '</a></td>'
							} else {
								str8 = '<td style="width:4%"><a></a></td>'
							}

							var adjustRestTime = data[i].adjustRestTime;
							if (adjustRestTime != 0) {
								str9 = '<td style="width:4%;"><a>'
										+ adjustRestTime + '</a></td>'
							} else {
								str9 = '<td style="width:4%"><a></a></td>'
							}

							var vacationOverWorkTime = data[i].vacationOverWorkTime;
							if (vacationOverWorkTime != 0) {
								str10 = '<td style="width:6%;"><a>'
										+ vacationOverWorkTime + '</a></td>'
							} else {
								str10 = '<td style="width:6%"><a></a></td>'
							}

							var festivalOverWorkTime = data[i].festivalOverWorkTime;
							if (festivalOverWorkTime != 0) {
								str11 = '<td style="width:6%;"><a>'
										+ festivalOverWorkTime + '</a></td>'
							} else {
								str11 = '<td style="width:6%"><a></a></td>'
							}

							var isLate = data[i].isLate;
							if (isLate == 1) {
								str12 = '<td style="width:4%;color:red"><a>迟到</a></td>'
							} else {
								str12 = '<td style="width:4%"><a></a></td>'
							}

							str += '<tr style="color: #000;width: 100%;">'
									+ '<td style="width:6%;word-wrap:break-word;"><a>'
									+ data[i].date
									+ '</a></td>'
									+ '<td style="width:4%;"><a>'
									+ data[i].name
									+ '</a></td>'
									+ '<td style="width:10%;word-wrap:break-word;"><a>'
									+ data[i].schedule
									+ '</a></td>'
									+ str1
									+ str2
									+ str3
									+ str4
									+ str5
									+ str6
									+ str7
									+ '<td style="width:10%;word-wrap:break-word;"><a>'
									+ data[i].remark
									+ '</a></td>'
									+ str8
									+ str9 + str10 + str11 + str12 + '</tr>';

						}
						$("#tb").empty();
						$("#tb").append(str);
					},
					error : function(XMLHttpRequest, textStatus, errorThrown) {
					}
				});
	}

	function getUserList(dpartId) {
		$.ajax({
			url : "${pageContext.request.contextPath}/userList",
			type : 'GET',
			data : {
				"dpartId" : dpartId,
				"date" : $('#year').val() + "/" + $('#month').val() + "/1",
				"name" : "",
				"nickName" : "",
				"jobId" : "",
				"isHide":true
			},
			cache : false,
			success : function(returndata) {
				var str = '';
				var data2 = eval("(" + returndata + ")").userlist;
				for ( var i in data2) {
					str += '<option value="'+data2[i].name+'">' + data2[i].name
							+ '</option>';
				}
				$("#name").empty();
				$("#name").append(str);

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

	function test(Names) {
		for (var i = 1; i < 4; i++) {
			var tempname = "menu_x" + i
			var NewsHot = "x" + i
			if (Names == tempname) {
				document.getElementById(NewsHot).style.display = 'block';
			} else {
				document.getElementById(NewsHot).style.display = 'none';
			}
		}
	}

	function queryReportList() {
		getReportList();
	}

	function printTable() {
		$("#div1").jqprint();
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
		// window.location.reload();
		getReportList();
	}
</script>
</head>
<body>

	<div style="width: 100%; height: 30px">

		<div style="float: left;">
			<select id="queryType" name="D1"
				style="width: 120px; margin-left: 20px;"
				onChange="javascript:test('menu_x'+this.value)">
				<option value="1">日期</option>
				<option value="2">人员</option>
			</select>
		</div>

		<div style="float: left; margin-left: 10px;" id="x1">
			<input type="text" id="date" style="width: 120px;">
			<div id="dd"></div>
		</div>

		<div style="float: left; margin-left: 10px; display: none" id="x2">
			<select id="departmentSel" onchange="selDpart()" style="width: 80px">
				<option value="0">所有部门</option>
				<option value="1">技术部</option>
				<option value="2">销售部</option>
				<option value="3">行政部</option>
				<option value="4">研发部</option>
			</select> <select id="name" style="width: 80px"></select> <select id="year"
				style="width: 80px" onchange="selDate()">
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
			</select> <select id="month" style="width: 80px" onchange="selDate()">
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
			</select>
		</div>

		<div style="float: left; margin-left: 10px; width: 10%;">
			<input type="button" value="查询" onclick="queryReportList()" />
		</div>

		<div style="float: right; margin-right: 20px;">
			<input type="button" value="导出excel表格" onclick="outputExcelTable()" />
		</div>

		<div style="float: right; margin-right: 20px;">
			<input type="button" value="打印" onclick="printTable()" />
		</div>
	</div>



	<form id="form1">
		<div id="div1"
			style="background-color: #39A4DA; padding: 5px; border-radius: 5px 5px 5px 5px; color: #fff; text-align: center; font-size: 12px">

			<table id="tb2"
				style="width: 100%; text-align: center; table-layout: fixed">
				<tr style="width: 100%;" id="tr1">
					<td style="width: 6%;"><a>日期</a></td>
					<td style="width: 4%;"><a>姓名</a></td>
					<td style="width: 10%"><a>日程</a></td>
					<td style="width: 6%"><a>日程发送时间</a></td>
					<td style="width: 4%"><a>日报</a></td>
					<td style="width: 4%"><a>周报</a></td>
					<td style="width: 4%"><a>下周计划</a></td>
					<td style="width: 4%"><a>crm上传</a></td>
					<td style="width: 4%"><a>项目计划</a></td>
					<td style="width: 20%"><a>签到/签退</a></td>
					<td style="width: 10%"><a>备注/日程调整</a></td>
					<td style="width: 4%"><a>加班</a></td>
					<td style="width: 4%"><a>请假</a></td>
					<td style="width: 6%"><a>放假期间加班</a></td>
					<td style="width: 6%"><a>国定假日加班</a></td>
					<td style="width: 4%"><a>迟到</a></td>
				</tr>
			</table>
			<table
				style="width: 100%; background: #fff; border-collapse: collapse; border-spacing: 0; margin: 0; padding: 0; text-align: center; table-layout: fixed"
				id="tb" border="1">
			</table>
			<table id="outTb" style="display: none"></table>
		</div>
	</form>
</body>
</html>