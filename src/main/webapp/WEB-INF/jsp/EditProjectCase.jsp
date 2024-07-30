<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="renderer" content="webkit" />
<meta http-equiv="X-UA-COMPATIBLE" content="IE=edge,chrome=1" />
<meta name="viewport"
	content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=yes" />
<meta name="apple-mobile-web-app-capable" content="yes" />
<meta name="apple-mobile-web-app-status-bar-style" content="black" />
<meta name="format-detection" content="telephone=no" />
<meta http-equiv="pragma" content="no-cache" />
<meta http-equiv="cache-control" content="no-cache" />
<title>编辑派工单</title>
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/loading.css?v=2">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/select4.css?v=1999" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/css.css?v=1997" />
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/material_blue.css">
<link rel="stylesheet" type="text/css"
	href="https://npmcdn.com/flatpickr/dist/ie.css">
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/animate.css">
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.2.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/select3.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/flatpickr_v3.js"></script>
<script src="${pageContext.request.contextPath}/js/checkPermission.js?v=3"></script>
<script src="${pageContext.request.contextPath}/js/changePsd.js"></script>
<script src="${pageContext.request.contextPath}/js/commonUtils.js"></script>
<script
	src="${pageContext.request.contextPath}/js/getObjectList.js?v=103"></script>
<script src="${pageContext.request.contextPath}/js/request.js?v=3"></script>
<script src="${pageContext.request.contextPath}/js/getObject.js?v=1"></script>
<script src="${pageContext.request.contextPath}/js/loading.js"></script>
<style type="text/css">
a:hover {
	color: #FF00FF
} /* 鼠标移动到链接上 */
.need {
	color: red;
	margin-right: 5px;
	margin-left: 0px
}
</style>

<script type="text/javascript">
	var id;//projectCase_id
	var type;//0.编辑1.销审2.技审
	var host;
	var checkResult;//1.通过2.驳回
	var chunks;
	var sliceSize;
	var currentChunk;
	var caseId;
	var sId;//sessionId
	var isPermissionEdit;
	var isPermissionCheck;
	var isPermissionDispatch;
	var salesId;//projectCase_salesId
	var tId;//user_id
	var tRoleId;//user_roleId
	var isChecked;//销售已审
	var isFmlkShare;
	var requestReturn;
	var isRejected;

	$(document).ready(function() {
		id = "${mId}";
		type = "${type}";
		sId = "${sessionId}";
		host = "${pageContext.request.contextPath}";
		checkEditPremission2(23, 25, 26);
	});

	function initialPage() {
		isFmlkShare = false;
		document.getElementById("serviceDate").flatpickr({
			minuteIncrement : 30,
			mode : "range",
			enableTime : true,
			dateFormat : "Y-m-d H:i",
			time_24hr : true,
			onChange : function(dateObj, dateStr) {
			}
		});
		getProjectCaseInfo(id);
		matchEdit2("派工单");
		$("#salesId").select2({});
		$("#projectId").select2({});
		$("#contactUsers").select2({
			placeholder : "请选择..."
		});
		$("#projectState").select2({});
		$("#caseType").select2({});
		$("#serviceType").select2({});
		$("#serviceUsers").select2({
			placeholder : "请选择..."
		});
		sliceSize = 1 * 1024 * 1024;
	}

	function getProjectCaseInfo(tid) {
		get("getProjectCase", {
			"id" : tid
		}, false);
		if (requestReturn.result == "error") {
			alert(requestReturn.error);
		} else {
			var projectCase = requestReturn.data.projectCase[0];
			salesId = projectCase.salesId;
			getSalesList(salesId);
			var mCompany = getCompany("projectId", projectCase.projectId);
			$("#companyName").val(mCompany.companyName);
			getProjectList(mCompany.companyId, projectCase.projectId);
			$('#serviceDate').val(projectCase.serviceDate + " to "+ projectCase.serviceEndDate);
			var arr = new Array();
			if (projectCase.contactUsers.indexOf(",") != -1) {
				for (var i = 0; i < projectCase.contactUsers.split(",").length; i++) {
					arr.push(projectCase.contactUsers.split(",")[i])
				}
			} else {
				arr.push(projectCase.contactUsers);
			}
			getMultiContactUsersList(mCompany.companyId, arr);
			getProjectStateList(projectCase.caseType.split("#")[0]);
			getCaseTypeList(projectCase.caseType.split("#")[1]);
			getServiceTypeList(projectCase.serviceType);
			$('#serviceContent').val(projectCase.serviceContent);
			$('#deviceInfo').val(projectCase.deviceInfo);
			caseId = projectCase.caseId;
			getProjectCaseUploadFile(caseId, projectCase.projectId);
			isChecked = projectCase.isChecked;//销售已审
			var serviceUsers = projectCase.serviceUsers;
			var serviceUsersArr = new Array();
			if(serviceUsers != null && serviceUsers != ""){
				if (serviceUsers.indexOf(",") != -1) {
					for (var j = 0; j < serviceUsers.split(",").length; j++) {
						serviceUsersArr.push(serviceUsers.split(",")[j])
					}
				}else{
					serviceUsersArr.push(serviceUsers);
				}
				$("#remark").val(projectCase.remark);
			}else{
				serviceUsersArr = null;
			}
			getMultiServiceUsersList(serviceUsersArr);
			isRejected = projectCase.isRejected;
			
			$("#projectId").attr("disabled", "disabled");
			if(type >0){
				//销售审核和派工页面不能编辑
				$("#contactUsers").attr("disabled", "disabled");
				$("#serviceDate").attr("disabled", "disabled");
				$("#serviceDate").css("background-color", "#EEE");
				$("#serviceType").attr("disabled", "disabled");
				$("#serviceContent").attr("disabled", "disabled");
				$("#deviceInfo").attr("disabled", "disabled");
				$("#serviceContent").css("background-color", "#EEE");
				$("#deviceInfo").css("background-color", "#EEE");
				$("#myfile").attr("disabled", "disabled");
				$("input[name='field02']").removeAttr("disabled");
				//审核操作显示
				$("#checkDiv").show();
				selCheckResult(1);
				if(type==2){
					//技术审核
					$("#serviceUserDiv").show();
					$("#remarkDiv").show();
				}
			}else{
				//编辑页面
				if(projectCase.caseState > 0 && projectCase.caseState <6){
					//开始处理了就不能编辑了
					$("#contactUsers").attr("disabled", "disabled");
					$("#serviceDate").attr("disabled", "disabled");
					$("#serviceDate").css("background-color", "#EEE");
					$("#serviceType").attr("disabled", "disabled");
					$("#serviceContent").attr("disabled", "disabled");
					$("#deviceInfo").attr("disabled", "disabled");
					$("#serviceContent").css("background-color", "#EEE");
					$("#deviceInfo").css("background-color", "#EEE");
					$("#myfile").attr("disabled", "disabled");
					$("#checkDiv").show();
					$("#okclick").hide();
					selCheckResult(1);
					$("input[name='field02']").attr("disabled", "disabled");
					//已派工
					$("#serviceUserDiv").show();
					$("#remarkDiv").show();
				}else{
					$("#contactUsers").removeAttr("disabled");
					$("#serviceDate").removeAttr("disabled");
					$("#serviceDate").css("background-color", "#fff");
					$("#serviceType").removeAttr("disabled");
					$("#serviceContent").removeAttr("disabled");
					$("#deviceInfo").removeAttr("disabled");
					$("#serviceContent").css("background-color", "#fff");
					$("#deviceInfo").css("background-color", "#fff");
					$("#myfile").removeAttr("disabled");
					
					if(isChecked){
						$("#checkDiv").show();
						$("input[name='field02']").attr("disabled", "disabled");
						if(isRejected){
							$("#okclick").show();
							if(projectCase.caseState == 6){
								selCheckResult(2);
								$("input[name='field02'][value='2']").attr("checked", true);
								$("input[name='field02']").attr("disabled", "disabled");
								$("#reasonForReject").val(projectCase.rejectReason.indexOf("@")>-1?projectCase.rejectReason.split("@")[0]:projectCase.rejectReason);
								$('#reasonForReject').attr("disabled", "disabled");
								$('#reasonForReject').css("background-color", "#EEE");
								$("#checkDiv").show();
							}
						}else{
							$("#okclick").hide();
						}
					}
				}	
			}
		}
	}

	function changeProject(tProjectId) {
		if (tProjectId != 0) {
			var project = getProject("projectId", tProjectId);
			getProjectStateList(project.projectState);
		} else {
			getProjectStateList(0);
		}
		$("#caseType").removeAttr("disabled");
	}

	//销售审核
	function selCheckResult(mSel) {
		checkResult = mSel;
		if (mSel == 2) {
			//拒绝
			$("#remark").val("");
			$("#serviceUserDiv").hide();
			$("#remarkDiv").hide();
			$("#reasonDiv").show();
		} else {
			//通过
			$("#reasonDiv").hide();
			$("#reasonForReject").val("");
			if (type == 2) {
				//技术审核
				$("#serviceUserDiv").show();
				$("#remarkDiv").show();
			}
		}
	}

	function downloadFile(fileName, reportType, projectId) {
		$.ajax({
			url : host + "/downloadFile",
			type : 'GET',
			data : {
				"fileName" : fileName,
				"reportType" : reportType,
				"projectId" : projectId,
				"createYear" : ""
			},
			cache : false,
			async : false,
			success : function(returndata) {
				var errcode = eval("(" + returndata + ")").errcode;
				if (errcode == 0) {
					var link = document.createElement("a");
					link.href = eval("(" + returndata + ")").fileLink;
					document.body.appendChild(link).click();
				} else {
					var msg = eval("(" + returndata + ")").errmsg;
					alert(msg);
				}
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
	}

	function editProjectCase() {
		if (!isPermissionEdit && type == 0) {
			alert("你没有权限编辑派工单");
			return;
		} else if (!isPermissionCheck && type == 1) {
			alert("你没有权限审核派工单");
			return;
		} else if (!isPermissionDispatch && type == 2) {
			alert("你没有权限派工");
			return;
		}
		if(type==0 && !isRejected){
			alert("审核被驳回后才可以重新提审");
			return;
		}
		var projectId = $("#projectId").val();
		var mSalesId = $("#salesId").val();
		var contactUsersArr = new Array();
		$("#contactUsers option:selected").each(function() {
			contactUsersArr.push($(this).val());
		});
		var projectState = $("#projectState").val();
        var caseType = $("#caseType").val();
        var serviceDate = $("#serviceDate").val();
		var serviceType = $("#serviceType").val();
		var serviceContent = $("#serviceContent").val().trim();
		var deviceInfo = $("#deviceInfo").val().trim();
		var rejectReason = $("#reasonForReject").val().trim();
		var remark = $("#remark").val();
		var serviceUsersArr = new Array();
		$("#serviceUsers option:selected").each(function() {
			serviceUsersArr.push($(this).val());
		});
		
        if (mSalesId == 0) {
			alert("请选择销售人员");
			return;
		}

		if (contactUsersArr.length == 0) {
			alert("请选择客户联系人");
			return;
		}

		if (serviceDate == "") {
			alert("客户服务时间不能为空");
			return;
		}else{
			var timeStart = serviceDate.split("to")[0].replace(/-/g, "/").trim();
			var timeEnd = serviceDate.split("to")[1].replace(/-/g, "/").trim();
			if(new Date(timeEnd).getTime() - new Date(timeStart).getTime()<=0){
				alert("客户服务时间有误,请重新选择");
				return;
			}
		}

		if (caseType == 0) {
			alert("请选择派工类别");
			return;
		} else {
			caseType = projectState + "#" + caseType;
		}

		if (serviceType == 0) {
			alert("请选择服务级别");
			return;
		}
		if (serviceContent == "") {
			alert("请输入服务内容");
			return;
		}
		
		var myFile = document.getElementById("myfile").files[0];
		if (myFile != undefined && myFile.size > 3 * 1024 * 1024 * 1024) {
			alert("单个文件上传不能大于3GB");
			return;
		}

		if (checkResult == 2 && rejectReason == "") {
			alert("请填写驳回理由");
			return;
		}

		if (checkResult == 1 && serviceUsersArr.length == 0 && type == 2) {
			alert("请选择服务工程师");
			return;
		}
		if(serviceUsersArr.length==0){
			serviceUsersArr.push("");
		}
		
		if (type==0 && myFile != undefined) {
			if (!checkFileExist(myFile.name, projectId)) {
				chunks = Math.ceil(myFile.size / sliceSize);
				$("#progressDiv").show();
				currentChunk = 0;
				loading();
				doUploadFile(myFile, mSalesId, projectId, contactUsersArr,
						timeStart, caseType, serviceType, serviceContent,
						deviceInfo, rejectReason, serviceUsersArr,remark, timeEnd);
			} else {
				alert("该派工有相同文件名的附件已上传，请修改文件名");
				return;
			}
		} else {
			//无附件,保存派工单
			loading();
			setTimeout(function() {
				var result = editCaseRecord(mSalesId, contactUsersArr, timeStart,
						caseType, serviceType, serviceContent, deviceInfo,
						rejectReason, serviceUsersArr,remark,timeEnd);
				if (result) {
					if (type == 0) {
						alert("派工单已重新提审");
					} else if (type == 1) {
						alert("派工单已审核");
					} else {
						alert("派工审核已完成");
					}
					parent.leftFrame.initialPage();
					setTimeout(function() {
						closeLoading();
						toPage();
					}, 500);
				}
			}, 500);
		}
	}

	//检查文件服务器相同文件是否存在
	function checkFileExist(fileName, projectId) {
		var isExist = false;
        var params = {
        		"createYear" : "",
				"projectId" : projectId,
				"reportType" : 99	
        }
        get("queryUploadFile",params,false);
        if(requestReturn.result == "error"){
    		alert(requestReturn.error);
    	}else{
    		var data = requestReturn.data.fileList;
    		for(var i = 0; i < data.length; i++){
    			var path = data[i].path;
				var tFileName = path.substring(path.lastIndexOf("\/") + 1,path.length);
				if (fileName == tFileName) {
					isExist = true;
					break;
				}
    		}
    		return isExist;
    	}
	}

	function doUploadFile(mFile, mUserId, mProjectId, mContactUsersArr,
			mServiceDate, mCaseType, mServiceType, mServiceContent,
			mDeviceInfo, mRejectReason, mServiceUsersArr, mRemark,mServiceEndDate) {
		if (currentChunk < chunks) {
			var formData = new FormData();
			formData.append('reportType', 99);
			formData.append('projectId', mProjectId);
			formData.append('createYear', "");
			formData.append('fileSize', mFile.size);
			formData.append('fileName', mFile.name);
			formData.append('chunks', chunks);
			formData.append('chunk', currentChunk);
			formData.append('file', getSliceFile(mFile, currentChunk));
			formData.append('salesId', mUserId);
			formData.append('userId', mUserId);
			formData.append('projectName', $("#projectId option:selected").text());
			formData.append('companyName', $('#companyName').val());

			var xhr = new XMLHttpRequest();
			xhr.open("POST", host + "/addProjectReport");
			xhr.send(formData);
			xhr.onreadystatechange = function() {
				if (xhr.readyState == 4) {
					var errcode = eval("(" + xhr.responseText + ")").errcode;
					var info = eval("(" + xhr.responseText + ")").info;
					if (errcode == 0) {
						upDateProgress(currentChunk);
						currentChunk++;
						doUploadFile(mFile, mUserId, mProjectId,
								mContactUsersArr, mServiceDate, mCaseType,
								mServiceType, mServiceContent, mDeviceInfo,
								mRejectReason, mServiceUsersArr,mRemark, mServiceEndDate);
					} else {
						alert("上传文件错误，错误信息：" + info);
						closeLoading();
					}
				}
			}
		} else {
			setTimeout(function() {
				var result = editCaseRecord(mUserId, mContactUsersArr,
						mServiceDate, mCaseType, mServiceType, mServiceContent,
						mDeviceInfo, mRejectReason, mServiceUsersArr,mRemark, mServiceEndDate);
				if (result) {
					saveFileRecord(mUserId, mProjectId, mFile.name);
				}
			}, 500);
		}
	}

	function upDateProgress(currentChunk) {
		var percent = Math.round((currentChunk + 1) * 100 / chunks);
		var cont = document.getElementById("progress");
		cont.innerHTML = percent.toFixed(2) + '%';
		cont.style.width = percent.toFixed(2) + '%';
	}

	//获取分片文件
	function getSliceFile(mFile, tChunk) {
		var start = tChunk * sliceSize;
		var end = Math.min(start + sliceSize, mFile.size);
		var slice = File.prototype.slice || File.prototype.mozSlice
				|| File.prototype.webkitSlice;
		var sliceFile = slice.call(mFile, start, end);
		return sliceFile;
	}

	function saveFileRecord(mUserId, mProjectId, mFileName) {
		//保存到数据库
		var params = {
				"contactDate" : "",
				"userId" : mUserId,
				"reportDesc" : "",
				"projectId" : mProjectId,
				"reportType" : 99,
				"fileName" : mFileName,
				"caseId" : caseId
		}
		post("createProjectReport",params,true);
		if(requestReturn.result == "error"){
			alert(requestReturn.error);
		}else if(parseInt(requestReturn.code)==0){
			alert("编辑派工单成功");
			parent.leftFrame.initialPage();
			setTimeout(function() {
				toPage();
			}, 500);
		}else{
			alert("写入附件信息失败");
		}
		closeLoading();
	}

	function editCaseRecord(mSalesId, contactUsersArr, serviceDate, caseType,
			serviceType, serviceContent, deviceInfo, rejectReason,
			serviceUsersArr,mRemark, mServiceEndDate) {
		var isSuccess = false;
		var params = {
				"id" : id,
				"type" : type,
				"checkResult" : checkResult,
				"salesId" : mSalesId,
				"contactUsers" : contactUsersArr,
				"serviceDate" : serviceDate,
				"caseType" : caseType,
				"serviceType" : serviceType,
				"serviceContent" : serviceContent,
				"deviceInfo" : deviceInfo,
				"rejectReason" : rejectReason==""?"":rejectReason+"@"+type,
				"serviceUsers" : serviceUsersArr,
				"projectId" : $("#projectId").val(),
				"companyName" : $('#companyName').val(),
				"projectName" : $("#projectId option:selected").text(),
				"remark" : mRemark,
				"isChecked" : isChecked,
				"serviceEndDate" : mServiceEndDate	
		}
		post("editCaseRecord",params,true);
		if(requestReturn.result == "error"){
			alert(requestReturn.error);
			closeLoading();
		}else if(parseInt(requestReturn.code)==0){
			isSuccess = true;
		}else {
			if (type == 0) {
				isSuccess = true;
			} else if (type == 1) {
				alert("审核失败");
				closeLoading();
			} else {
				alert("派工失败");
				closeLoading();
			}
		}
		return isSuccess;
	}

	function getProjectList(tCompanyId, tProjectId) {
		var params = {
			"companyId" : tCompanyId,
			"projectName" : "",
			"salesId" : 0,
			"projectType" : 0,
			"productStyle" : 0,
			"isFmlkShare" : isFmlkShare
		}
		get("projectList", params, false)
		if (requestReturn.result == "error") {
			alert(requestReturn.error);
		} else {
			var data = requestReturn.data.projectList;
			var str = '<option value="0">请选择...</option>';
			for ( var i in data) {
				var disableSelect = data[i].projectState > 2;
				if (!disableSelect && data[i].endDate != "") {
					disableSelect = (new Date(data[i].endDate).getTime() - new Date()
							.getTime())
							/ (3600 * 1000) <= 0
				}
				if (disableSelect) {
					str += '<option value="' + data[i].projectId + '" disabled>'
							+ data[i].projectName + '</option>';
				} else {
					str += '<option value="' + data[i].projectId + '">'
							+ data[i].projectName + '</option>';
				}

			}
			$("#projectId").empty();
			$("#projectId").append(str);
			$("#projectId").find('option[value="' + tProjectId + '"]').attr(
					"selected", true);
		}
	}

	function toPage() {
		toProjectCaseListPage(type);
	}
	
	function loading() {
		$('body').loading({
			loadingWidth : 240,
			title : '请稍等!',
			name : 'test',
			discription : '提交中',
			direction : 'column',
			type : 'origin',
			originDivWidth : 40,
			originDivHeight : 40,
			originWidth : 6,
			originHeight : 6,
			smallLoading : false,
			loadingMaskBg : 'rgba(0,0,0,0.2)'
		});
	}

	function closeLoading() {
		removeLoading('test');
	}
</script>

</head>
<body>
	<div id="pageAll">
		<div class="pageTop">
			<div class="page">
				<img src="${pageContext.request.contextPath}/image/coin02.png" /><span><a
					href="#">首页</a>&nbsp;-&nbsp;<a href="#">派工管理</a>&nbsp;-</span><span
					style="margin-left: 5px" id="span_title2"></span>
			</div>
		</div>

		<div class="page">
			<div class="banneradd bor">
				<div class="baTopNo">
					<span id="span_title1"></span>
				</div>
				<div class="baBody">
					<div class="bbD">
						<span class="need">*</span><label style="margin-left: 0px">客户名称：</label><input
							type="text" class="input3" id="companyName" disabled="disabled"
							style="width: 786px; background-color: #EEE" />
					</div>
					<div class="bbD">
						<span class="need">*</span><label style="margin-left: 0px">项目名称：</label><select
							class="selCss" id="projectId" style="width: 340px;"
							onChange="changeProject(this.options[this.options.selectedIndex].value)"></select>
						<span class="need" style="margin-left: 15px">*</span><label
							style="margin-left: 0px">销售人员：</label><select class="selCss"
							id="salesId" style="width: 330px;" disabled></select>
					</div>

					<div class="bbD">
						<span class="need">*</span><label style="margin-left: 0px">客户联系人：</label><select
							class="selCss" id="contactUsers" multiple="multiple"
							style="width: 327px;"></select><span class="need"
							style="margin-left: 17px">*</span><label style="margin-left: 0px">客户服务时间：</label>
						<input class="input3" type="text" id="serviceDate"
							onfocus="this.blur();" style="width: 284px" />
					</div>

					<div class="bbD">
						<span class="need">*</span><label style="margin-left: 0px">派工类别：</label><select
							class="selCss" id="projectState"
							style="width: 150px; background-color: #EEE" disabled="disabled">
						</select><label style="margin-left: 15px"></label><select class="selCss"
							id="caseType" style="width: 162px;" disabled></select><span
							class="need" style="margin-left: 17px">*</span><label
							style="margin-left: 0px">服务级别：</label><select class="selCss"
							id="serviceType" style="width: 332px;"></select>
					</div>

					<div class="bbD" style="margin-top: 20px">
						<label style="float: left; margin-left: 15px">上传附件：</label><input
							type="file" name="myfile" id="myfile"
							style="width: 335px; border: none; float: left"
							accept="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet, application/vnd.ms-excel,application/vnd.ms-powerpoint,application/msword,image/*,application/pdf,application/x-zip-compressed,application/x-rar-compressed,.docx,.rar" />
						<div id="progressDiv"
							style="width: 430px; height: 20px; background-color: gray; margin-left: 20px; float: left; display: none">
							<span id="progress"
								style="display: inline-block; height: 20px; background-color: orange; line-height: 20px"></span>
						</div>
						<br />
					</div>
					<div class="bbD" id="upFileDiv"
						style="margin-top: 20px; display: none">
						<label style="float: left; margin-left: 15px">已上传附件：</label>
						<table id="filelist" style="height: auto;">
						</table>
					</div>
					<div class="bbD" style="margin-top: 20px">
						<span class="need" style="float: left">*</span><label
							style="float: left; margin-left: 0px">要求服务内容：</label>
						<textarea class="input3" id="serviceContent"
							style="width: 760px; resize: none; height: 80px;"></textarea>
					</div>

					<div class="bbD" style="margin-bottom: 30px;">
						<label style="margin-left: 12px; float: left;">设备型号数量：</label>
						<textarea class="input3" id="deviceInfo"
							style="width: 760px; resize: none; height: 80px;"></textarea>
					</div>


					<div class="bbD" id="checkDiv"
						style="display: none; margin-bottom: 30px;">
						<label><strong style="font-size: 20px; margin-left: 0px;">审核结果：</strong></label>
						<input type="radio" name="field02" id="checkResult" value="1"
							checked="checked" onclick="selCheckResult(1)" /><label
							style="margin-right: 50px; margin-left: 5px;">通过</label><input
							type="radio" name="field02" id="checkResult" value="2"
							onclick="selCheckResult(2)" /><label
							style="margin-left: 5px; color: red">驳回</label>
					</div>

					<div class="bbD" id="serviceUserDiv"
						style="margin-bottom: 30px; display: none;">
						<span class="need" style="margin-left: 15px">*</span><label
							style="margin-left: 0px;">服务工程师：</label><select class="selCss"
							id="serviceUsers" multiple="multiple" style="width: 786px;"></select>

					</div>

					<div class="bbD" id="remarkDiv"
						style="margin-bottom: 30px; display: none;">
						<label style="margin-left: 68px; color: red">备注：</label> <input
							type="text" class="input3" id="remark" style="width: 776px;" />
					</div>

					<div class="bbD" id="reasonDiv"
						style="margin-bottom: 30px; display: none;">
						<span class="need" style="margin-left: 15px">*</span><label
							style="margin-left: 0px">驳回理由：</label><input class="input3"
							id="reasonForReject" style="width: 776px; font-weight: bold;"></input>
					</div>


					<div class="cfD"
						style="margin-bottom: 30px; margin-top: 30px; display: none"
						id="operation">
						<a class="addA" href="#" onclick="editProjectCase()"
							style="margin-left: 125px" id="okclick">重新提审</a> <a class="addA"
							href="#" onclick="toPage()">返回</a>
					</div>

				</div>

			</div>
		</div>


	</div>

</body>
</html>