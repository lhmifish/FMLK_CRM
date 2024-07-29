<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="renderer" content="webkit" />
<meta http-equiv="pragma" content="no-cache" />
<meta http-equiv="cache-control" content="no-cache" />
<title>审核项目</title>
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/css.css?v=1997" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/select4.css?v=1999" />
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.2.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/select3.js"></script>
<style type="text/css">
a:hover {
	color: #FF00FF
} /* 鼠标移动到链接上 */
</style>
<script type="text/javascript">
	$(document).ready(function() {
		var sId = "${sessionId}";
		getUserPermissionList(sId);
	});
	
	function getUserPermissionList(mNickName) {
		$.ajax({
			url : "${pageContext.request.contextPath}/getUserPermissionList",
			type : 'GET',
			data : {
				"nickName" : mNickName
			},
			cache : false,
			async : false,
			success : function(returndata) {
				var data = eval("(" + returndata + ")").permissionSettingList;
				var isReject = true;
				for ( var i in data) {
					if(data[i].permissionId == 15){
						isReject = false;
					}
				}
				if(isReject){
					window.location.href = "${pageContext.request.contextPath}/page/error";
				}else{
					$('#body').show();
				}
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});

	}

	

	
</script>
</head>
<body id="body" style="display:none">
imcomplete
</body>
</html>