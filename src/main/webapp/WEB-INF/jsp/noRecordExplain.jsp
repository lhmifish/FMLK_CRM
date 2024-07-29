<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="pragma" content="no-cache" />
<meta http-equiv="cache-control" content="no-cache" />
<title>无打卡记录说明表</title>
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/css.css?v=1990" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/select4.css?v=1997" />
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.2.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/select3.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery.jqprint-0.3.js"></script>
<script src="http://www.jq22.com/jquery/jquery-migrate-1.2.1.min.js"></script>
<script
	src="${pageContext.request.contextPath}/js/jquery.table2excel.js"></script>
<style type="text/css">
.line {
	width: 100%;
	border: 2px solid #000;
	display: flex;
	flex-direction: row;
	justify-content: center;
	line-height: 45px
}

.td1 {
	height: 49px;
	width: 142.5px;
	border: 2px solid #000;
	border-top: 0;
	border-bottom: 0;
	border-left: 0;
	display: flex;
	flex-direction: row;
	align-items: center;
	justify-content: center;
	font-size: 20px;
}

.inputline {
	border: 0;
	width: 100%;
	height: 100%;
	text-align: center;
	font-size: 18px;
	height: 49px
}

.btn {
	line-height: 45px;
	width: 150px;
	background-color: #5EC7CE;
	display: flex;
	flex-direction: row;
	align-item: center;
	justify-content: center;
	color: white;
	border-radius: 5px;
	font-size:20px;
}

a:hover {
	color: #FF00FF
}
</style>

<script type="text/javascript">
	var sId;
	var host;
	$(document).ready(function() {
		sId = "${sessionId}";
		host = "${pageContext.request.contextPath}";
		var user = getUser(sId);
		document.getElementById('name').innerHTML = user.name;
		document.getElementById('dept').innerHTML = getDepartment(user.departmentId);
		document.getElementById('date').innerHTML = "${year}年${month}月";
	});

	function printTable() {
		for(var i=1;i<=3;i++){
			var unSignTime = $("#unSignTimeInput"+i).val();
			document.getElementById('unSignTimeDiv'+i).innerHTML = '<input id="unSignTimeInput'+i+'" type="text" style="border: 0;width: 100%;line-height:45px;text-align: center;font-size: 20px;height: 49px" value="'+ unSignTime +'"/>';
			var signInCheck = $("#signIn"+i).is(":checked")?'checked="checked"':'';
			var signOutCheck = $("#signOut"+i).is(":checked")?'checked="checked"':'';
			document.getElementById('signCheckBox'+i).innerHTML = '<input id="signIn'+i+'" type="checkbox" '+ signInCheck +' style="display: flex; flex-direction: row; align-items: center; justify-content: center; line-height:45px; width: 20px; margin-right: 10px;height:50px"/>上班'
			+'<input id="signOut'+i+'" type="checkbox" '+ signOutCheck + ' style="display: flex; flex-direction: row; align-items: center; justify-content: center; line-height:45px; width: 20px; margin:0 10px;height:50px"/>下班';
			var startTimeH = $("#startTimeInputH"+i).val();
			var startTimeM = $("#startTimeInputM"+i).val();
			var endTimeH = $("#endTimeInputH"+i).val();
			var endTimeM = $("#endTimeInputM"+i).val();
			document.getElementById('startTimeDivH'+i).innerHTML = '<input id="startTimeInputH'+i+'" type="text" style="border: 0;width: 100%;line-height:45px;text-align: center;font-size: 20px;" value="'+ startTimeH +'"/>';
			document.getElementById('startTimeDivM'+i).innerHTML = '<input id="startTimeInputM'+i+'" type="text" style="border: 0;width: 100%;line-height:45px;text-align: center;font-size: 20px;" value="'+ startTimeM +'"/>';
			document.getElementById('endTimeDivH'+i).innerHTML = '<input id="endTimeInputH'+i+'" type="text" style="border: 0;width: 100%;line-height:45px;text-align: center;font-size: 20px;" value="'+ endTimeH +'"/>';
			document.getElementById('endTimeDivM'+i).innerHTML = '<input id="endTimeInputM'+i+'" type="text" style="border: 0;width: 100%;line-height:45px;text-align: center;font-size: 20px;" value="'+ endTimeM +'"/>';
			var reason = $("#unSignReasonInput"+i).val();
			document.getElementById('unSignReasonDiv'+i).innerHTML = '<input id="unSignReasonInput'+i+'" type="text" style="border: 0;width: 100%;line-height:45px;font-size: 20px;height: 49px;padding-left:20px" value="'+ reason +'"/>';
		}
		$("#tableView").jqprint();
	}
	
	function getUser(nName) {
		var user;
		$.ajax({
			url : host + "/getUserByNickName",
			type : 'GET',
			data : {
				"nickName" : nName
			},
			cache : false,
			async : false,
			success : function(returndata) {
				user = eval("(" + returndata + ")").user[0];
				
				$("#departmentId").val(data[0].departmentId);
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
		return user;
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
	
	
	
	
</script>
</head>

<body id="body" style="width: 100%; display: flex; flex-direction: column; justify-content: center; align-items: center;">
	<div id="tableView"
		style="display: flex; flex-direction: column; padding-top: 10px; padding-bottom: 50px; width: 960px;">
		<div style="width: 100%; border: 2px solid #000; display: flex; flex-direction: row; justify-content: center; font-weight: bold; font-size: 30px; border-bottom: 0; height: 60px; line-height: 60px;">
		无打卡记录说明
		</div>
		<div style="width: 100%; border: 2px solid #000; border-bottom: 0; display: flex; flex-direction: row; justify-content: center; line-height: 45px;">
			<div style="width: 142.5px; height: 49px; border-right: 2px solid #000; display: flex; flex-direction: row; align-items: center; justify-content: center; font-size: 20px;">
				部门
			</div>
			<div id="dept" style="width: 142.5px; height: 49px; border-right: 2px solid #000; display: flex; flex-direction: row; align-items: center; justify-content: center; font-size: 18px;">				
			</div>
			<div style="width: 142.5px; height: 49px; border-right: 2px solid #000; display: flex; flex-direction: row; align-items: center; justify-content: center; font-size: 20px;">
				姓名
			</div>
			<div id="name"  style="width: 190px; height: 49px; border-right: 2px solid #000; display: flex; flex-direction: row; align-items: center; justify-content: center;font-size: 18px;">				
			</div>
			<div style="width: 190px; height: 49px; border-right: 2px solid #000; display: flex; flex-direction: row; align-items: center; justify-content: center; font-size: 20px;">
				考勤所属月份
			</div>
			<div id="date" style="width: 142.5px; height: 49px; display: flex; flex-direction: row; align-items: center; justify-content: center;font-size: 18px;">
			</div>
		</div>
		<div style="width: 100%;border: 2px solid #000;border-bottom: 0;display: flex;flex-direction: row;justify-content: center;line-height: 45px">
			<div style="width: 142.5px; height: 49px; border-right: 2px solid #000; display: flex; flex-direction: row; align-items: center; justify-content: center; font-size: 20px;">
			        未打卡时间
			</div>
			<div id="unSignTimeDiv1" style="width: 142.5px; height: 49px; border-right: 2px solid #000; display: flex; flex-direction: row; align-items: center; justify-content: center;font-size: 20px;">
				<input id="unSignTimeInput1" type="text" style="border: 0;width: 100%;line-height:45px;text-align: center;font-size: 20px;height: 49px"/>
			</div>
			<div id="signCheckBox1" style="height: 49px;width: 332.5px;border-right: 2px solid #000;display: flex;flex-direction: row;align-items: center;justify-content: center;font-size: 18px;padding-right: 2px">
				<input id="signIn1" type="checkbox" style="display: flex; flex-direction: row; align-items: center; justify-content: center; line-height:45px; width: 20px; margin-right: 10px;height:50px"/>
				上班
				<input id="signOut1" type="checkbox" style="display: flex; flex-direction: row; align-items: center; justify-content: center; line-height:45px; width: 20px; margin:0 10px;height:50px"/>
				下班
			</div>
			<div style="height: 49px;width: 332.5px;display: flex;flex-direction: row;align-items: center;justify-content: center;font-size: 18px;padding-right: 2px">
				<div id="startTimeDivH1" style="width: 50px;font-size: 20px;text-align: center;">
					<input id="startTimeInputH1" type="text" style="border: 0;width: 100%;line-height:45px;text-align: center;font-size: 20px;"/>
				</div>
				点
				<div id="startTimeDivM1" style="width: 50px;font-size: 20px;text-align: center;">
					<input id="startTimeInputM1" type="text" style="border: 0;width: 100%;line-height:45px;text-align: center;font-size: 20px;"/>
				</div>
				分至
				<div id="endTimeDivH1" style="width: 50px;font-size: 20px;text-align: center;">
					<input id="endTimeInputH1" type="text" style="border: 0;width: 100%;line-height:45px;text-align: center;font-size: 20px;"/>
				</div>
				点
				<div id="endTimeDivM1" style="width: 50px;font-size: 20px;text-align: center;">
					<input id="endTimeInputM1" type="text" style="border: 0;width: 100%;line-height:45px;text-align: center;font-size: 20px;"/>
				</div>
				分
			</div>
		</div>
		<div style="width: 100%;border: 2px solid #000;border-bottom: 0;display: flex;flex-direction: row;justify-content: center;line-height: 45px">
			<div style="width: 142.5px; height: 49px; border-right: 2px solid #000; display: flex; flex-direction: row; align-items: center; justify-content: center; font-size: 20px;">
			         未打卡原因
			</div>
			<div id="unSignReasonDiv1" style="width: 815.5px; height: 49px; display: flex; flex-direction: row; justify-content: center;font-size: 20px;">
				<input id="unSignReasonInput1" type="text" style="border: 0;width: 100%;line-height:45px;font-size: 20px;height: 49px;padding-left:20px" />
			</div>
		</div>
		<div style="width: 100%;border: 2px solid #000;border-bottom: 0;display: flex;flex-direction: row;justify-content: center;line-height: 45px">
			<div style="width: 142.5px; height: 49px; border-right: 2px solid #000; display: flex; flex-direction: row; align-items: center; justify-content: center; font-size: 20px;">
			        本人签字/日期
			</div>
			<div style="width: 287px; height: 49px; border-right: 2px solid #000;"></div>
			<div style="width: 190px; height: 49px; border-right: 2px solid #000; display: flex; flex-direction: row; align-items: center; justify-content: center; font-size: 20px;">
			      部门领导签字/日期
			</div>
			<div style="width: 334.5px; height: 49px;"></div>
		</div>
		<div style="width: 100%;border: 2px solid #000;border-bottom: 0;display: flex;flex-direction: row;justify-content: center;line-height: 45px">
			<div style="width: 142.5px; height: 49px; border-right: 2px solid #000; display: flex; flex-direction: row; align-items: center; justify-content: center; font-size: 20px;">
			        未打卡时间
			</div>
			<div id="unSignTimeDiv2" style="width: 142.5px; height: 49px; border-right: 2px solid #000; display: flex; flex-direction: row; align-items: center; justify-content: center;font-size: 20px;">
				<input id="unSignTimeInput2" type="text" style="border: 0;width: 100%;line-height:45px;text-align: center;font-size: 20px;height: 49px" />
			</div>
			<div id="signCheckBox2" style="height: 49px;width: 332.5px;border-right: 2px solid #000;display: flex;flex-direction: row;align-items: center;justify-content: center;font-size: 18px;padding-right: 2px">
				<input id="signIn2" type="checkbox" style="display: flex; flex-direction: row; align-items: center; justify-content: center; line-height:45px; width: 20px; margin-right: 10px;height:50px"/>
				上班
				<input id="signOut2" type="checkbox" style="display: flex; flex-direction: row; align-items: center; justify-content: center; line-height:45px; width: 20px; margin:0 10px;height:50px"/>
				下班
			</div>
			<div style="height: 49px;width: 332.5px;display: flex;flex-direction: row;align-items: center;justify-content: center;font-size: 18px;padding-right: 2px">
				<div id="startTimeDivH2" style="width: 50px;font-size: 20px;text-align: center;">
					<input id="startTimeInputH2" type="text" style="border: 0;width: 100%;line-height:45px;text-align: center;font-size: 20px;"/>
				</div>
				点
				<div id="startTimeDivM2" style="width: 50px;font-size: 20px;text-align: center;">
					<input id="startTimeInputM2" type="text" style="border: 0;width: 100%;line-height:45px;text-align: center;font-size: 20px;"/>
				</div>
				分至
				<div id="endTimeDivH2" style="width: 50px;font-size: 20px;text-align: center;">
					<input id="endTimeInputH2" type="text" style="border: 0;width: 100%;line-height:45px;text-align: center;font-size: 20px;"/>
				</div>
				点
				<div id="endTimeDivM2" style="width: 50px;font-size: 20px;text-align: center;">
					<input id="endTimeInputM2" type="text" style="border: 0;width: 100%;line-height:45px;text-align: center;font-size: 20px;"/>
				</div>
				分
			</div>
		</div>
		<div style="width: 100%;border: 2px solid #000;border-bottom: 0;display: flex;flex-direction: row;justify-content: center;line-height: 45px">
			<div style="width: 142.5px; height: 49px; border-right: 2px solid #000; display: flex; flex-direction: row; align-items: center; justify-content: center; font-size: 20px;">
			         未打卡原因
			</div>
			<div id="unSignReasonDiv2" style="width: 815.5px; height: 49px; display: flex; flex-direction: row; justify-content: center;font-size: 20px">
				<input id="unSignReasonInput2" type="text" style="border: 0;width: 100%;line-height:45px;font-size: 20px;height: 49px;padding-left:20px" />
			</div>
		</div>
		<div style="width: 100%;border: 2px solid #000;border-bottom: 0;display: flex;flex-direction: row;justify-content: center;line-height: 45px">
			<div style="width: 142.5px; height: 49px; border-right: 2px solid #000; display: flex; flex-direction: row; align-items: center; justify-content: center; font-size: 20px;">
			       本人签字/日期
			</div>
			<div style="width: 287px; height: 49px; border-right: 2px solid #000;"></div>
			<div style="width: 190px; height: 49px; border-right: 2px solid #000; display: flex; flex-direction: row; align-items: center; justify-content: center; font-size: 20px;">
			       部门领导签字/日期
			</div>
			<div style="width: 334.5px; height: 49px;"></div>
		</div>
		<div style="width: 100%;border: 2px solid #000;border-bottom: 0;display: flex;flex-direction: row;justify-content: center;line-height: 45px">
			<div style="width: 142.5px; height: 49px; border-right: 2px solid #000; display: flex; flex-direction: row; align-items: center; justify-content: center; font-size: 20px;">
			        未打卡时间
			</div>
			<div id="unSignTimeDiv3" style="width: 142.5px; height: 49px; border-right: 2px solid #000; display: flex; flex-direction: row; align-items: center; justify-content: center;font-size: 20px;">
				<input id="unSignTimeInput3" type="text" style="border: 0;width: 100%;line-height:45px;text-align: center;font-size: 20px;height: 49px" />
			</div>
			<div id="signCheckBox3" style="height: 49px;width: 332.5px;border-right: 2px solid #000;display: flex;flex-direction: row;align-items: center;justify-content: center;font-size: 18px;padding-right: 2px">
				<input id="signIn3" type="checkbox" style="display: flex; flex-direction: row; align-items: center; justify-content: center; line-height:45px; width: 20px; margin-right: 10px;height:50px"/>
				上班
				<input id="signOut3" type="checkbox" style="display: flex; flex-direction: row; align-items: center; justify-content: center; line-height:45px; width: 20px; margin:0 10px;height:50px"/>
				下班
			</div>
			<div style="height: 49px;width: 332.5px;display: flex;flex-direction: row;align-items: center;justify-content: center;font-size: 18px;padding-right: 2px">
				<div id="startTimeDivH3" style="width: 50px;font-size: 20px;text-align: center;">
					<input id="startTimeInputH3" type="text" style="border: 0;width: 100%;line-height:45px;text-align: center;font-size: 20px;"/>
				</div>
				点
				<div id="startTimeDivM3" style="width: 50px;font-size: 20px;text-align: center;">
					<input id="startTimeInputM3" type="text" style="border: 0;width: 100%;line-height:45px;text-align: center;font-size: 20px;"/>
				</div>
				分至
				<div id="endTimeDivH3" style="width: 50px;font-size: 20px;text-align: center;">
					<input id="endTimeInputH3" type="text" style="border: 0;width: 100%;line-height:45px;text-align: center;font-size: 20px;"/>
				</div>
				点
				<div id="endTimeDivM3" style="width: 50px;font-size: 20px;text-align: center;">
					<input id="endTimeInputM3" type="text" style="border: 0;width: 100%;line-height:45px;text-align: center;font-size: 20px;"/>
				</div>
				分
			</div>
		</div>
		<div style="width: 100%;border: 2px solid #000;border-bottom: 0;display: flex;flex-direction: row;justify-content: center;line-height: 45px">
			<div style="width: 142.5px; height: 49px; border-right: 2px solid #000; display: flex; flex-direction: row; align-items: center; justify-content: center; font-size: 20px;">
			         未打卡原因
			</div>
			<div id="unSignReasonDiv3" style="width: 815.5px; height: 49px; display: flex; flex-direction: row; justify-content: center;font-size: 20px">
				<input id="unSignReasonInput3" type="text" style="border: 0;width: 100%;line-height:45px;font-size: 20px;height: 49px;padding-left:20px" />
			</div>
		</div>
		<div style="width: 100%;border: 2px solid #000;border-bottom: 0;display: flex;flex-direction: row;justify-content: center;line-height: 45px">
			<div style="width: 142.5px; height: 49px; border-right: 2px solid #000; display: flex; flex-direction: row; align-items: center; justify-content: center; font-size: 20px;">
			       本人签字/日期
			</div>
			<div style="width: 287px; height: 49px; border-right: 2px solid #000;"></div>
			<div style="width: 190px; height: 49px; border-right: 2px solid #000; display: flex; flex-direction: row; align-items: center; justify-content: center; font-size: 20px;">
			      部门领导签字/日期
			</div>
			<div style="width: 334.5px; height: 49px;"></div>
		</div>
		
		
		<div style="line-height: 20px; display: flex; flex-direction: column;width: 100%;border: 2px solid #000;">
			<div style="margin-left: 10px; margin-top: 10px">说明：</div>
			<div style="margin-left: 10px">1、此表需要部门负责人签字；</div>
			<div style="margin-left: 10px; margin-bottom: 10px">2、当事人应在三个工作日内将此表交人事行政部作为考勤依据，若未签送无打卡记录说明表单者一律按员工考勤制度相关规定处理。</div>
		</div>
	</div>
	<div
		style="width: 960px; height: 30px; display: flex; flex-direction: row; align-items: center; margin-top: 10px; justify-content: center;">
		<a class="btn" onclick="printTable()">打印签字</a>
	</div>
</body>
</html>