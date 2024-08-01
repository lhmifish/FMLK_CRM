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
<title>发送通知</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/select4.css?v=1999" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/css.css?v=1997" />
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/material_blue.css">
<link rel="stylesheet" type="text/css"
	href="https://npmcdn.com/flatpickr/dist/ie.css">
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/flatpickr_v3.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.2.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/select3.js"></script>
<script src="${pageContext.request.contextPath}/js/changePsd.js"></script>
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
	var informTime;
	var thisDate;
	var informSelect;
	var isPermissionEdit;

	$(document)
			.ready(
					function() {
						sId = "${sessionId}";
						//	sId = "lu.haiming";
						informTime = 1;
						informSelect = 1;
						if (sId == null || sId == "") {
							parent.location.href = "${pageContext.request.contextPath}/page/login";
						} else {
							getUserPermissionList();
							if(isPermissionEdit){
								thisDate = new Date();
								thisDate = new Date(thisDate.getFullYear(),
										thisDate.getMonth(), thisDate.getDate());

								getDepartmentList();
								document.getElementById("informDate").flatpickr(
										{
											defaultDate : formatDate(new Date())
													.substring(0, 10),
											mode : "single",
											dateFormat : "Y/m/d",
											onChange : function(dateObj, dateStr) {
												var selDate = new Date(Date
														.parse(dateStr));
												if (selDate < thisDate) {
													alert("不能选今天之前的日期");
													$("#informDate").val(
															formatDate(new Date())
																	.substring(0,
																			10));
												}
											}
										});
							}
							
							
						}
					});

	function getUserPermissionList() {
		$
				.ajax({
					url : "${pageContext.request.contextPath}/getUserPermissionList",
					type : 'GET',
					data : {
						"nickName" : sId
					},
					cache : false,
					async : false,
					success : function(returndata) {
						var data = eval("(" + returndata + ")").permissionSettingList;
						isPermissionEdit = false;
						for ( var i in data) {
							if (data[i].permissionId == 77) {
								isPermissionEdit = true;
								break;
							}
						}
						if (!isPermissionEdit) {
							window.location.href = "${pageContext.request.contextPath}/page/error";
						} else {
							$('#body').show();
						}
					},
					error : function(XMLHttpRequest, textStatus, errorThrown) {
					}
				});
	}
	
	
	function checkInformTime() {
		var isCheck = document.getElementsByName('field03');
		if (isCheck[1].checked == true) {
			informTime = 2;
		} else {
			informTime = 1;
		}

	}

	function checkInformType() {
		var isCheck = document.getElementsByName('field01');
		if (isCheck[0].checked == true) {
			//文本
			$("#titleDiv").attr("style", "display:block;");
			$("#contentDiv").attr("style", "display:block;");
			$("#imageDiv").attr("style", "display:none;");
			informSelect = 1;
		} else {
			//图片
			$("#titleDiv").attr("style", "display:none;");
			$("#contentDiv").attr("style", "display:none;");
			$("#imageDiv").attr("style", "display:block;");
			informSelect = 2;
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
				var str = '<option value="0">全体员工</option>';
				var data2 = eval("(" + returndata + ")").dList;
				for ( var i in data2) {
					if (data2[i].id <= 4) {
						str += '<option value="'+data2[i].id+'">'
								+ data2[i].departmentName + '</option>';
					}
				}
				$("#departmentId").empty();
				$("#departmentId").append(str);

			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
	}

	function createInformation() {
		var title = $("#title").val().trim();
		var informContent = $("#informContent").val().trim();
		var departmentId = $("#departmentId option:selected").val();
		var informDate = $("#informDate").val();
		var myFile = document.getElementById("myfile").files[0];

		if (title == "" && informSelect == 1) {
			alert("通知标题不能为空");
			return;
		}

		if (informContent == "" && informSelect == 1) {
			alert("通知内容不能为空");
			return;
		}

		if (myFile == undefined && informSelect == 2) {
			alert("通知图片不能为空");
			return;
		}

		if (informSelect == 2) {
			var formData = new FormData();
			formData.append('informType', informTime);
			formData.append('departmentId', 2);
			formData.append('informDate', informDate);
			formData
					.append('thisDate', formatDate(new Date()).substring(0, 10));
			formData.append('imgFile', myFile);
			$
					.ajax({
						url : "${pageContext.request.contextPath}/createImageInformation",
						type : 'POST',
						cache : false,
						data : formData,
						contentType : false,
						processData : false,
						success : function(returndata) {
							/* var data = eval("(" + returndata + ")").errcode;
							var msg = eval("(" + returndata + ")").errmsg;
							if (data == 0) {
								alert("发送通知成功");
								window.location.reload();
							} else {
								alert("错误码：" + data + " 错误信息：" + msg);
							} */
						},
						error : function(XMLHttpRequest, textStatus,
								errorThrown) {
						}
					});
		} else {
			$
					.ajax({
						url : "${pageContext.request.contextPath}/createTextInformation",
						type : 'POST',
						cache : false,
						data : {
							"title" : title,
							"informContent" : informContent,
							"informType" : informTime,
							"departmentId" : departmentId,
							"informDate" : informDate,
							"thisDate" : formatDate(new Date())
									.substring(0, 10)
						},
						success : function(returndata) {
							var data = eval("(" + returndata + ")").errcode;
							var msg = eval("(" + returndata + ")").errmsg;
							if (data == 0) {
								alert("发送通知成功");
								window.location.reload();
							} else {
								alert("错误码：" + data + " 错误信息：" + msg);
							}
						},
						error : function(XMLHttpRequest, textStatus,
								errorThrown) {
						}
					});
		}

	}
</script>

</head>
<body id="body" style="display: none;">
	<div id="pageAll">
		<div class="pageTop">
			<div class="page">
				<img src="${pageContext.request.contextPath}/image/coin02.png" /><span><a
					href="#">首页</a>&nbsp;-&nbsp;<a href="#">考勤管理</a>&nbsp;-</span>&nbsp;发送通知
			</div>
		</div>

		<div class="page">
			<div class="banneradd bor">
				<div class="baTopNo">
					<span>通知内容</span> <input type="radio" name="field01"
						id="informSelect" value="1" checked="checked"
						onclick="checkInformType()" style="margin-left: 30px;" /><label
						style="margin-right: 60px; margin-left: 5px;">文本通知</label> <input
						type="radio" name="field01" id="informSelect" value="2"
						onclick="checkInformType()" /><label style="margin-left: 5px;">图片通知</label>
				</div>
				<div class="baBody" style="margin-left: 40px;">

					<div class="bbD" id="titleDiv">
						<label>通知标题：</label><input type="text" class="input3" id="title"
							style="width: 750px;" />
					</div>

					<div class="bbD" id="contentDiv">
						<label style="float: left">通知内容：</label>
						<textarea class="input3" id="informContent"
							style="width: 750px; resize: none; height: 180px;"></textarea>
					</div>

					<div class="bbD" id="imageDiv" style="display: none">
						<label style="float: left; margin-left: -14px">通知图片上传：</label> <input
							type="file" name="myfile" id="myfile"
							style="width: 410px; margin-left: 10px; border: none;"
							accept="image/jpg,image/png" />
					</div>

					<div class="bbD">
						<label style="float: left; margin-left: -24px;">事件(开始)时间：</label>
						<input class="input3" type="text" id="informDate"
							onfocus="this.blur();" style="width: 200px; display: inline" /><label
							style="margin-left: 30px;">通知类型：</label> <input type="radio"
							name="field03" id="informModel3" value="1" checked="checked"
							onclick="checkInformTime()" style="margin-left: 10px;" /><label
							style="margin-right: 60px; margin-left: 5px;">一次性立即发送</label> <input
							type="radio" name="field03" id="informModel3" value="2"
							onclick="checkInformTime()" /><label
							style="margin-right: 60px; margin-left: 5px;">立即发送且提前一天报警</label>
					</div>

					<div class="bbD">
						<label>通知对象：</label><select class="selCss" id="departmentId"
							style="width: 760px;" /></select>
					</div>

					<div class="cfD" style="margin-bottom: 30px; margin-top: 30px">
						<a class="addA" href="#" onclick="createInformation()"
							style="margin-left: 100px">提交</a> <a class="addA"
							href="${pageContext.request.contextPath}/page/techJobList">关闭</a>
					</div>

				</div>
			</div>
		</div>

	</div>

</body>
</html>