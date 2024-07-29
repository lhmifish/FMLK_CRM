<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="pragma" content="no-cache" />
<meta http-equiv="cache-control" content="no-cache" />
<title>用户信息管理</title>
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/css.css?v=1990" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/select4.css?v=1997" />
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.2.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/select3.js"></script>
<script src="${pageContext.request.contextPath}/js/changePsd.js"></script>
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
	var editId;
	var editNickName;
	var isHide;

	$(document).ready(function() {
		$("#departmentId").select2({});
		page = 1;
		isHide = false;
		getDepartmentList();
		getUserList(page);
	});

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

	function getDepartmentList() {
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
				}
				$("#departmentId").empty();
				$("#departmentId").append(str);

			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
	}
	
	function sortJobId(a,b){
		return b.jobId.substring(1)-a.jobId.substring(1);
	}

	function getUserList(mPage) {
		// isHide
		page = mPage;
		var mName = $("#name").val().trim();
		var mNickName = $("#nickName").val().trim();
		var mJobId = $("#jobId").val().trim();
		var mDepartmentId = $("#departmentId option:selected").val();
		$
				.ajax({
					url : "${pageContext.request.contextPath}/userList",
					type : 'GET',
					data : {
						"dpartId" : mDepartmentId,
						"date" : "",
						"name" : mName,
						"nickName" : mNickName,
						"jobId" : mJobId,
						"isHide" : isHide
					},
					cache : false,
					async : false,
					success : function(returndata) {
						var data = eval("(" + returndata + ")").userlist;
						data.sort(sortJobId);
						var str = "";
						var num = data.length;
						if (num > 0) {
							lastPage = Math.ceil(num / 10);
							for ( var i in data) {
								if (i >= 10 * (mPage - 1)
										&& i <= 10 * mPage - 1) {
									str += '<tr style="width:100%"><td style="width:16%" class="tdColor2">'
											+ data[i].jobId
											+ '</td>'
											+ '<td style="width:16%" class="tdColor2">'
											+ data[i].nickName
											+ '</td>'
											+ '<td style="width:16%" class="tdColor2">'
											+ getUser(data[i].UId)
											+ '</td>'
											+ '<td style="width:16%" class="tdColor2">'
											+ getDepartment(data[i].departmentId)
											+ '</td>'
											+ '<td style="width:16%" class="tdColor2">'
											+ getUserState(data[i].UId,
													data[i].state, i,
													data[i].nickName)
											+ '</td>'
											+ '<td style="width:20%" class="tdColor2">'
											+ '<img style="vertical-align:middle" class="operation" src="../image/update.png" title="编辑用户" ><a style="vertical-align:middle" href="../page/editUser/'+ data[i].UId +'">编辑用户</a>'
											+ '<img style="vertical-align:middle" class="operation delban" src="../image/update.png" title="修改密码" /><a style="vertical-align:middle" onclick="changePsd2('
											+ data[i].UId
											+ ',\''
											+ data[i].nickName
											+ '\')">重置密码</a></td></tr>';
								}
							}
						} else {
							lastPage = 1;
							str += '<tr style="height:40px;text-align: center;"><td style="color:red;width:1300px;" border=0>没有你要找的用户</td></tr>';
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

	function getUserState(mId, mState, i, mNickName) {
		var str;
		if (mState.indexOf("在职") != -1) {
			str = '<div><span style="margin-left:25px">正常</span>';
		} else {
			str = '<div><span style="color:brown;margin-left:25px">已离职</span>';
		}
		str += '<img src="../image/coinL1.png" style="width:14px;float:right;margin-right:10px" title="更改用户状态" onclick="checkUserState('
				+ mId + ',\'' + mState + '\',\'' + mNickName + '\')" /></div>';
		return str;
	}

	function checkUserState(mId, mState, mNickName) {
		$("#banDel2").show();
		editId = mId;
		editNickName = mNickName;
		if (mState.indexOf("在职") != -1) {
			//在职
			$("#userState").val(0);
			$("#tDate").hide();
			$("#info").hide();
			$("#userState").css("color", "black");
		} else {
			$("#tDate").show();
			$("#info").show();
			var mDate = mState.split("-")[1];
			$("#userState").val(1);
			$("#year").val(mDate.split("/")[0]);
			$("#month").val(mDate.split("/")[1]);
			$("#userState").css("color", "brown");
		}
	}

	function changeUserState(uState) {
		$("#userState").val(uState);
		$('#year option:first').prop('selected', 'selected');
		$('#month option:first').prop('selected', 'selected');
		if (uState == 0) {
			$("#userState").css("color", "black");
			$("#tDate").hide();
			$("#info").hide();
		} else {
			$("#userState").css("color", "brown");
			$("#tDate").show();
			$("#info").show();
		}
	}

	function editUser(t) {
		//t=1改状态t=2改密码
		var mState = $("#userState").val() == 0 ? "在职" : "离职-"
				+ $('#year').val() + "/" + $('#month').val();
		var psd = $("#newPsd2").val().trim();
		if (t == 2 && psd.length < 6) {
			alert("密码不能少于6位");
			return;
		}
		var mData;
		if (t == 1) {
			mData = {
				"name" : "",
				"nickName" : editNickName,
				"psd" : "",
				"email" : "",
				"departmentId" : 0,
				"tel" : "",
				"id" : editId,
				"state" : mState,
				"roleId" : -1
			};
		} else if (t == 2) {
			mData = {
				"name" : "",
				"nickName" : editNickName,
				"psd" : psd,
				"email" : "",
				"departmentId" : 0,
				"tel" : "",
				"id" : editId,
				"state" : "",
				"roleId" : -1
			};
		}
		$.ajax({
			url : "${pageContext.request.contextPath}/editUser",
			type : 'POST',
			cache : false,
			data : mData,
			success : function(returndata) {
				var data = eval("(" + returndata + ")").errcode;
				if (data == 0) {
					if (t == 1) {
						alert("更改用户状态成功");
					} else if (t == 2) {
						alert("修改密码成功");
					}
					setTimeout(function() {
						$(".banDel").hide();
						getUserList(1);
					}, 500);
				} else {
					if (t == 1) {
						alert("更改用户状态失败");
					} else if (t == 2) {
						alert("修改密码失败");
					}
				}
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
	}

	function getUser(uId) {
		var uName;
		$.ajax({
			url : "${pageContext.request.contextPath}/getUserById",
			type : 'GET',
			data : {
				"uId" : uId
			},
			cache : false,
			async : false,
			success : function(returndata) {
				uName = eval("(" + returndata + ")").user[0].name;
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
		return uName;
	}

	function getDepartment(dpartId) {
		if (dpartId == 1) {
			return "技术部";
		} else if (dpartId == 2) {
			return "销售部";
		} else if (dpartId == 3) {
			return "行政部";
		} else if (dpartId == 4) {
			return "研发部";
		} else if (dpartId == 5) {
			return "经理办公室";
		} else if (dpartId == 6){
			return "管理员";
		} else if (dpartId == 7){
			return "市场部";
		} else if (dpartId == 8){
			return "运维部";
		} else if (dpartId == 9){
			return "客服部";
		} else {
			return "";
		}
	}

	function changePsd2(id, nickName) {
		$("#newPsd2").val("");
		$("#banDel8").show();
		editId = id;
		editNickName = nickName;
	}

    function deleteUser() {
		$.ajax({
			url : "${pageContext.request.contextPath}/deleteUser",
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

	function nextPage() {
		if (page == lastPage) {
			alert("已经是最后一页");
			return;
		} else {
			page++;
			getUserList(page);
		}
	}

	function previousPage() {
		if (page == 1) {
			alert("已经是第一页");
			return;
		} else {
			page--;
			getUserList(page);
		}
	}

	function FirstPage() {
		if (page == 1) {
			alert("已经是首页");
			return;
		} else {
			page = 1;
			getUserList(page);
		}
	}

	function LastPage() {
		if (page == lastPage) {
			alert("已经是尾页");
			return;
		} else {
			page = lastPage;
			getUserList(page);
		}
	}

	function hideUser() {
		if (isHide) {
			isHide = false;
			document.getElementById('hu').innerHTML = "隐藏已离职人员";
		} else {
			isHide = true;
			document.getElementById('hu').innerHTML = "显示已离职人员";
		}
		getUserList(1);
	}
</script>
</head>

<body>
	<div id="pageAll">
		<div class="pageTop">
			<div class="page">
				<img src="../image/coin02.png" /><span><a href="#">首页</a>&nbsp;-&nbsp;<a
					href="#">用户管理</a>&nbsp;-</span>&nbsp;用户信息管理
			</div>
		</div>

		<div class="page">
			<!-- vip页面样式 -->
			<div class="vip">
				<div class="conform">
					<form>
						<div class="cfD">
							<Strong style="margin-right: 20px">查询条件：</Strong><label>用户姓名：</label><input
								type="text" class="input3" placeholder="输入用户姓名"
								style="margin-right: 10px; width: 100px" id="name" /><label>登入账号：</label><input
								type="text" class="input3" placeholder="输入登入账号"
								style="margin-right: 10px; width: 100px" id="nickName" /><label>员工工号：</label><input
								type="text" class="input3" placeholder="输入员工工号"
								style="margin-right: 10px; width: 100px" id="jobId" /><label>所在部门：</label><select
								class="selCss" style="margin-left: 10px; width: 120px"
								id="departmentId"></select>
						</div>
						<div class="cfD">
							<a class="addA" href="../page/createUser"
								style="margin-left: 114px">新建用户+</a> <a class="addA"
								onClick="getUserList(1)">搜索</a> <a id="hu" href="#"
								style="text-decoration: underline; height: 35px; line-height: 35px; margin-left: 40px;"
								onClick="hideUser()">隐藏已离职人员</a>
						</div>

					</form>
				</div>
				<!-- vip 表格 显示 -->
				<div class="conShow">
					<table border="1" style="width: 100%">
						<tr style="width: 100%">
							<td style="width: 16%" class="tdColor">员工工号</td>
							<td style="width: 16%" class="tdColor">登入账号</td>
							<td style="width: 16%" class="tdColor">用户姓名</td>
							<td style="width: 16%" class="tdColor">所在部门</td>
							<td style="width: 16%" class="tdColor">状态</td>
							<td style="width: 20%" class="tdColor">操作</td>
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
	<div class="banDel" id="banDel">
		<div class="delete">
			<div class="close">
				<a><img src="../image/shanchu.png" onclick="closeConfirmBox()" /></a>
			</div>
			<p class="delP1">你确定要删除此条客户记录吗？</p>
			<p class="delP2">
				<a href="#" class="ok yes" onclick="deleteCompany()">确定</a><a
					class="ok no" onclick="closeConfirmBox()">取消</a>
			</p>
		</div>
	</div>
	<!-- 删除弹出框  end-->

	<!-- 删除弹出框 -->
	<div class="banDel" id="banDel2">
		<div class="delete">
			<div class="close">
				<a><img src="../image/shanchu.png" onclick="closeConfirmBox()" /></a>
			</div>
			<p class="delP1">更改用户状态</p>
			<p class="delP2" style="margin-top: 20px;">
				<label style="font-size: 16px;">用户状态：</label> <select id="userState"
					onChange="changeUserState(this.options[this.options.selectedIndex].value)"
					style="width: 180px; height: 26px; border-bottom: 1px dashed #78639F; background: none; border-left: none; border-right: none; border-top: none; padding: 4px 2px 3px 2px; padding-left: 10px">
					<option value="0" style="color:black">正常</option>
					<option value="1" style="color:brown">已离职</option>
				</select>
			</p>
			<p class="delP2" style="margin-top: 20px;" id="tDate">
				<label style="font-size: 16px;">离职日期：</label> <select id="year"
					style="width: 90px; height: 26px; border-bottom: 1px dashed #78639F; background: none; border-left: none; border-right: none; border-top: none; padding: 4px 2px 3px 2px; padding-left: 10px">
					<option value="2018">2018年</option>
					<option value="2019">2019年</option>
					<option value="2020">2020年</option>
					<option value="2021">2021年</option>
					<option value="2022">2022年</option>
					<option value="2023">2023年</option>
					<option value="2024">2024年</option>
					<option value="2025">2025年</option>
					<option value="2026">2026年</option>
					<option value="2027">2027年</option>
					<option value="2028">2028年</option>
					<option value="2029">2029年</option>
					<option value="2030">2030年</option>
					<option value="2031">2031年</option>
					<option value="2032">2032年</option>
					<option value="2033">2033年</option>
					<option value="2034">2034年</option>
					<option value="2035">2035年</option>
					<option value="2036">2036年</option>
					<option value="2037">2037年</option>
				</select> <select id="month"
					style="width: 85px; height: 26px; border-bottom: 1px dashed #78639F; background: none; border-left: none; border-right: none; border-top: none; padding: 4px 2px 3px 2px; padding-left: 10px">
					<option value="1">1月</option>
					<option value="2">2月</option>
					<option value="3">3月</option>
					<option value="4">4月</option>
					<option value="5">5月</option>
					<option value="6">6月</option>
					<option value="7">7月</option>
					<option value="8">8月</option>
					<option value="9">9月</option>
					<option value="10">10月</option>
					<option value="11">11月</option>
					<option value="12">12月</option>
				</select>
			</p>

			<p class="delP2" id="info"
				style="margin-top: 10px; text-align: center;">
				<label style="font-size: 16px; color: brown">离职月份为离职后的第一个月</label>
			</p>

			<div class="cfD" style="margin-top: 30px">
				<a class="addA" href="#" onclick="editUser(1)"
					style="margin-left: 0px; margin-bottom: 30px;">确定</a> <a
					class="addA" onclick="closeConfirmBox()">取消</a>
			</div>
		</div>
	</div>

	<div class="banDel" id="banDel8">
		<div class="delete">
			<div class="close">
				<a><img src="../image/shanchu.png" onclick="closeConfirmBox()" /></a>
			</div>
			<p class="delP1">修改密码</p>
			<p class="delP2" style="margin-top: 20px;">
				<label style="font-size: 16px;">新密码：</label> <input type="password"
					style="width: 250px; height: 26px; border-bottom: 1px dashed #78639F; border-left: none; border-right: none; border-top: none; width: 180px; padding-left: 10px;"
					placeholder="输入新密码(不能少于6位)" id="newPsd2" />
			</p>
			<div class="cfD" style="margin-top: 30px">
				<a class="addA" href="#" onclick="editUser(2)"
					style="margin-left: 0px; margin-bottom: 30px;">确定</a> <a
					class="addA" onclick="closeConfirmBox()">取消</a>
			</div>
		</div>
	</div>
</body>


</html>