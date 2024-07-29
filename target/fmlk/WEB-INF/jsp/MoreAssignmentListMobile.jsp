<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title></title>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/amazeui2.css?v=2023" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/select3.css?v=2023" />
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.2.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/select3.js"></script>
<script type="text/javascript">
	var eachNum;
	var type;
	var page;
	var allPage;
	$(document)
			.ready(
					function() {
						type = "${type}";
						//type 1.未开始2.处理中3.超时未完成4.已完成5.已完成正常6.已完成超时7.重要8.所有9.待确认
						page = 1;
						if (type == 1) {
							document.title = "未开始事务"
							$("#c1").show();
							document.getElementById('c').style.height = "22px";
						} else if (type == 2) {
							document.title = "处理中事务"
							$("#c3").show();
							document.getElementById('c').style.height = "22px";
						} else if (type == 3) {
							document.title = "超时未完成事务"
							$("#c2").show();
							document.getElementById('c').style.height = "22px";
						} else if (type == 4) {
							document.title = "已完成事务"
							$("#c4").show();
							$("#c5").show();
							document.getElementById('c').style.height = "22px";
						} else if (type == 5) {
							document.title = "超时已完成事务"
							$("#c5").show();
							document.getElementById('c').style.height = "22px";
						} else if (type == 6) {
							document.title = "正常已完成事务"
							$("#c4").show();
							document.getElementById('c').style.height = "22px";
						} else if (type == 7) {
							document.title = "重要事务"
							$("#c1").show();
							$("#c2").show();
							$("#c3").show();
							$("#c4").show();
							$("#c5").show();
							$("#c6").show();
						} else if (type == 8) {
							document.title = "所有事务"
							$("#c1").show();
							$("#c2").show();
							$("#c3").show();
							$("#c4").show();
							$("#c5").show();
							$("#c6").show();
						} else if (type == 9) {
							document.title = "待确认事务"
							$("#c6").show();
							document.getElementById('c').style.height = "22px";
						}

						var h = document.documentElement.clientHeight;
						
						eachNum = Math.floor((h - 150) / 100);
						
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
						getList(1);
					});

	function edit(id) {
		window.location.href = "${pageContext.request.contextPath}/page/editAssignment/"
				+ id
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
	
	function query(){
		var saleUser = $("#saleUser option:selected").text();
		var techUser = $("#techUser option:selected").text();
		var company = $("#company option:selected").text();
		saleUser = (saleUser == "请选择...")?"":saleUser;
		techUser = (techUser == "请选择...")?"":techUser;
		company = (company == "请选择...")?"":company;
		getList2(1,saleUser,techUser,company);
	}
	
	function getList2(tPage,saleUser,techUser,company) {
		
		var num_all;
		var thisPageNum = 4 * eachNum;
		$
				.ajax({
					url : "${pageContext.request.contextPath}/getMoreAssignmentList2",
					type : 'GET',
					data : {
						"type" : type,
						"saleUser" : saleUser,
					    "techUser" : techUser,
					    "company" : company
					},
					cache : false,
					async : false,
					success : function(returndata) {
						var strColumn_1 = '', strColumn_2 = '', strColumn_3 = '', strColumn_4 = '';
						var num_column_1 = 0, num_column_2 = 0, num_column_3 = 0, num_column_4 = 0
						var data2 = eval("(" + returndata + ")").assignlist;
						num_all = data2.length;
						//alert(num_all);
						if (num_all == 0) {
							allPage = 1;
						} else {
							allPage = Math.ceil(num_all / thisPageNum);
						}
						for ( var i in data2) {
							if (i >= thisPageNum * (tPage - 1)
									&& i <= thisPageNum * tPage - 1) {

								var state = data2[i].state;
								var importment = (data2[i].rank == 1) ? "★★★ "
										: "";
								var colorStr;
								if (state == 1) {
									colorStr = '<div class="column_top" style="background:black;color:white">';
								} else if (state == 2) {
									colorStr = '<div class="column_top" style="background:orange;color:white">'
								} else if (state == 3) {
									colorStr = '<div class="column_top" style="background:red;color:white">';
								} else if (state == 4) {
									colorStr = '<div class="column_top" style="background:green;color:white">';
								} else if (state == 5) {
									colorStr = '<div class="column_top" style="background:blue;color:white">';
								}else if(state == 6){
									colorStr = '<div class="column_top" style="background:brown;color:white">'
								}
								
								
								if (i % 4 == 0) {
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
								} else if (i % 4 == 1) {
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
								} else if (i % 4 == 2) {
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
						}
						$("#coloum_1").empty();
						$("#coloum_2").empty();
						$("#coloum_3").empty();
						$("#coloum_4").empty();
						$("#coloum_1").append(strColumn_1);
						$("#coloum_2").append(strColumn_2);
						$("#coloum_3").append(strColumn_3);
						$("#coloum_4").append(strColumn_4);
						document.getElementById('p').innerHTML = tPage + "/"
								+ allPage;
						if (tPage == 1 && allPage > 1) {
							document.getElementById('previous').style.color = "gray";
							document.getElementById('next').style.color = "blue";
						} else if (tPage == allPage && allPage > 1) {
							document.getElementById('next').style.color = "gray";
							document.getElementById('previous').style.color = "blue";
						} else if (tPage == allPage && allPage == 1) {
							document.getElementById('previous').style.color = "gray";
							document.getElementById('next').style.color = "gray";
						} else {
							document.getElementById('previous').style.color = "blue";
							document.getElementById('next').style.color = "blue";
						}
					},
					error : function(XMLHttpRequest, textStatus, errorThrown) {
					}

				});
	}

	function getList(tPage) {
		var num_all;
		var thisPageNum = 4 * eachNum;
		$
				.ajax({
					url : "${pageContext.request.contextPath}/getMoreAssignmentList",
					type : 'GET',
					data : {
						"type" : type
					},
					cache : false,
					async : false,
					success : function(returndata) {
						
						var strColumn_1 = '', strColumn_2 = '', strColumn_3 = '', strColumn_4 = '';
						var num_column_1 = 0, num_column_2 = 0, num_column_3 = 0, num_column_4 = 0
						var data2 = eval("(" + returndata + ")").assignlist;
						num_all = data2.length;
					//	alert(num_all);
						if (num_all == 0) {
							allPage = 1;
						} else {
							allPage = Math.ceil(num_all / thisPageNum);
						}
						/* alert("当页"+thisPageNum);
						alert(thisPageNum*(tPage-1));
						alert(thisPageNum*tPage-1); */
						for ( var i in data2) {
							if (i >= thisPageNum * (tPage - 1)
									&& i <= thisPageNum * tPage - 1) {

								var state = data2[i].state;
								var importment = (data2[i].rank == 1) ? "★★★ "
										: "";
								var colorStr;
								if (state == 1) {
									colorStr = '<div class="column_top" style="background:black;color:white">';
								} else if (state == 2) {
									colorStr = '<div class="column_top" style="background:orange;color:white">'
								} else if (state == 3) {
									colorStr = '<div class="column_top" style="background:red;color:white">';
								} else if (state == 4) {
									colorStr = '<div class="column_top" style="background:green;color:white">';
								} else if (state == 5) {
									colorStr = '<div class="column_top" style="background:blue;color:white">';
								}else if(state == 6){
									colorStr = '<div class="column_top" style="background:brown;color:white">'
								}
								
								
								if (i % 4 == 0) {
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
								} else if (i % 4 == 1) {
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
								} else if (i % 4 == 2) {
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
						}
						$("#coloum_1").empty();
						$("#coloum_2").empty();
						$("#coloum_3").empty();
						$("#coloum_4").empty();
						$("#coloum_1").append(strColumn_1);
						$("#coloum_2").append(strColumn_2);
						$("#coloum_3").append(strColumn_3);
						$("#coloum_4").append(strColumn_4);
						document.getElementById('p').innerHTML = tPage + "/"
								+ allPage;
						if (tPage == 1 && allPage > 1) {
							document.getElementById('previous').style.color = "gray";
							document.getElementById('next').style.color = "blue";
						} else if (tPage == allPage && allPage > 1) {
							document.getElementById('next').style.color = "gray";
							document.getElementById('previous').style.color = "blue";
						} else if (tPage == allPage && allPage == 1) {
							document.getElementById('previous').style.color = "gray";
							document.getElementById('next').style.color = "gray";
						} else {
							document.getElementById('previous').style.color = "blue";
							document.getElementById('next').style.color = "blue";
						}
					},
					error : function(XMLHttpRequest, textStatus, errorThrown) {
					}

				});
	}

	function returnBackPage() {
		window.location.href = "${pageContext.request.contextPath}/page/assignmentList";
	}

	function nextPage() {
		if (page == allPage) {
			alert("已经是最后一页");
			return;
		} else {
			page++;
			
			
			var saleUser = $("#saleUser option:selected").text();
			var techUser = $("#techUser option:selected").text();
			var company = $("#company option:selected").text();
			saleUser = (saleUser == "请选择...")?"":saleUser;
			techUser = (techUser == "请选择...")?"":techUser;
			company = (company == "请选择...")?"":company;
			getList2(page,saleUser,techUser,company);
		//	getList(page);
		}
	}

	function previousPage() {
		if (page == 1) {
			alert("已经是第一页");
			return;
		} else {
			page--;
			var saleUser = $("#saleUser option:selected").text();
			var techUser = $("#techUser option:selected").text();
			var company = $("#company option:selected").text();
			saleUser = (saleUser == "请选择...")?"":saleUser;
			techUser = (techUser == "请选择...")?"":techUser;
			company = (company == "请选择...")?"":company;
			getList2(page,saleUser,techUser,company);
		//	getList(page);
		}
	}

	function getSpecialList(selType) {
		type = selType;
		var saleUser = $("#saleUser option:selected").text();
		var techUser = $("#techUser option:selected").text();
		var company = $("#company option:selected").text();
		saleUser = (saleUser == "请选择...")?"":saleUser;
		techUser = (techUser == "请选择...")?"":techUser;
		company = (company == "请选择...")?"":company;
		getList2(1,saleUser,techUser,company);
	}
</script>

</head>
<body style="width: 100%; height: 100%">

	<div id="c" style="width: 100%; height: 42px">
<div id="c1" class="column_numInfo"
			style="background: black; display: none" onclick="getSpecialList(1)">
			<a>未开始</a>
		</div>
		<div id="c3" class="column_numInfo"
			style="background: orange; display: none" onclick="getSpecialList(2)">
			<a>处理中</a>
		</div>
		<div id="c2" class="column_numInfo"
			style="background: red; display: none" onclick="getSpecialList(3)">
			<a>超时未完成</a>
		</div>
		<div id="c6" class="column_numInfo"
			style="background: brown; display: none" onclick="getSpecialList(9)">
			<a>待销售确认</a>
		</div>
		<div id="c4" class="column_numInfo"
			style="background: blue; display: none" onclick="getSpecialList(6)">
			<a>已完成(超时)</a>
		</div>
		<div id="c5" class="column_numInfo"
			style="background: green; display: none" onclick="getSpecialList(5)">
			<a>已完成(正常)</a>
		</div>
		
		<div id="previous" onclick="previousPage()"
			style="float: left; font-size: 12px; padding-left: 10px; color: blue; padding-top: 3px">上一页</div>
		<div id="next" onclick="nextPage()"
			style="float: left; font-size: 12px; padding-left: 10px; color: blue; padding-top: 3px">下一页</div>
		<div
			style="float: left; font-size: 12px; padding-left: 10px; padding-right: 2px;; color: blue; padding-top: 3px">
			当前页(<span id="p"></span>)
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
<br><br><br>

	<div>
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
	</div>

</body>
</html>