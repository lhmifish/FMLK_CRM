<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="renderer" content="webkit" />
<meta http-equiv="pragma" content="no-cache" />
<meta http-equiv="cache-control" content="no-cache" />
<title>人才招聘管理</title>
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/css.css?v=1997" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/select4.css?v=1999" />
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.2.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/select3.js"></script>
<script src="${pageContext.request.contextPath}/js/checkPermission.js"></script>
<script src="${pageContext.request.contextPath}/js/changePsd.js"></script>
<script src="${pageContext.request.contextPath}/js/commonUtils.js"></script>
<script src="${pageContext.request.contextPath}/js/getObjectList.js"></script>

<script type="text/javascript">

var page;
var lastPage;
var deleteId;
var editId;
var sId;
var host;
var isPermissionEdit;
var isPermissionDelete;
var isPermissionEditArr;
var jobPositionArr

$(document).ready(function() {	
	sId = "${sessionId}";
	host = "${pageContext.request.contextPath}";
	checkViewPremission(2);
});

function initialPage() {
	page = 1;
	getJobList(page);
}

function getJobList(mPage){
	page = mPage;
	$
	.ajax({
		url : host + "/jobPositionList",
		type : 'GET',
		data : {},
		cache : false,
		async : false,
		success : function(returndata) {
			var data = eval("(" + returndata + ")").jobPositionList;
			var str = "";
			var num = data.length;
			jobPositionArr = new Array();
			if (num > 0) {
				lastPage = Math.ceil(num / 10);
				for ( var i in data) {
					if (i >= 10 * (mPage - 1)
							&& i <= 10 * mPage - 1) {
						jobPositionArr.push(data[i].id+"#"+data[i].jobTitle+"#"+data[i].techDemand+"#"+data[i].level+"#"+data[i].salary+"#"+data[i].educationDemand+"#"+data[i].otherDemand);
						
						str += '<tr style="width:100%"><td style="width:15%" class="tdColor2">'
								+ data[i].jobTitle
								+ '</td>'
								+ '<td style="width:30%" class="tdColor2">'
								+ data[i].techDemand
								+ '</td>'
								+ '<td style="width:15%" class="tdColor2">'
								+ data[i].educationDemand
								+ '</td>'
								+ '<td style="width:15%" class="tdColor2">'
								+ data[i].otherDemand
								+ '</td>'
								+ '<td style="width:10%" class="tdColor2">'
								+ data[i].level
								+ '</td>'
								+ '<td style="width:8%" class="tdColor2">'
								+ data[i].salary
								+ '</td>'
								+ '<td style="width:3.5%" class="tdColor2">'
								+ '<img name="img_edit" title="编辑" style="vertical-align:middle" class="operation" src="../image/update.png" onclick="editPositionPage('
								+ i
								+ ')"/></td>'
								+ '<td style="width:3.5%;" class="tdColor2">'
								+ '<img title="删除" style="vertical-align:middle" class="operation delban" src="../image/delete.png" onclick="confirmDelete('
								+ data[i].id
								+ ')"></td></tr>';
					}
				}
			} else {
				lastPage = 1;
				str += '<tr style="height:40px;text-align: center;"><td style="color:red;width:1300px;" border=0>人才招聘列表不存在</td></tr>';
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

function confirmDelete(id) {
	$("#banDel1").show();
	deleteId = id;
}

function editPositionPage(t){
	editId = jobPositionArr[t].split("#")[0];
	$("#banDel2").show();
	$("#editJobTitle").val(jobPositionArr[t].split("#")[1]);
	$("#editTechDemand").val(jobPositionArr[t].split("#")[2]);
	$("#editlevel").val(jobPositionArr[t].split("#")[3]);
	$("#editSalary").val(jobPositionArr[t].split("#")[4]);
	$("#editEducationDemand").val(jobPositionArr[t].split("#")[5]);
	$("#editOtherDemand").val(jobPositionArr[t].split("#")[6]);
}

function newPositionPage(){
	$("#banDel3").show();
}

function deletePosition(){
	$.ajax({
		url : host + "/deletePosition",
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

function editPosition(){
	var jobTitle = $("#editJobTitle").val().trim();
	var techDemand = $("#editTechDemand").val().trim();
	var level = $("#editlevel").val().trim();
	var salary = $("#editSalary").val().trim();
	var educationDemand = $("#editEducationDemand").val().trim();
	var otherDemand = $("#editOtherDemand").val().trim();
	
	if (jobTitle == "") {
		alert("职称不能为空");
		return;
	}

	if (techDemand == "") {
		alert("技能要求不能为空");
		return;
	}
	
	if (level == "") {
		alert("级别不能为空");
		return;
	}

	if (salary == "") {
		alert("薪资不能为空");
		return;
	}
	
	$.ajax({
		url : "${pageContext.request.contextPath}/editPosition",
		type : 'POST',
		cache : false,
		data : {
			"id":editId,
			"jobTitle" : jobTitle,
			"techDemand" : techDemand,
			"level" : level,
			"salary" : salary,
			"educationDemand" : educationDemand,
			"otherDemand" : otherDemand
		},
		success : function(returndata) {
			var data = eval("(" + returndata + ")").errcode;
			if (data == 0) {
				alert("编辑招聘职位成功");
				setTimeout(function() {
					toReloadPage();
				}, 500);
			} else {
				alert("编辑招聘职位失败");
			}
		},
		error : function(XMLHttpRequest, textStatus, errorThrown) {
		}
	});
}

function createPosition(){
	var jobTitle = $("#mJobTitle").val().trim();
	var techDemand = $("#mTechDemand").val().trim();
	var level = $("#mlevel").val().trim();
	var salary = $("#mSalary").val().trim();
	var educationDemand = $("#mEducationDemand").val().trim();
	var otherDemand = $("#mOtherDemand").val().trim();
	
	if (jobTitle == "") {
		alert("职称不能为空");
		return;
	}

	if (techDemand == "") {
		alert("技能要求不能为空");
		return;
	}
	
	if (level == "") {
		alert("级别不能为空");
		return;
	}

	if (salary == "") {
		alert("薪资不能为空");
		return;
	}
	
	$.ajax({
		url : "${pageContext.request.contextPath}/createNewPosition",
		type : 'POST',
		cache : false,
		data : {
			"jobTitle" : jobTitle,
			"techDemand" : techDemand,
			"level" : level,
			"salary" : salary,
			"educationDemand" : educationDemand,
			"otherDemand" : otherDemand
		},
		success : function(returndata) {
			var data = eval("(" + returndata + ")").errcode;
			if (data == 0) {
				alert("新建招聘职位成功");
				setTimeout(function() {
					toReloadPage();
				}, 500);
			} else if(data == 3){
				alert("请勿重复新建招聘职位");
			} else{
				alert("新建招聘职位失败");
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
					href="#">系统管理</a>&nbsp;-</span>&nbsp;人才招聘管理
			</div>
		</div>
		
		<div class="page">
			<!-- vip页面样式 -->
			<div class="vip">
			<!-- vip 表格 显示 -->
				<div class="conShow">
					<table border="1" style="width: 100%">
						<tr style="width: 100%">
							<td style="width: 15%" class="tdColor">职称</td>
							<td style="width: 30%" class="tdColor">技能要求</td>
							<td style="width: 15%" class="tdColor">学历要求</td>
							<td style="width: 15%" class="tdColor">其他要求</td>
							<td style="width: 10%" class="tdColor">级别</td>
							<td style="width: 8%" class="tdColor">薪资</td>
							<td style="width: 7%" class="tdColor">操作</td>
						</tr>
					</table>
					<table id="tb" border="1" style="width: 100%">
					</table>
					<div class="paging" style="margin-top: 20px; margin-bottom: 50px;">
					    <input type="button" class="submit" value="新建"
							style="margin-left: 10px; width: 60px;" onclick="newPositionPage()" />
						<input type="button" class="submit" value="上一页"
							style="margin-left: 10px; width: 60px;" onclick="previousPage()" />
						<input type="button" class="submit" value="下一页"
							style="margin-left: 10px; width: 60px;" onclick="nextPage()" />
						<span style="margin-left: 10px;">当前页：</span> <span id="p">0/0</span>
					</div>
				</div>
				<!-- vip 表格 显示 end-->
			</div>
		</div>
		
		<!-- 删除弹出框 -->
	<div class="banDel" id="banDel1">
		<div class="delete">
			<div class="close">
				<a><img src="../image/shanchu.png" onclick="closeConfirmBox()" /></a>
			</div>
			<p class="delP1">你确定要删除这条招聘记录吗？</p>

			<div class="cfD" style="margin-top: 30px">
				<a class="addA" href="#" onclick="deletePosition()"
					style="margin-left: 0px; margin-bottom: 30px;">确定</a> <a
					class="addA" onclick="closeConfirmBox()">取消</a>
			</div>

		</div>
	</div>
	
	<!-- 编辑弹出框 -->
	<div class="banDel" id="banDel2">
		<div class="delete" style="top:3%">
			<div class="close">
				<a><img src="../image/shanchu.png" onclick="closeConfirmBox()" /></a>
			</div>
			<p class="delP1">编辑人才招聘</p>
			<p class="delP2" style="margin-top: 20px;">
				<label style="font-size: 16px;margin-left:30px">职称：</label> 
				<input id="editJobTitle" type="text"
							 style="width: 250px;height: 26px;border-bottom: 1px dashed #78639F;border-left: none; border-right: none; border-top: none;padding: 4px 2px 3px 2px; padding-left: 10px"></input>
			</p>
			<p class="delP2" style="margin-top: 20px;">
				<label style="font-size: 16px;">技能要求：</label> 
				<textarea id="editTechDemand"
							 style="rows:5;width: 250px;height: 50px;border-bottom: 1px dashed #78639F;border-left: none; border-right: none; border-top: none;padding: 4px 2px 3px 2px; padding-left: 10px; resize: none;"></textarea>
			</p>
			<p class="delP2" style="margin-top: 20px;">
				<label style="font-size: 16px;">学历要求：</label> 
				<input id="editEducationDemand" type="text"
							 style="width: 250px;height: 26px;border-bottom: 1px dashed #78639F;border-left: none; border-right: none; border-top: none;padding: 4px 2px 3px 2px; padding-left: 10px;"></input>
			</p>
			
			<p class="delP2" style="margin-top: 20px;">
				<label style="font-size: 16px;">其他要求：</label> 
				<textarea id="editOtherDemand"
							 style="rows:5;width: 250px;height: 50px;border-bottom: 1px dashed #78639F;border-left: none; border-right: none; border-top: none;padding: 4px 2px 3px 2px; padding-left: 10px; resize: none;"></textarea>
			</p>
			<p class="delP2" style="margin-top: 20px;">
				<label style="font-size: 16px;margin-left:30px">级别：</label> 
				<input id="editlevel" type="text"
							 style="width: 250px;height: 26px;border-bottom: 1px dashed #78639F;border-left: none; border-right: none; border-top: none;padding: 4px 2px 3px 2px; padding-left: 10px"></input>
			</p>
			<p class="delP2" style="margin-top: 20px;">
				<label style="font-size: 16px;margin-left:30px">薪资：</label> 
				<input id="editSalary" type="text"
							 style="width: 250px;height: 26px;border-bottom: 1px dashed #78639F;border-left: none; border-right: none; border-top: none;padding: 4px 2px 3px 2px; padding-left: 10px"></input>
			</p>

			<div class="cfD" style="margin-top: 30px">
				<a class="addA" href="#" onclick="editPosition()"
					style="margin-left: 0px; margin-bottom: 30px;">编辑</a> <a
					class="addA" onclick="closeConfirmBox()">取消</a>
			</div>
		</div>
	</div>
	
	<!-- 新建弹出框 -->
	<div class="banDel" id="banDel3">
		<div class="delete" style="top:3%">
			<div class="close">
				<a><img src="../image/shanchu.png" onclick="closeConfirmBox()" /></a>
			</div>
			<p class="delP1">新建人才招聘</p>
			<p class="delP2" style="margin-top: 20px;">
				<label style="font-size: 16px;margin-left:30px">职称：</label> 
				<input id="mJobTitle" type="text"
							 style="width: 250px;height: 26px;border-bottom: 1px dashed #78639F;border-left: none; border-right: none; border-top: none;padding: 4px 2px 3px 2px; padding-left: 10px"></input>
			</p>
			
			<p class="delP2" style="margin-top: 20px;">
				<label style="font-size: 16px;">技能要求：</label> 
				<textarea id="mTechDemand"
							 style="rows:5;width: 250px;height: 50px;border-bottom: 1px dashed #78639F;border-left: none; border-right: none; border-top: none;padding: 4px 2px 3px 2px; padding-left: 10px; resize: none;"></textarea>
			</p>
			
			<p class="delP2" style="margin-top: 20px;">
				<label style="font-size: 16px;">学历要求：</label> 
				<input id="mEducationDemand" type="text"
							 style="width: 250px;height: 26px;border-bottom: 1px dashed #78639F;border-left: none; border-right: none; border-top: none;padding: 4px 2px 3px 2px; padding-left: 10px;"></input>
			</p>
			
			<p class="delP2" style="margin-top: 20px;">
				<label style="font-size: 16px;">其他要求：</label> 
				<textarea id="mOtherDemand"
							 style="rows:5;width: 250px;height: 50px;border-bottom: 1px dashed #78639F;border-left: none; border-right: none; border-top: none;padding: 4px 2px 3px 2px; padding-left: 10px; resize: none;"></textarea>
			</p>
			
			<p class="delP2" style="margin-top: 20px;">
				<label style="font-size: 16px;margin-left:30px">级别：</label> 
				<input id="mlevel" type="text"
							 style="width: 250px;height: 26px;border-bottom: 1px dashed #78639F;border-left: none; border-right: none; border-top: none;padding: 4px 2px 3px 2px; padding-left: 10px"></input>
			</p>
			<p class="delP2" style="margin-top: 20px;">
				<label style="font-size: 16px;margin-left:30px">薪资：</label> 
				<input id="mSalary" type="text"
							 style="width: 250px;height: 26px;border-bottom: 1px dashed #78639F;border-left: none; border-right: none; border-top: none;padding: 4px 2px 3px 2px; padding-left: 10px"></input>
			</p>

			<div class="cfD" style="margin-top: 30px">
				<a class="addA" href="#" onclick="createPosition()"
					style="margin-left: 0px; margin-bottom: 30px;">确定</a> <a
					class="addA" onclick="closeConfirmBox()">取消</a>
			</div>
		</div>
	</div>
	
	
	
</div>
</body>
</html>