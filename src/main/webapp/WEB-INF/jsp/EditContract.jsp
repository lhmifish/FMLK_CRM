<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="renderer" content="webkit" />
<meta http-equiv="pragma" content="no-cache" />
<meta http-equiv="cache-control" content="no-cache" />
<title>编辑合同信息</title>
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/css.css?v=2000" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/select4.css?v=1999" />
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/calendar.css" />
<link href='http://fonts.googleapis.com/css?family=Roboto'
	rel='stylesheet' type='text/css'>
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/bootstrap-switch.css" />
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/bootstrap.min.css" />
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/highlight.css" />
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/main2.css" />
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.2.1.min.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/bootstrap-switch.js"></script>
<script src="${pageContext.request.contextPath}/js/select3.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/validation.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/calendar.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/bootstrap.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/highlight.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/main.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery.jqprint-0.3.js"></script>
<script src="http://www.jq22.com/jquery/jquery-migrate-1.2.1.min.js"></script>
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
	var id;//合同id
	var sId;//sessionId
	var host;
	var salesId;
	var isPermissionEdit;
	var collectionArr;//收款
	var deliveryArr;//交货
	var collectionNum;
	var deliveryNum;
	var isUpload;

	$(document).ready(function() {
		id = "${mId}";//合同id
		sId = "${sessionId}";
		host = "${pageContext.request.contextPath}";
		checkEditPremission(43, 0);
	});

	function initialPage() {
		initDate();
		getContractInfo(id);

		matchEdit("合同");
		$("#companyId").select2({});
		$("#salesId").select2({});
		$("#projectId").select2({});
		if (isPermissionEdit) {
			$("#divEdit").show();
		}
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
		$('#dd0_1_0').calendar({
			trigger : '#collectionTime1',
			zIndex : 999,
			format : 'yyyy/mm/dd',
			onSelected : function(view, date, data) {
			},
			onClose : function(view, date, data) {
				$('#collectionTime1').val(formatDate(date).substring(0, 10));
			}
		});

		$('#dd0_1_1').calendar(
				{
					trigger : '#actCollectionTime1',
					zIndex : 999,
					format : 'yyyy/mm/dd',
					onSelected : function(view, date, data) {
					},
					onClose : function(view, date, data) {
						$('#actCollectionTime1').val(
								formatDate(date).substring(0, 10));
					}
				});

		$('#dd1_1_0').calendar({
			trigger : '#deliveryTime1',
			zIndex : 999,
			format : 'yyyy/mm/dd',
			onSelected : function(view, date, data) {
			},
			onClose : function(view, date, data) {
				$('#deliveryTime1').val(formatDate(date).substring(0, 10));
			}
		});
		$('#dd1_1_1').calendar({
			trigger : '#actDeliveryTime1',
			zIndex : 999,
			format : 'yyyy/mm/dd',
			onSelected : function(view, date, data) {
			},
			onClose : function(view, date, data) {
				$('#actDeliveryTime1').val(formatDate(date).substring(0, 10));
			}
		});
	}

	function getContractInfo(tid) {
		$.ajax({
			url : host + "/getContractById",
			type : 'GET',
			cache : false,
			async : false,
			data : {
				"id" : tid
			},
			success : function(returndata) {
				var data = eval("(" + returndata + ")").contract;
				$("#contractNum").val(data[0].contractNum);
				getCompanyList("", 0, data[0].companyId, 1);
				getProjectList(data[0].companyId, data[0].projectId);
				getSalesList(data[0].saleUser);
				$('#dateForStartContract').val(
						data[0].dateForContract.split("-")[0]);
				$('#dateForEndContract').val(
						data[0].dateForContract.split("-")[1]);
				salesId = data[0].saleUser;

				$("#contractAmount").val(data[0].contractAmount);
				$("#taxrate").val(data[0].taxRate);
				$("#serviceDetails").val(data[0].serviceDetails);
				
				getContractPaymentInfo(data[0].contractNum);
				isUpload = data[0].isUploadContract;
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
	}

	function getContractPaymentInfo(tContractNum) {
		$
				.ajax({
					url : host + "/getContractPaymentInfoList",
					type : 'GET',
					cache : false,
					async : false,
					data : {
						"contractNum" : tContractNum
					},
					success : function(returndata) {
						var data = eval("(" + returndata + ")").paymentInfolist;
						collectionArr = new Array();//收款
						deliveryArr = new Array();//交货

						if (data.length > 0) {
							for (var i = 0; i < data.length; i++) {
								var type = data[i].split("#")[3];
								if (type == 1) {
									//收款
									collectionArr.push(data[i]);
								} else {
									// 交货
									deliveryArr.push(data[i]);
								}
							}
						}
						collectionNum = (collectionArr.length==0)?1:collectionArr.length;
						deliveryNum = (deliveryArr.length==0)?1:deliveryArr.length;
						
						var isFinished;
						if (collectionArr.length >= 1) {
							var mct = collectionArr[0].split("#")[0]=="*"?"":collectionArr[0].split("#")[0];
							var amct = collectionArr[0].split("#")[1]=="*"?"":collectionArr[0].split("#")[1];
							var cd = collectionArr[0].split("#")[2]=="*"?"":collectionArr[0].split("#")[2];
							
							$("#collectionTime1").val(mct);
							$("#actCollectionTime1").val(amct);
							$("#collectionDesc1").val(cd);
							
							isFinished = collectionArr[0].split("#")[4] == 1 ? true
									: false;
							$('#switch0_1').bootstrapSwitch('state',
									isFinished, false);

							for (var j = 2; j <= collectionArr.length; j++) {
								var str = '<div class="bbD" id="mDiv0_'
										+ (j - 1)
										+ '_1" style="height: 32px">'
										+ '<label style="margin-left: 132px; float: left;">合同收款时间：</label>'
										+ '<input class="input3" type="text" id="collectionTime'+j+'" style="width: 150px; float: left;" /><span id="dd0_'+j+'_0"></span>'
										+ '<label style="margin-left: 15px; float: left;">实际收款时间：</label>'
										+ '<input class="input3" type="text" id="actCollectionTime'+j+'" style="width: 150px; float: left;" /><span id="dd0_'+j+'_1"></span>'
										+ '<label style="margin-left: 15px"></label><input id="switch0_'+j+'" type="checkbox" data-size="mini"  data-on-text="已收款" data-off-text="未收款" data-label-text="收款状态" />'
										+ '</div>';
								$("#collectionInfo").append(str);
								str = '<div class="bbD" id="mDiv0_'
										+ (j - 1)
										+ '_2" style="height: 32px">'
										+ '<label style="margin-left: 160px; float: left;">收款说明：</label>'
										+ '<input class="input3" id="collectionDesc'+j+'" style="width: 500px; height: 20px; float: left;"></input>'
										+ '</div>';
								$("#collectionInfo").append(str);
								
								
								mct = collectionArr[j - 1].split("#")[0]=="*"?"":collectionArr[j - 1].split("#")[0];
								amct = collectionArr[j - 1].split("#")[1]=="*"?"":collectionArr[j - 1].split("#")[1];
								cd = collectionArr[j - 1].split("#")[2]=="*"?"":collectionArr[j - 1].split("#")[2];
								

								$("#collectionTime" + j).val(mct);
								$("#actCollectionTime" + j).val(amct);
								$("#collectionDesc" + j).val(cd);
								isFinished = collectionArr[j-1].split("#")[4] == 1 ? true
										: false;
								$('#switch0_'+j).bootstrapSwitch('state',
										isFinished, false);
								
								$('#dd0_' + j + '_0').calendar(
										{
											trigger : '#collectionTime' + j,
											zIndex : 999,
											format : 'yyyy/mm/dd',
											onSelected : function(view, date, data) {
											},
											onClose : function(view, date, data) {
												$('#collectionTime' + j).val(
														formatDate(date).substring(0, 10));
											}
										});

								$('#dd0_' + j + '_1').calendar(
										{
											trigger : '#actCollectionTime' + j,
											zIndex : 999,
											format : 'yyyy/mm/dd',
											onSelected : function(view, date, data) {
											},
											onClose : function(view, date, data) {
												$('#actCollectionTime' + j).val(
														formatDate(date).substring(0, 10));
											}
										});
							}
						}
						if (deliveryArr.length >= 1) {
							
							var mdt = deliveryArr[0].split("#")[0]=="*"?"":deliveryArr[0].split("#")[0];
							var amdt = deliveryArr[0].split("#")[1]=="*"?"":deliveryArr[0].split("#")[1];
							var dd = deliveryArr[0].split("#")[2]=="*"?"":deliveryArr[0].split("#")[2];
							
							$("#deliveryTime1").val(mdt);
							$("#actDeliveryTime1").val(amdt);
							$("#deliveryDesc1").val(dd);							
							isFinished = deliveryArr[0].split("#")[4] == 1 ? true
									: false;
							$('#switch1_1').bootstrapSwitch('state',
									isFinished, false);
							
							for (var j = 2; j <= deliveryArr.length; j++) {
								var str = '<div class="bbD" id="mDiv1_'
									+ (j - 1)
									+ '_1" style="height: 32px">'
									+ '<label style="margin-left: 132px; float: left;">合同交货时间：</label>'
									+ '<input class="input3" type="text" id="deliveryTime'+j+'" style="width: 150px; float: left;" /><span id="dd1_'+j+'_0"></span>'
									+ '<label style="margin-left: 15px; float: left;">实际交货时间：</label>'
									+ '<input class="input3" type="text" id="actDeliveryTime'+j+'" style="width: 150px; float: left;" /><span id="dd1_'+j+'_1"></span>'
									+ '<label style="margin-left: 15px"></label><input id="switch1_'+j+'" type="checkbox" data-size="mini"  data-on-text="已交货" data-off-text="未交货" data-label-text="交货状态" />'
									+ '</div>';
							$("#deliveryInfo").append(str);
							str = '<div class="bbD" id="mDiv1_'
									+ (j - 1)
									+ '_2" style="height: 32px">'
									+ '<label style="margin-left: 160px; float: left;">交货说明：</label>'
									+ '<input class="input3" id="deliveryDesc'+j+'" style="width: 500px; height: 20px; float: left;"></input>'
									+ '</div>';
							$("#deliveryInfo").append(str);
							
							mdt = deliveryArr[j - 1].split("#")[0]=="*"?"":deliveryArr[j - 1].split("#")[0];
							amdt = deliveryArr[j - 1].split("#")[1]=="*"?"":deliveryArr[j - 1].split("#")[1];
							dd = deliveryArr[j - 1].split("#")[2]=="*"?"":deliveryArr[j - 1].split("#")[2];
							$("#deliveryTime" + j).val(mdt);
							$("#actDeliveryTime" + j).val(amdt);
							$("#deliveryDesc" + j).val(dd);
							isFinished = deliveryArr[j-1].split("#")[4] == 1 ? true
									: false;
							$('#switch1_'+j).bootstrapSwitch('state',
									isFinished, false);
							}
							
							$('#dd1_' + j + '_0').calendar(
									{
										trigger : '#deliveryTime' + j,
										zIndex : 999,
										format : 'yyyy/mm/dd',
										onSelected : function(view, date, data) {
										},
										onClose : function(view, date, data) {
											$('#deliveryTime' + j).val(
													formatDate(date).substring(0, 10));
										}
									});

							$('#dd1_' + j + '_1').calendar(
									{
										trigger : '#actDeliveryTime' + j,
										zIndex : 999,
										format : 'yyyy/mm/dd',
										onSelected : function(view, date, data) {
										},
										onClose : function(view, date, data) {
											$('#actDeliveryTime' + j).val(
													formatDate(date).substring(0, 10));
										}
									});
						}

					},
					error : function(XMLHttpRequest, textStatus, errorThrown) {
					}
				});

	}

	function changeProject() {
		// js方法结束后调用,此处留空
	}

	function checkTenderIntent(j) {
		tenderIntent = j;
	}

	function addNewCollection() {
		if (collectionNum > 2) {
			alert("最多只能输入3条收款说明");
			return;
		}
		collectionNum++;
		var str = '<div class="bbD" id="mDiv0_'
				+ (collectionNum - 1)
				+ '_1" style="height: 32px">'
				+ '<label style="margin-left: 132px; float: left;">合同收款时间：</label>'
				+ '<input class="input3" type="text" id="collectionTime'+collectionNum+'" style="width: 150px; float: left;" /><span id="dd0_'+collectionNum+'_0"></span>'
				+ '<label style="margin-left: 15px; float: left;">实际收款时间：</label>'
				+ '<input class="input3" type="text" id="actCollectionTime'+collectionNum+'" style="width: 150px; float: left;" /><span id="dd0_'+collectionNum+'_1"></span>'
				+ '<label style="margin-left: 15px"></label>'
				+ '<input id="switch0_'+collectionNum+'" type="checkbox" data-size="mini"  data-on-text="已收款" data-off-text="未收款" data-label-text="收款状态"/>'
				+ '</div>';
		$("#collectionInfo").append(str);
		$("#switch0_"+collectionNum).bootstrapSwitch('state',false, false);
		
		str = '<div class="bbD" id="mDiv0_'
				+ (collectionNum - 1)
				+ '_2" style="height: 32px">'
				+ '<label style="margin-left: 160px; float: left;">收款说明：</label>'
				+ '<input class="input3" id="collectionDesc'+collectionNum+'" style="width: 540px; height: 20px; float: left;"></input>'
				+ '</div>';
		$("#collectionInfo").append(str);
		
		$('#dd0_' + collectionNum + '_0').calendar(
				{
					trigger : '#collectionTime' + collectionNum,
					zIndex : 999,
					format : 'yyyy/mm/dd',
					onSelected : function(view, date, data) {
					},
					onClose : function(view, date, data) {
						$('#collectionTime' + collectionNum).val(
								formatDate(date).substring(0, 10));
					}
				});

		$('#dd0_' + collectionNum + '_1').calendar(
				{
					trigger : '#actCollectionTime' + collectionNum,
					zIndex : 999,
					format : 'yyyy/mm/dd',
					onSelected : function(view, date, data) {
					},
					onClose : function(view, date, data) {
						$('#actCollectionTime' + collectionNum).val(
								formatDate(date).substring(0, 10));
					}
				});
	}
	
	function addNewDelivery(){
		if (deliveryNum > 2) {
			alert("最多只能输入3条交货说明");
			return;
		}
		deliveryNum++;
		var str = '<div class="bbD" id="mDiv1_'
				+ (deliveryNum - 1)
				+ '_1" style="height: 32px">'
				+ '<label style="margin-left: 132px; float: left;">合同交货时间：</label>'
				+ '<input class="input3" type="text" id="deliveryTime'+deliveryNum+'" style="width: 150px; float: left;" /><span id="dd1_'+deliveryNum+'_0"></span>'
				+ '<label style="margin-left: 15px; float: left;">实际交货时间：</label>'
				+ '<input class="input3" type="text" id="actDeliveryTime'+deliveryNum+'" style="width: 150px; float: left;" /><span id="dd1_'+deliveryNum+'_1"></span>'
				+ '<label style="margin-left: 15px"></label>'
				+ '<input id="switch1_'+deliveryNum+'" type="checkbox" data-size="mini"  data-on-text="已交货" data-off-text="未交货" data-label-text="交货状态"/>'
				+ '</div>';
		$("#deliveryInfo").append(str);
		$("#switch1_"+deliveryNum).bootstrapSwitch('state',false, false);
		
		str = '<div class="bbD" id="mDiv1_'
				+ (deliveryNum - 1)
				+ '_2" style="height: 32px">'
				+ '<label style="margin-left: 160px; float: left;">交货说明：</label>'
				+ '<input class="input3" id="deliveryDesc'+deliveryNum+'" style="width: 540px; height: 20px; float: left;"></input>'
				+ '</div>';
		$("#deliveryInfo").append(str);
		
		$('#dd1_' + deliveryNum + '_0').calendar(
				{
					trigger : '#deliveryTime' + deliveryNum,
					zIndex : 999,
					format : 'yyyy/mm/dd',
					onSelected : function(view, date, data) {
					},
					onClose : function(view, date, data) {
						$('#deliveryTime' + deliveryNum).val(
								formatDate(date).substring(0, 10));
					}
				});

		$('#dd1_' + deliveryNum + '_1').calendar(
				{
					trigger : '#actDeliveryTime' + deliveryNum,
					zIndex : 999,
					format : 'yyyy/mm/dd',
					onSelected : function(view, date, data) {
					},
					onClose : function(view, date, data) {
						$('#actDeliveryTime' + deliveryNum).val(
								formatDate(date).substring(0, 10));
					}
				});
	}
	
	function removeCollection(){
		if (collectionNum == 1) {
			alert("至少要输入1条收款说明");
			return;
		}
		$("#mDiv0_" + (collectionNum-1) + "_1").remove();
		$("#mDiv0_" + (collectionNum-1) + "_2").remove();
		collectionNum--;
	}
	
	function removeDelivery(){
		if (deliveryNum == 1) {
			alert("至少要输入1条交货说明");
			return;
		}
		$("#mDiv1_" + (deliveryNum-1) + "_1").remove();
		$("#mDiv1_" + (deliveryNum-1) + "_2").remove();
		deliveryNum--;
	}
	
 	function editContract(){
		var contractNum = $("#contractNum").val().trim();		
		var companyId = $("#companyId").val();
		var salesId = $("#salesId").val();
		var projectId = $("#projectId").val();
		var dateForStartContract = $("#dateForStartContract").val().trim();
		var dateForEndContract = $("#dateForEndContract").val().trim();
		var contractAmount = $("#contractAmount").val().trim();
		var taxRate = $("#taxrate").val().trim();
		var serviceDetails = $("#serviceDetails").val().trim();		
        var arrayPaymentInfo = new Array();       
        var isFinished;
		for (var i = 1; i <= collectionNum; i++) {
			var time = $("#collectionTime" + i).val();
			var time2 = $("#actCollectionTime" + i).val();
			var desc = $("#collectionDesc" + i).val().trim();
			var isFinished = 0;
			time = (time == "") ? "*" : time;
			time2 = (time2 == "") ? "*" : time2;
			desc = (desc == "") ? "*" : desc;
			isFinished = $("#switch0_"+i).bootstrapSwitch('state')==true?1:0;
			arrayPaymentInfo.push("1#" + time + "#" + time2 + "#" + desc + "#" + isFinished);
		}
		for (var j = 1; j <= deliveryNum; j++) {
			var time3 = $("#deliveryTime" + j).val();
			var time4 = $("#actDeliveryTime" + j).val();
			var desc2 = $("#deliveryDesc" + j).val().trim();
			time3 = (time3 == "") ? "*" : time3;
			time4 = (time4 == "") ? "*" : time4;
			desc2 = (desc2 == "") ? "*" : desc2;
			isFinished = $("#switch1_"+i).bootstrapSwitch('state')==true?1:0;
			arrayPaymentInfo.push("2#" + time3 + "#" + time4 + "#" + desc2 + "#" + isFinished);
		} 
		
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
			alert("错误：合同实施开始日期不能晚于或等于结束日期，请修改");
			return;
		}

		var r = /^(?!(0[0-9]{0,}$))[0-9]{1,}[.]{0,}[0-9]{0,}$/;

		if (contractAmount == "") {
			alert("合同金额不能为空");
			return;
		} else if (!r.test(contractAmount)) {
			alert("合同金额有误，请重新输入");
			return;
		}

		if (serviceDetails == "") {
			alert("服务内容不能为空");
			return;
		}
	//	alert(arrayPaymentInfo.length);
		
		$.ajax({
			url : "${pageContext.request.contextPath}/editContract",
			type : 'POST',
			cache : false,
			dataType : "json",
			data : {
				"contractNum" : contractNum,
				"companyId" : companyId,
				"projectId" : projectId,
				"saleUser" : salesId,
				"dateForContract" : dateForStartContract + "-"
						+ dateForEndContract,
				"contractAmount" : contractAmount,
				"taxRate" : taxRate,
				"serviceDetails" : serviceDetails,
				"paymentInfo" : arrayPaymentInfo,
				"id":id,
				"isUploadContract":isUpload
			},
			traditional : true,
			success : function(returndata) {
				var data = returndata.errcode;
				if (data == 0) {
					alert("编辑合同成功");
					//parent.leftFrame.getContractNum();
					setTimeout(function() {
						location.reload();
					}, 500);
				} else {
					alert("录入失败");
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
		<!-- pageTop-->
		<div class="pageTop">
			<div class="page">
				<img src="${pageContext.request.contextPath}/image/coin02.png" /><span><a
					href="#">首页</a>&nbsp;-&nbsp;<a href="#">合同管理</a>&nbsp;-</span>&nbsp;编辑合同信息
			</div>
		</div>
		<!-- end of  pageTop-->

		<div class="page">
			<div class="banneradd bor">
				<div class="baTopNo">
					<span>编辑合同信息</span>
				</div>
				<!-- baBody-->
				<div class="baBody">
					<div class="bbD">
						<label>合同编号：</label><input type="text" class="input3"
							id="contractNum" style="width: 670px; margin-right: 10px;" />
					</div>

					<div class="bbD">
						<label>客户名称：</label><select class="selCss" id="companyId"
							style="margin-right: 10px; width: 285px;"
							onChange="changeCompany(this.options[this.options.selectedIndex].value)"></select>
						<label>销售人员：</label><select class="selCss" id="salesId"
							style="width: 285px;"></select>
					</div>

					<div class="bbD">
						<label>项目名称：</label><select class="selCss" id="projectId"
							style="margin-right: 10px; width: 676px;"><option
								value="0">请选择...</option></select>
					</div>



					<div class="bbD">
						<label style="margin-left: -12px">合同实施日期：</label><input
							class="input3" type="text" id="dateForStartContract"
							style="width: 110px;"> <span id="dd_dateForStartContract"></span>
						<Strong style="margin-left: 15px; margin-right: 10px">至</Strong> <input
							class="input3" type="text" id="dateForEndContract"
							style="width: 110px;"> <span id="dd_dateForEndContract"></span>
						<label style="margin_left: 15px">合同金额：&nbsp;&nbsp;￥</label><input
							type="text" class="input3" id="contractAmount"
							style="width: 100px; margin-right: 5px;" /> <label>税率：</label> <input
							type="text" class="input3" id="taxrate"
							style="width: 80px; margin-right: 5px;" />%
					</div>

					<div class="bbD">
						<label style="float: left; margin-left: -12px">服务内容说明：</label>
						<textarea id="serviceDetails"
							style="width: 670px; resize: none; height: 100px; margin-right: 10px;"
							class="input3"></textarea>
					</div>

                    <div style="border:1px solid green;margin:20px;margin-left:-40px;width:900px"></div>

					<div class="bbD" id="collectionInfo" style="margin-left: -26px">
						<div class="bbD" id="mDiv0_0_1" style="height: 32px">
							<label style="float: left; margin-left: 42px">收款说明：</label><label
								style="margin-left: 5px; float: left;">合同收款时间：</label><input
								class="input3" type="text" id="collectionTime1"
								style="width: 150px; float: left;" /><span id="dd0_1_0"></span>
							<label style="margin-left: 15px; float: left;">实际收款时间：</label><input
								class="input3" type="text" id="actCollectionTime1"
								style="width: 150px; float: left;" /><span id="dd0_1_1"></span>
							<label style="margin-left: 15px"></label> <input id="switch0_1"
								type="checkbox" data-size="mini" data-on-text="已收款"
								data-off-text="未收款" data-label-text="收款状态"/>
						</div>
						<div class="bbD" id="mDiv0_0_2" style="height: 32px">
							<label style="margin-left: 160px; float: left;">收款说明：</label><input
								class="input3" id="collectionDesc1"
								style="width: 500px; height: 20px; float: left;"></input> <img
								style="height: 30px; margin-left: 10px"
								src="${pageContext.request.contextPath}/image/plus2018.png"
								onClick="addNewCollection()"><img style="height: 30px;"
								src="${pageContext.request.contextPath}/image/minus2018.png"
								onClick="removeCollection()">
						</div>
					</div>
                    <div style="border:1px solid green;margin:20px;margin-left:-40px;width:900px"></div>
					<div class="bbD" id="deliveryInfo" style="margin-left: -26px">
						<div class="bbD" id="mDiv1_0_1" style="height: 32px">
							<label style="float: left; margin-left: 42px">交货说明：</label><label
								style="margin-left: 5px; float: left;">合同交货时间：</label><input
								class="input3" type="text" id="deliveryTime1"
								style="width: 150px; float: left;"> <span id="dd1_1_0"></span>
							<label style="margin-left: 15px; float: left;">实际交货时间：</label><input
								class="input3" type="text" id="actDeliveryTime1"
								style="width: 150px; float: left;"><span id="dd1_1_1"></span>
							<label style="margin-left: 15px"></label> <input id="switch1_1"
								type="checkbox" data-size="mini" data-on-text="已交货"
								data-off-text="未交货" data-label-text="交货状态"/>
						</div>
						<div class="bbD" id="mDiv1_0_2" style="height: 32px">
							<label style="margin-left: 160px; float: left;">交货说明：</label> <input
								class="input3" id="deliveryDesc1"
								style="width: 500px; height: 20px; float: left;"></input> <img
								style="height: 30px; margin-left: 10px"
								src="${pageContext.request.contextPath}/image/plus2018.png"
								onClick="addNewDelivery()"><img style="height: 30px;"
								src="${pageContext.request.contextPath}/image/minus2018.png"
								onClick="removeDelivery()">
						</div>
					</div>


					<div class="cfD" style="margin-bottom: 30px; display: none"
						id="divEdit">
						<a class="addA" href="#" onclick="editContract()" id="operation"
							style="margin-left: 120px; margin-top: 20px">编辑</a> <a
							class="addA" href="#" onclick="toContractListPage()">返回</a>
					</div>

				</div>
				<!-- end of  baBody-->
			</div>
			<!-- end of  banneradd bor-->
		</div>
		<!-- end of  page-->
	</div>

</body>
</html>