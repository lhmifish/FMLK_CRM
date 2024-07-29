<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="pragma" content="no-cache" />
<meta http-equiv="cache-control" content="no-cache" />
<title>客户拜访记录表</title>
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/css.css?v=1990" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/select4.css?v=1997" />
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/calendar.css" />
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.2.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/select3.js"></script>
<script src="${pageContext.request.contextPath}/js/checkPermission.js"></script>
<script src="${pageContext.request.contextPath}/js/changePsd.js"></script>
<script src="${pageContext.request.contextPath}/js/commonUtils.js"></script>
<script src="${pageContext.request.contextPath}/js/getObjectList.js?v=2024"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/calendar.js"></script>
<style type="text/css">
a:hover {
	color: #FF00FF
} /* 鼠标移动到链接上 */
::-webkit-scrollbar {
	display: none;
}

html {
	-ms-overflow-style: none;
	/*火狐下隐藏滚动条*/
	overflow: -moz-scrollbars-none;
}

.line1 {
	width: 1px;
	height: 100%;
	background-color: #dcdbdb
}

.line2 {
	width: 100%;
	height: 1px;
	background-color: #dcdbdb
}

.flexRowCenter {
	height: 100%;
	display: flex;
	flex-direction: row;
	justify-content: center;
}

.flexRowAlign {
	height: 100%;
	display: flex;
	flex-direction: row;
	align-items: center;
}

.flexRowCenter2 {
	display: flex;
	flex-direction: row;
	justify-content: center;
	height: 20px;
	width: 100%;
	color:blue
}

.flexCloumnAlignCenter {
	height: 100%;
	display: flex;
	flex-direction: column;
	justify-content: center;
	align-items: center;
}
.divView{
   width: 100%; display: flex; flex-direction: row; align-items: center; justify-content: center; border-bottom: 1px solid #dcdbdb
}

.divView1{
   width: 120px; display: flex; flex-direction: row; align-items: center; justify-content: center;border-right: 1px solid #dcdbdb;border-bottom:0;height:100%
}

.divView2{
   width: 788px; display: flex; flex-direction: row; align-items: center; justify-content: center;border-bottom:0;height:100%;
}

.divView3{
overflow-y:scroll;height:80%;width:780px;justify-content: flex-start;
}

.visitRecordDate{
   height:100%;width:120px;border-right: 1px solid #dcdbdb;display:flex;flex-direction:row;justify-content: center;align-items: center;
}

.visitRecordDesc{
   height:100%;width:788px;border-right: 1px solid #dcdbdb;overflow-y:scroll
}

.visitRecordUser{
   height:100%;width:90px;display:flex;flex-direction:row;justify-content: center;align-items: center;
}

</style>
<script type="text/javascript">
	var sId;
	var host;
	var isPermissionView;
	var isFmlkShare;
	var mCompanyId;
	var contactNum;
	var recordNum;
	var titleList;
	var updateIndex;

	$(document).ready(function() {
		sId = "${sessionId}";
		host = "${pageContext.request.contextPath}";
		titleList = ["产品投放位置说明","需要解决问题","用户需求","现状描述","遗留问题","解决方案","所需资质","竞争对手"]
		checkViewPremission(5);
	});

	function initialPage() {
		var isCheck = document.getElementsByName('field03');
		isFmlkShare = isCheck[0].checked;
		mCompanyId = 0
		$("#companyId").select2({});
		fliterCompanyList();
		//getCompanyList("", 0, 0, 1, isFmlkShare);
		for(var i in titleList){
			document.getElementById("updateTitle"+i).innerHTML=titleList[i];
		}
		$('#dd').calendar({
			trigger : '#visitDate',
			zIndex : 999,
			format : 'yyyy/mm/dd',
			onSelected : function(view, date, data) {
			},
			onClose : function(view, date, data) {
				$('#visitDate').val(formatDate(date).substring(0, 10));
			}
		});
	}

	function checkCompanyType(type) {
		isFmlkShare = type == 2;
		getCompanyList("", 0, 0, 1, isFmlkShare);
		//清空数据
		clearTable();
	}
	
	function fliterCompanyList(){
		var user = getUserSpec(sId);
		if(user.roleId==5){
			getCompanyList("", user.UId, 0, 1, isFmlkShare);
		}else{
			getCompanyList("", 0, 0, 1, isFmlkShare);
		}
	}
	
	function changeCompany(companyId){
		clearTable();
		if(companyId!=0){
			getCompanyInfo(companyId);
		}
	}
	
	function getCompanyInfo(tid) {
		$.ajax({
			url : host + "/getCompanyByCompanyId",
			type : 'GET',
			cache : false,
			async : false,
			data : {
				"companyId" : tid
			},
			success : function(returndata) {
				var data = eval("(" + returndata + ")").company;
				mCompanyId = data[0].companyId;
				var companyName = data[0].companyName;
				if(data[0].fieldLevel!=0){
					companyName += "("+getFieldLevel(data[0].fieldLevel).levelName+")";
				}
				document.getElementById("companyName").innerHTML=companyName;
				document.getElementById("sales").innerHTML=getUser(data[0].salesId).name;
				document.getElementById("address").innerHTML=data[0].address;
				getContactUser(mCompanyId);
				var hospitalDataInfo = data[0].hospitalDataInfo;
				if(hospitalDataInfo != ""){
					document.getElementById("bedNum").innerHTML=hospitalDataInfo.split("#")[0];
					document.getElementById("patientNum").innerHTML=hospitalDataInfo.split("#")[1];
					document.getElementById("patientAccompanyNum").innerHTML=hospitalDataInfo.split("#")[2];
					document.getElementById("outPatientNum").innerHTML=hospitalDataInfo.split("#")[3];
				}
				getClientDetailInfo(mCompanyId);
                getVisitRecord(mCompanyId);
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
	}
	
	function clearTable(){
		document.getElementById("companyName").innerHTML="";
		document.getElementById("sales").innerHTML="";
		document.getElementById("address").innerHTML="";
		for(var i=0;i<contactNum;i++){
			document.getElementById("uName"+i).innerHTML="";
			document.getElementById("uTel"+i).innerHTML="";
			document.getElementById("uPosition"+i).innerHTML="";
		}
		document.getElementById("bedNum").innerHTML="";
		document.getElementById("patientNum").innerHTML="";
		document.getElementById("patientAccompanyNum").innerHTML="";
		document.getElementById("outPatientNum").innerHTML="";
		for(var i=0;i<titleList.length;i++ ){
			document.getElementById("content"+i).innerHTML="";
			$("#content"+i).removeAttr("title");
		}
		$("input[name='field01'][value='0']").prop("checked", true);
		document.getElementById("visitTimes").innerHTML="";
		contactNum = 0;
		recordNum = 0;
		$("#visitRecord").empty();
		var recordStr ='<div class="flexRowCenter2" style="border-bottom:1px solid #dcdbdb;height:100px"><div class="visitRecordDate"></div>'
		+'<div class="visitRecordDesc"><div style="margin-left:5px"></div></div><div class="visitRecordUser"></div></div>';
		$("#visitRecord").append(recordStr);
	}
	
	function getFieldLevel(levelId){
		var mFieldLevel;
		$.ajax({
			url : host + "/getFieldLevel",
			type : 'GET',
			data : {
				"levelId" : levelId
			},
			cache : false,
			async : false,
			success : function(returndata) {
				mFieldLevel = eval("(" + returndata + ")").fieldLevel[0];
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
		return mFieldLevel;
	}
	
	function getUser(userId) {
		var user;
		$.ajax({
			url : host + "/getUserById",
			type : 'GET',
			data : {
				"uId" : userId
			},
			cache : false,
			async : false,
			success : function(returndata) {
				user = eval("(" + returndata + ")").user[0];
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
		return user;
	}
	
	function getUserSpec(uNickName) {
		var user;
		$.ajax({
			url : host + "/getUserByNickName",
			type : 'GET',
			async : false,
			data : {
				"nickName" : uNickName
			},
			cache : false,
			success : function(returndata) {
				user = eval("(" + returndata + ")").user[0];
			}
		});
		return user;
	}
	
	function getContactUser(companyId){
		$.ajax({
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
							for(var i in data2){
								document.getElementById("uName"+i).innerHTML=data2[i].userName;
								document.getElementById("uTel"+i).innerHTML=data2[i].tel;
								document.getElementById("uPosition"+i).innerHTML=data2[i].position;
							}
						}
					},
					error : function(XMLHttpRequest, textStatus, errorThrown) {
					}
				});
	}
	
	function getClientDetailInfo(companyId){
		$.ajax({
			url : host + "/getClientDetailInfo",
			type : 'GET',
			data : {
				"companyId" : companyId
			},
			cache : false,
			async : false,
			success : function(returndata) {
				var errcode = eval("(" + returndata + ")").errcode;
				if(errcode == 0){
					var data2 = eval("(" + returndata + ")").ClientDetailInfo[0];
					document.getElementById("content0").innerHTML=data2.putPosition;
					document.getElementById("content1").innerHTML=data2.currentProblem;
					document.getElementById("content2").innerHTML=data2.demand;
					document.getElementById("content3").innerHTML=data2.currentStateDesc;
					document.getElementById("content4").innerHTML=data2.leftProblem;
					document.getElementById("content5").innerHTML=data2.solution;
					document.getElementById("content6").innerHTML=data2.qualifications;
					document.getElementById("content7").innerHTML=data2.competitor;
					$("input[name='field01'][value=" + data2.schedule + "]").prop(
							"checked", true);
					$("#content0").attr("title",data2.putPosition);
					$("#content1").attr("title",data2.currentProblem);
					$("#content2").attr("title",data2.demand);
					$("#content3").attr("title",data2.currentStateDesc);
					$("#content4").attr("title",data2.leftProblem);
					$("#content5").attr("title",data2.solution);
					$("#content6").attr("title",data2.qualifications);
					$("#content7").attr("title",data2.competitor);
				}
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
	}
	
	function getVisitRecord(companyId){
		$.ajax({
			url : host + "/visitRecordList",
			type : 'GET',
			data : {
				"companyId" : companyId
			},
			cache : false,
			async : false,
			success : function(returndata) {
				var errcode = eval("(" + returndata + ")").errcode;
				if(errcode == 0){
					var list = eval("(" + returndata + ")").visitRecordList;
					recordNum = list.length;
					document.getElementById("visitTimes").innerHTML=recordNum+" 次";
					if(recordNum>0){
						$("#visitRecord").empty();
						var str='';
						for(var i in list){
							str+='<div class="flexRowCenter2" style="border-bottom:1px solid #dcdbdb;height:100px">'
							+'<div class="visitRecordDate">'+list[i].visitDate
							+'</div><div class="visitRecordDesc" title="'+list[i].visitDesc+'"><div style="margin-left:5px">'+list[i].visitDesc
							+'</div></div><div class="visitRecordUser">'+ getUser(list[i].salesId).name +'</div></div>';
						}
						$("#visitRecord").append(str);
					}
				}
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
	}
	
	function openWin(index){
		if(mCompanyId==0){
			alert("请先选择客户");
		}else{
			updateIndex = index;
			document.getElementById("title").innerHTML=titleList[index];
			var currentContent = document.getElementById("content"+index).innerHTML;
			$("#currentContent").val(currentContent);
			$("#currentContent").attr("title",currentContent);
			$("#updateContent").val("");
			if(currentContent==""){
				$("#currentContentView").hide();
			}else{
				$("#currentContentView").show();
			}
			$("#banDel").show();
		}
	}
	
    function openWin2(){
		if(mCompanyId==0){
			alert("请先选择客户");
		}else{
			$("#visitDesc").val("");
			$('#visitDate').val(formatDate(new Date()).substring(0, 10));
			$("#banDel2").show();
		}
	}
	
	function selectClientSchedule(id){
		if(mCompanyId==0){
			alert("请先选择客户");
			$("input[name='field01'][value='0']").prop("checked", true);
		}else{
			updateIndex = 8;
			updateClientDetailInfo(updateIndex,id);
		}
	}
	
	function confirmUpdate(){
		var updateContent = $("#updateContent").val().trim();
		if(updateContent==""){
			alert("请输入添加的"+titleList[updateIndex]+"内容");
		}else{
			updateClientDetailInfo(updateIndex,updateContent);
		}
	}
	
	function updateClientDetailInfo(index,value){
		var putPosition = document.getElementById("content0").innerHTML;
		var currentProblem = document.getElementById("content1").innerHTML;
		var demand = document.getElementById("content2").innerHTML;
		var currentStateDesc = document.getElementById("content3").innerHTML;
		var leftProblem = document.getElementById("content4").innerHTML;
		var solution = document.getElementById("content5").innerHTML;
		var qualifications = document.getElementById("content6").innerHTML;
		var competitor = document.getElementById("content7").innerHTML;
		var schedule = document.querySelector('input[name="field01"]:checked').value;
		putPosition = index==0?putPosition+'\n'+value:putPosition;
		currentProblem = index==1?currentProblem+'\n'+value:currentProblem;
	    demand = index==2?demand+'\n'+value:demand;
		currentStateDesc = index==3?currentStateDesc+'\n'+value:currentStateDesc;
		leftProblem = index==4?leftProblem+'\n'+value:leftProblem;
		solution = index==5?solution+'\n'+value:solution;
		qualifications = index==6?qualifications+'\n'+value:qualifications;
		competitor = index==7?competitor+'\n'+value:competitor;
		$.ajax({
			url :  host + "/editClientDetailInfo",
			type : 'POST',
			cache : false,
			data : {
				"putPosition" : putPosition,
				"currentProblem" : currentProblem,
				"demand" : demand,
				"currentStateDesc" : currentStateDesc,
				"leftProblem" : leftProblem,
				"solution" : solution,
				"qualifications" : qualifications,
				"competitor" :competitor,
				"schedule":schedule,
				"companyId":mCompanyId
			},
			success : function(returndata) {
				var data = eval("(" + returndata + ")").errcode;
				if(data==0){
					if(index != 8){
						alert("更新客户拜访表内容成功");
						changeCompany(mCompanyId);
					}
				}else{
					alert("更新客户拜访表内容失败");
				}
				$("#banDel").hide();
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
	}
	
	function confirmUpdateVisitRecord(){
		var visitDate = $("#visitDate").val().trim();
		var visitDesc = $("#visitDesc").val().trim();
		if(visitDate==""){
			alert("请选择拜访日期");
		}else if(visitDesc==""){
			alert("请输入拜访内容");
		}else{
			updateVisitRecord(visitDate,visitDesc);
		}
	}
	
	function updateVisitRecord(visitDate,visitDesc){
		$.ajax({
			url : host + "/createVisitRecord",
			type : 'POST',
			cache : false,
			data : {
				"visitDate" : visitDate,
				"desc" : visitDesc,
				"salesId" : getUserSpec(sId).UId,
				"companyId" : mCompanyId
			},
			success : function(returndata) {
				var data = eval("(" + returndata + ")").errcode;
				if(data==0){
					alert("提交拜访进度成功");
					getVisitRecord(mCompanyId);
				}else{
					alert("提交拜访进度失败");
				}
				$("#banDel2").hide();
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
				<img src="../image/coin02.png" /><span><a href="#">首页</a>&nbsp;-&nbsp;<a
					href="#">客户关系管理</a>&nbsp;-</span>&nbsp;客户拜访记录表
			</div>
		</div>

		<div class="page">
			<!-- 完整页面 -->
			<div class="vip">
				<div class="conform">
					<form>
						<div class="cfD">
							<Strong style="margin-right: 20px">查询条件：</Strong> <label>客户名称：</label>
							<select class="selCss" style="width: 550px; margin-right: 20px"
								id="companyId" onChange="changeCompany(this.options[this.options.selectedIndex].value)"/></select><input type="radio" name="field03" value="2"
								checked="checked" onclick="checkCompanyType(2)"
								style="margin-left: 20px;" /> <label>共享陪护</label> <input
								type="radio" name="field03" value="1"
								onclick="checkCompanyType(1)" style="margin-left: 20px;" /> <label>信息</label>
						</div>
					</form>
				</div>

				<div class="conShow"
					style="width: 1000px; height: auto; border: 1px solid #dcdbdb;margin-bottom:50px">
					<div class="divView"
						style="height: 40px;font-size: 18px;">客户拜访表</div>
					<!-- 医院情况-->
					<div class="divView" style="height: 163px;font-size: 10px;">
						<div class="divView" style="width: 120px; height: 163px; border-right: 1px solid #dcdbdb;border-bottom:0">医院情况</div>
						<div  style="width: 879px; height: 163px; display: flex; flex-direction: column; align-items: center;">
							<div class="divView" style="height: 20px;">
								<div class="flexRowCenter" style="width: 105px;">医院名称(级别)</div>
								<span class="line1"></span>
								<div 
									style="width: 611px; height: 100%; display: flex; flex-direction: row;">
									<div style="margin-left: 20px;color:blue" id="companyName"></div>
								</div>
								<span class="line1"></span>
								<div class="flexRowCenter" style="width: 70px;">销售经理</div>
								<span class="line1"></span>
								<div class="flexRowCenter" style="width: 90px;color:blue" id="sales"></div>
							</div>
							<div class="divView" style="height: 104px;">
								<div class="flexRowCenter"
									style="width: 105px; align-items: center;">医院地址</div>
								<span class="line1"></span>
								<div class="flexCloumnAlignCenter" style="width: 280px;">
									<div style="margin: 0 20px;color:blue" id="address"></div>
								</div>
								<span class="line1"></span>
								<div class="flexCloumnAlignCenter" style="width: 70px;">联系人</div>
								<span class="line1"></span>
								<div class="flexCloumnAlignCenter" style="width: 70px;">
									<div class="flexRowCenter2" id="uName0"></div>
									<span class="line2"></span>
									<div class="flexRowCenter2" id="uName1"></div>
									<span class="line2"></span>
									<div class="flexRowCenter2" id="uName2"></div>
									<span class="line2"></span>
									<div class="flexRowCenter2" id="uName3"></div>
									<span class="line2"></span>
									<div class="flexRowCenter2" id="uName4"></div>
								</div>
								<span class="line1"></span>
								<div class="flexCloumnAlignCenter" style="width: 70px;">联系电话</div>
								<span class="line1"></span>
								<div class="flexCloumnAlignCenter" style="width: 117px;">
									<div class="flexRowCenter2" id="uTel0"></div>
									<span class="line2"></span>
									<div class="flexRowCenter2" id="uTel1"></div>
									<span class="line2"></span>
									<div class="flexRowCenter2" id="uTel2"></div>
									<span class="line2"></span>
									<div class="flexRowCenter2" id="uTel3"></div>
									<span class="line2"></span>
									<div class="flexRowCenter2" id="uTel4"></div>
								</div>
								<span class="line1"></span>
								<div class="flexCloumnAlignCenter" style="width: 70px;">职务</div>
								<span class="line1"></span>
								<div class="flexCloumnAlignCenter" style="width: 90px;">
									<div class="flexRowCenter2" id="uPosition0"></div>
									<span class="line2"></span>
									<div class="flexRowCenter2" id="uPosition1"></div>
									<span class="line2"></span>
									<div class="flexRowCenter2" id="uPosition2"></div>
									<span class="line2"></span>
									<div class="flexRowCenter2" id="uPosition3"></div>
									<span class="line2"></span>
									<div class="flexRowCenter2" id="uPosition4"></div>
								</div>
							</div>
							<div class="divView" style="height: 20px;">
								<div class="flexRowCenter" style="width: 105px;">床位数</div>
								<span class="line1"></span>
								<div class="flexRowCenter" style="width: 144px;color:blue" id="bedNum"></div>
								<span class="line1"></span>
								<div class="flexRowCenter" style="width: 135px">住院人数</div>
								<span class="line1"></span>
								<div class="flexRowCenter" style="width: 141px;color:blue" id="patientNum"></div>
								<span class="line1"></span>
								<div class="flexRowCenter" style="width: 70px;">陪夜人数</div>
								<span class="line1"></span>
								<div class="flexRowCenter" style="width: 117px;color:blue" id="patientAccompanyNum"></div>
								<span class="line1"></span>
								<div class="flexRowCenter" style="width: 70px;">门诊量</div>
								<span class="line1"></span>
								<div class="flexRowCenter" style="width: 90px;color:blue" id="outPatientNum"></div>
							</div>
							<div class="flexRowCenter" style="height:20px">
								<div class="flexRowCenter" style="width: 105px;">目前进度</div>
								<span class="line1"></span>
								<div class="flexRowAlign" style="width: 611px;">
									<div class="flexRowAlign" style="width: 100%;">
										<input type="radio" name="field01" value="0" checked="checked"
											onclick="selectClientSchedule(0)" style="margin-left: 20px; margin-right: 10px" /><label>随拜</label>
										<input type="radio" name="field01" value="1"
											onclick="selectClientSchedule(1)" style="margin: 0 10px" /><label>介绍产品</label>
										<input type="radio" name="field01" value="2"
											onclick="selectClientSchedule(2)" style="margin: 0 10px" /><label>谈需求</label>
										<input type="radio" name="field01" value="3"
											onclick="selectClientSchedule(3)" style="margin: 0 10px" /><label>商务谈判</label>
										<input type="radio" name="field01" value="4"
											onclick="selectClientSchedule(4)" style="margin: 0 10px" /><label>签约</label>
										<input type="radio" name="field01" value="5"
											onclick="selectClientSchedule(5)" style="margin: 0 10px" /><label>经常</label>
										<input type="radio" name="field01" value="6"
											onclick="selectClientSchedule(6)" style="margin: 0 10px" /><label>上线</label>
									</div>
								</div>
								<span class="line1"></span>
								<div class="flexRowCenter" style="width: 70px;">访问次数</div>
								<span class="line1"></span>
								<div class="flexRowCenter" style="width: 90px;color:blue" id="visitTimes"></div>
							</div>
						</div>
					</div>

					<!-- 医院情况 end-->
					<!-- 投放-->
                    <div class="divView" style="height: 80px;font-size: 10px;">
                       <div class="divView1" id="updateTitle0"></div>
                       <div class="divView2">
                           <div class="divView3" id="content0" style="color:blue"></div>
                       </div>
                       <span class="line1"></span>
                       <div class="divView" style="width: 90px;border-bottom:0;height:100%">
                          <a class="addA" href="#" onclick="openWin(0)" style="margin: 0px;height:35px;width:58px">添加</a>
                       </div>
                    </div>
                    <!-- 投放 end-->
					<!-- 当前问题-->
                    <div class="divView" style="height: 80px;font-size: 10px;">
                       <div class="divView1" id="updateTitle1"></div>
                       <div class="divView2">
                           <div class="divView3" id="content1" style="color:blue"></div>
                       </div>
                       <span class="line1"></span>
                       <div class="divView" style="width: 90px;border-bottom:0;height:100%">
                          <a class="addA" href="#" onclick="openWin(1)" style="margin: 0px;height:35px;width:58px">添加</a>
                       </div>
                    </div>
					<!-- 当前问题 end-->

					<!-- 用户需求-->
                    <div class="divView" style="height:80px;font-size: 10px;">
                       <div class="divView1" id="updateTitle2"></div>
                       <div class="divView2">
                           <div class="divView3" id="content2" style="color:blue"></div>
                       </div>
                       <span class="line1"></span>
                       <div class="divView" style="width: 90px;border-bottom:0;height:100%">
                          <a class="addA" href="#" onclick="openWin(2)" style="margin: 0px;height:35px;width:58px">添加</a>
                       </div>
                    </div>
					<!-- 用户需求 end-->

					<!-- 现状描述-->
                    <div class="divView" style="height: 80px;font-size: 10px;">
                       <div class="divView1" id="updateTitle3"></div>
                       <div class="divView2">
                           <div class="divView3" id="content3" style="color:blue"></div>
                       </div>
                       <span class="line1"></span>
                       <div class="divView" style="width: 90px;border-bottom:0;height:100%">
                          <a class="addA" href="#" onclick="openWin(3)" style="margin: 0px;height:35px;width:58px">添加</a>
                       </div>
                    </div>
					<!-- 现状描述 end-->

					<!-- 拜访进度-->
                    <div class="divView" style="height: 40px;font-size: 10px;">
                        <div class="divView1" style="border-right:0px">拜访日期及进度</div>
                       <div class="divView2">
                       </div>
                       <div class="divView" style="width: 90px;border-bottom:0;height:100%">
                          <a class="addA" href="#" onclick="openWin2()" style="margin: 0px;height:35px;width:58px;background-color:#f0ad4e">添加</a>
                       </div>
                    </div>
                    <div style="display:flex;flex-direction:column;width:100%" id="visitRecord">
                        <div class="flexRowCenter2" style="border-bottom:1px solid #dcdbdb">
                             <div class="visitRecordDate"></div>
                             <div class="visitRecordDesc"></div>
                             <div class="visitRecordUser"></div>
                        </div>
                    </div>
					<!-- 拜访进度 end-->
					
					<!-- 遗留问题-->
                    <div class="divView" style="height:80px;font-size: 10px;">
                       <div class="divView1" id="updateTitle4"></div>
                       <div class="divView2">
                           <div class="divView3" id="content4" style="color:blue"></div>
                       </div>
                       <span class="line1"></span>
                       <div class="divView" style="width: 90px;border-bottom:0;height:100%">
                          <a class="addA" href="#" onclick="openWin(4)" style="margin: 0px;height:35px;width:58px">添加</a>
                       </div>
                    </div>
					<!-- 遗留问题 end-->
					
					<!-- 解决方案-->
                    <div class="divView" style="height:80px;font-size: 10px;">
                       <div class="divView1" id="updateTitle5"></div>
                       <div class="divView2">
                           <div class="divView3" id="content5" style="color:blue"></div>
                       </div>
                       <span class="line1"></span>
                       <div class="divView" style="width: 90px;border-bottom:0;height:100%">
                          <a class="addA" href="#" onclick="openWin(5)" style="margin: 0px;height:35px;width:58px">添加</a>
                       </div>
                    </div>
					<!-- 解决方案 end-->
					
					<!-- 所需资质-->
                    <div class="divView" style="height:80px;font-size: 10px;">
                       <div class="divView1" id="updateTitle6"></div>
                       <div class="divView2">
                           <div class="divView3" id="content6" style="color:blue"></div>
                       </div>
                       <span class="line1"></span>
                       <div class="divView" style="width: 90px;border-bottom:0;height:100%">
                          <a class="addA" href="#" onclick="openWin(6)" style="margin: 0px;height:35px;width:58px">添加</a>
                       </div>
                    </div>
					<!-- 所需资质 end-->
					
					<!-- 竞争对手-->
                    <div class="divView" style="height:80px;font-size: 10px;border-bottom:0px">
                       <div class="divView1" id="updateTitle7"></div>
                       <div class="divView2">
                           <div class="divView3" id="content7" style="color:blue"></div>
                       </div>
                       <span class="line1"></span>
                       <div class="divView" style="width: 90px;border-bottom:0;height:100%">
                          <a class="addA" href="#" onclick="openWin(7)" style="margin: 0px;height:35px;width:58px">添加</a>
                       </div>
                    </div>
					<!-- 竞争对手 end-->
				</div>

			</div>
			<!-- 完整页面-->
		</div>

	</div>
    <!-- 弹出框 -->
	<div class="banDel" id="banDel" >
		<div class="delete" style="width:600px">
			<div class="close">
				<a><img src="../image/shanchu.png" onclick="closeConfirmBox()" /></a>
			</div>
			<p class="delP1" id="title"></p>
			<div class="cfD" style="margin-top: 30px" id="currentContentView">
			  <textarea style="width: 480px;height:80px;padding: 10px;resize:none" disabled="disabled" id="currentContent"/></textarea>
			</div>
			<div class="cfD" style="margin-top: 10px">
			  <textarea style="width: 480px;height:120px;padding: 10px;resize:none" id="updateContent" placeholder="请输入..."/></textarea>
			</div>
			<div class="cfD" style="margin-top: 30px">
				<a class="addA" href="#" onclick="confirmUpdate()"
					style="margin-left: 0px; margin-bottom: 30px;">添加</a> <a
					class="addA" onclick="closeConfirmBox()">取消</a>
			</div>
		</div>
	</div>
    <!-- 弹出框 -->
	<div class="banDel" id="banDel2" >
		<div class="delete" style="width:600px">
			<div class="close">
				<a><img src="../image/shanchu.png" onclick="closeConfirmBox()" /></a>
			</div>
			<p class="delP1">添加拜访进度</p>
			<div class="cfD" style="margin-top: 30px">
			   <label style="margin-left:0px">拜访日期：</label><input class="input3" type="text" id="visitDate" style="width: 400px;"><span id="dd" style="margin-left:135px;margin-top:125px"></span>
			</div>
			<div class="cfD" style="margin-top: 10px">
			  <textarea style="width: 480px;height:120px;padding: 10px;resize:none" id="visitDesc" placeholder="请输入..."/></textarea>
			</div>
			<div class="cfD" style="margin-top: 30px">
				<a class="addA" href="#" onclick="confirmUpdateVisitRecord()"
					style="margin-left: 0px; margin-bottom: 30px;">添加</a> <a
					class="addA" onclick="closeConfirmBox()">取消</a>
			</div>
		</div>
	</div>

</body>
</html>