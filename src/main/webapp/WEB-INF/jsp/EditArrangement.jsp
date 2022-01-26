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
<title>日程</title>


<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/showbox.css" />
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.2.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/jweixin-1.0.0.js"></script>
<style>
.mask-layer-loading {
	position: fixed;
	width: 100%;
	height: 100%;
	z-index: 999999;
	top: 0;
	left: 0;
	text-align: center;
	display: none;
}

.mask-layer-loading i, .mask-layer-loading img {
	text-align: center;
	color: #000000;
	font-size: 50px;
	position: relative;
	top: 50%;
}

input:-webkit-autofill, textarea:-webkit-autofill, select:-webkit-autofill
	{
	background-color: rgba(217, 217, 217, 0.29);
}

input {
	border: 0;
	background: #fff;
}

body {
	max-width: 640px;
	color: #444;
}
/*独立*/
.form {
	margin-top: 10px;
	width: 100%;
	background-color: #F5F5F5
}

.form div {
	background-color: #FFF;
}

.form p {
	height: 20px;
	line-height: 20px;
	margin-left: 5px;
	font-size: 15px;
}

.form img {
	width: 15px;
	height: 15px;
	position: relative;
	top: 6px;
	margin-right: 5px;
}

.form .mes {
	margin-left: 25px;
	border-bottom: 2px solid #F5F5F5;
}

.form .button-submit {
	height: 80px;
	line-height: 80px;
	text-align: center;
	background-color: #F5F5F5;
}

.button-submit button {
	position: fixed;
	bottom: 0;
	z-index: 9999;
	width: 100%;
	max-width: 640px;
	height: 40px;
	background-color: #459BFE;
	color: #FFF;
	border: 0;
}

select { /*很关键：将默认的select选择框样式清除*/
	appearance: none;
	-moz-appearance: none;
	-webkit-appearance: none;
	/*在选择框的最右侧中间显示小箭头图片*/
	background: url("${pageContext.request.contextPath}/image/arrow.png")
		no-repeat scroll right center transparent;
	/*为下拉小箭头留出一点位置，避免被文字覆盖*/
	padding-right: 14px;
	border: 0;
	width: 95%;
}
/*清除ie的默认选择框样式清除，隐藏下拉箭头*/
select::-ms-expand {
	display: none;
}

#pickdate {
	border: 0;
	width: 95%;
	background: url("./images/images/gd/arrow.png") no-repeat scroll right
		center transparent;
}

.evaluate_right {
	float: left;
	width: 100%;
	height: 100%;
}

.evaluate_right .rate_content {
	border: 0;
	background: #fff;
}

.evaluate_right_three {
	height: 50px;
	width: 60px;
	line-height: 55px;
	background: #fff;
}

.evaluate_right_imgs {
	margin-top: 17px;
}

.evaluate_right_four {
	margin-top: 23px;
}

.evaluate_right_two {
	bottom: -17px;
}

.evaluate_right .input-file {
	width: 50px;
	height: 50px;
}

.test .right_imgs li {
	float: left;
	display: block;
	height: 50px;
	width: 50px;
	background: no-repeat center center;
	background-size: cover;
	margin-right: 5px;
	position: relative;
}

.right_imgs li>span {
	position: absolute;
	cursor: pointer;
	text-align: center;
	top: -5px;
	right: -5px;
	width: 13px;
	height: 13px;
	line-height: 13px;
	z-index: 3;
	font-size: 12px;
	background-color: #000;
	opacity: .8;
	filter: alpha(opacity = 80);
	color: #FFF;
	text-decoration: none;
	border-radius: 50%;
	display: block;
}
/*独立*/
</style>
<script type="text/javascript">
	var id;
	var uName;

	$(document).ready(
			function() {
				var uID = "${mUserId}";//用户id
				id = "${mId}";//日程id 

				getUserName(uID);

				var str2;
				for (var a = 0; a <= 23; a++) {
					if (a < 10) {
						str2 += '<option>0' + a + ':00</option>' + '<option>0'
								+ a + ':30</option>';
					} else {
						str2 += '<option>' + a + ':00</option>' + '<option>'
								+ a + ':30</option>';
					}
				}
				$("#time1").append(str2);
				$("#time2").append(str2);
				getData(id);
			});

	function getUserName(uid) {
		$.ajax({
			url : "${pageContext.request.contextPath}/getUserName",
			type : 'GET',
			data : {
				"uID" : uid
			},
			async : false,
			cache : false,
			success : function(returndata) {
				var data = eval("(" + returndata + ")").user;
				//	$(document).attr("title",data[0].name+"的日程");
				uName = data[0].name;
			}
		});
	}

	function editArrangement() {
		var userName = $("#user").val();
		var date = $('#date').val();
		var time1 = $("#time1 option:selected").text();
		var time2 = $("#time2 option:selected").text();

		var accident = $("#accident").val();
		var client = $("#client").val();
		var address = $("#address").val();

		if (uName != userName) {
			alert("这不是你的日程，你不能编辑");
			return;
		}

		if (accident == "") {
			alert("事件不能为空");
			return;
		}

		$
				.ajax({
					url : "${pageContext.request.contextPath}/editArrangement",
					type : 'POST',
					cache : false,
					data : {
						"id" : id,
						"userName" : userName,
						"time" : date + " " + time1 + "-" + time2,
						"accident" : accident,
						"client" : client,
						"address" : address
					},
					success : function(returndata) {
						var data = eval("(" + returndata + ")").errcode;
						if (data == 0) {
							alert("编辑成功");
							window.location.href = "http://crm.lanstarnet.com:8082/dailyUploadProject/page/arrangementList";
						} else if (data == 3) {
							alert("请勿重复上传相同时间段的日程");
						} else {
							alert("编辑失败");
						}

					},
					error : function(XMLHttpRequest, textStatus, errorThrown) {
					}
				});
	}

	function getData(id) {
		$.ajax({
			url : "${pageContext.request.contextPath}/getArrangement",
			type : 'GET',
			cache : false,
			data : {
				"id" : id
			},
			success : function(returndata) {
				var data = eval("(" + returndata + ")").dailyarrangement;
				$(document).attr("title", data[0].userName + "的日程");
				$("#user").val(data[0].userName);

				$("#accident").val(data[0].accident);
				$("#address").val(data[0].address);
				$("#client").val(data[0].client);

				//$("#time").val(data[0].time);
				$("#date").val(data[0].time.substring(0, 10));
				$("#time1").val(data[0].time.substring(11, 16));
				$("#time2").val(data[0].time.substring(17, 22));
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
	}
</script>
</head>


<body class="body-gray" style="margin: auto;">
	<div class="form">
		<div class="top" style="width: 100%">
			<p style="display: none">工作类型</p>
			<p class="mes" style="display: none">
				<input type="text" id="user" />
			</p>

			<p>
				<a style="color: red">* </a>时间
			</p>
			<p class="mes">
				<input type="text" id="date" disabled="disabled" /> <select
					id="time1" style="width: 50px; margin-left: 5px"></select> 至 <select
					id="time2" style="width: 50px; margin-left: 5px"></select>
			</p>

			<p>
				<a style="color: red">* </a>事件
			</p>
			<p class="mes">
				<input type="text" id="accident" placeholder="事件" />
			</p>

			<p>地点</p>
			<p class="mes">
				<input type="text" id="address" placeholder="地点" />
			</p>

			<p>客户</p>
			<p class="mes">
				<input type="text" id="client" placeholder="客户" />
			</p>


		</div>
	</div>

	<div class="button-submit">
		<button type="button" onclick="editArrangement();"
			class="btn btn-primary">编辑</button>
	</div>
</body>
</html>