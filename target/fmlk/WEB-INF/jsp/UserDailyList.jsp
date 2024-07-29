<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="renderer" content="webkit">
<title>个人日程表</title>
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
<script type="text/javascript">
	var mName;
	var mDate2;

	$(document).ready(function() {
		getDate();
		getReportList();
	});

	function getReportList() {
		mName = "${mUser}";
		mDate2 = $('#year option:selected').val() + "/" + $('#month option:selected').val();
		$.ajax({
			url : "${pageContext.request.contextPath}/userDailyList",
			type : 'GET',
			data : {"name" : mName,"date2" : mDate2},
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
				var data = eval("(" + returndata + ")").dailylist;
				for ( var i in data) {
					var scheduleState = data[i].scheduleState;
					if (scheduleState != "正常") {
						str1 = '<td style="width:5%;color:red"><a>'
								+ scheduleState + '</a></td>'
					} else {
						str1 = '<td style="width:5%"><a>' + scheduleState
								+ '</a></td>'
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
						str6 = '<td style="width:4%;color:red"><a>'
								+ weekReport + '</a></td>'
					} else {
						str6 = '<td style="width:4%"><a>' + weekReport
								+ '</a></td>'
					}

					var projectReport = data[i].projectReport;
					if (projectReport == "未发") {
						str7 = '<td style="width:4%;color:red"><a>'
								+ projectReport + '</a></td>'
					} else {
						str7 = '<td style="width:4%"><a>' + projectReport
								+ '</a></td>'
					}

					var sign = data[i].sign;
					if (new RegExp('未签到').test(sign)
							|| new RegExp('未签退').test(sign)) {
						str3 = '<td style="width:26%;color:red"><a>' + sign
								+ '</a></td>'
					} else {
						str3 = '<td style="width:26%"><a>' + sign + '</a></td>'
					}

					var nextWeekPlan = data[i].nextWeekPlan;
					if (nextWeekPlan == "未发") {
						str4 = '<td style="width:4%;color:red"><a>'
								+ nextWeekPlan + '</a></td>'
					} else {
						str4 = '<td style="width:4%"><a>' + nextWeekPlan
								+ '</a></td>'
					}

					var crmUpload = data[i].crmUpload;
					if (new RegExp('未上传').test(crmUpload)) {
						str5 = '<td style="width:4%;color:red"><a>' + crmUpload
								+ '</a></td>'
					} else {
						str5 = '<td style="width:4%"><a>' + crmUpload
								+ '</a></td>'
					}

					str += '<tr style="color: #000;width: 100%;">'
							+ '<td style="width:6%;"><a>' + data[i].date
							+ '</a></td>' + '<td style="width:4%;"><a>'
							+ data[i].name + '</a></td>'
							+ '<td style="width:15%"><a>' + data[i].schedule
							+ '</a></td>' + str1 + str2 + str6 + str4 + str5
							+ str7 + '<td style="width:4%"><a>'
							+ data[i].others + '</a></td>' + str3
							+ '<td style="width:10%"><a>' + data[i].remark
							+ '</a></td></tr>';

				}
				$("#tb").empty();
				$("#tb").append(str);
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

	function queryReportList() {
		getReportList();
	}

	function printTable() {
		$("#div1").jqprint();
	}
</script>
</head>
<body>

	<div style="width: 100%; height: 30px">

		<div style="float: left; margin-left: 10px" id="x2">
			<select id="year">
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
			</select> 
			
			<select id="month">
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
			<input type="button" value="打印" onclick="printTable()" />
		</div>
	</div>



	<form id="form1">
		<div id="div1"
			style="background-color: #39A4DA; padding: 1px; border-radius: 5px 5px 5px 5px; margin-left: -2px; color: #fff; font-size: 12px">
			<table style="width: 100%; text-align: center;">
				<tr style="width: 100%;">
					<td style="width: 6%;">日期</td>
					<td style="width: 4%;">姓名</td>
					<td style="width: 15%">日程</td>
					<td style="width: 5%">日程发送时间</td>
					<td style="width: 4%">日报</td>
					<td style="width: 4%">周报</td>
					<td style="width: 4%">下周计划</td>
					<td style="width: 4%">crm上传</td>
					<td style="width: 4%">项目计划</td>
					<td style="width: 4%">其他</td>
					<td style="width: 26%">签到/签退</td>
					<td style="width: 10%">备注/日程调整</td>
				</tr>
			</table>
			<table
				style="width: 100%; background: #fff; border-collapse: collapse; border-spacing: 0; margin: 0; padding: 0; text-align: center;"
				id="tb" border="1">
			</table>
		</div>
	</form>
</body>
</html>