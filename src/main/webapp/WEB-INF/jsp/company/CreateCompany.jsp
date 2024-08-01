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
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/css.css?v=1997" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/select4.css?v=1999" />
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-3.2.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/select3.js"></script>
<script src="${pageContext.request.contextPath}/js/checkPermission.js"></script>
<script src="${pageContext.request.contextPath}/js/changePsd.js"></script>
<script src="${pageContext.request.contextPath}/js/commonUtils.js"></script>
<script src="${pageContext.request.contextPath}/js/getObjectList.js?v=44"></script>
<script src="${pageContext.request.contextPath}/js/request.js?v=3"></script>
<style type="text/css">
a:hover {
	color: #FF00FF
} /* 鼠标移动到链接上 */
.need{
   color:red;
   margin-right:5px;
   margin-left:0px
}
</style>
<script type="text/javascript">
	var companySource;
	var arrayContact;
	var contactNum;
	var sId;
	var host;
	var isPermissionView;
	var isFmlkShare;
	var requestReturn;

	$(document).ready(function() {
		sId = "${sessionId}";
		host = "${pageContext.request.contextPath}";
		checkViewPremission(2);
	});

	function initialPage() {
		isFmlkShare = true;
		getFieldList(0);
		getSalesList(0);
		getAreaList(0);
		getFieldLevelList(0)
		getCompanyList("", 0, 0, 0,isFmlkShare);
		$("#fieldId").select2({});
		$("#salesId").select2({});
		$("#areaId").select2({});
		$("#companyId").select2({});
		$("#fieldLevel").select2({});
		companySource = 1;
		contactNum = 0;
		arrayContact = new Array();
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
			getCompanyList("", 0, 0, 0,isFmlkShare);
			$("#other").removeAttr("disabled");
			$("#other").css('background-color', '#fff');
			$("#companyId").attr("disabled", "disabled");
			$("#companyId").css('background-color', '#eee');
		} else {
			getCompanyList("", 0, 0, 0,isFmlkShare);
			$("#other").attr("disabled", "disabled");
			$("#companyId").css('background-color', '#eee');
			$("#companyId").attr("disabled", "disabled");
			$("#other").css('background-color', '#eee');
			$("#other").val("");
		}
	}

	function checkCompanyType(id) {
		isFmlkShare = id==2;
		getCompanyList("", 0, 0, 0,isFmlkShare);
	}

	function createCompany() {
		if (!isPermissionView) {
			alert("你没有权限新建客户");
			return;
		}
		var companyName = $("#companyName").val().trim();
		var abbrCompanyName = $("#abbrCompanyName").val().trim();
		var salesId = $("#salesId").val();
		var fieldId = $("#fieldId").val();
		var fieldLevel =  $("#fieldLevel").val();
		var hospitalDataInfo = $("#bedNum").val().trim()+"#"+$("#patientNum").val().trim()+"#"+$("#patientAccompanyNum").val().trim()+"#"+$("#outPatientNum").val().trim();
		var address = $("#address").val().trim();
		var areaId = $("#areaId").val();
		var mCompanySource = companySource + "#";
		var companyId = $("#companyId").val();
		var other = $("#other").val().trim();
		if (companySource == 4) {
			mCompanySource += companyId;
		} else if (companySource == 5) {
			mCompanySource += other;
		}
		if (companyName == "") {
			alert("公司名称不能为空");
			return;
		}
		if (salesId == 0) {
			alert("请选择销售人员");
			return;
		}
		if (fieldId == 0) {
			alert("请选择客户行业");
			return;
		}else if(fieldId == 2 && fieldLevel == 0){
			alert("请选择行业等级");
			return;
		}		
		if (areaId == 0) {
			alert("请选择所属地区");
			return;
		}
		if (companySource == 4 && companyId == 0) {
			alert("当前客户来源介绍的客户不能为空");
			return;
		}

		if (companySource == 5 && other == "") {
			alert("当前客户来源请填写其他说明");
			return;
		}
		var params = {
				"companyName" : companyName,
				"abbrCompanyName" : abbrCompanyName,
				"fieldId" : fieldId,
				"fieldLevel" : fieldLevel,
				"hospitalDataInfo":hospitalDataInfo,
				"salesId" : salesId,
				"address" : address,
				"areaId" : areaId,
				"companySource" : mCompanySource,
				"arrayContact" : arrayContact,
				"isFmlkShare":isFmlkShare	
		}
		post("createNewCompany",params,true);
		if(requestReturn.result == "error"){
			alert(requestReturn.error);
		}else if(parseInt(requestReturn.code)==0){
			alert("提交成功");
			setTimeout(function() {
				toCompanyListPage();
			}, 500);
		}else if(parseInt(requestReturn.code) == 3){
			alert("有相同或类似的客户已录入，请勿重复录入");
		}else if(parseInt(requestReturn.code) <= 4 ){
			alert("客户录入提交失败,错误编号:"+requestReturn.code);
		}else{
			alert("客户录入成功,联系人录入失败");
		}
	}
	
	function addNewContact() {
		if(contactNum==5){
			alert("最多支持5个联系人");
			return;
		}else{
			$("#userName").val("");
			$("#tel").val("");
			$("#email").val("");
			$("#depart").val("");
			$("#position").val("");
			$("#wechat").val("");
			$("#banDel").show();
		}
	}

	function removeContact(id) {
		arrayContact.splice(id, 1);
		updateContactInfo();
	}
	
	function confirmAddContact(){
		var contactUser = $("#userName").val().trim();
		var tel = $("#tel").val().trim();
		var email = $("#email").val().trim();
		var depart = $("#depart").val().trim();
		var position = $("#position").val().trim();
		var wechat = $("#wechat").val().trim();
		if(contactUser == ""){
			alert("联系人姓名不能为空");
			return;
		}
		if (tel == "" && email == "" && wechat == "") {
			alert("客户联系人的 电话/邮箱/微信 至少需要一个");
			return;
		}
		if(arrayContact.length>0){
			for(var i in arrayContact){
				if(arrayContact[i].split("#")[0]==contactUser){
					alert("联系人不能重复添加");
					return;
				}
			}
		}
		tel = tel==""?"null":tel;
		email = email==""?"null":email;
		depart = depart==""?"null":depart;
		position = position==""?"null":position;
		wechat = wechat==""?"null":wechat;
		var contactInfo = contactUser + "#" + tel + "#" + email + "#"
		+ depart + "#" + position +"#" + wechat;
		arrayContact.push(contactInfo);
		//更新页面联系人
		updateContactInfo();
		$("#banDel").hide();
	}
	
	function updateContactInfo(){
		var str = "";
		$("#ContactUsers").empty();
		contactNum = arrayContact.length;
		if(arrayContact.length>0){
			for(var i in arrayContact){
				var title = "姓名："+arrayContact[i].split("#")[0] + "\n";
				if(arrayContact[i].split("#")[4] != "null"){
					title += "职务："+arrayContact[i].split("#")[4] + "\n";
				}
				if(arrayContact[i].split("#")[3] != "null"){
					title += "部门："+arrayContact[i].split("#")[3] + "\n";
				}
				if(arrayContact[i].split("#")[1] != "null"){
					title += "电话："+arrayContact[i].split("#")[1] + "\n";
				}
				if(arrayContact[i].split("#")[5] != "null"){
					title += "微信："+arrayContact[i].split("#")[5] + "\n";
				}
				if(arrayContact[i].split("#")[2] != "null"){
					title += "邮箱："+arrayContact[i].split("#")[2];
				}
				
				str += '<span id="contactUser"'+i+'><span style="background-color:#eee;width:50px;height:30px;" title="'+title+'"><label>'
				+ arrayContact[i].split("#")[0]+'</label></span><span><img style="height: 25px" src="${pageContext.request.contextPath}/image/minus2018.png"'
				+' onClick="removeContact('+i+')"></span></span>';
			}
			$("#ContactUsers").append(str);
		}
	}
	
	function changeField(mField){
		$("#bedNum").val("");
		$("#patientNum").val("");
		$("#patientAccompanyNum").val("");
		$("#outPatientNum").val("");
		if(mField==2){
			$("#hospitalView").show();
		}else{
			getFieldLevelList(0);
			$("#hospitalView").hide();
		}
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
					<span>客户基本信息</span> 
					<input type="radio" name="field03" value="2" checked="checked"
						onclick="checkCompanyType(2)"
						style="margin-left: 50px; margin-right: 5px;" /> <label>共享陪护</label>
					<input type="radio" name="field03" value="1" 
						onclick="checkCompanyType(1)"
						style="margin-left: 50px; margin-right: 5px;" /> <label>信息</label>
				</div>
				<div class="baBody">
					<div class="bbD">
						<span class="need">*</span><label style="margin-left:0">客户全称：</label><input type="text" class="input3" placeHolder="请填写完整的客户名称"
							id="companyName" style="width: 390px;" /><span><label
							style="margin-left: 25px">客户简称：</label><input type="text" class="input3" id="abbrCompanyName" style="width: 180px" /></span>
					</div>

					<div class="bbD">
						   <span class="need">*</span><label style="margin-left:0">销售人员：</label><select class="selCss" id="salesId"
							style="width: 400px;" /></select><span style="margin-left: 15px"><span class="need">*</span><label style="margin-left:0">客户行业：</label><select
							class="selCss" id="fieldId" style="width: 190px;" onChange="changeField(this.options[this.options.selectedIndex].value)"/></select></span>					
					</div>
                    <div class="bbD" id="hospitalView" style="display:none">
                        <span class="need">*</span><label style="margin-left:0px">行业等级：</label><select
							class="selCss" id="fieldLevel" style="width: 90px;"/></select><label style="margin-left:15px;">床位数：</label><input type="text" class="input3" id="bedNum"
							style="width: 50px;"/><label style="margin-left:15px;">住院人数：</label><input type="text" class="input3" id="patientNum"
							style="width: 50px;"/><label style="margin-left:15px;">陪夜人数：</label><input type="text" class="input3" id="patientAccompanyNum"
							style="width: 50px;"/><label style="margin-left:15px;">门诊量：</label><input type="text" class="input3" id="outPatientNum"
							style="width: 50px;"/>
                    </div>
					<div class="bbD" >
						<label style="margin-left:12px">客户地址：</label><input type="text" class="input3" id="address"
							style="width: 390px;" /><span style="margin-left: 15px"><span class="need">*</span><label style="margin-left: 0px">所属地区：</label><select
							class="selCss" id="areaId" style="width: 190px;" /></select></span>
					</div>
					<div class="bbD" >
						<label style="margin-left:12px">客户来源：</label>
                        <input type="radio" name="field02" id="companySource" value="1" checked="checked"
							onclick="checkCompanySource(1)" /><label
							style="margin-right: 50px; margin-left: 5px;">厂商</label>
                        <input type="radio" name="field02" id="companySource" value="2"
							onclick="checkCompanySource(2)" /><label
							style="margin-right: 50px; margin-left: 5px;">招投标</label>
                        <input type="radio" name="field02" id="companySource" value="3"
							onclick="checkCompanySource(3)" /><label
							style="margin-right: 50px; margin-left: 5px;">电话联系</label>
						<input type="radio" name="field02" id="companySource" value="4"
							onclick="checkCompanySource(4)"/><label style="margin-left: 5px;">客户介绍</label>
                            <select class="selCss" id="companyId" style="width: 263px; background-color: #eee"
							disabled="disabled" /></select><br/>
						<input type="radio" name="field02" id="companySource" value="5" 
						    onclick="checkCompanySource(5)" style="margin-left: 100px;margin-top:10px" /><label style="margin-left: 5px;margin-top:10px">其他</label>
						<input type="text" class="input3" id="other" disabled="disabled"
							style="width: 625px; background-color: #eee;;margin-top:10px" />
					</div>
					
					<div id="ContactUserDiv" style="margin-bottom:50px">
						<div class="bbD" id="mDiv1">
							<label
								style="margin-right:0px">联系人信息：</label><img style="height: 25px;"
								src="${pageContext.request.contextPath}/image/plus2018.png"
								onClick="addNewContact()" id="addBtn" >
						</div>
						
						<div class="bbD" id="ContactUsers" style="padding-left:100px">
						    
						</div>
					</div>

					<div class="cfD" style="margin-bottom: 30px; margin-top: 30px">
						<a class="addA" href="#" onclick="createCompany()"
							style="margin-left: 90px">提交</a> <a class="addA" href="#"
							onclick="toIndexPage()">关闭</a><!--  <a class="addA" href="#"
							onclick="createCompanyRelationTable()">创建客户拜访表</a> -->
					</div>
				</div>
			</div>
			<!-- 新建客户信息end -->

		</div>
	</div>
	<!-- 弹出框 -->
	<div class="banDel" id="banDel" >
		<div class="delete" style="width:800px">
			<div class="close">
				<a><img src="../image/shanchu.png" onclick="closeConfirmBox()" /></a>
			</div>
			<p class="delP1">添加客户联系人</p>
			<div class="cfD" style="margin-top: 30px">
			   <span class="need">*</span><label style="font-size: 16px;margin-left:0px">姓名：</label> <input type="text" style="width: 100px;height:26px; border-bottom: 1px dashed #78639F; border-left: none; border-right: none; border-top: none; padding-left: 10px;" id="userName" />
			   <label style="font-size: 16px;">职务：</label> <input type="text" style="width: 100px;height:26px; border-bottom: 1px dashed #78639F; border-left: none; border-right: none; border-top: none;  padding-left: 10px;" id="position" />
			   <label style="font-size: 16px;">部门：</label> <input type="text" style="width: 100px;height:26px; border-bottom: 1px dashed #78639F; border-left: none; border-right: none; border-top: none;  padding-left: 10px;" id="depart" />		
			</div>
			<div class="cfD" style="margin-top: 30px">
			   <span class="need">*</span><label style="font-size: 16px;margin-left:0px">电话：</label> <input type="text" style="width: 193px;height:26px; border-bottom: 1px dashed #78639F; border-left: none; border-right: none; border-top: none; padding-left: 10px;margin-right:10px" id="tel" />
			   <span class="need">*</span><label style="font-size: 16px;margin-left:0px">微信：</label> <input type="text" style="width: 193px;height:26px; border-bottom: 1px dashed #78639F; border-left: none; border-right: none; border-top: none;  padding-left: 10px;" id="wechat" />
			</div>
			<div class="cfD" style="margin-top: 30px">
			   <span class="need">*</span><label style="font-size: 16px;margin-left:0px">邮箱：</label> <input type="text" style="width: 474px;height:26px; border-bottom: 1px dashed #78639F; border-left: none; border-right: none; border-top: none; padding-left: 10px;" id="email" />
			</div>
			<p class="delP1" style="color:red">※  客户联系人的 电话/微信/邮箱 至少需要一个  ※</p>
			<div class="cfD" style="margin-top: 30px">
				<a class="addA" href="#" onclick="confirmAddContact()"
					style="margin-left: 0px; margin-bottom: 30px;">添加</a> <a
					class="addA" onclick="closeConfirmBox()">取消</a>
			</div>
		</div>
	</div>
</body>
</html>