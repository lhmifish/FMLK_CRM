<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="renderer" content="webkit" />
<meta http-equiv="X-UA-COMPATIBLE" content="IE=edge,chrome=1" />
<meta name="viewport"
	content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=no" />
<meta name="apple-mobile-web-app-capable" content="yes" />
<meta name="apple-mobile-web-app-status-bar-style" content="black" />
<meta name="format-detection" content="telephone=no" />
<meta http-equiv="pragma" content="no-cache" />
<meta http-equiv="cache-control" content="no-cache" />
<title>编辑合同信息</title>


<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/select4.css?v=1997" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/style4.css?v=1984" />
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/calendar.css" />
<link href='http://fonts.googleapis.com/css?family=Roboto'
	rel='stylesheet' type='text/css'>
<style type="text/css">
a {
	text-decoration: none;
}

ul, ol, li {
	list-style: none;
	padding: 0;
	margin: 0;
}

#demo {
	width: 300px;
	margin: 150px auto;
}

p {
	margin: 0;
}

#dt {
	margin: 30px auto;
	height: 28px;
	padding: 0 6px;
	border: 1px solid #ccc;
	outline: none;
}
</style>
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

<script type="text/javascript">
	var id;//标书id
    var user;
	var uDept;
	var createUser;
	var tenderResult;
	var tenderIntent;
	var tenderState;

	$(document).ready(function() {
		id = "${mId}";//合同id


		/* getSaleUserList();
		getCompanyList();
		getContractInfo(id);
		$("#clientName").select2({
			tags : true
		});
		$("#saleUser").select2({
			tags : true
		}); */
		
	});
	
	function getSaleUserList() {
		$.ajax({
			url : "${pageContext.request.contextPath}/userList",
			type : 'GET',
			data : {
				"dpartId" : 2,
				"date" : getDateStr(new Date()),
				"name" : "",
				"nickName" : "",
				"jobId" : "",
				"isHide":true
			},
			cache : false,
			async : false,
			success : function(returndata) {
				var str = '<option value="top">请选择...</option>';
				var data2 = eval("(" + returndata + ")").userlist;
				for ( var i in data2) {
					str += '<option value="'+data2[i].name+'">' + data2[i].name
							+ '</option>';
				}
				str += '<option value="梁孔泰">梁孔泰</option>';
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
				var str = '<option value="top">请选择...</option>';
				var data2 = eval("(" + returndata + ")").companylist;
				for ( var i in data2) {
					str += '<option value="'+data2[i].companyName+'">'
							+ data2[i].companyName + '</option>';
				}
				$("#clientName").empty();
				$("#clientName").append(str);

			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
	}
	
	function getContractInfo(tid) {
		$
				.ajax({
					url : "${pageContext.request.contextPath}/getContract",
					type : 'GET',
					cache : false,
					async : false,
					data : {
						"id" : tid
					},
					success : function(returndata) {
						var data = eval("(" + returndata + ")").contract;
						
						$("#contractNum").val(data[0].contractNum);
						$("#projectName").val(data[0].projectName);
						$('#dateForStartContract').val(data[0].dateForStartContract);
						$('#dateForEndContract').val(data[0].dateForEndContract);
						$('#saleUser').val(data[0].saleUser);
						$('#clientName').val(data[0].clientName);
						$("#serviceDetails").val(data[0].serviceDetails);
						$('#collectionDetails').val(data[0].collectionDetails);
						$('#deliveryDetails').val(data[0].deliveryDetails);
						$('#contractAmount').val(data[0].contractAmount);

						var taxRate = data[0].taxRate

						$("input[name='field01'][value=" + taxRate + "]")
								.attr("checked", true);
						
						

					},
					error : function(XMLHttpRequest, textStatus, errorThrown) {
					}
				});
	}

	
/* 
	function checkTenderResult(i) {
		tenderResult = i;
		var isCheck = document.getElementsByName('field01');
		if (isCheck[2].checked == true) {
			//中标
			$("#serviceExpense").removeAttr("disabled");
			$("#serviceExpense").css('background-color', 'transparent');
			$("#star2").css('visibility', 'visible');
		} else {
			//其他
			$("#serviceExpense").attr("disabled", "disabled");
			$("#serviceExpense").css('background-color', '#eee');
			$("#serviceExpense").val("");
			$("#star2").css('visibility', 'hidden');
		}
	} */

	function getDateStr(date) {
		var y = date.getFullYear();
		var m = date.getMonth() < 10 ? ("0" + (date.getMonth() + 1)) : (date
				.getMonth() + 1);
		var d = date.getDate() < 10 ? ("0" + date.getDate()) : date.getDate();
		var str = y + "/" + m + "/" + d;
		return str;
	}

	function initDate() {
		$('#dd').calendar({
			trigger : '#dateForBuy',
			zIndex : 999,
			format : 'yyyy/mm/dd',
			onSelected : function(view, date, data) {
			},
			onClose : function(view, date, data) {
				$('#dateForBuy').val(getDateStr(date));
			}
		});

		$('#dd2').calendar({
			trigger : '#dateForSubmit',
			zIndex : 999,
			format : 'yyyy/mm/dd',
			onSelected : function(view, date, data) {
			},
			onClose : function(view, date, data) {
				$('#dateForSubmit').val(getDateStr(date));
			}
		});
	}

	

	function back() {
		history.back();
	}

	function printTender() {
		$("#div1").jqprint();
	}
	
	
	function editTender() {
		if (tenderState == 1) {
			alert("拒绝的标书不能编辑");
			return;
		}else if(user != createUser){
			alert("他人的标书你不能编辑");
			return;
		}
		
		var tenderNum = $("#tenderNum").val();
		var tenderCompany = $("#tenderCompany option:selected").text();
		var tenderAgency = $("#tenderAgency option:selected").text();
		var projectName = $("#projectName").val();
		var dateForBuy = $("#dateForStartContract").val();
		var dateForSubmit = $("#dateForSubmit").val();

		var tenderStyle1 = $("#tenderStyle1 option:selected").text();
		var tenderStyle2 = $("#tenderStyle2 option:selected").text();
		var saleUser = $("#saleUser option:selected").text();
		var tenderExpense = $("#tenderExpense").val();
		var serviceExpense = $("#serviceExpense").val();
		var reasonForNoTender = $("#reasonForNoTender").val();

		var productStyle = $("#productStyle option:selected").text();
		var productBrand = $("#productBrand option:selected").text();

		var enterpriseQualificationRequirment = $(
				"#enterpriseQualificationRequirment").val();
		var technicalRequirment = $("#technicalRequirment").val();
		var remark = $("#remark").val();

		if (tenderNum == "") {
			alert("招标编号不能为空");
			return;
		}

		if (tenderCompany == "请选择...") {
			alert("请选择招标单位");
			return;
		}

		if (tenderAgency == "请选择...") {
			tenderAgency = "";
		}

		if (projectName == "") {
			alert("项目名称不能为空");
			return;
		}

		var d1 = new Date(dateForBuy);
		var d2 = new Date(dateForSubmit);

		if (d1 > d2) {
			alert("错误：投标日期早于购标日期，请修改");
			return;
		} else if (d1 - d2 == 0) {
			alert("错误：投标日期和购标日期同一天，请修改");
			return;
		}

		if (tenderStyle1 == "请选择..." || tenderStyle2 == "请选择...") {
			alert("请正确选择投标类型");
			return;
		}

		if (saleUser == "请选择...") {
			alert("请选择对影销售");
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

		if (serviceExpense == "" && tenderResult == 3) {
			alert("中标服务费不能为空");
			return;
		} else if (!r.test(serviceExpense) && serviceExpense != "") {
			alert("中标服务费有误，请重新输入");
			return;
		}

		if (tenderIntent == 2 && reasonForNoTender == "") {
			alert("不投原因不能为空");
			return;
		}

		if (productStyle == "请选择...") {
			productStyle = "";
		}

		if (productBrand == "请选择...") {
			productBrand = "";
		}

		$
				.ajax({
					url : "${pageContext.request.contextPath}/editTender",
					type : 'POST',
					cache : false,
					data : {
						"id" : id,
						"tenderNum" : tenderNum,
						"tenderCompany" : tenderCompany,
						"tenderAgency" : tenderAgency,
						"projectName" : projectName,
						"dateForBuy" : dateForBuy,
						"dateForSubmit" : dateForSubmit,
						"tenderStyle" : tenderStyle1 + "#" + tenderStyle2,
						"saleUser" : saleUser,
						"tenderExpense" : tenderExpense,
						"serviceExpense" : serviceExpense,
						"reasonForNoTender" : reasonForNoTender,
						"productStyle" : productStyle,
						"productBrand" : productBrand,
						"enterpriseQualificationRequirment" : enterpriseQualificationRequirment,
						"technicalRequirment" : technicalRequirment,
						"remark" : remark,
						"tenderResult" : tenderResult,
						"tenderIntent" : tenderIntent
					},
					success : function(returndata) {
						var data = eval("(" + returndata + ")").errcode;
						if (data == 0) {
							alert("编辑标书成功");
							window.location.reload();
						} else {
							alert("编辑失败");
						}

					},
					error : function(XMLHttpRequest, textStatus, errorThrown) {
					}
				});

	}
</script>

</head>
<body>
   <div>
		<form id="test" action="#" method="get">
			<div style="float: left; width: 100%;">
				<fieldset
					style="width: 95.5%; height: 700px; margin: 5px 0 5px 5px;">
					<legend>合同有关</legend>
					<div class="form-row">
						<div class="field-label" style="width: 130px">
							<label><Strong style="color: red">★ </Strong><Strong>合同编号：</Strong></label>
						</div>
						<div class="field-widget">
							<input id="contractNum" class="required" style="width: 510px;" />
						</div>
					</div>

					<div class="form-row">
						<div class="field-label" style="width: 130px">
							<label><Strong style="color: red">★ </Strong><Strong>项目名称：</Strong></label>
						</div>
						<div class="field-widget">
							<input id="projectName" class="required" style="width: 510px;" />
						</div>
					</div>

					<div class="form-row" style="width: 100%; height: auto">
						<div class="field-label" style="width: 130px">
							<label><Strong style="color: red">★ </Strong><Strong>合同实施日期：</Strong></label>
						</div>
						<div class="field-widget" style="width: 33.5%">
							<input class="required" type="text" id="dateForStartContract"
								style="width: 100%">
							<div id="dd"></div>
						</div>
						<div class="field-label" style="width: 5%; margin-left: 25px">
							<label style="width: 100%"><Strong>至</Strong></label>
						</div>
						<div class="field-widget" style="width: 33.5%">
							<input class="required" type="text" id="dateForEndContract"
								style="width: 100%">
							<div id="dd2"></div>
						</div>
					</div>

					<div class="form-row" style="width: 100%; height: auto">
						<div class="field-label" style="width: 130px">
							<label><Strong style="color: red">★ </Strong><Strong>销售人员：</Strong></label>
						</div>
						<div class="field-widget">
							<select id="saleUser" class="validate-selection"
								style="width: 515px">
							</select>
						</div>
					</div>

					<div class="form-row">
						<div class="field-label" style="width: 130px">
							<label><Strong style="color: red">★ </Strong><Strong>用户名称：</Strong></label>
						</div>
						<div class="field-widget">
							<select id="clientName" class="validate-selection"
								style="width: 515px">
							</select>
						</div>
					</div>

					<div class="form-row" style="width: 100%; height: auto">
						<div class="field-label" style="width: 130px">
							<label><Strong style="color: red">★ </Strong><Strong>合同金额(含税)：</Strong></label>
						</div>
						<div class="field-widget" style="width: 35%">
							<input id="contractAmount" class="required" style="width: 100%" />
						</div>
						<div class="field-label" style="width: 75px; margin-left: 25px">
							<label><Strong style="color: red;">★ </Strong><Strong>税率：</Strong></label>
						</div>
						<div class="field-label2" style="width: 80px">
							<input type="radio" name="field01" id="taxRate" value="1"
								checked="checked" onclick="checkTaxRate(1)" />6%
						</div>
						<div class="field-label2" style="width: 80px">
							<input type="radio" name="field01" id="taxRate" value="0"
								onclick="checkTaxRate(0)" />13%
						</div>
					</div>

					<div class="form-row">
						<div class="field-label" style="width: 130px">
							<label><Strong style="color: red;">★ </Strong><Strong>服务内容说明：</Strong></label>
						</div>
						<div class="field-widget">
							<textarea id="serviceDetails" class="required"
								style="resize: none; width: 510px; height: 140px; background-color: #fff"></textarea>
						</div>
					</div>

					<div class="form-row">
						<div class="field-label" style="width: 130px">
							<label><Strong style="color: red;">★ </Strong><Strong>收款说明：</Strong></label>
						</div>
						<div class="field-widget">
							<textarea id="collectionDetails" class="required"
								placeholder="时间节点&nbsp-&nbsp节点说明&nbsp-&nbsp收款方式&nbsp-&nbsp收款金额（比例）"
								style="resize: none; width: 510px; height: 120px; background-color: #fff"></textarea>
						</div>
					</div>

					<div class="form-row">
						<div class="field-label" style="width: 130px">
							<label><Strong style="color: red; visibility: hidden">★
							</Strong><Strong>合同交货：</Strong></label>
						</div>
						<div class="field-widget">
							<textarea id="deliveryDetails" class="required"
								placeholder="交货内容&nbsp-&nbsp要求交货期&nbsp-&nbsp实际交货期"
								style="resize: none; width: 510px; height: 120px; background-color: #fff"></textarea>
						</div>
					</div>

					<input type="button" class="reset" value="提交"
						style="margin-right: 20px; width: 60px; margin-top: 10px; float: right"
						onclick="EditContract()" />
				</fieldset>
			</div>

        </form>
	</div>

</body>
</html>