<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>公司打卡记录</title>
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
	
	$(document)
			.ready(
					function() {
						var da = new Date();
						da.setTime(da.getTime() - 24 * 60 * 60 * 1000);
						var y = da.getFullYear()
						var m = da.getMonth() < 10 ? ("0" + (da.getMonth() + 1))
								: (da.getMonth() + 1);
						var d = da.getDate() < 10 ? ("0" + da.getDate()) : da
								.getDate();
						var yesterday = y + "/" + m + "/" + d;
						$('#date').val(yesterday);
						getCardList(0);
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
												var m1 = date.getMonth() < 10 ? ("0" + (date
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


	function getCardList(dept) {
		$.ajax({
			url : "${pageContext.request.contextPath}/cardList",
			type : 'GET',
			data : {"date" :  $('#date').val(),"department" : dept},
			cache : false,
			success : function(returndata) {
				var str = '';
				var data = eval("(" + returndata + ")").cardlist;
				for ( var i in data) {
				//	var flag = data[i].checkFlag=="1"?"进":"出";
					
					str += '<tr style="color: #000;width: 100%;">'
							+ '<td style="width:20%;"><a>' + data[i].date + '</a></td>' 
							+ '<td style="width:20%;"><a>' + data[i].userName + '</a></td>'
							+ '<td style="width:20%;"><a>' + data[i].checkFlag + '</a></td>' 
							+ '<td style="width:20%;"><a>' + data[i].checkTime + '</a></td>'
							+ '<td style="width:20%;"><a>' + data[i].address + '</a></td>'
							+ '</tr>';
}
				$("#tb").empty();
				$("#tb").append(str);
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
	}

	function queryList() {
		getCardList($('#departmentSel').val());
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
			<select id="departmentSel" style="width: 80px">
				<option value="0">所有部门</option>
				<option value="1">技术部</option>
				<option value="2">销售部</option>
				<option value="3">行政部</option>
				<option value="4">研发部</option>
			</select>
		</div>

		<div style="float: left; margin-left: 10px; width: 10%;">
			<input type="button" value="查询" onclick="queryList()" />
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
					<td style="width: 20%;">日期</td>
					<td style="width: 20%;">姓名</td>
					<td style="width: 20%">签到/签退</td>
					<td style="width: 20%">时间</td>
					<td style="width: 20%">地址</td>
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