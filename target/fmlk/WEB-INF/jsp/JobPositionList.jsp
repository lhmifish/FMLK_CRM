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
	//page = 1;
	//getJobList(page);
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
		
		<div class="page" style="margin-top:20px;color:red">
		    因网站服务端迁移，此页面不再提供更新和查看，请跳转继续操作
		  <a href="https://www.family-care.cn/page/netWebOrganize_jobPosition">点我跳转</a>
		</div>	
</div>
</body>
</html>