<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>周计划</title>
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
	$(document).ready(
			function() {
				var da = new Date();
				var DayOfWeek = (da.getDay() == 0) ? 7 : da.getDay();
				var startWeekStr = formatDate(new Date(da.getFullYear(), da
						.getMonth(), da.getDate() - DayOfWeek + 1));
				var endWeekStr = formatDate(new Date(da.getFullYear(), da
						.getMonth(), da.getDate() + (6 - DayOfWeek + 1)));
				$('#date').val(startWeekStr);
				$('#date2').val(endWeekStr);

				$('#dd').calendar(
						{
							trigger : '#date',
							zIndex : 999,
							format : 'yyyy/mm/dd',
							onSelected : function(view, date, data) {
							},
							onClose : function(view, date, data) {
								var DayOfWeek = (date.getDay() == 0) ? 7 : date
										.getDay();
								var startWeekStr = formatDate(new Date(date
										.getFullYear(), date.getMonth(), date
										.getDate()
										- DayOfWeek + 1));
								var endWeekStr = formatDate(new Date(date
										.getFullYear(), date.getMonth(), date
										.getDate()
										+ (6 - DayOfWeek + 1)));
								$('#date').val(startWeekStr);
								$('#date2').val(endWeekStr);
							}
						});

				$('#dd2').calendar(
						{
							trigger : '#date2',
							zIndex : 999,
							format : 'yyyy/mm/dd',
							onSelected : function(view, date, data) {
							},
							onClose : function(view, date, data) {
								var DayOfWeek = (date.getDay() == 0) ? 7 : date
										.getDay();
								var startWeekStr = formatDate(new Date(date
										.getFullYear(), date.getMonth(), date
										.getDate()
										- DayOfWeek + 1));
								var endWeekStr = formatDate(new Date(date
										.getFullYear(), date.getMonth(), date
										.getDate()
										+ (6 - DayOfWeek + 1)));
								$('#date').val(startWeekStr);
								$('#date2').val(endWeekStr);
							}
						});
				getReportList();
			});

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

	function getReportList() {
		var mStartDate = $('#date').val();
		var mEndDate = $('#date2').val();

		$.ajax({
			url : "${pageContext.request.contextPath}/weekPlanDetails",
			type : 'GET',
			data : {
				"startDate" : mStartDate,
				"endDate" : mEndDate
			},
			cache : false,
			success : function(returndata) {
			    var str = '';
				var data = eval("(" + returndata + ")").weekDetailsList;
				for ( var i in data) {
					str += '<tr style="color: #000;width: 100%;">'
							+ '<td style="width:5.5%;"><a>' + data[i].name + '</a></td>' 
							+ '<td style="width:13.5%;"><a>' + data[i].monSchedule + '</a></td>'
							+ '<td style="width:13.5%"><a>' + data[i].tuesSchedule + '</a></td>' 
							+ '<td style="width:13.5%"><a>' + data[i].wedSchedule + '</a></td>' 
							+ '<td style="width:13.5%"><a>' + data[i].thurSchedule + '</a></td>' 
							+ '<td style="width:13.5%"><a>' + data[i].friSchedule + '</a></td>' 
							+ '<td style="width:13.5%"><a>' + data[i].satSchedule + '</a></td>'
							+ '<td style="width:13.5%"><a>' + data[i].sunSchedule + '</a></td></tr>';

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

		<div style="float: left; margin-left: 10px;">
			<input type="text" id="date" style="width: 120px;">
			<div id="dd"></div>
		</div>

		<div style="float: left; margin-left: 10px;">
			<div>至</div>
		</div>

		<div style="float: left; margin-left: 10px;">
			<input type="text" id="date2" style="width: 120px;">
			<div id="dd2"></div>
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
			style="background-color: #39A4DA; padding: 5px; border-radius: 5px 5px 5px 5px; color: #fff; text-align: center; font-size: 12px">
			<table style="width: 100%; text-align: center;">
				<tr style="width: 100%;">
					<td style="width: 5.5%;"><a>姓名</a></td>
					<td style="width: 13.5%"><a>星期一</a></td>
					<td style="width: 13.5%"><a>星期二</a></td>
					<td style="width: 13.5%"><a>星期三</a></td>
					<td style="width: 13.5%"><a>星期四</a></td>
					<td style="width: 13.5%"><a>星期五</a></td>
					<td style="width: 13.5%"><a>星期六</a></td>
					<td style="width: 13.5%"><a>星期日</a></td>
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