<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="pragma" content="no-cache" />
<meta http-equiv="cache-control" content="no-cache" />
<title>配置项目进度</title>
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/css.css?v=1990" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/select4.css?v=1997" />
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/xcConfirm.css?v=2099" />
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.2.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/select3.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/xcConfirm.js?v=2018"></script>
<script src="${pageContext.request.contextPath}/js/changePsd.js"></script>
<script src="${pageContext.request.contextPath}/js/getObjectList.js?v=200"></script>
<script src="${pageContext.request.contextPath}/js/commonUtils.js"></script>
<style type="text/css">
a:hover {
	color: #FF00FF
} /* 鼠标移动到链接上 */
.xcConfirm .popBox {
	background-color: #ffffff;
	width: 800px;
	height: 560px;
	border-radius: 5px;
	font-weight: bold;
	color: #535e66;
	top: 160px;
	margin-left: -400px;
	position: absolute;
}

.xcConfirm .popBox .txtBox {
	margin: 15px 15px;
	height: 400px;
}

.xcConfirm .popBox .txtBox p {
	height: 400px;
	margin: 5px;
	line-height: 16px;
	overflow-x: hidden;
	overflow-y: auto;
}

::-webkit-scrollbar {
	display: none;
}
</style>

<script type="text/javascript">
	var isFmlkShare;
	var host;
	var selectType;

	$(document).ready(function() {
		host = "${pageContext.request.contextPath}";
		isFmlkShare = true;
		selectType = 4
		getProjectTypeList(selectType, isFmlkShare);
		$("#projectType").select2({});
		setTimeout(function() {
			updateCheckBox($("#projectType").val());
		}, 1000);
	});

	
	function checkProjectState(id){
		isFmlkShare = id==2;
		if(isFmlkShare && selectType != 4){
			selectType = 4;
			clearCheckBox();
			getProjectTypeList(selectType, isFmlkShare);
			setTimeout(function() {
				updateCheckBox($("#projectType").val());
			}, 1000);
		}else if(!isFmlkShare && selectType == 4){
			selectType = 1;
			clearCheckBox();
			getProjectTypeList(selectType, isFmlkShare);
			setTimeout(function() {
				updateCheckBox($("#projectType").val());
			}, 1000);
		}
		
	}
	
	function changeType(value){
		if(value !=0){
			clearCheckBox();
			updateCheckBox($("#projectType").val());
		}
	}
	
	function updateCheckBox(value){
		getProjectSubState(99,value);
	}
	
	function selectState(){
		
	}
	
	function getProjectSubState(mProjectState, mProjectType) {
		var projectSubStateName;
		$.ajax({
			url : host + "/projectSubStateList",
			type : 'GET',
			data : {
				"projectState" : mProjectState,
				"projectType" : mProjectType
			},
			cache : false,
			async : false,
			success : function(returndata) {
				var data = eval("(" + returndata + ")").projectSubStateList;
				for(var i=0;i<data.length;i++){
					var id= $.trim(data[i].projectState) + $.trim(data[i].PId);
					$("#checkbox"+id).prop("checked",true);
				}
				
				
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
		return projectSubStateName;
	}
	
	function clearCheckBox(){
		$("input[type='checkbox']").prop("checked",false);
	}
	
	function editProjectSubState(){
		var subStateArr = new Array()
		$("input[type='checkbox']").each(function() {
			if($(this).is(":checked")){
				var projectState = $(this).attr('id').substring(8,9);
				var name = $("#subStateName"+$(this).attr('id').substring(8,10)).text();
				var pId = $(this).attr('id').substring(9,10);
				subStateArr.push(pId+"#"+name+"#"+projectState);
			}
		});
		$.ajax({
			url : host + "/editProjectSubState",
			type : 'POST',
			cache : false,
			dataType : "json",
			data : {
				"subStateArr" : subStateArr,
				"projectType":$("#projectType").val()
			},
			traditional : true,
			success : function(returndata) {
				var data = returndata.errcode;
				if (data == 0) {
					alert("提交成功");
				} else {
					alert("提交失败");
				}
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
	}
	
	
</script>
</head>
<body id="mBody">
	<div id="pageAll">
		<div class="pageTop">
			<div class="page">
				<img src="../image/coin02.png" /><span><a href="#">首页</a>&nbsp;-&nbsp;<a
					href="#">系统管理</a>&nbsp;-</span>&nbsp;项目进度管理
			</div>
		</div>

		<div class="page">
			<!-- vip页面样式 -->
			<div class="vip">
				<div class="conform">
					<form style="width: 100%">
						<div class="cfD" style="width: 100%">
							<input type="radio" name="field03" value="2" checked="checked"
								onclick="checkProjectState(2)"
								style="margin-left: 50px; margin-right: 5px;" /> <label>共享陪护</label>
							<input type="radio" name="field03" value="1"
								onclick="checkProjectState(1)"
								style="margin-left: 50px; margin-right: 5px;" /> <label>信息</label>

							<label style="margin-right: 10px;margin-left:30px">产品类型：</label><select
								class="selCss" style="width: 23%" id="projectType" onChange="changeType(this.options[this.options.selectedIndex].value)" /></select>
						</div>
					</form>
				</div>

				<div class="conShow">
					<table border="1" style="width: 100%">
						<tr style="width: 100%">
							<td style="width: 15%; font-weight: bold" class="tdColor">项目状态</td>
							<td style="width: 15%; font-weight: bold;" class="tdColor">项目阶段</td>
							<td style="width: 35%; font-weight: bold;" class="tdColor">说明</td>
							<td style="width: 30%; font-weight: bold;" class="tdColor">当前进度更新条件</td>
							<td style="width: 5%; font-weight: bold;" class="tdColor">操作</td>
						</tr>
					</table>
					<table id="tb" border="1" style="width: 100%;">
						<tr style="width: 100%">
							<td style="width: 15%;" class="tdColor2">售前服务</td>
							<td style="width: 15%" class="tdColor2" id="subStateName00">项目启动</td>
							<td style="width: 35%" class="tdColor2">走现场跟客户联系沟通阶段</td>
							<td style="width: 30%" class="tdColor2"></td>
							<td style="width: 5%" class="tdColor2"><input
								type="checkbox" onclick="selectState" id="checkbox00" disabled="disabled"/></td>
						</tr>
						<tr style="width: 100%">
							<td style="width: 15%" class="tdColor2"></td>
							<td style="width: 15%" class="tdColor2" id="subStateName01">项目确认</td>
							<td style="width: 35%" class="tdColor2"></td>
							<td style="width: 30%" class="tdColor2"></td>
							<td style="width: 5%" class="tdColor2"><input
								type="checkbox" onclick="selectState" id="checkbox01"/></td>
						</tr>
						<tr style="width: 100%">
							<td style="width: 15%" class="tdColor2"></td>
							<td style="width: 15%" class="tdColor2" id="subStateName02">招投标/签合同</td>
							<td style="width: 35%" class="tdColor2">做标书，投标</td>
							<td style="width: 30%" class="tdColor2">招投标信息,合同录入</td>
							<td style="width: 5%" class="tdColor2"><input
								type="checkbox" onclick="selectState" id="checkbox02"/></td>
						</tr>
						<tr style="width: 100%">
							<td style="width: 15%;" class="tdColor2">项目实施</td>
							<td style="width: 15%" class="tdColor2" id="subStateName10">到货验收</td>
							<td style="width: 35%" class="tdColor2">采购运输等</td>
							<td style="width: 30%" class="tdColor2">已上传标书，合同</td>
							<td style="width: 5%" class="tdColor2"><input
								type="checkbox" onclick="selectState" id="checkbox10"/></td>
						</tr>
						<tr style="width: 100%">
							<td style="width: 15%;" class="tdColor2"></td>
							<td style="width: 15%" class="tdColor2" id="subStateName11">实施安装/投放</td>
							<td style="width: 35%" class="tdColor2">包含现场测试</td>
							<td style="width: 30%" class="tdColor2">已上传验收单文件</td>
							<td style="width: 5%" class="tdColor2"><input
								type="checkbox" onclick="selectState" id="checkbox11"/></td>
						</tr>
						<tr style="width: 100%">
							<td style="width: 15%;" class="tdColor2"></td>
							<td style="width: 15%" class="tdColor2" id="subStateName12">项目验收</td>
							<td style="width: 35%" class="tdColor2">客户验收</td>
							<td style="width: 30%" class="tdColor2">已上传验收报告</td>
							<td style="width: 5%" class="tdColor2"><input
								type="checkbox" onclick="selectState" id="checkbox12"/></td>
						</tr>
						<tr style="width: 100%">
							<td style="width: 15%;" class="tdColor2">售后服务</td>
							<td style="width: 15%" class="tdColor2" id="subStateName20">售后运维</td>
							<td style="width: 35%" class="tdColor2">维保/运维</td>
							<td style="width: 30%" class="tdColor2"></td>
							<td style="width: 5%" class="tdColor2"><input
								type="checkbox" onclick="selectState" id="checkbox20"/></td>
						</tr>
						<tr style="width: 100%">
							<td style="width: 15%;" class="tdColor2">项目结束关闭</td>
							<td style="width: 15%" class="tdColor2" id="subStateName30">项目关闭</td>
							<td style="width: 35%" class="tdColor2">合同期结束或者项目完成</td>
							<td style="width: 30%" class="tdColor2"></td>
							<td style="width: 5%" class="tdColor2"><input
								type="checkbox" onclick="selectState" id="checkbox30" disabled="disabled"/></td>
						</tr>
						<tr style="width: 100%">
							<td style="width: 15%;" class="tdColor2">项目失败关闭</td>
							<td style="width: 15%" class="tdColor2" id="subStateName40">项目关闭</td>
							<td style="width: 35%" class="tdColor2"></td>
							<td style="width: 30%" class="tdColor2">未中标</td>
							<td style="width: 5%" class="tdColor2"><input
								type="checkbox" onclick="selectState" id="checkbox40" disabled="disabled"/></td>
						</tr>
					</table>
				</div>
				<!-- vip 表格 显示 end-->
				<div class="cfD" style="margin-bottom: 30px;"
						id="operation">
						<a class="addA" href="#" onclick="editProjectSubState()"
							style="margin-left: 10px;margin-top: 20px">保存</a> <a class="addA" href="#"
							onclick="toBackPage()">返回</a>
					</div>
			</div>
		</div>
	</div>
</body>
</html>