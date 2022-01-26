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
	var id;//客户id
	var sId;//sessionId
	var host;
	var arrayContact;
	var contactNum;
	var isPermissionEdit;
	var companySource;
	var salesId;
	var mCompanyId;

	$(document).ready(function() {
		id = "${mId}";
		sId = "${sessionId}";
		host = "${pageContext.request.contextPath}";
		checkEditPremission(3, 0);
	});

	function initialPage() {
		getCompanyInfo(id);
		matchEdit("客户");
		$("#fieldId").select2({});
		$("#salesId").select2({});
		$("#areaId").select2({});
		$("#companyId").select2({});
	}

	function getCompanyInfo(tid) {
		$.ajax({
			url : host + "/getCompanyById",
			type : 'GET',
			cache : false,
			async : false,
			data : {
				"id" : tid
			},
			success : function(returndata) {
				var data = eval("(" + returndata + ")").company;
				$("#companyName").val(data[0].companyName);
				$("#abbrCompanyName").val(data[0].abbrCompanyName);
				getSalesList(data[0].salesId);
				salesId = data[0].salesId;
				getFieldList(data[0].fieldId);
				getAreaList(data[0].areaId);
				mCompanyId = data[0].companyId;
			//	alert(mCompanyId);
				var mCompanySource = data[0].companySource;
				companySource = mCompanySource.split("#")[0];
				$("input[name='field02'][value=" + companySource + "]").attr(
						"checked", true);
				if (companySource == 4) {
					$("#companyId").removeAttr("disabled");
					$("#companyId").css('background-color', '#fff');
					getCompanyList("", 0, mCompanySource.split("#")[1], 0);
				} else if (companySource == 5) {
					$("#other").removeAttr("disabled");
					$("#other").css('background-color', '#fff');
					$("#other").val(mCompanySource.split("#")[1]);
					getCompanyList("", 0, 0, 0);
				} else {
					getCompanyList("", 0, 0, 0);
				}
				$('#address').val(data[0].address);
				getUserContact(data[0].companyId);
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
	}

	function getUserContact(companyId) {
		arrayContact = new Array();
		$
				.ajax({
					url : host + "/userContactList",
					type : 'GET',
					data : {
						"companyId" : companyId
					},
					cache : false,
					async : false,
					success : function(returndata) {
						var data2 = eval("(" + returndata + ")").contactUserList;
						var str = "";
						for ( var i in data2) {
							var j = parseInt(i) + 1;
							str += '<div class="bbD" id="mDiv'+ j +'">'
									+ '<label style="margin-left: 28px;">联系人：</label>'
									+ '<input disabled="disabled" type="text" class="input3" id="contactUser'+ j +'" style="width:170px;background-color:#eee" value="'+ data2[i].userName +'"/>'
									+ '<label style="margin-left: 15px;">邮箱：</label>'
									+ '<input type="text" class="input3" id="email'+ j +'" style="width:420px;" value="'+ data2[i].email +'"/>';
							if (i == 0) {
								str += '<img style="height: 30px;margin-left: 15px;" src="${pageContext.request.contextPath}/image/plus2018.png" onClick="addNewContact()">'
										+ '<img style="height: 30px;" src="${pageContext.request.contextPath}/image/minus2018.png" onClick="removeContact()">';
							}
							str += '</br></br><label style="margin-left: 40px;">电话：</label>'
									+ '<input type="text" class="input3" id="tel'+ j +'" style="width:170px;" value="'+ data2[i].tel +'"/>'
									+ '<label style="margin-left: 15px;">部门：</label>'
									+ '<input type="text" class="input3" id="depart'+ j +'" style="width:170px" value="'+ data2[i].department +'"/>'
									+ '<label style="margin-left: 15px;">职务：</label>'
									+ '<input type="text" class="input3" id="position'+ j +'" style="width:170px" value="'+ data2[i].position +'"/></div>';
						}
						$("#allContact").append(str);
						contactNum = data2.length;
					},
					error : function(XMLHttpRequest, textStatus, errorThrown) {
					}
				});
	}

	function checkCompanySource(j) {
		companySource = j;
		var isCheck = document.getElementsByName('field02');
		if (isCheck[3].checked == true) {
			//客户介绍
			$("#companyId").removeAttr("disabled");
			$("#companyId").css('background-color', '#fff');
			$("#other").attr("disabled", "disabled");
			$("#other").css('background-color', '#eee');
			$("#other").val("");
		} else if (isCheck[4].checked == true) {
			//其他
			getCompanyList("", 0, 0, 0);
			$("#other").removeAttr("disabled");
			$("#other").css('background-color', '#fff');
			$("#companyId").attr("disabled", "disabled");
			$("#companyId").css('background-color', '#eee');
		} else {
			getCompanyList("", 0, 0, 0);
			$("#companyId").attr("disabled", "disabled");
			$("#other").attr("disabled", "disabled");
			$("#companyId").css('background-color', '#eee');
			$("#other").css('background-color', '#eee');
			$("#other").val("");
		}
	}

	function addNewContact() {
		if (contactNum > 4) {
			alert("最多只能输入5个联系人");
			return;
		}
		contactNum++;
		var str = '<div class="bbD" id="mDiv'+ contactNum +'">'
				+ '<label style="margin-left: 28px;">联系人：</label><input type="text" class="input3" id="contactUser'+ contactNum +'" style="width:170px;"/>'
				+ '<label style="margin-left: 15px;">邮箱：</label><input type="text" class="input3" id="email'+ contactNum +'" style="width:420px;"/><br/><br/>'
				+ '<label style="margin-left: 45px;">电话：</label><input type="text" class="input3" id="tel'+ contactNum +'" style="width:170px;"/>'
				+ '<label style="margin-left: 15px;">部门：</label><input type="text" class="input3" id="depart'+ contactNum +'" style="width:170px"/>'
				+ '<label style="margin-left: 15px;">职务：</label><input type="text" class="input3" id="position'+ contactNum +'" style="width:170px"/></div>'
		$("#allContact").append(str);
	}

	function removeContact() {
		if (contactNum == 1) {
			alert("至少要输入1个联系人");
			return;
		}
		$("#mDiv" + contactNum).remove();
		contactNum--;
	}

	function editCompany() {
		if (!isPermissionEdit) {
			alert("你没有权限编辑客户");
			return;
		}
		var companyName = $("#companyName").val().trim();
		var abbrCompanyName = $("#abbrCompanyName").val().trim();
		var fieldId = $("#fieldId option:selected").val();
		var mSalesId = $("#salesId option:selected").val();
		var areaId = $("#areaId option:selected").val();
		var address = $("#address").val().trim();
		var tCompanyId = $("#companyId").val();
		var other = $("#other").val().trim();
		
		var mCompanySource;
		if (companySource == 4) {
			mCompanySource = companySource + "#" + tCompanyId;
		} else if (companySource == 5) {
			mCompanySource = companySource + "#" + other;
		} else {
			mCompanySource = companySource + "#";
		}

		if (companyName == "") {
			alert("公司名称不能为空");
			return;
		}

		if (mSalesId == 0) {
			alert("请选择销售经理");
			return;
		}

		if (fieldId == 0 || fieldId == undefined) {
			alert("请选择客户行业");
			return;
		}

		if (address == "") {
			alert("客户地址不能为空");
			return;
		}

		if (areaId == 0 || areaId == undefined) {
			alert("请选择所属地区");
			return;
		}

		if (companySource == 4 && mCompanyId == 0) {
			alert("客户来源-客户介绍不能为空");
			return;
		}

		if (companySource == 5 && other == "") {
			alert("客户来源-其他不能为空");
			return;
		}

		arrayContact = new Array();

		for (var i = 1; i <= contactNum; i++) {
			var contactUser = $("#contactUser" + i).val().trim();
			var tel = $("#tel" + i).val().trim();
			var email = $("#email" + i).val().trim();
			var depart = $("#depart" + i).val().trim();
			var position = $("#position" + i).val().trim();
			if (contactUser == "") {
				alert("第" + i + "个联系人不能为空");
				arrayContact.splice(0, arrayContact.length);
				return;
			}
			if (tel == "") {
				alert("第" + i + "个电话不能为空");
				arrayContact.splice(0, arrayContact.length);
				return;
			}
			if (email == "") {
				alert("第" + i + "个邮箱不能为空");
				arrayContact.splice(0, arrayContact.length);
				return;
			}
			if (depart == "") {
				alert("第" + i + "个部门不能为空");
				arrayContact.splice(0, arrayContact.length);
				return;
			}
			if (position == "") {
				alert("第" + i + "个职位不能为空");
				arrayContact.splice(0, arrayContact.length);
				return;
			}
			var contactInfo = contactUser + "#" + tel + "#" + email + "#"
					+ depart + "#" + position;
			arrayContact.push(contactInfo);
		}

		$.ajax({
			url : host + "/editCompany",
			type : 'POST',
			cache : false,
			dataType : "json",
			data : {
				"companyName" : companyName,
				"abbrCompanyName" : abbrCompanyName,
				"fieldId" : fieldId,
				"salesId" : mSalesId,
				"address" : address,
				"areaId" : areaId,
				"companySource" : mCompanySource,
				"arrayContact" : arrayContact,
				"id" : id,
				"companyId":mCompanyId
			},
			traditional : true,
			success : function(returndata) {
				var data = returndata.errcode;
				if (data == 0) {
					alert("编辑成功");
					setTimeout(function() {
						toCompanyListPage();
					}, 500);
				} else if (data == 3) {
					alert("有相同或类似的客户名存在，请检查");
				} else {
					alert("编辑失败");
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
					href="#">首页</a>&nbsp;-&nbsp;<a href="#">客户关系管理</a>&nbsp;-</span><span
					style="margin-left: 5px" id="span_title2"></span>
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
						<label>客户全称：</label><input type="text" class="input3"
							id="companyName" style="width: 390px;" /><label
							style="margin-left: 15px">简称：</label> <input type="text"
							class="input3" id="abbrCompanyName" style="width: 210px" />
					</div>

					<div class="bbD">
						<label>销售人员：</label><select class="selCss" id="salesId"
							style="width: 400px;" /></select><label style="margin-left: 15px">客户行业：</label><select
							class="selCss" id="fieldId" style="width: 190px;" /></select>
					</div>

					<div class="bbD">
						<label>客户地址：</label><input type="text" class="input3" id="address"
							style="width: 385px;" /> <label style="margin-left: 15px">所属地区：</label><select
							class="selCss" id="areaId" style="width: 190px;" /></select>
					</div>

					<div class="bbD">
						<label>客户来源：</label> <input type="radio" name="field02"
							id="companySource" value="1" checked="checked"
							onclick="checkCompanySource(1)" /><label
							style="margin-right: 100px; margin-left: 5px;">厂商</label> <input
							type="radio" name="field02" id="companySource" value="2"
							onclick="checkCompanySource(2)" /><label
							style="margin-right: 100px; margin-left: 5px;">招投标</label> <input
							type="radio" name="field02" id="companySource" value="3"
							onclick="checkCompanySource(3)" /><label
							style="margin-right: 100px; margin-left: 5px;">Call_in</label> <br />
						<input type="radio" name="field02" id="companySource" value="4"
							onclick="checkCompanySource(4)"
							style="margin-left: 103px; margin-top: 30px;" /><label
							style="margin-left: 5px;">客户介绍</label> <select class="selCss"
							id="companyId" style="width: 270px; background-color: #eee"
							disabled="disabled" /></select> <input type="radio" name="field02"
							id="companySource" value="5" onclick="checkCompanySource(5)"
							style="margin-left: 20px;" /><label style="margin-left: 5px;">其他</label>
						<input type="text" class="input3" id="other" disabled="disabled"
							style="width: 225px; background-color: #eee;" />
					</div>
					<div id="allContact" style="margin-bottom: 30px;"></div>
					<div class="cfD" style="margin-bottom: 30px; display: none"
						id="operation">
						<a class="addA" href="#" onclick="editCompany()"
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