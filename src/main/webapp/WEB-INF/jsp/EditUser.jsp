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
<title>编辑用户</title>
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
</style>

<script type="text/javascript">
	var id;
	$(document).ready(function() {
		id = "${mId}";
		$("#departmentId").select2({});
		getDepartmentList();
		getUserInfo(id);
	});

	function changeNickName(tNickName) {
		if (tNickName != "") {
			$("#email").val(tNickName + "@lanstarnet.com");
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
					str += '<option value="'+data2[i].id+'">' + data2[i].departmentName
							+ '</option>';
				}
				$("#departmentId").empty();
				$("#departmentId").append(str);

			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
	}

	function getUserInfo(tid) {
		$.ajax({
			url : "${pageContext.request.contextPath}/getUserById",
			type : 'GET',
			cache : false,
			async : false,
			data : {
				"uId" : tid
			},
			success : function(returndata) {
				var data = eval("(" + returndata + ")").user;
				$("#name").val(data[0].name);
				$("#nickName").val(data[0].nickName);
				$("#email").val(data[0].email);
				$("#jobId").val(data[0].jobId);
				$("#tel").val(data[0].tel);
				$("#departmentId").val(data[0].departmentId);
				if (data[0].UId == 999 && data[0].departmentId == 6) {
					$("#div1").hide();
					$('#name').attr("disabled", "disabled");
					$('#name').css("background-color", "#EEE");
				}

			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
	}

	function editUser() {
		var name = $("#name").val().trim();
		var nickName = $("#nickName").val().trim();
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

		if (departmentId == 0) {
			alert("请选择所在部门");
			return;
		}

		if (departmentId == undefined) {
			departmentId = 6;
		}

		if (tel == "") {
			alert("手机号码不能为空");
			return;
		}

		var patten4 = /^1[34578]\d{9}$/.test(tel);

		if (!patten4) {
			alert("手机号码格式不正确,请重新输入");
			return;
		}

		$.ajax({
					url : "${pageContext.request.contextPath}/editUser",
					type : 'POST',
					cache : false,
					data : {
						"name" : name,
						"nickName" : nickName,
						"psd" : "",
						"email" : email,
						"departmentId" : departmentId,
						"tel" : tel,
						"id" : id,
						"state" : "",
						"roleId":-1
					},
					success : function(returndata) {
						var data = eval("(" + returndata + ")").errcode;
						if (data == 0) {
							alert("编辑用户成功");
							setTimeout(
									function() {
										window.location.href = "${pageContext.request.contextPath}/page/userList";
									}, 500);
						} else {
							alert("编辑用户失败");
						}
					},
					error : function(XMLHttpRequest, textStatus, errorThrown) {
					}
				});
	}

	function back() {
		window.history.back();
	}

</script>

</head>
<body>
	<div id="pageAll">
		<div class="pageTop">
			<div class="page">
				<img src="${pageContext.request.contextPath}/image/coin02.png" /><span><a
					href="#">首页</a>&nbsp;-&nbsp;<a href="#">用户管理</a>&nbsp;-</span>&nbsp;编辑用户
			</div>
		</div>

		<div class="page">
			<div class="banneradd bor">
				<div class="baTopNo">
					<span>编辑用户</span>
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
						<label>员工工号：</label><input type="text" class="input3" id="jobId"
							style="width: 350px; background-color: #eee"
							placeholder="格式：L001" disabled="disabled" /> <label
							style="margin-left: 15px">电子邮箱：</label><input type="text"
							class="input3" id="email" disabled="disabled"
							style="width: 350px; background-color: #eee" />
					</div>

					<div class="bbD" id="div1">
						<label>所在部门：</label><select class="selCss" id="departmentId"
							style="width: 360px;">
						</select> <label style="margin-left: 15px">手机号码：</label><input type="text"
							class="input3" id="tel" style="width: 350px;" />
					</div>

					<div class="cfD" style="margin-bottom: 30px; margin-top: 30px">
						<a class="addA" href="#" onclick="editUser()"
							style="margin-left: 100px">编辑</a> <a class="addA"
							href="#" onclick="back()">返回</a>
					</div>
				</div>
			</div>
		</div>

	</div>

</body>
</html>