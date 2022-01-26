<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="renderer" content="webkit">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>上海飞默利凯科技有限公司</title>

<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.2.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/bootstrap.js"></script>
<script src="${pageContext.request.contextPath}/js/common.js"></script>

<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/ns_blue_common.css" />
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/ns_table_style.css">


<style>

body::-webkit-scrollbar {
	display:none;
}

html body {
	margin: 0;
	padding: 0;
	font-family: "microsoft yahei";
	background-color: #fff !important;
	-ms-overflow-style: none;
	/*火狐下隐藏滚动条*/
	overflow: -moz-scrollbars-none;
}

.top {
	width: 100%;
	max-width: 1024px;
	margin: 0 20px;
	height: 70px;
}

.top img {
	margin: 30px 0;
	width: 300px;
}

.center {
	padding: 90px 0 120px 0;
	background-size: 100% 100%;
}

.center .login_box {
	width: 330px;
	padding: 10px 0 20px;
	margin-left: 70%;
	text-align: center;
	background: #fff;
	border-radius: 3px;
}

.center .input_box {
	position: relative;
}

.center .user {
	background: url(${pageContext.request.contextPath}/image/user.png)
		no-repeat;
	background-size: 100% 100%;
	width: 20px;
	height: 20px;
	left: 50px;
	top: 10px;
	position: absolute;
	border-radius: 3px 0px 0px 3px;
}

.center .pwd {
	background: url(${pageContext.request.contextPath}/image/pwd.png)
		no-repeat;
	background-size: 100% 100%;
	width: 20px;
	height: 20px;
	left: 50px;
	top: 10px;
	position: absolute;
	border-radius: 3px 0px 0px 3px;
}

.verify {
	position: absolute;
	top: 0px;
	right: 40px;
	z-index: 101;
	width: 100px;
	height: 38px;
	border-left: 1px solid #dedede;
}

.verify img {
	width: 100%;
	vertical-align: middle;
	margin-top: 1px;
}

.input_login {
	width: 220px;
	height: 30px;
	border: 1px #dedede solid;
	line-height: 30px;
	padding-left: 40px;
	padding-top: 5px;
	font-size: 13px;
	color: #666666;
	margin-bottom: 10px;
}

.input_login1 {
	width: 245px;
	height: 30px;
	border: 1px #dedede solid;
	line-height: 30px;
	font-size: 13px;
	color: #666666;
	padding-top: 5px;
	margin-bottom: 10px;
}

.login_box .login_btn {
	text-align: center;
	color: #FFFFFF;
	background-color: #0689E1;
	font-size: 13px;
	font-weight: bold;
	cursor: pointer;
	border: 0px;
	border-radius: 5px;
	width: 250px;
	line-height: 30px;
	letter-spacing: 2px;
	margin-top: 30px;
}

.bottom {
	padding: 10px 0;
	text-align: center;
}

html, body {
	height: 100%;
}
</style>

<script>
	function adminlogin() {
		var txtName = $("#txtName").val().trim();
		var txtPWD = $("#txtPWD").val().trim();
		var txtcode = $("#txtcode").val().trim();
		if (txtName == "") {
			alert("请输入账号");
			return;
		}
		if (txtPWD == "") {
			alert("请输入密码");
			return;
		}
		if (txtcode == "") {
			alert("请输入验证码");
			return;
		}
		$.ajax({
			type : "POST",
			url : "${pageContext.request.contextPath}/login",
			data : {
				"user" : txtName,
				"psd" : txtPWD,
				"code" : txtcode
			},
			success : function(returndata) {
				var data = eval("(" + returndata + ")").errcode;
				if (data == 0) {
					window.location.href = "${pageContext.request.contextPath}/page/index";
				} else if (data == 1) {
					alert("验证码错误,请重新输入");
					$("#txtcode").val("");
					changeValidateCode();
				} else if (data == 2) {
					alert("账号或密码错误,请重新输入");
					$("#txtcode").val("");
					$("#txtName").val("");
					$("#txtPWD").val("");
					changeValidateCode();
				} else {
					alert("登入错误");
				}
			}
		});
	}

	function changeValidateCode() {
		$("#verify_img").hide().attr(
				'src',
				'${pageContext.request.contextPath}/getCheckCode?'
						+ Math.floor(Math.random() * 100)).fadeIn();
	}
</script>
</head>

<body style="overflow-y:hidden">
	<div
		style="height:100%;background-image:url(${pageContext.request.contextPath}/assets/images/main-slider/bannerOne.jpg)">
		<div class="top">
			<img src="${pageContext.request.contextPath}/assets/images/logo_new_2021_09_26.png" style="margin-left: 30px"/>
		</div>
		
		<div class="center" style="height: 53%;">
			<form action="javascript:;" style="margin-top: 5%;">
				
				<div class="login_box">
					<p style="font-size: 20px;">
						<strong>用户登录</strong>
					</p>
					<div class="input_box">
						<div class="user"></div>
						<input type="text" class="input_login" name="txtName" id="txtName"
							placeholder="请输入账号" />
					</div>
					<div class="input_box">
						<div class="pwd"></div>
						<input type="password" class="input_login" name="txtPWD"
							id="txtPWD" placeholder="请输入密码" />
					</div>

					<div class="input_box">
						<input type="text" class="input_login1" name="txtcode"
							id="txtcode" placeholder="验证码"
							style="padding-left: 15px;" />
						<div class="verify">
							<img id="verify_img" style="width: 98px; height: 32px"
								src="${pageContext.request.contextPath}/getCheckCode"
								onclick="changeValidateCode()">
						</div>
					</div>
					<button style="margin-top: 10px;background-color:#5EC7CE" class="login_btn"
						onclick="adminlogin()">登入</button>
				</div>
			</form>
		</div>
		<div class="bottom">
			<!-- <p style="font-size: 13px">备案号</p> -->
		</div>
	</div>
	<!-- 公共的操作提示弹出框 common-success：成功，common-warning：警告，common-error：错误，-->
	<div class="common-tip-message js-common-tip">
		<div class="inner"></div>
	</div>

</body>
</html>