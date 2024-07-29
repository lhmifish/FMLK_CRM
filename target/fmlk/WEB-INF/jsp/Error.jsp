<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Error</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/main.css?v=2014">
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.2.1.min.js"></script>
<script type="text/javascript">
</script>
</head>
<body>
	<!-- <div id="div"
		style="display: table-cell; font-size: 20px; vertical-align: middle; text-align: center; color: red">
		<strong>你没有权限查看此页</strong>
	</div> -->

	<div id="wrapper">
		<a class="logo" href="/"></a>
		<div id="main">
			<header id="header">
				<h1>
					<span class="icon">!</span>Sorry<span class="sub">page is not available for you<br/>对不起,你没有权限查看此页面</span>
				</h1>
			</header>
		</div>
	</div>

</body>
</html>