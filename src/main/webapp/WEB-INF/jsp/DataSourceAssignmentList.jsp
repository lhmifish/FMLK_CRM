<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>数据库所有派工单</title>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.2.1.min.js"></script>
<script type="text/javascript">
	$(document)
			.ready(
					function() {
						$
								.ajax({
									url : "${pageContext.request.contextPath}/dataSourceAssignmentList",
									type : 'GET',
									data : {},
									cache : false,
									success : function(returndata) {
										var str = '';
										var data = eval("(" + returndata + ")").assignlist;
										for ( var i in data) {
											str += '<tr style="color: #000;width: 100%;">'
													+ '<td style="width:6%;"><a>'
													+ data[i].projectId
													+ '</a></td>'
													+ '<td style="width:4.5%;"><a>'
													+ data[i].name
													+ '</a></td>'
													+ '<td style="width:15%;"><a>'
													+ data[i].clientCompany
													+ '</a></td>'
													+ '<td style="width:4.5%;"><a>'
													+ data[i].clientContact
													+ '</a></td>'
													+ '<td style="width:10%;"><a>'
													+ data[i].projectName
													+ '</a></td>'
													+ '<td style="width:25%;"><a>'
													+ data[i].serviceContent
													+ '</a></td>'
													+ '<td style="width:5%;"><a>'
													+ data[i].startDate
													+ '</a></td>'
													+ '<td style="width:5%;"><a>'
													+ data[i].endDate
													+ '</a></td>'
													+ '<td style="width:15%;"><a>'
													+ data[i].userList
													+ '</a></td>' + '</tr>';

										}
										$("#tb").empty();
										$("#tb").append(str);
									},
									error : function(XMLHttpRequest,
											textStatus, errorThrown) {
									}
								});
					});
</script>
</head>
<body>
	<form id="form1">
		<div id="div1"
			style="background-color: #39A4DA; padding: 5px; border-radius: 5px 5px 5px 5px; color: #fff; text-align: center; font-size: 12px">
			<table id="tb2"
				style="width: 100%; text-align: center; table-layout: fixed">
				<tr style="width: 100%;">
					<td style="width: 6%"><a>项目ID</a></td>
					<td style="width: 4.5%;"><a>项目经理</a></td>
					<td style="width: 15%;"><a>客户公司</a></td>
					<td style="width: 4.5%"><a>客户联系人</a></td>
					<td style="width: 10%"><a>项目名称</a></td>
					<td style="width: 25%"><a>项目服务内容</a></td>
					<td style="width: 5%"><a>开始时间</a></td>
					<td style="width: 5%"><a>结束时间</a></td>
					<td style="width: 15%"><a>参与人员</a></td>

				</tr>
			</table>
			<table
				style="width: 100%; background: #fff; border-collapse: collapse; border-spacing: 0; margin: 0; padding: 0; text-align: center; table-layout: fixed"
				id="tb" border="1">
			</table>
		</div>
	</form>

</body>
</html>