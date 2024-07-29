<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="pragma" content="no-cache" />
<meta http-equiv="cache-control" content="no-cache" />
<title>客户信息管理</title>
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/css.css?v=1990" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/select4.css?v=1997" />
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.2.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/select3.js"></script>
<script src="${pageContext.request.contextPath}/js/checkPermission.js"></script>
<script src="${pageContext.request.contextPath}/js/changePsd.js"></script>
<script src="${pageContext.request.contextPath}/js/commonUtils.js"></script>
<script src="${pageContext.request.contextPath}/js/getObjectList.js"></script>
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
</style>
<script type="text/javascript">
	var page;
	var lastPage;
	var deleteId;
	var sId;
	var host;
	var isPermissionEdit;
	var isPermissionDelete;
	var isPermissionEditArr;
	var isFmlkShare;

	$(document).ready(function() {
		sId = "${sessionId}";
		host = "${pageContext.request.contextPath}";
		checkEditPremission(3, 4);
	});

	function initialPage() {
		var isCheck = document.getElementsByName('field03');
		isFmlkShare = isCheck[0].checked;
		$("#salesId").select2({});
		setTimeout(function() {
			getMyCompanyList(1);
		}, 500);
		getSalesList(0);
	}

	function getMyCompanyList(mPage) {
		page = mPage;
		var mCompanyName = $("#companyName").val().trim();
		var mSalesId = $("#salesId").val();
		mSalesId = (mSalesId == null) ? 0 : mSalesId;
		$
				.ajax({
					url : host + "/companyList",
					type : 'GET',
					data : {
						"companyName" : mCompanyName,
						"salesId" : mSalesId,
						"isFmlkShare":isFmlkShare
					},
					cache : false,
					async : false,
					success : function(returndata) {
						var data = eval("(" + returndata + ")").companylist;
						var str = "";
						var num = data.length;
						var companyArr = new Array();//销售数组
						if (num > 0) {
							lastPage = Math.ceil(num / 10);
							for ( var i in data) {
								if (i >= 10 * (mPage - 1)
										&& i <= 10 * mPage - 1) {
									companyArr.push(data[i].salesId);
									str += '<tr style="width:100%"><td style="width:49%" class="tdColor2">'
											+ data[i].companyName
											+ '</td>'
											+ '<td style="width:10%" class="tdColor2">'
											+ getUser(data[i].salesId).name
											+ '</td>'
											+ '<td style="width:15%" class="tdColor2">'
											+ getField(data[i].fieldId).clientField
											+ '</td>'
											+ '<td style="width:10%" class="tdColor2">'
											+ getArea(data[i].areaId).areaName
											+ '</td>'
											+ '<td style="width:8%" class="tdColor2">'
											+ '<img name="img_edit" title="查看" style="vertical-align:middle" class="operation" src="../image/update.png" onclick="toEditCompanyPage('
											+ data[i].id
											+ ')"/><a name="a_edit" style="vertical-align:middle" onclick="toEditCompanyPage('
											+ data[i].id
											+ ')">查看</a></td>'
											+ '<td style="width:8%;" class="tdColor2">'
											+ '<img title="删除" style="vertical-align:middle" class="operation delban" src="../image/delete.png" onclick="confirmDelete('
											+ data[i].id
											+ ')"><a style="vertical-align:middle" onclick="confirmDelete('
											+ data[i].id
											+ ')">删除</a></td></tr>';
								}
							}
						} else {
							lastPage = 1;
							str += '<tr style="height:40px;text-align: center;"><td style="color:red;width:1300px;" border=0>没有你要找的客户</td></tr>';
						}
						document.getElementById('p').innerHTML = mPage + "/"
								+ lastPage;
						$("#tb").empty();

						$("#tb").append(str);
						matchUserPremission(companyArr,0);
					},
					error : function(XMLHttpRequest, textStatus, errorThrown) {
					}
				});
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

	function getField(mFieldId) {
		var field;
		$.ajax({
			url : host + "/getClientField",
			type : 'GET',
			data : {
				"fieldId" : mFieldId
			},
			cache : false,
			async : false,
			success : function(returndata) {
				field = eval("(" + returndata + ")").clientField[0];
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
		return field;
	}

	function getArea(mAreaId) {
		var area;
		$.ajax({
			url : host + "/getArea",
			type : 'GET',
			data : {
				"areaId" : mAreaId
			},
			cache : false,
			async : false,
			success : function(returndata) {
				area = eval("(" + returndata + ")").area[0];
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
		return area;
	}

	function confirmDelete(id) {
		if (!isPermissionDelete) {
			alert("你没有权限删除客户");
		} else {
			$(".banDel").show();
			deleteId = id;
		}
	}

	function deleteCompany() {
		$.ajax({
			url : host + "/deleteCompany",
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
						toReloadPage();
					}, 500);

				} else {
					alert("删除失败");
				}

			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
	}

	function nextPage() {
		if (page == lastPage) {
			alert("已经是最后一页");
			return;
		} else {
			page++;
			getMyCompanyList(page);
		}
	}

	function previousPage() {
		if (page == 1) {
			alert("已经是第一页");
			return;
		} else {
			page--;
			getMyCompanyList(page);
		}
	}

	function FirstPage() {
		if (page == 1) {
			alert("已经是首页");
			return;
		} else {
			page = 1;
			getMyCompanyList(page);
		}
	}

	function LastPage() {
		if (page == lastPage) {
			alert("已经是尾页");
			return;
		} else {
			page = lastPage;
			getMyCompanyList(page);
		}
	}
	
	function checkCompanyType(type){
		isFmlkShare = type==2;
		getSalesList(0);
		$("#companyName").val("");
		setTimeout(function() {
			getMyCompanyList(1);
		}, 1000);
	}
	
	function matchUserPremission(objectArr,i){
		if (objectArr.length > 0 && isPermissionEdit) {
			isPermissionEditArr = new Array();
			var xhr = createxmlHttpRequest();
			xhr.open("GET", host + "/getUserByNickName?nickName=" + sId, true);
			xhr.onreadystatechange = function() {
				if (this.readyState == 4) {
					var data = eval("(" + xhr.responseText + ")").user;
					var tId = data[0].UId;
					var tRoleId = data[0].roleId;
					var arrImg = document.getElementsByName("img_edit");
					for (var j = 0; j < arrImg.length; j++) {
						if (objectArr[j] == tId || tRoleId == 11 || tRoleId == 3 || tRoleId == 4) {
							//管理员，销售经理，销售副经理，销售
							isPermissionEditArr.push(true);
							arrImg[j].setAttribute("title", "编辑");
							document.getElementsByName("a_edit")[j].innerHTML = "编辑";
						} else {
							isPermissionEditArr.push(false);
						}
					}
				}
			};
			xhr.send();
		}
	}
</script>
</head>

<body>
	<div id="pageAll">
		<div class="pageTop">
			<div class="page">
				<img src="../image/coin02.png" /><span><a href="#">首页</a>&nbsp;-&nbsp;<a
					href="#">客户关系管理</a>&nbsp;-</span>&nbsp;客户信息管理
			</div>
		</div>

		<div class="page">
			<!-- vip页面样式 -->
			<div class="vip">
				<div class="conform">
					<form>
						<div class="cfD">
							<Strong style="margin-right: 20px">查询条件：</Strong> <label>客户全称：</label><input
								type="text" class="input3" placeholder="输入客户全称"
								style="margin-right: 20px" id="companyName" /> <label>销售人员：</label><select
								class="selCss" style="margin-right: 40px" id="salesId" /></select>
						</div>
						<div class="cfD">
							<input type="radio" name="field03" value="2" checked="checked"
						onclick="checkCompanyType(2)"
						style="margin-left: 110px; " /> <label>共享陪护</label>
					    <input type="radio" name="field03" value="1" 
						onclick="checkCompanyType(1)"
						style="margin-left: 20px; " /> <label>信息</label>
							<a class="addA" href="#" onclick="toCreateCompanyPage()"
								style="margin-left: 150px">新建客户+</a> <a class="addA" href="#"
								onClick="getMyCompanyList(1)">搜索</a>
						</div>
						
					</form>
				</div>
				<!-- vip 表格 显示 -->
				<div class="conShow">
					<table border="1" style="width: 100%">
						<tr style="width: 100%">
							<td style="width: 49%" class="tdColor">客户全称</td>
							<td style="width: 10%" class="tdColor">销售人员</td>
							<td style="width: 15%" class="tdColor">所在行业</td>
							<td style="width: 10%" class="tdColor">所在地区</td>
							<td style="width: 16%" class="tdColor">操作</td>
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
			<p class="delP1">你确定要删除此条客户记录吗？</p>

			<div class="cfD" style="margin-top: 30px">
				<a class="addA" href="#" onclick="deleteCompany()"
					style="margin-left: 0px; margin-bottom: 30px;">确定</a> <a
					class="addA" onclick="closeConfirmBox()">取消</a>
			</div>

		</div>
	</div>
</body>
</html>