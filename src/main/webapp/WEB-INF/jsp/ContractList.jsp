<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="pragma" content="no-cache" />
<meta http-equiv="cache-control" content="no-cache" />
<title>合同信息管理</title>
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/css.css?v=1997" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/select4.css?v=1997" />
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/calendar.css" />

<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.2.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/select3.js"></script>

<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/validation.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/calendar.js"></script>
	<script src="${pageContext.request.contextPath}/js/changePsd.js"></script>
<style type="text/css">
a:hover {
	color: #FF00FF
} /* 鼠标移动到链接上 */

::-webkit-scrollbar{
display:none;
}

html {
	-ms-overflow-style: none;
	/*火狐下隐藏滚动条*/
	overflow: -moz-scrollbars-none;
}
</style>

<script type="text/javascript">
	var page;
	var lastPage;
	var deleteId;
	$(document).ready(function() {
		$("#companyId").select2({});
		$("#salesId").select2({});
		$("#projectId").select2({});
		getSaleUserList();
		getCompanyList();
		initDate();
		page = 1;
		getContractList(page);
	});

	function changeCompany(tCompanyId) {
		var salesId = getProjectList(tCompanyId);
		getSaleUserList();
		if (salesId != 0) {
			$("#salesId").val(salesId);
		}
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
				$("#projectId").empty();
				$("#projectId").append(str);

			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
		return mSalesId;
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
				"isHide":true
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
				$("#salesId").empty();
				$("#salesId").append(str);
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
	}

	function initDate() {
		$('#dd').calendar({
			trigger : '#date1',
			zIndex : 999,
			format : 'yyyy/mm/dd',
			onSelected : function(view, date, data) {
			},
			onClose : function(view, date, data) {
				$('#date1').val(formatDate(date).substring(0, 10));
			}
		});

		$('#dd2').calendar({
			trigger : '#date2',
			zIndex : 999,
			format : 'yyyy/mm/dd',
			onSelected : function(view, date, data) {
			},
			onClose : function(view, date, data) {
				$('#date2').val(formatDate(date).substring(0, 10));
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

	function getContractList(mPage) {
		page = mPage;
		var companyId = $("#companyId option:selected").val();
		companyId = (companyId == 0) ? "" : companyId;
		var projectId = $("#projectId option:selected").val().trim();
		projectId = (projectId == 0) ? "" : projectId;
		var salesId = $("#salesId option:selected").val();
		var contractNum = $("#contractNum").val().trim();
		var date1 = $("#date1").val();
		date1 = (date1 == "") ? "none" : date1;
		var date2 = $("#date2").val();
		date2 = (date2 == "") ? "none" : date2;

		if (new Date(date1) > new Date(date2) && date1 != "" && date2 != "") {
			alert("错误：第一个日期不能晚于第二个日期");
			return;
		}
		$
				.ajax({
					url : "${pageContext.request.contextPath}/getContractList",
					type : 'GET',
					data : {
						"contractNum" : contractNum,
						"projectId" : projectId,
						"dateForContract" : date1 + "-" + date2,
						"saleUser" : salesId,
						"companyId" : companyId
					},
					cache : false,
					async : false,
					success : function(returndata) {
						var data = eval("(" + returndata + ")").contractlist;
						var str = "";
						var num = data.length;
						if (num > 0) {
							lastPage = Math.ceil(num / 10);
							for ( var i in data) {
								if (i >= 10 * (mPage - 1)
										&& i <= 10 * mPage - 1) {
									str += '<tr style="width:1300px"><td style="width:14%" class="tdColor2">'
											+ data[i].contractNum
											+ '</td>'
											+ '<td style="width:40%" class="tdColor2">'
											+ getProject(data[i].projectId)
											+ '</br>'
											+ getCompany(data[i].companyId)
											+ '</td>'
											+ '<td style="width:10%" class="tdColor2">'
											+ getUser(data[i].saleUser)
											+ '</td>'
											+ '<td style="width:20%" class="tdColor2">'
											+ data[i].dateForContract
											+ '</td>'
											+ '<td style="width:8%" class="tdColor2">'
											+ '<a href="#" onclick="getPurchaseInfo(\''+ data[i].contractNum +'\')" >查看</a>'
											+ '</td>'
											+ '<td style="width:8%" class="tdColor2"><a href="../page/editContract/'+ data[i].id +'"><img class="operation" src="../image/update.png" title="编辑合同"></a>'
											/* + '<img class="operation delban" src="../image/delete.png" onclick="confirmDelete('
											+ data[i].id + ')">' */
											+'</td></tr>';
								}
							}
						} else {
							lastPage = 1;
							str += '<tr style="height:40px;text-align: center;"><td style="color:red;width:1300px;" border=0>没有你要找的合同</td></tr>';
						}
						document.getElementById('p').innerHTML = mPage + "/"
								+ lastPage;
						$("#tb").empty();
						$("#tb").append(str);
					},
					error : function(XMLHttpRequest, textStatus, errorThrown) {
					}
				});
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

	function getUser(uId) {
		var userName;
		$.ajax({
			url : "${pageContext.request.contextPath}/getUserById",
			type : 'GET',
			data : {
				"uId" : uId
			},
			cache : false,
			async : false,
			success : function(returndata) {
				userName = eval("(" + returndata + ")").user[0].name;
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
		return userName;
	}

	function nextPage() {
		if (page == lastPage) {
			alert("已经是最后一页");
			return;
		} else {
			page++;
			getContractList(page);
		}
	}

	function previousPage() {
		if (page == 1) {
			alert("已经是第一页");
			return;
		} else {
			page--;
			getContractList(page);
		}
	}

	function FirstPage() {
		if (page == 1) {
			alert("已经是首页");
			return;
		} else {
			page = 1;
			getContractList(page);
		}
	}

	function LastPage() {
		if (page == lastPage) {
			alert("已经是尾页");
			return;
		} else {
			page = lastPage;
			getContractList(page);
		}
	}
	
	function confirmDelete(id) {
		$(".banDel").show();
		deleteId = id;
	}
    
	function deleteContract() {
		$.ajax({
			url : "${pageContext.request.contextPath}/deleteContract",
			type : 'POST',
			data : {
				"id" : deleteId
			},
			cache : false,
			async : false,
			success : function(returndata) {
				var data = eval("(" + returndata + ")").errcode;
				if (data == 0) {
					alert("删除成功");
					setTimeout(function() {
						location.reload();
					}, 500);

				} else {
					alert("删除失败");
				}

			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
	}

	function getPurchaseInfo(cNum) {
		alert(cNum);
		/* var mHtml = '<div style="margin-top:10px;width:100%"><label><Strong>项目编号：</Strong>'
				+ arrayProjectNum[pNum]
				+ '</label></div><br/>'
				+ '<div style="margin-top:10px;width:100%"><label><Strong>项目名称：</Strong>'
				+ arrayProjectName[pNum]
				+ '</label></div><br/>'
				+ '<div style="margin-top:10px;width:100%"><label><Strong>是否需要采购：</Strong></label></div>'
				+ '<input type="radio" name="field002" disabled="disabled"/>是'
				+ '<input type="radio" name="field002" disabled="disabled" style="margin-left:100px;"/>否'
				+ '<div style="margin-top:5px;width:100%"><label><Strong>采购明细：</Strong></label><label style="color:red">设备序列号&nbsp-&nbsp设备型号&nbsp-&nbsp设备数量&nbsp-&nbsp预估到货时间&nbsp-&nbsp实际到货时间</label></div><br/>'
				+ '<div style="width:100%"><textarea id="purchaseDetails" style="resize: none; width: 98%; height: 92px; margin-top:5px"></textarea></div><br/>'

		swal({
			title : '采&nbsp&nbsp购&nbsp&nbsp信&nbsp&nbsp息',
			html : mHtml,
			showCloseButton : true,
			showConfirmButton : false,
			allowOutsideClick : false,
		}) */
	}
</script>

</head>
<body>
	<div id="pageAll">
		<div class="pageTop">
			<div class="page">
				<img src="../image/coin02.png" /><span><a href="#">首页</a>&nbsp;-&nbsp;<a
					href="#">合同管理</a>&nbsp;-</span>&nbsp;合同信息管理
			</div>
		</div>

		<div class="page">
			<!-- vip页面样式 -->
			<div class="vip">
				<div class="conform">
					<form style="width: 100%">
						<div class="cfD" style="width: 100%">
							<Strong style="margin-right: 20px">查询条件：</Strong> <label
								style="margin-right: 10px">客户名称：</label><select class="selCss"
								style="width: 25%" id="companyId"
								onChange="changeCompany(this.options[this.options.selectedIndex].value)" /></select>
							<label style="margin-right: 10px">项目名称：</label><select
								class="selCss" style="width: 25%" id="projectId">
								<option value="0">请选择...</option>
							</select>

						</div>
						<div class="cfD" style="width: 100%">
							<label style="margin-left: 114px; margin-right: 10px">销售人员：</label><select
								class="selCss" style="width: 25%" id="salesId"></select> <label
								style="margin-left: 20px">合同编号：</label><input type="text"
								class="input3" placeholder="输入合同编号" style="width: 24%"
								id="contractNum" />
						</div>
						<div class="cfD">
							<label style="margin-left: 86px;">合同实施日期：</label><input
								type="text" id="date1" style="width: 8%" class="input3"
								placeholder="0000/00/00"/> <span id="dd"></span><Strong
								style="margin-left: 15px; margin-right: 10px">至</Strong> <input
								type="text" id="date2" style="width: 8%" class="input3"
								placeholder="0000/00/00"/> <span id="dd2"></span> <a
								class="addA" href="../page/createContract"
								style="margin-left: 40px">新建合同信息+</a><a class="addA"
								onClick="getContractList(1)">搜索</a>
						</div>

					</form>
				</div>
				<!-- vip 表格 显示 -->
				<div class="conShow">
					<table border="1" style="width: 100%">
						<tr style="width: 100%">
							<td style="width: 14%" class="tdColor">合同编号</td>
							<td style="width: 40%" class="tdColor">项目名称 / 客户名称</td>
							<td style="width: 10%" class="tdColor">销售人员</td>
							<td style="width: 20%" class="tdColor">合同实施日期</td>
							<td style="width: 8%" class="tdColor">采购信息</td>
							<td style="width: 8%" class="tdColor">操作</td>
						</tr>

					</table>
					<table id="tb" border="1" style="width: 100%">
					</table>
					<div class="paging" style="margin-top: 20px; margin-bottom: 50px;">
						<input type="button" class="submit" value="首页"
							style="margin-left: 10px; width: 60px;" onclick="FirstPage()" />
						<input type="button" class="submit" value="上一页"
							style="margin-left: 10px; width: 60px;" onclick="previousPage()" />
						<input type="button" class="submit" value="下一页"
							style="margin-left: 10px; width: 60px;" onclick="nextPage()" />
						<input type="button" class="submit" value="尾页"
							style="margin-left: 10px; width: 60px;" onclick="LastPage()" />
						<span style="margin-left: 10px;">当前页：</span> <span id="p">0/0</span>
					</div>
				</div>
				<!-- vip 表格 显示 end-->
			</div>
			<!-- vip页面样式end -->
		</div>

	</div>

<!-- 删除弹出框 -->
	<div class="banDel">
		<div class="delete">
			<div class="close">
				<a><img src="../image/shanchu.png" onclick="closeConfirmBox()" /></a>
			</div>
			<p class="delP1">你确定要删除此条合同记录吗？</p>
			<p class="delP2">
				<a href="#" class="ok yes" onclick="deleteContract()">确定</a><a
					class="ok no" onclick="closeConfirmBox()">取消</a>
			</p>
		</div>
	</div>
	<!-- 删除弹出框  end-->
</body>
</html>