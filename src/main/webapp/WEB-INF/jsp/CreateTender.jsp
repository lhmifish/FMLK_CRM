<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="renderer" content="webkit" />
<meta http-equiv="pragma" content="no-cache" />
<meta http-equiv="cache-control" content="no-cache" />
<title>新建标书信息</title>
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/css.css?v=1997" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/select4.css?v=1999" />
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/calendar.css" />

<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.2.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/select3.js"></script>

<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/validation.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/calendar.js"></script>
<!-- Include a polyfill for ES6 Promises (optional) for IE11 and Android browser -->
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/core-js/2.4.1/core.js"></script>
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
	var tenderIntent;
	var sId;
	var host;
	var isPermissionView;

	$(document).ready(function() {
		sId = "${sessionId}";
		host = "${pageContext.request.contextPath}";
		checkViewPremission(32);
	});

	function initialPage() {
		var today = formatDate(new Date()).substring(0, 10);
		$('#dateForBuy').val(today);
		$('#dateForSubmit').val(today);
		$('#dateForOpen').val(today);
		initDate();
		getCompanyList("", 0, 0, 1);
		getAgencyList(0);
		getSalesList(0);
		getTenderStyleList(0);
		getProductBrandList(0);
		getProductStyleList(0);
		tenderIntent = 1;
		$("#companyId").select2({});
		$("#tenderAgency").select2({});
		$("#salesId").select2({});
		$("#tenderStyle").select2({});
		$("#productStyle").select2({});
		$("#productBrand").select2({});
		$("#projectId").select2({});
	}

	function checkTenderIntent(j) {
		tenderIntent = j;
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

	function getSalesByCompanyId(companyId) {
		var mSalesId;
		$.ajax({
			url : host + "/getCompanyByCompanyId",
			type : 'GET',
			data : {
				"companyId" : companyId
			},
			cache : false,
			async : false,
			success : function(returndata) {
				var data = eval("(" + returndata + ")").company;
				mSalesId = data[0].salesId;
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
		return mSalesId;
	}

	function changeCompany(tCompanyId) {
		var salesId = getSalesByCompanyId(tCompanyId);
		getSalesList(salesId);
		getProjectList(tCompanyId, 0);
	}

	function changeProject() {
		// js方法结束后调用,此处留空
	}

	function createTenderAgency() {
		if (!isPermissionView) {
			alert("你没有权限添加招标代理机构");
			return;
		}
		$("#banDel2").show();
	}

	function createAgency() {
		var newAgency = $("#newAgencyName").val().trim();
		if(newAgency == ""){
			alert("招标代理机构名不能为空");
			return;
		}
		
		$.ajax({
			url : host + "/createAgency",
			type : 'POST',
			cache : false,
			data : {
				"agencyName" : newAgency
			},
			success : function(returndata) {
				var data = eval("(" + returndata + ")").errcode;
				if (data == 0) {
					alert("输入成功");
					getAgencyList(0);
					$("#newAgencyName").val("");
					closeConfirmBox();
				} else if (data == 3) {
					alert("有相同或类似的招标代理机构名存在，请检查");
				} else {
					alert("输入失败");
				}
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
	}

	function createNewTender() {
		if (!isPermissionView) {
			alert("你没有权限新建标书");
			return;
		}
		var tenderNum = $("#tenderNum").val().trim();
		var tenderCompany = $("#companyId").val();
		var tenderAgency = $("#tenderAgency").val();
		var projectId = $("#projectId").val();
		var saleUser = $("#salesId").val();
		var dateForBuy = $("#dateForBuy").val().trim();
		var dateForSubmit = $("#dateForSubmit").val().trim();
		var dateForOpen = $("#dateForOpen").val().trim();
		var tenderStyle = $("#tenderStyle").val();
		var tenderExpense = $("#tenderExpense").val().trim();
		var tenderGuaranteeFee = $("#tenderGuaranteeFee").val().trim();
		var productStyle = $("#productStyle").val();
		var productBrand = $("#productBrand").val();
		var enterpriseQualificationRequirment = $(
				"#enterpriseQualificationRequirment").val().trim();
		var technicalRequirment = $("#technicalRequirment").val().trim();
		var remark = $("#remark").val().trim();

		if (tenderNum == "") {
			alert("招标编号不能为空");
			return;
		}

		if (tenderCompany == 0) {
			alert("请选择招标单位");
			return;
		}

		if (tenderAgency == 0) {
			alert("请选择招标代理机构");
			return;
		}

		if (projectId == 0) {
			alert("请选择项目名称");
			return;
		}

		if (saleUser == 0) {
			alert("请选择销售人员");
			return;
		}

		var d1 = new Date(dateForBuy);//购标
		var d2 = new Date(dateForSubmit);//投标
		var d3 = new Date(dateForOpen);//开标

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

		var r = /^\+?(0|[1-9][0-9]*)$/;

		if (tenderExpense == "") {
			alert("购标费用不能为空");
			return;
		} else if (!r.test(tenderExpense)) {
			alert("购标费用有误，请重新输入");
			return;
		}

		if (tenderGuaranteeFee == "") {
			alert("投标保证金不能为空");
			return;
		} else if (!r.test(tenderGuaranteeFee)) {
			alert("投标保证金有误，请重新输入");
			return;
		}

		if (tenderIntent == 2 && remark == "") {
			alert("非投标原因购标请在备注中说明");
			return;
		}

		if (productStyle == 0) {
			alert("产品类别不能为空");
			return;
		}

		if (productBrand == 0) {
			alert("产品品牌不能为空");
			return;
		}

		$
				.ajax({
					url : host + "/createNewTender",
					type : 'POST',
					cache : false,
					data : {
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
						"tenderIntent" : tenderIntent,
						"productStyle" : productStyle,
						"productBrand" : productBrand,
						"enterpriseQualificationRequirment" : enterpriseQualificationRequirment,
						"technicalRequirment" : technicalRequirment,
						"remark" : remark,
						"tenderGuaranteeFee" : tenderGuaranteeFee

					},
					success : function(returndata) {
						var data = eval("(" + returndata + ")").errcode;
						if (data == 0) {
							alert("新建标书成功");
							toReloadPage();
						} else if (data == 3) {
							alert("你已经录入这份标书，请勿重复录入");
						} else {
							alert("新建失败");
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
					href="#">招标管理</a>&nbsp;-</span>&nbsp;新建标书信息
			</div>
		</div>

		<div class="page">
			<div class="banneradd bor">
				<div class="baTopNo">
					<span>标书基本信息</span>
				</div>
				<div class="baBody">
					<div class="bbD">
						<label>招标编号：</label><input type="text" class="input3"
							id="tenderNum" style="width: 798px; margin-right: 10px;" />
					</div>

					<div class="bbD">
						<label>招标单位：</label><select class="selCss" id="companyId"
							style="margin-right: 10px; width: 340px;"
							onChange="changeCompany(this.options[this.options.selectedIndex].value)">
						</select><label>招标代理机构：</label><select class="selCss" id="tenderAgency"
							style="width: 340px;"></select> <img
							style="width: 30px; height: 30px;"
							src="${pageContext.request.contextPath}/image/plus2018.png"
							onclick="createTenderAgency()">

					</div>

					<div class="bbD">
						<label>项目名称：</label><select class="selCss" id="projectId"
							style="margin-right: 10px; width: 340px;">
							<option value="0">请选择...</option>
						</select> <label style="margin-left: 40px">销售人员：</label><select
							class="selCss" id="salesId" style="width: 340px;" /></select>
					</div>

					<div class="bbD">
						<label style="margin-left: -12px;">购标申请日期：</label><input
							class="input3" type="text" id="dateForBuy" style="width: 190px;">
						<span id="dd"></span> <label>投标日期：</label><input class="input3"
							type="text" id="dateForSubmit" style="width: 190px;"> <span
							id="dd2"></span> <label>开标日期：</label><input class="input3"
							type="text" id="dateForOpen" style="width: 190px;"> <span
							id="dd3"></span>
					</div>

					<div class="bbD">
						<label>投标类型：</label><select class="selCss" id="tenderStyle"
							style="margin-right: 10px; width: 340px;" /></select> <label
							style="margin-left: 40px">购标费用：&nbsp;RMB</label><input
							type="text" class="input3" id="tenderExpense"
							style="width: 67px;" placeholder="0" /><label>投标保证金：&nbsp;RMB</label><input
							type="text" class="input3" id="tenderGuaranteeFee"
							style="width: 67px;" placeholder="0" />
					</div>

					<div class="bbD">
						<label>购标意图：</label> <input type="radio" name="field02"
							id="tenderIntent" value="1" checked="checked"
							onclick="checkTenderIntent(1)" /><label
							style="margin-right: 100px; margin-left: 5px;">投标</label> <input
							type="radio" name="field02" id="tenderIntent" value="2"
							onclick="checkTenderIntent(2)" /><label
							style="margin-left: 5px;">购标(其他用处)</label> <Strong
							style="margin-left: 20px; color: red">非投标原因购标请在备注中说明</Strong>
					</div>

					<div class="bbD">
						<label>产品类别：</label><select class="selCss" id="productStyle"
							style="margin-right: 10px; width: 340px;"></select><label
							style="margin-left: 40px">产品品牌：</label><select class="selCss"
							id="productBrand" style="width: 340px;"></select>
					</div>

					<div class="bbD">
						<label>企业资质：</label>
						<textarea id="enterpriseQualificationRequirment"
							style="width: 332px; resize: none; height: 80px; margin-right: 10px;"
							class="input3"></textarea>
						<label style="margin-left: 20px">技术要求：</label>
						<textarea id="technicalRequirment"
							style="width: 332px; resize: none; height: 80px;" class="input3"></textarea>
					</div>

					<div class="bbD">
						<label style="margin-left: 44px;">备注：</label>
						<textarea id="remark"
							style="width: 798px; resize: none; height: 80px; margin-right: 10px;"
							class="input3"></textarea>
					</div>
					<div class="cfD" style="margin-bottom: 30px;">
						<a class="addA" href="#" onclick="createNewTender()"
							style="margin-left: 100px; margin-top: 30px">提交</a> <a
							class="addA" href="#" onclick="toIndexPage()">关闭</a>
					</div>
				</div>
			</div>
		</div>

		<!-- 弹出框 -->
		<div class="banDel" id="banDel2">
			<div class="delete">
				<div class="close">
					<a><img src="../image/shanchu.png" onclick="closeConfirmBox()" /></a>
				</div>
				<p class="delP1">添加招标代理机构名</p>
				<p class="delP2" style="margin-top: 20px;">
					<label style="font-size: 16px;">招标代理机构：</label> <input type="text"
						class="selCss" id="newAgencyName"
						style="width: 230px; height: 26px; margin-right: 10px; border-bottom: 1px dashed #78639F; background: none; border-left: none; border-right: none; border-top: none; padding: 4px 2px 3px 2px; padding-left: 10px" />

				</p>
				<div class="cfD" style="margin-top: 30px">
					<a class="addA" href="#" onclick="createAgency()"
						style="margin-left: 0px; margin-bottom: 30px;">确定</a> <a
						class="addA" onclick="closeConfirmBox()">取消</a>
				</div>
			</div>
		</div>


	</div>
</body>
</html>