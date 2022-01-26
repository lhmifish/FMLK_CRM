<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="pragma" content="no-cache" />
<meta http-equiv="cache-control" content="no-cache" />
<title>技术派工</title>
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/css.css?v=1990" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/select4.css?v=1997" />
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.2.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/select3.js"></script>
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
	var page;
	var lastPage;
	var sId;
	var host;
	var isPermissionView;

	$(document).ready(function() {
		sId = "${sessionId}";
		host = "${pageContext.request.contextPath}";
		checkViewPremission(26);
	});
	
	
	function initialPage(){
		page = 1;
		getProjectCaseList(page);
	}


	function getProjectCaseList(mPage) {
		page = mPage;
		$
				.ajax({
					url : host + "/projectCaseUnPatchList",
					type : 'GET',
					data : {
						"unPatch" : 1
					},
					cache : false,
					async : false,
					success : function(returndata) {
						var data = eval("(" + returndata + ")").pclist;
						var str = "";
						var num = data.length;
						var projectCaseArr = new Array();
						if (num > 0) {
							lastPage = Math.ceil(num / 10);
							for ( var i in data) {
								if (i >= 10 * (mPage - 1)
										&& i <= 10 * mPage - 1) {
									projectCaseArr.push(data[i].salesId);
									str += '<tr style="width: 100%"><td style="width: 8%" class="tdColor2">'
											+ getUser(data[i].salesId).name
											+ '</td>'
											+ '<td style="width:48%" class="tdColor2">'
											+ getProject(data[i].projectId).projectName
											+ '</br>'
											+ getCompany(data[i].projectId).companyName
											+ '</td>'
											+ getServiceType(data[i].serviceType)
											+ '<td style="width:6%" class="tdColor2">'
											+ getCaseType(data[i].caseType
													.split("#")[1]).typeName
											+ '</td>'
											+ '<td style="width:8%" class="tdColor2">'
											+ data[i].serviceDate.substring(0,
													10)
											+ '</br>'
											+ data[i].serviceDate.substring(11,
													16)
											+ '</td>'
											+ '<td style="width:8%" class="tdColor2"><span style="color:red">技术未审核</span></td>'
											+ '<td style="width:8%" class="tdColor2">'
											+ data[i].createDate.substring(0,
													10)
											+ '</td>'
											+ '<td style="width:8%" class="tdColor2">'
											+ '<img name="img_edit" title="派工" style="vertical-align:middle" class="operation delban" src="../image/update.png" onclick="toEditProjectCasePage('
											+ data[i].id
											+ ',2)"><a name="a_edit" style="vertical-align:middle" onclick="toEditProjectCasePage('
											+ data[i].id
											+ ',2)">派工</a></td></tr>';
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
						
					},
					error : function(XMLHttpRequest, textStatus, errorThrown) {
					}
				});
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

	function getProject(mProjectId) {
		var project;
		$
				.ajax({
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

	function getCompany(mProjectId) {
		var company;
		$
				.ajax({
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

	function getCaseType(typeId) {
		var type;
		$.ajax({
			url : host + "/getCaseTypeByTypeId",
			type : 'GET',
			data : {
				"typeId" : typeId
			},
			cache : false,
			async : false,
			success : function(returndata) {
				type = eval("(" + returndata + ")").caseType[0];
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
		return type;
	}

	function getServiceType(mServiceType) {
		if (mServiceType == 1) {
			return '<td style="width:6%" class="tdColor2"><span>一般</span></td>';
		} else {
			return '<td style="width:6%" class="tdColor2"><span style="color:brown">紧急</span></td>';
		}
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
</script>
</head>

<body id="body" style="display: none">
	<div id="pageAll">
		<div class="pageTop">
			<div class="page">
				<img src="../image/coin02.png" /><span><a href="#">首页</a>&nbsp;-&nbsp;<a
					href="#">派工管理</a>&nbsp;-&nbsp;<a href="#">派工单审核</a>&nbsp;-</span>&nbsp;技术派工
			</div>
		</div>

		<div class="page">
			<!-- vip页面样式 -->
			<div class="vip">
				<!-- vip 表格 显示 -->
				<div class="conShow">
					<table border="1" style="width: 100%">
						<tr style="width: 100%">
							<td style="width: 8%" class="tdColor">销售</td>
							<td style="width: 48%" class="tdColor">项目名称 / 客户名称</td>
							<td style="width: 6%" class="tdColor">优先级</td>
							<td style="width: 6%" class="tdColor">派工类别</td>
							<td style="width: 8%" class="tdColor">服务开始时间</td>
							<td style="width: 8%" class="tdColor">审核状态</td>
							<td style="width: 8%" class="tdColor">申请时间</td>
							<td style="width: 8%" class="tdColor">操作</td>
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
</body>


</html>