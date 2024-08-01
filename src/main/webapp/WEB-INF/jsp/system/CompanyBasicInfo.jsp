<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="pragma" content="no-cache" />
<meta http-equiv="cache-control" content="no-cache" />
<title>编辑客户</title>
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/css.css?v=1997" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/select4.css?v=1999" />
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
$(document).ready(function() {	
	sId = "${sessionId}";
	host = "${pageContext.request.contextPath}";
	getCompanyInfo();
});

function getCompanyInfo(){
	$.ajax({
		url : host + "/getCompanyInfo",
		type : 'GET',
		cache : false,
		async : false,
		data : {},
		success : function(returndata) {
			var data = eval("(" + returndata + ")").company;
			$("#address").val(data[0].address);
			$("#tel").val(data[0].companyId);
			$("#mail").val(data[0].companyName);
		},
		error : function(XMLHttpRequest, textStatus, errorThrown) {
		}
	});
}

function editCompanyBasicInfo(){
	var address = $("#address").val().trim();
	var tel = $("#tel").val().trim();
	var mail = $("#mail").val().trim();
	
	if (address == "") {
		alert("公司地址不能为空");
		return;
	}

	if (tel == 0) {
		alert("公司电话不能为空");
		return;
	}
	
	if (mail == 0) {
		alert("公司邮箱不能为空");
		return;
	}

	$.ajax({
		url : host + "/editCompanyInfo",
		type : 'POST',
		cache : false,
		dataType : "json",
		data : {
			"address" : address,
			"tel" : tel,
			"mail" : mail
		},
		traditional : true,
		success : function(returndata) {
			var data = returndata.errcode;
			if (data == 0) {
				alert("编辑公司基本信息成功");
				setTimeout(function() {
					toReloadPage();
				}, 500);
			} else {
				alert("编辑公司基本信息失败");
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
				<img src="../image/coin02.png" /><span><a href="#">首页</a>&nbsp;-&nbsp;<a
					href="#">系统管理</a>&nbsp;-</span>&nbsp;公司基本信息管理
			</div>
		</div>
		<div class="page ">
			<!-- 会员注册页面样式 -->
			<div class="banneradd bor" style="height: auto">
				<div class="baTopNo">
					<span id="span_title1"></span>
				</div>
				<div class="baBody">
					<div class="bbD">
						<label>公司地址：</label><input type="text" class="input3"
							id="address" style="width: 500px;" />
					</div>

					<div class="bbD">
						<label>公司电话：</label><input type="text" class="input3" id="tel"
							style="width: 500px;" />
					</div>

					<div class="bbD" style="margin-bottom: 50px;">
						<label>公司邮箱：</label><input type="text" class="input3" id="mail"
							style="width: 500px;" />
					</div>
					

					<div class="cfD" style="margin-bottom: 30px;"
						id="operation">
						<a class="addA" href="#" onclick="editCompanyBasicInfo()"
							style="margin-left: 90px">编辑</a> <a class="addA" href="#"
							onclick="toBackPage()">返回</a>
					</div>
				</div>
			</div>

			<!-- 会员注册页面样式end -->
		</div>
	</div>
</body>
</html>