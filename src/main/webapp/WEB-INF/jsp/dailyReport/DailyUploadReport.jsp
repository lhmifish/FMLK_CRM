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
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/bootstrap-switch.css" />
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/bootstrap.min.css" />
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/highlight.css" />
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/main2.css" />
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.2.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/jweixin-1.0.0.js"></script>
<script src="${pageContext.request.contextPath}/js/getObjectList.js?v=2024"></script>
<script src="${pageContext.request.contextPath}/js/select3.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/bootstrap-switch.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/bootstrap.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/highlight.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/main.js"></script>
<script src="${pageContext.request.contextPath}/js/request.js?v=2"></script>
<script src="${pageContext.request.contextPath}/js/getObject.js?v=0"></script>
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
	var isFmlkShare;
	var requestReturn;
	var tUser;
	var isShowCompanySelect;

	$(document).ready(function() {
		sId = "${mUserId}";
		host = "${pageContext.request.contextPath}";
		tUser =  getUser("nickName", sId);
		$(document).attr("title", tUser.name + "的日报");
		isFmlkShare = true;
		getDateSelect();
		getTimeList();
		if(tUser.departmentId != 1){
			$("#time1").val("09:00");
			$("#time2").val("18:00");
		}
		getCompanyList("", 0, 0, 1, isFmlkShare);
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
		$('#typeCheck').bootstrapSwitch();
		$("#typeCheck").on('switchChange.bootstrapSwitch', function(event, state) {
			isFmlkShare = state
			if(tUser.roleId == 5){
				getCompanyList("", tUser.UId, 0, 1, isFmlkShare);
			}else{
				getCompanyList("", 0, 0, 1, isFmlkShare);
			}
			$("#projectId").empty();
			$("#projectId").append('<option value="0">请选择...</option>');
		});
		setTimeout(function() {
			if(tUser.departmentId==2){
				alert("销售人员的客户拜访记录=日报，这里无需重复填写\n【当天在公司的在这里填写】");
			}
			isShowCompanySelect = tUser.departmentId==8;
			if(isShowCompanySelect){
				//只有运维部需要填客户
				$("#cpmpanyLineTitle").show();
				$("#cpmpanyLineSelect").show();
			}
		}, 500);
	
	});

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
		//getProjectList(tCompanyId, 0,isFmlkShare);
	}

	function createDailyReport() {
		var date = $("#date option:selected").text();
		var time1 = $("#time1 option:selected").text();
		var time2 = $("#time2 option:selected").text();
		var companyId = $("#companyId").val();
	//	var projectId = $("#projectId").val();
		var jobContent = $("#jobContent").val();

		if (companyId == 0 && isShowCompanySelect) {
			alert("请选择客户公司");
			return;
		}

		if (jobContent.length == 0) {
			alert("工作内容不能为空");
			return;
		}
        var params = {
        		"userName" : sId,
				"date" : date,
				"client" : companyId,
		    	"crmNum" : "0",
				"jobContent" : jobContent,
				"time" : time1 + "-" + time2,
				"isFmlkShare":isFmlkShare	
        }
        post("createDailyUploadReport",params,false);
		if(requestReturn.result == "error"){
			alert(requestReturn.error);
		}else if(parseInt(requestReturn.code)==0){
			alert("提交成功");
			setTimeout(function() {
				document.addEventListener('WeixinJSBridgeReady',
						function() {
							WeixinJSBridge.call('closeWindow');
						}, false);
				WeixinJSBridge.call('closeWindow');
			}, 500);
		}else if(parseInt(requestReturn.code)==3){
			alert("提交失败: 请勿重新提交日报");
		}else{
			alert("提交失败，错误编码: " + requestReturn.code);
		}
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

			<p style="margin-left: 5%; margin-top: 10px;display:none" id="cpmpanyLineTitle">
				<a style="color: red">* </a><span style="margin-right: 30px">客户公司</span><input
					type="checkbox" data-on-text="共享陪护" data-off-text="信息"
					data-size="mini" data-label-text="点击切换" data-on-color="info"
					data-off-color="warning" data-handle-width="50px"
					data-label-width="70px" id="typeCheck" checked="checked">
			</p>
			<div style="margin-left: 5%;display:none" id="cpmpanyLineSelect">
				<select id="companyId" style="width: 90%;"
					onChange="changeCompany(this.options[this.options.selectedIndex].value)">
				</select>
			</div>
            <%--
			<p style="margin-left: 5%; margin-top: 10px;">
				<a style="color: red; visibility: hidden">* </a>项目名称
			</p>
			<div style="margin-left: 5%;">
				<select id="projectId" style="width: 90%;"><option value="0">请选择...</option></select>
			</div>
            --%>
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