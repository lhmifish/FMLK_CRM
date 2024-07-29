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
	href="${pageContext.request.contextPath}/css/css.css?v=1997" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/select4.css?v=1999" />
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/calendar.css" />
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/xcConfirm.css?v=2099" />
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
	src="${pageContext.request.contextPath}/js/xcConfirm.js?v=2018"></script>
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
<script src="${pageContext.request.contextPath}/js/getObjectList.js?v=3"></script>

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
	height: 350px;
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
.need {
	color: red;
	margin-right: 5px;
	margin-left: 0px
}

.delete .close {
	opacity: 1;
	height: 30px;
	width: 100%;
	margin-bottom: 40px;
}
</style>

<script type="text/javascript">
	var id;//合同id
	var sId;//sessionId
	var host;
	var salesId;
	var isPermissionEdit;//编辑合同
	var isPermissionDelete;//编辑合同节点
	var isUpload;
	var isFmlkShare;
	var arrayCollection;
	var arrayDelivery;
	var arrayType;//0.collenction 1.Delivery
	var operation;//0新增1编辑
	var editPaymentId;

	$(document).ready(function() {
		id = "${mId}";//合同id
		sId = "${sessionId}";
		host = "${pageContext.request.contextPath}";
		checkEditPremission(43, 44);//43编辑合同44编辑合同节点
	});

	function initialPage() {
		arrayCollection = new Array();
		arrayDelivery = new Array();
		getContractInfo(id);
		initDate();
		matchEdit("合同");
		$("#companyId").select2({});
		$("#salesId").select2({});
		$("#projectId").select2({});
		$('#finishCheck').bootstrapSwitch();
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
			customClass : "left:150px",
			format : 'yyyy/mm/dd',
			onSelected : function(view, date, data) {
			},
			onClose : function(view, date, data) {
				$('#time1').val(formatDate(date).substring(0, 10));
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
				isFmlkShare = data[0].isFmlkShare;
				getCompanyList("", 0, data[0].companyId, 1, isFmlkShare);
				getProjectList(data[0].companyId, data[0].projectId,
						isFmlkShare);
				getSalesList(data[0].saleUser);
				$('#dateForStartContract').val(
						data[0].dateForContract.split("-")[0]);
				$('#dateForEndContract').val(
						data[0].dateForContract.split("-")[1]);
				$("#contractAmount").val(data[0].contractAmount);
				if(data[0].taxRate != -1){
					$("#taxrate").val(data[0].taxRate);
				}
				$("#serviceDetails").val(data[0].serviceDetails);
				salesId = data[0].saleUser;
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
						$("#collectionDiv").empty();
						$("#deliveryDiv").empty();
						var collectionStr = "";
						var deliveryStr = "";
						if (data.length > 0) {
							for ( var i in data) {
								var date = data[i].split("#")[1];
								var title = "时间：" + date + "\n" + "说明：" + data[i].split("#")[2];
								var isFinished = data[i].split("#")[3] == 1;
								var isFinishedColor = "";
								var isFinishedIcon = "";
								if (isFinished) {
									isFinishedColor = "background-color:#5EC7CE;color:white;";
									isFinishedIcon = '<label style="font-weight:normal;margin-right:5px">'
											+ date
											+ '</label><img style="height: 15px;margin-bottom:5px;margin-right:10px" src="${pageContext.request.contextPath}/image/complete_s.png"/>';
									title += "\n进度：已完成";
								} else {
									isFinishedColor = "background-color:#f0ad4e;color:white;";
									isFinishedIcon = '<label style="font-weight:normal">'
											+ date + '</label>';
								}

								if (data[i].split("#")[0] == 1) {
									arrayCollection.push(data[i]);
									var collectionIndex = arrayCollection.length - 1;
									collectionStr += '<span id="collection'+collectionIndex+'"><span style="'+isFinishedColor+'width:50px;height:30px;margin-top:0px;line-height:25px;padding:2px 0" title="'+title+'">'
											+ isFinishedIcon
											+ '</span><span>'
											+ '<img style="height: 12px;margin-bottom:5px;margin-left:5px;margin-right:10px;" src="${pageContext.request.contextPath}/image/update.png" onClick="editPaymentInfo('
											+ collectionIndex
											+ ',1)"/></span></span>';
								} else {
									arrayDelivery.push(data[i]);
									var deliveryIndex = arrayDelivery.length - 1;
									deliveryStr += '<span id="delivery'+deliveryIndex+'"><span style="'+isFinishedColor+'width:50px;height:30px;margin-top:0px;line-height:25px;padding:2px 0" title="'+title+'">'
											+ isFinishedIcon
											+ '</span><span><img style="height: 12px;margin-bottom:5px;margin-left:5px;margin-right:10px" src="${pageContext.request.contextPath}/image/update.png" onClick="editPaymentInfo('
											+ deliveryIndex
											+ ',2)"/></span></span>';
								}
							}
							$("#collectionDiv").append(collectionStr);
							$("#deliveryDiv").append(deliveryStr);
						}
					},
					error : function(XMLHttpRequest, textStatus, errorThrown) {
					}
				});

	}

	function editContract() {
		if(isPermissionEdit){
		var contractNum = $("#contractNum").val().trim();
		var companyId = $("#companyId").val();
		var salesId = $("#salesId").val();
		var projectId = $("#projectId").val();
		var dateForStartContract = $("#dateForStartContract").val().trim();
		var dateForEndContract = $("#dateForEndContract").val().trim();
		var contractAmount = $("#contractAmount").val().trim();
		var taxRate = $("#taxrate").val().trim();
		var serviceDetails = $("#serviceDetails").val().trim();
		var arrayPaymentInfo = arrayCollection.concat(arrayDelivery);

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
		}
		
		if(taxRate != "" && !r.test(taxRate)){
			alert("税率有误，请重新输入");
			return;
		}

		if (serviceDetails == "") {
			alert("服务内容不能为空");
			return;
		}
		$.ajax({
			url : host + "/editContract",
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
				"id" : id,
				"isUploadContract" : 0
			},
			traditional : true,
			success : function(returndata) {
				var data = returndata.errcode;
				if (data == 0) {
					alert("编辑合同成功");
					parent.leftFrame.getUnInputContract();
					setTimeout(function() {
						toReloadPage();
						toBackPage();
					}, 500);
				} else {
					alert("编辑合同失败");
				}
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
		}else{
			alert("你无权编辑合同");
		}
	}

	function addNewCollection() {
		if (arrayCollection.length == 5) {
				alert("最多只能添加5条收款/付款明细");
				return;
			} else {
				document.getElementById("delTitle").innerHTML = "添加收款/付款明细";
				arrayType = 0;
				operation = 0;
				$("#time1").val("");
				$("#desc").val("");
				$('#finishCheck').bootstrapSwitch('state', false);
				$("#banDel").show();
			}
	}

	function addNewDelivery() {
            if (arrayDelivery.length == 5) {
				alert("最多只能添加5条进货/出货明细");
				return;
			} else {
				document.getElementById("delTitle").innerHTML = "添加进货/出货明细";
				arrayType = 1;
				operation = 0;
				$("#time1").val("");
				$("#desc").val("");
				$('#finishCheck').bootstrapSwitch('state', false);
				$("#banDel").show();
			}
	}

	function editPaymentInfo(index, type) {
		if (isPermissionDelete) {
			var item;
			if (type == 1) {
				document.getElementById("delTitle").innerHTML = "编辑收款/付款明细";
				item = arrayCollection[index];
				arrayType = 0;
			} else {
				document.getElementById("delTitle").innerHTML = "编辑进货/出货明细";
				item = arrayDelivery[index];
				arrayType = 1;
			}
			operation = 1;
			$("#time1").val(item.split("#")[1]);
			$("#desc").val(item.split("#")[2]);
			$('#finishCheck').bootstrapSwitch('state', item.split("#")[3] == 1);
			editPaymentId = item.split("#")[4];
			$("#banDel").show();
		} else {
            if(type == 1){
            	alert("你无权编辑收款/付款明细");
            }else{
            	alert("你无权编辑进货/出货明细");
            }
			return;
		}
	}

	function confirmAdd() {
		var time = $("#time1").val().trim();
		var desc = $("#desc").val().trim();
		var isFinished = $("#finishCheck").bootstrapSwitch('state') == true ? 1
				: 0;
		if (time == "") {
			alert("时间节点不能为空");
			return;
		}
		if (desc == "") {
			alert("说明内容不能为空");
			return;
		}
		var addItem;
		if (arrayType == 0) {
			addItem = "1#" + time + "#" + desc + "#" + isFinished + "#";
			addItem += operation == 0 ? "null" : editPaymentId;
			var ret = checkRepeatItem(arrayCollection, addItem);
			if (ret == addItem) {
				alert("收款/付款明细不能重复添加");
				return;
			} else if (ret == -1) {
				//新增
				arrayCollection.push(addItem)
			} else {
				//编辑
				arrayCollection.splice(ret, 1, addItem);
			}
		} else {
			//进货/出货
			addItem = "2#" + time + "#" + desc + "#" + isFinished + "#";
			addItem += operation == 0 ? "null" : editPaymentId;
			var ret = checkRepeatItem(arrayDelivery, addItem);
			if (ret == addItem) {
				alert("进货/出货明细不能重复添加");
				return;
			} else if (ret == -1) {
				arrayDelivery.push(addItem);
			} else {
				arrayDelivery.splice(ret, 1, addItem);
			}
		}
		updateArrayList(arrayType == 0 ? 1 : 2);
		$("#banDel").hide();
	}

	function removeArray(index, type) {
		if (type == 1) {
			arrayCollection.splice(index, 1);
		} else {
			arrayDelivery.splice(index, 1);
		}
		updateArrayList(type);
	}

	/*** 查重,查到了返回当前item,未查到返回当前item的index ****/
	function checkRepeatItem(array, addItem) {
		var repeatItem = null;
		var index = -1;
		for ( var i in array) {
			if (operation == 1) {
				//编辑
				if (array[i].split("#")[1] == addItem.split("#")[1]
						&& array[i].split("#")[2] == addItem.split("#")[2]
						&& editPaymentId != array[i].split("#")[4]) {
					repeatItem = addItem;
					break;
				}
				if (editPaymentId == array[i].split("#")[4]) {
					index = i;
				}
			} else if (array[i].split("#")[1] == addItem.split("#")[1]
					&& array[i].split("#")[2] == addItem.split("#")[2]) {
				repeatItem = addItem;
				break;
			}
		}
		if (repeatItem != null) {
			//找到重复的了
			return repeatItem;
		} else {
			return index;
		}
	}

	function updateArrayList(type) {
		var str = "";
		var spanId = "";
		if (type == 1) {
			$("#collectionDiv").empty();
			mArray = arrayCollection;
			spanId = "collection";
		} else {
			$("#deliveryDiv").empty();
			mArray = arrayDelivery;
			spanId = "delivery";
		}
		if (mArray.length > 0) {
			for ( var i in mArray) {
				var date = mArray[i].split("#")[1];
				var title = "时间："+date + "\n" + "说明：" + mArray[i].split("#")[2];
				var isFinished = mArray[i].split("#")[3] == 1;
				var isEditItem = mArray[i].split("#")[4] != "null";
				var isFinishedColor = "";
				var isFinishedIcon = "";
				var operationImg = "";
				if (isFinished) {
					isFinishedColor = "background-color:#5EC7CE;color:white;";
					isFinishedIcon = '<label style="font-weight:normal;margin-right:5px">'
							+ date
							+ '</label><img style="height: 15px;margin-bottom:5px;margin-right:10px" src="${pageContext.request.contextPath}/image/complete_s.png"/>';
					title += "\n进度：已完成";
				} else {
					isFinishedColor = "background-color:#f0ad4e;color:white;";
					isFinishedIcon = '<label style="font-weight:normal">'
							+ date + '</label>';
				}
				if (isEditItem) {
					//编辑
					operationImg = '<img style="height: 12px;margin-bottom:5px;margin-left:5px;margin-right:10px" src="${pageContext.request.contextPath}/image/update.png" onClick="editPaymentInfo('
							+ i + ',' + type + ')"/>';
				} else {
					operationImg = '<img style="height: 25px;margin-bottom:5px;" src="${pageContext.request.contextPath}/image/minus2019.png" onClick="removeArray('
							+ i + ',' + type + ')"/>';
				}
				str += '<span id="'+spanId+i+'"><span style="'+isFinishedColor+'width:50px;height:30px;margin-top:0px;line-height:25px;padding:2px 0" title="'+title+'">'
						+ isFinishedIcon
						+ '</span><span>'
						+ operationImg
						+ '</span></span>';
			}
		}
		if (type == 1) {
			$("#collectionDiv").append(str);
		} else {
			$("#deliveryDiv").append(str);
		}
	}

	function changeCompany(companyId) {
		getProjectList(companyId, "", isFmlkShare);
	}
	
	function getUserInfo(uNickName) {
		var mUid;
		$.ajax({
			url : "${pageContext.request.contextPath}/getUserByNickName",
			type : 'GET',
			async : false,
			data : {
				"nickName" : uNickName
			},
			cache : false,
			success : function(returndata) {
				var data = eval("(" + returndata + ")").user;
				mUid = data[0].UId;
			}
		});
		return mUid;
	}

</script>

</head>
<body>
	<div id="pageAll">
		<!-- pageTop-->
		<div class="pageTop">
			<div class="page">
				<img src="${pageContext.request.contextPath}/image/coin02.png" /><span><a
					href="#">首页</a>&nbsp;-&nbsp;<a href="#">合同管理</a>&nbsp;-</span><span
					style="margin-left: 5px" id="span_title2"></span>
			</div>
		</div>
		<!-- end of  pageTop-->

		<div class="page">
			<div class="banneradd bor">
				<div class="baTopNo">
					<span id="span_title1"></span>
				</div>
				<!-- baBody-->
				<div class="baBody">
					<div class="bbD">
						<span class="need">*</span><label
							style="margin-left: 0; font-weight: normal">合同编号：</label><input
							type="text" class="input3" id="contractNum"
							placeHolder="请按照合同上的编号填写"
							style="width: 700px; margin-right: 10px; background-color: #eee;"
							disabled="disabled" />
					</div>

					<div class="bbD">
						<span class="need">*</span><label
							style="margin-left: 0; font-weight: normal">客户名称：</label><select
							class="selCss" id="companyId"
							style="margin-right: 10px; width: 290px;"
							onChange="changeCompany(this.options[this.options.selectedIndex].value)"></select>
						<span style="margin-left: 20px"><span class="need">*</span><label
							style="margin-left: 0; font-weight: normal">销售人员：</label><select
							class="selCss" id="salesId" style="width: 290px;"></select></span>

					</div>

					<div class="bbD">
						<span class="need">*</span><label
							style="margin-left: 0; font-weight: normal">项目名称：</label><select
							class="selCss" id="projectId"
							style="margin-right: 10px; width: 700px;"><option
								value="0">请选择...</option></select>
					</div>

					<div class="bbD" style="">
						<span class="need">*</span><label
							style="margin-left: 0; font-weight: normal">合同实施日期：</label><input
							class="input3" type="text" id="dateForStartContract"
							style="width: 100px;"> <span id="dd_dateForStartContract"></span>
						<label
							style="margin-left: 15px; margin-right: 10px; font-weight: normal">至</label>
						<input class="input3" type="text" id="dateForEndContract"
							style="width: 100px;"> <span id="dd_dateForEndContract"></span>

						<span style="margin-left: 15px"><span class="need">*</span><label
							style="margin-left: 0; font-weight: normal">合同金额：</label><input
							type="text" class="input3" id="contractAmount"
							style="width: 140px;" /></span> <span style="margin-left: 15px"><label
							style="margin-left: 0px; font-weight: normal">税率：</label><input
							type="text" class="input3" id="taxrate" style="width: 80px;" />%</span>
					</div>

					<div class="bbD">
						<span class="need" style="float: left;">*</span><label
							style="margin-left: 0; float: left; font-weight: normal">服务内容说明：</label>
						<textarea id="serviceDetails"
							style="width: 670px; resize: none; height: 100px; margin-right: 10px;"
							class="input3"></textarea>
					</div>
					<div style="margin-top: 15px; width: 1000px" id="collectionInfo">
						<div class="bbD" style="height: 32px">
							<span class="need" style="float: left;">*</span><label
								style="float: left; margin-left: 0px; font-weight: normal">收款/付款详情：</label>
							<img style="height: 25px; margin-right: 21px" id="addBtn"
								src="${pageContext.request.contextPath}/image/plus2019.png"
								onclick="addNewCollection()" />
						</div>
						<div class="bbD" id="collectionDiv"
							style="padding-left: 136px; margin-top: 0px"></div>
					</div>

					<div style="margin-top: 20px; width: 1000px" id="deliveryInfo">
						<div class="bbD" style="height: 32px">
							<span class="need" style="float: left;">*</span><label
								style="float: left; margin-left: 0px; font-weight: normal">进货/出货详情：</label>
							<img style="height: 25px; margin-right: 21px" id="addBtn"
								src="${pageContext.request.contextPath}/image/plus2019.png"
								onclick="addNewDelivery()" />
						</div>
						<div class="bbD" id="deliveryDiv"
							style="padding-left: 136px; margin-top: 0px"></div>
					</div>
					<div class="cfD"
						style="margin-top: 30px; margin-bottom: 30px; margin-left: -40px">
						<a class="addA" href="#" onclick="editContract()" id="operation" style="display: none;">保存</a> <a
							class="addA" href="#" onclick="toBackPage()">返回</a>
					</div>

				</div>
				<!-- end of  baBody-->
			</div>
			<!-- end of  banneradd bor-->
		</div>
		<!-- end of  page-->
	</div>
	<!-- 弹出框 -->
	<div class="banDel" id="banDel">
		<div class="delete">
			<div class="close">
				<a><img
					src="${pageContext.request.contextPath}/image/shanchu.png"
					onclick="closeConfirmBox()" /></a>
			</div>
			<p class="delP1" id="delTitle"></p>
			<div class="cfD" style="margin-top: 30px">
				<span class="need">*</span><label
					style="font-size: 16px; margin-left: 0px; font-weight: normal">时间节点：</label>
				<input type="text"
					style="width: 100px; height: 26px; border-bottom: 1px dashed #78639F; border-left: none; border-right: none; border-top: none; padding-left: 10px; margin-right: 5px"
					id="time1" /> <span id="dd0_1_1"
					style="margin-left: 150px; margin-top: 130px"></span> <input
					type="checkbox" data-on-text="已完成" data-off-text="未完成"
					data-size="mini" data-label-text="完成情况" data-on-color="info"
					data-off-color="warning" data-handle-width="70px"
					data-label-width="60px" id="finishCheck" checked="checked">
			</div>
			<div class="cfD" style="margin-top: 30px">
				<span class="need">*</span><label
					style="font-size: 16px; margin-left: 0px; font-weight: normal">内容说明：</label>
				<input type="text"
					style="width: 260px; height: 26px; border-bottom: 1px dashed #78639F; border-left: none; border-right: none; border-top: none; padding-left: 10px;"
					id="desc" />
			</div>
			<div class="cfD" style="margin-top: 30px">
				<a class="addA" href="#" onclick="confirmAdd()"
					style="margin-left: 0px; margin-bottom: 30px;">保存</a> <a
					class="addA" onclick="closeConfirmBox()">取消</a>
			</div>
		</div>
	</div>
</body>
</html>