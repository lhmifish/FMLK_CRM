<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="renderer" content="webkit" />
<meta http-equiv="pragma" content="no-cache" />
<meta http-equiv="cache-control" content="no-cache" />
<title>编辑标书信息</title>
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/css.css?v=2000" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/select4.css?v=1999" />
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/calendar.css" />
<link href='http://fonts.googleapis.com/css?family=Roboto'
	rel='stylesheet' type='text/css'>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.2.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/select3.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/validation.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/calendar.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery.jqprint-0.3.js"></script>
<script src="http://www.jq22.com/jquery/jquery-migrate-1.2.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/checkPermission.js"></script>
<script src="${pageContext.request.contextPath}/js/changePsd.js"></script>
<script src="${pageContext.request.contextPath}/js/commonUtils.js?v=200"></script>
<script src="${pageContext.request.contextPath}/js/getObjectList.js?v=1"></script>
<style type="text/css">
a:hover {
	color: #FF00FF
} /* 鼠标移动到链接上 */
</style>
<script type="text/javascript">
	var id;//标书id
	var sId;//sessionId
	var tenderResult;
	var tenderIntent;
	var host;
	var salesId;
	var isPermissionEdit;
	var isFmlkShare;

	$(document).ready(function() {
		id = "${mId}";//标书id
		sId = "${sessionId}";
		host = "${pageContext.request.contextPath}";
		checkEditPremission(33, 0);
	});

	function initialPage() {
		initDate();
		getTenderInfo(id);
		matchEdit("招投标");
		$("#companyId").select2({});
		$("#tenderAgency").select2({});
		$("#projectId").select2({});
		$("#salesId").select2({});
		$("#tenderStyle").select2({});
		$("#productStyle").select2({});
		$("#productBrand").select2({});
	}

	function getTenderInfo(tid) {
		$.ajax({
			url : host + "/getTenderById",
			type : 'GET',
			cache : false,
			async : false,
			data : {
				"id" : tid
			},
			success : function(returndata) {
				var data = eval("(" + returndata + ")").tender;
				isFmlkShare = data[0].isFmlkShare;
				$("#tenderNum").val(data[0].tenderNum);
				getCompanyList("", 0, data[0].tenderCompany, 1,isFmlkShare);
				getAgencyList(data[0].tenderAgency);
				getProjectList(data[0].tenderCompany, data[0].projectId,isFmlkShare);
				getSalesList(data[0].saleUser);
				salesId = data[0].saleUser;
				$('#dateForBuy').val(data[0].dateForBuy);
				$('#dateForSubmit').val(data[0].dateForSubmit);
				$('#dateForOpen').val(data[0].dateForOpen);
				getTenderStyleList(data[0].tenderStyle);
				$('#tenderExpense').val(data[0].tenderExpense);
				$('#tenderGuaranteeFee').val(data[0].tenderGuaranteeFee);
				tenderIntent = data[0].tenderIntent;
				$("input[name='field02'][value=" + tenderIntent + "]").attr(
						"checked", true);
				getProductStyleList(data[0].productStyle,isFmlkShare);
				getProductBrandList(data[0].productBrand);
				$('#enterpriseQualificationRequirment').val(
						data[0].enterpriseQualificationRequirment);
				$('#technicalRequirment').val(data[0].technicalRequirment);
				$('#remark').val(data[0].remark);
				tenderResult = data[0].tenderResult;
				if (tenderResult != 0) {
					$("input[name='field01'][value=" + tenderResult + "]")
							.attr("checked", true);
				}
				checkTenderResult(tenderResult);
				$("#serviceExpense").val(data[0].serviceExpense);
				$("#tenderAmount").val(data[0].tenderAmount);
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

	function checkTenderResult(k) {
		tenderResult = k;
		if (tenderResult == 1) {
			$("#labelServiceExpense").show();
			$("#labelTenderAmount").show();
			$("#serviceExpense").show();
			$("#tenderAmount").show();
			$("#info").hide();
		} else {
			$("#labelServiceExpense").hide();
			$("#labelTenderAmount").hide();
			$("#serviceExpense").hide();
			$("#tenderAmount").hide();
			if (tenderResult == 3) {
				$("#info").show();
			} else {
				$("#info").hide();
			}
		}
	}

	function initDate() {
		$('#dd').calendar({
			trigger : '#dateForBuy',
			zIndex : 999,
			format : 'yyyy/mm/dd',
			onSelected : function(view, date, data) {
			},
			onClose : function(view, date, data) {
				$('#dateForBuy').val(formatDate(date).substring(0, 10));
			}
		});

		$('#dd2').calendar({
			trigger : '#dateForSubmit',
			zIndex : 999,
			format : 'yyyy/mm/dd',
			onSelected : function(view, date, data) {
			},
			onClose : function(view, date, data) {
				$('#dateForSubmit').val(formatDate(date).substring(0, 10));
			}
		});

		$('#dd3').calendar({
			trigger : '#dateForOpen',
			zIndex : 999,
			format : 'yyyy/mm/dd',
			onSelected : function(view, date, data) {
			},
			onClose : function(view, date, data) {
				$('#dateForOpen').val(formatDate(date).substring(0, 10));
			}
		});
	}

	function printTender() {
		$("#div1").jqprint();
	}

	function editTender() {
		var tenderNum = $("#tenderNum").val();
		var tenderCompany = $("#companyId").val();
		var tenderAgency = $("#tenderAgency").val();
		var projectId = $("#projectId").val();
		var saleUser = $("#salesId").val();
		var dateForBuy = $("#dateForBuy").val();
		var dateForSubmit = $("#dateForSubmit").val();
		var dateForOpen = $("#dateForOpen").val();
		var tenderStyle = $("#tenderStyle").val();
		var tenderExpense = $("#tenderExpense").val();
		var tenderGuaranteeFee = $("#tenderGuaranteeFee").val();
		var productStyle = $("#productStyle").val();
		var productBrand = $("#productBrand").val();
		var enterpriseQualificationRequirment = $(
				"#enterpriseQualificationRequirment").val();
		var technicalRequirment = $("#technicalRequirment").val();
		var remark = $("#remark").val();
		var serviceExpense = $("#serviceExpense").val();
		var tenderAmount = $("#tenderAmount").val();

		if (tenderNum == "") {
			alert("招标编号不能为空");
			return;
		}
		if (saleUser == 0) {
			alert("请选择销售人员");
			return;
		}
		var d1 = new Date(dateForBuy);
		var d2 = new Date(dateForSubmit);
		var d3 = new Date(dateForOpen);

		if (d1 >= d2) {
			alert("错误：投标日期不能早于或等于购标日期，请修改");
			return;
		} else if (d2 > d3) {
			alert("错误：开标日期不能早于投标日期，请修改");
			return;
		}

		if (tenderStyle == 0) {
			alert("请选择投标类型");
			return;
		}

		if (productStyle == 0) {
			alert("产品类别不能为空");
			return;
		}

		var r = /^\+?(0|[1-9][0-9]*)$/;

		if (tenderExpense == "") {
			alert("购标费用不能为空");
			return;
		} else if (!r.test(tenderExpense)) {
			alert("购标费用有误，请重新输入");
			return;
		}

		if (tenderGuaranteeFee != "" && !r.test(tenderGuaranteeFee)) {
			alert("投标保证金有误，请重新输入");
			return;
		}
		
		if (tenderIntent == 2 && remark == "") {
			alert("非投标原因购标请在备注中说明");
			return;
		}

		if (tenderResult == 1) {
			if (serviceExpense == "") {
				alert("中标服务费不能为空");
				return;
			} else if (!r.test(serviceExpense)) {
				alert("中标服务费用有误，请重新输入");
				return;
			} else if(tenderAmount == ""){
				alert("中标金额不能为空");
				return;
			} else if(!r.test(tenderAmount)){
				alert("中标金额有误，请重新输入");
				return;
			}
		} else {
			serviceExpense = 0;
			tenderAmount = 0;
		}

		if (tenderResult == 3 && remark == "") {
			alert("请在备注中说明投标未中 和 未投标/弃标原因");
			return;
		}

		$
				.ajax({
					url : host + "/editTender",
					type : 'POST',
					cache : false,
					data : {
						"id" : id,
						"tenderNum" : tenderNum,
						"tenderCompany" : tenderCompany,
						"tenderAgency" : tenderAgency,
						"projectId" : projectId,
						"saleUser" : saleUser,
						"dateForBuy" : dateForBuy,
						"dateForSubmit" : dateForSubmit,
						"dateForOpen" : dateForOpen,
						"tenderStyle" : tenderStyle,
						"tenderExpense" : tenderExpense,
						"productStyle" : productStyle,
						"productBrand" : productBrand,
						"enterpriseQualificationRequirment" : enterpriseQualificationRequirment,
						"technicalRequirment" : technicalRequirment,
						"remark" : remark,
						"tenderResult" : tenderResult,
						"tenderIntent" : tenderIntent,
						"serviceExpense" : serviceExpense,
						"tenderAmount":tenderAmount,
						"tenderGuaranteeFee" : tenderGuaranteeFee,
						"isUploadTender" : false
						
					},
					success : function(returndata) {
						var data = eval("(" + returndata + ")").errcode;
						if (data == 0) {
							alert("编辑标书成功");
							parent.leftFrame.location.reload();
							setTimeout(function() {
								toReloadPage();
								toBackPage();
								toBackPage();
							}, 500);
						} else {
							alert("编辑标书失败");
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
					href="#">首页</a>&nbsp;-&nbsp;<a href="#">招标管理</a>&nbsp;-</span><span
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
						<label>招标编号：</label><input type="text" class="input3"
							id="tenderNum" style="width: 700px; margin-right: 10px;background-color:#eee;color:black" disabled="disabled"/>
					</div>

					<div class="bbD">
						<label>招标单位：</label><select class="selCss" id="companyId"
							style="width: 290px;" disabled="disabled"></select><label>招标代理机构：</label><select
							class="selCss" id="tenderAgency" style="width: 290px;"></select>

					</div>

					<div class="bbD">
						<label>项目名称：</label><select class="selCss" id="projectId"
							style="width: 290px;"><option value="0">请选择...</option></select><label
							style="margin-left: 42px">销售人员：</label><select class="selCss"
							id="salesId" style="width: 290px;" /></select>
					</div>

					<div class="bbD">
						<label style="margin-left: -14px;">购标申请日期：</label><input
							class="input3" type="text" id="dateForBuy" style="width: 158px;">
						<span id="dd"></span><label>投标日期：</label><input class="input3"
							type="text" id="dateForSubmit" style="width: 158px;"> <span
							id="dd2"></span><label>开标日期：</label><input class="input3"
							type="text" id="dateForOpen" style="width: 158px;"> <span
							id="dd3"></span>
					</div>

					<div class="bbD">
						<label>投标类型：</label><select class="selCss" id="tenderStyle"
							style="width: 168px;" /></select><label style="margin-left: 20px;">购标费用：
							￥</label><input type="text" class="input3" id="tenderExpense"
							style="width: 140px;" placeholder="0" /><label>投标保证金： ￥</label><input
							type="text" class="input3" id="tenderGuaranteeFee"
							style="width: 130px;" placeholder="0" />
					</div>

					<div class="bbD">
						<div style="margin-top: 15px">
							<label>购标意图：</label> <input type="radio" name="field02"
								id="tenderIntent" value="1" checked="checked"
								onclick="checkTenderIntent(1)" /><label
								style="margin-right: 100px; margin-left: 5px;">投标</label> <input
								type="radio" name="field02" id="tenderIntent" value="2"
								onclick="checkTenderIntent(2)" /><label
								style="margin-left: 5px;">购标(其他用处)</label><Strong
								style="margin-left: 20px; color: red">非投标原因购标请在备注中说明</Strong>
						</div>
					</div>

					<div class="bbD">
						<label>产品类别：</label><select class="selCss" id="productStyle"
							style="width: 290px;"></select><label
							style="margin-left: 42px;">产品品牌：</label><select class="selCss"
							id="productBrand" style="width: 290px;"></select>
					</div>

					<div class="bbD">
						<div style="float:left">
						<label style="float:left">企业资质：</label><textarea id="enterpriseQualificationRequirment"
							style="width: 280px; resize: none; height: 80px;"
							class="input3"></textarea>
						</div>
						<div>
						<label style="margin-left: 42px;float:left">技术要求：</label><textarea id="technicalRequirment"
							style="width: 280px; resize: none; height: 80px;" class="input3"></textarea>
						</div>
					</div>

					<div class="bbD">
						<label style="margin-left: 40px;float:left">备注：</label><textarea id="remark"
							style="width: 700px; resize: none; height: 80px; margin-right: 10px;"
							class="input3"></textarea>
					</div>

					<div class="bbD">
						<div style="margin-top: 30px; width: 100%; margin-bottom: 30px;">
							<Strong style="font-size: 20px;margin-left:-16px">招投标结果：</Strong>
							<input type="radio" name="field01" id="tenderResult" value="1"
								onclick="checkTenderResult(1)" style="margin-left: 25px;" /><label
								style="margin-right: 20px; margin-left: 5px;">中标</label><input
								type="radio" name="field01" id="tenderResult" value="2"
								onclick="checkTenderResult(2)" /><label
								style="margin-left: 5px; margin-right: 20px;">投标未中</label><input
								type="radio" name="field01" id="tenderResult" value="3"
								onclick="checkTenderResult(3)" /><label
								style="margin-left: 5px;">未投标/弃标</label> <label
								style="margin-left: 10px; display: none" id="labelServiceExpense">中标服务费：  ￥</label><input
								type="text" class="input3" id="serviceExpense"
								style="width: 90px; display: none" placeholder="0" /><label
								style="margin-left: 10px; display: none" id="labelTenderAmount">中标金额：  ￥</label><input
								type="text" class="input3" id="tenderAmount"
								style="width: 90px; display: none" placeholder="0" /><Strong
								id="info" style="margin-left: 30px; color: red; display: none">在备注中说明未投标/弃标原因</Strong>
						</div>
					</div>

					<div class="cfD" style="margin-bottom: 30px;">
						<a class="addA" href="#" onclick="editTender()" id="operation"
							style="margin-left: 120px; margin-top: 20px;display: none;">编辑</a> <a
							class="addA" href="#" onclick="toBackPage()">返回</a>
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