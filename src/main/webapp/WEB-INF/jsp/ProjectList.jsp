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
	href="${pageContext.request.contextPath}/css/css.css?v=1990" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/select4.css?v=1997" />
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
	src="${pageContext.request.contextPath}/js/getObjectList.js?v=15"></script>
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

	var previousProjectState;//编辑项当前的项目状态
	var previousProjectSubState;//编辑项当前的项目节点

	var thisSubStateNum;//当前状态下项目节点个数
	var stateNeedUpload;

	var chunks;
	var sliceSize;
	var currentChunk;
	var userReportType;
	var upNesInfo;
	var needUpload;
	var projectManagerArr;

	$(document).ready(function() {
		sId = "${sessionId}";
		host = "${pageContext.request.contextPath}";
		checkEditPremission(13, 14);
	});

	function initialPage() {
		page = 1;
		getCompanyList("", 0, 0, 1);
		getSalesList(0);
		getMyProjectList(page);
		
		$("#companyId").select2({});
		$("#salesId").select2({});
		$("#projectManager").select2({});
		sliceSize = 1 * 1024 * 1024;
	}

	function getProjectManagerList(mProjectManager, mSalesBeforeUsersArr,
			mSalesAfterUsersArr) {
		var today = formatDate(new Date()).substring(0, 10);
		var xhr = createxmlHttpRequest();
		xhr.open("GET", host + "/userList?date=" + today
				+ "&dpartId=102&name=&nickName=&jobId=&isHide=true", true);
		xhr.onreadystatechange = function() {
			if (this.readyState == 4) {
				var str = '<option value="0">请选择...</option>';
				var str2 = '';
				var data = eval("(" + xhr.responseText + ")").userlist;
				for ( var i in data) {
					str2 += '<option value="' + data[i].UId + '">'
							+ data[i].name + '</option>';
				}
				$("#projectManager").empty();
				$("#projectManager").append(str + str2);
				$("#projectManager").find(
						'option[value="' + mProjectManager + '"]').attr(
						"selected", true);
				for (var i = 0; i < projectManagerArr.length; i++) {
					var pid = projectManagerArr[i].split("#")[0];
					$("#projectManager" + pid).empty();
					$("#projectManager" + pid).append(str + str2);
					$("#projectManager" + pid)
							.find(
									'option[value="'
											+ projectManagerArr[i].split("#")[1]
											+ '"]').attr("selected", true);
				}
			}
		};
		xhr.send();
	}

	function changeProjectManager(tId, tProjectState, tSalesId,tManager) {
		if (sId == getUser(tSalesId).nickName || sId == "super.admin"
				|| sId == "sun.ke") {
			//编辑项目经理
			var tProjectManager = $("#projectManager" + tId).val();
			var arrayContact = new Array();
			arrayContact.push("");
			$.ajax({
				url : host + "/editProject",
				type : 'POST',
				cache : false,
				dataType : "json",
				data : {
					"projectName" : "",
					"projectType" : 0,
					"projectManager" : tProjectManager,
					"projectState" : tProjectState,
					"projectFailedReason" : "",
					"id" : tId,
					"contactUsers" : "",
					"salesBeforeUsers" : arrayContact,
					"salesAfterUsers" : arrayContact,
					"projectSubState" : 99
				},
				traditional : true,
				success : function(returndata) {
					//alert(returndata);
					var data = returndata.errcode;
					if (data == 0) {
						alert("更改项目经理成功");
					} else {
						alert("更改项目经理失败");
					}
					getMyProjectList(page);
					getProjectManagerList(0, null, null);
				},
				error : function(XMLHttpRequest, textStatus, errorThrown) {
				}
			});
		} else {
			alert("你没有权限更改此项目的项目经理");
			$("#projectManager" + tId).val(tManager);
		}
	}

	function getMyProjectList(mPage) {
		page = mPage;
		var mCompanyId = $("#companyId").val();
		var mProjectName = $("#projectName").val().trim();
		var mSalesId = $("#salesId").val();
		var mProjectManager = $("#projectManager").val();
		mCompanyId = (mCompanyId == null || mCompanyId == 0) ? "" : mCompanyId;
		mSalesId = (mSalesId == null) ? 0 : mSalesId;
		mProjectManager = (mProjectManager == null) ? 0 : mProjectManager;

		$
				.ajax({
					url : host + "/projectList",
					type : 'GET',
					data : {
						"companyId" : mCompanyId,
						"projectName" : mProjectName,
						"salesId" : mSalesId,
						"projectManager" : mProjectManager
					},
					cache : false,
					async : false,
					success : function(returndata) {
						var data = eval("(" + returndata + ")").projectList;
						var str = "";
						var num = data.length;
						var projectArr = new Array();
						var projectArr2 = new Array();//这里让项目经理也有权利编辑项目
						projectTypeArr = new Array();
						projectManagerArr = new Array();
						if (num > 0) {
							lastPage = Math.ceil(num / 10);
							for ( var i in data) {
								if (i >= 10 * (mPage - 1)
										&& i <= 10 * mPage - 1) {
									projectManagerArr.push(data[i].id + "#"
											+ data[i].projectManager + "#"
											+ data[i].salesId)

									projectArr.push(data[i].salesId);
									//这里新加项目经理有权更改项目状态,如果当前登入用户为该项目的项目经理
									if (data[i].projectManager == 0) {
										//没有项目经理
										projectArr2.push(false);
									} else if (getUser(data[i].projectManager).nickName == sId) {
										//项目经理就是本人
										projectArr2.push(true);
									} else {
										projectArr2.push(false);
									}
									projectTypeArr.push(data[i].id + "#"
											+ data[i].projectType)
									/* var projectManagerStr = (data[i].projectManager == 0) ? '<td style="width:7%;color:red" class="tdColor2">未指派</td>'
											: '<td style="width:7%" class="tdColor2">'
													+ getUser(data[i].projectManager).name
													+ '</td>'; */
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
										ps = '<span style="color:blue">项目实施中</span></br><span style="margin-left:24px;font-size:10px">'
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
									str += '<tr style="width:1300px"><td style="width:14%" class="tdColor2">'
											+ data[i].projectId
											+ '</td>'
											+ '<td style="width:40%" class="tdColor2">'
											+ data[i].projectName
											+ '</br><span style="font-size:10px">'
											+ getCompany(data[i].companyId).companyName
											+ '</span></td>'
											+ '<td style="width:7%" class="tdColor2">'
											+ getUser(data[i].salesId).name
											+ '</td>'
											+ '<td style="width:7%" class="tdColor2">'
											+ '<select class="selCss" style="width: 100%;border:none" id="projectManager'
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
											+ ')"/>'
											+ '</td>'
											//+ projectManagerStr

											+ '<td style="width:18%;" class="tdColor2">'
											+ '<div>'
											+ ps
											+ '<img src="../image/coinL1.png" style="width:14px;float:right;margin-right:10px;margin-top:-8px" title="更改项目状态" onclick="selectProjectState('
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
											+ thisUpNesInfo
											+ '\''
											+ ')">'
											+ '</div>'
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
						
						
						//getProjectManagerStr(projectManagerArr);
						//这里给销售和管理员加编辑权限
						matchUserPremission(projectArr,projectArr2);
                        
						//以下是项目基础信息，暂关闭项目经理变更权限
						/*  for(var k=0;k<isPermissionEditArr.length;k++){
							if(isPermissionEditArr[k]){
								document.getElementsByName("img_edit")[k].setAttribute("title", "编辑");
								document.getElementsByName("a_edit")[k].innerHTML = "编辑";
							}
						}  */
						getProjectManagerList(0, null, null);

					},
					error : function(XMLHttpRequest, textStatus, errorThrown) {
					}
				});
	}
	
	
	function matchUserPremission(objectArr,mProjectArr2) {
		if (objectArr.length > 0 && isPermissionEdit) {
			isPermissionEditArr = new Array();
			var xhr = createxmlHttpRequest();
			xhr.open("GET", host + "/getUserByNickName?nickName=" + sId, true);
			xhr.onreadystatechange = function() {
				if (this.readyState == 4) {
					var data = eval("(" + xhr.responseText + ")").user;
					var tId = data[0].UId;
					var tRoleId = data[0].roleId;
					var arrImg = document.getElementsByName("img_edit");
					for (var j = 0; j < arrImg.length; j++) {
						if (objectArr[j] == tId || tRoleId == 11) {
							isPermissionEditArr.push(true);
							arrImg[j].setAttribute("title", "编辑");
							document.getElementsByName("a_edit")[j].innerHTML = "编辑";
						} else if(mProjectArr2[j]){
							isPermissionEditArr.push(true);
							arrImg[j].setAttribute("title", "编辑");
							document.getElementsByName("a_edit")[j].innerHTML = "编辑";
						} else {
							isPermissionEditArr.push(false);
						}
					}
				}
			};
			xhr.send();
		}
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

	function getThisUser() {
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

	function createProjectStateSelection(projectState) {
		var selectionArr = new Array();
		selectionArr.push("售前服务");
		selectionArr.push("项目实施中");
		selectionArr.push("售后服务");
		selectionArr.push("项目结束关闭");
		selectionArr.push("项目失败关闭");
		var opt = "";
		for (var i = 0; i < 5; i++) {
			if (i == projectState || i == 3 || i == 4) {
				opt += "<option value='"+i+"'>" + selectionArr[i] + "</option>";
			} else {
				opt += "<optgroup label='"+selectionArr[i]+"' style='color:gray;font-weight:lighter'></optgroup>";
			}
		}
		$("#projectState").empty();
		$("#projectState").append(opt);
		$("#projectState").find('option[value="' + projectState + '"]').attr(
				"selected", true);
	}

	function selectProjectState(t, id, projectState, projectFailedReason,
			projectSubState, projectType, mUpNesInfo) {
		if(isPermissionEditArr[t % 10] || sId=="sun.ke"){
			createProjectStateSelection(projectState);
			upNesInfo = mUpNesInfo;
			//	alert(mUpNesInfo);
			$("#progressDiv").hide();
			$("#myfile").val("");
			thisProjectState = projectState;
			thisProjectSubState = projectSubState;
			thisProjectType = projectType;
			previousProjectState = projectState;
			previousProjectSubState = projectSubState;
			$("#projectState").val(projectState);

			/* if (projectState == 0) {
				$("#projectState").css("color", "orange");
			} else if (projectState == 1) {
				$("#projectState").css("color", "blue");
			} else if (projectState == 2) {
				$("#projectState").css("color", "green");
			} else if (projectState == 3) {
				$("#projectState").css("color", "black");
			} else {
				$("#projectState").css("color", "red");
			} */
			//获取节点状态列表
			getProjectSubStateList(projectState, projectType, projectSubState);
			//显示隐藏上传div
			var SubStateText = getProjectSubState(projectState, projectType,
					projectSubState);
			if (SubStateText == "需求分析&方案制定" || SubStateText == "招投标&合同签订"
					|| SubStateText == "到货验收" || SubStateText == "安装调试"
					|| SubStateText == "项目测试" || SubStateText == "项目实施"
					|| SubStateText == "项目试运行" || SubStateText == "项目终验") {
				$("#fileUploadDiv").show();
			} else {
				$("#fileUploadDiv").hide();
			}
			editId = id;
			//显示隐藏失败原因div
			if (projectState == 4) {
				if (projectFailedReason != null) {
					$("#projectFailedReason").val(projectFailedReason);
				}
				$("#pfr").show();
			} else {
				$("#pfr").hide();
			}
			if (projectState <= 2) {
				$("#pss").show();
				$("#projectState").css("background-color", "#fff");
				$("#projectState").removeAttr("disabled");
			} else {
				$("#pss").hide();
				$("#confirmStateId").hide();
				$("#projectState").css("background-color", "#eee");
				$("#projectState").attr("disabled", "disabled");
			}
			$("#banDel2").show();
		}else{
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

	function changeProjectSubState(mProjectSubState) {
		var SubStateText = getProjectSubState(previousProjectState,
				thisProjectType, mProjectSubState);
		if (SubStateText == "需求分析&方案制定" || SubStateText == "招投标&合同签订"
				|| SubStateText == "到货验收" || SubStateText == "安装调试"
				|| SubStateText == "项目测试" || SubStateText == "项目实施"
				|| SubStateText == "项目试运行" || SubStateText == "项目终验") {
			$("#fileUploadDiv").show();
		} else {
			$("#fileUploadDiv").hide();
		}
		previousProjectSubState = mProjectSubState;
	}

	function changeProjectState(mProjectState) {
		//失败原因div显示隐藏
		if (mProjectState == 4) {
			$("#pfr").show();
		} else {
			$("#pfr").hide();
			$("#projectFailedReason").val("");
		}
		//项目节点div显示隐藏
		if (mProjectState <= 2) {
			$("#pss").show();
		} else {
			$("#pss").hide();
		}

		if (mProjectState != previousProjectState) {
			previousProjectSubState = 0;
			getProjectSubStateList(mProjectState, thisProjectType,
					previousProjectSubState);
			previousProjectState = mProjectState;
			changeProjectSubState(previousProjectSubState);
		}

	}

	//检查文件服务器相同文件是否存在
	function checkFileExist(reportType, fileName) {
		var isExist = false;
		$.ajax({
			url : host + "/queryUploadFile",
			type : 'GET',
			data : {
				"createYear" : upNesInfo.split("#")[1],
				"projectId" : upNesInfo.split("#")[0],
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

	function addProjectReport(reportDesc, tProjectState, tProjectFailedReason,
			tProjectSubState) {
		var date = formatDate(new Date()).substring(0, 10);
		var userId = getThisUser().UId;
		var report = reportDesc + "-文档";
		var myFile = document.getElementById("myfile").files[0];
		if(myFile == undefined){
			alert("必须上传文件才能走到下一步");
			return;
		}
		
		
		if (myFile != undefined && myFile.size > 3 * 1024 * 1024 * 1024) {
			alert("单个文件上传不能大于3GB");
			return;
		}
		if (getThisUser().departmentId == 2) {
			//销售
			userReportType = 1;
		} else {
			userReportType = 3;
		}
		if (myFile != undefined) {
			//先检查是否有同文件名的文件
			if (!checkFileExist(userReportType, myFile.name)) {
				chunks = Math.ceil(myFile.size / sliceSize);
				$("#progressDiv").show();
				currentChunk = 0;
				doUploadFile(myFile, date, userId, report, userReportType,
						tProjectState, tProjectFailedReason, tProjectSubState);
			} else {
				alert("有相同文件名的附件已上传，请修改文件名");
				return;
			}
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

	function doUploadFile(mFile, mDate, mUserId, mReport, mReportType,
			tProjectState, tProjectFailedReason, tProjectSubState) {
		if (currentChunk < chunks) {
			var formData = new FormData();
			formData.append('reportType', mReportType);
			formData.append('projectId', upNesInfo.split("#")[0]);
			formData.append('createYear', upNesInfo.split("#")[1]);
			formData.append('fileSize', mFile.size);
			formData.append('fileName', mFile.name);
			formData.append('chunks', chunks);
			formData.append('chunk', currentChunk);
			formData.append('file', getSliceFile(mFile, currentChunk));
			//微信推送需要
			formData.append('salesId', upNesInfo.split("#")[2]);
			formData.append('userId', mUserId);
			formData.append('projectName', upNesInfo.split("#")[3]);
			formData.append('companyName',
					getCompany(upNesInfo.split("#")[4]).companyName);

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
								mReportType, tProjectState,
								tProjectFailedReason, tProjectSubState);
					} else {
						alert("上传错误，错误信息：" + info);
						return;
					}
				}
			}
		} else {
			saveReportInfo(mDate, mUserId, mReport, mReportType, mFile.name,
					tProjectState, tProjectFailedReason, tProjectSubState);
		}

	}

	function saveReportInfo(mDate, mUserId, mReport, mReportType, mFileName,
			tProjectState, tProjectFailedReason, tProjectSubState) {
		setTimeout(function() {
			//保存到数据库
			$.ajax({
				url : host + "/createProjectReport",
				type : 'POST',
				data : {
					"contactDate" : mDate,
					"userId" : mUserId,
					"reportDesc" : mReport,
					"projectId" : upNesInfo.split("#")[0],
					"reportType" : mReportType,
					"fileName" : mFileName,
					"caseId" : ""
				},
				cache : false,
				async : false,
				success : function(returndata) {
					var data = eval("(" + returndata + ")").errcode;
					if (data == 0) {
						//这里编辑存表
						Save(tProjectState, tProjectFailedReason,
								tProjectSubState);
					} else {
						alert("提交失败");
					}
				},
				error : function(XMLHttpRequest, textStatus, errorThrown) {
				}
			});
		}, 500);
	}

	function Save(tProjectState, tProjectFailedReason, tProjectSubState) {
		//编辑项目状态
		var arrayContact = new Array();
		arrayContact.push("");

		$.ajax({
			url : host + "/editProject",
			type : 'POST',
			cache : false,
			dataType : "json",
			data : {
				"projectName" : "",
				"projectType" : 0,
				"projectManager" : 0,
				"projectState" : tProjectState,
				"projectFailedReason" : tProjectFailedReason,
				"id" : editId,
				"contactUsers" : arrayContact,
				"salesBeforeUsers" : arrayContact,
				"salesAfterUsers" : arrayContact,
				"projectSubState" : tProjectSubState
			},
			traditional : true,
			success : function(returndata) {
				var data = returndata.errcode;
				if (data == 0) {
					alert("更改项目状态成功");
					setTimeout(function() {
						closeConfirmBox();
						getMyProjectList(page);
					}, 500);

				} else {
					alert("更改项目状态失败");
				}
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});

	}

	function editProjectState() {
		var mProjectState = $("#projectState").val();
		var mProjectSubState = $("#projectSubState").val();
		//alert(mProjectState);
		//alert(mProjectSubState);
		var projectFailedReason = $("#projectFailedReason").val().trim();
		needUpload = false;
		var needChangeState = false;
		if (mProjectState == 4 && projectFailedReason == "") {
			alert("请填写项目失败原因");
			return;
		}

		var SubStateText = getProjectSubState(mProjectState, thisProjectType,
				mProjectSubState);
		if (SubStateText == "需求分析&方案制定" || SubStateText == "招投标&合同签订"
				|| SubStateText == "到货验收" || SubStateText == "安装调试"
				|| SubStateText == "项目测试" || SubStateText == "项目实施"
				|| SubStateText == "项目试运行" || SubStateText == "项目终验") {
			needUpload = true;
		}
		
		if (SubStateText == "招投标&合同签订" || SubStateText == "项目交付"
				|| SubStateText == "售后维护" || SubStateText == "安装调试"
				|| SubStateText == "项目测试") {
			needChangeState = true;
		}
		

		if (needChangeState) {
			//状态跳转
			if (SubStateText == "售后维护") {
				mProjectState = 3;
			} else {
				mProjectState = parseInt(mProjectState) + 1;
			}
			mProjectSubState = 0;
		} else {
			mProjectSubState = parseInt(mProjectSubState) + 1;
		}
		
		//alert(mProjectState);
		//alert(mProjectSubState);
		
		//alert(needUpload);

		if (needUpload) {
			addProjectReport(SubStateText, mProjectState, projectFailedReason,
					mProjectSubState);
		} else {
			Save(mProjectState, projectFailedReason, mProjectSubState);
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
								id="projectName" />

						</div>
						<div class="cfD" style="width: 100%">
							<label style="margin-left: 114px; margin-right: 10px">销售人员：</label><select
								class="selCss" style="width: 10%" id="salesId"></select> <label
								style="margin-right: 10px;">项目经理：</label><select class="selCss"
								style="width: 10%" id="projectManager" /></select> <a class="addA"
								onclick="toCreateProjectPage()" href="#"
								style="margin-left: 30px">新建项目信息+</a> <a class="addA"
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
							<td style="width: 7%" class="tdColor">项目经理</td>
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
				<label style="font-size: 16px; margin-left: -28px">项目节点状态：</label> <select
					id="projectSubState" disabled="disabled"
					onChange="changeProjectSubState(this.options[this.options.selectedIndex].value)"
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

			<!--
			<p class="delP2" style="text-align: left; margin-left: 32px">
				<label style="font-size: 16px; color: brown">项目实施中：包含签订合同，采购下单，项目实施等。</label><br />
				<label style="font-size: 16px;margin-left:80px"></label>
			</p>
			<p class="delP2" style="text-align: left; margin-left: 48px">
				<label style="font-size: 16px; color: brown">售后服务：包含维保服务，其他服务等。</label>
			</p> -->
			<div class="cfD" id="confirmStateId" style="padding-bottom: 30px;">
				<a class="addA" href="#" onclick="editProjectState()"
					style="margin-left: 0px;">下一状态</a> <a class="addA"
					onclick="closeConfirmBox()">取消</a>
			</div>
		</div>
	</div>

</body>


</html>