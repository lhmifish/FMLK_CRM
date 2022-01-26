<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="renderer" content="webkit" />
<meta http-equiv="X-UA-COMPATIBLE" content="IE=edge,chrome=1" />
<meta name="viewport"
	content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=no" />
<meta name="apple-mobile-web-app-capable" content="yes" />
<meta name="apple-mobile-web-app-status-bar-style" content="black" />
<meta name="format-detection" content="telephone=no" />
<meta http-equiv="pragma" content="no-cache" />
<meta http-equiv="cache-control" content="no-cache" />
<title></title>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.2.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/jweixin-1.0.0.js"></script>
<script src="${pageContext.request.contextPath}/js/select3.js"></script>
<script src="${pageContext.request.contextPath}/js/checkPermission.js"></script>
<script src="${pageContext.request.contextPath}/js/changePsd.js"></script>
<script src="${pageContext.request.contextPath}/js/commonUtils.js"></script>
<script src="${pageContext.request.contextPath}/js/getObjectList.js"></script>
<style>
}
tr {
	border: 1px solid #ccc;
}
</style>
<script type="text/javascript">
	var sId;
	var host;
	var year;
	var month;

	$(document).ready(function() {
		sId = "${sessionId}";
		host = "${pageContext.request.contextPath}";
		year = "${date}".split("/")[0];
		month = "${date}".split("/")[1];
		$(document).attr("title", year + "年" + month + "月派工报警汇总");
		getProjectCaseUnClosedList(2, year, month);
	});

	function getProject(mPrjectId) {
		var project;
		$.ajax({
			url : host + "/getProjectByProjectId",
			type : 'GET',
			data : {
				"projectId" : mPrjectId
			},
			cache : false,
			async : false,
			success : function(returndata) {
				project = eval("(" + returndata + ")").project[0];
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
		return project;
	}

	function getUser(uId) {
		var user;
		$.ajax({
			url : host + "/getUserById",
			type : 'GET',
			data : {
				"uId" : uId
			},
			cache : false,
			async : false,
			success : function(returndata) {
				user = eval("(" + returndata + ")").user[0];
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
		return user;
	}

	function getCompany(mCompanyId) {
		var company;
		$.ajax({
			url : host + "/getCompanyByCompanyId",
			type : 'GET',
			data : {
				"companyId" : mCompanyId
			},
			cache : false,
			async : false,
			success : function(returndata) {
				company = eval("(" + returndata + ")").company[0];
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
		return company;
	}

	function getProjectCaseUnClosedList(mCaseState, mYear, mMonth) {
		var str;
		var xhr = createxmlHttpRequest();
		xhr.open("GET", host + "/getProjectCaseUnClosedList?caseState="
				+ mCaseState + "&year=" + mYear + "&month=" + mMonth, true);
		xhr.onreadystatechange = function() {
			if (this.readyState == 4) {
				var data = eval("(" + xhr.responseText + ")").pclist;
				if (data.length == 0) {
					str = "<tr style='border:0'><td>Good Job,EveryOne！！！</td></tr>";
					str += "<tr><td><strong>上个月无派工超时报警,这个月请保持</strong></td></tr>";
				} else {
					str = "<tr><td><strong>上个月有" + data.length
							+ "个派工有超时报警,明细如下：</strong></td></tr>";
					str += "<tr><td>==============================</td></tr>";
					for ( var i in data) {
						str += "<tr><td><strong>项目名称：</strong>"
								+ getProject(data[i].projectId).projectName;
						+"</td></tr>";
						str += "<tr><td><strong>客户名称：</strong>"
								+ getCompany(getProject(data[i].projectId).companyId).companyName
								+ "</td></tr>";
						str += "<tr><td><strong>服务内容：</strong>"+data[i].serviceContent + "</td></tr>";
						if (sId == getUser(data[i].salesId).nickName) {
							str += "<tr><td style='color:red;'><strong>销售：</strong>"
									+ getUser(data[i].salesId).name
									+ "</td></tr>";
						} else {
							str += "<tr><td><strong>销售：</strong>"
									+ getUser(data[i].salesId).name
									+ "</td></tr>";
						}
						var isExist = false;
						var str2 = "";
						var mServiceUsers = new Array();
						mServiceUsers = data[i].serviceUsers.split(",");
						for ( var k in mServiceUsers) {
							if (getUser(mServiceUsers[k]).nickName == sId) {
								isExist = true;
							}
							str2 += getUser(mServiceUsers[k]).name + ",";
						}
						str2 = str2.substring(0, str2.length - 1);
						if (isExist) {
							str += "<tr><td style='color:red'><strong>服务工程师：</strong>" + str2
									+ "</td></tr>";
						} else {
							str += "<tr><td><strong>服务工程师：</strong>" + str2 + "</td></tr>";
						}
						str += '<tr><td><strong>报警次数：</strong>' + data[i].lateTimes
								+ '</td></tr>';
						str += '<tr><td><strong>报警开始日期：</strong>'
								+ getAlertDate(data[i].serviceDate,
										data[i].casePeriod) + '</td></tr>';
						str += "<tr><td>==============================</td></tr>";
					}
				}
				$("#tb").empty();
				$("#tb").append(str);
			}
		};
		xhr.send();
	}

	function getAlertDate(mServiceDate, mPeriod) {
		var serviceDate = new Date(mServiceDate);
		// 3天延迟 ，第4天报警
		var d = Number(serviceDate.getDate()) + Number(mPeriod) + Number(4);
		var newd = new Date(serviceDate.setDate(d));
		return newd.getFullYear() + "年" + (newd.getMonth() + 1) + "月"
				+ newd.getDate() + "日";
	}
</script>
</head>

<body>
	<div>
		<table id="tb" style="width: 100%;">
		</table>
	</div>

</body>


</html>