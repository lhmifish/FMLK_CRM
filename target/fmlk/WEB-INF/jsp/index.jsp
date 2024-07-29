<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
<title>首页 - 飞默利凯信息服务平台</title>
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/css.css?v=1990" />
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.2.1.min.js"></script>
<style type="text/css">
a:link {
	color: #000
} /* 未访问的链接 */
a:hover {
	color: #FF00FF
} /* 鼠标移动到链接上 */

</style>

<script type="text/javascript">
	var sId;
	var host;
	$(document)
			.ready(
					function() {
						sId = "${sessionId}";
						host = "${pageContext.request.contextPath}";
						if (sId == null || sId == "") {
							window.location.href = "${pageContext.request.contextPath}/page/login";
						}
					});

	function ResetPsd(uid) {
        var host = "${pageContext.request.contextPath}";
        var str = '<div class="delete"><div class="close"><a><img src="${pageContext.request.contextPath}/image/shanchu.png" onclick="closeConfirmBox()" /></a>'
				+ '</div><p class="delP1">修改密码</p>'
				+ '<p class="delP2" style="margin-top: 20px;"><label style="font-size: 16px;">旧密码：</label>'
				+ '<input type="password" style="width: 250px; height: 26px; border-bottom: 1px dashed #78639F; border-left: none; border-right: none; border-top: none; width: 180px; padding-left: 10px;"'
				+ ' placeholder="输入旧密码" id="oldPsd" /></p>'
				+'<p class="delP2" style="margin-top: 20px;"><label style="font-size: 16px;">新密码：</label>'
				+ '<input type="password" style="width: 250px; height: 26px; border-bottom: 1px dashed #78639F; border-left: none; border-right: none; border-top: none; width: 180px; padding-left: 10px;"'
				+ ' placeholder="输入新密码(不能少于6位)" id="newPsd" /></p><div class="cfD" style="margin-top: 30px">'
				+ '<a class="addA" onclick="changePsd('+ uid + ',\''+ sId +'\',\''+ host +'\')" style="margin-left: 0px; margin-bottom: 30px;">确定</a> <a class="addA" onclick="closeConfirmBox()">取消</a></div></div>';
        var body = document.getElementById('rightFrame').contentWindow.document.body;
        var div = document.getElementById('rightFrame').contentWindow.document
				.createElement("div");
		div.setAttribute("id", "banDel999");
		div.setAttribute("class", "banDel");
		div.style.display = 'block';
		div.innerHTML = str;
        body.appendChild(div);
	}
	
</script>
</head>

<frameset rows="100,*" cols="*" framespacing="0" frameborder="no"
	border="0">
	<frame src="head" name="headFrame" id="headFrame" title="headFrame" />
	<frameset rows="100*" cols="220,*" framespacing="0" frameborder="no"
		border="0">
		<frame src="left" name="leftFrame" id="leftFrame" title="leftFrame" />
		<frame src="techJobList" name="rightFrame" scrolling="yes"
			noresize="noresize" id="rightFrame" title="rightFrame" />
	</frameset>
</frameset>

</html>