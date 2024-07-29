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
<script src="${pageContext.request.contextPath}/js/getObjectList.js?v=2011"></script>
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
	var isFmlkShare;

	$(document).ready(function() {
		sId = "${sessionId}";
		host = "${pageContext.request.contextPath}";
		checkEditPremission(33, 0);
		sliceSize = 1 * 1024 * 1024;
	});

	function initialPage() {
		var isCheck = document.getElementsByName('field03');
		isFmlkShare = isCheck[0].checked;
		getCompanyList("", 0, 0, 1,isFmlkShare);
		getSalesList(0);
		getTenderStyleList(0);
		getProductStyleList(0,isFmlkShare);
		initDate();
		$("#companyId").select2({});
		$("#salesId").select2({});
		$("#projectId").select2({});
		$("#tenderStyle").select2({});
		$("#tenderResult").select2({
			templateResult : formatTenderResult
		});
		$("#productStyle").select2({});
		setTimeout(function() {
			getMyTenderList(1);
		}, 1000);
	}

	function formatTenderResult(state) {
		if (!state.id) {
			return state.text;
		}
		var $state;
		if(state.id == 0){
			$state = $('<span><p style="margin-left: 5px;margin-right: 10px;width:15px;height:15px;border:1px solid gray;border-radius:50px;background-color:gray;float:left"></p>'
					+ '未确认' + '</span>');
		}else if (state.id == 1) {
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
		var projectId = $("#projectId").val();
		var saleUser = $("#salesId").val();
		var date1 = $("#date1").val();
		var date2 = $("#date2").val();
		var tenderStyle = $("#tenderStyle").val();
		var productStyle = $("#productStyle").val();
		var tenderResult = $("#tenderResult").val();
		tenderCompany = (tenderCompany == 0 || tenderCompany == null) ? "": tenderCompany;
		projectId = (projectId == 0 || projectId == null) ? "" : projectId;
		saleUser = (saleUser == null) ? 0 : saleUser;
		tenderStyle = (tenderStyle == null) ? 0 : tenderStyle;
		productStyle = (productStyle == null) ? 0 : productStyle;
		tenderResult = (tenderResult == null) ? 0 : tenderResult;
		if (new Date(date1) > new Date(date2) && date1 != "" && date2 != "") {
			alert("错误：投标开始日期不能晚于结束日期");
			return;
		}
        $
				.ajax({
					url : host + "/getTenderList",
					type : 'GET',
					data : {
						"tenderCompany" : tenderCompany,
						"projectId" : projectId,
						"saleUser" : saleUser,
						"date1" : date1,
						"date2" : date2,
						"tenderStyle" : tenderStyle,
						"productStyle":productStyle,
						"tenderResult" : tenderResult,
						"isFmlkShare":isFmlkShare
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
								var bgColor = "";
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
										bgColor = "gray";
									}
									str += '<tr style="width:100%">'
                                    	    + '<td style="width:1%;background-color:'+bgColor+'" class="tdColor2"></td>'
                                            + '<td style="width:19%;" class="tdColor2">'
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
											+ '\')">查看</a></td>'
											+ '<td style="width:10%" class="tdColor2">'
											+ data[i].dateForSubmit
											+ '</td>'
											+ '<td style="width:8%;" class="tdColor2">'
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
		uploadTenderWin(t, mId, mTenderNum, mSales, mProjectId,mCompanyId);
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
			alert("你没有权限查看招投标文件");
		} else {
			$("#progressDiv").hide();
			document.getElementById("progress").style.width = 0;
			document.getElementById("progress").innerHTML = "";
			$("#fileLink1").hide();
			$("#fileLink2").hide();
			$("#fileLink3").hide();
			$("#fileLink4").hide();
			$("#fileLink5").hide();
			$("#myfile1").show();
			$("#myfile2").show();
			$("#myfile3").show();
			$("#myfile4").show();
			$("#myfile5").show();
			$("#btn1").show();
			$("#btn2").show();
			$("#btn3").show();
			$("#btn4").show();
			$("#btn5").show();
			$("#myfile1").val("");
			$("#myfile2").val("");
			$("#myfile3").val("");
			$("#myfile4").val("");
			$("#myfile5").val("");
			tUploadFileInfo = tTenderNum + "#" + tSalesId + "#" + tProjectId
			+ "#" + tId + "#" + tCompanyId;
			getProjectReport(tProjectId);
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
				console.log(data2);
				for ( var i in data2) {
					var reportType = data2[i].reportType;
					if(reportType == 98){
						//投标文件
						console.log("98");
						$("#myfile3").hide();
						$("#btn3").hide();
						$("#myfile3").val("");
						$("#fileLink3").show();
						document.getElementById("fileLink3").innerHTML = data2[i].fileName;						
					}else if(reportType == 96){
						//招标文件
						console.log("96");
						$("#myfile1").hide();
						$("#btn1").hide();
						$("#myfile1").val("");
						$("#fileLink1").show();
						document.getElementById("fileLink1").innerHTML = data2[i].fileName;
					}else if(reportType == 95){
						//报价评估表
						console.log("95");
						$("#myfile2").hide();
						$("#btn2").hide();
						$("#myfile2").val("");
						$("#fileLink2").show();
						document.getElementById("fileLink2").innerHTML = data2[i].fileName;
					}else if(reportType == 94){
						//中标通知书
						console.log("94");
						$("#myfile4").hide();
						$("#btn4").hide();
						$("#myfile4").val("");
						$("#fileLink4").show();
						document.getElementById("fileLink4").innerHTML = data2[i].fileName;
					}else if(reportType == 93){
						//最终报价单
						console.log("93");
						$("#myfile5").hide();
						$("#btn5").hide();
						$("#myfile5").val("");
						$("#fileLink5").show();
						document.getElementById("fileLink5").innerHTML = data2[i].fileName;
					}
				}
				console.log("@@@@@@@@@@@@");
				$("#banDel2").show();
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
		return fileName;
	}

	function doUploadFile(tFile,id) {
		var reportType = "";
		if(id==1){
			reportType = 96;
		}else if(id==2){
			reportType = 95;
		}else if(id==3){
			reportType = 98;
		}else if(id==4){
			reportType = 94;
		}else if(id==5){
			reportType = 93;
		}
		if (currentChunk < chunks) {
			var formData = new FormData();
			formData.append('reportType', reportType);
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
						doUploadFile(tFile,id);
					} else {
						alert("上传错误，错误信息：" + info);
						return;
					}
				}
			}
		} else {
			editTender(tFile,reportType);
		}
	}

	function editTender(mFile,reportType) {
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
				"tenderExpense" : -1,
				"productStyle" : 0,
				"productBrand" : 0,
				"enterpriseQualificationRequirment" : "",
				"technicalRequirment" : "",
				"remark" : "",
				"tenderResult" : -1,
				"tenderIntent" : 0,
				"serviceExpense" : -1,
				"tenderAmount":-1,
				"isUploadTender" : true,
				"tenderGuaranteeFee":-1
			},
			success : function(returndata) {
				var data = eval("(" + returndata + ")").errcode;
				if (data == 0) {
					saveTenderReport(mFile,reportType);
				} else {
					alert("编辑标书失败");
				}
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
	}

	function saveTenderReport(tFile,reportType) {
		var reportDesc = tUploadFileInfo.split("#")[0];
		if(reportType==1){
			reportDesc += "-招标文件";
		}else if(reportType==2){
			reportDesc += "-报价评估表";
		}else if(reportType==3){
			reportDesc += "-投标文件";
		}else if(reportType==4){
			reportDesc += "-中标通知书";
		}else if(reportType==5){
			reportDesc += "-最终报价单";
		}
		
		setTimeout(function() {
			//保存到数据库
			$.ajax({
				url : host + "/createProjectReport",
				type : 'POST',
				data : {
					"contactDate" : "",
					"userId" : tUploadFileInfo.split("#")[1],
					"reportDesc" : reportDesc,
					"projectId" : tUploadFileInfo.split("#")[2],
					"reportType" : reportType,
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
		getProjectList(tCompanyId, 0,isFmlkShare);
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
	
	function checkTenderType(id){
		isFmlkShare = id==2;
		getCompanyList("", 0, 0, 1,isFmlkShare);
		$("#projectId").empty();
		$("#projectId").append("<option value='0'>请选择...</option>");
		getProductStyleList(0,isFmlkShare);
		getMyTenderList(1);
	}

	function downloadTender(id) {
		var reportType = "";
		var fileName = document.getElementById("fileLink"+id).innerHTML;
		if(id==1){
			reportType = 96;
		}else if(id==2){
			reportType = 95;
		}else if(id==3){
			reportType = 98;
		}else if(id==4){
			reportType = 94;
		}else if(id==5){
			reportType = 93;
		}
		var mProjectId = tUploadFileInfo.split("#")[2];
		$.ajax({
			url : host + "/downloadFile",
			type : 'GET',
			data : {
				"fileName" : fileName,
				"reportType" : reportType,
				"projectId" : mProjectId,
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
	
	function addTenderReport(id) {
		var myFile = document.getElementById("myfile"+id).files[0];
		if (myFile != undefined) {
			if (myFile.size > 1 * 1024 * 1024 * 1024) {
				alert("单个文件上传不能大于1GB");
			} else {
				chunks = Math.ceil(myFile.size / sliceSize);
				$("#progressDiv").show();
				currentChunk = 0;
				doUploadFile(myFile,id);
			}
		} else {
			var text = "";
			if(id==1){
				text = "招标文件";
			}else if(id==2){
				text = "报价评估表";
			}else if(id==3){
				text = "投标文件";
			}else if(id==4){
				text = "中标通知书";
			}else if(id==5){
				text = "最终报价单";
			}
			alert("请选择"+text);
		}
	}

</script>

</head>
<body>
	<div id="pageAll">
		<div class="pageTop">
			<div class="page">
				<img src="../image/coin02.png" /><span><a href="#">首页</a>&nbsp;-&nbsp;<a
					href="#">招投标管理</a>&nbsp;-</span>&nbsp;招投标信息管理
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
							<!-- <label style="margin-right: 10px">招标代理机构：</label><select
								class="selCss" style="width: 300px" id="tenderAgency" /></select> -->
								<label style="margin-left: 48px; margin-right: 10px">项目名称：</label><select
								class="selCss" style="width: 300px" id="projectId"><option value="0">请选择...</option>
							</select>
						</div>

						<div class="cfD">
							  <label style="margin-right: 10px; margin-left: 114px">销售人员：</label><select
								class="selCss" style="width: 300px" id="salesId" /></select>
								<label style="margin-left: 48px">投标日期：</label><input type="text"
								id="date1" style="width: 116px; padding-left: 8px" class="input3"
								placeholder="0000/00/00"> <span id="dd"></span><Strong
								style="margin-left: 15px; margin-right: 5px">至</Strong> <input
								type="text" id="date2" style="width: 116px; padding-left: 8px"
								class="input3" placeholder="0000/00/00"> <span id="dd2"></span>
						</div>

						<div class="cfD">
							<label
								style="margin-left: 114px; margin-right: 10px">投标类型：</label><select
								class="selCss" style="width: 160px" id="tenderStyle" /></select>
							<label
								style="margin-left: 48px; margin-right: 10px">产品类型：</label><select
								class="selCss" style="width: 160px" id="productStyle" /></select>	
							<label style="margin-left: 48px;">投标结果：</label><select
								class="selCss" style="width: 160px" id="tenderResult">
								<option value="0">请选择...</option>
								<option value="1">中标</option>
								<option value="2">投标未中</option>
								<option value="3">未投标/弃标</option></select>
						</div>

						<div class="cfD">
							 <input type="radio" name="field03" value="2" checked="checked"
						onclick="checkTenderType(2)"
						style="margin-left: 114px; " /> <label>共享陪护</label>
					    <input type="radio" name="field03" value="1" 
						onclick="checkTenderType(1)"
						style="margin-left: 20px;" /> <label>信息</label>
							 <a class="addA" href="#"
								onClick="toCreateTenderPage()" style="margin-left: 300px">新建标书信息+</a> <a class="addA"
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
							<td style="width: 8%" class="tdColor">招投标文件</td>
							<td style="width: 10%" class="tdColor">投标日期</td>
							<td style="width: 8%" class="tdColor">操作</td>
						</tr>
					</table>
					<table id="tb" border="1" style="width: 100%">
					</table>
					<div class="paging" style="margin-top: 20px; margin-bottom: 50px;">
						<p
							style="margin-left: 10px; width: 8px; height: 15px; border: 1px solid gray; background-color: gray;float: left">
						</p>
						<span style="margin-left: 5px; float: left">&nbsp;未确认&nbsp;</span>
						<p
							style="margin-left: 10px; width: 8px; height: 15px; border: 1px solid DeepSkyBlue;background-color: DeepSkyBlue; float: left">
						</p>
						<span style="margin-left: 5px; float: left">&nbsp;&nbsp;中标&nbsp;&nbsp;</span>
						<p
							style="margin-left: 10px; width: 8px; height: 15px; border: 1px solid Tomato;background-color: Tomato; float: left">
						</p>
						<span style="margin-left: 5px; float: left">&nbsp;投标未中</span>
						<p
							style="margin-left: 10px; width: 8px; height: 15px; border: 1px solid Gold;background-color: Gold; float: left">
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
		<div class="delete" style="width: 800px;height:480px">
			<div class="close">
				<a><img
					src="${pageContext.request.contextPath}/image/shanchu.png"
					onclick="closeConfirmBox()" /></a>
			</div>
			<p class="delP1">上传下载招投标文件</p>
			<p class="delP2" style="margin-top: 10px;text-align:left">
				<label style="font-size: 16px;margin-left:56px">招标文件：</label><input type="file"
					name="myfile1" id="myfile1" style="width: 410px; margin-top: 15px; margin-left: 10px; border: none;"
					accept="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet, application/vnd.ms-excel,application/vnd.ms-powerpoint,application/msword,image/*,application/pdf,application/x-zip-compressed,application/x-rar-compressed,.docx,.rar" />
				<a id="fileLink1" href="#" style="width:410px;margin-left: 10px;margin-top: 15px;line-height:42px" onclick="downloadTender(1)"></a>
				<a id="btn1" class="addA" href="#" onclick="addTenderReport(1)" style="margin-left: 10px;width:80px;height:25px;line-height:25px;font-size:12px">提交</a>
			</p>

			<p class="delP2" style="margin-top: 15px;text-align:left">
				<label style="font-size: 16px;margin-left:40px">报价评估表：</label><input type="file"
					name="myfile2" id="myfile2" style="width: 410px; margin-top: 15px; margin-left: 10px; border: none;"
					accept="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet, application/vnd.ms-excel,application/vnd.ms-powerpoint,application/msword,image/*,application/pdf,application/x-zip-compressed,application/x-rar-compressed,.docx,.rar" />
				<a id="fileLink2" href="#" style="width:410px;margin-left: 10px;margin-top: 15px;line-height:42px" onclick="downloadTender(2)"></a>
			    <a id="btn2" class="addA" href="#" onclick="addTenderReport(2)" style="margin-left: 10px;width:80px;height:25px;line-height:25px;font-size:12px">提交</a>
			</p>
			
			<p class="delP2" style="margin-top: 15px;text-align:left">
				<label style="font-size: 16px;;margin-left:56px">投标文件：</label><input type="file"
					name="myfile3" id="myfile3" style="width: 410px; margin-top: 15px; margin-left: 10px; border: none;"
					accept="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet, application/vnd.ms-excel,application/vnd.ms-powerpoint,application/msword,image/*,application/pdf,application/x-zip-compressed,application/x-rar-compressed,.docx,.rar" />
				<a id="fileLink3" href="#" style="width:410px;margin-left: 10px;margin-top: 15px;line-height:42px" onclick="downloadTender(3)"></a>
				<a id="btn3" class="addA" href="#" onclick="addTenderReport(3)" style="margin-left: 10px;width:80px;height:25px;line-height:25px;font-size:12px">提交</a>
			</p>
			
			<p class="delP2" style="margin-top: 15px;text-align:left">
				<label style="font-size: 16px;margin-left:40px">中标通知书：</label><input type="file"
					name="myfile4" id="myfile4"
					style="width: 410px; margin-top: 15px; margin-left: 10px; border: none;"
					accept="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet, application/vnd.ms-excel,application/vnd.ms-powerpoint,application/msword,image/*,application/pdf,application/x-zip-compressed,application/x-rar-compressed,.docx,.rar" />
				<a id="fileLink4" href="#" style="width:410px;margin-left: 10px;margin-top: 15px;line-height:42px" onclick="downloadTender(4)"></a>
				<a id="btn4" class="addA" href="#" onclick="addTenderReport(4)" style="margin-left: 10px;width:80px;height:25px;line-height:25px;font-size:12px">提交</a>
			</p>
			
			<p class="delP2" style="margin-top: 15px;text-align:left">
				<label style="font-size: 16px;margin-left:40px">最终报价单：</label><input type="file"
					name="myfile5" id="myfile5"
					style="width: 410px; margin-top: 15px; margin-left: 10px; border: none;"
					accept="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet, application/vnd.ms-excel,application/vnd.ms-powerpoint,application/msword,image/*,application/pdf,application/x-zip-compressed,application/x-rar-compressed,.docx,.rar" />
				<a id="fileLink5" href="#" style="width:410px;margin-left: 10px;margin-top: 15px;line-height:42px" onclick="downloadTender(5)"></a>
				<a id="btn5" class="addA" href="#" onclick="addTenderReport(5)" style="margin-left: 10px;width:80px;height:25px;line-height:25px;font-size:12px">提交</a>
			</p>
			
			<p class="delP2" style="height: 20px;">
			<div id="progressDiv"
				style="width: 700px; height: 20px; background-color: gray; margin-left: 50px;">
				<span id="progress"
					style="display: inline-block; height: 20px; background-color: orange; line-height: 20px; text-align: left; float: left"></span>
			</div>
			</p>
			
			<p class="delP2" style="margin-top: 10px;color:brown;height:50px;margin-bottom:30px">
				<label style="font-size: 22px;">每种文件有多个文件请打包上传</label>
			</p>
			<!-- 
			<p class="delP2" style="margin-top: 40px;">
				 <a class="addA" href="#" onclick="addTenderReport()"
					style="margin-left: 0px; margin-bottom: 30px;">提交</a><a
					class="addA" href="#" onclick="closeConfirmBox()">取消</a>
			</p> 
			 -->
		</div>
	</div>

</body>
</html>