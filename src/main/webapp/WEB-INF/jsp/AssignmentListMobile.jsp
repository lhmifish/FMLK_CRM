<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>事务看板</title>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/amazeui2.css?v=2023" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/select3.css?v=2023" />
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.2.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/select3.js"></script>
<script type="text/javascript">
	var eachNum;
	$(document)
			.ready(
					function() {
						var h = document.documentElement.clientHeight;
						eachNum = Math.floor((h - 65) / 110);
						document.getElementById('coloum_1').style.height = (eachNum * 100)
								+ "px";
						document.getElementById('coloum_2').style.height = (eachNum * 100)
								+ "px";
						document.getElementById('coloum_3').style.height = (eachNum * 100)
								+ "px";
						document.getElementById('coloum_4').style.height = (eachNum * 100)
								+ "px";
						$("#saleUser").select2({
						});
						$("#techUser").select2({
						});
						$("#company").select2({
							tags : true
						});
						getSaleUser();
						getTechUser();
						getCompany();
						getList();
					});

	function edit(id) {
		window.location.href = "${pageContext.request.contextPath}/page/editAssignment/"
				+ id
	}
	
	function createAssignment(){
		window.location.href = "${pageContext.request.contextPath}/page/createAssignmentOrder"
	}
	
	function getDateStr(date) {
		var y = date.getFullYear();
		var m = date.getMonth() < 9 ? ("0" + (date.getMonth() + 1)) : (date
				.getMonth() + 1);
		var d = date.getDate() < 10 ? ("0" + date.getDate()) : date.getDate();
		var str = y + "/" + m + "/" + d;
		return str;
	}

	function getSaleUser(){
		$.ajax({
			url : "${pageContext.request.contextPath}/userList",
			type : 'GET',
			data : {
				"dpartId" : 2,
				"date":getDateStr(new Date()),
				"name" : "",
				"nickName" : "",
				"jobId" : "",
				"isHide":true
			},
			cache : false,
			async : false,
			success : function(returndata) {
				var str = '<option value="top">请选择...</option>';
				var data2 = eval("(" + returndata + ")").userlist;
				for ( var i in data2) {
					str += '<option value="'+data2[i].name+'">' + data2[i].name
							+ '</option>';
				}
				$("#saleUser").empty();
				$("#saleUser").append(str);

			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
	}
	
	function getTechUser(){
		$.ajax({
			url : "${pageContext.request.contextPath}/userList",
			type : 'GET',
			data : {
				"dpartId" : 1,
				"date":getDateStr(new Date()),
				"name" : "",
				"nickName" : "",
				"jobId" : "",
				"isHide":true
			},
			cache : false,
			async : false,
			success : function(returndata) {
				var str = '<option value="top">请选择...</option>';
				var data2 = eval("(" + returndata + ")").userlist;
				for ( var i in data2) {
					str += '<option value="'+data2[i].name+'">' + data2[i].name
							+ '</option>';
				}
				$("#techUser").empty();
				$("#techUser").append(str);

			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
	}
	
	function getCompany(){
		$.ajax({
			url : "${pageContext.request.contextPath}/getClientCompany",
			type : 'GET',
			data : {},
			cache : false,
			async : false,
			success : function(returndata) {
				var str = '<option value="top">请选择...</option>';
				var data2 = eval("(" + returndata + ")").companylist;
				for ( var i in data2) {
					str += '<option value="'+data2[i].companyId+'">' + data2[i].companyName
							+ '</option>';
				}
				$("#company").empty();
				$("#company").append(str);

			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
		
	}

	function getList() {
		$
				.ajax({
					url : "${pageContext.request.contextPath}/getAssignmentList",
					type : 'GET',
					data : {},
					cache : false,
					async : false,
					success : function(returndata) {
						var strColumn_1 = '', strColumn_2 = '', strColumn_3 = '', strColumn_4 = '';
						var num_column_1 = 0, num_column_2 = 0, num_column_3 = 0, num_column_4 = 0
						var data2 = eval("(" + returndata + ")").assignlist;
						for ( var i in data2) {
							var state = data2[i].state;
							var importment = (data2[i].rank == 1) ? "★★★ " : "";
							var colorStr;
							if(state == 1){
								colorStr = '<div class="column_top" style="background:black;color:white">'
							}else if(state == 2){
								colorStr = '<div class="column_top" style="background:orange;color:white">'
							}else if(state == 3){
								colorStr = '<div class="column_top" style="background:red;color:white">'
							}else if(state == 4){
								colorStr = '<div class="column_top" style="background:green;color:white">'
							}else if(state == 5){
								colorStr = '<div class="column_top" style="background:blue;color:white">'
							}else if(state == 6){
								colorStr = '<div class="column_top" style="background:brown;color:white">'
							}
							
							
							if (state == 3) {//超时未完成
								if (num_column_1 < eachNum) {
									strColumn_1 += '<div class="column" onclick="edit('
											+ data2[i].id
											+ ')">'
											+ colorStr
											+ '<span style="color: white; font-weight: bold;">'
											+ importment
											+ '</span>'
											+ '<strong>'
											+ data2[i].projectName
											+ '</strong></div>'
											+ '<div class="am-panel-bd" style="display: block;">'
											+ '<ul class="am-list admin-content-file" >'
											+ '<li>'
											+ '<p class="column_p">内容：'
											+ data2[i].serviceContent
											+ '</p>'
											+'<p class="column_p">开始：'
											+ data2[i].startDate 
											+ '</p>'
											+ '<p class="column_p">结束：'
											+ data2[i].endDate
											+ '</p>'
											+ '<p class="column_p">参与：'
											+ data2[i].userList
											+ '</p></li>'
											+ '</ul></div></div>';
								}
								num_column_1++;
							} else if (state == 6) {//待销售确认
								if (num_column_2 < eachNum) {
									strColumn_2 += '<div class="column" onclick="edit('
											+ data2[i].id
											+ ')">'
											+ colorStr
											+ '<span style="color: white; font-weight: bold;">'
											+ importment
											+ '</span>'
											+ '<strong>'
											+ data2[i].projectName
											+ '</strong></div>'
											+ '<div class="am-panel-bd" style="display: block;">'
											+ '<ul class="am-list admin-content-file" >'
											+ '<li>'
											+ '<p class="column_p">内容：'
											+ data2[i].serviceContent
											+ '</p>'
											+'<p class="column_p">开始：'
											+ data2[i].startDate
											+ '</p>'
											+ '<p class="column_p">结束：'
											+ data2[i].endDate
											+ '</p>'
											+ '<p class="column_p">参与：'
											+ data2[i].userList
											+ '</p></li>'
											+ '</ul></div></div>';
								}
								num_column_2++;
							} else if (state == 4) {//已完成(正常)
								if (num_column_3 < eachNum) {
									strColumn_3 += '<div class="column" onclick="edit('
											+ data2[i].id
											+ ')">'
											+ colorStr
											+ '<span style="color: white; font-weight: bold;">'
											+ importment
											+ '</span>'
											+ '<strong>'
											+ data2[i].projectName
											+ '</strong></div>'
											+ '<div class="am-panel-bd" style="display: block;">'
											+ '<ul class="am-list admin-content-file" >'
											+ '<li>'
											+ '<p class="column_p">内容：'
											+ data2[i].serviceContent
											+ '</p>'
											+'<p class="column_p">开始：'
											+ data2[i].startDate
											+ '</p>'
											+ '<p class="column_p">结束：'
											+ data2[i].endDate
											+ '</p>'
											+ '<p class="column_p">参与：'
											+ data2[i].userList
											+ '</p></li>'
											+ '</ul></div></div>';
								}
								num_column_3++;
							} else if (state == 5) {//已完成(超时)
								if (num_column_3 < eachNum) {
									strColumn_3 += '<div class="column" onclick="edit('
											+ data2[i].id
											+ ')">'
											+ colorStr
											+ '<span style="color: white; font-weight: bold;">'
											+ importment
											+ '</span>'
											+ '<strong>'
											+ data2[i].projectName
											+ '</strong></div>'
											+ '<div class="am-panel-bd" style="display: block;">'
											+ '<ul class="am-list admin-content-file" >'
											+ '<li>'
											+ '<p class="column_p">内容：'
											+ data2[i].serviceContent
											+ '</p>'
											+'<p class="column_p">开始：'
											+ data2[i].startDate
											+ '</p>'
											+ '<p class="column_p">结束：'
											+ data2[i].endDate
											+ '</p>'
											+ '<p class="column_p">参与：'
											+ data2[i].userList
											+ '</p></li>'
											+ '</ul></div></div>';
								}
								num_column_3++;
							} else {

							}
							if (data2[i].rank == 1) {
								if (num_column_4 < eachNum) {
									strColumn_4 += '<div class="column" onclick="edit('
											+ data2[i].id
											+ ')">'
											+ colorStr
											+ '<span style="color: white; font-weight: bold;">'
											+ importment
											+ '</span>'
											+ '<strong>'
											+ data2[i].projectName
											+ '</strong></div>'
											+ '<div class="am-panel-bd" style="display: block;">'
											+ '<ul class="am-list admin-content-file" >'
											+ '<li>'
											+ '<p class="column_p">内容：'
											+ data2[i].serviceContent
											+ '</p>'
											+ '<p class="column_p">开始：'
											+ data2[i].startDate
											+ '</p>'
											+ '<p class="column_p">结束：'
											+ data2[i].endDate
											+ '</p>'
											+ '<p class="column_p">参与：'
											+ data2[i].userList
											+ '</p></li>'
											+ '</ul></div></div>';
								}
								num_column_4++;
							}

						}
						
						document.getElementById('num_1').innerHTML = "";
						document.getElementById('num_2').innerHTML = "";
						document.getElementById('num_3').innerHTML = "";
						document.getElementById('num_4').innerHTML = "";
						
						document.getElementById('num_1').innerHTML += num_column_1;//超时未完成
						document.getElementById('num_2').innerHTML += num_column_2;//待确认
						document.getElementById('num_3').innerHTML += num_column_3;//已完成
						document.getElementById('num_4').innerHTML += num_column_4;//重要
						$("#coloum_1").empty();
						$("#coloum_2").empty();
						$("#coloum_3").empty();
						$("#coloum_4").empty();
						$("#coloum_1").append(strColumn_1);
						$("#coloum_2").append(strColumn_2);
						$("#coloum_3").append(strColumn_3);
						$("#coloum_4").append(strColumn_4);
						document.getElementById('more_1').style.visibility = (num_column_1 > eachNum) ? "visible"
								: "hidden";
						document.getElementById('more_2').style.visibility = (num_column_2 > eachNum) ? "visible"
								: "hidden";
						document.getElementById('more_3').style.visibility = (num_column_3 > eachNum) ? "visible"
								: "hidden";
						document.getElementById('more_4').style.visibility = (num_column_4 > eachNum) ? "visible"
								: "hidden";
					},
					error : function(XMLHttpRequest, textStatus, errorThrown) {
					}

				});
	}
	
	function getList2(saleUser,techUser,company) {
		$
				.ajax({
					url : "${pageContext.request.contextPath}/getAssignmentList2",
					type : 'GET',
					data : {"saleUser" : saleUser,
						    "techUser" : techUser,
						    "company" : company},
					cache : false,
					async : false,
					success : function(returndata) {
						var strColumn_1 = '', strColumn_2 = '', strColumn_3 = '', strColumn_4 = '';
						var num_column_1 = 0, num_column_2 = 0, num_column_3 = 0, num_column_4 = 0
						var data2 = eval("(" + returndata + ")").assignlist;
						
						for ( var i in data2) {
							var state = data2[i].state;
							var importment = (data2[i].rank == 1) ? "★★★ " : "";
							var colorStr;
							if (state == 1) {
								colorStr = '<div class="column_top" style="background:black;color:white">'
							} else if (state == 2) {
								colorStr = '<div class="column_top" style="background:orange;color:white">'
							} else if (state == 3) {
								colorStr = '<div class="column_top" style="background:red;color:white">'
							} else if (state == 4) {
								colorStr = '<div class="column_top" style="background:green;color:white">'
							} else if (state == 5) {
								colorStr = '<div class="column_top" style="background:blue;color:white">'
							} else if (state == 6) {
								colorStr = '<div class="column_top" style="background:brown;color:white">'
							}

							if (state == 3) {//超时未完成
								if (num_column_1 < eachNum) {
									strColumn_1 += '<div class="column" onclick="edit('
											+ data2[i].id
											+ ')">'
											+ colorStr
											+ '<span style="color: white; font-weight: bold;">'
											+ importment
											+ '</span>'
											+ '<strong>'
											+ data2[i].projectName
											+ '</strong></div>'
											+ '<div class="am-panel-bd" style="display: block;">'
											+ '<ul class="am-list admin-content-file" >'
											+ '<li>'
											+ '<p class="column_p">内容：'
											+ data2[i].serviceContent
											+ '</p>'
											+ '<p class="column_p">开始：'
											+ data2[i].startDate
											+ '</p>'
											+ '<p class="column_p">结束：'
											+ data2[i].endDate
											+ '</p>'
											+ '<p class="column_p">参与：'
											+ data2[i].userList
											+ '</p></li>'
											+ '</ul></div></div>';
								}
								num_column_1++;
							} else if (state == 6) {//待销售确认
								if (num_column_2 < eachNum) {
									strColumn_2 += '<div class="column" onclick="edit('
											+ data2[i].id
											+ ')">'
											+ colorStr
											+ '<span style="color: white; font-weight: bold;">'
											+ importment
											+ '</span>'
											+ '<strong>'
											+ data2[i].projectName
											+ '</strong></div>'
											+ '<div class="am-panel-bd" style="display: block;">'
											+ '<ul class="am-list admin-content-file" >'
											+ '<li>'
											+ '<p class="column_p">内容：'
											+ data2[i].serviceContent
											+ '</p>'
											+ '<p class="column_p">开始：'
											+ data2[i].startDate
											+ '</p>'
											+ '<p class="column_p">结束：'
											+ data2[i].endDate
											+ '</p>'
											+ '<p class="column_p">参与：'
											+ data2[i].userList
											+ '</p></li>'
											+ '</ul></div></div>';
								}
								num_column_2++;
							} else if (state == 4) {//已完成(正常)
								if (num_column_3 < eachNum) {
									strColumn_3 += '<div class="column" onclick="edit('
											+ data2[i].id
											+ ')">'
											+ colorStr
											+ '<span style="color: white; font-weight: bold;">'
											+ importment
											+ '</span>'
											+ '<strong>'
											+ data2[i].projectName
											+ '</strong></div>'
											+ '<div class="am-panel-bd" style="display: block;">'
											+ '<ul class="am-list admin-content-file" >'
											+ '<li>'
											+ '<p class="column_p">内容：'
											+ data2[i].serviceContent
											+ '</p>'
											+ '<p class="column_p">开始：'
											+ data2[i].startDate
											+ '</p>'
											+ '<p class="column_p">结束：'
											+ data2[i].endDate
											+ '</p>'
											+ '<p class="column_p">参与：'
											+ data2[i].userList
											+ '</p></li>'
											+ '</ul></div></div>';
								}
								num_column_3++;
							} else if (state == 5) {//已完成(超时)
								if (num_column_3 < eachNum) {
									strColumn_3 += '<div class="column" onclick="edit('
											+ data2[i].id
											+ ')">'
											+ colorStr
											+ '<span style="color: white; font-weight: bold;">'
											+ importment
											+ '</span>'
											+ '<strong>'
											+ data2[i].projectName
											+ '</strong></div>'
											+ '<div class="am-panel-bd" style="display: block;">'
											+ '<ul class="am-list admin-content-file" >'
											+ '<li>'
											+ '<p class="column_p">内容：'
											+ data2[i].serviceContent
											+ '</p>'
											+ '<p class="column_p">开始：'
											+ data2[i].startDate
											+ '</p>'
											+ '<p class="column_p">结束：'
											+ data2[i].endDate
											+ '</p>'
											+ '<p class="column_p">参与：'
											+ data2[i].userList
											+ '</p></li>'
											+ '</ul></div></div>';
								}
								num_column_3++;
							} else {

							}
							if (data2[i].rank == 1) {
								if (num_column_4 < eachNum) {
									strColumn_4 += '<div class="column" onclick="edit('
											+ data2[i].id
											+ ')">'
											+ colorStr
											+ '<span style="color: white; font-weight: bold;">'
											+ importment
											+ '</span>'
											+ '<strong>'
											+ data2[i].projectName
											+ '</strong></div>'
											+ '<div class="am-panel-bd" style="display: block;">'
											+ '<ul class="am-list admin-content-file" >'
											+ '<li>'
											+ '<p class="column_p">内容：'
											+ data2[i].serviceContent
											+ '</p>'
											+ '<p class="column_p">开始：'
											+ data2[i].startDate
											+ '</p>'
											+ '<p class="column_p">结束：'
											+ data2[i].endDate
											+ '</p>'
											+ '<p class="column_p">参与：'
											+ data2[i].userList
											+ '</p></li>'
											+ '</ul></div></div>';
								}
								num_column_4++;
							}

						}
						
						document.getElementById('num_1').innerHTML = "";
						document.getElementById('num_2').innerHTML = "";
						document.getElementById('num_3').innerHTML = "";
						document.getElementById('num_4').innerHTML = "";
						
						document.getElementById('num_1').innerHTML += num_column_1;//超时未完成
						document.getElementById('num_2').innerHTML += num_column_2;//待确认
						document.getElementById('num_3').innerHTML += num_column_3;//已完成
						document.getElementById('num_4').innerHTML += num_column_4;//重要
						$("#coloum_1").empty();
						$("#coloum_2").empty();
						$("#coloum_3").empty();
						$("#coloum_4").empty();
						$("#coloum_1").append(strColumn_1);
						$("#coloum_2").append(strColumn_2);
						$("#coloum_3").append(strColumn_3);
						$("#coloum_4").append(strColumn_4);
						document.getElementById('more_1').style.visibility = (num_column_1 > eachNum) ? "visible"
								: "hidden";
						document.getElementById('more_2').style.visibility = (num_column_2 > eachNum) ? "visible"
								: "hidden";
						document.getElementById('more_3').style.visibility = (num_column_3 > eachNum) ? "visible"
								: "hidden";
						document.getElementById('more_4').style.visibility = (num_column_4 > eachNum) ? "visible"
								: "hidden";
					},
					error : function(XMLHttpRequest, textStatus, errorThrown) {
					}

				});
	}
	
	
	function showMore(type){
		//type 1.未开始2.处理中3.超时未完成4.已完成5.已完成正常6.已完成超时7.重要8.所有9.待确认
		window.location.href = "${pageContext.request.contextPath}/page/moreAssignmentListMobile/"
			+ type
	}
	
	function query(){
		var saleUser = $("#saleUser option:selected").text();
		var techUser = $("#techUser option:selected").text();
		var company = $("#company option:selected").text();
		saleUser = (saleUser == "请选择...")?"":saleUser;
		techUser = (techUser == "请选择...")?"":techUser;
		company = (company == "请选择...")?"":company;
		getList2(saleUser,techUser,company);
	}
	
</script>

</head>
<body style="width: 100%; height: 100%">

	<div style="width: 100%;height:42px">
		<div class="column_numInfo" style="background: black;" onclick="showMore(1)">
			<a>未开始</a>
		</div>
		<div class="column_numInfo" style="background: red;" onclick="showMore(3)">
			<a>超时未完成</a>
		</div>
		<div class="column_numInfo" style="background: orange;" onclick="showMore(2)">
			<a>处理中</a>
		</div>
		<div class="column_numInfo" style="background: brown;" onclick="showMore(9)">
			<a>待销售确认</a>
		</div>
		<div class="column_numInfo" style="background: blue;" onclick="showMore(6)">
			<a>已完成(超时)</a>
		</div>
		<div class="column_numInfo" style="background: green;" onclick="showMore(5)">
			<a>已完成(正常)</a>
		</div>
		
		<div style="margin: 3px; color:blue;margin-right:20px;font-size: 11px; float: right;" onclick="showMore(8)">
			<a>查看所有事务...</a>
		</div>
		<div style="margin: 3px; color:blue;margin-right:25px;font-size: 11px; float: right;" onclick="createAssignment()">
			<a>新建事务</a>
		</div>
		
		<br><br>
		
		
		<div style="margin: 3px;margin-left: 10px;margin-right: 10px; font-size: 10px;float: left;">
			<label style="width: 60px;">销售人员</label>
			<select id="saleUser" style="width: 95px;margin-left: 5px;"></select>
			<label style="width: 60px;margin-left: 5px;">服务工程师</label>
			<select id="techUser" style="width: 95px;margin-left: 5px;"></select>
		</div>
		
		<div style="margin: 3px;margin-left: 10px;margin-right: 10px; font-size: 10px;float: left;">
			<label style="width: 60px;">客户公司</label>
			<select id="company" style="width: 200px;margin-left: 5px;" class="js-example-basic-single" name="state"></select>
			<input type="button" value="查询" style="width: 53px;height:28px;margin-left: 5px;" onclick="query()" />
		</div>
		</div>
<br><br>
<div>
		<div class="am-avg-sm-4;am-avg-md-4 am-margin-xs am-text-center"
			style="width: 100%">
			
			<div class="column_num">
				超时未完成(<span id="num_1"></span>)
			</div>
			<div class="column_num">
				待销售确认(<span id="num_2"></span>)
			</div>
			<div class="column_num">
				已完成(<span id="num_3"></span>)
			</div>
			<div class="column_num">
				重要<span style="color: red; font-weight: bold;">*</span>(<span
					id="num_4"></span>)
			</div>
		</div>

		<div class="am-avg-sm-4;am-avg-md-4 am-margin-xs am-text-center"
			style="width: 100%">
			<div id="coloum_1" class="am-panel"
				style="float: left; font-size: 12px;"></div>
			<div id="coloum_2" class="am-panel"
				style="float: left; font-size: 12px; margin-left: 2px;"></div>
			<div id="coloum_3" class="am-panel"
				style="float: left; font-size: 12px; margin-left: 2px;"></div>
			<div id="coloum_4" class="am-panel"
				style="float: left; font-size: 12px; margin-left: 2px;"></div>
		</div>

		<div class="am-avg-sm-4;am-avg-md-4 am-margin-xs am-text-center">
			
			<div id="more_1" class="column_morelink" onclick="showMore(3)">更多...</div>
			<div id="more_2" class="column_morelink" onclick="showMore(9)">更多...</div>
			<div id="more_3" class="column_morelink" onclick="showMore(4)">更多...</div>
			<div id="more_4" class="column_morelink" onclick="showMore(7)">更多...</div>
		</div>
	</div>

</body>
</html>