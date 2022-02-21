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
<script src="${pageContext.request.contextPath}/js/getObjectList.js"></script>
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
	height: 380px;
	overflow: hidden;
}

.xcConfirm .popBox .txtBox p {
	height: 350px;
	margin: 5px;
	line-height: 16px;
	overflow-x: hidden;
	overflow-y: auto;
}

a:hover {
	color: #FF00FF
} /* 鼠标移动到链接上 */
</style>

<script type="text/javascript">
	var today;
	var collectionNum;
	var deliveryNum;
	var sId;
	var host;
	var isPermissionView;

	var isPermissionCreate;

	$(document)
			.ready(
					function() {
						sId = "${sessionId}";
						host = "${pageContext.request.contextPath}";
						checkViewPremission(32);

						if (sId == null || sId == "") {
							parent.location.href = "${pageContext.request.contextPath}/page/login";
						} else {
							getUserPermissionList();
							today = formatDate(new Date()).substring(0, 10);
							$('#dateForStartContract').val(today);
							$('#dateForEndContract').val(today);
							getSaleUserList();
							getCompanyList();
							$("#saleUser").select2({});
							$("#companyId").select2({});
							$("#projectName").select2({});
							initDate();
							collectionNum = 1;
							deliveryNum = 1;
							getUnInputContract();
						}
					});

	function initialPage() {

	}

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
						isPermissionCreate = false;
						for ( var i in data) {
							if (data[i].permissionId == 42) {
								isPermissionCreate = true;
								break;
							}
						}
						if (!isPermissionCreate) {
							window.location.href = "${pageContext.request.contextPath}/page/error";
						} else {
							$('#body').show();
						}
					},
					error : function(XMLHttpRequest, textStatus, errorThrown) {
					}
				});
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

	function getSaleUserList() {
		$.ajax({
			url : "${pageContext.request.contextPath}/userList",
			type : 'GET',
			data : {
				"dpartId" : 2,
				"date" : formatDate(new Date()).substring(0, 10),
				"name" : "",
				"nickName" : "",
				"jobId" : "",
				"isHide" : true
			},
			cache : false,
			async : false,
			success : function(returndata) {
				var str = '<option value="0">请选择...</option>';
				var data2 = eval("(" + returndata + ")").userlist;
				for ( var i in data2) {
					str += '<option value="'+data2[i].UId+'">' + data2[i].name
							+ '</option>';
				}
				$("#saleUser").empty();
				$("#saleUser").append(str);

			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
	}

	function getCompanyList() {
		$.ajax({
			url : "${pageContext.request.contextPath}/companyList",
			type : 'GET',
			data : {
				"companyName" : "",
				"salesId" : 0,
			},
			cache : false,
			async : false,
			success : function(returndata) {
				var str = '<option value="0">请选择...</option>';
				var data2 = eval("(" + returndata + ")").companylist;
				for ( var i in data2) {
					str += '<option value="'+data2[i].companyId+'">'
							+ data2[i].companyName + '</option>';
				}
				$("#companyId").empty();
				$("#companyId").append(str);

			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
	}

	function getUnInputContract() {
		var div = '<div>';
		var str = "";
		var num = 0;
		$
				.ajax({
					url : "${pageContext.request.contextPath}/getTenderListUnInputContract",
					type : 'GET',
					data : {},
					cache : false,
					async : false,
					success : function(returndata) {
						var data = eval("(" + returndata + ")").tenderlist;
						num = data.length;
						for ( var i in data) {
							var projectId = data[i].projectId;
							var companyId = data[i].tenderCompany;
							var salesId = data[i].saleUser;
							str += '<a href="#" onclick="closeWin('
									+ salesId
									+ ',\''
									+ projectId
									+ '\',\''
									+ companyId
									+ '\')" ><span style="width:20%;display:-moz-inline-box; display:inline-block;float:left">'
									+ projectId
									+ '</span><span style="width:38%;display:-moz-inline-box; display:inline-block;overflow:hidden;float:left">'
									+ getProject(projectId)
									+ '</span><span style="width:38%;float:left;margin-left:15px">'
									+ getCompany(companyId)
									+ '</span></a><br/><br/>';
						}
						div += str + "</div>";

					},
					error : function(XMLHttpRequest, textStatus, errorThrown) {
					}
				});
		if (num > 0) {
			window.wxc.xcConfirm(div, {
				title : "有以下中标的合同信息未录入,请点击选择",
				btn : parseInt("0010", 2),
				icon : "0 -96px",
			}, {
				onClose : function() {

				}
			});
		}
	}

	function closeWin(mSalesId, mProjectId, mCompanyId) {
		getSaleUserList();
		$("#saleUser").val(mSalesId);
		getCompanyList();
		$("#companyId").val(mCompanyId);
		getProjectList(mCompanyId);
		$("#projectName").val(mProjectId);
		//这个方法是引用js的
		clsWin();
		$("#saleUser").attr("disabled", "disabled");
		$("#saleUser").css('background-color', '#eee');
		$("#companyId").attr("disabled", "disabled");
		$("#companyId").css('background-color', '#eee');
		$("#projectName").attr("disabled", "disabled");
		$("#projectName").css('background-color', '#eee');
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

	function changeCompany(tCompanyId) {
		var tSalesId = getProjectList(tCompanyId);
		getSaleUserList();
		$("#saleUser").find('option[value="' + tSalesId + '"]').attr(
				"selected", true);
	}

	function getProjectList(tCompanyId) {
		var mSalesId;
		$.ajax({
			url : "${pageContext.request.contextPath}/projectList",
			type : 'GET',
			data : {
				"companyId" : tCompanyId,
				"projectName" : "",
				"salesId" : 0,
				"projectManager" : 0
			},
			cache : false,
			async : false,
			success : function(returndata) {
				var data2 = eval("(" + returndata + ")").projectList;
				var str = '<option value="0">请选择...</option>';
				if (data2.length > 0) {
					mSalesId = data2[0].salesId;
				} else {
					mSalesId = 0;
				}
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
		return mSalesId;
	}

	function addNewCollection() {
		if (collectionNum > 2) {
			alert("最多只能输入3条收款说明");
			return;
		}
		collectionNum++;
		var str = '<div class="bbD" id="mDiv0_'+(collectionNum-1)+'_1" style="height:32px">'
		        + '<label style="float: left;margin-left:132px">合同收款时间：</label>'
				+ '<input class="input3" type="text" id="collectionTime'+ collectionNum +'" style="width: 200px; float: left;"/><span id="dd0_'+collectionNum+'_0"></span>'
				+ '<label style="margin-left: 15px; float: left;">实际收款时间：</label>'
				+ '<input class="input3" type="text" id="actCollectionTime'+ collectionNum +'" style="width: 200px; float: left;"/><span id="dd0_'+collectionNum+'_1"></span>'
				+ '</div>';
		$("#collectionInfo").append(str);

		    str = '<div class="bbD" id="mDiv0_'+(collectionNum-1)+'_2" style="height:32px">'
		        + '<label style="float: left;margin-left:160px">收款说明：</label>'
				+ '<input class="input3" id="collectionDesc'+ collectionNum +'" style="width: 540px; height: 20px; float: left;"/>'
				+ '</div>';
		$("#collectionInfo").append(str);

		var thisNum = collectionNum;

		$('#dd0_' + thisNum + '_0').calendar(
				{
					trigger : '#collectionTime' + thisNum,
					zIndex : 999,
					format : 'yyyy/mm/dd',
					onSelected : function(view, date, data) {
					},
					onClose : function(view, date, data) {
						$('#collectionTime' + thisNum).val(
								formatDate(date).substring(0, 10));
					}
				});

		$('#dd0_' + thisNum + '_1').calendar(
				{
					trigger : '#actCollectionTime' + thisNum,
					zIndex : 999,
					format : 'yyyy/mm/dd',
					onSelected : function(view, date, data) {
					},
					onClose : function(view, date, data) {
						$('#actCollectionTime' + thisNum).val(
								formatDate(date).substring(0, 10));
					}
				});
	}

	function removeCollection() {
		if (collectionNum == 1) {
			alert("至少要输入1条收款说明");
			return;
		}
		$("#mDiv0_" + (collectionNum-1) + "_1").remove();
		$("#mDiv0_" + (collectionNum-1) + "_2").remove();
		collectionNum--;
	}

	function addNewDelivery() {
		if (deliveryNum > 2) {
			alert("最多只能输入3条交货说明");
			return;
		}
		deliveryNum++;
		var str = '<div class="bbD" id="mDiv1_'+(deliveryNum-1)+'_1" style="height:32px">'
				+ '<label style="float: left;margin-left:132px">合同交货时间：</label>'
				+ '<input class="input3" type="text" id="deliveryTime'+ deliveryNum +'" style="width: 200px; float:left;"/><span id="dd1_'+deliveryNum+'_0"></span>'
				+ '<label style="margin-left: 15px; float: left;">实际交货时间：</label>'
				+ '<input class="input3" type="text" id="actDeliveryTime'+ deliveryNum +'" style="width: 200px; float: left;"/><span id="dd1_'+deliveryNum+'_1"></span>'
				+ '</div>';

		$("#deliveryInfo").append(str);

		    str = '<div class="bbD" id="mDiv1_'+(deliveryNum-1)+'_2" style="height:32px">'
				+ '<label style="margin-left: 160px; float: left;">交货说明：</label>'
				+ '<input class="input3" id="deliveryDesc'+ deliveryNum +'" style="width: 540px; height: 20px; float: left;"/>'
				+ '</div>';

		$("#deliveryInfo").append(str);

		var thisNum = deliveryNum;

		$('#dd1_' + thisNum + '_0').calendar(
				{
					trigger : '#deliveryTime' + thisNum,
					zIndex : 999,
					format : 'yyyy/mm/dd',
					onSelected : function(view, date, data) {
					},
					onClose : function(view, date, data) {
						$('#deliveryTime' + thisNum).val(
								formatDate(date).substring(0, 10));
					}
				});
		$('#dd1_' + thisNum + '_1').calendar(
				{
					trigger : '#actDeliveryTime' + thisNum,
					zIndex : 999,
					format : 'yyyy/mm/dd',
					onSelected : function(view, date, data) {
					},
					onClose : function(view, date, data) {
						$('#actDeliveryTime' + thisNum).val(
								formatDate(date).substring(0, 10));
					}
				});
	}

	function removeDelivery() {
		if (deliveryNum == 1) {
			alert("至少要输入1条交货说明");
			return;
		}
		$("#mDiv1_" + (deliveryNum-1) + "_1").remove();
		$("#mDiv1_" + (deliveryNum-1) + "_2").remove();
		deliveryNum--;
		
	}

	function createNewContract() {
		var contractNum = $("#contractNum").val().trim();		
		var companyId = $("#companyId").val();
		var salesId = $("#saleUser").val();
		var projectId = $("#projectName").val();
		var dateForStartContract = $("#dateForStartContract").val().trim();
		var dateForEndContract = $("#dateForEndContract").val().trim();
		var contractAmount = $("#contractAmount").val().trim();
		var taxRate = $("#taxrate").val().trim();
		var serviceDetails = $("#serviceDetails").val().trim();
		
		var arrayPaymentInfo = new Array();
		
		for (var i = 1; i <= collectionNum; i++) {
			var time = $("#collectionTime" + i).val();
			var time2 = $("#actCollectionTime" + i).val();
			var desc = $("#collectionDesc" + i).val().trim();
			time = (time == "") ? "*" : time;
			time2 = (time2 == "") ? "*" : time2;
			desc = (desc == "") ? "*" : desc;
			arrayPaymentInfo.push("1#" + time + "#" + time2 + "#" + desc);
		}
		for (var j = 1; j <= deliveryNum; j++) {
			var time3 = $("#deliveryTime" + j).val();
			var time4 = $("#actDeliveryTime" + j).val();
			var desc2 = $("#deliveryDesc" + j).val().trim();
			time3 = (time3 == "") ? "*" : time3;
			time4 = (time4 == "") ? "*" : time4;
			desc2 = (desc2 == "") ? "*" : desc2;
			arrayPaymentInfo.push("2#" + time3 + "#" + time4 + "#" + desc2);
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
				"paymentInfo" : arrayPaymentInfo
			},
			traditional : true,
			success : function(returndata) {
				var data = returndata.errcode;
				if (data == 0) {
					alert("录入合同成功");
					parent.leftFrame.getContractNum();
					setTimeout(function() {
						location.reload();
					}, 500);
				} else if (data == 3) {
					alert("这份合同已录入，请勿重复录入");
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
				</div>
				<div class="baBody">

					<div class="bbD">
						<label style="margin-left: 42px">合同编号：</label><input type="text"
							class="input3" id="contractNum"
							style="width: 670px; margin-right: 10px;" />
					</div>

					<div class="bbD">
						<label style="margin-left: 42px">客户名称：</label><select
							class="selCss" id="companyId"
							style="margin-right: 10px; width: 290px;"
							onChange="changeCompany(this.options[this.options.selectedIndex].value)"></select>
						<label>销售人员：</label><select class="selCss" id="saleUser"
							style="width: 290px;"></select>

					</div>

					<div class="bbD">
						<label style="margin-left: 42px">项目名称：</label><select
							class="selCss" id="projectName"
							style="margin-right: 10px; width: 680px;"><option
								value="0">请选择...</option></select>
					</div>

					<div class="bbD">
						<label>合同实施日期：</label><input class="input3" type="text"
							id="dateForStartContract" style="width: 100px;"> <span
							id="dd_dateForStartContract"></span> <Strong
							style="margin-left: 15px; margin-right: 10px">至</Strong> <input
							class="input3" type="text" id="dateForEndContract"
							style="width: 100px;"> <span id="dd_dateForEndContract"></span>
						<label>合同金额：&nbsp;&nbsp;&nbsp;￥</label><input type="text"
							class="input3" id="contractAmount"
							style="width: 80px; margin-right: 10px;" /> <label>税率：</label> <input
							type="text" class="input3" id="taxrate"
							style="width: 60px; margin-right: 10px;" />%

					</div>

					<div class="bbD">
						<label style="float: left;">服务内容说明：</label>
						<textarea id="serviceDetails"
							style="width: 670px; resize: none; height: 100px; margin-right: 10px;"
							class="input3"></textarea>
					</div>
					
					<div style="border:1px solid green;margin:20px;margin-left:-40px;width:900px;float: left;"></div>

					<div style="float: left;" id="collectionInfo">
						<div class="bbD" id="mDiv0_0_1" style="height: 32px">
							<label style="float: left; margin-left: 42px">收款说明：</label><label
								style="margin-left: 5px; float: left;">合同收款时间：</label><input
								class="input3" type="text" id="collectionTime1"
								style="width: 200px; float: left;" /><span id="dd0_1_0"></span>
							<label style="margin-left: 15px; float: left;">实际收款时间：</label><input
								class="input3" type="text" id="actCollectionTime1"
								style="width: 200px; float: left;" /><span id="dd0_1_1"></span>

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
                    
                    <div style="border:1px solid green;margin:20px;margin-left:-40px;width:900px;float: left;"></div>

					<div style="float: left;" id="deliveryInfo">
						<div class="bbD" id="mDiv1_0_1" style="height: 32px">
							<label style="float: left; margin-left: 42px">交货说明：</label><label
								style="margin-left: 5px; float: left;">合同交货时间：</label><input
								class="input3" type="text" id="deliveryTime1"
								style="width: 200px; float: left;"> <span id="dd1_1_0"></span>
							<label style="margin-left: 15px; float: left;">实际交货时间：</label><input
								class="input3" type="text" id="actDeliveryTime1"
								style="width: 200px; float: left;"><span id="dd1_1_1"></span>
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

					<div class="cfD" style="margin-bottom: 30px">
						<a class="addA" href="#" onclick="createNewContract()"
							style="margin-left: 130px; margin-top: 30px">提交</a> <a
							class="addA"
							href="${pageContext.request.contextPath}/page/techJobList">关闭</a>
					</div>
				</div>
			</div>
		</div>

	</div>

</body>
</html>