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
<title>录入事务单</title>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/style.css?v=2017">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/select2.css?v=2017" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/showbox.css" />
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/flatpickr.material_blue.min.css">

<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.2.1.min.js"></script>

<script src="${pageContext.request.contextPath}/js/select2.js"></script>
<script src="${pageContext.request.contextPath}/js/jweixin-1.0.0.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/zh-CN.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/flatpickr.js"></script>



<style type="text/css">
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
}

.form div {
	
}

.form p {
	height: 20px;
	line-height: 20px;
	margin-left: 5px;
	font-size: 16px;
}

.form img {
	width: 15px;
	height: 15px;
	position: relative;
	top: 6px;
	margin-right: 5px;
}

.form .mes {
	border-bottom: 2px solid #F5F5F5;
}

.form .mes2 {
	margin-left: 10px;
	border-bottom: 2px solid #F5F5F5;
	height: auto;
	line-height: 13px;
}

.form .mes3 {
	margin-left: 10px;
	border-bottom: 2px solid #F5F5F5;
	height: auto;
	line-height: 13px;
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

.flatpickr-input {
	cursor: pointer;
	z-index: 1;
	width: 95%
}
</style>

<script type="text/javascript">
	$(document).ready(function() {
		
		document.getElementById("date").flatpickr({
			defaultDate : formatDate(new Date())
		});
		document.getElementById("date2").flatpickr({
			defaultDate : formatDate(new Date())
		});
		
		getProjectManager(2);//获取项目经理列表
		getCompanyList();//获取客户公司列表
		getUserList(0);

		$("#company").select2({
			tags : true
		});
		$("#name").select2({
			tags : true
		});

		$("#contact").select2({
			tags : true
		});

		$("#projectName").select2({
			tags : true
		});

		$("#member").select2({
			tags : true,
			insertTag : function(data, tag) {
				data.push(tag);
			}
		});

		$("#projectState").select2({
			minimumResultsForSearch : -1,
			templateResult : formatProjectState
		});
		$("#projectRank").select2({
			minimumResultsForSearch : -1
		});
	});

	function formatProjectState(state) {
		if (!state.id) {
			return state.text;
		}
		var $state;
		if (state.id == 1) {
			$state = $('<span><a style="color:black">●</a> ' + state.text
					+ '</span>');
		} else if (state.id == 2) {
			$state = $('<span><a style="color:orange">●</a> ' + state.text
					+ '</span>');
		} else if (state.id == 3) {
			$state = $('<span><a style="color:red">●</a> ' + state.text
					+ '</span>');
		} else if (state.id == 4) {
			$state = $('<span><a style="color:green">●</a> ' + state.text
					+ '</span>');
		} else if (state.id == 5) {
			$state = $('<span><a style="color:blue">●</a> ' + state.text
					+ '</span>');
		} else if (state.id == 6) {
			$state = $('<span><a style="color:brown">●</a> ' + state.text
					+ '</span>');
		}
		return $state;
	}
	
	function updateUserList(){
	}

	function formatDate(date) {
		var myyear = date.getFullYear();
		var mymonth = date.getMonth() + 1;
		var myweekday = date.getDate();
		var hour = date.getHours();
		var minute = date.getMinutes();
		if (mymonth < 10) {
			mymonth = "0" + mymonth;
		}
		if (myweekday < 10) {
			myweekday = "0" + myweekday;
		}
		return (myyear + "/" + mymonth + "/" + myweekday + " " + hour + ":" + minute);
	}

	function getProjectManager(dpartId) {
		$.ajax({
			url : "${pageContext.request.contextPath}/userList",
			type : 'GET',
			data : {
				"dpartId" : dpartId,
				"date":formatDate(new Date()).substring(0,10),
				"name" : "",
				"nickName" : "",
				"jobId" : "",
				"isHide":true
			},
			cache : false,
			async : false,
			success : function(returndata) {
				var str = '';
				var data2 = eval("(" + returndata + ")").userlist;
				for ( var i in data2) {
					str += '<option value="'+data2[i].name+'">' + data2[i].name
							+ '</option>';
				}
				$("#name").empty();
				$("#name").append(str);
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
	}

	function getCompanyList() {
		$.ajax({
			url : "${pageContext.request.contextPath}/getClientCompany",
			type : 'GET',
			data : {},
			cache : false,
			success : function(returndata) {
				var str = '';
				var data2 = eval("(" + returndata + ")").companylist;
				for ( var i in data2) {
					str += '<option value="'+data2[i].companyId+'">'
							+ data2[i].companyName + '</option>';
				}
				$("#company").empty();
				$("#company").append(str);
				getContactList();
				getProjectNameList();

			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
	}

	function getUserList(dpartId) {

		$.ajax({
			url : "${pageContext.request.contextPath}/userList",
			type : 'GET',
			data : {
				"dpartId" : dpartId,
				"date":formatDate(new Date()).substring(0,10),
				"name" : "",
				"nickName" : "",
				"jobId" : "",
				"isHide":true
			},
			cache : false,
			success : function(returndata) {
				var str = '';
				var data2 = eval("(" + returndata + ")").userlist;
				for ( var i in data2) {
					str += '<option value="'+data2[i].name+'">' + data2[i].name
							+ '</option>';
				}
				$("#member").empty();
				$("#member").append(str);

			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
	}

	function getContactList() {
		$.ajax({
			url : "${pageContext.request.contextPath}/getContactList",
			type : 'GET',
			data : {
				"companyId" : $("#company").val()
			},
			cache : false,
			success : function(returndata) {
				var str = '';
				var data2 = eval("(" + returndata + ")").contactlist;
				for ( var i in data2) {
					str += '<option value="'+data2[i].name+'">' + data2[i].name
							+ '</option>';
				}
				$("#contact").empty();
				$("#contact").append(str);
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
	}

	function getProjectNameList() {
		$.ajax({
			url : "${pageContext.request.contextPath}/getProjectList",
			type : 'GET',
			data : {
				"companyId" : $("#company").val()
			},
			cache : false,
			success : function(returndata) {
				var str = '';
				var data2 = eval("(" + returndata + ")").projectlist;
				for ( var i in data2) {
					str += '<option value="'+data2[i].projectId+'">'
							+ data2[i].projectName + '</option>';
				}
				$("#projectName").empty();
				$("#projectName").append(str);

			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
	}

	function selectCompany() {
		getProjectNameList();
		getContactList();
	}
	
	function createOrder() {
		var name = $("#name option:selected").text();
		var company = $("#company option:selected").text();
		var contact = $("#contact option:selected").text();
		var startDate = $("#date").val();
		var endDate = $("#date2").val();
		var projectName = $("#projectName option:selected").text();
		var memberArr = new Array();
		$("#member option:selected").each(function() {
			memberArr.push($(this).text());
		});
		var serviceContent = $("#serviceContent").val();

		var projectState = $("#projectState option:selected").val();
		var projectRank = $("#projectRank option:selected").val();

		if (new Date(startDate) > new Date(endDate)) {
			alert("开始日期不能在结束日期之后");
			return;
		}

		if (projectName == "") {
			alert("项目名称不能为空");
			return;
		}

		if (memberArr.length == 0) {
			alert("参与人员不能为空");
			return;
		}

		var nowDateStr = formatDate(new Date());//格式YYYY/MM/DD

		if (new Date(startDate) > new Date(nowDateStr) && projectState != 1) {
			alert("项目状态与项目实施时间不符,请修改");
			return;
		} else if (new Date(endDate) < new Date(nowDateStr)
				&& (projectState == 1 || projectState == 2)) {
			alert("项目状态与项目实施时间不符,请修改");
			return;
		} else if (new Date(endDate) >= new Date(nowDateStr)
				&& new Date(startDate) <= new Date(nowDateStr)
				&& (projectState != 2 && projectState != 4)) {
			alert("项目状态与项目实施时间不符,请修改");
			return;
		}

		if (serviceContent == "") {
			alert("服务内容不能为空");
			return;
		}
		$
				.ajax({
					url : "${pageContext.request.contextPath}/createNewAssignment",
					type : 'POST',
					dataType : "json",
					data : {
						"name" : name,
						"company" : company,
						"startDate" : startDate,
						"endDate" : endDate,
						"projectName" : projectName,
						"member" : memberArr,
						"serviceContent" : serviceContent,
						"contact" : contact,
						"projectState" : projectState,
						"projectRank" : projectRank
					},
					traditional : true,
					cache : false,
					success : function(returndata) {
						var data = returndata.errcode;
						if (data == 0) {
							alert("录入成功");
							window.location.href = "${pageContext.request.contextPath}/page/assignmentList";
						} else {
							alert("录入失败");
							window.location.reload();
						}

					},
					error : function(XMLHttpRequest, textStatus, errorThrown) {
					}
				});

	}
</script>
</head>
<body class="body-gray" style="margin: auto;">
	<div id="contact-form">
		<div class="form">
			<div class="top" style="width: 100%">
				<p style="font-size: 20px; margin-bottom: 10px; text-align: center;">
					<Strong>录入事务单</Strong>
				</p>
				<p>
					<a style="color: red">* </a>项目经理：
				</p>
				<div class="mes">
					<select id="name" class="js-example-basic-single" name="state"
						style="width: 100%">
					</select>
				</div>

				<p>
					<a style="color: red">* </a>客户公司：
				</p>
				<div class="mes">
					<select id="company" class="js-example-basic-single" name="state"
						style="width: 100%" onchange="selectCompany()">
					</select>
				</div>

				<p>
					<a style="color: red">* </a>客户联系人：
				</p>
				<div class="mes">
					<select id="contact" class="js-example-basic-single" name="state"
						style="width: 100%">
					</select>
				</div>

				<p>
					<a style="color: red">* </a>开始日期：
				</p>
				<div class="mes">
					<input id="date" onfocus="this.blur();" style="width: 95%"/>
				</div>

				<p>
					<a style="color: red">* </a>结束日期：
				</p>
				<div class="mes">
					<input id="date2" onfocus="this.blur();" style="width: 95%" />
				</div>

				<p>
					<a style="color: red">* </a>项目名称：
				</p>
				<div class="mes">
					<select id="projectName" class="js-example-basic-single"
						style="width: 100%">
					</select>
				</div>

				<p>
					<a style="color: red">* </a>参与人员：
				</p>
				<div class="mes">
					<select id="member" class="js-example-basic-multiple"
						name="states[]" multiple="multiple" style="width: 100%">
					</select>
				</div>

				<p>
					<a style="color: red">* </a>项目当前状态：
				</p>
				<div class="mes">
					<select id="projectState" class="js-example-basic-single"
						style="width: 100%">
						<option value="1">未开始</option>
						<option value="2">处理中</option>
						<option value="3">超时未完成</option>
						<option value="4">已完成(正常)</option>
						<option value="5">已完成(超时)</option>
						<option value="6">待销售确认</option>
					</select>
				</div>

				<p>
					<a style="color: red">* </a>项目等级：
				</p>
				<div class="mes">
					<select id="projectRank" class="js-example-basic-single"
						style="width: 100%">
						<option value="0">正常</option>
						<option value="1">重要</option>
					</select>
				</div>

				<p>
					<a style="color: red">* </a>项目服务内容：
				</p>
				<div class="mes">
					<textarea id="serviceContent" style="border: 1; width: 95%"
						rows="25"></textarea>
				</div>

				<div class="mes">
					<button type="button" onclick="createOrder()" style="height:30px;border: 1; width: 100%;background-color: #333; color: #FFF; border: none; display: block; float: right; background-color: #8FB5C1;-moz-border-radius: 8px;">保存</button>
				</div>
				<p></p>
			</div>
		</div>

	</div>
</body>
</html>