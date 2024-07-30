<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="pragma" content="no-cache" />
<meta http-equiv="cache-control" content="no-cache" />
<title>项目信息管理</title>
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/loading.css?v=2">
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/css.css?v=1990" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/select4.css?v=1997" />
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/animate.css">
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.2.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/select3.js"></script>
<style type="text/css">
</style>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.2.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/select3.js"></script>

<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/validation.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/calendar.js"></script>
<script src="${pageContext.request.contextPath}/js/sweetalert2.js"></script>
<!-- Include a polyfill for ES6 Promises (optional) for IE11 and Android browser -->
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/core-js/2.4.1/core.js"></script>
<script
	src="${pageContext.request.contextPath}/js/checkPermission.js?v=200"></script>
<script src="${pageContext.request.contextPath}/js/changePsd.js"></script>
<script src="${pageContext.request.contextPath}/js/commonUtils.js"></script>
<script
	src="${pageContext.request.contextPath}/js/getObjectList.js?v=2024"></script>
<script src="${pageContext.request.contextPath}/js/request.js?v=3"></script>
<script src="${pageContext.request.contextPath}/js/loading.js"></script>
<script src="${pageContext.request.contextPath}/js/getObject.js?v=0"></script>
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
	var page;
	var lastPage;
	var deleteId;
	var editId;
	var sId;
	var host;
	var isPermissionEdit;
	var isPermissionDelete;
	var isPermissionEditArr;
	var projectTypeArr;
	var thisProjectState;//编辑项的项目状态
	var thisProjectSubState;//编辑项的项目节点
	var thisProjectType;//编辑项的项目类型
	var nextProjectState;
	var nextProjectSubState;
	var thisSubStateNum;//当前状态下项目节点个数
	var stateNeedUpload;
	var chunks;
	var sliceSize;
	var currentChunk;
	var userReportType;
	var upNesInfo;
	var needUpload;
	var projectManagerArr;
	var isFmlkShare;
	var projectSalesBeforeArr;
	var projectSalesAfterArr;
	var requestReturn;

	$(document).ready(function() {
		sId = "${sessionId}";
		host = "${pageContext.request.contextPath}";
		checkEditPremission(13, 14);
	});

	function initialPage() {
		page = 1;
		var isCheck = document.getElementsByName('field03');
		isFmlkShare = isCheck[0].checked;
		getCompanyList("", 0, 0, 1, isFmlkShare);
		getSalesList(0);
		if (isFmlkShare) {
			getProductStyleList();
			$("#productStyleView").show();
			$("#projectTypeView").hide();
			document.getElementById("columnTitle").innerHTML = "产品类型";
		} else {
			getProjectTypeList(0, isFmlkShare);
			$("#projectTypeView").show();
			$("#productStyleView").hide();
			document.getElementById("columnTitle").innerHTML = "项目经理";
		}
		$("#companyId").select2({});
		$("#salesId").select2({});
		$("#productStyle").select2({});
		$("#projectType").select2({});
		getMyProjectList(page);
		sliceSize = 1 * 1024 * 1024;
	}

	function getProjectManagerList(mProjectManager, mSalesBeforeUsersArr,
			mSalesAfterUsersArr) {
		var params = {
			"date" : formatDate(new Date()).substring(0, 10),
			"dpartId" : 1,
			"name" : "",
			"nickName" : "",
			"jobId" : "",
			"isHide" : true,
		}
		get("userList", params, false)
		if (requestReturn.result == "error") {
			alert(requestReturn.error);
		} else {
			var data = requestReturn.data.userlist
			var str = '<option value="0">请选择...</option>';
			for ( var i in data) {
				str += '<option value="' + data[i].UId + '">' + data[i].name
						+ '</option>';
			}
			for (var i = 0; i < projectManagerArr.length; i++) {
				var pid = projectManagerArr[i].split("#")[0];
				$("#projectManager" + pid).empty();
				$("#projectManager" + pid).append(str);
				$("#projectManager" + pid).find(
						'option[value="' + projectManagerArr[i].split("#")[1]
								+ '"]').attr("selected", true);
				if (!isPermissionEditArr[i]) {
					$("#projectManager" + pid).prop('disabled', true);
				}
			}
		}
	}

	function changeProjectManager(tId, tProjectState, tSalesId, tManager) {
		if (sId == getUser("uId", tSalesId).nickName || sId == "super.admin") {
			//编辑项目经理
			var tProjectManager = $("#projectManager" + tId).val();
			var arrayContact = new Array();
			arrayContact.push("");
			var params = {
				"id" : tId,
				"projectName" : "",
				"projectType" : 0,
				"projectManager" : tProjectManager,
				"projectState" : tProjectState,
				"projectFailedReason" : "",
				"contactUsers" : arrayContact,
				"salesBeforeUsers" : arrayContact,
				"salesAfterUsers" : arrayContact,
				"productStyle":arrayContact,
				"startDate":"",
	            "endDate":"",
				"projectSubState" : 99
			}
			post("editProject", params, true);
			if (requestReturn.result == "error") {
				alert(requestReturn.error);
			} else if (parseInt(requestReturn.code) == 0) {
				alert("更改项目经理成功");
			} else {
				alert("更改项目经理失败");
			}
			getMyProjectList(page);
			getProjectManagerList(0, null, null);
		} else {
			alert("你没有权限更改此项目的项目经理");
			$("#projectManager" + tId).val(tManager);
		}
	}

	function getMyProjectList(mPage) {
		loading();
		page = mPage;
		var mCompanyId = $("#companyId").val();
		var mProjectName = $("#projectName").val().trim();
		var mSalesId = $("#salesId").val();
		var projectType = $("#projectType").val();
		var productStyle = $("#productStyle").val();
		mCompanyId = (mCompanyId == null || mCompanyId == 0) ? "" : mCompanyId;
		mSalesId = (mSalesId == null) ? 0 : mSalesId;
		projectType = (projectType == null) ? 0 : projectType;
		productStyle = (productStyle == null) ? 0 : productStyle;
		var params = {
			"companyId" : mCompanyId,
			"projectName" : mProjectName,
			"salesId" : mSalesId,
			"isFmlkShare" : isFmlkShare,
			"projectType" : projectType,
			"productStyle" : productStyle
		}
		setTimeout(
				function() {
					get("projectList", params, false)
					if (requestReturn.result == "error") {
						closeLoading();
						alert(requestReturn.error);
					} else {
						var data = requestReturn.data.projectList;
						var str = "";
						var num = data.length;
						var projectArr = new Array();//项目的销售
						var projectArr2 = new Array();//这里让项目经理也有权利编辑项目
						projectTypeArr = new Array();
						projectManagerArr = new Array();
						projectSalesBeforeArr = new Array();
						projectSalesAfterArr = new Array();
						var mArrProductStyle = getAllProductStyle();
						if (num > 0) {
							lastPage = Math.ceil(num / 10);
							for ( var i in data) {
								if (i >= 10 * (mPage - 1)
										&& i <= 10 * mPage - 1) {
									projectManagerArr.push(data[i].id + "#"
											+ data[i].projectManager + "#"
											+ data[i].salesId)
									projectArr.push(data[i].salesId);
									projectSalesBeforeArr
											.push(data[i].salesBeforeUsers);
									projectSalesAfterArr
											.push(data[i].salesAfterUsers);
									//这里新加项目经理有权更改项目状态,如果当前登入用户为该项目的项目经理
									projectArr2.push(data[i].projectManager);
									projectTypeArr.push(data[i].id + "#"
											+ data[i].projectType);
									var ps;
									if (data[i].projectState <= 2) {
										ps = getProjectSubState(
												data[i].projectState,
												data[i].projectType,
												data[i].projectSubState);
									}

									if (data[i].projectState == 0) {
										ps = '<span style="color:orange">售前服务</span></br><span style="margin-left:24px;font-size:10px">'
												+ ps + '</span>';
									} else if (data[i].projectState == 1) {
										ps = '<span style="color:blue">项目实施</span></br><span style="margin-left:24px;font-size:10px">'
												+ ps + '</span>';
									} else if (data[i].projectState == 2) {
										ps = '<span style="color:green">售后服务</span></br><span style="margin-left:24px;font-size:10px">'
												+ ps + '</span>';
									} else if (data[i].projectState == 3) {
										ps = '<span style="color:black;">项目结束关闭</span></br><span></span>';
									} else {
										ps = '<span style="color:red;">项目失败关闭</span></br><span></span>';
									}

									var mProjectFailedReason = data[i].projectFailedReason == "" ? null
											: data[i].projectFailedReason;
									var thisUpNesInfo = data[i].projectId
											+ "#"
											+ data[i].createDate
													.substring(0, 4) + "#"
											+ data[i].salesId + "#"
											+ data[i].projectName + "#"
											+ data[i].companyId;
									str += '<tr style="width:1300px"><td style="width:14%" class="tdColor2"><a onclick="toEditProjectPage('
										    + data[i].id
										    + ')">'
											+ data[i].projectId
											+ '</a></td>'
											+ '<td style="width:40%" class="tdColor2">'
											+ data[i].projectName
											+ '</br><span style="font-size:10px">'
											+ getCompany("companyId",
													data[i].companyId).companyName
											+ '</span></td>'
											+ '<td style="width:7%" class="tdColor2">'
											+ getUser("uId", data[i].salesId).name
											+ '</td>'
											+ '<td style="width:7%;font-size:12px" class="tdColor2">';
									if (isFmlkShare) {
										str += getListItemProductStyle(
												mArrProductStyle,
												data[i].productStyle);
									} else {
										str += '<select class="selCss" style="width: 100%;border:none" id="projectManager'
												+ data[i].id
												+ '" '
												+ 'onChange="changeProjectManager('
												+ data[i].id
												+ ','
												+ data[i].projectState
												+ ','
												+ data[i].salesId
												+ ','
												+ data[i].projectManager
												+ ')"/>';
									}
									str += '</td>'
											+ '<td style="width:18%;" class="tdColor2">'
											+ '<div>' + ps;
									if (data[i].projectState < 3) {
										str += '<img src="../image/coinL1.png" style="width:14px;float:right;margin-right:10px;margin-top:-8px" title="更改项目状态" onclick="selectProjectState('
												+ i
												+ ','
												+ data[i].id
												+ ','
												+ data[i].projectState
												+ ',\''
												+ mProjectFailedReason
												+ '\','
												+ data[i].projectSubState
												+ ','
												+ data[i].projectType
												+ ',\''
												+ thisUpNesInfo + '\'' + ')">';
									}
									str += '</div>'
											+ '</td>'
											+ '<td style="width:7%" class="tdColor2">'
											+ '<img name="img_edit" title="查看" style="vertical-align:middle;" class="operation" src="../image/update.png" onclick="toEditProjectPage('
											+ data[i].id
											+ ')"/><a name="a_edit" style="vertical-align:middle" onclick="toEditProjectPage('
											+ data[i].id
											+ ')">查看</a></td>'
											+ '<td style="width:7%;" class="tdColor2">'
											+ '<img title="删除" style="vertical-align:middle" class="operation delban" src="../image/delete.png" onclick="confirmDelete('
											+ data[i].id
											+ ')"><a style="vertical-align:middle" onclick="confirmDelete('
											+ data[i].id
											+ ')">删除</a></td></tr>';

								}
							}
						} else {
							lastPage = 1;
							str += '<tr style="height:40px;text-align: center;"><td style="color:red;width:1300px;" border=0>没有你要找的项目</td></tr>';
						}
						document.getElementById('p').innerHTML = mPage + "/"
								+ lastPage;
						$("#tb").empty();
						$("#tb").append(str);
						//这里给销售和管理员加编辑权限
						matchUserPremission(projectArr, projectArr2);
						getProjectManagerList(0, null, null);
						closeLoading();
					}
				}, 500);
	}
	/* objectArr-项目销售  mProjectArr2-是否是项目经理 */
	function matchUserPremission(objectArr, mProjectArr2) {
		if(objectArr.length > 0){
			isPermissionEditArr = new Array();
			var myUser = getUser("nickName", sId);
			var tId = myUser.UId;
			var tRoleId = myUser.roleId;
			var tDepartmentId = myUser.departmentId;
			var arrImg = document.getElementsByName("img_edit");
			for (var j = 0; j < arrImg.length; j++) {
				if((objectArr[j] == tId || mProjectArr2[j] == tId || tDepartmentId==5 || tDepartmentId==6) && isPermissionEdit) {
					isPermissionEditArr.push(true);
					arrImg[j].setAttribute("title", "编辑");
					document.getElementsByName("a_edit")[j].innerHTML = "编辑";
				}else{
					isPermissionEditArr.push(false);
				}
			}
		}
	}

	function createProjectStateSelection(projectState) {
		var selectionArr = new Array();
		selectionArr.push("售前服务");
		selectionArr.push("项目实施");
		selectionArr.push("售后服务");
		selectionArr.push("项目结束关闭");
		selectionArr.push("项目失败关闭");
		var opt = "";
		for (var i = 0; i < 5; i++) {
			if (i == projectState || i==3 || i==4) {
				opt += "<option value='"+i+"' style='color:brown'>"
						+ selectionArr[i] + "</option>";
			} else {
				opt += "<option value='"+i+"' disabled>" + selectionArr[i]
						+ "</option>";
			}
		}
		$("#projectState").empty();
		$("#projectState").append(opt);
		$("#projectState").find('option[value="' + projectState + '"]').attr(
				"selected", true);
	}

	function selectProjectState(t, id, projectState, projectFailedReason,
			projectSubState, projectType, mUpNesInfo) {
		if (isPermissionEditArr[t % 10]) {
			//获取项目状态列表及选中
			createProjectStateSelection(projectState);
			//获取项目进度列表及选中
			getProjectSubStateList(projectState, projectType, projectSubState);
			upNesInfo = mUpNesInfo;
			$("#progressDiv").hide();
			$("#myfile").val("");
			thisProjectState = projectState;
			thisProjectSubState = projectSubState;
			thisProjectType = projectType;
			editId = id;
			if (projectState == 1) {
				$("#fileUploadDiv").show();
			} else {
				$("#fileUploadDiv").hide();
			}
			//显示隐藏失败原因div
			if (projectState == 4) {
				if (projectFailedReason != null && projectFailedReason != "") {
					$("#projectFailedReason").val(projectFailedReason);
				}
				//显示失败理由
				$("#pfr").show();
			} else {
				$("#pfr").hide();
			}
			if (projectState <= 2) {
				//显示项目进度及提交按钮
				$("#pss").show();
				$("#confirmStateId").show();
				$("#projectState").css("background-color", "#fff");
				$("#projectState").removeAttr("disabled");
			} else {
				$("#pss").hide();
				$("#confirmStateId").hide();
				$("#projectState").css("background-color", "#eee");
				$("#projectState").attr("disabled", "disabled");
			}
			$("#banDel2").show();
		} else {
			alert("你没有权限更改此项目状态");
		}
	}

	function confirmDelete(id) {
		if (!isPermissionDelete) {
			alert("你没有权限删除项目");
		} else {
			$("#banDel").show();
			deleteId = id;
		}
	}

	function deleteProject() {
		$.ajax({
			url : host + "/deleteProject",
			type : 'POST',
			data : {
				"id" : deleteId
			},
			cache : false,
			async : false,
			success : function(returndata) {
				var data = eval("(" + returndata + ")").errcode;
				if (data == 0) {
					alert("删除成功");
					setTimeout(function() {
						toReloadPage();
					}, 500);

				} else {
					alert("删除失败");
				}

			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
	}

	function nextPage() {
		if (page == lastPage) {
			alert("已经是最后一页");
			return;
		} else {
			page++;
			getMyProjectList(page);
			getProjectManagerList(0, null, null);
		}
	}

	function previousPage() {
		if (page == 1) {
			alert("已经是第一页");
			return;
		} else {
			page--;
			getMyProjectList(page);
			getProjectManagerList(0, null, null);
		}
	}

	function FirstPage() {
		if (page == 1) {
			alert("已经是首页");
			return;
		} else {
			page = 1;
			getMyProjectList(page);
			getProjectManagerList(0, null, null);
		}
	}

	function LastPage() {
		if (page == lastPage) {
			alert("已经是尾页");
			return;
		} else {
			page = lastPage;
			getMyProjectList(page);
			getProjectManagerList(0, null, null);
		}
	}

	//弹窗更改项目状态
	function changeProjectState(mProjectState) {
		//失败原因div显示隐藏
		if (mProjectState <= 2) {
			$("#pss").show();
			if (mProjectState == 1) {
				$("#fileUploadDiv").show();
			} else {
				$("#fileUploadDiv").hide();
			}
			document.getElementById("oprText").innerHTML = "进度更新";
		} else {
			$("#pss").hide();
			$("#fileUploadDiv").hide();
			document.getElementById("oprText").innerHTML = "关闭项目";
		}
		if (mProjectState == 4) {
			$("#pfr").show();
		} else {
			$("#pfr").hide();
			$("#projectFailedReason").val("");
		}
		if (mProjectState != thisProjectState) {
			//更新
			getProjectSubStateList(mProjectState, thisProjectType, 0);
		} else {
			getProjectSubStateList(thisProjectState, thisProjectType,
					thisProjectSubState);
		}
	}

	function editProjectState() {
		//当前选择的状态
		var mProjectState = $("#projectState").val();
		var mProjectSubState = $("#projectSubState").val();
		if (mProjectState == 3 || mProjectState == 4) {
			//项目关闭
			nextProjectState = mProjectState;
			nextProjectSubState = 0;
			var projectFailedReason = $("#projectFailedReason").val().trim();
			if (mProjectState == 4 && projectFailedReason == "") {
				alert("请填写项目失败原因");
				return;
			}
		} else {
			var retData = getNextProjectSubState();
			nextProjectState = retData.projectState;
			nextProjectSubState = retData.PId;
		}
		if ((nextProjectState == 1 && thisProjectState == 0)
				|| nextProjectState == 3) {
			//检查项目合同
			var existContractUpload = checkProjectContract();
			if (existContractUpload == "") {
				alert("更新此状态/进度需要提交此项目的合同文件");
				return;
			}
		}
		if (thisProjectState == 1) {
			var myFile = document.getElementById("myfile").files[0];
			if (myFile != undefined) {
				if (myFile.size > 1 * 1024 * 1024 * 1024) {
					alert("单个文件上传不能大于1GB");
					return;
				} else {
					chunks = Math.ceil(myFile.size / sliceSize);
					$("#progressDiv").show();
					currentChunk = 0;
					//先上传文件
					doUploadFile(myFile);
				}
			} else {
				var alertText;
				if (thisProjectSubState == 0) {
					alertText = "货物验收单";
				} else if (thisProjectSubState == 1) {
					alertText = "实施安装/投放文件"
				} else {
					alertText = "项目验收文件"
				}
				alert("更新此状态/进度需要提交" + alertText);
				return;
			}
		} else {
			editProject(null);
		}
	}

	function checkProjectType(type) {
		//type 1信息2共享陪护
		isFmlkShare = type == 2;
		if (isFmlkShare) {
			getProductStyleList();
			$("#productStyleView").show();
			$("#projectTypeView").hide();
			$("#projectType").val("");
			document.getElementById("columnTitle").innerHTML = "产品类型";
		} else {
			getProjectTypeList(0, isFmlkShare);
			$("#projectTypeView").show();
			$("#productStyleView").hide();
			$("#productStyle").val("");
			document.getElementById("columnTitle").innerHTML = "项目经理";
		}
		getCompanyList("", 0, 0, 1, isFmlkShare);
		page = 1;
		getMyProjectList(page)
	}

	function getAllProductStyle() {
		var productStyleArr = new Array();
		var options = document.querySelector('#productStyle').querySelectorAll(
				'option');
		for (var i = 0; i < options.length; i++) {
			productStyleArr[options[i].value] = options[i].text;
		}
		return productStyleArr;
	}

	function getProjectSubState(mProjectState, mProjectType, mProjectSubState) {
		var projectSubStateName;
		$.ajax({
			url : host + "/projectSubStateList",
			type : 'GET',
			data : {
				"projectState" : mProjectState,
				"projectType" : mProjectType
			},
			cache : false,
			async : false,
			success : function(returndata) {
				var data = eval("(" + returndata + ")").projectSubStateList;
				for ( var i in data) {
					if (data[i].PId == mProjectSubState) {
						projectSubStateName = data[i].name;
					}

				}
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
		return projectSubStateName;
	}

	function getNextProjectSubState() {
		var isFind = false;
		var retData = "";
		$.ajax({
			url : host + "/projectSubStateList",
			type : 'GET',
			data : {
				"projectState" : 99,
				"projectType" : thisProjectType
			},
			cache : false,
			async : false,
			success : function(returndata) {
				var data = eval("(" + returndata + ")").projectSubStateList;
				for ( var i in data) {
					if (isFind) {
						retData = data[i];
						break;
					} else {
						if (thisProjectSubState == data[i].PId
								&& thisProjectState == data[i].projectState) {
							isFind = true;
						}
					}
				}
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
		return retData;
	}

	function checkProjectContract() {
		var retData = ""
		$.ajax({
			url : host + "/projectReportList",
			type : 'GET',
			data : {
				"projectId" : upNesInfo.split("#")[0]
			},
			cache : false,
			async : false,
			success : function(returndata) {
				var data2 = eval("(" + returndata + ")").prList;
				if (data2.length > 0) {
					for ( var i in data2) {
						if (data2[i].reportType == 97) {
							retData = data2[i].projectId;
							break;
						}
					}
				}
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}

		});
		return retData;
	}

	function doUploadFile(mFile) {
		if (currentChunk < chunks) {
			var formData = new FormData();
			formData.append('reportType', 2);
			formData.append('projectId', upNesInfo.split("#")[0]);
			formData.append('createYear', "");
			formData.append('fileSize', mFile.size);
			formData.append('fileName', mFile.name);
			formData.append('chunks', chunks);
			formData.append('chunk', currentChunk);
			formData.append('file', getSliceFile(mFile, currentChunk));
			//微信推送需要
			formData.append('salesId', upNesInfo.split("#")[2]);
			formData.append('userId', getUser("nickName", sId).UId);
			formData.append('projectName', upNesInfo.split("#")[3]);
			formData.append('companyName', getCompany("companyId", upNesInfo
					.split("#")[4]).companyName);

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
						doUploadFile(mFile);
					} else {
						alert("上传错误，错误信息：" + info);
						return;
					}
				}
			}
		} else {
			editProject(mFile);
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

	function editProject(mFile) {
		var array = new Array();
		array.push("");
		var params = {
				"id" : editId,
				"projectName" : "",
				"projectType" : 0,
				"projectManager" : 0,
				"projectState" : nextProjectState,
				"projectFailedReason" : $("#projectFailedReason").val().trim(),
				"contactUsers" : array,
				"salesBeforeUsers" : array,
				"salesAfterUsers" : array,
				"productStyle":array,
				"startDate":"",
	            "endDate":"",
				"projectSubState" : nextProjectSubState
			}
		post("editProject", params, true);
		if (requestReturn.result == "error") {
			alert(requestReturn.error);
		} else if (parseInt(requestReturn.code) == 0) {
			if (thisProjectState == 1) {
				saveProjectReport(mFile);
			} else {
				alert("更新项目进度成功");
				closeConfirmBox();
				getMyProjectList(page);
			}
		} else {
			alert("更新项目进度失败");
		}
	}

	function saveProjectReport(tFile) {
		var reportDesc = isFmlkShare ? "运维实施进展报告" : "售前工程师进展报告"
		if (thisProjectSubState == 0) {
			reportDesc += "-货物验收单";
		} else if (thisProjectSubState == 1) {
			reportDesc += "-实施安装/投放文件";
		} else {
			reportDesc += "-项目验收文件";
		}
		setTimeout(function() {
			//保存到数据库
			$.ajax({
				url : host + "/createProjectReport",
				type : 'POST',
				data : {
					"contactDate" : "",
					"userId" : getUser("nickName", sId).UId,
					"reportDesc" : reportDesc,
					"projectId" : upNesInfo.split("#")[0],
					"reportType" : 2,
					"fileName" : tFile.name,
					"caseId" : ""
				},
				cache : false,
				async : false,
				success : function(returndata) {
					var data = eval("(" + returndata + ")").errcode;
					if (data == 0) {
						alert("更新项目进度成功");
						closeConfirmBox();
						getMyProjectList(page);
					} else {
						alert("提交失败");
					}
				},
				error : function(XMLHttpRequest, textStatus, errorThrown) {
				}
			});
		}, 500);
	}

	function loading() {
		$('body').loading({
			loadingWidth : 240,
			title : '请稍等!',
			name : 'test',
			discription : '加载中',
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

	function getListItemProductStyle(productStyleArr, mProductStyle) {
		var retProductStyle = "";
		if (mProductStyle.indexOf(",") > -1) {
			var arr = mProductStyle.split(",");
			for (var i = 0; i < arr.length; i++) {
				retProductStyle += (i == arr.length - 1) ? productStyleArr[arr[i]]
						: productStyleArr[arr[i]] + ",";
			}
			retProductStyle = retProductStyle.trim();
		} else if (mProductStyle == 0) {
			retProductStyle = "————";
		} else {
			retProductStyle = productStyleArr[mProductStyle];
		}
		return retProductStyle;
	}
	
	function getProductStyleList() {
		get("productStyleList", {"isFmlkShare":isFmlkShare}, false)
		if (requestReturn.result == "error") {
			alert(requestReturn.error);
		} else {
			var data = requestReturn.data.pslist;
			var str = '<option value="0">请选择...</option>';
			for ( var i in data) {
				str += '<option value="' + data[i].id + '">'
						+ data[i].styleName + '</option>';
			}
			$("#productStyle").empty();
			$("#productStyle").append(str);
		}
	}
</script>
</head>

<body>
	<div id="pageAll">
		<div class="pageTop">
			<div class="page">
				<img src="../image/coin02.png" /><span><a href="#">首页</a>&nbsp;-&nbsp;<a
					href="#">项目管理</a>&nbsp;-</span>&nbsp;项目信息管理
			</div>
		</div>

		<div class="page">
			<!-- vip页面样式 -->
			<div class="vip">
				<div class="conform">
					<form style="width: 100%">
						<div class="cfD" style="width: 100%">
							<Strong style="margin-right: 20px">查询条件：</Strong> <label
								style="margin-right: 10px">客户名称：</label><select class="selCss"
								style="width: 23%" id="companyId" /></select> <label
								style="margin-right: 10px">项目名称：</label><input type="text"
								class="input3" placeholder="输入项目名称" style="width: 23%"
								id="projectName" /> <label style="margin-right: 10px">销售人员：</label><select
								class="selCss" style="width: 10%" id="salesId"></select>
						</div>
						<div class="cfD" style="width: 100%">
							<input type="radio" name="field03" value="2" checked="checked"
								onclick="checkProjectType(2)" style="margin-left: 125px;" /> <label
								style="margin-left: 10px">共享陪护</label> <input type="radio"
								name="field03" value="1" onclick="checkProjectType(1)"
								style="margin-left: 20px;" /> <label style="margin-left: 10px">信息</label>
							<span id="productStyleView"> <label
								style="margin-right: 10px; margin-left: 40px">产品类型：</label><select
								class="selCss" style="width: 150px" id="productStyle" /></select>
							</span> <span id="projectTypeView"> <label
								style="margin-right: 10px; margin-left: 40px">项目类型：</label><select
								class="selCss" style="width: 150px%; display: none"
								id="projectType" /></select>
							</span> <a class="addA" onclick="toCreateProjectPage()" href="#"
								style="margin-left: 260px">新建项目信息+</a> <a class="addA"
								onClick="getMyProjectList(1)">搜索</a>
						</div>

					</form>
				</div>
				<!-- vip 表格 显示 -->
				<div class="conShow">
					<table border="1" style="width: 100%">
						<tr style="width: 100%">
							<td style="width: 14%" class="tdColor">项目编号</td>
							<td style="width: 40%" class="tdColor">项目名称 / 客户名称</td>
							<td style="width: 7%" class="tdColor">销售人员</td>
							<td style="width: 7%" class="tdColor" id="columnTitle">项目经理</td>
							<td style="width: 18%" class="tdColor">项目状态</td>
							<td style="width: 14%" class="tdColor">操作</td>
						</tr>

					</table>
					<table id="tb" border="1" style="width: 100%">
					</table>
					<div class="paging" style="margin-top: 20px; margin-bottom: 50px;">
						<input type="button" class="submit" value="首页"
							style="margin-left: 10px; width: 60px;" onclick="FirstPage()" />
						<input type="button" class="submit" value="上一页"
							style="margin-left: 10px; width: 60px;" onclick="previousPage()" />
						<input type="button" class="submit" value="下一页"
							style="margin-left: 10px; width: 60px;" onclick="nextPage()" />
						<input type="button" class="submit" value="尾页"
							style="margin-left: 10px; width: 60px;" onclick="LastPage()" />
						<span style="margin-left: 10px;">当前页：</span> <span id="p">0/0</span>
					</div>
				</div>
				<!-- vip 表格 显示 end-->
			</div>
			<!-- vip页面样式end -->
		</div>

	</div>

	<!-- 删除弹出框 -->
	<div class="banDel" id="banDel">
		<div class="delete">
			<div class="close">
				<a><img src="../image/shanchu.png" onclick="closeConfirmBox()" /></a>
			</div>
			<p class="delP1">你确定要删除此条项目记录吗?</p>
			<div class="cfD" style="margin-top: 30px">
				<a class="addA" href="#" onclick="deleteProject()"
					style="margin-left: 0px; margin-bottom: 30px;">确定</a> <a
					class="addA" onclick="closeConfirmBox()">取消</a>
			</div>
		</div>
	</div>

	<!-- 项目状态弹出框 -->
	<div class="banDel" id="banDel2">
		<div class="delete">
			<div class="close">
				<a><img src="../image/shanchu.png" onclick="closeConfirmBox()" /></a>
			</div>
			<p class="delP1" style="margin-top: 10px;">更改项目状态</p>
			<p class="delP2" style="margin-top: 20px; padding-bottom: 30px">
				<label style="font-size: 16px;">项目状态：</label> <select
					id="projectState"
					onChange="changeProjectState(this.options[this.options.selectedIndex].value)"
					style="width: 220px; height: 26px; border-bottom: 1px dashed #78639F; background: none; border-left: none; border-right: none; border-top: none; padding: 4px 2px 3px 2px; padding-left: 10px">

				</select>
			</p>
			<p class="delP2" style="padding-bottom: 30px" id="pss">
				<label style="font-size: 16px;">项目进度：</label> <select
					id="projectSubState" disabled="disabled"
					style="width: 220px; height: 26px; border-bottom: 1px dashed #78639F; background: none; border-left: none; border-right: none; border-top: none; padding: 4px 2px 3px 2px; padding-left: 10px">
				</select>
			</p>
			<p id="pfr" class="delP2"
				style="text-align: left; margin-left: 48px; display: none; padding-bottom: 30px">
				<label style="font-size: 16px;">项目失败原因：</label> <input type="text"
					style="height: 26px; border-bottom: 1px dashed #78639F; border-left: none; border-right: none; border-top: none; width: 220px; padding-left: 10px;"
					placeholder="输入项目失败原因" id="projectFailedReason" />
			</p>
			<p class="delP2" id="fileUploadDiv"
				style="padding-bottom: 30px; display: none;">
				<label style="font-size: 16px;">文件上传：</label> <input type="file"
					name="myfile" id="myfile"
					style="margin-left: 10px; border: none; width: 205px;"
					accept="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet, application/vnd.ms-excel,application/vnd.ms-powerpoint,application/msword,image/*,application/pdf,application/x-zip-compressed,application/x-rar-compressed,.docx,.rar" />
			</p>
			<p class="delP2" style="height: 20px;">
			<div id="progressDiv"
				style="width: 360px; height: 20px; background-color: gray; margin-left: 50px;">
				<span id="progress"
					style="display: inline-block; height: 20px; background-color: orange; line-height: 20px; text-align: left; float: left"></span>
			</div>
			</p>
			<div class="cfD" id="confirmStateId" style="padding-bottom: 30px;">
				<a class="addA" href="#" onclick="editProjectState()"
					style="margin-left: 0px;" id="oprText">进度更新</a> <a class="addA"
					onclick="closeConfirmBox()">取消</a>
			</div>
		</div>
	</div>

</body>


</html>