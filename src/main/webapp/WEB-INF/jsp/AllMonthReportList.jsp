<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="pragma" content="no-cache" />
<meta http-equiv="cache-control" content="no-cache" />
<title>所有人统计数据</title>
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
<script src="${pageContext.request.contextPath}/js/changePsd.js"></script>
<style type="text/css">
a:hover {
	color: #FF00FF
} /* 鼠标移动到链接上 */
::-webkit-scrollbar {
	display: none;
}

html {
	-ms-overflow-style: none;
	/*火狐下隐藏滚动条*/
	overflow: -moz-scrollbars-none;
}
</style>
<script type="text/javascript">
	var sId;
	var isPermissionEdit;
	var queryType;
	var isUpdate;

	$(document)
			.ready(
					function() {
						sId = "${sessionId}";
						if (sId == null || sId == "") {
							parent.location.href = "${pageContext.request.contextPath}/page/login";
						} else {
							getUserPermissionList();
							getUserList();
							var year = new Date().getFullYear();
							var month = new Date().getMonth() + 1;
							month = month < 10 ? "0" + month : month;
							$("#year").val(year);
							$("#month").val(month);
							queryType = 1;
							
							/* var updateDate = new Date(Date.parse("2021/10/01"));
							var thisDate = new Date();
							if(thisDate>updateDate){
								isUpdate = true;
							}else{
								isUpdate = false;
							} */
							getUserMonthReportList();
							$("#year").select2({});
							$("#month").select2({});
							$("#queryType").select2({});
							$("#userId").select2({});
						}
					});

	function getUserPermissionList() {
		$
				.ajax({
					url : "${pageContext.request.contextPath}/getUserPermissionList",
					type : 'GET',
					data : {
						"nickName" : sId
					},
					cache : false,
					async : false,
					success : function(returndata) {
						var data = eval("(" + returndata + ")").permissionSettingList;
						isPermissionEdit = false;
						for ( var i in data) {
							if (data[i].permissionId == 75) {
								isPermissionEdit = true;
								break;
							}
						}
						if (!isPermissionEdit) {
							window.location.href = "${pageContext.request.contextPath}/page/error";
						} else {
							$('#body').show();
						}
					},
					error : function(XMLHttpRequest, textStatus, errorThrown) {
					}
				});
	}

	function getUserList() {
		$.ajax({
			url : "${pageContext.request.contextPath}/userList",
			type : 'GET',
			data : {
				"dpartId" : 99,
				"date" : "",
				"name" : "",
				"nickName" : "",
				"jobId" : "",
				"isHide" : false
			},
			cache : false,
			async : false,
			success : function(returndata) {
				var str = '';
				var data2 = eval("(" + returndata + ")").userlist;
				for ( var i in data2) {
					str += '<option value="'+data2[i].nickName+'">'
							+ data2[i].name + '</option>';
				}
				$("#userId").empty();
				$("#userId").append(str);

			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
	}

	function getUserMonthReportList() {
		var month;
		var year;
		if ($("#mSpan2").css("display") == 'none') {
			queryType = 2;
			month = "";
		} else {
			queryType = 1;
			month = $("#month").val();
		}
		year = $("#year").val();
		
		var updateDate = new Date(Date.parse("2021/10/01"));
		var selectDATE = new Date(Date.parse(year+"/" + month + "/01"));
		if(selectDATE>=updateDate){
			isUpdate = true;
		}else{
			isUpdate = false;
		}
		
		
		$
				.ajax({
					url : "${pageContext.request.contextPath}/getUserMonthReportList",
					type : 'GET',
					data : {
						"year" : year,
						"nickName" : $("#userId").val(),
						"month" : month
					},
					cache : false,
					async : false,
					success : function(returndata) {
						//alert(returndata);
						var str = "";
						var data = eval("(" + returndata + ")").monthlist;
						if (data.length == 0) {
							str += '<tr style="width: 100%"><td style="width: 100%;color:red;font-size: 12px; height: 35px;">月数据还没有录入</td></tr>';
						} else {
							var allScheduleNum = 0;
							var allDailyReportNum = 0;
							var allWeekReportNum = 0;
							var allNextWeekPlanNum = 0;
							var allProjectReportNum = 0;
							var allSignNum = 0;
							var allAmountNum = 0;
							var allOverWorkTimeNum = 0;
							var allAdjustRestTimeNum = 0;
							var allFestivalOverWorkTimeNum = 0;
							var allIsLateNum = 0;
							var allOverWorkTime4HNum = 0;

							for (var i = 0; i < data.length; i++) {
								var sign = parseInt(parseInt(data[i].noSignIn)
										+ parseInt(data[i].noSignOut));
								var monthAccumulateData = getMonthAccumulateData(
										data[i].month, data[i].name);
								/* var amount = (parseInt(data[i].scheduleT)
										+ parseInt(data[i].dailyReportT)
										+ parseInt(data[i].weekReportT)
										+ parseInt(data[i].nextWeekPlanT) + parseInt(data[i].projectReportT))
										* 50 + sign * 200 + data[i].isLate * 30; */
								var amount;
								if(isUpdate){
									amount = (parseInt(data[i].scheduleT)
											+ parseInt(data[i].dailyReportT))
											* 50 + sign * 200;
									for(var k=0;k<parseInt(data[i].isLate)-3;k++){
										amount += 30*Math.pow(2,k);
									}
									
								}else{
									amount = (parseInt(data[i].scheduleT)
											+ parseInt(data[i].dailyReportT))
											* 50 + sign * 200 + data[i].isLate * 30;
								}	
								

								var accumulateOverWorkTime = monthAccumulateData
										.split("#")[0];
								var accumulateYearVacation = monthAccumulateData
										.split("#")[1];
								var overWorkTime4H = monthAccumulateData
										.split("#")[2];
								var scheduleTd = "";
								var dailyReportTd = "";
								var weekReportTd = "";
								var nextWeekPlanTd = "";
								var projectReportTd = "";
								var signTd = "";
								var isLateTd = "";
								var overWorkTimeTd = "";
								var adjustRestTimeTd = "";
								var festivalOverWorkTimeTd = "";
								var accumulateOverWorkTimeTd = "";
								var accumulateYearVacationTd = "";
								var first_column = "";
								var amountTd = "";

								if (queryType == 1) {
									first_column = '<td style="width:8%;height: 35px;" class="tdColor2">'
											+ '<input type="text"  id="name'
											+ i
											+ '" style="font-size: 14px;border:none;width:98%;text-align:center;background-color:#fff;font-weight:900" '
											+ 'value="'
											+ data[i].name
											+ '" disabled="disabled"/></td>';
									$("#coloum_name").show();
									$("#coloum_month").hide();
								} else {
									first_column = '<td style="width:8%;height: 35px;" class="tdColor2">'
											+ '<input type="text"  id="date'
											+ i
											+ '" style="font-size: 14px;border:none;width:88%;text-align:center;background-color:#fff;font-weight:900" '
											+ 'value="'
											+ data[i].month
											+ '月" disabled="disabled"/></td>';
									$("#coloum_month").show();
									$("#coloum_name").hide();
								}

								if (data[i].scheduleT != 0) {
									scheduleTd = '<td style="width:8%;font-size: 14px; height: 35px;color:red;" class="tdColor2"><strong>'
											+ data[i].scheduleT + '</strong></td>';
									allScheduleNum += parseInt(data[i].scheduleT);
								} else {
									scheduleTd = '<td style="width:8%;font-size: 12px; height: 35px;" class="tdColor2">'
											+ data[i].scheduleT + '</td>';
								}

								if (data[i].dailyReportT != 0) {
									dailyReportTd = '<td style="width:8%;font-size: 14px; height: 35px;color:red;" class="tdColor2"><strong>'
											+ data[i].dailyReportT + '</strong></td>';
									allDailyReportNum += parseInt(data[i].dailyReportT);
								} else {
									dailyReportTd = '<td style="width:8%;font-size: 12px; height: 35px;" class="tdColor2">'
											+ data[i].dailyReportT + '</td>';
								}

								if (data[i].weekReportT != 0) {
									weekReportTd = '<td style="width:6%;font-size: 14px; height: 35px;color:red;" class="tdColor2"><strong>'
											+ data[i].weekReportT + '</strong></td>';
									allWeekReportNum += parseInt(data[i].weekReportT);
								} else {
									weekReportTd = '<td style="width:6%;font-size: 12px; height: 35px;" class="tdColor2">'
											+ data[i].weekReportT + '</td>';
								}

								if (data[i].nextWeekPlanT != 0) {
									nextWeekPlanTd = '<td style="width:7%;font-size: 14px; height: 35px;color:red;" class="tdColor2"><strong>'
											+ data[i].nextWeekPlanT + '</strong></td>';
									allNextWeekPlanNum += parseInt(data[i].nextWeekPlanT);
								} else {
									nextWeekPlanTd = '<td style="width:7%;font-size: 12px; height: 35px;" class="tdColor2">'
											+ data[i].nextWeekPlanT + '</td>';
								}

								if (data[i].projectReportT != 0) {
									projectReportTd = '<td style="width:7%;font-size: 14px; height: 35px;color:red;" class="tdColor2"><strong>'
											+ data[i].projectReportT + '</strong></td>';
									allProjectReportNum += parseInt(data[i].projectReportT);
								} else {
									projectReportTd = '<td style="width:7%;font-size: 12px; height: 35px;" class="tdColor2">'
											+ data[i].projectReportT + '</td>';
								}

								if (sign != 0) {
									signTd = '<td style="width:10%;font-size: 14px; height: 35px;color:red;" class="tdColor2"><strong>'
											+ sign + '</strong></td>';
									allSignNum += sign;
								} else {
									signTd = '<td style="width:10%;font-size: 12px; height: 35px;" class="tdColor2">'
											+ sign + '</td>';
								}

								if (data[i].isLate != 0) {
									isLateTd = '<td style="width:8%;font-size: 14px; height: 35px;color:red;" class="tdColor2"><strong>'
											+ data[i].isLate + '</strong></td>';
									allIsLateNum += parseInt(data[i].isLate);
								} else {
									isLateTd = '<td style="width:8%;font-size: 12px; height: 35px;" class="tdColor2">'
											+ data[i].isLate + '</td>';
								}

								/* if (data[i].overWorkTime != 0) {
									overWorkTimeTd = '<td style="width:9%;height: 35px;" class="tdColor2"><strong>'
									if (overWorkTime4H > 0) {
										overWorkTimeTd += '<input type="text" style="font-size: 14px;border:none;width:40%;color:blue;text-align:right;font-weight:900" id="overWorkTime4H'
												+ i
												+ '" value="'
												+ overWorkTime4H
												+ '" oninput="OnChangeOverWorkTime4H(event)"/>';
									} else {
										overWorkTimeTd += '<input type="text" style="font-size: 14px;border:none;width:40%;text-align:right;" id="overWorkTime4H'
												+ i
												+ '" value="'
												+ overWorkTime4H
												+ '" oninput="OnChangeOverWorkTime4H(event)"/>';
									}
									overWorkTimeTd += "/"
											+ '<input type="text" style="font-size: 14px;border:none;width:40%;color:blue;text-align:left;background-color:#fff;font-weight:900" disabled="disabled" id="overWorkTime'
											+ i + '" value="'
											+ (data[i].overWorkTime-overWorkTime4H) + '"/></strong></td>';
											
											overWorkTimeTd += "/"
												+ '<input type="text" style="font-size: 14px;border:none;width:40%;color:blue;text-align:left;background-color:#fff;font-weight:900" disabled="disabled" id="overWorkTime'
												+ i + '" value="'
												+ (data[i].overWorkTime-overWorkTime4H) + '"/></strong></td>';

									allOverWorkTimeNum += parseFloat(data[i].overWorkTime-overWorkTime4H);
									allOverWorkTime4HNum += parseFloat(overWorkTime4H);

								} else { 
									overWorkTimeTd = '<td style="width:9%;height: 35px" class="tdColor2">'
										    + '<input type="text" style="font-size: 14px;border:none;width:40%;text-align:right;background-color:white;color:black" disabled="disabled" id="overWorkTime4H'
											+ i
											+ '" value="'
											+ overWorkTime4H
											+ '"/>/'
											+ '<input type="text" style="font-size: 14px;border:none;width:40%;text-align:left;background-color:white;color:black" disabled="disabled" id="overWorkTime'
											+ i
											+ '" value="'
											+ data[i].overWorkTime + '"/>' 
											+ data[i].overWorkTime
											+'</td>';*/
									
									if(data[i].overWorkTime != 0){
										overWorkTimeTd = '<td style="width:10%;height: 35px;color:blue;" class="tdColor2"><strong>'
											+ data[i].overWorkTime
											+'</strong></td>';
										
									}else{
										overWorkTimeTd = '<td style="width:10%;height: 35px" class="tdColor2">'
											+ data[i].overWorkTime
											+'</td>';
										
										
									}
									allOverWorkTimeNum += parseFloat(data[i].overWorkTime);
									
									
							//	}

								if (data[i].adjustRestTime != 0) {
									adjustRestTimeTd = '<td style="width:8%;font-size: 14px; height: 35px;color:red;border-left:3px solid blue" class="tdColor2"><strong>'
											+ data[i].adjustRestTime + '</strong></td>';
									allAdjustRestTimeNum += parseFloat(data[i].adjustRestTime);
								} else {
									adjustRestTimeTd = '<td style="width:8%;font-size: 12px; height: 35px;border-left:3px solid blue" class="tdColor2">'
											+ data[i].adjustRestTime + '</td>';
								}

								if (data[i].festivalOverWorkTime != 0) {
									festivalOverWorkTimeTd = '<td style="width:8%;font-size: 14px; height: 35px;color:blue;" class="tdColor2"><strong>'
											+ data[i].festivalOverWorkTime
											+ '</strong></td>';
									allFestivalOverWorkTimeNum += parseFloat(data[i].festivalOverWorkTime);
								} else {
									festivalOverWorkTimeTd = '<td style="width:8%;font-size: 12px; height: 35px;" class="tdColor2">'
											+ data[i].festivalOverWorkTime
											+ '</td>';
								}

								if (accumulateOverWorkTime > 0) {
									accumulateOverWorkTimeTd = '<td style="width:8%;font-size: 14px; height: 35px;background-color:pink;border-left:3px solid blue;border-right:3px solid blue" class="tdColor2"><strong>'
											+ '<input type="text" style="font-size: 14px;border:none;width:98%;text-align:center;color:blue;background-color:pink;font-weight:900" id="accumulateOverWorkTime'
											+ i
											+ '" value="'
											+ accumulateOverWorkTime
											+ '"/></strong></td>';
								} else if (accumulateOverWorkTime < 0) {
									accumulateOverWorkTimeTd = '<td style="width:8%;font-size: 14px; height: 35px;background-color:pink;border-left:3px solid blue;border-right:3px solid blue" class="tdColor2"><strong>'
											+ '<input type="text" style="font-size: 14px;border:none;width:98%;text-align:center;color:red;background-color:pink;font-weight:900" id="accumulateOverWorkTime'
											+ i
											+ '" value="'
											+ accumulateOverWorkTime
											+ '"/><strong></td>';

								} else {
									accumulateOverWorkTimeTd = '<td style="width:8%;font-size: 12px; height: 35px;background-color:pink;border-left:3px solid blue;border-right:3px solid blue" class="tdColor2">'
											+ '<input type="text" style="font-size: 12px;border:none;width:98%;text-align:center;background-color:pink" id="accumulateOverWorkTime'
											+ i
											+ '" value="'
											+ accumulateOverWorkTime
											+ '"/></td>';
								}

								if (accumulateYearVacation != 0) {
									accumulateYearVacationTd = '<td style="width:8%;font-size: 12px; height: 35px;" class="tdColor2">'
											+ '<input type="text" style="font-size: 12px;border:none;width:40%;text-align:right;color:blue" id="accumulateYearVacation'
											+ i
											+ '" value="'
											+ accumulateYearVacation
											+ '"/><input disabled="disabled" type="text" type="text" style="font-size: 12px;border:none;width:40%;text-align:left;background-color:white;margin-left:5px" value="天"/></td>';
								} else {
									accumulateYearVacationTd = '<td style="width:8%;font-size: 12px; height: 35px;" class="tdColor2">'
											+ '<input type="text" style="font-size: 12px;border:none;width:40%;text-align:right;" id="accumulateYearVacation'
											+ i
											+ '" value="'
											+ accumulateYearVacation
											+ '"/><input disabled="disabled" type="text" style="font-size: 12px;border:none;width:40%;text-align:left;background-color:white;margin-left:5px" value="天"/></td>';
								}

								if (amount != 0) {
									amountTd = '<td style="width:8%;font-size: 14px; height: 35px;color:red;background-color:yellow;border-left:3px solid blue;border-right:3px solid blue;" class="tdColor2"><strong>'
											+ amount + '</strong></td>';
									allAmountNum += amount;
								} else {
									amountTd = '<td style="width:8%;font-size: 12px; height: 35px;background-color:yellow;border-left:3px solid blue;border-right:3px solid blue;" class="tdColor2">0</td>';
								}

								str += '<tr style="width: 100%">'
										+ first_column
										+ scheduleTd
										+ dailyReportTd
									//	+ weekReportTd
									//	+ nextWeekPlanTd
									//	+ projectReportTd
										+ signTd
										+ isLateTd
										+ amountTd
										+ overWorkTimeTd
										+ adjustRestTimeTd
										+ festivalOverWorkTimeTd
										+ accumulateOverWorkTimeTd
										+ accumulateYearVacationTd
										+ '<td style="width:8%;font-size: 12px; height: 35px;" class="tdColor2">'
										+ '<img title="编辑" style="vertical-align:middle" class="operation" src="../image/update.png" onclick="editMonthReport('
										+ i + ')"/></td></tr>';
							}

							str += '<tr style="width: 100%"><td style="width: 8%; font-size: 12px; height: 35px;color:white;background-color:green" class="tdColor2">总数</td>'
									+ '<td style="width: 8%; font-size: 12px; height: 35px;;color:white;background-color:green" class="tdColor2">'
									+ allScheduleNum
									+ '</td><td style="width: 8%; font-size: 12px; height: 35px;color:white;background-color:green" class="tdColor2">'
									+ allDailyReportNum
									/* + '</td><td style="width: 6%; font-size: 12px; height: 35px;color:white;background-color:green" class="tdColor2">'
									+ allWeekReportNum */
									/* + '</td><td style="width: 7%; font-size: 12px; height: 35px;color:white;background-color:green" class="tdColor2">'
									+ allNextWeekPlanNum */
									/* + '</td><td style="width: 7%; font-size: 12px; height: 35px;color:white;background-color:green;" class="tdColor2">'
									+ allProjectReportNum */
									+ '</td><td style="width: 10%; font-size: 12px; height: 35px;color:white;background-color:green" class="tdColor2">'
									+ allSignNum
									+ '</td><td style="width: 8%; font-size: 12px; height: 35px;color:white;background-color:green" class="tdColor2">'
									+ allIsLateNum
									+ '</td><td style="width: 8%; font-size: 12px; height: 35px;color:white;background-color:green;border-left:3px solid blue;border-right:3px solid blue;border-bottom:3px solid blue;" class="tdColor2">'
									+ allAmountNum
									+ '</td>'
									
									+'<td style="width: 10%;height: 35px;background-color:green;border-left:3px solid blue;border-right:3px solid blue;border-bottom:3px solid blue;color:white;" class="tdColor2">'
									
									/* + '<input type="text" style="font-size: 12px;border:none;width:40%;line-height:32px;text-align:right;color:white;background-color:green" disabled="disabled" id="allOverWorkTime4HNum" value="'
									+ allOverWorkTime4HNum
									+ '"/>'
									+ '<a style="color:white;">/</a>'
									+ '<input type="text" style="font-size: 12px;border:none;width:40%;line-height:32px;text-align:left;color:white;background-color:green" disabled="disabled" value="'
									+ allOverWorkTimeNum
									+ '"/>' */
									+ allOverWorkTimeNum
									
									+'</td><td class="tdColor2" style="width: 8%; font-size: 12px; height: 35px;color:white;background-color:green;" >'
									+ allAdjustRestTimeNum
									+ '</td><td style="width: 8%; font-size: 12px; height: 35px;color:white;background-color:green;" class="tdColor2">'
									+ allFestivalOverWorkTimeNum
									+ '</td><td style="width: 8%; font-size: 12px; height: 35px;color:white;background-color:green;border-left:3px solid blue;border-right:3px solid blue;border-bottom:3px solid blue;" class="tdColor2">×</td>'
									+ '<td style="width: 8%; font-size: 12px; height: 35px;color:white;background-color:green" class="tdColor2">×</td>'
									+ '<td style="width: 8%; font-size: 12px; height: 35px;color:white;background-color:green" class="tdColor2">×</td></tr>'
						}
						$("#tb").empty();
						$("#tb").append(str);

					},
					error : function(XMLHttpRequest, textStatus, errorThrown) {
					}
				});
	}

	function OnChangeOverWorkTime4H(event) {
		if (event.target.value != "") {
			var newValue = parseFloat($("#allOverWorkTime4HNum").val())
					+ parseFloat(event.target.value);
			$("#allOverWorkTime4HNum").val(newValue);
		}
	}

	function editMonthReport(tid) {
		//alert(tid);
		//var mOverWorkTime4H = $("#overWorkTime4H" + tid).val();
		var mAccumulateOverWorkTime = $("#accumulateOverWorkTime" + tid).val();
		var mAccumulateYearVacation = $("#accumulateYearVacation" + tid).val();
		var mOverWorkTime = $("#overWorkTime" + tid).val();
		var date;
		var userId;
		if (queryType == 1) {
			date = $("#year").val() + "/" + $("#month").val();
			var myselect = document.getElementById("userId");
			$('#userId').find("option").each(function() {
				if ($(this).text() === $("#name" + tid).val()) {
					userId = getUser($(this).val());
				}
			});

		} else {
			var tDate = $("#date" + tid).val();
			tDate = tDate.substring(0, tDate.lastIndexOf('月'));
			tDate = tDate < 10 ? "0" + tDate : tDate;
			date = $("#year").val() + "/" + tDate;
			userId = getUser($("#userId").val());
		}
		/* if (mOverWorkTime4H-mOverWorkTime>0) {
			alert("大于4H加班不能超过总加班");
			return;
		} */
		$.ajax({
			url : "${pageContext.request.contextPath}/editMonthAccumulateData",
			type : 'POST',
			cache : false,
			data : {
				"userId" : userId,
				"date" : date,
				"accumulateOverWorkTime" : mAccumulateOverWorkTime,
				"accumulateYearVacation" : mAccumulateYearVacation
			//	"overWorkTime4H" : mOverWorkTime4H,
			},
			success : function(returndata) {
				var data = eval("(" + returndata + ")").errcode;
				if (data == 0) {
					alert("编辑成功");
				} else {
					alert("编辑失败");
				}
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
	}

	function getMonthAccumulateData(mMonth, mName) {
		var date;
		var nickName;
		var mReturnData;
		if (mMonth < 10) {
			mMonth = "0" + mMonth;
		}
		if (queryType == 1) {
			date = $("#year").val() + "/" + $("#month").val();
			var myselect = document.getElementById("userId");
			$('#userId').find("option").each(function() {
				if ($(this).text() === mName) {
					nickName = $(this).val();
				}
			});
		} else {
			date = $("#year").val() + "/" + mMonth;
			nickName = $("#userId").val();
		}
		$
				.ajax({
					url : "${pageContext.request.contextPath}/getMonthAccumulateData",
					type : 'GET',
					data : {
						"date" : date,
						"nickName" : nickName,
					},
					cache : false,
					async : false,
					success : function(returndata) {
						var accumulateOverWorkTime = eval("(" + returndata
								+ ")").accumulateOverWorkTime;
						var accumulateYearVacation = eval("(" + returndata
								+ ")").accumulateYearVacation;
						var overWorkTime4H = eval("(" + returndata + ")").overWorkTime4H;
						mReturnData = accumulateOverWorkTime + "#"
								+ accumulateYearVacation + "#" + overWorkTime4H;
					},
					error : function(XMLHttpRequest, textStatus, errorThrown) {
					}
				});
		return mReturnData;
	}

	function printTable() {
		$("#div1").jqprint();
	}

	function changeQueryType(type) {
		if (type == 1) {
			$("#mSpan2").show();
			$("#mSpan1").hide();
		} else {
			$("#mSpan1").show();
			$("#mSpan2").hide();
		}
	}

	function getUser(tNickName) {
		var uId = "";
		$.ajax({
			url : "${pageContext.request.contextPath}/getUserByNickName",
			type : 'GET',
			async : false,
			data : {
				"nickName" : tNickName
			},
			cache : false,
			success : function(returndata) {
				var data = eval("(" + returndata + ")").user;
				uId = data[0].UId;
			}
		});
		return uId;
	}
</script>
</head>

<body id="body" style="display: none">
	<div id="pageAll">
		<div class="pageTop">
			<div class="page">
				<img src="../image/coin02.png" /><span><a href="#">首页</a>&nbsp;-&nbsp;<a
					href="#">考勤管理</a>&nbsp;-</span>&nbsp;所有人月统计数据<span style="margin-left:30px;color:red">UPDATE INFORM:2021/10 起15分钟内迟到3次以内不扣款，3次以上每多迟到一次翻倍扣款(-30,-60,-120,...)</span>
			</div>
		</div>

		<div class="page">
			<!-- vip页面样式 -->
			<div class="vip">
				<div class="conform">
					<form>
						<div class="cfD">
							<Strong style="margin-right: 30px">查询条件：</Strong><select
								id="queryType" class="selCss" style="width: 80px;"
								onChange="javascript:changeQueryType(this.value)">
								<option value="1">日期</option>
								<option value="2">人员</option>
							</select><a style="margin-right: 15px"></a><span style="display: none"
								id="mSpan1"><select class="selCss" id="userId"
								style="width: 80px;" /></select><a style="margin-right: 20px"></a></span><select
								class="selCss" style="width: 80px;" id="year">
								<option value="2018">2018年</option>
								<option value="2019">2019年</option>
								<option value="2020">2020年</option>
								<option value="2021">2021年</option>
								<option value="2022">2022年</option>
								<option value="2023">2023年</option>
								<option value="2024">2024年</option>
								<option value="2025">2025年</option>
								<option value="2026">2026年</option>
								<option value="2027">2027年</option>
								<option value="2028">2028年</option>
								<option value="2029">2029年</option>
								<option value="2030">2030年</option>
								<option value="2031">2031年</option>
								<option value="2032">2032年</option>
								<option value="2033">2033年</option>
								<option value="2034">2034年</option>
								<option value="2035">2035年</option>
								<option value="2036">2036年</option>
								<option value="2037">2037年</option>
								<option value="2038">2038年</option>
								<option value="2039">2039年</option>
								<option value="2040">2040年</option>
							</select><span id="mSpan2"><a style="margin-left: 20px"></a> <select
								class="selCss" style="width: 80px;" id="month">
									<option value="01">1月</option>
									<option value="02">2月</option>
									<option value="03">3月</option>
									<option value="04">4月</option>
									<option value="05">5月</option>
									<option value="06">6月</option>
									<option value="07">7月</option>
									<option value="08">8月</option>
									<option value="09">9月</option>
									<option value="10">10月</option>
									<option value="11">11月</option>
									<option value="12">12月</option>
							</select></span><a class="addA" style="width: 120px"
								onClick="getUserMonthReportList()">搜索</a> <a class="addA"
								style="width: 120px" onClick="printTable()">打印表单</a><label
								id="label" style="font-size: 12px;"></label>
						</div>
					</form>
				</div>
				<!-- vip 表格 显示 -->
				<div class="conShow" style="margin-bottom: 30px" id="div1">
					<table border="1" style="width: 100%">
						<tr style="width: 100%">
							<td style="width: 8%; font-size: 12px; height: 35px;"
								class="tdColor" id="coloum_name">姓名</td>
							<td
								style="width: 8%; font-size: 12px; height: 35px; display: none"
								class="tdColor" id="coloum_month">月份</td>
							<td style="width: 8%; font-size: 12px; height: 35px;"
								class="tdColor">日程</td>
							<td style="width: 8%; font-size: 12px; height: 35px;"
								class="tdColor">日报</td>
							<!-- <td style="width: 6%; font-size: 12px; height: 35px;display:none";
								class="tdColor">周报</td> -->
							<!-- <td style="width: 7%; font-size: 12px; height: 35px;"
								class="tdColor">下周计划</td> -->
							<!-- <td style="width: 7%; font-size: 12px; height: 35px;display:none"
								class="tdColor">项目计划/报告</td> -->
							<td style="width: 10%; font-size: 12px; height: 35px;"
								class="tdColor">未签到/未签退</td>
							<td style="width: 8%; font-size: 12px; height: 35px;"
								class="tdColor">迟到</td>
							<td style="width: 8%; font-size: 12px; height: 35px;border-left:3px solid blue;border-right:3px solid blue;border-top:3px solid blue;"
								class="tdColor">扣款总额</td>
							<td style="width: 10%; font-size: 12px; height: 35px;border-left:3px solid blue;border-right:3px solid blue;border-top:3px solid blue;"
								class="tdColor">可调休加班</td>
							<td style="width: 8%; font-size: 12px; height: 35px;"
								class="tdColor">请假</td>
							<td style="width: 8%; font-size: 12px; height: 35px;"
								class="tdColor">法定节日加班</td>
							<td style="width: 8%; font-size: 12px; height: 35px;border-left:3px solid blue;border-right:3px solid blue;border-top:3px solid blue;"
								class="tdColor">累计剩余调休</td>
							<td style="width: 8%; font-size: 12px; height: 35px;"
								class="tdColor">累计剩余年假</td>
							<td style="width: 8%; font-size: 12px; height: 35px;"
								class="tdColor">操作</td>
						</tr>
					</table>
					<table id="tb" border="1" style="width: 100%">
					</table>
				</div>
				<!-- vip 表格 显示 end-->
			</div>
			<!-- vip页面样式end -->
		</div>

	</div>

</body>
</html>