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
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.2.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/select3.js"></script>
<script src="${pageContext.request.contextPath}/js/checkPermission.js"></script>
<script src="${pageContext.request.contextPath}/js/changePsd.js"></script>
<script src="${pageContext.request.contextPath}/js/commonUtils.js"></script>
<script src="${pageContext.request.contextPath}/js/getObjectList.js?v=2024"></script>
<style type="text/css">
a:hover {
	color: #FF00FF
} /* 鼠标移动到链接上 */
</style>
<script type="text/javascript">
	var salesId;
	var isPermissionView;
	var sId;
	var host;
	var isFmlkShare;
	
	$(document).ready(function() {
		sId = "${sessionId}";
		host = "${pageContext.request.contextPath}";
		checkViewPremission(12);
	});
	
	function initialPage() {
		isFmlkShare = true;
		getCompanyList("",0,0,1,isFmlkShare);
		getProjectTypeList(0,isFmlkShare);
		getProjectManagerList(0,null,null);
		getProductStyleList(0,isFmlkShare);
		$("#projectManagerView").css('display', 'none');
		$("#companyId").select2({});
		$("#projectManager").select2({});
		$("#contactUsers").select2({
			placeholder : "请选择..."
		});
		$("#projectType").select2({});
		$("#productStyle").select2({});
	}

	function changeCompany(tCompanyId) {
		salesId = getSalesByCompanyId(tCompanyId).salesId;
		$("#salesName").val(getUser(salesId).name);
		getMultiContactUsersList(tCompanyId,null);
	}
	
	function getSalesByCompanyId(companyId) {
		var mSales;
		$.ajax({
			url : host + "/getCompanyByCompanyId",
			type : 'GET',
			data : {
				"companyId" : companyId
			},
			cache : false,
			async : false,
			success : function(returndata) {
				mSales = eval("(" + returndata + ")").company[0];
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
		return mSales;
	}
	
	function getUser(userId) {
		var user;
		$.ajax({
			url : host + "/getUserById",
			type : 'GET',
			data : {
				"uId" : userId
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
	
	function checkCompanyType(j) {
		companyType = j;
		var isCheck = document.getElementsByName('field03');
		if (isCheck[0].checked == true) {
			//陪护床
			$("#projectManagerView").css('display', 'none');
			$("#productStyleView").css('display', 'block');
			isFmlkShare = true;
		} else {
			//信息
			$("#projectManagerView").css('display', 'block');
			$("#productStyleView").css('display', 'none');
			isFmlkShare = false;
		}
		$("#salesName").val("");
		$("#projectName").val("");
		$("#contactUsers").empty();
		$("#contactUsers").val("").trigger("change");
		getCompanyList("",0,0,1,isFmlkShare);
		getProjectTypeList(0,isFmlkShare);
		//重置
		getProductStyleList(0,isFmlkShare);
		getProjectManagerList(0,null,null);
	}

	function createNewProject() {
		if(!isPermissionView){
			alert("你没有权限新建项目");
			return;
		}
		var projectName = $("#projectName").val().trim();
		var companyId = $("#companyId").val();
		var projectType = $("#projectType").val();
		var projectManager = $("#projectManager").val();
		var productStyle = $("#productStyle").val();
		var contactUsersArr = new Array();
		$("#contactUsers option:selected").each(function() {
			contactUsersArr.push($(this).val());
		});

		if (projectName == "") {
			alert("项目名称不能为空");
			return;
		}

		if (companyId == 0) {
			alert("请选择客户名称");
			return;
		}

		if (contactUsersArr.length == 0) {
			alert("请选择客户联系人");
			return;
		}

		if (projectType == 0) {
			alert("请选择项目类型");
			return;
		}
		if(isFmlkShare && productStyle == 0){
			alert("请选择产品类别");
			return;
		}

		$.ajax({
			url : host + "/createNewProject",
			type : 'POST',
			cache : false,
			dataType : "json",
			data : {
				"projectName" : projectName,
				"companyId" : companyId,
				"contactUsers" : contactUsersArr,
				"salesId" : salesId,
				"projectType" : projectType,
				"projectManager" : projectManager,
				"productStyle":productStyle,
				"isFmlkShare":isFmlkShare
			},
			traditional : true,
			success : function(returndata) {
				var data = returndata.errcode;
				if (data == 0) {
					alert("提交成功");
					setTimeout(function() {
						toProjectListPage();
					}, 500);
				} else if (data == 3) {
					alert("有相同或类似的项目名存在，请检查");
				} else {
					alert("输入失败");
				}
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
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
						<label>项目名称：</label><input type="text" class="input3"
							id="projectName" style="width: 790px;" />
					</div>

					<div class="bbD">
						<label>客户名称：</label><select class="selCss" id="companyId"
							style="width: 350px;"
							onChange="changeCompany(this.options[this.options.selectedIndex].value)" /></select>
						<label style="margin-left: 15px">客户联系人：</label><select
							class="selCss" id="contactUsers" multiple="multiple"
							style="width: 330px;"></select>
					</div>

					<div class="bbD">
						<label>销售人员：</label><input type="text" class="input3"
							id="salesName" style="width: 340px; background-color: #EEE"
							disabled="disabled" /><label style="margin-left: 32px">项目类型：</label><select
							class="selCss" id="projectType" style="width: 330px;"></select>
					</div>
					<div class="bbD" id="projectManagerView">
						<label>项目经理：</label><select class="selCss" id="projectManager"
							style="width: 350px;" /></select>
					</div>
					<div class="bbD" id="productStyleView">
						<label>产品类别：</label><select class="selCss" id="productStyle"
							style="width: 350px;" /></select>
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