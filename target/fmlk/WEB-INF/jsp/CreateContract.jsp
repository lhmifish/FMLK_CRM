<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="renderer" content="webkit" />
<meta http-equiv="pragma" content="no-cache" />
<meta http-equiv="cache-control" content="no-cache" />
<title>新建合同</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/select4.css?v=1999" />
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/css.css?v=1997" />
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/calendar.css" />
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/xcConfirm.css?v=2099" />
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.2.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/select3.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/validation.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/calendar.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/xcConfirm.js?v=2018"></script>
<script src="${pageContext.request.contextPath}/js/checkPermission.js"></script>
<script src="${pageContext.request.contextPath}/js/changePsd.js"></script>
<script src="${pageContext.request.contextPath}/js/commonUtils.js"></script>
<script src="${pageContext.request.contextPath}/js/getObjectList.js?v=2000"></script>
<style>
.xcConfirm .popBox {
	background-color: #ffffff;
	width: 800px;
	height: 500px;
	border-radius: 5px;
	font-weight: bold;
	color: #535e66;
	top: 180px;
	margin-left: -400px;
}

.xcConfirm .popBox .txtBox {
	margin: 25px 25px;
	height: 390px;
	overflow: hidden;
}

.xcConfirm .popBox .txtBox p {
	height: 350px;
	margin: 5px;
	line-height: 16px;
	overflow-x: hidden;
	overflow-y: auto;
}

.xcConfirm .popBox .txtBox.bigIcon {
	height: 30px;
	width: 30px;
}

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
	var today;
	var sId;
	var host;
	var isPermissionView;
	var isPermissionCreate;
	var isFmlkShare;
	var arrayCollection;
	var arrayDelivery;
	var arrayType;

	$(document).ready(function() {
		sId = "${sessionId}";
		host = "${pageContext.request.contextPath}";
		checkViewPremission(42);
	});

	function initialPage() {
		isFmlkShare = true;
		today = formatDate(new Date()).substring(0, 10);
		$('#dateForStartContract').val(today);
		$('#dateForEndContract').val(today);
		getSalesList(0);
		getCompanyList("", 0, 0, 1,isFmlkShare);
		$("#salesId").select2({});
		$("#companyId").select2({});
		$("#projectId").select2({});
		initDate();
		arrayCollection = new Array();
		arrayDelivery = new Array();
		getUnInputContract(true);
	}

	function initDate() {
		$('#dd_dateForStartContract').calendar(
				{
					trigger : '#dateForStartContract',
					zIndex : 999,
					format : 'yyyy/mm/dd',
					onSelected : function(view, date, data) {
					},
					onClose : function(view, date, data) {
						$('#dateForStartContract').val(
								formatDate(date).substring(0, 10));
					}
				});

		$('#dd_dateForEndContract').calendar(
				{
					trigger : '#dateForEndContract',
					zIndex : 999,
					format : 'yyyy/mm/dd',
					onSelected : function(view, date, data) {
					},
					onClose : function(view, date, data) {
						$('#dateForEndContract').val(
								formatDate(date).substring(0, 10));
					}
				});

		$('#dd0_1_1').calendar({
			trigger : '#time1',
			zIndex : 999,
			customClass:"left:150px",
			format : 'yyyy/mm/dd',
			onSelected : function(view, date, data) {
			},
			onClose : function(view, date, data) {
				$('#time1').val(formatDate(date).substring(0, 10));
			}
		});
	}

    // 未录入合同的标书列表
	function getUnInputContract(isFirstOpen) {
		//alert("222222");
    	var div = '<div>';
		var str = '<div><span style="width:20%;float:left;line-height:50px">项目编号</span><span style="width:40%;float:left;line-height:50px">项目名称</span><span style="width:30%;float:left;line-height:50px">招标公司</span><span style="width:10%;float:left;line-height:50px">投标状态</span></div>';
		var num = 0;
		$
				.ajax({
					url : "${pageContext.request.contextPath}/getTenderListUnInputContract",
					type : 'GET',
					data : {},
					cache : false,
					async : false,
					success : function(returndata) {
						var code = eval("(" + returndata + ")").errcode;
						if(code==0){
							var data = eval("(" + returndata + ")").tenderlist;
							num = data.length;
							for ( var i in data) {
								var projectId = data[i].projectId;
								var companyId = data[i].tenderCompany;
								var salesId = data[i].saleUser;
								var currentIsFmlkShare = data[i].isFmlkShare;
								var tenderResult = data[i].tenderResult
								if(tenderResult==1){
									tenderResult = "已中标";
								}else{
									tenderResult = "投标未中";
								}
								str += '<a href="#" onclick="closeWin('
										+ salesId
										+ ',\''
										+ projectId
										+ '\',\''
										+ companyId
										+ '\','+ currentIsFmlkShare +')" ><span style="width:20%;display:-moz-inline-box; display:inline-block;float:left;line-height:30px">'
										+ projectId
										+ '</span><span style="width:40%;display:-moz-inline-box; display:inline-block;white-space: nowrap;overflow:hidden;float:left;line-height:30px">'
										+ getProject(projectId)
										+ '</span><span style="width:30%;float:left;line-height:30px;white-space: nowrap;overflow:hidden;">'
										+ getCompany(companyId)
										+ '</span><span style="width:10%;float:left;line-height:30px">'+tenderResult+'</a><br/><br/>';
							}
							div += str + "</div>";
						}
					},
					error : function(XMLHttpRequest, textStatus, errorThrown) {
					}
				});
		if (num > 0) {
			$("#winOpenDiv").show();
			window.wxc.xcConfirm(div, {
				title : "有以下合同信息未录入,请点击选择",
				btn : parseInt("0010", 2),
				icon : "0 -96px",
			}, {
				onClose : function() {

				}
			});
		}else{
			$("#winOpenDiv").hide();
		}
	}

	function closeWin(mSalesId, mProjectId, mCompanyId,currentIsFmlkShare) {
		isFmlkShare = currentIsFmlkShare;
		$("input[name='field03'][value='2']").prop("checked",isFmlkShare);
		$("input[name='field03'][value='1']").prop("checked",!isFmlkShare);
		getCompanyList("", 0, mCompanyId, 1,isFmlkShare);
		getSalesList(mSalesId);
		getProjectList(mCompanyId,mProjectId,isFmlkShare);
		$("#salesId").attr("disabled", "disabled");
		$("#salesId").css('background-color', '#eee');
		$("#companyId").attr("disabled", "disabled");
		$("#companyId").css('background-color', '#eee');
		$("#projectId").attr("disabled", "disabled");
		$("#projectId").css('background-color', '#eee');
		//这个方法是引用js的
		clsWin();
	}

	function getCompany(mCompanyId) {
		var companyName;
		$
				.ajax({
					url : "${pageContext.request.contextPath}/getCompanyByCompanyId",
					type : 'GET',
					data : {
						"companyId" : mCompanyId
					},
					cache : false,
					async : false,
					success : function(returndata) {
						companyName = eval("(" + returndata + ")").company[0].companyName;
					},
					error : function(XMLHttpRequest, textStatus, errorThrown) {
					}
				});
		return companyName;
	}

	function getProject(mProjectId) {
		var projectName;
		$
				.ajax({
					url : "${pageContext.request.contextPath}/getProjectByProjectId",
					type : 'GET',
					data : {
						"projectId" : mProjectId
					},
					cache : false,
					async : false,
					success : function(returndata) {
						projectName = eval("(" + returndata + ")").project[0].projectName;
					},
					error : function(XMLHttpRequest, textStatus, errorThrown) {
					}
				});
		return projectName;
	}

	function createNewContract() {
		var contractNum = $("#contractNum").val().trim();
		var companyId = $("#companyId").val();
		var salesId = $("#salesId").val();
		var projectId = $("#projectId").val();
		var dateForStartContract = $("#dateForStartContract").val().trim();
		var dateForEndContract = $("#dateForEndContract").val().trim();
		var contractAmount = $("#contractAmount").val().trim();
		var taxRate = $("#taxrate").val().trim();
		var serviceDetails = $("#serviceDetails").val().trim();
		if (contractNum == "") {
			alert("合同编号不能为空");
			return;
		}
        if (companyId == 0 || companyId == null) {
			alert("请选择客户名称");
			return;
		}

		if (salesId == 0 || salesId == null) {
			alert("请选择销售人员");
			return;
		}
		if (projectId == 0 || projectId == null) {
			alert("请选择项目名称");
			return;
		}
		var d1 = new Date(dateForStartContract);
		var d2 = new Date(dateForEndContract);
		if (d1 >= d2) {
			alert("错误：合同实施开始日期不能晚于或等于结束日期");
			return;
		}

		var r = /^(?!(0[0-9]{0,}$))[0-9]{1,}[.]{0,}[0-9]{0,}$/;

		if (contractAmount == "") {
			alert("合同金额不能为空");
			return;
		}
		
		if(taxRate != "" && !r.test(taxRate)){
			alert("税率有误，请重新输入");
			return;
		}
		
		if (serviceDetails == "") {
			alert("服务内容不能为空");
			return;
		}
		var arrayPaymentInfo = new Array();
		if(arrayCollection.length == 0){
			alert("请输入至少1条收款/付款详情");
			return;
		}
		if(arrayDelivery.length == 0){
			alert("请输入至少1条进货/出货详情");
			return;
		}
		arrayPaymentInfo = arrayCollection.concat(arrayDelivery);
		$.ajax({
			url : "${pageContext.request.contextPath}/createNewContract",
			type : 'POST',
			cache : false,
			dataType : "json",
			data : {
				"contractNum" : contractNum,
				"companyId" : companyId,
				"projectId" : projectId,
				"salesId" : salesId,
				"dateForContract" : dateForStartContract + "-"
						+ dateForEndContract,
				"contractAmount" : contractAmount,
				"taxRate" : taxRate,
				"serviceDetails" : serviceDetails,
				"paymentInfo" : arrayPaymentInfo,
				"isFmlkShare":isFmlkShare
			},
			traditional : true,
			success : function(returndata) {
				var data = returndata.errcode;
				if (data == 0) {
					alert("录入合同成功");
					parent.leftFrame.getUnInputContract();
					setTimeout(function() {
						toContractListPage();
					}, 500);
				} else if (data == 3) {
					alert("该项目合同已录入，请勿重复录入");
				} else {
					alert("项目合同录入提交失败");
				}
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
	}

	function checkContractType(id) {
		isFmlkShare = id==2;
		getCompanyList("", 0, 0, 1,isFmlkShare);
		$("#projectId").empty();
		$("#projectId").append("<option value='0'>请选择...</option>");
	}
	
	function changeCompany(tCompanyId) {
		var salesId = getSalesByCompanyId(tCompanyId).salesId;
		getSalesList(salesId);
		getProjectList(tCompanyId, 0,isFmlkShare);
	}
	
	function getSalesByCompanyId(companyId) {
		var mSales;
		$.ajax({
			url : host + "/getCompanyByCompanyId",
			type : 'GET',
			data : {
				"companyId" : companyId
			},
			cache : false,
			async : false,
			success : function(returndata) {
				mSales = eval("(" + returndata + ")").company[0];
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
		return mSales;
	}
	
	function addNewCollection(){
		document.getElementById("delTitle").innerHTML="添加收款/付款明细";
		if(arrayCollection.length==5){
			alert("最多只能添加5条收款/付款明细");
			return;
		}else{
			arrayType = 0;
			$("#time1").val("");
			$("#desc").val("");
			$("#banDel").show();
		}
	}
	
	function addNewDelivery(){
		document.getElementById("delTitle").innerHTML="添加进货/出货明细";
		if(arrayDelivery.length==5){
        	alert("最多只能添加5条进货/出货明细");
			return;
		}else{
			arrayType = 1;
			$("#time1").val("");
			$("#desc").val("");
			$("#banDel").show();
		}
	}
	
	function confirmAdd(){
		var time = $("#time1").val().trim();
		var desc = $("#desc").val().trim();
		if(time == ""){
			alert("时间节点不能为空");
			return;
		}
		if(desc == ""){
			alert("说明内容不能为空");
			return;
		}
		if(arrayType==0){
			if(arrayCollection.length>0){
				for(var i in arrayCollection){
					if(arrayCollection[i].split("#")[1]==time && arrayCollection[i].split("#")[2]==desc){
						alert("收款/付款明细不能重复添加");
						return;
					}
				}
			}
			arrayCollection.push("1#" + time + "#" + desc +"#0");
		}else{
            if(arrayDelivery.length>0){
            	for(var i in arrayDelivery){
					if(arrayDelivery[i].split("#")[1]==time && arrayDelivery[i].split("#")[2]==desc){
						alert("进货/出货明细不能重复添加");
						return;
					}
				}
			}
			arrayDelivery.push("2#" + time + "#" + desc +"#0");
		}
		updateArrayList(arrayType==0?1:2);
		$("#banDel").hide();
	}
	
	function updateArrayList(type){
		var str = "";
		var spanId = "";
		if(type==1){
			$("#collectionDiv").empty();
			mArray = arrayCollection;
			spanId = "collection";
		}else{
			$("#deliveryDiv").empty();
			mArray = arrayDelivery;
			spanId = "delivery";
		}
		if(mArray.length>0){
			for(var i in mArray){
				var title = "时间："+mArray[i].split("#")[1] + "\n" + "说明：" + mArray[i].split("#")[2];
				str += '<span id="'+spanId+i+'"><span style="background-color:#eee;width:50px;height:30px;margin-top:0px;line-height:25px;padding:2px 0" title="'+title+'">'
				    +'<label>'+mArray[i].split("#")[1]+'</label></span><span><img style="height: 25px" src="${pageContext.request.contextPath}/image/minus2018.png" onClick="removeArray('+i+','+type+')"></span></span>';
			}
		}
		if(type==1){
			$("#collectionDiv").append(str);
		}else{
			$("#deliveryDiv").append(str);
		}
	}
	
	function removeArray(index,type){
		if(type==1){
			arrayCollection.splice(index,1);
		}else{
			arrayDelivery.splice(index,1);
		}
		updateArrayList(type);
	}
</script>

</head>
<body id="body" style="display: none">
	<div id="pageAll">
		<div class="pageTop">
			<div class="page">
				<img src="../image/coin02.png" /><span><a href="#">首页</a>&nbsp;-&nbsp;<a
					href="#">合同管理</a>&nbsp;-</span>&nbsp;新建合同
			</div>
		</div>
		<div class="page">
			<div class="banneradd bor">
				<div class="baTopNo">
					<span>合同基本信息</span> 
					<input type="radio" name="field03" value="2"
						checked="checked" onclick="checkContractType(2)"
						style="margin-left: 50px; margin-right: 5px;" /> <label>共享陪护</label>
					<input type="radio" name="field03" value="1"
						onclick="checkContractType(1)"
						style="margin-left: 50px; margin-right: 5px;" /> <label>信息</label>				
					<a style="margin-left:200px;" onclick="getUnInputContract(false)" id="winOpenDiv">
					<img src="../image/warning.png"></img>
					<label>未录入的所有合同</label>
					</a>
				</div>
				<div class="baBody">

					<div class="bbD">
						<span class="need">*</span><label style="margin-left:0">合同编号：</label><input type="text"
							class="input3" id="contractNum" placeHolder="请按照合同上的编号填写"
							style="width: 690px; margin-right: 10px;" />
					</div>

					<div class="bbD">
						<span class="need">*</span><label style="margin-left:0">客户名称：</label><select
							class="selCss" id="companyId"
							style="margin-right: 10px; width: 290px;"
							onChange="changeCompany(this.options[this.options.selectedIndex].value)"></select>
						<span style="margin-left:20px"><span class="need">*</span><label style="margin-left:0">销售人员：</label><select class="selCss" id="salesId"
							style="width: 290px;"></select></span>

					</div>

					<div class="bbD">
						<span class="need">*</span><label style="margin-left:0">项目名称：</label><select
							class="selCss" id="projectId"
							style="margin-right: 10px; width: 700px;"><option
								value="0">请选择...</option></select>
					</div>

					<div class="bbD">
						<span class="need">*</span><label style="margin-left:0">合同实施日期：</label><input class="input3" type="text"
							id="dateForStartContract" style="width: 90px;"> <span
							id="dd_dateForStartContract"></span> <label
							style="margin-left: 15px; margin-right: 10px">至</label> <input
							class="input3" type="text" id="dateForEndContract"
							style="width: 90px;"> <span id="dd_dateForEndContract"></span>
						
						<span style="margin-left:15px"><span class="need">*</span><label style="margin-left:0">合同金额：</label><input type="text"
							class="input3" id="contractAmount"
							style="width: 135px;" /></span> 
						
						<span style="margin-left:15px"><label style="margin-left:0px">税率：</label><input
							type="text" class="input3" id="taxrate"
							style="width: 70px;" />%</span>
					</div>

					<div class="bbD">
						<span class="need" style="float: left;">*</span><label style="margin-left:0;float: left;">服务内容说明：</label>
						<textarea id="serviceDetails"
							style="width: 660px; resize: none; height: 100px; margin-right: 10px;"
							class="input3"></textarea>
					</div>

					<div style="margin-top:15px;width:870px" id="collectionInfo">
						<div class="bbD" style="height: 32px">
							<span class="need" style="float: left;">*</span><label style="float: left; margin-left: 0px">收款/付款详情：</label>
							<img style="height: 25px;margin-right:21px" id="addBtn"
							src="${pageContext.request.contextPath}/image/plus2019.png"
							onclick="addNewCollection()" />
						</div>
						<div class="bbD"  id="collectionDiv" style="padding-left:136px;margin-top:0px">
						</div>
					</div>

					<div style="margin-top:20px;width:870px" id="deliveryInfo">
						<div class="bbD" style="height: 32px">
							<span class="need" style="float: left;">*</span><label style="float: left; margin-left: 0px">进货/出货详情：</label>
							<img style="height: 25px;margin-right:21px" id="addBtn"
							src="${pageContext.request.contextPath}/image/plus2019.png"
							onclick="addNewDelivery()" />
						</div>
						<div class="bbD"  id="deliveryDiv" style="padding-left:136px;margin-top:0px">						
						</div>
					</div>
                    
					<div class="cfD" style="margin-top: 30px;margin-bottom:30px">
						<a class="addA" href="#" onclick="createNewContract()">提交</a> <a
							class="addA" href="#" onclick="toIndexPage()">关闭</a>
					</div>
				</div>
			</div>
		</div>
	</div>
    <!-- 弹出框 -->
	<div class="banDel" id="banDel" >
		<div class="delete">
			<div class="close">
				<a><img src="${pageContext.request.contextPath}/image/shanchu.png" onclick="closeConfirmBox()" /></a>
			</div>
			<p class="delP1" id="delTitle"></p>
			<div class="cfD" style="margin-top: 30px">
			   <span class="need">*</span><label style="font-size: 16px;margin-left:0px">时间节点：</label> <input type="text" style="width: 250px;height:26px; border-bottom: 1px dashed #78639F; border-left: none; border-right: none; border-top: none; padding-left: 10px;" id="time1" />
			   <span id="dd0_1_1" style="margin-left:150px;margin-top:130px"></span>
			</div>
			<div class="cfD" style="margin-top: 30px">
			   <span class="need">*</span><label style="font-size: 16px;margin-left:0px">内容说明：</label> <input type="text" style="width: 250px;height:26px; border-bottom: 1px dashed #78639F; border-left: none; border-right: none; border-top: none; padding-left: 10px;" id="desc" />
			</div>
			<div class="cfD" style="margin-top: 30px">
				<a class="addA" href="#" onclick="confirmAdd()"
					style="margin-left: 0px; margin-bottom: 30px;">添加</a> <a
					class="addA" onclick="closeConfirmBox()">取消</a>
			</div>
		</div>
	</div>
</body>
</html>