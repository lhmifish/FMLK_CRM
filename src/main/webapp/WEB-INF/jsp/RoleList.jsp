<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="pragma" content="no-cache" />
<meta http-equiv="cache-control" content="no-cache" />
<title>角色管理</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/select4.css?v=1997" />
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/css.css?v=1990" />
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/xcConfirm.css?v=2099" />
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.2.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/select3.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/validation.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/xcConfirm.js?v=2018"></script>
	<script src="${pageContext.request.contextPath}/js/changePsd.js"></script>
<style type="text/css">
a:hover {
	color: #FF00FF
} /* 鼠标移动到链接上 */

.xcConfirm .popBox {
	background-color: #ffffff;
	width: 800px;
	height: 660px;
	border-radius: 5px;
	font-weight: bold;
	color: #535e66;
	top: 160px;
	margin-left: -400px;
	position: absolute;
}

.xcConfirm .popBox .txtBox {
	margin: 15px 15px;
	height: 500px;
}

.xcConfirm .popBox .txtBox p {
	height: 500px;
	margin: 5px;
	line-height: 16px;
	overflow-x: hidden;
	overflow-y: auto;
}

::-webkit-scrollbar{
display:none;
}
</style>
<script type="text/javascript">
	var page;
	var lastPage;
	var editId;
	var arrayDept;

	$(document).ready(function() {
		$("#departmentId").select2({});
		getDepartmentList();
		page = 1;
		getRoleList(page);
	});

	function getDepartmentList() {
		
		arrayDept = new Array();
		$.ajax({
			url : "${pageContext.request.contextPath}/departmentList",
			type : 'GET',
			data : {},
			cache : false,
			async : false,
			success : function(returndata) {
				var str = '<option value="0">请选择...</option>';
				var data2 = eval("(" + returndata + ")").dList;
				for ( var i in data2) {
					str += '<option value="'+data2[i].id+'">'
							+ data2[i].departmentName + '</option>';
					arrayDept.push(data2[i].id+"#"+data2[i].departmentName);
				}
				$("#departmentId").empty();
				$("#departmentId").append(str);

			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
	}

	function getRoleList(mPage) {
		$
				.ajax({
					url : "${pageContext.request.contextPath}/roleList",
					type : 'GET',
					data : {},
					cache : false,
					async : false,
					success : function(returndata) {
						var data = eval("(" + returndata + ")").roleList;
						var str = "";
						var num = data.length;
						lastPage = Math.ceil(num / 10);
						for ( var i in data) {
							if (i >= 10 * (mPage - 1) && i <= 10 * mPage - 1) {
								str += '<tr style="width:100%"><td style="width:20%" class="tdColor2">'
										+ '<input type="text" id="roleName_'
										+ data[i].id
										+ '" style="text-align: center; font-weight: bold;width: 90%; '
										+ 'border-bottom: 1px dashed #78639F; background: none; border-left: none; '
										+ 'border-right: none; border-top: none; border-left-width: 2px; '
										+ 'padding: 5px 0 0 2px; padding-left: 10px;" value="'
										+ data[i].roleName
										+ '"/></td>'
										+ '<td style="width:20%" class="tdColor2">'
										+ getDepartment(data[i].departmentId)
										+ '</td>'
										+ '<td style="width:60%" class="tdColor2"><div style="width: 100%">'
										+ '<div style="width: 33%; float: left; border-right: 1px dashed #78639F">'
										+ '<img title="更新角色名称" class="operation" style="vertical-align:middle" src="../image/update.png"/><a style="vertical-align:middle" href="#" onclick="editRole('
										+ data[i].id
										+ ')">更新角色名称</a></div>'
										+ '<div style="width: 33%; float: left; border-right: 1px dashed #78639F">'
										+ '<img title="配置用户" class="operation" style="vertical-align:middle" src="../image/update.png"/><a style="vertical-align:middle" href="#" onclick="editUserRole('
										+ data[i].id
										+ ','
										+ data[i].departmentId
										+ ',\''
										+ data[i].roleName
										+ '\')">配置用户</a></div>'
										+ '<div style="width: 33%; float: left;">'
										+ '<img title="配置角色权限" class="operation" style="vertical-align:middle" src="../image/update.png"/><a style="vertical-align:middle" href="#" onclick="editRolePermission('
										+ data[i].id
										+ ',\''
										+ data[i].roleName
										+ '\')">配置角色权限</a></div>'
										+ '</div></td>' + '</tr>';
							}
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

	function editRolePermission(rId, rName) {
		
		$.ajax({
			url : "${pageContext.request.contextPath}/rolePermissionList",
			type : 'GET',
			data : {},
			cache : false,
			async : false,
			success : function(returndata) {
				var data = eval("(" + returndata + ")").rpList;
				var companyPermissionArr = new Array();
				var projectPermissionArr = new Array();
				var projectCasePermissionArr = new Array();
				var tenderPermissionArr = new Array();
				var contractPermissionArr = new Array();
				var userPermissionArr = new Array();
				var sysPermissionArr = new Array();
				var attendancePermissionArr = new Array();

				for (var i = 0; i < data.length; i++) {
					if (data[i].type == 1) {
						companyPermissionArr.push(data[i].id + "#"
								+ data[i].permissionDesc);
					} else if (data[i].type == 2) {
						projectPermissionArr.push(data[i].id + "#"
								+ data[i].permissionDesc);
					} else if (data[i].type == 3) {
						projectCasePermissionArr.push(data[i].id + "#"
								+ data[i].permissionDesc);
					} else if (data[i].type == 4) {
						tenderPermissionArr.push(data[i].id + "#"
								+ data[i].permissionDesc);
					} else if (data[i].type == 5) {
						contractPermissionArr.push(data[i].id + "#"
								+ data[i].permissionDesc);
					} else if (data[i].type == 6) {
						userPermissionArr.push(data[i].id + "#"
								+ data[i].permissionDesc);
					} else if (data[i].type == 7) {
						sysPermissionArr.push(data[i].id + "#"
								+ data[i].permissionDesc);
					} else if (data[i].type == 8) {
						attendancePermissionArr.push(data[i].id + "#"
								+ data[i].permissionDesc);
					}
				}

				var mDiv = '<div><table style="width: 100%">';
				var cpline = getLine(companyPermissionArr, "所有客户信息管理", 1, rId);
				mDiv += cpline;
				var ppline = getLine(projectPermissionArr, "所有项目管理", 2, rId);
				mDiv += ppline;
				var pcpline = getLine(projectCasePermissionArr, "所有派工管理", 3,
						rId);
				mDiv += pcpline;
				var tpline = getLine(tenderPermissionArr, "所有招标管理", 4, rId);
				mDiv += tpline;
				var copline = getLine(contractPermissionArr, "所有合同管理", 5, rId);
				mDiv += copline;
				var upline = getLine(userPermissionArr, "所有用户管理", 6, rId);
				mDiv += upline;
				var spline = getLine(sysPermissionArr, "所有系统管理", 7, rId);
				mDiv += spline;
				var apline = getLine(attendancePermissionArr, "所有考勤管理", 8, rId);
				mDiv += apline;

				mDiv += '</table></div>';
				
				//alert(mDiv);

				window.wxc.xcConfirm(mDiv, {
					title : "配置角色权限：" + rName,
					btn : parseInt("0011", 2)
				}, {
					onOk : function() {
						var permissionArray = new Array();
						$("input[name='permissionOption']").each(
								function(index, item) {
									var pId = item.id.substring(1,
											item.id.length);
									var isChecked = item.checked == true ? 1
											: 0;
									var roleId = item.getAttribute("role");
									permissionArray.push(pId + "#" + isChecked
											+ "#" + roleId);
								});
						updatePermissionSetting(permissionArray, rId);
					}
				});
			}
		});
		getCheckedPermission(rId);
	}

	function updatePermissionSetting(mPermissionArray, mRoleId) {
		for (var i = 0; i < mPermissionArray.length; i++) {
			var permissionId = mPermissionArray[i].split("#")[0];
			var isChecked = mPermissionArray[i].split("#")[1];
			//setting时roleId已更改
			var roleId = mPermissionArray[i].split("#")[2];
			var needUpdate = false;

			var mData;
			if (isChecked == 1) {
				//选中的
				if (roleId == mRoleId) {
					//原来没选中的 create
					needUpdate = true;
					mData = {
						"roleId" : mRoleId,
						"permissionId" : permissionId,
						"operation" : 1
					};
				}
			} else {
				//没选中的
				if (roleId != mRoleId) {
					//原来选中的 delete
					needUpdate = true;
					mData = {
						"roleId" : mRoleId,
						"permissionId" : permissionId,
						"operation" : 2
					};
				}
			}
			if (needUpdate) {
				$
						.ajax({
							url : "${pageContext.request.contextPath}/updatePermissionSetting",
							type : 'POST',
							cache : false,
							data : mData,
							success : function(returndata) {
								var data = eval("(" + returndata + ")").errcode;
								if (data == 0) {
								} else {
									alert("配置角色权限错误");
									return;
								}
							},
							error : function(XMLHttpRequest, textStatus,
									errorThrown) {
							}
						});
			}
		}
		alert("配置角色权限成功");
	//	document.body.style.overflow='visible';
	}

	function getCheckedPermission(mRoleId) {
		$.ajax({
			url : "${pageContext.request.contextPath}/permissionSettingList",
			type : 'GET',
			data : {
				"roleId" : mRoleId
			},
			cache : false,
			async : false,
			success : function(returndata) {
				var data = eval("(" + returndata + ")").permissionSettingList;
				for ( var i in data) {
					var pId = data[i].permissionId;
					document.getElementById('p' + pId).setAttribute("role",
							"r" + data[i].roleId);
					$('#p' + pId).prop("checked", "checked");
				}
				var option = document.getElementsByName('permissionOption');
				for (var i = 1; i <= 8; i++) {
					var selAll = true;
					for (var j = 0; j < option.length; j++) {
						if (option[j].getAttribute("mType") == i
								&& option[j].checked == false) {
							selAll = false;
							break;
						}
					}
					if (selAll) {
						$('#allPermissionType' + i).prop("checked", "checked");
					}
				}
			}
		});
	}

	function selTypeAllPermissionSetting(type) {
		var isCheck = document.getElementById('allPermissionType' + type);
		var option = document.getElementsByName('permissionOption');
		if (isCheck.checked == true) {
			for (var i = 0; i < option.length; i++) {
				if (option[i].getAttribute("mType") == type) {
					option[i].checked = "checked";
				}
			}
		} else {
			for (var i = 0; i < option.length; i++) {
				if (option[i].getAttribute("mType") == type) {
					option[i].checked = false;
				}
			}
		}
	}

	function selPermissionOption(type) {
		var option = document.getElementsByName('permissionOption');
		var selAll = document.getElementById('allPermissionType' + type).checked;
		if (selAll) {
			$('#allPermissionType' + type).prop("checked", false);
		} else {
			//原来没有选中
			selAll = true;
			for (var i = 0; i < option.length; i++) {
				if (option[i].getAttribute("mType") == type
						&& option[i].checked == false) {
					selAll = false;
					break;
				}
			}
			if (selAll) {
				$('#allPermissionType' + type).prop("checked", "checked");
			}
		}
	}

	function getLine(mPermissionArr, mTitle, mType, mRoleId) {
		var line = Math.ceil(mPermissionArr.length / 3);
		var tDiv = "";
		for (var i = 0; i < line; i++) {
			tDiv += '<tr style="width: 100%">';
			for (var j = 3 * i; j < 3 * (i + 1); j++) {
				var div;
				if (j < mPermissionArr.length) {
					div = '<td style="width: 25%;border: none;text-align:left"><input id="p'
							+ mPermissionArr[j].split("#")[0]
							+ '" type="checkbox" style="width:16px;height:16px" mType="'
							+ mType
							+ '" name="permissionOption" role="'
							+ mRoleId
							+ '" onclick="selPermissionOption('
							+ mType
							+ ')"/>'
							+ '<span style="font-size: 14px;position: relative;bottom: 2px;margin-left:5px;">'
							+ mPermissionArr[j].split("#")[1] + '</span></td>';
				}
				var divNull = '<td style="width: 25%;border: none"></td>';

				if (i == 0) {
					//第一行
					if (j % 3 == 0) {
						tDiv += '<td style="width: 25%;border: none;text-align:left;color:#0095d9"><input type="checkbox" style="width:16px;height:16px" id="allPermissionType'
								+ mType
								+ '" onclick="selTypeAllPermissionSetting('
								+ mType
								+ ')"/>'
								+ '<span style="font-size: 16px;position: relative;bottom: 2px;margin-left:5px;">'
								+ mTitle + '</span></td>' + div;
					} else if (j % 3 == 2) {
						tDiv += div + "</tr>";
					} else {
						tDiv += div;
					}
				} else if (i == line - 1) {
					// 最后一行
					if (j % 3 == 0) {
						tDiv += divNull + div;
					} else if (j < mPermissionArr.length) {
						tDiv += div;
					} else {
						for (var z = 0; z < (3 * line - mPermissionArr.length); z++) {
							tDiv += divNull;
						}
					}
					if (j == 3 * line - 1) {
						tDiv += "</tr>";
					}
				} else {
					if (j % 3 == 0) {
						tDiv += divNull + div;
					} else if (j % 3 == 2) {
						tDiv += div + "</tr>";
					} else {
						tDiv += div;
					}
				}
			}

		}

		return tDiv;
	}

	function getDepartment(dpartId) {
		var retDept = "";
		for(var i=0;i<arrayDept.length;i++){
			if(arrayDept[i].split("#")[0]==dpartId){
				retDept = arrayDept[i].split("#")[1];
				break;
			}
		}
		return retDept;
	}

	function createRole() {
		var roleName = $("#roleName").val().trim();
		var departmentId = $("#departmentId option:selected").val();

		if (roleName == "") {
			alert("角色名称不能为空");
			return;
		}

		if (departmentId == 0) {
			alert("请选择所属部门");
			return;
		}

		$.ajax({
			url : "${pageContext.request.contextPath}/createNewRole",
			type : 'POST',
			cache : false,
			data : {
				"roleName" : roleName,
				"departmentId" : departmentId
			},
			success : function(returndata) {
				var data = eval("(" + returndata + ")").errcode;
				if (data == 0) {
					alert("新建角色成功");
					window.location.reload();
				} else if (data == 3) {
					alert("改角色已存在,请勿重复录入");
				} else {
					alert("新建失败");
				}
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
	}

	function editRole(rId) {
		var roleName = $("#roleName_" + rId).val().trim();
		if (roleName == "") {
			alert("角色名称不能为空");
			return;
		}
		$.ajax({
			url : "${pageContext.request.contextPath}/editRole",
			type : 'POST',
			cache : false,
			data : {
				"roleName" : roleName,
				"roleId" : rId
			},
			success : function(returndata) {
				var data = eval("(" + returndata + ")").errcode;
				if (data == 0) {
					alert("更新成功");
					getRoleList(page);
				} else {
					alert("更新失败");
				}
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
	}

	function editUserRole(rId, rDepartmentId, rName) {
		$
				.ajax({
					url : "${pageContext.request.contextPath}/userList",
					type : 'GET',
					data : {
						"dpartId" : rDepartmentId,
						"date" : formatDate(new Date()).substring(0, 10),
						"name" : "",
						"nickName" : "",
						"jobId" : "",
						"isHide" : true
					},
					cache : false,
					async : false,
					success : function(returndata) {
						var data = eval("(" + returndata + ")").userlist;
						var mDiv = '<div><table style="width: 100%">';
						var trline = Math.ceil(data.length / 5);
						for (var i = 0; i < trline; i++) {
							mDiv += '<tr style="width: 100%">';
							if (i != trline - 1) {
								//非最后一行
								for (var j = 5 * i; j < 5 * (i + 1); j++) {
									mDiv += '<td style="width: 20%;border: none;text-align:left"><input type="checkbox" role="'+ data[j].roleId +'" id="u'+ data[j].UId +'" name = "'+ data[j].nickName +'" style="width:16px;height:16px"/>'
											+ '<span style="font-size: 10px;position: relative;bottom: 2px;margin-left:5px;">'
											+ data[j].name + '</span></td>'
								}
								mDiv += '</tr>';
							} else {
								for (var j = 5 * (trline - 1); j < data.length; j++) {
									mDiv += '<td style="width: 20%;border: none;text-align:left"><input type="checkbox" role="'+ data[j].roleId +'" id="u'+ data[j].UId +'" name = "'+ data[j].nickName +'" style="width:16px;height:16px"/>'
											+ '<span style="font-size: 10px;position: relative;bottom: 2px;margin-left:5px;">'
											+ data[j].name + '</span></td>'
								}
								for (var z = 0; z < (5 * trline - data.length); z++) {
									mDiv += '<td style="width: 20%;border: none"></td>'
								}
								mDiv += '</tr><tr style="width: 100%"></tr></table></div>';
							}
						}

						window.wxc
								.xcConfirm(
										mDiv,
										{
											title : "配置用户：" + rName,
											btn : parseInt("0011", 2)
										},
										{
											onOk : function() {
												var userArray = new Array();
												$("input[type='checkbox']")
														.each(
																function(index,
																		item) {
																	var mId = item.id
																			.substring(
																					1,
																					item.id.length);
																	var mRoleId = document
																			.getElementById(
																					item.id)
																			.getAttribute(
																					"role");
																	var mName = item.name;
																	var isChecked = item.checked == true ? 1
																			: 0;
																	userArray
																			.push(mId
																					+ "#"
																					+ mRoleId
																					+ "#"
																					+ mName
																					+ "#"
																					+ isChecked);
																});
												updateUserRole(userArray, rId);
											}
										});

						for (k = 0; k < data.length; k++) {
							if (data[k].roleId == rId) {
								$('#u' + data[k].UId)
										.prop("checked", "checked");
							}
						}
					},
					error : function(XMLHttpRequest, textStatus, errorThrown) {
					}
				});

	}

	function updateUserRole(mArray, mRId) {
		for (var i = 0; i < mArray.length; i++) {
			var uid = mArray[i].split("#")[0];
			var pRId = mArray[i].split("#")[1];
			var nickName = mArray[i].split("#")[2];
			var isChecked = mArray[i].split("#")[3];
			var needUpdate = false;
			var mData;
			if (isChecked == 1) {
				//选中的
				if (pRId != mRId) {
					needUpdate = true;
					mData = {
						"name" : "",
						"nickName" : nickName,
						"psd" : "",
						"email" : "",
						"departmentId" : 0,
						"tel" : "",
						"id" : uid,
						"state" : "",
						"roleId" : mRId
					};
				}
			} else {
				//没选中的
				if (pRId == mRId) {
					needUpdate = true;
					mData = {
						"name" : "",
						"nickName" : nickName,
						"psd" : "",
						"email" : "",
						"departmentId" : 0,
						"tel" : "",
						"id" : uid,
						"state" : "",
						"roleId" : 0
					};
				}
			}
			if (needUpdate) {
				$.ajax({
					url : "${pageContext.request.contextPath}/editUser",
					type : 'POST',
					cache : false,
					data : mData,
					success : function(returndata) {
						var data = eval("(" + returndata + ")").errcode;
						if (data == 0) {
						} else {
							alert("配置用户错误");
							return;
						}
					},
					error : function(XMLHttpRequest, textStatus, errorThrown) {
					}
				});
			}
		}
		alert("配置用户成功");
	}

	function nextPage() {
		if (page == lastPage) {
			alert("已经是最后一页");
			return;
		} else {
			page++;
			getRoleList(page);
		}
	}

	function previousPage() {
		if (page == 1) {
			alert("已经是第一页");
			return;
		} else {
			page--;
			getRoleList(page);
		}
	}

	function FirstPage() {
		if (page == 1) {
			alert("已经是首页");
			return;
		} else {
			page = 1;
			getRoleList(page);
		}
	}

	function LastPage() {
		if (page == lastPage) {
			alert("已经是尾页");
			return;
		} else {
			page = lastPage;
			getRoleList(page);
		}
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
</script>
</head>
<body id="mBody">
	<div id="pageAll">
		<div class="pageTop">
			<div class="page">
				<img src="../image/coin02.png" /><span><a href="#">首页</a>&nbsp;-&nbsp;<a
					href="#">系统管理</a>&nbsp;-</span>&nbsp;角色管理
			</div>
		</div>

		<div class="page">
			<!-- vip页面样式 -->
			<div class="vip">
				<div class="conShow">
					<table border="1" style="width: 100%">
						<tr style="width: 100%">
							<td style="width: 20%" class="tdColor">角色名称</td>
							<td style="width: 20%" class="tdColor">所属部门</td>
							<td style="width: 60%" class="tdColor">操作</td>
						</tr>
					</table>
					<table border="1" style="width: 100%">
						<tr style="width: 100%">
							<td style="width: 20%" class="tdColor2"><input type="text"
								id="roleName" placeholder="请输入角色名称"
								style="text-align: center; font-weight: bold; width: 90%; border-bottom: 1px dashed #78639F; background: none; border-left: none; border-right: none; border-top: none; border-left-width: 2px; padding: 5px 0 0 2px; padding-left: 10px;" /></td>
							<td style="width: 20%" class="tdColor2"><select
								style="width: 90%; border-bottom: 0px dashed #78639F;"
								id="departmentId">
							</select></td>
							<td style="width: 60%" class="tdColor2">
								<div style="width: 100%">
									<div
										style="width: 33%; float: left; border-right: 1px dashed #78639F">
										<img class="operation" style="vertical-align: middle"
											src="../image/update.png" title="新建角色" /><a
											style="vertical-align: middle; margin-right: 28px;" href="#"
											onclick="createRole()">新建角色</a>
									</div>
									<div style="width: 33%; float: left;"></div>
									<div style="width: 33%; float: left"></div>
								</div>
							</td>
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
</body>
</html>