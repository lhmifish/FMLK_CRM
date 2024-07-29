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

	$(document).ready(function() {
		id = "${mId}";
		type = "${type}";
		sId = "${sessionId}";
	//	sId = "yang.huifang";
		host = "${pageContext.request.contextPath}";
		checkEditPremission2(23, 25, 26);
	});

	function initialPage() {
		if (type == 1) {
			$(document).attr("title", "销售审核");
		} else {
			$(document).attr("title", "技术派工");
		}
		getProjectCaseInfo(id);
		$("#salesId").select2({});
		$("#projectId").select2({});
		$("#projectState").select2({});
		$("#caseType").select2({});
		$("#casePeriod").select2({});
		$("#serviceType").select2({});
		$("#serviceUsers").select2({
			placeholder : "请选择..."
		});

		if (!isPermissionCheck && type == 1) {
			$("#divBtn").hide();
		} else if (!isPermissionDispatch && type == 2) {
			$("#divBtn").hide();
		}
	}

	function getProjectCaseInfo(tid) {
		$
				.ajax({
					url : host + "/getProjectCase",
					type : 'GET',
					cache : false,
					async : false,
					data : {
						"id" : tid
					},
					success : function(returndata) {
						var data = eval("(" + returndata + ")").projectCase;
						$("#companyName").val(
								getCompany(data[0].projectId).companyName);
						var companyId = getCompany(data[0].projectId).companyId;
						getProjectList(companyId, data[0].projectId);
						getSalesList(data[0].salesId);
						salesId = data[0].salesId;
						
						if(data[0].serviceEndDate == "" || data[0].serviceEndDate == null){
							data[0].serviceEndDate = data[0].serviceDate
						}
						
						$('#serviceDate').val(data[0].serviceDate+" to "+data[0].serviceEndDate);
						getProjectStateList(data[0].caseType.split("#")[0]);
						getCaseTypeList(data[0].caseType.split("#")[1]);
						getServiceTypeList(data[0].serviceType);
						getCasePeriodList(data[0].casePeriod);
						$('#serviceContent').val(data[0].serviceContent);
						caseId = data[0].caseId;
						isChecked = data[0].isChecked;
						var isRejected = data[0].isRejected;
						if (isRejected) {
							//拒绝
							$("input[name='field02']").attr("disabled",
									"disabled");
							$("#divBtn").hide();
							selCheckResult(2);
							$(
									"input[name='field02'][value='"
											+ checkResult + "']").attr(
									"checked", true);
							$("#reasonForReject").val(data[0].rejectReason);
							$('#reasonForReject').attr("disabled", "disabled");
							$('#reasonForReject').css("background-color",
									"#EEE");
						} else {
							//同意
							if (isChecked && type == 1) {
								
								$("input[name='field02']").attr("disabled",
										"disabled");
								$("#divBtn").hide();
								selCheckResult(1);
								$(
										"input[name='field02'][value='"
												+ checkResult + "']").attr(
										"checked", true);
							} else if (type == 2
									&& data[0].serviceUsers != null
									&& data[0].serviceUsers != "") {
								$("input[name='field02']").attr("disabled",
										"disabled");
								$("#divBtn").hide();
								selCheckResult(1);
								$(
										"input[name='field02'][value='"
												+ checkResult + "']").attr(
										"checked", true);
								$('#serviceUsers').attr("disabled", "disabled");
								$('#serviceUsers').css("background-color",
										"#EEE");
								getMultiServiceUsersList(data[0].serviceUsers
										.split(","));
								$("#remark").val(data[0].remark);
								$('#remark').attr("disabled", "disabled");
								$("#serviceUserDiv").show();
								$("#serviceUserLine").show();
								$("#remarkDiv").show();
								$("#remarkLine").show();
							} else {
								checkResult = 1;
								if (type == 2) {
									$("#serviceUserDiv").show();
									$("#serviceUserLine").show();
									$("#remarkDiv").show();
									$("#remarkLine").show();
									getMultiServiceUsersList(null);
									$("#remark").val("");
								}
							}
						}
					},
					error : function(XMLHttpRequest, textStatus, errorThrown) {
					}
				});
	}

	function getCompany(mProjectId) {
		var company;
		$.ajax({
			url : host + "/getCompanyByProjectId",
			type : 'GET',
			data : {
				"projectId" : mProjectId
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
			getMultiServiceUsersList(null);
		} else {
			//通过
			$("#reasonDiv").hide();
			$("#reasonLine").hide();
			$("#reasonForReject").val("");
			if (type != 1) {
				$("#serviceUserDiv").show();
				$("#serviceUserLine").show();
				$("#remarkDiv").show();
				$("#remarkLine").show();
			}
		}
	}

	function editProjectCase() {
		if (!isPermissionCheck && type == 1) {
			alert("你没有权限审核派工单");
			return;
		} else if (!isPermissionDispatch && type == 2) {
			alert("你没有权限派工");
			return;
		}

		var rejectReason = $("#reasonForReject").val().trim();
		if (checkResult == 2 && rejectReason == "") {
			alert("请填写拒绝理由");
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
		
		//var timeStart = serviceDate.split("to")[0].replace(/-/g, "/");
		//var timeEnd = serviceDate.split("to")[1].replace(/-/g, "/");
		
		$.ajax({
			url : host + "/editCaseRecord",
			type : 'POST',
			cache : false,
			dataType : "json",
			async : false,
			data : {
				"id" : id,
				"type" : type,
				"checkResult" : checkResult,
				"salesId" : $("#salesId").val(),
				"contactUsers" : new Array(),
				"serviceDate" : $("#serviceDate").val().split("to")[0].replace(/-/g, "/").trim(),
				"caseType" : $("#caseType").val(),
				"serviceType" : $("#serviceType").val(),
				"serviceContent" : $("#serviceContent").val().trim(),
				"deviceInfo" : "",
				"rejectReason" : rejectReason,
				"serviceUsers" : serviceUsersArr,
				"casePeriod" : $("#casePeriod").val(),
				"projectId" : $("#projectId").val(),
				"companyName" : $('#companyName').val(),
				"projectName" : $("#projectId option:selected").text(),
				"remark":$('#remark').val(),
				"isChecked":isChecked,
				"serviceEndDate" : $("#serviceDate").val().split("to")[1].replace(/-/g, "/").trim(),
			},
			traditional : true,
			success : function(returndata) {
				var data = returndata.errcode;
				if (data == 0) {
					alert("确认成功");
				} else {
					if (type == 1) {
						alert("销售审核失败");
					} else {
						alert("技术派工失败");
					}
				}
				setTimeout(function() {

					//这个可以关闭安卓系统的手机  
					document.addEventListener('WeixinJSBridgeReady',
							function() {
								WeixinJSBridge.call('closeWindow');
							}, false);
					//这个可以关闭ios系统的手机  
					WeixinJSBridge.call('closeWindow');
				}, 500)
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
				<a style="color: red"> </a>客户名称
			</p>
			<div style="margin-left: 5%;">
				<input id="companyName" style="width: 88%; height: 26px;padding-left:10px"
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
				<input id="serviceDate" style="width: 88%; height: 26px;padding-left:10px"
					disabled="disabled" />
			</div>
			<p style="margin-left: 5%; margin-top: 10px;">
				<a style="color: red"> </a>派工类别
			</p>
			<div style="margin-left: 5%;">
				<select id="projectState" style="width: 42%;" disabled="disabled"></select>&nbsp&nbsp&nbsp&nbsp<select
					id="caseType" style="width: 42%; margin-left: 5px"
					disabled="disabled"></select>
			</div>
			<p style="margin-left: 5%; margin-top: 10px;">
				<a style="color: red"> </a>服务级别&时长
			</p>
			<div style="margin-left: 5%;">
				<select id="serviceType" style="width: 42%;" disabled="disabled"></select>&nbsp&nbsp&nbsp&nbsp<select
					id="casePeriod" style="width: 42%; margin-left: 5px"
					disabled="disabled"></select>
			</div>
			<p style="margin-left: 5%; margin-top: 10px;">
				<a style="color: red"> </a>要求服务内容
			</p>
			<div style="margin-left: 8%; margin-top: 10px; font-size: 12px">
				<textarea placeholder="工作内容" id="serviceContent"
					style="width: 90%; background: none;border-bottom: 1px dashed #78639F;border-top:none;border-left:none;border-right:none" rows="5"
					disabled="disabled"></textarea>
			</div>
			<p style="margin-left: 5%; margin-top: 10px;">
				<a style="color: red"> </a>审核结果
			</p>
			<div style="margin-left: 5%;">
				<input type="radio" name="field02" id="checkResult" value="1"
					checked="checked" onclick="selCheckResult(1)" /><label
					style="margin-right: 50px; margin-left: 5px;">通过</label><input
					type="radio" name="field02" id="checkResult" value="2"
					onclick="selCheckResult(2)" /><label
					style="margin-left: 5px; color: red">拒绝</label>
			</div>


			<p style="margin-left: 5%; margin-top: 10px; display: none;"
				id="serviceUserLine">
				<a style="color: red"> </a>服务工程师
			</p>
			<div id="serviceUserDiv"
				style="margin-left: 5%; display: none;">
				<select id="serviceUsers" multiple="multiple" style="width: 90%;"></select>

			</div>
			<p style="margin-left: 5%; margin-top: 10px; display: none;"
				id="remarkLine">
				<a style="color: red"> </a>备注
			</p>
			<div id="remarkDiv"
				style="margin-left: 5%; display: none; margin-bottom: 30px;">
				<input id="remark" style="width: 88%; height: 26px;color:red;border-bottom: 1px dashed #78639F;border-top:none;border-left:none;border-right:none;padding-left:10px"/>
			</div>
			<p style="margin-left: 5%; margin-top: 10px; display: none;"
				id="reasonLine">
				<a style="color: red"> </a>拒绝理由
			</p>
			<div id="reasonDiv"
				style="margin-left: 8%; margin-top: 10px; font-size: 12px; display: none;">
				<textarea placeholder="拒绝理由" id="reasonForReject"
					style="width: 90%; background: none;border-bottom: 1px dashed #78639F;border-top:none;border-left:none;border-right:none" rows="5"></textarea>
			</div>

		</div>
	</div>


	<div class="button-submit" id="divBtn">
		<button type="button" onclick="editProjectCase()"
			class="btn btn-primary" id="btn">确认</button>
	</div>
</body>
</html>