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
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/select4.css?v=1999" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/css.css?v=1997" />
<%-- <link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/flatpickr.material_blue.min.css"> --%>
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/material_blue.css">
<link rel="stylesheet" type="text/css" href="https://npmcdn.com/flatpickr/dist/ie.css">
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.2.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/select3.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/flatpickr_v3.js?v=1999"></script>
<script src="${pageContext.request.contextPath}/js/checkPermission.js"></script>
<script src="${pageContext.request.contextPath}/js/changePsd.js"></script>
<script src="${pageContext.request.contextPath}/js/commonUtils.js"></script>
<script src="${pageContext.request.contextPath}/js/getObjectList.js?v=100"></script>
<style type="text/css">
a:hover {
	color: #FF00FF
} /* 鼠标移动到链接上 */
</style>
<script type="text/javascript">
	var salesId;
	var chunks;
	var sliceSize;
	var currentChunk;
	var caseId;
	var isPermissionView;
	var sId;
	var host;
	var isFmlkShare;

	$(document).ready(function() {
		sId = "${sessionId}";
		host = "${pageContext.request.contextPath}";
		checkViewPremission(22);
	});

	function initialPage() {
		isFmlkShare = false;
		document.getElementById("serviceDate").flatpickr({
			//defaultDate : formatDate(new Date()),
			minuteIncrement : 30,
			mode: "range",
			enableTime: true,
			dateFormat: "Y-m-d H:i",
			time_24hr:true,
			onChange : function(dateObj, dateStr) {

			}
		});
		getProjectStateList(0);
		getCompanyList("", 0, 0, 1,isFmlkShare);
		getSalesList(0);
		getCaseTypeList(0);
		getServiceTypeList(0);
        getCasePeriodList(0);
		$("#companyId").select2({});
		$("#salesId").select2({});
		$("#caseType").select2({});
		$("#serviceType").select2({});
		$("#casePeriod").select2({});
		$("#contactUsers").select2({
			placeholder : "请选择..."
		});
		$("#projectId").select2({});
		$("#projectState").select2({});
		sliceSize = 1 * 1024 * 1024;
	}

	function changeCompany(tCompanyId) {
		salesId = getSalesByCompanyId(tCompanyId).salesId;
		getSalesList(salesId);
		getMultiContactUsersList(tCompanyId, null);
		getProjectList(tCompanyId, 0,isFmlkShare);
	}

	function getSalesByCompanyId(companyId) {
		var mSales;
		$.ajax({
			url : host + "/getCompanyByCompanyId",
			type : 'GET',
			data : {
				"companyId" : companyId
			},
			cache : false,
			async : false,
			success : function(returndata) {
				mSales = eval("(" + returndata + ")").company[0];
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
		return mSales;
	}

	function changeProject() {
		$.ajax({
			url : host + "/getProjectByProjectId",
			type : 'GET',
			data : {
				"projectId" : $("#projectId").val()
			},
			cache : false,
			async : false,
			success : function(returndata) {
				var data = eval("(" + returndata + ")").project;
				getProjectStateList(data[0].projectState);
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
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
		var casePeriod = $("#casePeriod").val();
		
		if (projectId == undefined) {
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
		
		
		if(serviceDate == ""){
			alert("客户服务时间不能为空");
			return;
		}
		
		var timeStart = serviceDate.split("to")[0].replace(/-/g, "/").trim();
		var timeEnd = serviceDate.split("to")[1].replace(/-/g, "/").trim();
        var timeDiff = (new Date(timeEnd).getTime()-new Date(timeStart).getTime())/(3600*1000);
        
    //    alert(timeDiff);
        
        if(timeDiff<=0){
        	alert("客户服务时间有误");
			return;
        }else if(timeDiff<=6){
        	timeDiff = 0.5
        }else{
        	timeDiff = Math.ceil(timeDiff/24);
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

		if (casePeriod == 0) {
			alert("请选择服务时长");
			return;
		}else if(casePeriod != timeDiff){
			alert("客户服务时间段与服务时长不一致");
			return;
		}
		
		serviceDate = timeStart;
		var serviceEndDate = timeEnd;

		if (serviceContent == "") {
			alert("请输入服务内容");
			return;
		}

		//return;
		var myFile = document.getElementById("myfile").files[0];
		if (myFile != undefined && myFile.size > 3 * 1024 * 1024 * 1024) {
			alert("单个文件上传不能大于3GB");
			return;
		}

		if (myFile != undefined) {
			//先检查是否有同文件名的文件
			if (!checkFileExist(myFile.name, projectId)) {
				chunks = Math.ceil(myFile.size / sliceSize);
				$("#progressDiv").show();
				currentChunk = 0;
				doUploadFile(myFile, mSalesId, projectId, contactUsersArr,
						serviceDate, caseType, serviceType, serviceContent,
						deviceInfo, casePeriod,serviceEndDate);
			} else {
				alert("该项目有相同文件名的附件已上传，请修改文件名");
				return;
			}
		} else {
			//保存派工单
			var result = createCaseRecord(projectId, mSalesId, contactUsersArr,
					serviceDate, caseType, serviceType, serviceContent,
					deviceInfo, casePeriod,serviceEndDate);
			if (result) {
				alert("提交成功");
		    	parent.leftFrame.initialPage();
				setTimeout(function() {
					location.reload();
				}, 500);
			}
		}
	}

	//检查文件服务器相同文件是否存在
	function checkFileExist(fileName, projectId) {
		var isExist = false;
		$.ajax({
			url : host + "/queryUploadFile",
			type : 'GET',
			data : {
				"createYear" : "",
				"projectId" : projectId,
				"reportType" : 99
			},
			cache : false,
			async : false,
			success : function(returndata) {
				var data = eval("(" + returndata + ")").fileList;
				for (var i = 0; i < data.length; i++) {
					var path = data[i].path;
					var tFileName = path.substring(path.lastIndexOf("\/") + 1,
							path.length);
					if (fileName == tFileName) {
						isExist = true;
						break;
					}
				}
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
		return isExist;
	}

	function doUploadFile(mFile, mUserId, mProjectId, mContactUsersArr,
			mServiceDate, mCaseType, mServiceType, mServiceContent,
			mDeviceInfo, mCasePeriod,mServiceEndDate) {
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
			formData.append('companyName', $('#companyId option:selected').text());
			
			var xhr = new XMLHttpRequest();
			xhr.open("POST", host + "/addProjectReport");
			xhr.send(formData);
			xhr.onreadystatechange = function() {
				if (xhr.readyState == 4) {
				//	alert(eval("(" + xhr.responseText + ")"));
					var errcode = eval("(" + xhr.responseText + ")").errcode;
					var info = eval("(" + xhr.responseText + ")").info;
					if (errcode == 0) {
						upDateProgress(currentChunk);
						currentChunk++;
						doUploadFile(mFile, mUserId, mProjectId,
								mContactUsersArr, mServiceDate, mCaseType,
								mServiceType, mServiceContent, mDeviceInfo,
								mCasePeriod,mServiceEndDate);
					} else {
						alert("上传文件错误，错误信息：" + info);

					}
				}
			}
		} else {
			setTimeout(
					function() {
						var result = createCaseRecord(mProjectId, mUserId,
								mContactUsersArr, mServiceDate, mCaseType,
								mServiceType, mServiceContent, mDeviceInfo,
								mCasePeriod,mServiceEndDate);
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
		$.ajax({
			url : host + "/createProjectReport",
			type : 'POST',
			data : {
				"contactDate" : "",
				"userId" : mUserId,
				"reportDesc" : "",
				"projectId" : mProjectId,
				"reportType" : 99,
				"fileName" : mFileName,
				"caseId" : caseId
			},
			cache : false,
			async : false,
			success : function(returndata) {
				var data = eval("(" + returndata + ")").errcode;
				if (data == 0) {
					alert("提交成功");
					parent.leftFrame.initialPage();
					setTimeout(function() {
						location.reload();
					}, 500);
					
					
				} else {
					alert("写入附件信息失败");
				}
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
	}

	function createCaseRecord(projectId, mSalesId, contactUsersArr,
			serviceDate, caseType, serviceType, serviceContent, deviceInfo,
			casePeriod,serviceEndDate) {
		var isSuccess = false;
		$.ajax({
			url : host + "/createProjectCase",
			type : 'POST',
			cache : false,
			dataType : "json",
			async : false,
			data : {
				"projectId" : projectId,
				"salesId" : mSalesId,
				"arrayContact" : contactUsersArr,
				"serviceDate" : serviceDate,
				"caseType" : caseType,
				"serviceType" : serviceType,
				"serviceContent" : serviceContent,
				"deviceInfo" : deviceInfo,
				"casePeriod" : casePeriod,
				"companyName" : $('#companyId option:selected').text(),
				"projectName" : $("#projectId option:selected").text(),
				"serviceEndDate":serviceEndDate
			},
			traditional : true,
			success : function(returndata) {
				var data = returndata.errcode;
				if (data == 0) {
					caseId = returndata.caseId;
					isSuccess = true;
				} else {
					alert("新建派工单失败");
				}
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
		return isSuccess;
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
						<label>客户名称：</label><select class="selCss" id="companyId"
							style="width: 780px; margin-right: 10px;"
							onChange="changeCompany(this.options[this.options.selectedIndex].value)" /></select>

					</div>

					<div class="bbD">
						<label>项目名称：</label><select class="selCss" id="projectId"
							style="width: 340px; margin-right: 10px;"
							onChange="changeProject()"></select><label
							style="margin-left: 15px">销售人员：</label><select class="selCss"
							id="salesId" style="width: 340px; margin-right: 10px;"></select>
					</div>

					<div class="bbD">
						<label style="margin-left: 0px">客户联系人：</label><select
							class="selCss" id="contactUsers" multiple="multiple"
							style="width: 340px;"></select><label style="margin-left: 15px">客户服务时间：</label>
						<input class="input3" type="text" id="serviceDate"
							onfocus="this.blur();" style="width: 300px" />
					</div>

					<div class="bbD">
						<label>派工类别：</label><select class="selCss" id="projectState"
							style="width: 150px; background-color: #eee" disabled="disabled">
						</select><label style="margin-left: 15px"></label><select class="selCss"
							id="caseType" style="width: 160px;"></select><label
							style="margin-left: 15px">服务级别：</label><select class="selCss"
							id="serviceType" style="width: 110px;">
						</select> <label style="margin-left: 25px">服务时长：</label> <select
							class="selCss" id="casePeriod" style="width: 110px;">
						</select>
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
						<label style="margin-left: -15px; float: left">要求服务内容：</label>
						<textarea class="input3" id="serviceContent"
							style="width: 776px; resize: none; height: 80px;"></textarea>
					</div>

					<div class="bbD">
						<label style="margin-left: -15px; float: left">设备型号数量：</label>
						<textarea class="input3" id="deviceInfo"
							style="width: 776px; resize: none; height: 80px;"></textarea>
					</div>

					<div class="cfD" style="margin-bottom: 30px; margin-top: 30px">
						<a class="addA" href="#" onclick="createProjectCase()"
							style="margin-left: 95px">提交</a> <a class="addA" href="#"
							onclick="toIndexPage()">关闭</a>
					</div>
				</div>
			</div>
		</div>


	</div>

</body>
</html>