<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>事务统计图表</title>

<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.2.1.min.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jsapi.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/corechart.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery.gvChart-1.0.1.min.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery.ba-resize.min.js"></script>

<script type="text/javascript">
	gvChartInit();
	$(document).ready(function() {
		/* var h = document.documentElement.clientWidth;
		alert(h);
		document.getElementById('myTable5').style.width = h / 2 + "px"; */

		$('#myTable1').gvChart({
			chartType : 'AreaChart',
			gvSettings : {
				vAxis : {
					title : ''
				},
				hAxis : {
					title : ''
				}
			}
		});
		
		$('#myTable2').gvChart({
			chartType : 'LineChart',
			gvSettings : {
				vAxis : {
					title : ''
				},
				hAxis : {
					title : ''
				}
			}
		});

		$('#myTable3').gvChart({
			chartType : 'BarChart',
			gvSettings : {
				vAxis : {
					title : ''
				},
				hAxis : {
					title : ''
				}
			}
		});
		
		$('#myTable4').gvChart({
			chartType : 'PieChart',
			gvSettings : {
				vAxis : {
					title : ''
				},
				hAxis : {
					title : ''
				}
			}
		});

	});
</script>


</head>
<body style="width: 100%">
	<div style="margin: 0 auto;">
		<div style="float: left; width: 50%;">
			<table style="width: 50%;" id='myTable1'>
				<caption>事务类型占比</caption>
				<thead>
					<tr>
						<th></th>
						<th>未开始</th>
						<th>超时未完成</th>
						<th>处理中</th>
						<th>已完成(超时)</th>
						<th>已完成(正常)</th>

					</tr>
				</thead>
				<tbody>
					<tr>
						<th>1020</th>
						<td>540</td>
						<td>300</td>
						<td>150</td>
						<td>180</td>
						<td>120</td>
					</tr>
				</tbody>
			</table>
		</div>
		<div style="float: left; width: 50%;">
			<table style="width: 50%; float: right" id='myTable2'>
				<caption>事务类型占比</caption>
				<thead>
					<tr>
						<th></th>
						<th>未开始</th>
						<th>超时未完成</th>
						<th>处理中</th>
						<th>已完成(超时)</th>
						<th>已完成(正常)</th>

					</tr>
				</thead>
				<tbody>
					<tr>
						<th>1020</th>
						<td>540</td>
						<td>300</td>
						<td>150</td>
						<td>180</td>
						<td>120</td>
					</tr>
				</tbody>
			</table>
		</div>
		
		<div style="float: left; width: 50%;">
			<table style="width: 50%;" id='myTable3'>
				<caption>事务类型占比</caption>
				<thead>
					<tr>
						<th></th>
						<th>未开始</th>
						<th>超时未完成</th>
						<th>处理中</th>
						<th>已完成(超时)</th>
						<th>已完成(正常)</th>

					</tr>
				</thead>
				<tbody>
					<tr>
						<th>1020</th>
						<td>540</td>
						<td>300</td>
						<td>150</td>
						<td>180</td>
						<td>120</td>
					</tr>
				</tbody>
			</table>
		</div>
		<div style="float: left; width: 50%;">
			<table style="width: 50%; float: right" id='myTable4'>
				<caption>事务类型占比</caption>
				<thead>
					<tr>
						<th></th>
						<th>未开始</th>
						<th>超时未完成</th>
						<th>处理中</th>
						<th>已完成(超时)</th>
						<th>已完成(正常)</th>

					</tr>
				</thead>
				<tbody>
					<tr>
						<th>1020</th>
						<td>540</td>
						<td>300</td>
						<td>150</td>
						<td>180</td>
						<td>120</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
</body>
</html>