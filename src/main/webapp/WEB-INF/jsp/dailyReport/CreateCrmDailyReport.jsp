<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="pragma" content="no-cache" />
<meta http-equiv="cache-control" content="no-cache" />
<title>日报</title>
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/css.css?v=1990" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/select4.css?v=1997" />
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.2.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/select3.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery.jqprint-0.3.js"></script>
<script src="http://www.jq22.com/jquery/jquery-migrate-1.2.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/checkPermission.js"></script>
<script src="${pageContext.request.contextPath}/js/changePsd.js"></script>
<script src="${pageContext.request.contextPath}/js/commonUtils.js"></script>
<script src="${pageContext.request.contextPath}/js/getObjectList.js"></script>
<style type="text/css">
a:hover {
	color: #FF00FF
} /* 鼠标移动到链接上 */
::-webkit-scrollbar {
	display: none;
}

html {
	-ms-overflow-style: none;
	/*火狐下隐藏滚动条*/
	overflow: -moz-scrollbars-none;
}
</style>
<script type="text/javascript">
	var sId;
	var host;
	var userName;
	var isPermissionView;
	var year;
	var month;
	var DayOfWeek;
	var MonStr;
	var TuesStr;
	var WedStr;
	var ThurStr;
	var FriStr;
	var SatStr;
	var SunStr;

	$(document).ready(function() {
		sId = "${sessionId}";
		host = "${pageContext.request.contextPath}";
		checkViewPremission(77);
	});

	function initialPage() {
		initialDate();
		userName = getUser().name;
		document.getElementById("userCrm").innerHTML = "&nbsp;&nbsp;(&nbsp;"
				+ userName + "&nbsp;&nbsp;" + MonStr
				+ "&nbsp;&nbsp;至&nbsp;&nbsp;" + SunStr + "&nbsp;)";
		getThisWeekList(formatDate(new Date()).substring(0, 10));
		getTimeList();
		getCompanyList("", 0, 0, 1);
		getCrmDailyReportList();
		$("#date").select2({minimumResultsForSearch: -1});
		$("#time1").select2({minimumResultsForSearch: -1});
		$("#time2").select2({minimumResultsForSearch: -1});
		$("#companyId").select2({});
		$("#projectId").select2({});
	}

	function initialDate() {
		var da = new Date();
		year = da.getFullYear();
		month = da.getMonth() + 1;
		DayOfWeek = (da.getDay() == 0) ? 7 : da.getDay();
		MonStr = formatDate(
				new Date(year, month - 1, da.getDate() - DayOfWeek + 1))
				.substring(0, 10);//当前周第一天
		TuesStr = formatDate(
				new Date(year, month - 1, da.getDate() - DayOfWeek + 2))
				.substring(0, 10);
		WedStr = formatDate(
				new Date(year, month - 1, da.getDate() - DayOfWeek + 3))
				.substring(0, 10);
		ThurStr = formatDate(
				new Date(year, month - 1, da.getDate() - DayOfWeek + 4))
				.substring(0, 10);
		FriStr = formatDate(
				new Date(year, month - 1, da.getDate() - DayOfWeek + 5))
				.substring(0, 10);
		SatStr = formatDate(
				new Date(year, month - 1, da.getDate() - DayOfWeek + 6))
				.substring(0, 10);
		SunStr = formatDate(
				new Date(year, month - 1, da.getDate() - DayOfWeek + 7))
				.substring(0, 10);
	}

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
	
	function getCompany(mCompanyId) {
		var company;
		$
				.ajax({
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
		$
				.ajax({
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

	function changeCompany(tCompanyId) {
		getProjectList(tCompanyId, 0);
	}

	function createCrmDailyReport() {
		var date = $("#date option:selected").text();
		var time1 = $("#time1 option:selected").text();
		var time2 = $("#time2 option:selected").text();
		var companyId = $("#companyId").val();
		var projectId = $("#projectId").val();
		var jobContent = $("#jobContent").val();
		//userName;
		if (new Date(date) > new Date()) {
			alert("你不能填写今天之后的日报");
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
						initialPage();
						$("#projectId").empty();
						$("#jobContent").val("");
					}, 500)
				} else {
					alert("提交失败  " + eval("(" + returndata + ")").message);
				}
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});

	}
	
	function showEditDailyUploadProjectWin(durIp){
		alert("暂时无法编辑...");
	}
</script>
</head>
<body id="body" style="display: none">
	<div id="pageAll">
		<div class="pageTop">
			<div class="page">
				<img src="../image/coin02.png" /><span><a href="#">首页</a>&nbsp;-&nbsp;<a
					href="#">考勤管理</a>&nbsp;-</span>&nbsp;填写日报<span id="userCrm"></span>
			</div>
		</div>

		<!-- 新建客户信息 -->
		<div class="page">
			<div class="banneradd bor"
				style="width: 35%; float: left;; margin-top: 20px">
				<div class="baBody" style="margin-left: 0px">
					<div class="bbD">
						<label style="margin-left: 42px;">日期：</label><select
							class="selCss" id="date" style="width: 70%;"></select>
					</div>

					<div class="bbD">
						<label style="margin-left: 42px;">时间：</label><select
							class="selCss" id="time1" style="width: 31%;"></select><label
							style="margin-left: 10px; margin-right: 10px;">至</label><select
							class="selCss" id="time2" style="width: 31%;"></select>
					</div>

					<div class="bbD">
						<label>客户公司：</label><select class="selCss" id="companyId"
							style="width: 70%;"
							onChange="changeCompany(this.options[this.options.selectedIndex].value)"></select>
					</div>

					<div class="bbD">
						<label>项目名称：</label><select class="selCss" id="projectId"
							style="width: 70%;"></select>
					</div>

					<div class="bbD">
						<label style="float: left;">工作内容：</label>
						<textarea class="input3" id="jobContent"
							style="width: 68%; resize: none; height: 280px;"></textarea>
					</div>

					<div class="cfD" style="margin-top: 20px">
						<a class="addA" href="#" onclick="createCrmDailyReport()"
							style="width: 100%; margin-left: 0px;">提交</a>
					</div>
				</div>
			</div>
			<!-- 新建客户信息end -->

			<div class="conShow" style="width: 60%; float: left; margin: 20px;">
				<table border="1" style="width: 100%;">
					<tr>
						<td style="width: 14%;" class="tdColor">日期&时间</td>
						<td style="width: 35%;" class="tdColor">客户公司/项目名称</td>
						<td style="width: 45%;" class="tdColor">工作内容</td>
						<td style="width: 6%;" class="tdColor">操作</td>
					</tr>
				</table>
				<table id="tb" border="1" style="table-layout: fixed; width: 100%;">
				</table>
			</div>
		</div>
	</div>
</body>
</html>