<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="renderer" content="webkit" />
<meta http-equiv="pragma" content="no-cache" />
<meta http-equiv="cache-control" content="no-cache" />
<title>新建客户</title>
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
	var companySource;
	var arrayContact;
	var contactNum;
	var sId;
	var host;
	var isPermissionView;
	var companyType;

	$(document).ready(function() {
		sId = "${sessionId}";
		host = "${pageContext.request.contextPath}";
		checkViewPremission(2);
	});

	function initialPage() {
		getFieldList(0);
		getSalesList(0);
		getAreaList(0);
		getCompanyList("", 0, 0, 0);
		$("#fieldId").select2({});
		$("#salesId").select2({});
		$("#areaId").select2({});
		$("#companyId").select2({});
		companySource = 1;
		contactNum = 1;
		companyType = 1;
		
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
			$("#other").attr("disabled", "disabled");
			$("#companyId").css('background-color', '#eee');
			$("#companyId").attr("disabled", "disabled");
			$("#other").css('background-color', '#eee');
			$("#other").val("");
		}
	}

	function checkCompanyType(j) {
		companyType = j;
		var isCheck = document.getElementsByName('field03');
		if (isCheck[0].checked == true) {
			//信息
			$("#divCompanySource").css('display', 'block');
			$("#addBtn").css('visibility', 'visible');
			$("#rmvBtn").css('visibility', 'hidden');
			$("#divfieldId").css('visibility', 'visible');
			$("#divAbbrName").css('visibility', 'visible');
			
		} else {
			//陪护床
			$("#divCompanySource").css('display', 'none');
			$("#addBtn").css('visibility', 'hidden');
			$("#rmvBtn").css('visibility', 'hidden');
			$("#divfieldId").css('visibility', 'hidden');
			$("#divAbbrName").css('visibility', 'hidden');
			
			if (contactNum > 1) {
				for (var i = contactNum; i > 1; i--) {
					$("#mDiv" + i).remove();
				}
				contactNum = 1;
			}

		}
	}

	function addNewContact() {
		/* if (contactNum > 4) {
			alert("最多只能输入5个联系人");
			return;
		} */
		$("#rmvBtn").css('visibility', 'visible');
		contactNum++;
		var str = '<div class="bbD" id="mDiv'+ contactNum +'">'
				+ '<label style="margin-left: 28px;">联系人：</label><input type="text" class="input3" id="contactUser'+ contactNum +'" style="width:170px;"/>'
				+ '<label style="margin-left: 15px;">邮箱：</label><input type="text" class="input3" id="email'+ contactNum +'" style="width:420px;"/><br/><br/>'
				+ '<label style="margin-left: 40px;">电话：</label><input type="text" class="input3" id="tel'+ contactNum +'" style="width:170px;"/>'
				+ '<label style="margin-left: 15px;">部门：</label><input type="text" class="input3" id="depart'+ contactNum +'" style="width:170px"/>'
				+ '<label style="margin-left: 15px;">职务：</label><input type="text" class="input3" id="position'+ contactNum +'" style="width:170px"/></div>'
		$("#allContact").append(str);
		if (contactNum == 5) {
			$("#addBtn").css('visibility', 'hidden');
		}
	}

	function removeContact() {
		/* if (contactNum == 1) {
			alert("至少要输入1个联系人");
			return;
		} */
		$("#addBtn").css('visibility', 'visible');
		$("#mDiv" + contactNum).remove();
		contactNum--;
		if (contactNum == 1) {
			$("#rmvBtn").css('visibility', 'hidden');
		}
	}

	function createCompany() {
		if (!isPermissionView) {
			alert("你没有权限新建客户");
			return;
		}
		var companyName = $("#companyName").val().trim();
		var abbrCompanyName = $("#abbrCompanyName").val().trim();
		var fieldId = $("#fieldId").val();
		var salesId = $("#salesId").val();
		var areaId = $("#areaId").val();
		var address = $("#address").val().trim();

		var companyId = $("#companyId").val();
		var other = $("#other").val().trim();

		var mCompanySource = companySource + "#";

		if (companySource == 4) {
			mCompanySource = mCompanySource + companyId;
		} else if (companySource == 5) {
			mCompanySource = mCompanySource + other;
		}

		if (companyName == "") {
			alert("公司名称不能为空");
			return;
		}

		if (salesId == 0) {
			alert("请选择销售经理");
			return;
		}

		if (fieldId == 0) {
			alert("请选择客户行业");
			return;
		}

		if (address == "") {
			alert("客户地址不能为空");
			return;
		}

		if (areaId == 0) {
			alert("请选择所属地区");
			return;
		}

		if (companySource == 4 && companyId == 0) {
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
			if (tel == "" && email == "") {
				alert("第" + i + "个电话和邮箱不能同时为空");
				arrayContact.splice(0, arrayContact.length);
				return;
			}
			/* if (email == "") {
				alert("第" + i + "个邮箱不能为空");
				arrayContact.splice(0, arrayContact.length);
				return;
			} */
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
			url : host + "/createNewCompany",
			type : 'POST',
			cache : false,
			dataType : "json",
			data : {
				"companyName" : companyName,
				"abbrCompanyName" : abbrCompanyName,
				"fieldId" : fieldId,
				"salesId" : salesId,
				"address" : address,
				"areaId" : areaId,
				"companySource" : mCompanySource,
				"arrayContact" : arrayContact
			},
			traditional : true,
			success : function(returndata) {
				var data = returndata.errcode;
				if (data == 0) {
					alert("提交成功");
					setTimeout(function() {
						toReloadPage();
					}, 500);
				} else if (data == 3) {
					alert("有相同或类似的客户名存在，请检查");
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
					href="#">客户关系管理</a>&nbsp;-</span>&nbsp;新建客户信息
			</div>
		</div>

		<!-- 新建客户信息 -->
		<div class="page">
			<div class="banneradd bor">
				<div class="baTopNo">
					<span>客户基本信息</span> <input type="radio" name="field03"
						id="companyType" value="1" checked="checked"
						onclick="checkCompanyType(1)"
						style="margin-left: 50px; margin-right: 5px;" /> <label>信息</label>
					<input type="radio" name="field03" id="companyType" value="2"
						onclick="checkCompanyType(2)"
						style="margin-left: 50px; margin-right: 5px;" /> <label>陪护床</label>
				</div>
				<div class="baBody">
					<div class="bbD">
						<label>客户全称：</label><input type="text" class="input3"
							id="companyName" style="width: 390px;" /><span id="divAbbrName"><label
							style="margin-left: 15px">简称：</label><input type="text"
							class="input3" id="abbrCompanyName" style="width: 210px" /></span>
					</div>

					<div class="bbD">
						   <label>销售人员：</label><select class="selCss" id="salesId"
							style="width: 400px;" /></select><span id="divfieldId"><label style="margin-left: 15px">客户行业：</label><select
							class="selCss" id="fieldId" style="width: 190px;"/></select></span>
					</div>

					<div class="bbD" >
						<label>客户地址：</label><input type="text" class="input3" id="address"
							style="width: 390px;" /><label style="margin-left: 15px">所属地区：</label><select
							class="selCss" id="areaId" style="width: 190px;" /></select>
						
					</div>

					<div class="bbD" id="divCompanySource" >
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
							style="width: 230px; background-color: #eee;" />
					</div>
					
					<div id="allContact" >

						<div class="bbD" id="mDiv1">
							<img style="height: 25px;float:left;margin-left:-45px;visibility:visible;"
								src="${pageContext.request.contextPath}/image/plus2018.png"
								onClick="addNewContact()" id="addBtn" >
                            <img style="height: 25px;float:left;margin-left:-15px;visibility:hidden;" 
                                src="${pageContext.request.contextPath}/image/minus2018.png"
								onClick="removeContact()" id="rmvBtn" ><label
								style="margin-left: 15px;">联系人：</label><input type="text"
								class="input3" id="contactUser1" style="width: 170px;" /><label
								style="margin-left: 15px;">邮箱：</label><input type="text"
								class="input3" id="email1" style="width: 430px;" /><br /> <br /> <label
								style="margin-left: 40px;">电话：</label><input type="text"
								class="input3" id="tel1" style="width: 170px;" /> <label
								style="margin-left: 15px;">部门：</label><input type="text"
								class="input3" id="depart1" style="width: 170px" /><label
								style="margin-left: 15px;">职务：</label><input type="text"
								class="input3" id="position1" style="width: 170px" />
						</div>
					</div>

					<div class="cfD" style="margin-bottom: 30px; margin-top: 30px">
						<a class="addA" href="#" onclick="createCompany()"
							style="margin-left: 90px">提交</a> <a class="addA" href="#"
							onclick="toIndexPage()">关闭</a>
					</div>
				</div>
			</div>
			<!-- 新建客户信息end -->

		</div>
	</div>
</body>
</html>