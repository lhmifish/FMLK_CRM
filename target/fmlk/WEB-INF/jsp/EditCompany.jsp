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
<script src="${pageContext.request.contextPath}/js/commonUtils.js?v=200"></script>
<script src="${pageContext.request.contextPath}/js/getObjectList.js?v=44"></script>
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
	var id;//客户id
	var sId;//sessionId
	var host;
	var arrayContact;
	var contactNum;
	var isPermissionEdit;
	var companySource;
	var salesId;
	var mCompanyId;
	var isFmlkShare;
	var operation;//0新增1编辑
	var editContactUserId;

	$(document).ready(function() {
		id = "${mId}";
		sId = "${sessionId}";
		host = "${pageContext.request.contextPath}";
		checkEditPremission(3, 0);
	});

	function initialPage() {
		arrayContact = new Array();
		getCompanyInfo(id);
		matchEdit("客户");
		$("#fieldId").select2({});
		$("#salesId").select2({});
		$("#areaId").select2({});
		$("#companyId").select2({});
		$("#fieldLevel").select2({});
		
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
				getFieldLevelList(data[0].fieldLevel);
				if(data[0].fieldId==2){
					var hospitalDataInfo = data[0].hospitalDataInfo;
					if(hospitalDataInfo != null && hospitalDataInfo != ""){
						$("#bedNum").val(hospitalDataInfo.split("#")[0]);
						$("#patientNum").val(hospitalDataInfo.split("#")[1]);
						$("#patientAccompanyNum").val(hospitalDataInfo.split("#")[2]);
						$("#outPatientNum").val(hospitalDataInfo.split("#")[3]);
					}
					$("#hospitalView").show();
				}
				getAreaList(data[0].areaId);
				mCompanyId = data[0].companyId;
				isFmlkShare = data[0].isFmlkShare;
				var mCompanySource = data[0].companySource;
				companySource = mCompanySource.split("#")[0];
				$("input[name='field02'][value=" + companySource + "]").attr(
						"checked", true);
				if (companySource == 4) {
					$("#companyId").removeAttr("disabled");
					$("#companyId").css('background-color', '#fff');
					getCompanyList("", 0, mCompanySource.split("#")[1], 0,isFmlkShare);
				} else if (companySource == 5) {
					$("#other").removeAttr("disabled");
					$("#other").css('background-color', '#fff');
					$("#other").val(mCompanySource.split("#")[1]);
					getCompanyList("", 0, 0, 0,isFmlkShare);
				} else {
					getCompanyList("", 0, 0, 0,isFmlkShare);
				}
				$('#address').val(data[0].address);
				getUserContact(data[0].companyId,data[0].isFmlkShare);
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
	}

	function getUserContact(companyId,isFmlkShare) {
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
						contactNum = data2.length;
						if(contactNum>0){
							var str = "";
							for(var i in data2){
								var title = "姓名："+data2[i].userName + "\n";
								if(data2[i].position != ""){
									title += "职务："+data2[i].position + "\n";
								}
								if(data2[i].department != ""){
									title += "部门："+data2[i].department + "\n";
								}
								if(data2[i].tel != ""){
									title += "电话："+data2[i].tel + "\n";
								}
								if(data2[i].wechatNo != ""){
									title += "微信："+data2[i].wechatNo + "\n";;
								}
								if(data2[i].email != ""){
									title += "邮箱："+data2[i].email + "\n";
								}
								arrayContact.push(data2[i].userName + "#" +data2[i].tel + "#" + data2[i].email + "#" 
										+ data2[i].department + "#" + data2[i].position + "#" + data2[i].wechatNo + "#" + data2[i].id);
								str += '<span id="contactUser"'+i+'><span style="background-color:#eee;width:50px;height:30px;" title="'+title+'"><label>'
								+ data2[i].userName+'</label></span><span><img style="height: 12px;margin-left:10px;margin-right:10px" src="${pageContext.request.contextPath}/image/update.png"'
								+' onClick="editContact('+i+')"></span></span>';
							}
							$("#ContactUsers").append(str);
						}
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
			getCompanyList("", 0, 0, 0,isFmlkShare);
			$("#other").removeAttr("disabled");
			$("#other").css('background-color', '#fff');
			$("#companyId").attr("disabled", "disabled");
			$("#companyId").css('background-color', '#eee');
		} else {
			getCompanyList("", 0, 0, 0,isFmlkShare);
			$("#companyId").attr("disabled", "disabled");
			$("#other").attr("disabled", "disabled");
			$("#companyId").css('background-color', '#eee');
			$("#other").css('background-color', '#eee');
			$("#other").val("");
		}
	}

	function editCompany() {
		if (!isPermissionEdit) {
			alert("你没有权限编辑客户");
			return;
		}
		var companyName = $("#companyName").val().trim();
		var abbrCompanyName = $("#abbrCompanyName").val().trim();
		var mSalesId = $("#salesId option:selected").val();
		var fieldId = $("#fieldId option:selected").val();
		var fieldLevel =  $("#fieldLevel").val();
		var hospitalDataInfo = $("#bedNum").val().trim()+"#"+$("#patientNum").val().trim()+"#"+$("#patientAccompanyNum").val().trim()+"#"+$("#outPatientNum").val().trim();
		var address = $("#address").val().trim();
		var areaId = $("#areaId option:selected").val();
		var tCompanyId = $("#companyId").val();
		var other = $("#other").val().trim();
		var mCompanySource = companySource + "#";
		if (companySource == 4) {
			mCompanySource += tCompanyId;
		} else if (companySource == 5) {
			mCompanySource += other;
		}
		if (companyName == "") {
			alert("公司名称不能为空");
			return;
		}
		if (mSalesId == 0) {
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
		if (companySource == 4 && tCompanyId == 0) {
			alert("当前客户来源介绍的客户不能为空");
			return;
		}

		if (companySource == 5 && other == "") {
			alert("当前客户来源请填写其他说明");
			return;
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
				"fieldLevel" : fieldLevel,
				"hospitalDataInfo":hospitalDataInfo,
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
						toReloadPage();
						toBackPage();
						toBackPage();
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
	
	function updateContactInfo(){
		var str = "";
		$("#ContactUsers").empty();
		contactNum = arrayContact.length;
		if(arrayContact.length>0){
			for(var i in arrayContact){
				var title = "姓名："+arrayContact[i].split("#")[0] + "\n";
				if(arrayContact[i].split("#")[4] != ""){
					title += "职务："+arrayContact[i].split("#")[4] + "\n";
				}
				if(arrayContact[i].split("#")[3] != ""){
					title += "部门："+arrayContact[i].split("#")[3] + "\n";
				}
				if(arrayContact[i].split("#")[1] != ""){
					title += "电话："+arrayContact[i].split("#")[1] + "\n";
				}
				if(arrayContact[i].split("#")[5] != ""){
					title += "微信："+arrayContact[i].split("#")[5] + "\n";
				}
				if(arrayContact[i].split("#")[2] != ""){
					title += "邮箱："+arrayContact[i].split("#")[2] + "\n";
				}
				
				str += '<span id="contactUser"'+i+'><span style="background-color:#eee;width:50px;height:30px;" title="'+title+'"><label>'
				+ arrayContact[i].split("#")[0]+'</label></span><span>';
				if(arrayContact[i].split("#")[6] != "null"){
					str += '<img style="height: 12px;margin-left:10px;margin-right:10px" src="${pageContext.request.contextPath}/image/update.png"'
					    +' onClick="editContact('+i+')"></span></span>';
					
				}else{
					str += '<img style="height: 25px" src="${pageContext.request.contextPath}/image/minus2018.png"'
						+' onClick="removeContact('+i+')"></span></span>';
				}
			}
			$("#ContactUsers").append(str);
		}
	}
	
	function addNewContact() {
		if(contactNum==5){
			alert("最多支持5个联系人");
			return;
		}else{
			operation = 0;
			document.getElementById("delTitle").innerHTML="添加客户联系人";
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
	
	function editContact(index){
		operation=1;
		document.getElementById("delTitle").innerHTML="编辑客户联系人";
		$("#userName").val(arrayContact[index].split("#")[0]);
		$("#tel").val(arrayContact[index].split("#")[1]);
		$("#email").val(arrayContact[index].split("#")[2]);
		$("#depart").val(arrayContact[index].split("#")[3]);
		$("#position").val(arrayContact[index].split("#")[4]);
		$("#wechat").val(arrayContact[index].split("#")[5]);
		editContactUserId = arrayContact[index].split("#")[6];
		$("#banDel").show();
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
			if(operation==1){
				//编辑
				var index;
				for(var i in arrayContact){
					if(arrayContact[i].split("#")[6] == editContactUserId){
						index = i;
					}
					if(arrayContact[i].split("#")[0]==contactUser && arrayContact[i].split("#")[6] != editContactUserId){
						alert("联系人不能重复添加");
						return;
					}
				}
			}else{
				//添加
				for(var i in arrayContact){
					if(arrayContact[i].split("#")[0]==contactUser){
						alert("联系人不能重复添加");
						return;
					}
				}
			}
		}
		var contactInfo = contactUser + "#" + tel + "#" + email + "#"
		+ depart + "#" + position + "#" + wechat + "#";
		if(operation==1){
			contactInfo += editContactUserId;
			arrayContact.splice(index, 1,contactInfo);
		}else{
			contactInfo += "null";
			arrayContact.push(contactInfo);
		}
		//更新页面联系人
		updateContactInfo();
		$("#banDel").hide();
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
						<span class="need">*</span><label style="margin-left:0">客户全称：</label><input type="text" class="input3"
							id="companyName" style="width: 390px;" /><span id="divAbbrName"><label
							style="margin-left: 25px">客户简称：</label> <input type="text"
							class="input3" id="abbrCompanyName" style="width: 180px" /></span>
					</div>

					<div class="bbD">
						<span class="need">*</span><label style="margin-left:0">销售人员：</label><select class="selCss" id="salesId"
							style="width: 400px;" /></select><span style="margin-left: 15px"><span class="need">*</span><label style="margin-left: 0px">客户行业：</label><select
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

					<div class="bbD">
						<label style="margin-left:12px">客户地址：</label><input type="text" class="input3" id="address"
							style="width: 390px;" /><span style="margin-left: 15px"><span class="need">*</span><label style="margin-left: 0px">所属地区：</label><select
							class="selCss" id="areaId" style="width: 190px;" /></select></span>
					</div>

					<div class="bbD" id="divCompanySource">
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
					
					<div class="cfD" style="margin-bottom: 30px; display: none;margin-left: 60px"
						id="operation">
						<a class="addA" href="#" onclick="editCompany()">保存</a> 
						<a class="addA" href="#" onclick="toBackPage()">返回</a>
					</div>
				</div>
			</div>

			<!-- 会员注册页面样式end -->
		</div>
	</div>
	<!-- 弹出框 -->
	<div class="banDel" id="banDel" >
		<div class="delete" style="width:800px">
			<div class="close">
				<a><img src="${pageContext.request.contextPath}/image/shanchu.png" onclick="closeConfirmBox()" /></a>
			</div>
			<p class="delP1" id="delTitle">添加客户联系人</p>
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
					style="margin-left: 0px; margin-bottom: 30px;" id="confirmText">保存</a> <a
					class="addA" onclick="closeConfirmBox()">取消</a>
			</div>
		</div>
	</div>
</body>
</html>