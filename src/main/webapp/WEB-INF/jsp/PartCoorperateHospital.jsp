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
<title>合作医院</title>
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/css.css?v=1990" />
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.2.1.min.js"></script>

<script type="text/javascript">
	var limitStr = "";
	var str = "";
	var host = "";
	var ImageList = null;
	var urlList = null;
	
	$(document).ready(function() {
		host = "${pageContext.request.contextPath}";
		document.getElementById('titleView').innerHTML = document.title
		//getImageList();
		ImageList = ["上海市中山医院","国际和平妇幼保健院","上海华山医院宝山分院","上海仁济医院宝山分院","上海第八人民医院","上海徐汇区中心医院"];
		getDefaultView();
	});

	function backPage() {
	}
	
	function showMoreHospital(){
		url = host + "/page/cooperateHospital";
		window.location.href = url;
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
						ImageList.push(list[i].name.split('.')[0]);
					}
					getView();
				}else if(code==2){
					//无列表
					ImageList = new Array();
					getView();
				}else{
					//获取失败
					ImageList = ["上海市中山医院","国际和平妇幼保健院","上海华山医院宝山分院","上海仁济医院宝山分院","上海第八人民医院","上海徐汇区中心医院"];
					getDefaultView();
				}
				
			} 
		};
	}
	
	function getDefaultView(){
		var str;
		for (var i = 1; i <= 6; i=i+2) {
			var srcUrlLeft = host + "/image/wpa/hospital/医院0" + i + ".png";
			var srcUrlRight = host + "/image/wpa/hospital/医院0" + parseInt(i*1+1) + ".png";
			str +="<div style='display: flex; flex-direction: row;width:100%'>"
			+"<div style='width:50%;margin-top:16px;display: flex; flex-direction: column;align-items: center'>"
			+"<image style='width:154px;height:154px' src='"+ srcUrlLeft +"'></image>"
			+"<text style='font-size:12px;font-weight:400;margin-top:12px'>"+ImageList[i-1]+"</text></div>"
			+"<div style='width:50%;margin-top:16px;display: flex; flex-direction: column;align-items: center'>"
			+"<image style='width:154px;height:154px' src='"+ srcUrlRight +"'></image>"
			+"<text style='font-size:12px;font-weight:400;margin-top:12px'>"+ImageList[i]+"</text></div></div>"
		}
		$("#hospitalDiv").empty();
		$("#hospitalDiv").append(str);
	}
	
	function getView(){
		if(ImageList.length>0){
			var str = ""
			for(i in ImageList){
				str += ImageList[i]+"=";
			}
			getImageUrlList(str);
		}
	}
	
	function getImageUrlList(nameList){
		var formData = new FormData();
		formData.append('nameList', nameList);		
		var xhr = new XMLHttpRequest();
		xhr.open("POST", "${pageContext.request.contextPath}/getClientImageThumb");
		xhr.send(formData);
		xhr.onreadystatechange = function() {
			if (xhr.readyState == 4) {
				var code = eval("(" + xhr.responseText + ")").errcode;
				if(code==0){
					urlList = new Array()
					for(i in eval("(" + xhr.responseText + ")").errmsg.imageList){
						urlList.push(eval("(" + xhr.responseText + ")").errmsg.imageList[i])
					}
				}else{
					//无图
				}
				var str;
				for (var i = 1; i <= ImageList.length; i=i+2) {
					var srcUrlLeft = urlList[i-1];
					var srcUrlRight =  urlList[i];
					str +="<div style='display: flex; flex-direction: row;width:100%'>"
					+"<div style='width:50%;margin-top:16px;display: flex; flex-direction: column;align-items: center'>"
					+"<image style='width:154px;height:154px' src='"+ srcUrlLeft +"'></image>"
					+"<text style='font-size:12px;font-weight:400;margin-top:12px'>"+ImageList[i-1]+"</text></div>"
					+"<div style='width:50%;margin-top:16px;display: flex; flex-direction: column;align-items: center'>"
					+"<image style='width:154px;height:154px' src='"+ srcUrlRight +"'></image>"
					+"<text style='font-size:12px;font-weight:400;margin-top:12px'>"+ImageList[i]+"</text></div></div>"
				}
				$("#hospitalDiv").empty();
				$("#hospitalDiv").append(str);
			}
		};
	}
</script>
</head>

<body style="margin: 0; background-color: #DFF4F5;display:flex;flex-direction: column;">
	<div
		style="width: 100%; height: 50px; display: flex; align-items: center; flex-direction: row; align-items: center; background-color: #5EC7CE;position:fixed;">
		<div
			style="width: 20%; height: 100%; display: flex; flex-direction: row; align-items: center;visibility:hidden"
			onclick="backPage()">
			<img style="width: 24px; height: 24px;margin-left:20px"
				src="${pageContext.request.contextPath}/image/ic_back.png"></img>
		</div>
		<div
			style="width: 60%; height: 100%; display: flex; flex-direction: row; align-items: center; justify-content: center; font-size: 18px; color: #fff;"
			id="titleView"></div>
		<div style="width: 20%; height: 100%;"></div>
	</div>
	<div id="mDiv2" style="width:100%;display: flex; flex-direction: column;margin-top:50px">
		<div style="display:flex;flex-direction: row; align-items: center; justify-content: center; height:54px;margin-top:18px;width:100%;">
		<text style="font-size:36px">部分合作医院</text>
        </div>
        <div id="hospitalDiv" style="width:100%;display:flex;flex-direction: column;font-size:0"></div>
        <div style="display:flex;flex-direction: row; align-items: center;width:100%">
        <div style="height:60px;width:100%;border:2px solid #F68D4E;margin:50px 24px;display: flex; flex-direction: row; align-items: center;justify-content: center;"
        onclick="showMoreHospital()">
        <text style="font-size:16px;color:#F68D4E;font-weight:700">查看更多</text>
        </div>
        </div>
	</div>
</body>
</html>