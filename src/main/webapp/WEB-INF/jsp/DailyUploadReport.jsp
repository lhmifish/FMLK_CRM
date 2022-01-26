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
	var sId;
	var host;

	$(document).ready(function() {
		sId = "${mUserId}";
		host = "${pageContext.request.contextPath}";
		$(document).attr("title", getUser().name + "的日报");
		getDateSelect();
		getTimeList();
		getCompanyList("", 0, 0, 1);
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

	function getUser() {
		var user;
		$.ajax({
			url : host + "/getUserByNickName",
			type : 'GET',
			data : {
				"nickName" : sId
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

	function getDateSelect() {
		var da = new Date();
		da.setTime(da.getTime() - 24 * 60 * 60 * 1000);
		var y = da.getFullYear();
		var m = da.getMonth() < 9 ? ("0" + (da.getMonth() + 1)) : (da
				.getMonth() + 1);
		var d = da.getDate() < 10 ? ("0" + da.getDate()) : da.getDate();
		var yesterday = y + "/" + m + "/" + d;

		var da2 = new Date();
		var y2 = da2.getFullYear();
		var m2 = da2.getMonth() < 9 ? ("0" + (da2.getMonth() + 1)) : (da2
				.getMonth() + 1);
		var d2 = da2.getDate() < 10 ? ("0" + da2.getDate()) : da2.getDate();
		var today = y2 + "/" + m2 + "/" + d2;
		var str = '<option value="'+yesterday+'">' + yesterday
				+ '</option><option value="'+today+'">' + today + '</option>';
		$("#date").empty();
		$("#date").append(str);
		$('#date').val(today);
	}

	function changeCompany(tCompanyId) {
		getProjectList(tCompanyId, 0);
	}

	function createDailyReport() {
		var date = $("#date option:selected").text();
		var time1 = $("#time1 option:selected").text();
		var time2 = $("#time2 option:selected").text();
		var companyId = $("#companyId").val();
		var projectId = $("#projectId").val();
		var jobContent = $("#jobContent").val();

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
			url : host + "/createDailyUploadReport",
			type : 'POST',
			cache : false,
			data : {
				"userName" : sId,
				"date" : date,
				"client" : companyId,
				"crmNum" : projectId,
				"jobContent" : jobContent,
				"time" : time1 + "-" + time2
			},
			success : function(returndata) {
				var data = eval("(" + returndata + ")").errcode;
				if (data == 0) {
					alert("提交成功");
					setTimeout(function() {

						//这个可以关闭安卓系统的手机  
						document.addEventListener('WeixinJSBridgeReady',
								function() {
									WeixinJSBridge.call('closeWindow');
								}, false);
						//这个可以关闭ios系统的手机  
						WeixinJSBridge.call('closeWindow');
					}, 500)
				} else {
					alert("提交失败  " + eval("(" + returndata + ")").message);
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
				<select id="date" style="width: 90%;">
				</select>
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
		<button type="button" onclick="createDailyReport();"
			class="btn btn-primary">提交</button>
	</div>
</body>
</html>