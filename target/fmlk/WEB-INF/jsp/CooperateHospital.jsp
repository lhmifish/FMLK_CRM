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
<title>合作入驻的医院</title>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.2.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/jweixin-1.0.0.js"></script>
<script src="${pageContext.request.contextPath}/js/getObjectList.js"></script>
<script src="${pageContext.request.contextPath}/js/select3.js"></script>
<script type="text/javascript">
	$(document).ready(function() {
		getClientList();
	});

	function getClientList() {
		$.ajax({
					url : "${pageContext.request.contextPath}/clientList",
					type : 'GET',
					data : {},
					cache : false,
					async : false,
					success : function(returndata) {
						//alert(returndata);
						var data = eval("(" + returndata + ")").clientList;
						var str="";
						for(var i in data){
							str+="<a style='font-size: 18px; line-height: 35px'>" + data[i].clientName + "</a>";
						}
						$("#clientView").empty();
						$("#clientView").append(str.trim());
					},
					error : function(XMLHttpRequest, textStatus, errorThrown) {
					}
				});
	}
</script>
</head>


<body style="margin: auto;">
	<div style="width: 100%; height: 100%;">
		<div
			style="border-bottom: 2px solid #ccc; margin: 0 20px; margin-bottom: 20px">
			<a
				style="font-size: 36px; color: #66C4CE; margin-left: 20px; line-height: 80px">合作入驻的医院</a>
		</div>
		<div style="margin: 0 20px; margin-top: 20px; margin-bottom: 30px;">
			<div style="margin: 0 10px; display: flex; flex-direction: column" id="clientView">
				<a style="font-size: 18px; line-height: 35px">上海市宝山区罗店医院</a> <a
					style="font-size: 18px; line-height: 35px">上海市华山宝山分院（仁和医院）</a> <a
					style="font-size: 18px; line-height: 35px">上海市普陀区利群医院</a> <a
					style="font-size: 18px; line-height: 35px">上海市仁济宝山分院（大场医院）</a> <a
					style="font-size: 18px; line-height: 35px">上海市宝山区中冶医院</a> <a
					style="font-size: 18px; line-height: 35px">上海市宝山区罗店医院</a> <a
					style="font-size: 18px; line-height: 35px">上海能量谷门诊部有限公司</a> <a
					style="font-size: 18px; line-height: 35px">金华市人民医院</a> <a
					style="font-size: 18px; line-height: 35px">泰兴市中医院</a> <a
					style="font-size: 18px; line-height: 35px">乐清市人民医院</a> <a
					style="font-size: 18px; line-height: 35px">上海能量谷门诊部有限公司（私立医院）</a> <a
					style="font-size: 18px; line-height: 35px">安徽中医药大学第一附属医院</a> <a
					style="font-size: 18px; line-height: 35px">上海市黄浦区美格美发店</a> <a
					style="font-size: 18px; line-height: 35px">上海浩居餐饮有限公司</a> <a
					style="font-size: 18px; line-height: 35px">上海和盟餐饮管理有限公司</a> <a
					style="font-size: 18px; line-height: 35px">上海一鼎餐饮有限公司</a> <a
					style="font-size: 18px; line-height: 35px">米钱米锦（上海）餐饮有限公司</a>
			</div>
		</div>


	</div>


</body>
</html>