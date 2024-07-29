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
<title>修改合作入驻的客户</title>
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/css.css?v=1990" />
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.2.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/jweixin-1.0.0.js"></script>
<script src="${pageContext.request.contextPath}/js/getObjectList.js"></script>
<script src="${pageContext.request.contextPath}/js/select3.js"></script>
<script
	src="${pageContext.request.contextPath}/js/jquery.table2excel.js"></script>
<script type="text/javascript">
	var mClientList;//客户列表
	var ImageList;//已上传图片列表
	var operationType = 1;
	var operationId = '';
	var buttonEnable = true;
	
	$(document).ready(function() {
		getImageList();
	});

	function getClientList() {
		$.ajax({
					url : "${pageContext.request.contextPath}/clientList",
					type : 'GET',
					data : {},
					cache : false,
					async : false,
					success : function(returndata) {
						var data = eval("(" + returndata + ")").clientList;
						var str="";
						mClientList = new Array()
						for(var i in data){
							var imgName = data[i].clientName+".png";
							mClientList.push(data[i].clientName);
							str+='<div style="display:flex;flex-direction: row;border-bottom:1px solid #eee">'
							+'<div style="width:60%"><a style="font-size: 18px; line-height: 35px">' + data[i].clientName + '</a></div>';
							if(ImageList.length>0 && $.inArray(imgName,ImageList)>=0){
								str+='<div style="width:30%;display:flex;flex-direction: row-reverse;align-items:center;"><a style="color:#66C4CE">'+imgName+'</a></div>'
								+'<div style="width:10%;display:flex;flex-direction: row-reverse;align-items:center;">'
								+'<input type="button" value="删除图片" onclick="updateImg(2,'+i+')"></input>';
							}else{
								str+='<div style="width:20%"></div>'
								+'<div style="width:20%;display:flex;flex-direction: row-reverse;align-items:center;">'
								+'<input type="button" value="提交图片" onclick="updateImg(1,'+i+')"></input>'
								+'<input type="file" accept=".png"  name="myfile" id="myfile'+i+'"></input>';
							}
							str+='</div></div>';
						};
						str+='<div style="display:flex;flex-direction: row;">'
							+'<div style="width:90%"><input id="inputClient" style="font-size: 18px; line-height: 35px;border-top:0;border-left:0;border-right:0;width:100%" placeholder="添加新客户"></input></div>'
							+'<div style="width:10%;display:flex;flex-direction: row-reverse;align-items:center">'
			                +'<img style="width:20px;height:20px" src="../image/update.png" onclick="addClient()"/>'
			                +'</div></div>';
						
						$("#clientView").empty();
						$("#clientView").append(str.trim());
						document.getElementById('listTitle').innerHTML = "合作入驻的客户(总数："+ data.length +")";
					},
					error : function(XMLHttpRequest, textStatus, errorThrown) {
					}
				});
	}
	
	function deleteClient(mId){
		$.ajax({
			url : "${pageContext.request.contextPath}/editAllCooperateClient",
			type : 'POST',
			cache : false,
			data : {
				"clientId" : mId,
				"operation" : 2
			},
			success : function(returndata) {
				var data = eval("(" + returndata + ")").errcode;
				if (data == 0) {
					alert("删除客户成功");
					getClientList();
				} else {
					alert("删除失败");
				}
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
	}
	
	function addClient(){
		var newClient = $("#inputClient").val().trim();
		if(newClient=="" || newClient==null){
			alert("客户名为空不能添加");
		}else{
			$.ajax({
				url : "${pageContext.request.contextPath}/editCooperateClient",
				type : 'POST',
				cache : false,
				data : {
					"clientName" : newClient,
					"operation" : 1
				},
				success : function(returndata) {
					var data = eval("(" + returndata + ")").errcode;
					if (data == 0) {
						alert("添加客户成功");
						getImageList();
					} else if (data == 3) {
						alert("有相同或类似的客户名存在，请勿重复输入");
						$("#inputClient").val("");
					} else {
						alert("添加失败;错误码："+data);
						$("#inputClient").val("");
					}
				},
				error : function(XMLHttpRequest, textStatus, errorThrown) {
				}
			});
		}
	}
	
	function uploadExcelFile(){
		var myFile = document.getElementById("myfile").files[0];
		if (myFile != undefined){
			if(!myFile.name.endsWith(".xlsx") && !myFile.name.endsWith(".xls")){
				alert("请选择excel文件");
				return;
			}
			var formData = new FormData();
			formData.append('file', myFile);
			var xhr = new XMLHttpRequest();
			xhr.open("POST", "${pageContext.request.contextPath}/editAllCooperateClient");
			xhr.send(formData);
			xhr.onreadystatechange = function() {
				if (xhr.readyState == 4) {
					alert(xhr.responseText);
					getImageList();
					document.getElementById("myfile").value="";
				} 
			} 
			
		}else{
			alert("请先选择文件");
		}
	}
	
	function downloadExcelFile(){
		var mTable = "<table style='display:none' id='table1'>";
		for(var i=0;i<mClientList.length;i++){
			mTable += "<tr><td>" + mClientList[i] + "</td></tr>";
		}
		mTable += "</table>";
		$("#div2").append(mTable);
		$('#table1').table2excel({
		filename : "最新客户清单.xlsx"});
		$("#div2").empty(); 
	}
	
	function updateImg(type,index){
		if(!buttonEnable){
			alert("==按钮不可操作,请检查==");
		}else{
			//type  1.提交 2.删除
			operationType = type
			operationId  = index
			if(type==1){
				var myFile = document.getElementById("myfile"+index).files[0];
				if (myFile != undefined){
					if(!myFile.name.endsWith(".png")){
						alert("只支持png图片");
						return;
					}else{
						$("#banDel2").show();
						document.getElementById('banTitle').innerHTML = "是否要提交</br>"+mClientList[index]+"</br>的图片";
					}
				}else{
					alert("请先选择图片文件");
				}
			}else{
				$("#banDel2").show();
				document.getElementById('banTitle').innerHTML = "是否要删除</br>"+mClientList[index]+"</br>的图片";
			}
		}
	}
	
	function closeConfirmBox(){
		$(".banDel").hide();
	}
	
	function confirm(){
		var formData = new FormData();
		var mUrl = "";
		formData.append('fileName', mClientList[operationId]+".png");
		if(operationType==1){
		    //添加图片
			var mFile = document.getElementById("myfile"+operationId).files[0];
		    formData.append('file',mFile);
			formData.append('fileSize', mFile.size);
			mUrl = "${pageContext.request.contextPath}/addClientImage";
		}else{
			//删除图片
			mUrl = "${pageContext.request.contextPath}/removeClientImage";
		}
		var xhr = new XMLHttpRequest();
		xhr.open("POST", mUrl);
		xhr.send(formData);
		xhr.onreadystatechange = function() {
			if (xhr.readyState == 4) {
				alert(eval("(" + xhr.responseText + ")").errmsg);
				$(".banDel").hide();
				getImageList();
			} 
		};
	}
	
	function getImageList(){
		var xhr = new XMLHttpRequest();
		xhr.open("POST", "${pageContext.request.contextPath}/getClientImageList");
		xhr.send(null);
		xhr.onreadystatechange = function() {
			if (xhr.readyState == 4) {
				var code = eval("(" + xhr.responseText + ")").errcode;
				if(code==0){
					//获取到列表
					ImageList = new Array();
					var list = eval("(" + xhr.responseText + ")").errmsg;
					for(var i in list){
						ImageList.push(list[i].name);
					}
				}else if(code==2){
					//无列表
					ImageList = new Array();
				}else{
					//获取失败
					buttonEnable = false;
				}
				getClientList();
			} 
		};
	}
</script>
</head>


<body style="margin: auto;">
	<div style="width: 100%; height: 100%;">
		<div
			style="border-bottom: 2px solid #ccc; margin: 0 20px; margin-bottom: 20px">
			<a
				style="font-size: 36px; color: #66C4CE; margin-left: 20px; line-height: 80px" id="listTitle"></a>
		</div>
		<div style="margin: 0 20px; margin-top: 20px; margin-bottom: 30px;">
			<div style="margin: 0 10px; display: flex; flex-direction: column"
				id="clientView"></div>
			<div style="margin: 0 10px; display: flex; flex-direction: row">
				<input type='file' accept=".xlsx,.xls"
					style="margin-top: 20px; width: 80%;" name="myfile" id="myfile"></input>
				<div
					style="margin-top: 20px; width: 10%; flex-direction: row; justify-content: flex-end; display: flex">
					<input type='button' value="下载清单模板" onclick="downloadExcelFile()"></input>
				</div>
				<div
					style="margin-top: 20px; width: 10%; flex-direction: row; justify-content: flex-end; display: flex">
					<input type='button' value="提交客户清单(sheet0)" onclick="uploadExcelFile()"></input>
				</div>
			</div>
			<div id="div2"></div>
		</div>
	</div>
	
	<div class="banDel" id="banDel2">
		<div class="delete">
			<div class="close">
				<a><img src="../image/shanchu.png" onclick="closeConfirmBox()" /></a>
			</div>
			<p class="delP1" id="banTitle" style="margin: 10px 20px"></p>
			<div class="cfD" style="margin-top: 30px">
				<a class="addA" href="#" onclick="confirm()"
					style="margin-left: 0px; margin-bottom: 30px;">确定</a> <a
					class="addA" onclick="closeConfirmBox()">取消</a>
			</div>
		</div>
	</div>


</body>
</html>