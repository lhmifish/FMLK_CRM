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
<title>新建用户</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/select4.css?v=1999" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/css.css?v=1997" />
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.2.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/select3.js"></script>
<script src="${pageContext.request.contextPath}/js/changePsd.js"></script>
<style type="text/css">
a:hover {
	color: #FF00FF
} /* 鼠标移动到链接上 */

::-webkit-scrollbar{
display:none;
}
</style>

<script type="text/javascript">
	var sId;

	$(document).ready(function() {
		sId = "${sessionId}";
		if (sId == null || sId == "") {
			parent.location.href = "${pageContext.request.contextPath}/page/login";
		}else{
			$("#departmentId").select2({});
			getDepartmentList();
		}
		
	});

	function changeNickName(tNickName) {
		if (tNickName != "") {
			$("#email").val(tNickName.split(".")[0]+ tNickName.split(".")[1]+ "@family-care.cn");
		}
	}

	function getDepartmentList() {
		$.ajax({
			url : "${pageContext.request.contextPath}/departmentList",
			type : 'GET',
			data : {},
			cache : false,
			async : false,
			success : function(returndata) {
				var str = '<option value="0">请选择...</option>';
				var data2 = eval("(" + returndata + ")").dList;
				for ( var i in data2) {
					str += '<option value="'+data2[i].id+'">'
							+ data2[i].departmentName + '</option>';
				}
				$("#departmentId").empty();
				$("#departmentId").append(str);

			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
	}

	function createNewUser() {
		var name = $("#name").val().trim();
		var nickName = $("#nickName").val().trim();
		var psd = $("#psd").val().trim();
		var confirmPsd = $("#confirmPsd").val().trim();
		var jobId = $("#jobId").val().trim();
		var email = $("#email").val().trim();
		var departmentId = $("#departmentId option:selected").val();
		var tel = $("#tel").val().trim();

		if (name == "") {
			alert("用户姓名不能为空");
			return;
		}

		if (nickName == "") {
			alert("登入账号不能为空");
			return;
		}

		var patten1 = /^[a-z.]+$/.test(nickName);
		var patten2 = nickName.lastIndexOf(".") == nickName.indexOf(".");
		if (nickName.indexOf(".") < 2
				|| nickName.indexOf(".") > nickName.length - 3 || !patten1
				|| !patten2) {
			alert("登入账号格式不正确,请重新输入");
			return;
		}

		if (psd == "") {
			alert("登入密码不能为空");
			return;
		}

		if (psd.length < 6) {
			alert("登入密码不能少于6位");
			return;
		}

		if (confirmPsd == "") {
			alert("确认密码不能为空");
			return;
		}

		if (psd != confirmPsd) {
			alert("确认密码与登入密码不一致,请重新确认");
			return;
		}

		if (jobId == "") {
			alert("员工工号不能为空");
			return;
		}

		var patten3 = /^[L]\d{3}$/.test(jobId);

		if (!patten3) {
			alert("员工工号格式不正确,请重新输入");
			return;
		}

		if(email == ""){
			alert("电子邮箱不能为空");
			return;
		}
		
		if (departmentId == 0) {
			alert("请选择所在部门");
			return;
		}

		if (tel == "") {
			alert("手机号码不能为空");
			return;
		}

		var patten4 = /^1[345678]\d{9}$/.test(tel);

		if (!patten4) {
			alert("手机号码格式不正确,请重新输入");
			return;
		}

		$.ajax({
			url : "${pageContext.request.contextPath}/createNewUser",
			type : 'POST',
			cache : false,
			data : {
				"name" : name,
				"nickName" : nickName,
				"psd" : psd,
				"jobId" : jobId,
				"email" : email,
				"departmentId" : departmentId,
				"tel" : tel
			},
			success : function(returndata) {
				var data = eval("(" + returndata + ")").errcode;
				if (data == 0) {
					alert("新建用户成功");
					window.location.reload();
				} else if (data == 3) {
					alert("登入账号和员工工号必须是唯一的,请勿重复录入");
				} else {
					alert("新建失败");
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
				<img src="${pageContext.request.contextPath}/image/coin02.png" /><span><a
					href="#">首页</a>&nbsp;-&nbsp;<a href="#">用户管理</a>&nbsp;-</span>&nbsp;新建用户
			</div>
		</div>

		<div class="page">
			<div class="banneradd bor">
				<div class="baTopNo">
					<span>用户基本信息</span>
				</div>
				<div class="baBody">

					<div class="bbD">
						<label>用户姓名：</label><input type="text" class="input3" id="name"
							style="width: 350px;" /> <label style="margin-left: 15px">登入账号：</label><input
							type="text" class="input3" id="nickName"
							placeholder="格式：zhu.jinglian" style="width: 350px;"
							onChange="changeNickName(this.value)" />
					</div>

					<div class="bbD">
						<label>登入密码：</label><input type="password" class="input3" id="psd"
							style="width: 350px;" placeholder="密码不能少于6位" /> <label
							style="margin-left: 15px">确认密码：</label><input type="password"
							class="input3" id="confirmPsd" style="width: 350px" />
					</div>

					<div class="bbD">
						<label>员工工号：</label><input type="text" class="input3" id="jobId"
							style="width: 350px;" placeholder="格式：L001" /> <label
							style="margin-left: 15px">电子邮箱：</label><!-- <input type="text"
							class="input3" id="email" disabled="disabled"
							style="width: 350px; background-color: #eee" /> --><input type="text"
							class="input3" id="email" 
							style="width: 350px; background-color: #eee" />
					</div>

					<div class="bbD">
						<label>所在部门：</label><select class="selCss" id="departmentId"
							style="width: 360px;">
						</select> <label style="margin-left: 15px">手机号码：</label><input type="text"
							class="input3" id="tel" style="width: 350px;" />
					</div>
					<div class="cfD" style="margin-bottom: 30px; margin-top: 30px">
						<a class="addA" href="#" onclick="createNewUser()"
							style="margin-left: 100px">提交</a> <a class="addA"
							href="${pageContext.request.contextPath}/page/techJobList">关闭</a>
					</div>
				</div>
			</div>
		</div>

	</div>

</body>
</html>