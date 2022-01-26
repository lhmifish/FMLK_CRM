<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title>
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/public.css?v=2019" />
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.2.1.min.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/public.js"></script>
<script src="${pageContext.request.contextPath}/js/checkPermission.js"></script>
<script src="${pageContext.request.contextPath}/js/getObjectList.js"></script>
<style type="text/css">
a:hover {
	color: #FF00FF
} /* 鼠标移动到链接上 */
::-webkit-scrollbar {
	display: none;
}
</style>
<script type="text/javascript">
	var sId;
	var host;
	var projectCaseNum;
	$(document).ready(function() {
		sId = "${sessionId}";
		host = "${pageContext.request.contextPath}";
		//sId = "gong.zhiping";
		checkMenuPremission();
	});
	
	function initialPage(){
		projectCaseNum = 0;
		getUnCheckedTenderList();
		getUnInputContract();
		getUnDispatchProjectCaseList(0);
		getUnDispatchProjectCaseList(1);
	}
</script>
</head>

<body id="bg">
	<!-- 左边节点 -->
	<div class="container">

		<div class="leftsidebar_box">
			<div class="line">
				<a href="../page/techJobList" target="rightFrame"> <img
					src="../image/coin01.png" />&nbsp;&nbsp;首页
				</a>
			</div>
			<dl class="system_log" id="line_company" style="display: none">
				<dt>
					<img class="icon1" src="../image/coin07.png" /><img class="icon2"
						src="../image/coin08.png" /> 客户关系管理<img class="icon3"
						src="../image/coin19.png" /><img class="icon4"
						src="../image/coin20.png" />
				</dt>
				<dd id="line_company_create" style="display: none">
					<img class="coin11" src="../image/coin111.png" /><img
						class="coin22" src="../image/coin222.png" /><a class="cks"
						href="../page/createCompany" target="rightFrame">新建客户信息</a><img
						class="icon5" src="../image/coin21.png" />
				<dd id="line_company_list">
					<img class="coin11" src="../image/coin111.png" /><img
						class="coin22" src="../image/coin222.png" /><a class="cks"
						href="../page/companyList" target="rightFrame">客户信息管理</a><img
						class="icon5" src="../image/coin21.png" />
				</dd>
				<!-- <dd id="line_company_confirm">
					<img class="coin11" src="../image/coin111.png" /><img
						class="coin22" src="../image/coin222.png" /><a class="cks"
						href="../page/confirmCompany" target="rightFrame">客户信息审核</a><img
						class="icon5" src="../image/coin21.png" />
				</dd> -->

			</dl>

			<dl class="system_log" id="line_project" style="display: none">
				<dt>
					<img class="icon1" src="../image/coin03.png" /><img class="icon2"
						src="../image/coin04.png" />项目管理<img class="icon3"
						src="../image/coin19.png" /><img class="icon4"
						src="../image/coin20.png" />
				</dt>
				<dd>
					<img class="coin11" src="../image/coin111.png" /><img
						class="coin22" src="../image/coin222.png" /><a
						href="../page/createProject" target="rightFrame" class="cks">新建项目信息</a><img
						class="icon5" src="../image/coin21.png" />
				</dd>
				<dd>
					<img class="coin11" src="../image/coin111.png" /><img
						class="coin22" src="../image/coin222.png" /><a
						href="../page/projectList" target="rightFrame" class="cks">项目信息管理</a><img
						class="icon5" src="../image/coin21.png" />
				</dd>
				<!-- <dd>
					<img class="coin11" src="../image/coin111.png" /><img
						class="coin22" src="../image/coin222.png" /><a
						href="../page/confirmProject" target="rightFrame" class="cks">项目信息审核</a><img
						class="icon5" src="../image/coin21.png" />
				</dd> -->
			</dl>

			<dl class="system_log" id="line_projectCase" style="display: none">
				<dt>
					<img class="icon1" src="../image/coin03.png" /><img class="icon2"
						src="../image/coin04.png" />派工管理<a id="p3"
						style="color: red; margin-left: 5px"></a><img class="icon3"
						src="../image/coin19.png" /><img class="icon4"
						src="../image/coin20.png" />
				</dt>
				<dd>
					<img class="coin11" src="../image/coin111.png" /><img
						class="coin22" src="../image/coin222.png" /><a
						href="../page/createProjectCase" target="rightFrame" class="cks">新建派工单</a><img
						class="icon5" src="../image/coin21.png" />
				</dd>

				<dd>
					<img class="coin11" src="../image/coin111.png" /><img
						class="coin22" src="../image/coin222.png" /><a
						href="../page/projectCaseList" target="rightFrame" class="cks">派工单管理</a><img
						class="icon5" src="../image/coin21.png" />
				</dd>

				<dd>
					<img class="coin11" src="../image/coin111.png" /><img
						class="coin22" src="../image/coin222.png" /><a
						href="../page/checkProjectCase" target="rightFrame" class="cks"
						id="p3_3">派工单审核</a><img class="icon5" src="../image/coin21.png" />
				</dd>

				<dd id="2" style="display: none;">
					<img class="coin333" src="../image/coin111.png" /><img
						class="coin444" src="../image/coin222.png" /><a
						href="../page/checkProjectCase" target="rightFrame" class="cks"
						style="margin-left: 30px" id="p3_3_1">销售审核</a><img class="icon5"
						src="../image/coin21.png" />
				</dd>

				<dd>
					<img class="coin333" src="../image/coin111.png" /><img
						class="coin444" src="../image/coin222.png" /><a
						href="../page/dispatchProjectCase" target="rightFrame" class="cks"
						style="margin-left: 30px" id="p3_3_2">技术派工</a><img class="icon5"
						src="../image/coin21.png" />
				</dd>
			</dl>



			<dl class="system_log" id="line_tender" style="display: none">
				<dt>
					<img class="icon1" src="../image/coin05.png" /><img class="icon2"
						src="../image/coin06.png" /> 招标管理<a id="p4"
						style="color: red; margin-left: 5px"></a><img class="icon3"
						src="../image/coin19.png" /><img class="icon4"
						src="../image/coin20.png" />
				</dt>
				<dd>
					<img class="coin11" src="../image/coin111.png" /><img
						class="coin22" src="../image/coin222.png" /><a class="cks"
						href="../page/createTender" target="rightFrame" id="">新建标书信息</a><img
						class="icon5" src="../image/coin21.png" />
				</dd>
				<dd>
					<img class="coin11" src="../image/coin111.png" /><img
						class="coin22" src="../image/coin222.png" /><a class="cks"
						href="../page/tenderList" target="rightFrame" id="p4_2">标书信息管理</a><img
						class="icon5" src="../image/coin21.png" />
				</dd>
				<!-- <dd>
					<img class="coin11" src="../image/coin111.png" /><img
						class="coin22" src="../image/coin222.png" /><a class="cks"
						href="../page/confirmTender" target="rightFrame">标书信息审核</a><img
						class="icon5" src="../image/coin21.png" />
				</dd> -->
			</dl>
			<dl class="system_log" id="line_contract" style="display: none">
				<dt>
					<img class="icon1" src="../image/coin05.png" /><img class="icon2"
						src="../image/coin06.png" /> 合同管理<a id="p5"
						style="color: red; margin-left: 5px"></a><img class="icon3"
						src="../image/coin19.png" /><img class="icon4"
						src="../image/coin20.png" />
				</dt>
				<dd>
					<img class="coin11" src="../image/coin111.png" /><img
						class="coin22" src="../image/coin222.png" /><a
						href="../page/createContract" target="rightFrame" class="cks"
						id="p5_1">新建合同</a><img class="icon5" src="../image/coin21.png" />
				</dd>
				<dd>
					<img class="coin11" src="../image/coin111.png" /><img
						class="coin22" src="../image/coin222.png" /><a
						href="../page/contractList" target="rightFrame" class="cks">合同信息管理</a><img
						class="icon5" src="../image/coin21.png" />
				</dd>
				<!-- <dd>
					<img class="coin11" src="../image/coin111.png" /><img
						class="coin22" src="../image/coin222.png" /><a
						href="../page/confirmContract" target="rightFrame" class="cks">合同审核</a><img
						class="icon11" src="../image/coin19.png" /><img class="icon12"
						src="../image/coin20.png" />
				</dd>

				<dd id="1" style="display: none;">
					<img class="coin333" src="../image/coin111.png" /><img
						class="coin444" src="../image/coin222.png" /><a
						href="../page/confirmContract" target="rightFrame" class="cks"
						style="margin-left: 30px">采购审核</a><img class="icon5"
						src="../image/coin21.png" />
				</dd>

				<dd>
					<img class="coin333" src="../image/coin111.png" /><img
						class="coin444" src="../image/coin222.png" /><a
						href="../page/confirmContract" target="rightFrame" class="cks"
						style="margin-left: 30px">技术审核</a><img class="icon5"
						src="../image/coin21.png" />
				</dd>

				<dd>
					<img class="coin333" src="../image/coin111.png" /><img
						class="coin444" src="../image/coin222.png" /><a
						href="../page/confirmContract" target="rightFrame" class="cks"
						style="margin-left: 30px">商务审核</a><img class="icon5"
						src="../image/coin21.png" />
				</dd> -->

			</dl>
			<dl class="system_log" id="line_user" style="display: none">
				<dt>
					<img class="icon1" src="../image/coin10.png" /><img class="icon2"
						src="../image/coin09.png" /> 用户管理<img class="icon3"
						src="../image/coin19.png" /><img class="icon4"
						src="../image/coin20.png" />
				</dt>
				<dd>
					<img class="coin11" src="../image/coin111.png" /><img
						class="coin22" src="../image/coin222.png" /><a class="cks"
						href="../page/createUser" target="rightFrame">新建用户</a><img
						class="icon5" src="../image/coin21.png" />
				</dd>
				<dd>
					<img class="coin11" src="../image/coin111.png" /><img
						class="coin22" src="../image/coin222.png" /><a class="cks"
						href="../page/userList" target="rightFrame">用户信息管理</a><img
						class="icon5" src="../image/coin21.png" />
				</dd>
			</dl>
			<dl class="system_log" id="line_system" style="display: none">
				<dt>
					<img class="icon1" src="../image/coin11.png" /><img class="icon2"
						src="../image/coin12.png" /> 系统管理<img class="icon3"
						src="../image/coin19.png" /><img class="icon4"
						src="../image/coin20.png" />
				</dt>
				<dd>
					<img class="coin11" src="../image/coin111.png" /><img
						class="coin22" src="../image/coin222.png" /><a
						href="../page/roleList" target="rightFrame" class="cks">角色管理</a><img
						class="icon5" src="../image/coin21.png" />
				</dd>
				<dd>
					<img class="coin11" src="../image/coin111.png" /><img
						class="coin22" src="../image/coin222.png" /><a
						href="../page/netWebOrganize_jobPosition" target="rightFrame" class="cks">人才招聘管理</a><img
						class="icon5" src="../image/coin21.png" />
				</dd>
				<dd>
					<img class="coin11" src="../image/coin111.png" /><img
						class="coin22" src="../image/coin222.png" /><a
						href="../page/companyBasicInfo" target="rightFrame" class="cks">公司基本信息管理</a><img
						class="icon5" src="../image/coin21.png" />
				</dd>
			</dl>

			<dl class="system_log" id="line_attence">
				<dt>
					<img class="icon1" src="../image/coin17.png" /><img class="icon2"
						src="../image/coin18.png" /> 考勤管理<img class="icon3"
						src="../image/coin19.png" /><img class="icon4"
						src="../image/coin20.png" />
				</dt>
				<dd>
					<img class="coin11" src="../image/coin111.png" /><img
						class="coin22" src="../image/coin222.png" /><a
						href="../page/userWorkAttendanceList" target="rightFrame"
						class="cks">个人考勤数据</a><img class="icon5" src="../image/coin21.png" />
				</dd>
				<dd>
					<img class="coin11" src="../image/coin111.png" /><img
						class="coin22" src="../image/coin222.png" /><a
						href="../page/userMonthReportList" target="rightFrame" class="cks">个人月统计数据</a><img
						class="icon5" src="../image/coin21.png" />
				</dd>
				<dd>
					<img class="coin11" src="../image/coin111.png" /><img
						class="coin22" src="../image/coin222.png" /><a
						href="../page/allWorkAttendanceList" target="rightFrame"
						class="cks">所有人考勤数据</a><img class="icon5"
						src="../image/coin21.png" />
				</dd>
				<dd>
					<img class="coin11" src="../image/coin111.png" /><img
						class="coin22" src="../image/coin222.png" /><a
						href="../page/allMonthReportList" target="rightFrame" class="cks">所有人月统计数据</a><img
						class="icon5" src="../image/coin21.png" />
				</dd>
				<dd>
					<img class="coin11" src="../image/coin111.png" /><img
						class="coin22" src="../image/coin222.png" /><a
						href="../page/createDailyReportList" target="rightFrame"
						class="cks">上传下载考勤数据</a><img class="icon5"
						src="../image/coin21.png" />
				</dd>
				<dd>
					<img class="coin11" src="../image/coin111.png" /><img
						class="coin22" src="../image/coin222.png" /><a
						href="../page/sendInformation" target="rightFrame"
						class="cks">发送通知</a><img class="icon5"
						src="../image/coin21.png" />
				</dd>
				<dd>
					<img class="coin11" src="../image/coin111.png" /><img
						class="coin22" src="../image/coin222.png" /><a
						href="../page/createCrmDailyReport" target="rightFrame"
						class="cks">填写日报</a><img class="icon5"
						src="../image/coin21.png" />
				</dd>
				<!--
				<dd>
					<img class="coin11" src="../image/coin111.png" /><img
						class="coin22" src="../image/coin222.png" /><a
						href="../page/createCrmArrangement" target="rightFrame"
						class="cks">填写日程安排</a><img class="icon5"
						src="../image/coin21.png" />
				</dd>-->
			</dl> 



		</div>

	</div>
</body>
</html>
