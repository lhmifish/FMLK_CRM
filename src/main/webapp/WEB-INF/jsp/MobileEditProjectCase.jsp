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
<title></title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/showbox.css" />
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/css.css?v=1999" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/select4.css?v=2001" />
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.2.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/jweixin-1.0.0.js"></script>
<script src="${pageContext.request.contextPath}/js/select3.js"></script>
<script src="${pageContext.request.contextPath}/js/checkPermission.js"></script>
<script src="${pageContext.request.contextPath}/js/changePsd.js"></script>
<script src="${pageContext.request.contextPath}/js/commonUtils.js"></script>
<script src="${pageContext.request.contextPath}/js/getObjectList.js"></script>
<script src="${pageContext.request.contextPath}/js/getObject.js?v=1"></script>
<script src="${pageContext.request.contextPath}/js/request.js?v=3"></script>

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
	var type;//0.编辑1.销审2.技审
	var sId;//sessionId
	var salesId;//projectCase_salesId
	var checkResult;
	var isChecked;
	var isRejected;
	var isPermissionEdit;
	var isPermissionCheck;
	var isPermissionDispatch;

	$(document).ready(function() {
		id = "${mId}";
		type = "${type}";
		sId = "${sessionId}";
		host = "${pageContext.request.contextPath}";
		checkEditPremission2(23, 25, 26);
	});

	function initialPage() {
		if(type == 0){
			$(document).attr("title", "派工已撤回");
		}else if (type == 1) {
			$(document).attr("title", "销售审核");
		} else {
			$(document).attr("title", "技术派工");
		}
		getProjectCaseInfo(id);
		$("#salesId").select2({});
		$("#projectId").select2({});
		$("#projectState").select2({});
		$("#caseType").select2({});
		$("#serviceType").select2({});
		$("#serviceUsers").select2({
			placeholder : "请选择..."
		});
		if(type>0){
			$("#checkDivTitle").show();
			$("#checkDiv").show();
			if((type == 1 && !isPermissionCheck) || (type == 2 && !isPermissionDispatch)){
				$("#divBtn").hide();
			}
		}else{
			$("#divBtn").hide();
		}
	}

	function getProjectCaseInfo(tid) {
		get("getProjectCase", {
			"id" : tid
		}, false);
		if (requestReturn.result == "error") {
			alert(requestReturn.error);
		} else {
			var projectCase = requestReturn.data.projectCase[0];
			isChecked = projectCase.isChecked;
			isRejected = projectCase.isRejected;
			var mCompany = getCompany("projectId", projectCase.projectId);
			$("#companyName").val(mCompany.companyName);
			getProjectList(mCompany.companyId, projectCase.projectId);
			salesId = projectCase.salesId;
			getSalesList(salesId);
			$('#serviceDate').val(
					projectCase.serviceDate + " to "
							+ projectCase.serviceEndDate);
			getProjectStateList(projectCase.caseType.split("#")[0]);
			getCaseTypeList(projectCase.caseType.split("#")[1]);
			getServiceTypeList(projectCase.serviceType);
			$('#serviceContent').val(projectCase.serviceContent);
			$('#deviceInfo').val(projectCase.deviceInfo);
			if (isRejected) {
				//显示审核结果及驳回理由
				$("#divBtn").hide();
				checkResult = 2;
				$("input[name='field02'][value='2']").attr("checked", true);
				$("input[name='field02']").attr("disabled", "disabled");
                var rejectReason = projectCase.rejectReason;
                if(rejectReason.indexOf("@")!=-1){
                	rejectReason = rejectReason.split("@")[0];
                }
				$('#reasonForReject').val(rejectReason);
				$('#reasonForReject').attr("disabled", "disabled");
				$('#reasonForReject').css("background-color", "#EEE");
				$("#reasonLine").show();
				$("#reasonDiv").show();
			} else if (!isChecked) {
				//未审核
				if(!projectCase.isDelete){
					$("#divBtn").show();
					checkResult = 1;
					$("input[name='field02'][value='1']").attr("checked", true);
					$("#checkDiv").css("margin-bottom","60px");
				}
			} else {
				//已审核
				if (projectCase.serviceUsers != null
						&& projectCase.serviceUsers != "") {
					//技术已审核
					$("#divBtn").hide();
					checkResult = 1;
					$("input[name='field02'][value='1']").attr("checked", true);
					$("input[name='field02']").attr("disabled", "disabled");

					var serviceUsers = projectCase.serviceUsers;
					var serviceUsersArr = new Array();
					if (serviceUsers != null && serviceUsers != "") {
						if (serviceUsers.indexOf(",") != -1) {
							for (var j = 0; j < serviceUsers.split(",").length; j++) {
								serviceUsersArr
										.push(serviceUsers.split(",")[j])
							}
						} else {
							serviceUsersArr.push(serviceUsers);
						}
						$("#remark").val(projectCase.remark);
					} else {
						serviceUsersArr = null;
					}
					getMultiServiceUsersList(serviceUsersArr);
					$('#serviceUsers').attr("disabled", "disabled");
					$('#serviceUsers').css("background-color", "#EEE");
					$("#serviceUserLine").show();
					$("#serviceUserDiv").show();
					$('#remark').attr("disabled", "disabled");
					$('#remark').css("background-color", "#EEE");
					$("#remarkLine").show();
					$("#remarkDiv").show();
				} else {
					//销售已审核技术未审核
					if (type == 1) {
						$("#divBtn").hide();
						checkResult = 1;
						$("input[name='field02'][value='1']").attr("checked",
								true);
						$("input[name='field02']").attr("disabled", "disabled");
					} else {
						$("#divBtn").show();
						checkResult = 1;
						$("input[name='field02'][value='1']").attr("checked",
								true);
						getMultiServiceUsersList(null);
						$("#serviceUserLine").show();
						$("#serviceUserDiv").show();
						$("#remarkLine").show();
						$("#remarkDiv").show();
					}
				}
			}
		}
	}

	function selCheckResult(mSel) {
		checkResult = mSel;
		//只有在审核时才能选择
		if (mSel == 2) {
			//拒绝
			$("#reasonDiv").show();
			$("#reasonLine").show();
			$("#serviceUserDiv").hide();
			$("#serviceUserLine").hide();
			$("#remarkDiv").hide();
			$("#remarkLine").hide();
			$("#remark").val("");
			$("#checkDiv").css("margin-bottom","20px");
			getMultiServiceUsersList(null);
		} else {
			//通过
			$("#reasonDiv").hide();
			$("#reasonLine").hide();
			$("#reasonForReject").val("");
			if (type == 2) {
				$("#serviceUserDiv").show();
				$("#serviceUserLine").show();
				$("#remarkDiv").show();
				$("#remarkLine").show();
			}else if(type==1){
				$("#checkDiv").css("margin-bottom","60px");
			}
		}
	}

	function editProjectCase() {
		var rejectReason = $("#reasonForReject").val().trim();
		if (checkResult == 2 && rejectReason == "") {
			alert("请填写驳回理由");
			return;
		}
		var serviceUsersArr = new Array();
		$("#serviceUsers option:selected").each(function() {
			serviceUsersArr.push($(this).val());
		});
		if (checkResult == 1 && serviceUsersArr.length == 0 && type == 2) {
			alert("请选择服务工程师");
			return;
		}
		if(serviceUsersArr.length==0){
			serviceUsersArr.push("");
		}
		var contactUsersArr = new Array();
		contactUsersArr.push("");	
		var params = {
				"id" : id,
				"type" : type,
				"checkResult" : checkResult,
				"salesId" : salesId,
				"contactUsers" : contactUsersArr,
				"serviceDate" : $("#serviceDate").val().split("to")[0].replace(/-/g, "/").trim(),
				"caseType" : $("#projectState").val()+"#"+$("#caseType").val(),
				"serviceType" :$("#serviceType").val(),
				"serviceContent" : $("#serviceContent").val(),
				"deviceInfo" : $("#deviceInfo").val(),
				"rejectReason" : rejectReason==""?"":rejectReason+"@"+type,
				"serviceUsers" : serviceUsersArr,
				"projectId" : $("#projectId").val(),
				"companyName" : $('#companyName').val(),
				"projectName" : $("#projectId option:selected").text(),
				"remark" : $('#remark').val(),
				"isChecked" : isChecked,
				"serviceEndDate" : $("#serviceDate").val().split("to")[1].replace(/-/g, "/").trim()	
		}
		post("editCaseRecord",params,true);
		if(requestReturn.result == "error"){
			alert(requestReturn.error);
		}else if(parseInt(requestReturn.code)==0){
			alert("审核完成");
		}else {
			alert("审核失败");
		}
		setTimeout(function() {
            //这个可以关闭安卓系统的手机  
			document.addEventListener('WeixinJSBridgeReady',
					function() {
						WeixinJSBridge.call('closeWindow');
					}, false);
			//这个可以关闭ios系统的手机  
			WeixinJSBridge.call('closeWindow');
		}, 500);
	}
</script>
</head>


<body class="body-gray" style="margin: auto;">
	<div class="form">
		<div class="top" style="width: 100%">
			<p style="margin-left: 5%; margin-top: 30px;">
				<a style="color: red"> </a>客户名称
			</p>
			<div style="margin-left: 5%;">
				<input id="companyName"
					style="width: 88%; height: 26px; padding-left: 10px;border:0px;background-color:#eee"
					disabled="disabled" />
			</div>
			<p style="margin-left: 5%; margin-top: 10px;">
				<a style="color: red"> </a>项目名称
			</p>
			<div style="margin-left: 5%;">
				<select id="projectId" style="width: 90%;" disabled="disabled">
				</select>
			</div>
			<p style="margin-left: 5%; margin-top: 10px;">
				<a style="color: red"> </a>销售人员
			</p>
			<div style="margin-left: 5%;">
				<select id="salesId" style="width: 90%;" disabled="disabled">
				</select>
			</div>
			<p style="margin-left: 5%; margin-top: 10px">
				<a style="color: red"> </a>客户服务时间
			</p>
			<div style="margin-left: 5%;">
				<input id="serviceDate"
					style="width: 88%; height: 26px; padding-left: 10px;border:0px;background-color:#eee"
					disabled="disabled" />
			</div>
			<p style="margin-left: 5%; margin-top: 10px;">
				<a style="color: red"> </a>派工类别
			</p>
			<div style="margin-left: 5%;">
				<select id="projectState" style="width: 44%;" disabled="disabled"></select>&nbsp&nbsp&nbsp&nbsp<select
					id="caseType" style="width: 42%; margin-left: 5px"
					disabled="disabled"></select>
			</div>
			<p style="margin-left: 5%; margin-top: 10px;">
				<a style="color: red"> </a>服务级别
			</p>
			<div style="margin-left: 5%;">
				<select id="serviceType" style="width: 90%;" disabled="disabled"></select>
			</div>
			<p style="margin-left: 5%; margin-top: 10px;">
				<a style="color: red"> </a>要求服务内容
			</p>
			<div style="margin-left: 5%; margin-top: 10px; font-size: 12px">
				<textarea placeholder="工作内容" id="serviceContent"
					style="width: 90%; background-color:#eee; border-bottom: 1px dashed #78639F; border-top: none; border-left: none; border-right: none; resize: none;"
					rows="3" disabled="disabled"></textarea>
			</div>
			<p style="margin-left: 5%; margin-top: 10px;">
				<a style="color: red"> </a>设备型号数量
			</p>
			<div style="margin-left: 5%; margin-top: 10px; font-size: 12px">
				<textarea placeholder="型号及数量" id="deviceInfo"
					style="width: 90%; background-color:#eee; border-bottom: 1px dashed #78639F; border-top: none; border-left: none; border-right: none; resize: none;"
					rows="3" disabled="disabled"></textarea>
			</div>

			<p style="margin-left: 5%; margin-top: 10px;display: none;" id="checkDivTitle">
				<a style="color: red"> </a>审核结果
			</p>
			<div style="margin-left: 5%;margin-top: 10px;margin-bottom:20px;display: none;" id="checkDiv">
				<input type="radio" name="field02" id="checkResult" value="1"
					checked="checked" onclick="selCheckResult(1)" /><label
					style="margin-right: 50px; margin-left: 5px;">通过</label><input
					type="radio" name="field02" id="checkResult" value="2"
					onclick="selCheckResult(2)" /><label
					style="margin-left: 5px; color: red">驳回</label>
			</div>
			<p style="margin-left: 5%;display: none;"
				id="reasonLine">
				<a style="color: red"> </a>驳回理由
			</p>
			<div id="reasonDiv"
				style="margin-left: 5%; margin-top: 10px; font-size: 12px; display: none;margin-bottom:60px">
				<textarea placeholder="驳回理由" id="reasonForReject"
					style="width: 90%; background: none; border-bottom: 1px dashed #78639F; border-top: none; border-left: none; border-right: none; resize: none;"
					rows="3"></textarea>
			</div>

			<p style="margin-left: 5%; margin-top: 10px; display: none;"
				id="serviceUserLine">
				<a style="color: red"> </a>服务工程师
			</p>
			<div id="serviceUserDiv" style="margin-left: 5%; display: none;">
				<select id="serviceUsers" multiple="multiple" style="width: 90%;"></select>

			</div>
			<p style="margin-left: 5%; margin-top: 10px; display: none;"
				id="remarkLine">
				<a style="color: red"> </a>备注
			</p>
			<div id="remarkDiv"
				style="margin-left: 5%; display: none; margin-bottom: 60px;">
				<input id="remark"
					style="width: 88%; height: 26px; color: red; border-bottom: 1px dashed #78639F; border-top: none; border-left: none; border-right: none; padding-left: 10px" />
			</div>


		</div>
	</div>


	<div class="button-submit" id="divBtn">
		<button type="button" onclick="editProjectCase()"
			class="btn btn-primary" id="btn">审核</button>
	</div>
</body>
</html>