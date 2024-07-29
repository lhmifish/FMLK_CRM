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
<%-- <script type="text/javascript"
	src="${pageContext.request.contextPath}/js/flatpickr.js"></script> --%>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/flatpickr_v3.js"></script>
<script src="${pageContext.request.contextPath}/js/checkPermission.js"></script>
<script src="${pageContext.request.contextPath}/js/changePsd.js"></script>
<script src="${pageContext.request.contextPath}/js/commonUtils.js"></script>
<script src="${pageContext.request.contextPath}/js/getObjectList.js"></script>

<style type="text/css">
a:hover {
	color: #FF00FF
} /* 鼠标移动到链接上 */
</style>

<script type="text/javascript">
	var id;//projectCase_id
	var type;//0.编辑1.销审2.技审
	var host;
	var checkResult;
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
	var isChecked;

	$(document).ready(function() {
		id = "${mId}";
		type = "${type}";
	    sId = "${sessionId}";
		host = "${pageContext.request.contextPath}";
		checkEditPremission2(23, 25, 26);
	});

	function initialPage() {
		document.getElementById("serviceDate").flatpickr({
			minuteIncrement : 30,
			mode: "range",
			enableTime: true,
			dateFormat: "Y-m-d H:i",
			time_24hr:true,
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
		$("#casePeriod").select2({});
		$("#serviceType").select2({});
		$("#serviceUsers").select2({
			placeholder : "请选择..."
		});
		sliceSize = 1 * 1024 * 1024;
	}

	function getProjectCaseInfo(tid) {
		$.ajax({
			url : host + "/getProjectCase",
			type : 'GET',
			cache : false,
			async : false,
			data : {
				"id" : tid
			},
			success : function(returndata) {
				var data = eval("(" + returndata + ")").projectCase;
				$("#companyName")
						.val(getCompany(data[0].projectId).companyName);
				getSalesList(data[0].salesId);
				salesId = data[0].salesId;
				var companyId = getCompany(data[0].projectId).companyId;
				getProjectList(companyId, data[0].projectId);
				$("#projectIdNum").val(data[0].projectId);
				
				if(data[0].serviceEndDate==""||data[0].serviceEndDate==null){
				    $('#serviceDate').val(data[0].serviceDate+" to "+data[0].serviceDate);
				}else{
					$('#serviceDate').val(data[0].serviceDate+" to "+data[0].serviceEndDate);
				}
				getMultiContactUsersList(companyId, data[0].contactUsers
						.split(","));
				getProjectStateList(data[0].caseType.split("#")[0]);
				getCaseTypeList(data[0].caseType.split("#")[1]);
				getServiceTypeList(data[0].serviceType);
				getCasePeriodList(data[0].casePeriod);
				$('#serviceContent').val(data[0].serviceContent);
				$('#deviceInfo').val(data[0].deviceInfo);
				caseId = data[0].caseId;
				getProjectCaseUploadFile(caseId, data[0].projectId);
				var isRejected = data[0].isRejected;
				isChecked = data[0].isChecked;
				checkResult = 1;
				if (type == 2) {
					$("#checkDiv").show();
					$("#serviceUserDiv").show();
					$("#remarkDiv").show();
					getMultiServiceUsersList(null);
					$("#remark").val("");
				} else if (type == 1) {
					$("#checkDiv").show();
				} else if (isChecked) {
					$("#checkDiv").show();
					$("input[name='field02']").attr("disabled", "disabled");
					if (isRejected) {
						selCheckResult(2);
						$("input[name='field02'][value='" + checkResult + "']")
								.attr("checked", true);
						$("#reasonForReject").val(data[0].rejectReason);
						$('#reasonForReject').attr("disabled", "disabled");
						$('#reasonForReject').css("background-color", "#EEE");
					} else {
						selCheckResult(1);
						$("input[name='field02'][value='" + checkResult + "']")
								.attr("checked", true);
						getMultiServiceUsersList(data[0].serviceUsers.split(","));
						$('#serviceUsers').attr("disabled", "disabled");
						$('#serviceUsers').css("background-color", "#EEE");
						$("#remark").val(data[0].remark);
						$('#remark').attr("disabled", "disabled");
						$('#remark').css("background-color", "#EEE");
						$('#remark').css("color", "red");
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
		$("#projectIdNum").val($("#projectId").val());
	}

	function selCheckResult(mSel) {
		checkResult = mSel;
		//只有在审核时才能选择
		if (mSel == 2) {
			//拒绝
			$("#reasonDiv").show();
			$("#serviceUserDiv").hide();
			$("#remarkDiv").hide();
			getMultiServiceUsersList(null);
			$("#remark").val("");
		} else {
			//通过
			$("#reasonDiv").hide();
			$("#reasonForReject").val("");
			if (type != 1) {
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
		var projectId = $("#projectIdNum").val();
		var mSalesId = $("#salesId").val();
		var contactUsersArr = new Array();
		$("#contactUsers option:selected").each(function() {
			contactUsersArr.push($(this).val());
		});
		var serviceDate = $("#serviceDate").val();
		var projectState = $("#projectState").val();
		var caseType = $("#caseType").val();
		var serviceType = $("#serviceType").val();
		var serviceContent = $("#serviceContent").val().trim();
		var deviceInfo = $("#deviceInfo").val().trim();
		var rejectReason = $("#reasonForReject").val().trim();
		var casePeriod = $("#casePeriod").val();
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
		
		if(serviceDate == ""){
			alert("客户服务时间不能为空");
			return;
		}
		
		var timeStart = serviceDate.split("to")[0].replace(/-/g, "/").trim();
		var timeEnd = serviceDate.split("to")[1].replace(/-/g, "/").trim();
        var timeDiff = (new Date(timeEnd).getTime()-new Date(timeStart).getTime())/(3600*1000);
        
        //alert(timeDiff);
        
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
			caseType = projectState + "#" + caseType;
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

		var myFile = document.getElementById("myfile").files[0];
		if (myFile != undefined && myFile.size > 3 * 1024 * 1024 * 1024) {
			alert("单个文件上传不能大于3GB");
			return;
		}

		if (checkResult == 2 && rejectReason == "") {
			alert("请填写拒绝理由");
			return;
		}

		if (checkResult == 1 && serviceUsersArr.length == 0 && type == 2) {
			alert("请选择服务工程师");
			return;
		}

		if (myFile != undefined) {
			if (!checkFileExist(myFile.name, projectId)) {
				chunks = Math.ceil(myFile.size / sliceSize);
				$("#progressDiv").show();
				currentChunk = 0;
				doUploadFile(myFile, mSalesId, projectId, contactUsersArr,
						serviceDate, caseType, serviceType, serviceContent,
						deviceInfo, rejectReason, serviceUsersArr, casePeriod,remark,serviceEndDate);
			} else {
				alert("该派工有相同文件名的附件已上传，请修改文件名");
				return;
			}
		} else {
			//无附件,保存派工单
			var result = editCaseRecord(mSalesId, contactUsersArr, serviceDate,
					caseType, serviceType, serviceContent, deviceInfo,
					rejectReason, serviceUsersArr, casePeriod,remark,serviceEndDate);
			if (result) {
				if (type == 0) {
					alert("编辑派工单成功");
				} else if(type == 1){
					alert("派工单已审核");
				}else {
					alert("派工已完成");
				}
				parent.leftFrame.initialPage();
				setTimeout(
						function() {
							toProjectCaseListPage();
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
			mDeviceInfo, mRejectReason, mServiceUsersArr, casePeriod,mRemark,mServiceEndDate) {
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
			xhr.open("POST",
					host + "/addProjectReport");
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
								mRejectReason, mServiceUsersArr, casePeriod,mRemark,mServiceEndDate);
					} else {
						alert("上传文件错误，错误信息：" + info);

					}
				}
			}
		} else {
			setTimeout(function() {
				var result = editCaseRecord(mUserId, mContactUsersArr,
						mServiceDate, mCaseType, mServiceType, mServiceContent,
						mDeviceInfo, mRejectReason, mServiceUsersArr,
						casePeriod,mRemark,mServiceEndDate);
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
		$
				.ajax({
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
							alert("编辑派工单成功");
							parent.leftFrame.initialPage();
							setTimeout(
									function() {
										toProjectCaseListPage();
									}, 500);
						} else {
							alert("写入附件信息失败");
						}
					},
					error : function(XMLHttpRequest, textStatus, errorThrown) {
					}
				});
	}

	function editCaseRecord(mSalesId, contactUsersArr, serviceDate, caseType,
			serviceType, serviceContent, deviceInfo, rejectReason,
			serviceUsersArr, casePeriod,mRemark,mServiceEndDate) {
	//	alert($('#companyName').val());
		var isSuccess = false;
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
				"salesId" : mSalesId,
				"contactUsers" : contactUsersArr,
				"serviceDate" : serviceDate,
				"caseType" : caseType,
				"serviceType" : serviceType,
				"serviceContent" : serviceContent,
				"deviceInfo" : deviceInfo,
				"rejectReason" : rejectReason,
				"serviceUsers" : serviceUsersArr,
				"casePeriod" : casePeriod,
				"projectId" : $("#projectId").val(),
				"companyName" : $('#companyName').val(),
				"projectName" : $("#projectId option:selected").text(),
				"remark":mRemark,
				"isChecked":isChecked,
				"serviceEndDate":mServiceEndDate
			},
			traditional : true,
			success : function(returndata) {
				var data = returndata.errcode;
				if (data == 0) {
					isSuccess = true;
				} else {
					if (type == 0) {
						isSuccess = true;
					} else if(type == 1){
						alert("审核派工失败");
					} else{
						alert("派工失败");
					}

				}
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
		return isSuccess;
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
						<label>客户名称：</label><input type="text" class="input3"
							id="companyName" disabled="disabled"
							style="width: 330px; background-color: #EEE" /><label
							style="margin-left: 15px">销售人员：</label><select class="selCss"
							id="salesId" style="width: 340px;"></select>
					</div>
					<div class="bbD">
						<label>项目名称：</label><select class="selCss" id="projectId"
							style="width: 340px;" onChange="changeProject()"></select><label
							style="margin-left: 15px">项目编号：</label><input class="input3"
							type="text" style="width: 330px; background-color: #EEE"
							id="projectIdNum" disabled="disabled" />
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
							style="width: 150px; background-color: #EEE" disabled="disabled">
						</select><label style="margin-left: 15px"></label><select class="selCss"
							id="caseType" style="width: 150px;"></select><label
							style="margin-left: 25px">服务级别：</label><select class="selCss"
							id="serviceType" style="width: 110px;"></select><label
							style="margin-left: 25px">服务时长：</label><select class="selCss"
							id="casePeriod" style="width: 110px;">
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
					<div class="bbD" id="upFileDiv"
						style="margin-top: 10px; float: left; display: none">
						<label style="float: left; margin-left: 42px">附件：</label>
						<table id="filelist" style="height: auto;">
						</table>
					</div>
					<div class="bbD">
						<label style="margin-left: -15px; float: left; margin-top: 5px;">要求服务内容：</label>
						<textarea class="input3" id="serviceContent"
							style="width: 776px; resize: none; height: 80px; margin-top: 5px"></textarea>
					</div>

					<div class="bbD" style="margin-bottom: 30px;">
						<label style="margin-left: -15px; float: left;">设备型号数量：</label>
						<textarea class="input3" id="deviceInfo"
							style="width: 776px; resize: none; height: 80px;"></textarea>
					</div>


					<div class="bbD" id="checkDiv"
						style="display: none; margin-bottom: 30px;">
						<label><strong
							style="font-size: 20px; margin-left: -28px;">审核结果：</strong></label> <input
							type="radio" name="field02" id="checkResult" value="1"
							checked="checked" onclick="selCheckResult(1)" /><label
							style="margin-right: 50px; margin-left: 5px;">通过</label><input
							type="radio" name="field02" id="checkResult" value="2"
							onclick="selCheckResult(2)" /><label
							style="margin-left: 5px; color: red">拒绝</label>
					</div>

					<div class="bbD" id="serviceUserDiv"
						style="margin-bottom: 30px; display: none;">
						<label style="margin-left: 0px;">服务工程师：</label><select
							class="selCss" id="serviceUsers" multiple="multiple"
							style="width: 786px;"></select>

					</div>
					
					<div class="bbD" id="remarkDiv"
						style="margin-bottom: 30px; display: none;">
						<label style="margin-left: 40px;color:red">备注：</label>
                        <input type="text" class="input3"
							id="remark" style="width: 776px;" />
					</div>

					<div class="bbD" id="reasonDiv"
						style="margin-bottom: 30px; display: none;">
						<label style="margin-left: 15px">拒绝理由：</label><input
							class="input3" id="reasonForReject"
							style="width: 776px; font-weight: bold;"></input>
					</div>


					<div class="cfD"
						style="margin-bottom: 30px; margin-top: 30px; display: none"
						id="operation">
						<a class="addA" href="#" onclick="editProjectCase()"
							style="margin-left: 95px" id="okclick">编辑</a> <a class="addA"
							href="#" onclick="toProjectCaseListPage()">返回</a>
					</div>

				</div>

			</div>
		</div>


	</div>

</body>
</html>