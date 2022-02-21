<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="renderer" content="webkit" />
<meta http-equiv="pragma" content="no-cache" />
<meta http-equiv="cache-control" content="no-cache" />
<title>标书信息管理</title>
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/css.css?v=1997" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/select4.css?v=1997" />
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/calendar.css" />

<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.2.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/select3.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/calendar.js"></script>
<script src="${pageContext.request.contextPath}/js/checkPermission.js"></script>
<script src="${pageContext.request.contextPath}/js/changePsd.js"></script>
<script src="${pageContext.request.contextPath}/js/commonUtils.js"></script>
<script src="${pageContext.request.contextPath}/js/getObjectList.js"></script>
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
	var sId;
	var host;
	var isPermissionEdit;
	var isPermissionDelete;
	var isPermissionEditArr;
	var chunks;
	var sliceSize;
	var currentChunk;
	var tUploadFileInfo;

	$(document).ready(function() {
		sId = "${sessionId}";
		host = "${pageContext.request.contextPath}";
		checkEditPremission(33, 0);
		sliceSize = 1 * 1024 * 1024;
	});

	function initialPage() {
		page = 1;
		getCompanyList("", 0, 0, 1);
		getAgencyList(0);
		getSalesList(0);
		getTenderStyleList(0);
		initDate();
		getMyTenderList(page);
		$("#companyId").select2({});
		$("#tenderAgency").select2({});
		$("#salesId").select2({});
		$("#projectId").select2({});
		$("#tenderStyle").select2({});
		$("#tenderResult").select2({
			templateResult : formatTenderResult
		});
	}

	function formatTenderResult(state) {
		if (!state.id) {
			return state.text;
		}
		var $state;
		if (state.id == 1) {
			$state = $('<span><p style="margin-left: 5px;margin-right: 10px;width:15px;height:15px;border:1px solid DeepSkyBlue;border-radius:50px;background-color:DeepSkyBlue;float:left"></p>'
					+ state.text + '</span>');
		} else if (state.id == 2) {
			$state = $('<span><p style="margin-left: 5px;margin-right: 10px;width:15px;height:15px;border:1px solid Tomato;border-radius:50px;background-color:Tomato;float:left"></p>'
					+ state.text + '</span>');
		} else if (state.id == 3) {
			$state = $('<span><p style="margin-left: 5px;margin-right: 10px;width:15px;height:15px;border:1px solid Gold;border-radius:50px;background-color:Gold;float:left"></p>'
					+ state.text + '</span>');
		}
		return $state;
	}

	function initDate() {
		$('#dd').calendar({
			trigger : '#date1',
			zIndex : 999,
			format : 'yyyy/mm/dd',
			onSelected : function(view, date, data) {
			},
			onClose : function(view, date, data) {
				$('#date1').val(formatDate(date).substring(0, 10));
			}
		});

		$('#dd2').calendar({
			trigger : '#date2',
			zIndex : 999,
			format : 'yyyy/mm/dd',
			onSelected : function(view, date, data) {
			},
			onClose : function(view, date, data) {
				$('#date2').val(formatDate(date).substring(0, 10));
			}
		});
	}

	function getMyTenderList(tPage) {
		page = tPage;
		var tenderCompany = $("#companyId").val();
		var tenderAgency = $("#tenderAgency").val();
		var projectId = $("#projectId").val();
		var saleUser = $("#salesId").val();
		var date1 = $("#date1").val();
		var date2 = $("#date2").val();
		var tenderStyle = $("#tenderStyle").val();
		var tenderResult = $("#tenderResult").val();
		tenderCompany = (tenderCompany == 0 || tenderCompany == null) ? ""
				: tenderCompany;
		tenderAgency = (tenderAgency == null) ? 0 : tenderAgency;
		projectId = (projectId == 0 || projectId == null) ? "" : projectId;
		saleUser = (saleUser == null) ? 0 : saleUser;
		tenderStyle = (tenderStyle == null) ? 0 : tenderStyle;
		if (new Date(date1) > new Date(date2) && date1 != "" && date2 != "") {
			alert("错误：第一个日期不能晚于第二个日期");
			return;
		}

		$
				.ajax({
					url : host + "/getTenderList",
					type : 'GET',
					data : {
						"tenderStyle" : tenderStyle,
						"tenderResult" : tenderResult,
						"tenderCompany" : tenderCompany,
						"tenderAgency" : tenderAgency,
						"projectId" : projectId,
						"saleUser" : saleUser,
						"date1" : date1,
						"date2" : date2
					},
					cache : false,
					async : false,
					success : function(returndata) {
						var data = eval("(" + returndata + ")").tenderlist;
						var str = "";
						var tenderResult;
						var tenderState;
						var num = data.length;
						var tenderArr = new Array();
						tenderReportStateArr = new Array();
						if (num == 0) {
							lastPage = 1;
							str += '<tr style="width: 1300px; height:40px;text-align: center;"><td style="color:red" border=0 >没有你要找的标书</td></tr>';
						} else {
							lastPage = Math.ceil(num / 10);
							for ( var i in data) {
								var tenderCompanyStyle = "";
								var bgColor = "";
								var tenderUploadInfo = ""
								if (i >= 10 * (tPage - 1)
										&& i <= 10 * tPage - 1) {
									tenderArr.push(data[i].saleUser);
									tenderReportStateArr.push(i + "#"
											+ data[i].projectId);
									tenderResult = data[i].tenderResult;
									if (tenderResult == 1) {
										bgColor = "DeepSkyBlue";
									} else if (tenderResult == 2) {
										bgColor = "Tomato";
									} else if (tenderResult == 3) {
										bgColor = "Gold";
									} else {
										bgColor = "white";
										if (new Date(data[i].dateForSubmit) > new Date()) {
											tenderCompanyStyle = "color:blue;";
										} else {
											tenderCompanyStyle = "color:red;";
										}
									}
									if (data[i].isUploadTender) {
										tenderUploadInfo = "下载";
									} else {
										tenderUploadInfo = "点击请上传";
									}

									str += '<tr style="width:100%">'
											+ '<td style="width:20%;'
											+ tenderCompanyStyle
											+ '" class="tdColor2">'
											+ data[i].tenderNum
											+ '</td>'
											+ '<td style="width:46%" class="tdColor2">'
											+ getProject(data[i].projectId).projectName
											+ '</br>'
											+ getCompany(data[i].tenderCompany).companyName
											+ '</td>'
											+ '<td style="width:8%" class="tdColor2">'
											+ getSalesManager(data[i].saleUser).name
											+ '</td>'
											+ '<td style="width:8%" class="tdColor2">'
											+ '<a href="#" id="a_'
											+ i
											+ '" onclick="getUploadInfo('
											+ i
											+ ','
											+ data[i].id
											+ ',\''
											+ data[i].projectId
											+ '\',\''
											+ data[i].tenderNum
											+ '\','
											+ data[i].saleUser
											+ ',\''
											+ data[i].tenderCompany
											+ '\')">'
											+ tenderUploadInfo
											+ '</a></td>'
											+ '<td style="width:10%" class="tdColor2">'
											+ data[i].dateForSubmit
											+ '</td>'
											+ '<td style="width:8%;background-color:'
											+ bgColor
											+ '" class="tdColor2">'
											+ '<img title="查看" name="img_edit" class="operation" src="../image/update.png" style="vertical-align:middle" onclick="toEditTenderPage('
											+ data[i].id
											+ ')"/>'
											+ '<a name="a_edit" style="vertical-align:middle" onclick="toEditTenderPage('
											+ data[i].id
											+ ')">查看</a>'
											+ '</td></tr>';

								}
							}
						}
						document.getElementById('p').innerHTML = tPage + "/"
								+ lastPage;
						$("#tb").empty();
						$("#tb").append(str);
						matchUserPremission(tenderArr);
					},
					error : function(XMLHttpRequest, textStatus, errorThrown) {
					}
				});
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

	function getProject(mProjectId) {
		var project;
		$.ajax({
			url : host + "/getProjectByProjectId",
			type : 'GET',
			data : {
				"projectId" : mProjectId
			},
			cache : false,
			async : false,
			success : function(returndata) {
				project = eval("(" + returndata + ")").project[0];
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
		return project;
	}

	function getSalesManager(mSalesId) {
		var sales;
		$.ajax({
			url : host + "/getUserById",
			type : 'GET',
			data : {
				"uId" : mSalesId
			},
			cache : false,
			async : false,
			success : function(returndata) {
				sales = eval("(" + returndata + ")").user[0];
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
		return sales;
	}

	function getSalesByCompanyId(companyId) {
		var mSalesId;
		$.ajax({
			url : host + "/getCompanyByCompanyId",
			type : 'GET',
			data : {
				"companyId" : companyId
			},
			cache : false,
			async : false,
			success : function(returndata) {
				var data = eval("(" + returndata + ")").company;
				mSalesId = data[0].salesId;
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
		return mSalesId;
	}
	
	function getUserInfo(uNickName) {
		var mUid;
		$.ajax({
			url : "${pageContext.request.contextPath}/getUserByNickName",
			type : 'GET',
			async : false,
			data : {
				"nickName" : uNickName
			},
			cache : false,
			success : function(returndata) {
				var data = eval("(" + returndata + ")").user;
				mUid = data[0].UId;
			}
		});
		return mUid;
	}
	
	

	function getUploadInfo(t, mId, mProjectId, mTenderNum, mSales,mCompanyId) {
		var state = document.getElementById("a_" + t).innerHTML;
		if (state == "下载") {
			downloadTender(getProjectReport(mProjectId), mProjectId);
		} else {
			uploadTenderWin(t, mId, mTenderNum, mSales, mProjectId,mCompanyId);
		}
	}

	function getProjectReport(tProjectId) {
		var fileName = "";
		$.ajax({
			url : host + "/projectReportList",
			type : 'GET',
			data : {
				"projectId" : tProjectId
			},
			cache : false,
			async : false,
			success : function(returndata) {
				var data2 = eval("(" + returndata + ")").prList;
				for ( var i in data2) {
					var reportType = data2[i].reportType;
					if (reportType == 98) {
						fileName = data2[i].fileName;
						break;
					}
				}
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
		return fileName;
	}

	function checkUplaodTender(tProjectId) {
		var isExist = false;
		$.ajax({
			url : host + "/queryUploadFile",
			type : 'GET',
			data : {
				"createYear" : "",
				"projectId" : tProjectId,
				"reportType" : 98
			},
			cache : false,
			async : false,
			success : function(returndata) {
				var data = eval("(" + returndata + ")").fileList;
				if (data.length > 0) {
					var path = data[0].path;
					var upFileName = path.substring(path.lastIndexOf("\/") + 1,
							path.length);
					upFileNameArr.push(upFileName);
					isExist = true;
				} else {
					upFileNameArr.push("");
				}
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
		return isExist;
	}

	function uploadTenderWin(t, tId, tTenderNum, tSalesId, tProjectId,tCompanyId) {
		if (!isPermissionEditArr[t % 10]) {
			alert("你没有权限上传此投标文件");
		} else {
			$("#progressDiv").hide();
			$("#myfile").val("");
			document.getElementById("progress").style.width = 0;
			document.getElementById("progress").innerHTML = "";
			$("#banDel2").show();
			tUploadFileInfo = tTenderNum + "#" + tSalesId + "#" + tProjectId
					+ "#" + tId + "#" + tCompanyId;
		}
	}

	function addTenderReport() {
		var myFile = document.getElementById("myfile").files[0];
		if (myFile != undefined) {
			if (myFile.size > 1 * 1024 * 1024 * 1024) {
				alert("单个文件上传不能大于1GB");
			} else {
				chunks = Math.ceil(myFile.size / sliceSize);
				$("#progressDiv").show();
				currentChunk = 0;
				doUploadFile(myFile);
			}
		} else {
			alert("请选择投标文件");
		}
	}

	function downloadTender(fileName, projectId) {
		$.ajax({
			url : host + "/downloadFile",
			type : 'GET',
			data : {
				"fileName" : fileName,
				"reportType" : 98,
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

	function doUploadFile(tFile) {
		if (currentChunk < chunks) {
			var formData = new FormData();
			formData.append('reportType', 98);
			formData.append('projectId', tUploadFileInfo.split("#")[2]);
			formData.append('createYear', "");
			formData.append('fileSize', tFile.size);
			formData.append('fileName', tFile.name);
			formData.append('chunks', chunks);
			formData.append('chunk', currentChunk);
			formData.append('file', getSliceFile(tFile, currentChunk));
			
			formData.append('salesId', tUploadFileInfo.split("#")[1]);
			formData.append('userId', getUserInfo(sId));
            
			formData.append('projectName', getProject(tUploadFileInfo.split("#")[2]).projectName);
			formData.append('companyName', getCompany(tUploadFileInfo.split("#")[4]).companyName);
			
			
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
						doUploadFile(tFile);
					} else {
						alert("上传错误，错误信息：" + info);
						return;
					}
				}
			}
		} else {
			//alert("开始编辑标书信息")
			editTender(tFile);
		}
	}

	function editTender(mFile) {
		$.ajax({
			url : host + "/editTender",
			type : 'POST',
			cache : false,
			data : {
				"id" : tUploadFileInfo.split("#")[3],
				"tenderNum" : tUploadFileInfo.split("#")[0],
				"tenderCompany" : "",
				"tenderAgency" : 0,
				"projectId" : tUploadFileInfo.split("#")[2],
				"saleUser" : tUploadFileInfo.split("#")[1],
				"dateForBuy" : "",
				"dateForSubmit" : "",
				"dateForOpen" : "",
				"tenderStyle" : 0,
				"tenderExpense" : 0,
				"productStyle" : 0,
				"productBrand" : 0,
				"enterpriseQualificationRequirment" : "",
				"technicalRequirment" : "",
				"remark" : "",
				"tenderResult" : 0,
				"tenderIntent" : 0,
				"serviceExpense" : 0,
				"isUploadTender" : true
			},
			success : function(returndata) {
				var data = eval("(" + returndata + ")").errcode;
				if (data == 0) {
					saveTenderReport(mFile);
				} else {
					alert("编辑标书失败");
				}
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
	}

	function saveTenderReport(tFile) {
		setTimeout(function() {
			//保存到数据库
			$.ajax({
				url : host + "/createProjectReport",
				type : 'POST',
				data : {
					"contactDate" : "",
					"userId" : tUploadFileInfo.split("#")[1],
					"reportDesc" : tUploadFileInfo.split("#")[0],
					"projectId" : tUploadFileInfo.split("#")[2],
					"reportType" : 98,
					"fileName" : tFile.name,
					"caseId" : ""
				},
				cache : false,
				async : false,
				success : function(returndata) {
					var data = eval("(" + returndata + ")").errcode;
					if (data == 0) {
						alert("提交成功");
						closeConfirmBox();
						getMyTenderList(page);
					} else {
						alert("提交失败");
					}
				},
				error : function(XMLHttpRequest, textStatus, errorThrown) {
				}
			});
		}, 500);
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

	function changeCompany(tCompanyId) {
		var salesId = getSalesByCompanyId(tCompanyId);
		getSalesList(salesId);
		getProjectList(tCompanyId, 0);
	}

	function nextPage() {
		if (page == lastPage) {
			alert("已经是最后一页");
			return;
		} else {
			page++;
			getMyTenderList(page);
		}
	}

	function previousPage() {
		if (page == 1) {
			alert("已经是第一页");
			return;
		} else {
			page--;
			getMyTenderList(page);
		}
	}

	function FirstPage() {
		if (page == 1) {
			alert("已经是首页");
			return;
		} else {
			page = 1;
			getMyTenderList(page);
		}
	}

	function LastPage() {
		if (page == lastPage) {
			alert("已经是尾页");
			return;
		} else {
			page = lastPage;
			getMyTenderList(page);
		}
	}
</script>

</head>
<body>
	<div id="pageAll">
		<div class="pageTop">
			<div class="page">
				<img src="../image/coin02.png" /><span><a href="#">首页</a>&nbsp;-&nbsp;<a
					href="#">招标管理</a>&nbsp;-</span>&nbsp;标书信息管理
			</div>
		</div>

		<div class="page">
			<!-- vip页面样式 -->
			<div class="vip">
				<div class="conform">
					<form>
						<div class="cfD">
							<Strong style="margin-right: 20px">查询条件：</Strong> <label
								style="margin-right: 10px">招标单位：</label><select class="selCss"
								style="width: 300px" id="companyId"
								onChange="changeCompany(this.options[this.options.selectedIndex].value)" /></select>
							<label style="margin-right: 10px">招标代理机构：</label><select
								class="selCss" style="width: 300px" id="tenderAgency" /></select>
						</div>

						<div class="cfD">
							<label style="margin-left: 114px; margin-right: 10px">项目名称：</label><select
								class="selCss" style="width: 300px" id="projectId">
								<option value="0">请选择...</option>
							</select> <label style="margin-right: 10px; margin-left: 48px">销售人员：</label><select
								class="selCss" style="width: 300px" id="salesId" /></select>
						</div>

						<div class="cfD">
							<label style="margin-left: 114px">投标日期：</label><input type="text"
								id="date1" style="width: 115px; padding-left: 8px" class="input3"
								placeholder="0000/00/00"> <span id="dd"></span><Strong
								style="margin-left: 15px; margin-right: 5px">至</Strong> <input
								type="text" id="date2" style="width: 115px; padding-left: 8px"
								class="input3" placeholder="0000/00/00"> <span id="dd2"></span><label
								style="margin-left: 48px; margin-right: 10px">投标类型：</label><select
								class="selCss" style="width: 300px" id="tenderStyle" /></select>
						</div>

						<div class="cfD">
							<label style="margin-left: 114px; margin-right: 10px">投标结果：</label><select
								class="selCss" style="width: 300px" id="tenderResult">
								<option value="0">请选择...</option>
								<option value="1">中标</option>
								<option value="2">投标未中</option>
								<option value="3">未投标/弃标</option>
							</select> <a class="addA" href="#"
								onClick="toCreateTenderPage()" style="margin-left: 50px">新建标书信息+</a> <a class="addA"
								onClick="getMyTenderList(1)">搜索</a>
						</div>
					</form>
				</div>
				<!-- vip 表格 显示 -->
				<div class="conShow">
					<table border="1" style="width: 100%">
						<tr style="width: 100%">
							<td style="width: 20%" class="tdColor">招标编号</td>
							<td style="width: 46%" class="tdColor">项目名称 / 招标单位</td>
							<td style="width: 8%" class="tdColor">销售</td>
							<td style="width: 8%" class="tdColor">投标文件</td>
							<td style="width: 10%" class="tdColor">投标日期</td>
							<td style="width: 8%" class="tdColor">操作</td>
						</tr>
					</table>
					<table id="tb" border="1" style="width: 100%">
					</table>
					<div class="paging" style="margin-top: 20px; margin-bottom: 50px;">
						<p
							style="margin-left: 10px; width: 15px; height: 15px; border: 1px solid; border-radius: 50px; float: left">
						</p>
						<span style="margin-left: 5px; float: left">&nbsp;未确认&nbsp;</span>
						<p
							style="margin-left: 10px; width: 15px; height: 15px; border: 1px solid DeepSkyBlue; border-radius: 50px; background-color: DeepSkyBlue; float: left">
						</p>
						<span style="margin-left: 5px; float: left">&nbsp;&nbsp;中标&nbsp;&nbsp;</span>
						<p
							style="margin-left: 10px; width: 15px; height: 15px; border: 1px solid Tomato; border-radius: 50px; background-color: Tomato; float: left">
						</p>
						<span style="margin-left: 5px; float: left">&nbsp;投标未中</span>
						<p
							style="margin-left: 10px; width: 15px; height: 15px; border: 1px solid Gold; border-radius: 50px; background-color: Gold; float: left">
						</p>
						<span style="margin-left: 5px; float: left">未投标/弃标</span> <input
							type="button" class="submit" value="首页"
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

	<!-- 上传投标文件弹出框 -->
	<div class="banDel" id="banDel2">
		<div class="delete" style="width: 600px">
			<div class="close">
				<a><img
					src="${pageContext.request.contextPath}/image/shanchu.png"
					onclick="closeConfirmBox()" /></a>
			</div>
			<p class="delP1">上传投标文件</p>
			<p class="delP2" style="margin-top: 10px;">
				<label style="font-size: 16px;">上传附件：</label><input type="file"
					name="myfile" id="myfile"
					style="width: 410px; margin-top: 15px; margin-left: 10px; border: none;"
					accept="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet, application/vnd.ms-excel,application/vnd.ms-powerpoint,application/msword,image/*,application/pdf,application/x-zip-compressed,application/x-rar-compressed,.docx,.rar" />
			</p>

			<p class="delP2" style="text-align: center; margin-top: 15px;">
				<label style="font-size: 16px; color: brown">所有投标文件请打包成一个文件上传</label><br />
			</p>

			<p class="delP2" style="height: 20px;">
			<div id="progressDiv"
				style="width: 500px; height: 20px; background-color: gray; margin-left: 50px;">
				<span id="progress"
					style="display: inline-block; height: 20px; background-color: orange; line-height: 20px; text-align: left; float: left"></span>
			</div>
			</p>

			<p class="delP2" style="margin-top: 40px;">
				<a class="addA" href="#" onclick="addTenderReport()"
					style="margin-left: 0px; margin-bottom: 30px;">提交</a><a
					class="addA" href="#" onclick="closeConfirmBox()">取消</a>
			</p>
		</div>
	</div>

</body>
</html>