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
<title>新建派工单</title>
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/loading.css?v=2">
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/animate.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/select4.css?v=1999" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/css.css?v=1997" />
<%-- <link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/flatpickr.material_blue.min.css"> --%>
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/material_blue.css">
<link rel="stylesheet" type="text/css"
	href="https://npmcdn.com/flatpickr/dist/ie.css">
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.2.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/select3.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/flatpickr_v3.js?v=1999"></script>
<script src="${pageContext.request.contextPath}/js/checkPermission.js"></script>
<script src="${pageContext.request.contextPath}/js/changePsd.js"></script>
<script src="${pageContext.request.contextPath}/js/commonUtils.js?v=1"></script>
<script
	src="${pageContext.request.contextPath}/js/getObjectList.js?v=100"></script>
<script src="${pageContext.request.contextPath}/js/request.js?v=5"></script>
<script src="${pageContext.request.contextPath}/js/getObject.js"></script>
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
	var chunks;
	var sliceSize;
	var currentChunk;
	var caseId;
	var isPermissionView;
	var sId;
	var host;
	var isFmlkShare;
	var requestReturn;

	$(document).ready(function() {
		sId = "${sessionId}";
		host = "${pageContext.request.contextPath}";
		checkViewPremission(22);
	});

	function initialPage() {
		isFmlkShare = false;
		document.getElementById("serviceDate").flatpickr({
			defaultDate : "",
			minuteIncrement : 30,
			mode : "range",
			enableTime : true,
			dateFormat : "Y-m-d H:i",
			time_24hr : true,
			onChange : function(dateObj, dateStr) {
			}
		});
		getCompanyList("", 0, 0, 1, isFmlkShare);
		getSalesList(0);
		//派工类别
		getProjectStateList(0);
		getCaseTypeList(0);
		//服务级别
		getServiceTypeList(0);
		$("#companyId").select2({});
		$("#salesId").select2({});
		$("#caseType").select2({});
		$("#projectState").select2({});
		$("#serviceType").select2({});
		$("#contactUsers").select2({
			placeholder : "请选择..."
		});
		$("#projectId").select2({});
		sliceSize = 1 * 1024 * 1024;
	}

	function changeCompany(tCompanyId) {
		if (tCompanyId != 0) {
			getSalesList(getCompany("companyId", tCompanyId).salesId);
			getMultiContactUsersList(tCompanyId, null);
			getProjectList(tCompanyId, 0);
		} else {
			getSalesList(0);
			$("#contactUsers").empty();
			$("#projectId").empty();
		}
	}

	function changeProject(tProjectId) {
		if (tProjectId != 0) {
			var project = getProject("projectId", tProjectId);
			getProjectStateList(project.projectState);
		} else {
			getProjectStateList(0);
		}
	}

	function createProjectCase() {
		if (!isPermissionView) {
			alert("你没有权限新建项目");
			return;
		}
		var projectId = $("#projectId").val();
		var mSalesId = $("#salesId").val();
		var contactUsersArr = new Array();
		$("#contactUsers option:selected").each(function() {
			contactUsersArr.push($(this).val());
		});
		var tprojectState = $("#projectState").val();
		var caseType = $("#caseType").val();
		var serviceDate = $("#serviceDate").val().trim();
		var serviceType = $("#serviceType").val();
		var serviceContent = $("#serviceContent").val().trim();
		var deviceInfo = $("#deviceInfo").val().trim();
		var companyId = $("#companyId").val()

		if (companyId == 0) {
			alert("请选择客户名称");
			return;
		}
		if (projectId == null || projectId == 0) {
			alert("请选择项目名称");
			return;
		}

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
		} else {
			var timeStart = serviceDate.split("to")[0].replace(/-/g, "/")
					.trim();
			var timeEnd = serviceDate.split("to")[1].replace(/-/g, "/").trim();
			if (new Date(timeEnd).getTime() - new Date(timeStart).getTime() <= 0) {
				alert("客户服务时间有误,请重新选择");
				return;
			}
		}

		if (caseType == 0) {
			alert("请选择派工类别");
			return;
		} else {
			caseType = tprojectState + "#" + caseType;
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
		if (myFile != undefined) {
			if (myFile.size > 3 * 1024 * 1024 * 1024) {
				alert("上传附件大小不能大于3GB");
				return;
			}
			if (!checkFileExist(myFile.name, projectId)) {
				loading();
				chunks = Math.ceil(myFile.size / sliceSize);
				$("#progressDiv").show();
				currentChunk = 0;
				doUploadFile(myFile, mSalesId, projectId, contactUsersArr,
						timeStart, caseType, serviceType, serviceContent,
						deviceInfo, timeEnd);
			} else {
				alert("该项目有同文件名的附件已上传，请修改文件名");
				return;
			}
		} else {
			loading();
			setTimeout(function() {
				//保存派工单
				var result = createCaseRecord(projectId, mSalesId, contactUsersArr,
						timeStart, caseType, serviceType, serviceContent,
						deviceInfo, timeEnd);
				if (result) {
					alert("提交成功");
					parent.leftFrame.initialPage();
					setTimeout(function() {
						closeLoading();
						toProjectCaseListPage(0);
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
		get("queryUploadFile", params, false);
		if (requestReturn.result == "error") {
			alert(requestReturn.error);
		} else {
			var data = requestReturn.data.fileList;
			for (var i = 0; i < data.length; i++) {
				var path = data[i].path;
				var tFileName = path.substring(path.lastIndexOf("\/") + 1,
						path.length);
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
			mDeviceInfo, mServiceEndDate) {
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
			formData.append('projectName', $("#projectId option:selected")
					.text());
			formData.append('companyName', $('#companyId option:selected')
					.text());
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
								mServiceEndDate);
					} else {
						alert("上传文件错误，错误信息：" + info);
						closeLoading();
					}
				}
			}
		} else {
			setTimeout(function() {
				var result = createCaseRecord(mProjectId, mUserId,
						mContactUsersArr, mServiceDate, mCaseType,
						mServiceType, mServiceContent, mDeviceInfo,
						mServiceEndDate);
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
		post("createProjectReport", params, false);
		if (requestReturn.result == "error") {
			alert(requestReturn.error);
			closeLoading()
		} else if (parseInt(requestReturn.code) == 0) {
			alert("提交成功");
			parent.leftFrame.initialPage();
			setTimeout(function() {
				closeLoading();
				parent.leftFrame.initialPage();
				toProjectCaseListPage(0);
			}, 500);
		} else {
			alert("写入附件信息失败");
			closeLoading()
		}
	}

	function createCaseRecord(projectId, mSalesId, contactUsersArr,
			serviceDate, caseType, serviceType, serviceContent, deviceInfo,
			serviceEndDate) {
		var isSuccess = false;
		var params = {
			"projectId" : projectId,
			"salesId" : mSalesId,
			"arrayContact" : contactUsersArr,
			"serviceDate" : serviceDate,
			"caseType" : caseType,
			"serviceType" : serviceType,
			"serviceContent" : serviceContent,
			"deviceInfo" : deviceInfo,
			"companyName" : $('#companyId option:selected').text(),
			"projectName" : $("#projectId option:selected").text(),
			"serviceEndDate" : serviceEndDate
		}
		post("createProjectCase", params, true);
		if (requestReturn.result == "error") {
			alert(requestReturn.error);
			closeLoading();
		} else if (parseInt(requestReturn.code) == 0) {
			caseId = requestReturn.data.caseId;
			isSuccess = true;
		} else if (parseInt(requestReturn.code) == 3) {
			alert("新建派工单失败,请勿重复派工");
			closeLoading();
		} else {
			alert("新建派工单失败,错误编号:" + requestReturn.code);
			closeLoading();
		}
		return isSuccess;
	}

	function getProjectList(companyId, index) {
		var params = {
			"companyId" : companyId,
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
		}
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
<body id="body" style="display: none">
	<div id="pageAll">
		<div class="pageTop">
			<div class="page">
				<img src="../image/coin02.png" /><span><a href="#">首页</a>&nbsp;-&nbsp;<a
					href="#">派工管理</a>&nbsp;-</span>&nbsp;新建派工单
			</div>
		</div>

		<div class="page">
			<div class="banneradd bor">
				<div class="baTopNo">
					<span>派工基本信息</span>
				</div>
				<div class="baBody">
					<div class="bbD">
						<span class="need">*</span><label style="margin-left: 0px">客户名称：</label><select
							class="selCss" id="companyId"
							style="width: 792px; margin-right: 10px;"
							onChange="changeCompany(this.options[this.options.selectedIndex].value)" /></select>

					</div>

					<div class="bbD">
						<span class="need">*</span><label style="margin-left: 0px">项目名称：</label><select
							class="selCss" id="projectId"
							style="width: 340px; margin-right: 10px;"
							onChange="changeProject(this.options[this.options.selectedIndex].value)"></select><span
							class="need" style="margin-left: 15px">*</span><label
							style="margin-left: 0px">销售人员：</label><select class="selCss"
							id="salesId" style="width: 340px; margin-right: 10px;"></select>
					</div>

					<div class="bbD">
						<span class="need">*</span><label style="margin-left: 0px">客户联系人：</label><select
							class="selCss" id="contactUsers" multiple="multiple"
							style="width: 325px;"></select><span class="need"
							style="margin-left: 15px">*</span><label style="margin-left: 0px">客户服务时间：</label>
						<input class="input3" type="text" id="serviceDate"
							onfocus="this.blur();" style="width: 300px" />
					</div>

					<div class="bbD">
						<span class="need">*</span><label style="margin-left: 0px">派工类别：</label><select
							class="selCss" id="projectState"
							style="width: 150px; background-color: #eee" disabled="disabled">
						</select><label style="margin-left: 15px"></label><select class="selCss"
							id="caseType" style="width: 160px;"></select><span class="need"
							style="margin-left: 15px">*</span><label style="margin-left: 0px">服务级别：</label><select
							class="selCss" id="serviceType" style="width: 340px;">
						</select>
						<!-- <label style="margin-left: 25px">服务时长：</label>
						<select
							class="selCss" id="casePeriod" style="width: 110px;" disabled>
						</select>
						<input type="text" class="input3" id="casePeriod"
							style="width: 104px; background-color: #EEE" disabled="disabled" /> -->
					</div>

					<div class="bbD">
						<label style="float: left">上传附件：</label><input type="file"
							name="myfile" id="myfile"
							style="width: 335px; border: none; float: left"
							accept="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet, application/vnd.ms-excel,application/vnd.ms-powerpoint,application/msword,image/*,application/pdf,application/x-zip-compressed,application/x-rar-compressed,.docx,.rar" />
						<div id="progressDiv"
							style="width: 430px; height: 20px; background-color: gray; margin-left: 20px; float: left; display: none">
							<span id="progress"
								style="display: inline-block; height: 20px; background-color: orange; line-height: 20px"></span>
						</div>
						<br />
					</div>

					<div class="bbD">
						<span class="need" style="margin-left: -25px; float: left">*</span><label
							style="margin-left: -12px; float: left">要求服务内容：</label>
						<textarea class="input3" id="serviceContent"
							style="width: 776px; resize: none; height: 80px;"></textarea>
					</div>

					<div class="bbD">
						<label style="margin-left: -12px; float: left">设备型号数量：</label>
						<textarea class="input3" id="deviceInfo"
							style="width: 776px; resize: none; height: 80px;"></textarea>
					</div>

					<div class="cfD" style="margin-bottom: 30px; margin-top: 30px"
						id="operation">
						<a class="addA" href="#" onclick="createProjectCase()"
							style="margin-left: 100px">提审</a> <a class="addA" href="#"
							onclick="toIndexPage()">关闭</a>
					</div>
				</div>
			</div>
		</div>


	</div>

</body>
</html>