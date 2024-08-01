<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="pragma" content="no-cache" />
<meta http-equiv="cache-control" content="no-cache" />
<title>派工单管理</title>
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
<script src="${pageContext.request.contextPath}/js/checkPermission.js?v=3"></script>
<script src="${pageContext.request.contextPath}/js/changePsd.js"></script>
<script src="${pageContext.request.contextPath}/js/commonUtils.js"></script>
<script src="${pageContext.request.contextPath}/js/getObjectList.js"></script>
<script src="${pageContext.request.contextPath}/js/request.js?v=3"></script>
<script src="${pageContext.request.contextPath}/js/loading.js"></script>
<script src="${pageContext.request.contextPath}/js/getObject.js?v=2"></script>
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
	var isPermissionEditArr;
	var requestReturn;

	$(document).ready(function() {
		sId = "${sessionId}";
		host = "${pageContext.request.contextPath}";
		checkEditPremission(23, 0);
	});

	function initialPage() {
		page = 1;
		getSalesList(0);
		getServiceUsersList(0);
		getCompanyList("", 0, 0, 1);
		$("#salesId").select2({});
		$("#serviceUsers").select2({});
		$("#companyId").select2({});
		getProjectCaseList(page);
	}

	function getProjectCaseList(mPage) {
		loading();
		page = mPage;
		var mProjectName = $("#projectName").val().trim();
		var mSalesId = $("#salesId").val();
		var mCompanyId = $("#companyId").val();
		var mServiceUserId = $("#serviceUsers").val();
		mCompanyId = (mCompanyId == null || mCompanyId == 0) ? "" : mCompanyId;
		mServiceUserId = (mServiceUserId == null || mServiceUserId == 0) ? ""
				: mServiceUserId;
		mSalesId = (mSalesId == null) ? 0 : mSalesId;
		var params = {
			"projectName" : mProjectName,
			"salesId" : mSalesId,
			"companyId" : mCompanyId,
			"serviceUsers" : mServiceUserId
		}
		setTimeout(
				function() {
					get("projectCaseList", params, false)
					if (requestReturn.result == "error") {
						closeLoading();
						alert(requestReturn.error);
					} else {
						var data = requestReturn.data.pclist;
						var str = "";
						var num = data.length;
						var projectCaseArr = new Array();
						if (num > 0) {
							lastPage = Math.ceil(num / 10);
							for ( var i in data) {
								if (i >= 10 * (mPage - 1)
										&& i <= 10 * mPage - 1) {
									projectCaseArr.push(data[i].salesId);
									var mUser = getUser("uId", data[i].salesId);
									var mProject = getProject("projectId",data[i].projectId);
									var mCompany = getCompany("projectId",data[i].projectId);
									str += '<tr style="width: 100%;"><td style="width: 5%;font-size:14px" class="tdColor2">'
											+ mUser.name
											+ '</td>'
											+ '<td style="width:28%" class="tdColor2">'
											+ mProject.projectName
											+ '</br><span style="font-size:10px">'
											+ mCompany.companyName
											+ '</span></td>'
											+ getServiceType(data[i].serviceType)
											+ '<td style="width:6%;font-size:14px" class="tdColor2">'
											+ getCaseType(
													"typeId",
													data[i].caseType.split("#")[1]).typeName
											+ '</td>'
											+ '<td style="width:8%;font-size:14px" class="tdColor2">'
											+ data[i].serviceDate.substring(0,
													10)
											+ '</br><span style="font-size:12px">'
											+ data[i].serviceDate.substring(11,
													16)
											+ '</span></td>'
											+ '<td style="width:12%" class="tdColor2">'
											+ getServiceUsers(data[i].serviceUsers)
											+ '</td>'
											+ getIsChecked(data[i].isChecked,
													data[i].serviceUsers,
													data[i].isRejected,
													data[i].rejectReason)
											+ getCaseState(data[i].caseState,
													data[i].id, i,
													data[i].salesId,
													data[i].isChecked,
													data[i].cancelReason,
													data[i].rejectReason)
											+ '<td style="width:8%;font-size:14px" class="tdColor2">'
											+ data[i].createDate.substring(0,
													10)
											+ '</td>'
											+ getOperationTd(data[i].isChecked,
													data[i].id,data[i].salesId,mProject.projectName,mCompany.companyName) + '</tr>';
								}
							}
						} else {
							lastPage = 1;
							str += '<tr style="height:40px;text-align: center;"><td style="color:red;width:100%;" border=0>没有你要找的派工单</td></tr>';
						}
						document.getElementById('p').innerHTML = mPage + "/"
								+ lastPage;
						$("#tb").empty();
						$("#tb").append(str);
						matchUserPremission(projectCaseArr);
						closeLoading();
					}
				}, 500);
	}

	function getServiceUsers(mServiceUsers) {
		var tServiceUsers = "";
		if (mServiceUsers == "") {
			tServiceUsers = "————".trim();
		} else {
			if (mServiceUsers.indexOf(",") == -1) {
				//单个
				tServiceUsers = getUser("uId", mServiceUsers).name.trim();
			} else {
				for (var i = 0; i < mServiceUsers.split(",").length; i++) {
					tServiceUsers += getUser("uId", mServiceUsers.split(",")[i]).name
							+ ",";
				}
				tServiceUsers = tServiceUsers.substr(0, tServiceUsers
						.lastIndexOf(','));
			}
		}
		return tServiceUsers;
	}

	function getIsChecked(mIsChecked, mServiceUsers, mIsRejected, mRejectReason) {
		var isCheckedSales;
		var isCheckedTech;

		if (!mIsChecked) {
			isCheckedSales = '<span style="color:brown;font-size:14px">销售未审核</span>';
			isCheckedTech = '<span style="color:brown;font-size:14px">技术未审核</span>'
		} else if (mRejectReason != "") {
			if (mRejectReason.indexOf("@") > -1
					&& mRejectReason.split("@")[1] == 2) {
				isCheckedSales = '<span style="font-size:14px">销售已通过</span>';
				isCheckedTech = '<span style="font-size:14px;color:green;">技术已驳回</span>';
			} else {
				isCheckedSales = '<span style="font-size:14px;color:green;">销售已驳回</span>';
				isCheckedTech = '<span style="color:brown;font-size:14px">技术未审核</span>'
			}
		} else {
			isCheckedSales = '<span style="font-size:14px">销售已通过</span>';
			//未被驳回
			if (mServiceUsers != "") {
				isCheckedTech = '<span style="font-size:14px">技术已派工</span>';
			} else {
				isCheckedTech = '<span style="color:brown;font-size:14px">技术未审核</span>';
			}
		}
		return '<td style="width:8%" class="tdColor2">' + isCheckedSales
				+ "</br>" + isCheckedTech + '</td>';
	}

	function getCaseState(mCaseState, mId, i, tSalesId, tIsChecked,
			tCancelReason, tRejectReason) {
		// 0.待审批 1.处理中 2.已超时 3.已取消 4.超时完成    5.正常完成
		var str;
		var color;
		var text;
		var tUser = getUser("nickName", sId);
		var permitChangeState = (tUser.UId == tSalesId || tUser.roleId == 3 || tUser.roleId == 11);
		if (mCaseState == 0) {
			color = "brown";
			text = "待审核";
			permitChangeState = false;
		} else if (mCaseState == 1) {
			color = "blue";
			text = "处理中";
		} else if (mCaseState == 2) {
			color = "red";
			text = "已超时";
		} else if (mCaseState == 3) {
			color = "green";
			text = "已取消";
			permitChangeState = false;
		} else if (mCaseState == 4) {
			color = "green";
			text = "超时完成";
			permitChangeState = false;
		} else if (mCaseState == 5) {
			color = "green";
			text = "正常完成";
			permitChangeState = false;
		} else if (mCaseState == 6) {
			color = "green";
			text = "被驳回";
		}
		if (mCaseState == 3 && tCancelReason != "") {
			str = '<td style="width:8%" class="tdColor2" title="取消理由：'
					+ tCancelReason
					+ '"><div><span style="margin-left:8px;color:'+ color +'">'
					+ text + '</span>';
		} else if (mCaseState == 6) {
			if (tRejectReason.indexOf("@") != -1) {
				tRejectReason = tRejectReason.split("@")[0];
			}
			str = '<td style="width:8%" class="tdColor2" title="驳回理由：'
					+ tRejectReason
					+ '"><div><span style="margin-left:8px;color:'+ color +'">'
					+ text + '</span>';
		} else {
			str = '<td style="width:8%" class="tdColor2"><div><span style="margin-left:8px;color:'+ color +'">'
					+ text + '</span>';
		}

		if (permitChangeState) {
			str += '<img src="../image/coinL1.png" title="更改派工单状态" style="width:14px;float:right;margin-right:5px"  onclick="selectCaseState('
					+ i
					+ ','
					+ mId
					+ ',\''
					+ mCaseState
					+ '\''
					+ ')"></div></td>';
		} else {
			str += '<img src="../image/coinL1.png" style="width:14px;float:right;margin-right:5px;visibility:hidden"></div></td>';
		}
		return str;
	}

	function selectCaseState(t, id, tCaseState) {
		if (!isPermissionEditArr[t % 10]) {
			alert("你没有权限更改此派工状态");
		} else {
			$('#caseState').val(tCaseState);
			var str = ""
			$("#caseState").css("color", "green");
			editId = id;
			if (tCaseState == 0 || tCaseState == 6) {
				str += '<option value="3" style="color: green">取消派工</option>';
			} else if (tCaseState == 1) {
				str += '<option value="3" style="color: green">取消派工</option>';
				str += '<option value="5" style="color: green">正常完成</option>';
			} else if (tCaseState == 2) {
				str += '<option value="3" style="color: green">取消派工</option>';
				str += '<option value="4" style="color: green">超时完成</option>';
			}
			$("#caseState").empty();
			$("#caseState").append(str);
			if ($("#caseState").val() == 3) {
				$("#cancelReason").show();
			} else {
				$("#cancelReason").hide();
			}
			$("#banDel2").show();
		}
	}

	function getServiceType(mServiceType) {
		if (mServiceType == 1) {
			return '<td style="width:5%" class="tdColor2"><span>一般</span></td>';
		} else {
			return '<td style="width:5%" class="tdColor2"><span style="color:brown">紧急</span></td>';
		}
	}

	function confirmDelete(id) {
		$("#banDel").show();
		deleteId = id;
	}

	function nextPage() {
		if (page == lastPage) {
			alert("已经是最后一页");
			return;
		} else {
			page++;
			getProjectCaseList(page);
		}
	}

	function previousPage() {
		if (page == 1) {
			alert("已经是第一页");
			return;
		} else {
			page--;
			getProjectCaseList(page);
		}
	}

	function FirstPage() {
		if (page == 1) {
			alert("已经是首页");
			return;
		} else {
			page = 1;
			getProjectCaseList(page);
		}
	}

	function LastPage() {
		if (page == lastPage) {
			alert("已经是尾页");
			return;
		} else {
			page = lastPage;
			getProjectCaseList(page);
		}
	}

	function changeCaseState() {
		var selCaseState = $("#caseState").val();
		/* if (selCaseState == 0) {
			$("#caseState").css("color", "brown");
		} else if (selCaseState == 1) {
			$("#caseState").css("color", "blue");
		} else if (selCaseState == 2) {
			$("#caseState").css("color", "red");
		} else {
			$("#caseState").css("color", "green");
		} */
		$("#cancelReason").val("");
		if (selCaseState == 3) {
			$("#cancelReasonView").show();
		} else {
			$("#cancelReasonView").hide();
		}
	}

	function editProjectCase() {
		var caseState = $("#caseState option:selected").val();
		var cancelReason = $("#cancelReason").val();
		if (caseState == 3 && cancelReason == "") {
			alert("请填写取消理由");
			return;
		}
		var params = {
			"id" : editId,
			"caseState" : caseState,
			"cancelReason" : cancelReason
		}
		post("editProjectCase", params, false);
		if (requestReturn.result == "error") {
			alert(requestReturn.error);
		} else if (parseInt(requestReturn.code) == 0) {
			alert("更改派工状态成功");
			setTimeout(function() {
				closeConfirmBox();
				getProjectCaseList(page);
				parent.leftFrame.location.reload();
			}, 500);
		} else {
			alert("更改派工状态失败");
		}
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

	function getOperationTd(mIsChecked, pcId,mSalesId,mProjectName,mCompanyName) {
		var str = ""
		if (mIsChecked) {
			str = '<td style="width:12%" class="tdColor2">'
					+ '<img name="img_edit" title="查看" style="vertical-align:middle" class="operation delban" src="../image/update.png" onclick="toEditProjectCasePage('
					+ pcId
					+ ',0)"><a name="a_edit" style="vertical-align:middle" onclick="toEditProjectCasePage('
					+ pcId + ',0)">查看</a></td>';
		} else {
			str = '<td style="width:12%;height:100%;" class="tdColor2">'
					+ '<div style="display:flex;flex-direction:row;height:40px;">'
					+ '<div style="width:49.7%;height:100%;display:flex;flex-direction:row;align-items:center;justify-content:center">'
					+ '<img name="img_edit" title="查看" style="vertical-align:middle" class="operation delban" src="../image/update.png" onclick="toEditProjectCasePage('
					+ pcId + ',0)"><a name="a_edit" style="vertical-align:middle" onclick="toEditProjectCasePage('
					+ pcId + ',0)">查看</a></div><div style="width:0.6%;background-color:#dcdbdb;height:100%;"></div>'
					+ '<div style="width:49.7%;height:100%;display:flex;flex-direction:row;align-items:center;justify-content:center">'
					+ '<img title="撤回" style="vertical-align:middle" class="operation delban" src="../image/delete.png" onclick="cancelProjectCase('
					+ pcId + ','+mSalesId+',\''+mProjectName+'\',\''+mCompanyName+'\')"><a style="vertical-align:middle" onclick="cancelProjectCase('
					+ pcId + ','+mSalesId+',\''+mProjectName+'\',\''+mCompanyName+'\')">撤回</a>' + '</div></div></div></td>';
		}
		return str;
	}
	
	function cancelProjectCase(projectCaseId,mSalesId,mProjectName,mCompanyName){
		var tUser = getUser("nickName",sId);
		if(tUser.UId != mSalesId && tUser.departmentId != 6 && tUser.departmentId != 5){
			alert("你无权撤回派工单");
			return;
		}else{
			var params = {
					"id":projectCaseId,
					"salesId":mSalesId,
					"projectName":mProjectName,
					"companyName":mCompanyName
			};
			post("deleteProjectCase",params,true);
			if(requestReturn.result == "error"){
				alert(requestReturn.error);
			}else if(parseInt(requestReturn.code)==0){
				alert("派工已撤回");
				parent.leftFrame.initialPage();
				getProjectCaseList(1);
			}else{
				alert("派工撤回失败:"+ requestReturn.code);
			}
		}
		
		
	}
</script>
</head>

<body>
	<div id="pageAll">
		<div class="pageTop">
			<div class="page">
				<img src="../image/coin02.png" /><span><a href="#">首页</a>&nbsp;-&nbsp;<a
					href="#">派工管理</a>&nbsp;-</span>&nbsp;派工单管理
			</div>
		</div>

		<div class="page">
			<!-- vip页面样式 -->
			<div class="vip">
				<div class="conform">
					<form>
						<div class="cfD" style="width: 100%">
							<Strong style="margin-right: 20px">查询条件：</Strong> <label
								style="margin-right: 10px">客户名称：</label><select class="selCss"
								style="width: 23%" id="companyId" /></select> <label
								style="margin-right: 10px">项目名称：</label><input type="text"
								class="input3" placeholder="输入项目名称" style="width: 23%"
								id="projectName" />
						</div>
						<div class="cfD" style="width: 100%">
							<label style="margin-left: 124px; margin-right: 10px">销售人员：</label><select
								class="selCss" style="width: 10%" id="salesId"></select> <label
								style="margin-right: 10px;">工程师：</label><select class="selCss"
								id="serviceUsers" style="width: 10%;"></select> <a class="addA"
								href="#" onclick="toCreateProjectCasePage()"
								style="margin-left: 30px">新建派工单+</a> <a class="addA"
								onClick="getProjectCaseList(1)">搜索</a>
						</div>
					</form>
				</div>
				<!-- vip 表格 显示 -->
				<div class="conShow">
					<table border="1" style="width: 100%">
						<tr style="width: 100%">
							<td style="width: 5%" class="tdColor">销售</td>
							<td style="width: 28%" class="tdColor">项目名称 / 客户名称</td>
							<td style="width: 5%" class="tdColor">优先级</td>
							<td style="width: 6%" class="tdColor">派工类别</td>
							<td style="width: 8%" class="tdColor">服务开始时间</td>
							<td style="width: 12%" class="tdColor">服务工程师</td>
							<td style="width: 8%" class="tdColor">审核状态</td>
							<td style="width: 8%" class="tdColor">派工状态</td>
							<td style="width: 8%" class="tdColor">申请时间</td>
							<td style="width: 12%" class="tdColor">操作</td>
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

	<!-- 删除弹出框  end-->
	<!-- 删除弹出框 -->
	<div class="banDel" id="banDel2">
		<div class="delete">
			<div class="close">
				<a><img src="../image/shanchu.png" onclick="closeConfirmBox()" /></a>
			</div>
			<p class="delP1">更改派工状态</p>
			<p class="delP2" style="margin-top: 20px;">
				<label style="font-size: 16px;">请选择：</label> <select id="caseState"
					onChange="changeCaseState(this.options[this.options.selectedIndex].value)"
					style="width: 190px; height: 26px; border-bottom: 1px dashed #78639F; background: none; border-left: none; border-right: none; border-top: none; padding: 4px 2px 3px 2px; padding-left: 10px">
				</select>
			</p>
			<p class="delP2" style="margin-top: 20px;" id="cancelReasonView">
				<textarea
					style="font-size: 16px; width: 240px; height: 100px; resize: none; padding: 10px"
					placeholder="请填写取消理由" id="cancelReason"></textarea>
			</p>
			<div class="cfD" style="margin-top: 30px">
				<a class="addA" href="#" onclick="editProjectCase()"
					style="margin-left: 0px; margin-bottom: 30px;">确定</a> <a
					class="addA" onclick="closeConfirmBox()">取消</a>
			</div>
		</div>
	</div>

</body>


</html>