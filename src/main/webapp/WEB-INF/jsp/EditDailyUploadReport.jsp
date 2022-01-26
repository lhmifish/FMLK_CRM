<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
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
<title>日报</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/showbox.css" />
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/css.css?v=1990" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/select4.css?v=2000" />
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.2.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/jweixin-1.0.0.js"></script>
<script src="${pageContext.request.contextPath}/js/getObjectList.js"></script>
<script src="${pageContext.request.contextPath}/js/select3.js"></script>
<style>
.button-submit button {
	position: fixed;
	bottom: 0;
	z-index: 9999;
	width: 100%;
	max-width: 640px;
	height: 40px;
	background-color: #459BFE;
	color: #FFF;
	border: 0;
}
</style>

<script type="text/javascript">
	var id;
	var host;
	var sId;
	var mId;
	$(document).ready(function() {
		sId = "${mUserId}";//访问用户id
		host = "${pageContext.request.contextPath}";
		id = "${mId}";//日报id
		getTimeList();
		getData(id);
		$("#date").select2({
			minimumResultsForSearch : -1
		});
		$("#time1").select2({
			minimumResultsForSearch : -1
		});
		$("#time2").select2({
			minimumResultsForSearch : -1
		});
		$("#companyId").select2({});
		$("#projectId").select2({});
	});

	function getUser(tId) {
		var user;
		$.ajax({
			url : host + "/getUserByNickName",
			type : 'GET',
			data : {
				"nickName" : tId
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

	function getProject(mProjectId) {
		var project;
		$.ajax({
			url : host + "/getProjectByProjectId",
			type : 'GET',
			data : {
				"projectId" : mProjectId
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

	function getData(id) {
		$.ajax({
			url : host + "/getDailyUploadReport",
			type : 'GET',
			cache : false,
			data : {
				"id" : id
			},
			success : function(returndata) {
				var data = eval("(" + returndata + ")").dailyUploadReport;
				mId = data[0].userName;
				$(document).attr("title", getUser(mId).name + "的日报");
				$("#date").val(data[0].date);
				$("#companyId").val(data[0].client);
				$("#projectId").val(data[0].crmNum);
				$("#jobContent").val(data[0].jobContent);
				$("#time1").val(data[0].time.substring(0, 5));
				$("#time2").val(data[0].time.substring(6, 11));
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
	}

	function changeCompany(tCompanyId) {
		getProjectList(tCompanyId, 0);
	}

	function editDailyReport() {
		var date = $('#date').val();
		var time1 = $("#time1 option:selected").text();
		var time2 = $("#time2 option:selected").text();
		var companyId = $("#companyId").val();
		var projectId = $("#projectId").val();
		var jobContent = $("#jobContent").val();

		if (mId != sId) {
			alert("这不是你的日报，你不能编辑");
			return;
		}

		if (companyId == 0) {
			alert("请选择客户公司");
			return;
		}

		if (projectId == null) {
			alert("请选择项目");
			return;
		}

		if (jobContent.length == 0) {
			alert("工作内容不能为空");
			return;
		}

		$.ajax({
			url : host + "/editDailyUploadReport",
			type : 'POST',
			cache : false,
			data : {
				"id" : id,
				"userName" : mId,
				"date" : date,
				"client" : companyId,
				"crmNum" : projectId,
				"jobContent" : jobContent,
				"time" : time1 + "-" + time2
			},
			success : function(returndata) {
				var data = eval("(" + returndata + ")").errcode;
				if (data == 0) {
					alert("编辑成功");
					window.location.href = host
							+ "/page/allDailyUploadReportList";
				} else if (data == 3) {
					alert("请勿重复上传相同时间段的日报");
				} else {
					alert("编辑失败");
				}
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
	}
</script>
</head>


<body class="body-gray" style="margin: auto;">
	<div class="form">
		<div class="top" style="width: 100%">
			<p style="margin-left: 5%; margin-top: 10px;">
				<a style="color: red">* </a>日期
			</p>
			<div style="margin-left: 5%;">
				<input id="date" disabled="disabled"
					style="background-color: #eee; width: 90%;" />
			</div>

			<p style="margin-left: 5%; margin-top: 10px;">
				<a style="color: red">* </a>时间
			</p>
			<div style="margin-left: 5%;">
				<select id="time1" style="width: 42%;"></select> 至 <select
					id="time2" style="width: 42%; margin-left: 5px"></select>
			</div>

			<p style="margin-left: 5%; margin-top: 10px;">
				<a style="color: red">* </a>客户公司
			</p>
			<div style="margin-left: 5%;">
				<select id="companyId" style="width: 90%;"
					onChange="changeCompany(this.options[this.options.selectedIndex].value)">
				</select>
			</div>

			<p style="margin-left: 5%; margin-top: 10px;">
				<a style="color: red">* </a>项目名称
			</p>
			<div style="margin-left: 5%;">
				<select id="projectId" style="width: 90%;"></select>
			</div>
			<p style="margin-left: 5%; margin-top: 10px;">
				<a style="color: red">* </a>工作内容
			</p>
			<div style="margin-left: 8%; margin-top: 10px; font-size: 12px">
				<textarea placeholder="工作内容" id="jobContent"
					style="border: 0; width: 90%; background: none" rows="20"></textarea>
			</div>

		</div>
	</div>

	<div class="button-submit">
		<button type="button" onclick="editDailyReport();"
			class="btn btn-primary">编辑</button>
	</div>
</body>
</html>