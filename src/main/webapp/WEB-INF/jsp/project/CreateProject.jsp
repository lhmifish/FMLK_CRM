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
<title>新建项目信息</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/select4.css?v=1999" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/css.css?v=1997" />
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/material_blue.css">
<link rel="stylesheet" type="text/css" href="https://npmcdn.com/flatpickr/dist/ie.css">
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.2.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/select3.js"></script>
<script src="${pageContext.request.contextPath}/js/checkPermission.js"></script>
<script src="${pageContext.request.contextPath}/js/changePsd.js"></script>
<script src="${pageContext.request.contextPath}/js/commonUtils.js"></script>
<script src="${pageContext.request.contextPath}/js/getObjectList.js?v=2027"></script>
<script src="${pageContext.request.contextPath}/js/request.js?v=4"></script>
<script src="${pageContext.request.contextPath}/js/getObject.js?v=0"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/flatpickr_v3.js?v=1999"></script>
<style type="text/css">
a:hover {
	color: #FF00FF
} /* 鼠标移动到链接上 */
.need{
   color:red;
   margin-right:5px;
   margin-left:0px
}
</style>
<script type="text/javascript">
	var salesId;
	var isPermissionView;
	var sId;
	var host;
	var isFmlkShare;
	var requestReturn;
	
	$(document).ready(function() {
		sId = "${sessionId}";
		host = "${pageContext.request.contextPath}";
		checkViewPremission(12);
	});
	
	function initialPage() {
		isFmlkShare = true;
		document.getElementById("startDate").flatpickr({
			defaultDate : "",
			mode: "single",
			enableTime: false,
			dateFormat: "Y/m/d",
			onChange : function(dateObj, dateStr) {

			}
		});
		document.getElementById("endDate").flatpickr({
			defaultDate : "",
			mode: "single",
			enableTime: false,
			dateFormat: "Y/m/d",
			onChange : function(dateObj, dateStr) {

			}
		});
		getCompanyList("",0,0,1,isFmlkShare);
		$("#companyName").css("display","none")
		//项目类型
		getProjectTypeList(0,isFmlkShare);
		//项目状态
		getProjectStateList(0);
		if(isFmlkShare){
			$("#productStyleView").show();
		}else{
			$("#projectManagerView").show();
		}
		//产品类型
		getProductStyleList(null,isFmlkShare);	
		//项目经理
		getProjectManagerList(0,null,null);
		
		$("#companyId").select2({});
		$("#contactUsers").select2({
			placeholder : "请选择..."
		});
		$("#productStyle").select2({
			placeholder : "请选择..."
		});
		$("#projectType").select2({});
		$("#projectManager").select2({});
		$("#projectState").select2({});
	}

	function changeCompany(tCompanyId) {
		if(tCompanyId==0){
			salesId = 0;
			$("#salesName").val("");
			$("#contactUsers").empty();
		}else{
			salesId = getCompany("companyId",tCompanyId).salesId;
			$("#salesName").val(getUser("uId",salesId).name);
			getMultiContactUsersList(tCompanyId,null);
		}
	}
	
	function checkCompanyType(j) {
		companyType = j;
		var isCheck = document.getElementsByName('field03');
		if (isCheck[0].checked == true) {
			//共享陪护
			$("#projectManagerView").hide();
			$("#productStyleView").show();
			isFmlkShare = true;

		} else {
			//信息
			$("#projectManagerView").show();
			$("#productStyleView").hide();
			isFmlkShare = false;
		}
		$("#projectName").val("");
		getCompanyList("",0,0,1,isFmlkShare);
		$("#contactUsers").empty();
		$("#contactUsers").val("").trigger("change");
		$("#salesName").val("");
		getProjectTypeList(0,isFmlkShare);
		getProductStyleList(null,isFmlkShare);	
		getProjectStateList(0);
		getProjectManagerList(0,null,null);
		$("#startDate").val("");
		$("#endDate").val("");
	}

	function createNewProject() {
		if(!isPermissionView){
			alert("你没有权限新建项目");
			return;
		}
		var projectName = $("#projectName").val().trim();
		var companyId = $("#companyId").val();
		var contactUsersArr = new Array();
		$("#contactUsers option:selected").each(function() {
			contactUsersArr.push($(this).val());
		});
        if(contactUsersArr.length==0){
        	contactUsersArr.push("");
        }

		var projectType = $("#projectType").val();
		var productStyleArr = new Array();
		$("#productStyle option:selected").each(function() {
			productStyleArr.push($(this).val());
		});
		var projectManager = $("#projectManager").val();
		var projectState = $("#projectState").val();
		var startDate = $("#startDate").val();
		var endDate = $("#endDate").val();
		
		if (projectName == "") {
			alert("项目名称不能为空");
			return;
		}

		if (companyId == 0) {
			alert("请选择客户名称");
			return;
		}
		
		/* if (contactUsersArr.length == 0) {
			alert("请选择客户联系人");
			return;
		} */

		if (projectType == 0) {
			alert("请选择项目类型");
			return;
		}
		
		if(productStyleArr.length == 0){
			if(isFmlkShare){
				alert("请选择产品类别");
				return;
			}else{
				productStyleArr.push("");
			}
		}

		if(startDate == "" || endDate == "" ){
			alert("请选择项目起止时间");
			return;
		}else if((new Date(startDate).getTime()-new Date(endDate).getTime())/(3600*1000)>=0){
			alert("项目起止时间错误：开始时间应早于结束时间");
			return;
		}
        var params = {
        		"projectName" : projectName,
				"companyId" : companyId,
				"contactUsers" : contactUsersArr,
				"salesId" : salesId,
				"projectType" : projectType,
				"projectManager" : projectManager,
				"productStyle":productStyleArr,
				"projectState":projectState,
				"isFmlkShare":isFmlkShare,
				"startDate":startDate,
				"endDate":endDate
        }
        post("createNewProject",params,true);
        if(requestReturn.result == "error"){
			alert(requestReturn.error);
		}else if(parseInt(requestReturn.code)==0){
			alert("提交成功");
			setTimeout(function() {
				toProjectListPage();
			}, 500);
		}else if(parseInt(requestReturn.code) == 3){
			alert("该客户有相同或类似的项目已录入，请勿重复录入");
		}else {
			alert("客户录入提交失败,错误编号:"+requestReturn.code);
		}
	}
	
	function getProjectStateList(mProjectState){
		var str = '<option value="0">售前服务</option><option value="1">项目实施</option>'
			+ '<option value="2">售后服务</option>'
	$("#projectState").empty();
	$("#projectState").append(str);
	$("#projectState").find('option[value="' + mProjectState + '"]').attr(
			"selected", true);
	}
</script>

</head>
<body id="body" style="display: none">
	<div id="pageAll">
		<div class="pageTop">
			<div class="page">
				<img src="../image/coin02.png" /><span><a href="#">首页</a>&nbsp;-&nbsp;<a
					href="#">项目管理</a>&nbsp;-</span>&nbsp;新建项目信息
			</div>
		</div>

		<div class="page">
			<div class="banneradd bor">
				<div class="baTopNo">
					<span>项目基本信息</span>
					<input type="radio" name="field03" value="2" checked="checked"
						onclick="checkCompanyType(2)"
						style="margin-left: 50px; margin-right: 5px;" /> <label>共享陪护</label>
					<input type="radio" name="field03" value="1" 
						onclick="checkCompanyType(1)"
						style="margin-left: 50px; margin-right: 5px;" /> <label>信息</label>
				</div>
				<div class="baBody">

					<div class="bbD">
						<span class="need">*</span><label style="margin-left: 0px">项目名称：</label><input type="text" class="input3"
							id="projectName" style="width: 790px;" />
					</div>

					<div class="bbD">
						<span class="need">*</span><label style="margin-left: 0px">客户名称：</label><select class="selCss" id="companyId"
							style="width: 350px;"
							onChange="changeCompany(this.options[this.options.selectedIndex].value)" /></select>
						<label style="margin-left: 18px">客户联系人：</label><select
							class="selCss" id="contactUsers" multiple="multiple"
							style="width: 330px;"></select>
					</div>

					<div class="bbD">
						<span class="need">*</span><label style="margin-left: 0px">销售人员：</label><input type="text" class="input3"
							id="salesName" style="width: 340px; background-color: #EEE"
							disabled="disabled" /><span style="margin-left: 25px"><span class="need">*</span><label style="margin-left: 0px">项目类型：</label><select
							class="selCss" id="projectType" style="width: 330px;"></select></span>
					</div>
					<div class="bbD">
					    <span id="projectManagerView" style="display:none;">
						<label style="margin-left: 12px;">项目经理：</label>
						<select class="selCss" id="projectManager" style="width: 344px;" /></select>
						</span>
						<span id="productStyleView" style="display:none;">
						<span class="need">*</span><label style="margin-left: 0px">产品类别：</label>
						<select class="selCss" id="productStyle" multiple="multiple" style="width: 344px;margin-left: 0px"/></select>
						</span>
						<span style="margin-left: 23px"><span class="need">*</span><label style="margin-left: 0px">项目状态：</label><select
							class="selCss" id="projectState" style="width: 330px;"></select></span>
					</div>
					
					<div class="bbD">
					    <span class="need">*</span><label style="margin-left: 0px">项目起止时间：</label><input class="input3" type="text" id="startDate"
							onfocus="this.blur();" style="width: 128px" /><span style="margin:0 15px">至</span><input class="input3" type="text" id="endDate"
							onfocus="this.blur();" style="width: 128px" />
					</div>
					<div class="cfD" style="margin-bottom: 30px; margin-top: 30px">
						<a class="addA" href="#" onclick="createNewProject()"
							style="margin-left: 90px">提交</a> <a class="addA"
							href="#" onclick="toIndexPage()">关闭</a>
					</div>
				</div>
			</div>
		</div>

	</div>

</body>
</html>