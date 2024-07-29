<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="pragma" content="no-cache" />
<meta http-equiv="cache-control" content="no-cache" />
<title>编辑项目</title>
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/css.css?v=1998" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/select4.css?v=1999" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/showbox.css" />
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/xcConfirm.css?v=2010" />
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/calendar.css" />
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.2.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/select3.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/xcConfirm.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/validation.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/calendar.js"></script>
<script src="${pageContext.request.contextPath}/js/checkPermission.js"></script>
<script src="${pageContext.request.contextPath}/js/changePsd.js"></script>
<script src="${pageContext.request.contextPath}/js/commonUtils.js?v=200"></script>
<script src="${pageContext.request.contextPath}/js/getObjectList.js?v=2024"></script>
<style type="text/css">
a:hover {
	color: #FF00FF
} /* 鼠标移动到链接上 */
</style>
<script type="text/javascript">
	var id;//project_id
	var sId;//sessionId
	var host;
	var projectId;
	var createYear;//项目的创建年份
	var chunks;
	var sliceSize;
	var currentChunk;
	var contactUsersArr;
	var salesBeforeUsersArr;
	var salesAfterUsersArr;
	var salesReportArray;
	var salesBeforeReportArray;
	var salesAfterReportArray;
	var purchaseReportArray;
	var showlist1;
	var showlist2;
	var showlist3;
	var projectState;
	var isPermissionEdit;
	var isPermissionUpload;
	var salesId;//project_salesId
	var userReportType;
	var userId;
	var companyName;
	var isFmlkShare;

	$(document).ready(function() {
		id = "${mId}";
		sId = "${sessionId}";
		host = "${pageContext.request.contextPath}";
		checkEditPremission(13, 0);
	});

	function initialPage() {
		getProjectInfo(id);
		showlist1 = true;
		showlist2 = true;
		showlist3 = true;
		showReportList(1);
		showReportList(2);
		showReportList(3);
		matchEdit("项目");
		
		$("#projectType").select2({});
		$("#productStyle").select2({});
		$("#projectManager").select2({});
		$("#contactUsers").select2({
			placeholder : "请选择..."
		});
		$("#salesBeforeUsers").select2({
			placeholder : "请选择..."
		});
		$("#salesAfterUsers").select2({
			placeholder : "请选择..."
		});
		sliceSize = 1 * 1024 * 1024;
	}

	function getProjectInfo(tid) {
		$.ajax({
			url : host + "/getProject",
			type : 'GET',
			cache : false,
			async : false,
			data : {
				"id" : tid
			},
			success : function(returndata) {
				var data = eval("(" + returndata + ")").project;
				$("#projectName").val(data[0].projectName);
				companyName = getCompany(data[0].companyId).companyName;
				$("#companyId").val(companyName);
				$('#salesName').val(getUser(data[0].salesId).name);
				isFmlkShare = data[0].isFmlkShare;
				if(isFmlkShare){
					$("#managerDiv").hide();
					$("#spanProjectType").hide();
					$("#spanProductStyle").show();
					$("#inputSaleBefore").val("运维实施进展报告");
					$("#inputSaleAfter").val("售后运维进展报告");
					document.getElementById("labelBeforeUsers").innerHTML="运维实施人员：";
					document.getElementById("labelAfterUsers").innerHTML="售后运维人员：";
				}else{
					$("#managerDiv").show();
					$("#spanProductStyle").hide();
					$("#spanProjectType").show();
					$("#inputSaleBefore").val("售前工程师进展报告");
					$("#inputSaleAfter").val("售后工程师进展报告");
					document.getElementById("labelBeforeUsers").innerHTML="售前跟进技术人员：";
					document.getElementById("labelAfterUsers").innerHTML="售后跟进技术人员：";
				}
				
				
				salesId = data[0].salesId;
				getProjectTypeList(data[0].projectType,isFmlkShare);
				getProductStyleList(data[0].productStyle,isFmlkShare);
				if(getUser(salesId).nickName==sId || sId=="super.admin"){
					if(isFmlkShare){
						$('#productStyle').removeAttr("disabled");
					}else{
						$('#projectType').removeAttr("disabled");
					}
				}
				projectState = data[0].projectState;
                if(projectState==0){
                	//售前
                }else if(projectState==1){
                	//实施
                }else if(projectState==2){
                	//售后
                	$("#saleAfterDiv_1").show();
                	$("#saleAfterDiv_2").show();
                	$("#saleAfterDiv_3").show();
                	$("#saleBeforeDiv_3").css("margin-bottom", "0px"); 
                }else{
                	//项目关闭
                	isPermissionEdit=false;
                	$('#projectName').attr("disabled", "disabled");
					$('#projectName').css("background-color", "#EEE");
					$('#contactUsers').attr("disabled", "disabled");
					$('#contactUsers').attr("background-color", "#EEE");
					$('#projectType').attr("disabled", "disabled");
					$('#projectType').attr("background-color", "#EEE");
					$('#productStyle').attr("disabled", "disabled");
					$('#productStyle').attr("background-color", "#EEE");
					$('#projectManager').attr("disabled", "disabled");
					$('#projectManager').attr("background-color", "#EEE");
					$('#salesAfterUsers').attr("disabled", "disabled");
					$('#salesAfterUsers').attr("background-color", "#EEE");
					$('#salesBeforeUsers').attr("disabled", "disabled");
					$('#salesBeforeUsers').attr("background-color", "#EEE");
                }
				contactUsersArr = new Array();
				contactUsersArr = data[0].contactUsers.split(",");
				getMultiContactUsersList(data[0].companyId, contactUsersArr);
				salesBeforeUsersArr = new Array();
				if (data[0].salesBeforeUsers != "") {
					salesBeforeUsersArr = data[0].salesBeforeUsers.split(",");
				}
				salesAfterUsersArr = new Array();
				if (data[0].salesAfterUsers != "") {
					salesAfterUsersArr = data[0].salesAfterUsers.split(",");
				}
				getProjectManagerList(data[0].projectManager,
						salesBeforeUsersArr, salesAfterUsersArr);
				projectId = data[0].projectId;
				createYear = data[0].createDate.substring(0, 4);
				getProjectReportList();
				matchUpload();
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
	}
	
	function getProjectManagerList(mProjectManager, mSalesBeforeUsersArr,
			mSalesAfterUsersArr) {
		var today = formatDate(new Date()).substring(0, 10);
		var xhr = createxmlHttpRequest();
		var dptId;
		if(isFmlkShare){
			dptId = 8;
		}else{
			dptId = 1;
		}
		xhr.open("GET", host + "/userList?date=" + today
				+ "&dpartId=" + dptId + "&name=&nickName=&jobId=&isHide=true", true);
		xhr.onreadystatechange = function() {
			if (this.readyState == 4) {
				var str = '<option value="0">请选择...</option>';
				var str2 = '';
				var data = eval("(" + xhr.responseText + ")").userlist;
				for ( var i in data) {
					str2 += '<option value="' + data[i].UId + '">' + data[i].name
							+ '</option>';
				}
				$("#projectManager").empty();
				$("#projectManager").append(str + str2);
				$("#projectManager")
						.find('option[value="' + mProjectManager + '"]').attr(
								"selected", true);
				if (mSalesBeforeUsersArr != null) {
					$("#salesBeforeUsers").empty();
					$("#salesBeforeUsers").append(str2);
					$('#salesBeforeUsers').val(mSalesBeforeUsersArr).trigger("change");
				}
				if (mSalesAfterUsersArr != null) {
					$("#salesAfterUsers").empty();
					$("#salesAfterUsers").append(str2);
					$('#salesAfterUsers').val(mSalesAfterUsersArr).trigger("change");
				}
			}
		};
		xhr.send();
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

	function getUser(uId) {
		var user;
		$.ajax({
			url : host + "/getUserById",
			type : 'GET',
			data : {
				"uId" : uId
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

	function getProjectReportList() {
		$
				.ajax({
					url : host + "/projectReportList",
					type : 'GET',
					data : {
						"projectId" : projectId
					},
					cache : false,
					async : false,
					success : function(returndata) {
						var data2 = eval("(" + returndata + ")").prList;
						var str1 = "";
						var str2 = "";
						var str3 = "";
						for ( var i in data2) {
							var reportType = data2[i].reportType;
							var str = '<tr><td style="width:95px" class="tdColor3">'
									+ data2[i].contactDate
									+ '</td>'
									+ '<td style="width:80px" class="tdColor3">'
									+ getUser(data2[i].userId).name
									+ '</td>'
									+ '<td style="width:300px" class="tdColor3">'
									+ data2[i].reportDesc
									+ '</td>'
									+ '<td style="width:300px;" class="tdColor3"><div style="width:300px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;">'
									+ '<a href="#" title="'+data2[i].fileName +'" onclick="downloadFile(\''
									+ data2[i].fileName
									+ '\','
									+ reportType
									+ ')" >'
									+ data2[i].fileName
									+ '</a></div></td>'
									+ '<td style="width:95px" class="tdColor3">'
									+ data2[i].createDate.substring(0, 10)
									+ '</td></tr>';
							if (reportType == 1) {
								str1 += str;
							} else if (reportType == 2) {
								str2 += str;
							} else if (reportType == 3) {
								str3 += str;
							}
						}
						var strX = '<tr><td style="color:red;width:874px;height: 20px;" border=0 >没有上传项目报告</td></tr>';
						str1 == "" ? str1 += strX : "";
						str2 == "" ? str2 += strX : "";
						str3 == "" ? str3 += strX : "";
						$("#tb1").empty();
						$("#tb1").append(str1);
						$("#tb2").empty();
						$("#tb2").append(str2);
						$("#tb3").empty();
						$("#tb3").append(str3);
					},
					error : function(XMLHttpRequest, textStatus, errorThrown) {
					}
				});
	}

	function openProjectReportWin(tReportType) {
		if (projectState >= 3) {
			alert("关闭的项目不能上传项目报告");
			return;
		}
		if (isPermissionUpload[tReportType - 1]) {
			if(tReportType==1){
				document.getElementById("reportTitle").innerHTML= "添加销售进展报告";
			}else if(tReportType==2){
				document.getElementById("reportTitle").innerHTML=isFmlkShare? "添加运维实施进展报告":"添加售前工程师进展报告";
			}else{
				document.getElementById("reportTitle").innerHTML=isFmlkShare? "添加售后运维进展报告":"添加售后工程师进展报告";
			}
			userReportType = tReportType;
			getMyUserList(tReportType);
			$('#date').val(formatDate(new Date()).substring(0, 10));
			$('#dd').calendar({
				trigger : '#date',
				zIndex : 999,
				format : 'yyyy/mm/dd',
				onSelected : function(view, date, data) {
				},
				onClose : function(view, date, data) {
					$('#date').val(formatDate(date).substring(0, 10));
				}
			});
			$('#reportDesc').val("");
			$("#progressDiv").hide();
			$("#myfile").val("");
			document.getElementById("progress").style.width = 0;
			document.getElementById("progress").innerHTML = "";
			$('#dd').css("left", "142px");
			$('#dd').css("top", "145px");
			$("#banDel2").show();

		} else {
			var alertText;
			if(tReportType==1){
				alertText = "你没有权限在这里上传销售进展报告";
			}else{
				alertText = isFmlkShare?"你没有权限在这里上传运维报告":"你没有权限在这里上传工程师进展报告";
			}
			alert(alertText);
			return;
		}
	}

	function getMyUserList(mProjectType) {
		var dpartId = 0;
		if (mProjectType == 1) {
			//销售
			dpartId = 2;
		} else if (mProjectType == 2 || mProjectType == 3) {
			if(isFmlkShare){
				//运维
				dpartId = 8;
			}else{
				//技术
				dpartId = 1;
			}
		}

		$.ajax({
			url : host + "/userList",
			type : 'GET',
			data : {
				"dpartId" : dpartId,
				"date" : formatDate(new Date()).substring(0, 10),
				"name" : "",
				"nickName" : "",
				"jobId" : "",
				"isHide" : true
			},
			cache : false,
			async : false,
			success : function(returndata) {
				var str = '<option value="0">请选择...</option>';
				var data2 = eval("(" + returndata + ")").userlist;
				for ( var i in data2) {
					str += '<option value="'+data2[i].UId+'">' + data2[i].name
							+ '</option>';
				}
				$("#userId").empty();
				$("#userId").append(str);

			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
		if (mProjectType == 1) {
			//销售
			$("#userId").find("option").filter(function(index) {
				return $('#salesName').val() === $(this).text();
			}).attr("selected", "selected");
			$("#userId").val(salesId);
		} else {
			//售前或售后
			$("#userId").find("option").filter(function(index) {
				return userId === $(this).value;
			}).attr("selected", "selected");
			$("#userId").val(userId);
		}

	}


	//检查文件服务器相同文件是否存在
	function checkFileExist(reportType, fileName) {
		var isExist = false;
		$.ajax({
			url : host + "/queryUploadFile",
			type : 'GET',
			data : {
				"createYear" : createYear,
				"projectId" : projectId,
				"reportType" : reportType
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

	function addProjectReport() {
		var date = $('#date').val();
		var userId = $("#userId").val();
		var report = $("#reportDesc").val().trim();
		var myFile = document.getElementById("myfile").files[0];
		if (userId == 0) {
			alert("请选择报告者");
			return;
		}
		if (report == "") {
			alert("请输入报告描述");
			return;
		}
		if (myFile != undefined && myFile.size > 3 * 1024 * 1024 * 1024) {
			alert("单个文件上传不能大于3GB");
			return;
		}
		if (myFile != undefined) {
			//先检查是否有同文件名的文件
			if (!checkFileExist(userReportType, myFile.name)) {
				chunks = Math.ceil(myFile.size / sliceSize);
				$("#progressDiv").show();
				currentChunk = 0;
				doUploadFile(myFile, date, userId, report, userReportType);
			} else {
				alert("有相同文件名的附件已上传，请修改文件名");
				return;
			}
		} else {
			saveReportInfo(date, userId, report, userReportType, "");
		}
	}

	function doUploadFile(mFile, mDate, mUserId, mReport, mReportType) {
		if (currentChunk < chunks) {
			var formData = new FormData();
			formData.append('reportType', mReportType);
			formData.append('projectId', projectId);
			formData.append('createYear', createYear);
			formData.append('fileSize', mFile.size);
			formData.append('fileName', mFile.name);
			formData.append('chunks', chunks);
			formData.append('chunk', currentChunk);
			formData.append('file', getSliceFile(mFile, currentChunk));
			
			formData.append('salesId', salesId);
			formData.append('userId', mUserId);
			formData.append('projectName', $("#projectName").val());
			formData.append('companyName', companyName);
			
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
						doUploadFile(mFile, mDate, mUserId, mReport,
								mReportType);
					} else {
						alert("上传错误，错误信息：" + info);
						return;
					}
				}
			} 
		} else {
			saveReportInfo(mDate, mUserId, mReport, mReportType, mFile.name);
		}

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

	function upDateProgress(currentChunk) {
		var percent = Math.round((currentChunk + 1) * 100 / chunks);
		var cont = document.getElementById("progress");
		cont.innerHTML = percent.toFixed(2) + '%';
		cont.style.width = percent.toFixed(2) + '%';
	}

	function saveReportInfo(mDate, mUserId, mReport, mReportType, mFileName) {
		setTimeout(function() {
			//保存到数据库
			$.ajax({
				url : host + "/createProjectReport",
				type : 'POST',
				data : {
					"contactDate" : mDate,
					"userId" : mUserId,
					"reportDesc" : mReport,
					"projectId" : projectId,
					"reportType" : mReportType,
					"fileName" : mFileName,
					"caseId" : ""
				},
				cache : false,
				async : false,
				success : function(returndata) {
					var data = eval("(" + returndata + ")").errcode;
					if (data == 0) {
						alert("提交成功");
						closeConfirmBox();
						getProjectReportList();
					} else {
						alert("提交失败");
					}
				},
				error : function(XMLHttpRequest, textStatus, errorThrown) {
				}
			});
		}, 500);
	}

	function downloadFile(fileName, reportType) {
		$.ajax({
			url : host + "/downloadFile",
			type : 'GET',
			data : {
				"fileName" : fileName,
				"reportType" : reportType,
				"projectId" : projectId,
				"createYear" : createYear
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

	function showReportList(mProjectType) {
		var mShowlist;
		if (mProjectType == 1) {
			mShowlist = showlist1;
		} else if (mProjectType == 2) {
			mShowlist = showlist2;
		} else if (mProjectType == 3) {
			mShowlist = showlist3;
		}

		if (mShowlist) {
			$("#tb" + mProjectType).show();
			document.getElementById('img' + mProjectType).src = host
					+ "/image/Puck_Hover_down.png";
			mShowlist = false;
			
		} else {
			$("#tb" + mProjectType).hide();
			document.getElementById('img' + mProjectType).src = host
					+ "/image/Puck_Hover_up.png";
			mShowlist = true;
		}

	 	if (mProjectType == 1) {
			showlist1 = mShowlist;
		} else if (mProjectType == 2) {
			showlist2 = mShowlist;
		} else if (mProjectType == 3) {
			showlist3 = mShowlist;
		} 
	}

	function editProject() {
		if (!isPermissionEdit) {
			alert("你没有权限编辑项目");
			return;
		}
		var projectName = $("#projectName").val().trim();
		var projectType = $("#projectType").val();
		var productStyle = $("#productStyle").val();
		var projectManager = $("#projectManager").val();
		contactUsersArr = new Array();
		$("#contactUsers option:selected").each(function() {
			contactUsersArr.push($(this).val());
		});

		salesBeforeUsersArr = new Array();
		$("#salesBeforeUsers option:selected").each(function() {
			salesBeforeUsersArr.push($(this).val());
		});

		salesAfterUsersArr = new Array();
		$("#salesAfterUsers option:selected").each(function() {
			salesAfterUsersArr.push($(this).val());
		});

		if (projectName == "") {
			alert("项目名称不能为空");
			return;
		}

		if (contactUsersArr.length == 0) {
			alert("请选择客户联系人");
			return;
		}

		if(isFmlkShare){
			if (productStyle == 0) {
				alert("请选择产品类型");
				return;
			}
		}else{
			if (projectType == 0) {
				alert("请选择项目类型");
				return;
			}
		}

		if (salesBeforeUsersArr.length == 0) {
			salesBeforeUsersArr.push("");
		}

		if (salesAfterUsersArr.length == 0) {
			salesAfterUsersArr.push("");
		}
		$.ajax({
			url : host + "/editProject",
			type : 'POST',
			cache : false,
			dataType : "json",
			data : {
				"projectName" : projectName,
				"projectType" : projectType,
				"projectManager" : projectManager,
				"projectState" : projectState,
				"projectFailedReason" : "",
				"id" : id,
				"contactUsers" : contactUsersArr,
				"salesBeforeUsers" : salesBeforeUsersArr,
				"salesAfterUsers" : salesAfterUsersArr,
				"projectSubState":99,
				"productStyle":productStyle
			},
			traditional : true,
			success : function(returndata) {
				var data = returndata.errcode;
				if (data == 0) {
					alert("编辑项目成功");
					setTimeout(function() {
						toReloadPage();
						toBackPage();
						toBackPage();
					}, 500);
				} else {
					alert("编辑项目失败");
				}
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
	}
	
</script>


</head>
<body>
	<div id="pageAll">
		<div class="pageTop">
			<div class="page">
				<img src="${pageContext.request.contextPath}/image/coin02.png" /><span><a
					href="#">首页</a>&nbsp;-&nbsp;<a href="#">项目管理</a>&nbsp;-</span><span
					style="margin-left: 5px" id="span_title2"></span>
			</div>
		</div>

		<div class="page ">
			<div class="banneradd bor" style="height: auto">
				<div class="baTopNo">
					<span id="span_title1"></span>
				</div>
				<!--销售 -->
				<div class="baBody" style="margin-top: 20px;">
					<div class="bbD">
						<label>项目名称：</label><input type="text" class="input3"
							id="projectName" style="width: 790px;" />
					</div>

					<div class="bbD">
						<label>客户名称：</label><input type="text" class="input3"
							id="companyId" disabled="disabled"
							style="width: 340px; background-color: #EEE" /><label
							style="margin-left: 15px">客户联系人：</label><select class="selCss"
							id="contactUsers" multiple="multiple" name="states[]"
							style="width: 330px;"></select>
					</div>

					<div class="bbD">
						<label>销售人员：</label><input type="text" class="input3"
							id="salesName" disabled="disabled"
							style="width: 340px; margin-right: 10px; background-color: #EEE" />
							<span id="spanProjectType">
							<label style="margin-left: 19px">项目类型：</label><select class="selCss"
							id="projectType" style="width: 330px;" disabled="disabled"></select>
							</span>
							<span id="spanProductStyle">
							<label style="margin-left: 19px">产品类型：</label><select class="selCss"
							id="productStyle" style="width: 330px;" disabled="disabled"></select>
							</span>
					</div>

					<div class="bbD" id="managerDiv">
						<label>项目经理：</label><select class="selCss" id="projectManager"
							style="width: 350px;" /></select>
					</div>

					<div class="bbD" style="height: 27px;">
						<input type="button" value="销售进展报告"
							onclick="openProjectReportWin(1)"
							style="width: 140px; float: left; margin-left: 15px;" /> <img
							style="margin-left: 5px; height: 21px" id="img1"
							src="${pageContext.request.contextPath}/image/Puck_Hover_down.png"
							onclick="showReportList(1)" />
					</div>

					<div class="bbD">
						<table border="1" style="margin-left: 15px">
							<tr>
								<td style="width: 95px" class="tdColor3"><strong>沟通时间</strong></td>
								<td style="width: 80px" class="tdColor3"><strong>报告者</strong></td>
								<td style="width: 300px" class="tdColor3"><strong>报告描述</strong></td>
								<td style="width: 300px" class="tdColor3"><strong>上传文件</strong></td>
								<td style="width: 95px" class="tdColor3"><strong>上传时间</strong></td>
							</tr>
						</table>
						<table id="tb1" border="1"
							style="margin-left: 15px">
						</table>
					</div>

					<div class="bbD">
						<label id="labelBeforeUsers">售前跟进技术人员：</label><select class="selCss"
							id="salesBeforeUsers" multiple="multiple" name="states[]"
							style="width: 730px;"></select>
					</div>


					<div class="bbD" style="height: 27px;">
						<input type="button" value="售前工程师进展报告"
							onclick="openProjectReportWin(2)" id="inputSaleBefore"
							style="width: 140px; float: left; margin-left: 15px" /> <img
							style="margin-left: 5px; height: 21px" id="img2"
							src="${pageContext.request.contextPath}/image/Puck_Hover_down.png"
							onclick="showReportList(2)" />
					</div>

					<div class="bbD" style="margin-bottom: 30px;" id="saleBeforeDiv_3">
						<table border="1" style="margin-left: 15px">
							<tr>
								<td style="width: 95px" class="tdColor3"><strong>沟通时间</strong></td>
								<td style="width: 80px" class="tdColor3"><strong>报告者</strong></td>
								<td style="width: 300px" class="tdColor3"><strong>报告描述</strong></td>
								<td style="width: 300px" class="tdColor3"><strong>上传文件</strong></td>
								<td style="width: 95px" class="tdColor3"><strong>上传时间</strong></td>
							</tr>
						</table>
						<table id="tb2" border="1"
							style="margin-left: 15px">
						</table>
					</div>


					<div class="bbD" id="saleAfterDiv_1" style="display: none">
						<label id="labelAfterUsers">售后跟进技术人员：</label><select class="selCss"
							id="salesAfterUsers" multiple="multiple" name="states[]"
							style="width: 73  0px;"></select>
					</div>

					<div class="bbD" id="saleAfterDiv_2" style="height: 27px; display: none">
						<input type="button" value="售后工程师进展报告"
							onclick="openProjectReportWin(3)" id="inputSaleAfter"
							style="width: 140px; float: left; margin-left: 15px" /> <img
							style="margin-left: 5px; height: 21px" id="img3"
							src="${pageContext.request.contextPath}/image/Puck_Hover_down.png"
							onclick="showReportList(3)" />
					</div>

					<div class="bbD" id="saleAfterDiv_3" style="margin-bottom: 30px; display: none">
						<table border="1" style="margin-left: 15px;">
							<tr>
								<td style="width: 95px" class="tdColor3"><strong>沟通时间</strong></td>
								<td style="width: 80px" class="tdColor3"><strong>报告者</strong></td>
								<td style="width: 300px" class="tdColor3"><strong>报告描述</strong></td>
								<td style="width: 300px" class="tdColor3"><strong>上传文件</strong></td>
								<td style="width: 95px" class="tdColor3"><strong>上传时间</strong></td>
							</tr>
						</table>
						<table id="tb3" border="1"
							style="margin-left: 15px">
						</table>
					</div>

				</div>
				<!--销售 -->
				<div class="cfD" style="margin-bottom: 30px; display: none"
					id="operation">
					<a class="addA" href="#" onclick="editProject()"
						style="margin-left: 105px; margin-top: 20px">编辑</a> <a
						class="addA" href="#" onclick="toBackPage()">返回</a>
				</div>

				<!-- 进展报告弹出框 -->
				<div class="banDel" id="banDel2">
					<div class="delete" style="width: 600px">
						<div class="close">
							<a><img
								src="${pageContext.request.contextPath}/image/shanchu.png"
								onclick="closeConfirmBox()" /></a>
						</div>
						<p class="delP1" id="reportTitle">添加项目进展报告</p>
						<p class="delP2" style="margin-top: 20px;">
							<label style="font-size: 16px;">沟通时间：</label><input type="text"
								id="date"
								style="width: 150px; margin-left: 10px; margin-right: 10px; height: 25px; border-bottom: 1px dashed #78639F; border-left: none; border-right: none; border-top: none;"><span
								id="dd"></span> <label style="font-size: 16px;">报告者：</label><select
								id="userId"
								style="width: 180px; height: 25px; border-bottom: 1px dashed #78639F; border-left: none; border-right: none; border-top: none;"></select>
						</p>
						<p class="delP2" style="margin-top: 10px;">
							<label style="font-size: 16px;">报告描述：</label><input
								id="reportDesc" type="text"
								style="width: 410px; margin-left: 10px; height: 25px; border-bottom: 1px dashed #78639F; border-left: none; border-right: none; border-top: none; margin-top: 15px;" />
						</p>
						<p class="delP2" style="margin-top: 10px;">
							<label style="font-size: 16px;">上传附件：</label><input type="file"
								name="myfile" id="myfile"
								style="width: 410px; margin-top: 15px; margin-left: 10px; border: none;"
								accept="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet, application/vnd.ms-excel,application/vnd.ms-powerpoint,application/msword,image/*,application/pdf,application/x-zip-compressed,application/x-rar-compressed,.docx,.rar" />
						</p>

						<p class="delP2" style="height: 20px;">
						<div id="progressDiv"
							style="width: 500px; height: 20px; background-color: gray; margin-left: 50px;">
							<span id="progress"
								style="display: inline-block; height: 20px; background-color: orange; line-height: 20px; text-align: left; float: left"></span>
						</div>
						</p>

						<p class="delP2" style="margin-top: 30px;">
							<a class="addA" href="#" onclick="addProjectReport()"
								style="margin-left: 0px; margin-bottom: 30px;">提交</a><a
								class="addA" href="#" onclick="closeConfirmBox()">取消</a>
						</p>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>