<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>所有考勤记录</title>
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/calendar.css" />
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/xcConfirm.css" />
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

.sgBtn {
	width: 135px;
	height: 35px;
	line-height: 35px;
	margin-left: 10px;
	margin-top: 10px;
	text-align: center;
	background-color: #0095D9;
	color: #FFFFFF;
	float: left;
	border-radius: 5px;
}
</style>

<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.2.1.min.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/calendar.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/xcConfirm.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery.jqprint-0.3.js"></script>
<script src="http://www.jq22.com/jquery/jquery-migrate-1.2.1.min.js"></script>
<script type="text/javascript">
	var arrayRecord;
	var arrayName;

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
						getAllCheckList(0);
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
	
	function queryList(){
		getAllCheckList($('#departmentSel').val());
	}
	
	
	function getAllCheckList(dept) {
		arrayRecord = new Array();
		arrayName = new Array();
		$
				.ajax({
					url : "${pageContext.request.contextPath}/allCheckList",
					type : 'GET',
					data : {"date" : $('#date').val(),"department" : dept},
					cache : false,
					success : function(returndata) {
						//alert(returndata);
						var str = '';
						var link = '';
						var data = eval("(" + returndata + ")").wechatlist;
						for ( var i in data) {
							var details = data[i].detail.list;
							var startTime = data[i].startTime;
							var endTime = data[i].endTime;
							var str2 = "";
							var startAddress = "";
							var endAddress = "";
							var startStr = '<td style="width:20%;"><a></a></td>';
							var endStr = '<td style="width:20%;"><a></a></td>';
							
							for ( var j in details) {
								str2 += (details[j].checkTime + "&"
										+ details[j].address + "&"
										+ details[j].checkFlag + "/");
								if(startTime != "" || startTime != "未签到"){
									var subTime = startTime.substring(startTime.lastIndexOf('/')+1, startTime.length);
									if(details[j].checkTime==startTime.replace("次日",'').trim()){
										startAddress = details[j].address;
										startStr = '<td style="width:20%;"><a>'
										+ startTime + "/"+ startAddress + '</a></td>';
										
									}
								}
								if(endTime != "" || endTime != "未签退"){
                                    if(details[j].checkTime==endTime.replace("次日",'').trim()){
                                    	endAddress = details[j].address;
                                    	endStr = '<td style="width:20%;"><a>'
    										+ endTime + "/"+ endAddress + '</a></td>';
									}
								}
							}
							 
							if(startTime == "未签到"){
								startStr = '<td style="width:20%;color:red;background:yellow"><a>'
									+ startTime + '</a></td>';
							}
							if(endTime == "未签退"){
								endStr = '<td style="width:20%;color:red;background:yellow"><a>'
									+ endTime + '</a></td>';
							}
							
							arrayRecord.push(str2);
							arrayName.push(data[i].name);

							if (details.length != 0) {
								link = '<a href="javascript:void(0)" onclick="showList('
										+ i + ');return false;">详情</a>';
							} else {
								link = '<a></a>';
							}

							str += '<tr style="color: #000;width: 100%;">'
									+ '<td style="width:20%;"><a>'
									+ data[i].date + '</a></td>'
									+ '<td style="width:20%;"><a>'
									+ data[i].name + '</a></td>'
									+ startStr 
									+ endStr 
									+ '<td style="width:20%;">' + link
									+ '</td></tr>';
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

	function showList(a) {
		var txt = arrayRecord[a].substring(0, arrayRecord[a].length - 1);
		var txtNew = "";
		var txtArr = txt.split("/");

		var tab = '<table style="width: 100%;text-align: center;" border="1">'
				+ '<tr style="width: 100%;"><td style="width: 20%;">时间</td><td style="width: 65%;">地点</td>'
				+ '<td style="width: 15%;">类型</td></tr></table><table style="width: 100%;text-align: center;" border="1">';

		for (var k = 0; k < txtArr.length; k++) {
			txtNew += '<tr style="width: 100%;"><td style="width: 20%;"><a>'
					+ txtArr[k].split("&")[0]
					+ '</a></td><td style="width: 65%;"><a>'
					+ txtArr[k].split("&")[1]
					+ '</a></td><td style="width: 15%;"><a>'
					+ txtArr[k].split("&")[2] + '</tr>';
		}

		tab = tab + txtNew + '</table>';

		window.wxc.xcConfirm(tab, {
			title : arrayName[a] + "当天的考勤记录"
		});
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
					<td style="width: 20%">上班时间/地点</td>
					<td style="width: 20%">下班时间/地点</td>
					<td style="width: 20%">签到详情</td>
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