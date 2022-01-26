<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="pragma" content="no-cache" />
<meta http-equiv="cache-control" content="no-cache" />
<title>上传下载考勤数据</title>
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
	var dayNum;
	var userArr;

	$(document)
			.ready(
					function() {
						sId = "${sessionId}";
						if (sId == null || sId == "") {
							parent.location.href = "${pageContext.request.contextPath}/page/login";
						} else {
							getUserPermissionList();
							var da = new Date();
							var year = da.getFullYear();
							var month = da.getMonth() + 1;
							var date = da.getDate();
							month = month < 10 ? "0" + month : month;
							date = date < 10 ? "0" + date : date;
							dayNum = new Date(year, month, 0).getDate();//当月天数
							$("#year").val(year);
							$("#month").val(month);
							getDateList();
							$("#date").val(date);
							getAllList();
							$("#year").select2({});
							$("#month").select2({});
							$("#date").select2({});
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
							if (data[i].permissionId == 76) {
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

	function changeDate() {
		dayNum = new Date($("#year").val(), $("#month").val(), 0).getDate();//当月天数
		var tDate = $("#date").val();//当前选中值;
		getDateList();//刷新select
		var exist = false;
		for (var i = 0; i < $('#date').find('option').length; i++) {
			if ($('#date').get(0).options[i].value == tDate) {
				exist = true;
				break;
			}
		}
		if(exist){
			$("#date").val(tDate);
		}else{
			$("#date").val("01");
		}
	}

	function getDateList() {
		var str = ""
		for (var i = 1; i <= dayNum; i++) {
			var mVal = i < 10 ? "0" + i : i;
			var mTxt = i + "日";
			str += '<option value="'+mVal+'">' + mTxt + '</option>';
		}
		$("#date").empty();
		$("#date").append(str);
	}

	function getNameList() {
		$
				.ajax({
					url : "${pageContext.request.contextPath}/userList",
					type : 'GET',
					data : {
						"dpartId" : 99,
						"date" : $("#year").val() + "/" + $("#month").val()
								+ "/1",
						"name" : "",
						"nickName" : "",
						"jobId" : "",
						"isHide" : true
					},
					cache : false,
					async : false,
					success : function(returndata) {
						userArr = new Array();
						var str = '<tr style="width: 100%;"><td class="tdColor" style="width: 100%; font-size: 12px; height: 50px;border-right-style:none">姓名</td></tr>';
						var data2 = eval("(" + returndata + ")").userlist;
						for ( var i in data2) {
							str += '<tr style="width: 100%"><td class="tdColor2" style="width: 100%;height: 50px;border-right-style:none"><input type="text" disabled="disabled"'
									+ 'style="font-size: 12px;border:none;width:98%;text-align:center;background-color:white" id="user'
									+ data2[i].UId
									+ '" value="'
									+ data2[i].name + '" /></td></tr>';
							userArr.push(data2[i].UId + "#" + data2[i].name+"#"+data2[i].nickName);
						}
						$("#tbName").empty();
						$("#tbName").append(str);

					},
					error : function(XMLHttpRequest, textStatus, errorThrown) {
					}
				});
	}

	function getScheduleList(mDayOfWeek) {
		var mDate = $("#year").val() + "/" + $("#month").val() + "/"
				+ $("#date").val();
		$
				.ajax({
					url : "${pageContext.request.contextPath}/getDailyArrangementList",
					type : 'GET',
					data : {
						"date" : mDate
					},
					cache : false,
					async : false,
					success : function(returndata) {
						//alert(returndata);
						var str = '<tr style="width: 100%"><td class="tdColor" style="width: 100%; font-size: 12px; height: 50px;border-right-style:none">日程</td></tr>';
						var data2 = eval("(" + returndata + ")").dailyarrangementlist;
						for (var i = 0; i < userArr.length; i++) {
							var uName = userArr[i].split("#")[1];
							var uId = userArr[i].split("#")[0];
							var content = "";
							for (var j = 0; j < data2.length; j++) {
								if (data2[j].userId == uId) {
									content += data2[j].time.substring(0, 12)
											+ " " + data2[j].jobDescriptionP + ";"
								}
							}
							if (content == "") {
								if (mDayOfWeek == 6 || mDayOfWeek == 7) {
									str += '<tr style="width: 100%;"><td class="tdColor2" style="width: 100%;border-right-style:none;height: 50px"><textarea type="text"'
											+ 'style="font-size: 12px;border:none;width:98%;text-align:center;background-color:white;resize:none;height: 46px;" id="schedule'
											+ uId + '">休息</textarea></td></tr>';
								} else {
									str += '<tr style="width: 100%;"><td class="tdColor2" style="width: 100%;border-right-style:none;height: 50px"><textarea type="text"'
											+ 'style="font-size: 12px;border:none;width:98%;text-align:center;background-color:white;color:red;resize:none;height: 46px;" id="schedule'
											+ uId + '">未发</textarea></td></tr>';
								}
							} else {
								str += '<tr style="width: 100%"><td class="tdColor2" style="width: 100%;border-right-style:none;height: 50px"><textarea type="text"'
										+ 'style="font-size: 12px;border:none;width:98%;text-align:center;background-color:white;resize:none;height: 46px;" id="schedule'
										+ uId
										+ '">'
										+ content
										+ '</textarea></td></tr>';
							}
						}
						$("#tbSchedule").empty();
						$("#tbSchedule").append(str);
					},
					error : function(XMLHttpRequest, textStatus, errorThrown) {
					}
				});
	}

	function getDailyReportList(mDayOfWeek) {
		var mDate = $("#year").val() + "/" + $("#month").val() + "/"
				+ $("#date").val();
		$
				.ajax({
					url : "${pageContext.request.contextPath}/getAllDailyUploadReportList",
					type : 'GET',
					data : {
						"date" : mDate
					},
					cache : false,
					async : false,
					success : function(returndata) {
						//alert(returndata);
						var str = '<tr style="width: 100%"><td class="tdColor" style="width: 100%; font-size: 12px; height: 50px;border-right-style:none">日报</td></tr>';
						var data2 = eval("(" + returndata + ")").dailyuploadreportlist;
						for (var i = 0; i < userArr.length; i++) {
							var uName = userArr[i].split("#")[1];
							var uId = userArr[i].split("#")[0];
							var nickName = userArr[i].split("#")[2];
							var content = "";
							for (var j = 0; j < data2.length; j++) {
								if (data2[j].userName == nickName) {
									content = "已发";
									break;
								}
							}
							if (content == "") {
								if (mDayOfWeek == 6 || mDayOfWeek == 7) {
									str += '<tr style="width: 100%;"><td class="tdColor2" style="width: 100%;height: 50px;border-right-style:none"><input type="text"'
											+ 'style="font-size: 12px;border:none;width:98%;text-align:center;background-color:white" id="dailyReport'
											+ uId + '"/></td></tr>';
								} else {
									str += '<tr style="width: 100%;"><td class="tdColor2" style="width: 100%;height: 50px;border-right-style:none"><input type="text"'
											+ 'style="font-size: 12px;border:none;width:98%;text-align:center;background-color:white;color:red" id="dailyReport'
											+ uId + '" value="未发" /></td></tr>';
								}
							} else {
								str += '<tr style="width: 100%"><td class="tdColor2" style="width: 100%;height: 50px;border-right-style:none"><input type="text"'
										+ 'style="font-size: 12px;border:none;width:98%;text-align:center;background-color:white;" id="dailyReport'
										+ uId + '" value="已发" /></td></tr>';
							}
						}
						$("#tbDailyReport").empty();
						$("#tbDailyReport").append(str);
					},
					error : function(XMLHttpRequest, textStatus, errorThrown) {
					}
				});
	}

	function getWeekReportList(mDayOfWeek) {
		//周五检查周报
		var str = '<tr style="width: 100%"><td class="tdColor" style="width: 100%; font-size: 12px; height: 50px;border-right-style:none">周报</td></tr>';
		var startWeekStr = formatDate(new Date($("#year").val(), $("#month")
				.val() - 1, $("#date").val() - mDayOfWeek + 1));
		var endWeekStr = formatDate(new Date($("#year").val(), $("#month")
				.val() - 1, $("#date").val() - mDayOfWeek + 7));
		if (mDayOfWeek != 5) {
			for (var i = 0; i < userArr.length; i++) {
				var uId = userArr[i].split("#")[0];
				str += '<tr style="width: 100%;"><td class="tdColor2" style="width: 100%;height: 50px;border-right-style:none"><input type="text"'
						+ 'style="font-size: 12px;border:none;width:98%;text-align:center;background-color:white" id="weekReport'
						+ uId + '"/></td></tr>';
			}
		} else {
			$
					.ajax({
						url : "${pageContext.request.contextPath}/getAllWeekUploadReportList",
						type : 'GET',
						data : {
							"startDate" : startWeekStr,
							"endDate" : endWeekStr
						},
						cache : false,
						async : false,
						success : function(returndata) {
							var data2 = eval("(" + returndata + ")").weekuploadreportlist;
							for (var i = 0; i < userArr.length; i++) {
								var uName = userArr[i].split("#")[1];
								var uId = userArr[i].split("#")[0];
								var content = "";
								for (var j = 0; j < data2.length; j++) {
									if (data2[j].userName == uName) {
										content = "已发";
										break;
									}
								}
								if (content == "") {
									str += '<tr style="width: 100%;"><td class="tdColor2" style="width: 100%;height: 50px;border-right-style:none"><input type="text"'
											+ 'style="font-size: 12px;border:none;width:98%;text-align:center;background-color:white;color:red" id="weekReport'
											+ uId + '" value="未发" /></td></tr>';
								} else {
									str += '<tr style="width: 100%"><td class="tdColor2" style="width: 100%;height: 50px;border-right-style:none"><input type="text"'
											+ 'style="font-size: 12px;border:none;width:98%;text-align:center;background-color:white;" id="weekReport'
											+ uId + '" value="已发" /></td></tr>';
								}
							}
						},
						error : function(XMLHttpRequest, textStatus,
								errorThrown) {
						}
					});
		}
	//	$("#tbWeekReport").empty();
	//	$("#tbWeekReport").append(str);
	}

	function getNextWeekPlanList(mDayOfWeek) {
		//周日检查下周计划
		var str = '<tr style="width: 100%"><td class="tdColor" style="width: 100%; font-size: 12px; height: 50px;border-right-style:none">下周计划</td></tr>';
		var startWeekStr = formatDate(new Date($("#year").val(), $("#month")
				.val() - 1, $("#date").val() - mDayOfWeek + 8));
		var endWeekStr = formatDate(new Date($("#year").val(), $("#month")
				.val() - 1, $("#date").val() - mDayOfWeek + 14));

		if (mDayOfWeek != 7) {
			for (var i = 0; i < userArr.length; i++) {
				var uId = userArr[i].split("#")[0];
				str += '<tr style="width: 100%;"><td class="tdColor2" style="width: 100%;height: 50px;border-right-style:none"><input type="text"'
						+ 'style="font-size: 12px;border:none;width:98%;text-align:center;background-color:white" id="nextWeekPlan'
						+ uId + '"/></td></tr>';
			}
		} else {
			$
					.ajax({
						url : "${pageContext.request.contextPath}/getWeekPlan",
						type : 'GET',
						data : {
							"userId" : 0,
							"startDate" : startWeekStr,
							"endDate" : endWeekStr
						},
						cache : false,
						async : false,
						success : function(returndata) {
							var data2 = eval("(" + returndata + ")").joblist;
							for (var i = 0; i < userArr.length; i++) {
								var uName = userArr[i].split("#")[1];
								var uId = userArr[i].split("#")[0];
								var content = "";
								for (var j = 0; j < data2.length; j++) {
									if (data2[j].userId == uId
											&& data2[j].jobDescriptionP != ""
											&& data2[j].jobDescriptionP != "%") {
										content = "已发";
										break;
									}
								}
								if (content == "") {
									str += '<tr style="width: 100%;"><td class="tdColor2" style="width: 100%;height: 50px;border-right-style:none"><input type="text"'
											+ 'style="font-size: 12px;border:none;width:98%;text-align:center;background-color:white;color:red" id="nextWeekPlan'
											+ uId + '" value="未发" /></td></tr>';
								} else {
									str += '<tr style="width: 100%"><td class="tdColor2" style="width: 100%;height: 50px;border-right-style:none"><input type="text"'
											+ 'style="font-size: 12px;border:none;width:98%;text-align:center;background-color:white;" id="nextWeekPlan'
											+ uId + '" value="已发" /></td></tr>';
								}
							}

						},
						error : function(XMLHttpRequest, textStatus,
								errorThrown) {
						}
					});
		}
	//	$("#tbNextWeekPlan").empty();
	//	$("#tbNextWeekPlan").append(str);
	}

	function getWeekProjectReportList(mDayOfWeek) {
		var str = '<tr style="width: 100%"><td class="tdColor" style="width: 100%; font-size: 12px; height: 50px;border-right-style:none">项目报告</td></tr>';
		for (var i = 0; i < userArr.length; i++) {
			var uId = userArr[i].split("#")[0];
			if (mDayOfWeek == 7) {
				str += '<tr style="width: 100%;"><td class="tdColor2" style="width: 100%;height: 50px;border-right-style:none"><input type="text"'
						+ 'style="font-size: 12px;border:none;width:98%;text-align:center;background-color:white;color:red" id="projectReport'
						+ uId + '" value="未发" /></td></tr>';
			} else {
				str += '<tr style="width: 100%;"><td class="tdColor2" style="width: 100%;height: 50px;border-right-style:none"><input type="text"'
						+ 'style="font-size: 12px;border:none;width:98%;text-align:center;background-color:white" id="projectReport'
						+ uId + '"/></td></tr>';
			}
		}
	//	$("#tbProjectReport").empty();
	//	$("#tbProjectReport").append(str);
	}

	function getSignList() {
		var mDate = $("#year").val() + "/" + $("#month").val() + "/"
				+ $("#date").val();

		var str = '<tr style="width: 100%"><td class="tdColor" style="width: 100%; font-size: 12px; height: 50px;border-right-style:none">签到/签退</td></tr>';
		$
				.ajax({
					url : "${pageContext.request.contextPath}/allCheckList",
					type : 'GET',
					data : {
						"date" : mDate,
						"department" : 0
					},
					cache : false,
					async : false,
					success : function(returndata) {
						//alert(returndata);
						var data = eval("(" + returndata + ")").wechatlist;
						for (var i = 0; i < userArr.length; i++) {
							var uName = userArr[i].split("#")[1];
							var uId = userArr[i].split("#")[0];
							var content = "";
							for (var j = 0; j < data.length; j++) {
								if (data[j].name == uName) {
									var details = data[j].detail.list;
									for ( var k in details) {
										content += details[k].checkTime
												.substring(0, 5)
												+ " "
												+ details[k].address
												+ " "
												+ details[k].checkFlag
												+ "\n";
									}
									break;
								}

							}
							str += '<tr style="width: 100%;"><td class="tdColor2" style="width: 100%;border-right-style:none;height: 50px;"><textarea type="text"'
									+ 'style="font-size: 12px;border:none;width:98%;text-align:center;background-color:white;resize:none;height: 46px;" id="sign'
									+ uId
									+ '">'
									+ content
									+ '</textarea></td></tr>';
						}

					},
					error : function(XMLHttpRequest, textStatus, errorThrown) {
					}
				});

		$("#tbSign").empty();
		$("#tbSign").append(str);
	}

	function getRemarkList() {
		var str = '<tr style="width: 100%"><td class="tdColor" style="width: 100%; font-size: 12px; height: 50px;border-right-style:none">备注</td></tr>';
		for (var i = 0; i < userArr.length; i++) {
			var uId = userArr[i].split("#")[0];
			str += '<tr style="width: 100%;"><td class="tdColor2" style="width: 100%;height: 50px;border-right-style:none"><input type="text"'
					+ 'style="font-size: 12px;border:none;width:98%;text-align:center;background-color:white" id="remark'
					+ uId + '"/></td></tr>';
		}
		$("#tbRemark").empty();
		$("#tbRemark").append(str);
	}

	function getOverWorkTimeList() {
		var str = '<tr style="width: 100%"><td class="tdColor" style="width: 100%; font-size: 12px; height: 50px;border-right-style:none">加班</td></tr>';
		for (var i = 0; i < userArr.length; i++) {
			var uId = userArr[i].split("#")[0];
			str += '<tr style="width: 100%;"><td class="tdColor2" style="width: 100%;height: 50px;border-right-style:none"><input type="text"'
					+ 'style="font-size: 12px;border:none;width:98%;text-align:center;background-color:white" id="overWorkTime'
					+ uId + '" value="0"/></td></tr>';
		}
		$("#tbOverWorkTime").empty();
		$("#tbOverWorkTime").append(str);
	}

	function getAdjustRestTimeList() {
		var str = '<tr style="width: 100%"><td class="tdColor" style="width: 100%; font-size: 12px; height: 50px;border-right-style:none">请假</td></tr>';
		for (var i = 0; i < userArr.length; i++) {
			var uId = userArr[i].split("#")[0];
			str += '<tr style="width: 100%;"><td class="tdColor2" style="width: 100%;height: 50px;border-right-style:none"><input type="text"'
					+ 'style="font-size: 12px;border:none;width:98%;text-align:center;background-color:white" id="adjustRestTime'
					+ uId + '" value="0"/></td></tr>';
		}
		$("#tbAdjustRestTime").empty();
		$("#tbAdjustRestTime").append(str);
	}

	function getFestivalOverWorkTimeList() {
		var str = '<tr style="width: 100%"><td class="tdColor" style="width: 100%; font-size: 12px; height: 50px;border-right-style:none">法定节日加班</td></tr>';
		for (var i = 0; i < userArr.length; i++) {
			var uId = userArr[i].split("#")[0];
			str += '<tr style="width: 100%;"><td class="tdColor2" style="width: 100%;height: 50px;border-right-style:none"><input type="text"'
					+ 'style="font-size: 12px;border:none;width:98%;text-align:center;background-color:white" id="festivalOverWorkTime'
					+ uId + '" value="0"/></td></tr>';
		}
		$("#tbFestivalOverWorkTime").empty();
		$("#tbFestivalOverWorkTime").append(str);
	}

	function getIsLateList() {
		var str = '<tr style="width: 100%"><td class="tdColor" style="width: 100%; font-size: 12px; height: 50px;border-right-style:none">迟到</td></tr>';
		for (var i = 0; i < userArr.length; i++) {
			var uId = userArr[i].split("#")[0];
			str += '<tr style="width: 100%;"><td class="tdColor2" style="width: 100%;height: 50px;border-right-style:none"><input type="text"'
					+ 'style="font-size: 12px;border:none;width:98%;text-align:center;background-color:white" id="isLate'
					+ uId + '"/></td></tr>';
		}
		$("#tbIsLate").empty();
		$("#tbIsLate").append(str);
	}

	function getOperationList() {
		var str = '<tr style="width: 100%"><td class="tdColor" style="width: 100%; font-size: 12px; height: 50px;">操作</td></tr>';
		for (var i = 0; i < userArr.length; i++) {
			var uId = userArr[i].split("#")[0];
			str += '<tr style="width: 100%;"><td class="tdColor2" style="width: 100%;height: 50px;">'
					+ '<img title="上传" style="vertical-align:middle" class="operation" src="../image/update.png"'
					+ 'onclick="createWorkAttendance(' + uId + ')"/></td></tr>';
		}
		$("#tbOperation").empty();
		$("#tbOperation").append(str);
	}

	function getAllList() {
		var newDate = new Date($("#year").val(), $("#month").val() - 1, $(
				"#date").val());
		var DayOfWeek = (newDate.getDay() == 0) ? 7 : newDate.getDay();
		getNameList();
		getScheduleList(DayOfWeek);
		getDailyReportList(DayOfWeek);
		getWeekReportList(DayOfWeek);
		getNextWeekPlanList(DayOfWeek);
		getWeekProjectReportList(DayOfWeek);
		getSignList();
		getRemarkList();
		getOverWorkTimeList();
		getAdjustRestTimeList();
		getFestivalOverWorkTimeList();
		getIsLateList();
		getOperationList();
	}

	function formatDate(date) {
		var myyear = date.getFullYear();
		var mymonth = date.getMonth() + 1;
		var myweekday = date.getDate();
		var hour = date.getHours();
		var minute = date.getMinutes();
		if (mymonth < 10) {
			mymonth = "0" + mymonth;
		}
		if (myweekday < 10) {
			myweekday = "0" + myweekday;
		}
		return (myyear + "/" + mymonth + "/" + myweekday);
	}

	function createWorkAttendance(mUId) {
		if (isPermissionEdit) {
			var date = $("#year").val() + "/" + $("#month").val() + "/"
					+ $("#date").val();
			var uName = $("#user" + mUId).val();
			var schedule = $("#schedule" + mUId).val().trim();
			var dailyReport = $("#dailyReport" + mUId).val().trim();
		//	var weekReport = $("#weekReport" + mUId).val().trim();
		//	var nextWeekPlan = $("#nextWeekPlan" + mUId).val().trim();
		//	var projectReport = $("#projectReport" + mUId).val().trim();
			var sign = $("#sign" + mUId).val().trim();
			var remark = $("#remark" + mUId).val().trim();
			var overWorkTime = $("#overWorkTime" + mUId).val().trim();
			var adjustRestTime = $("#adjustRestTime" + mUId).val().trim();
			var festivalOverWorkTime = $("#festivalOverWorkTime" + mUId).val()
					.trim();
			var isLate = ($("#isLate" + mUId).val().trim() == 1 || $(
					"#isLate" + mUId).val().trim() == "迟到") ? 1 : 0;

			var patten1 = /^[0-9]+(.[0-9]{1})?$/.test(overWorkTime);
			var patten2 = /^[0-9]+(.[0-9]{1})?$/.test(adjustRestTime);
			var patten3 = /^[0-9]+(.[0-9]{1})?$/.test(festivalOverWorkTime);

			if (!patten1 || !patten2 || !patten3) {
				alert("加班或请假输入格式不正确, 请重新输入");
				return;
			}
			$
					.ajax({
						url : "${pageContext.request.contextPath}/createWorkAttendance",
						type : 'POST',
						cache : false,
						data : {
							"date" : date,
							"name" : uName,
							"schedule" : schedule,
							"dailyReport" : dailyReport,
						//	"weekReport" : weekReport,
						//	"nextWeekPlan" : nextWeekPlan,
						//	"projectReport" : projectReport,
							"sign" : sign,
							"remark" : remark,
							"isLate" : isLate,
							"overWorkTime" : overWorkTime,
							"adjustRestTime" : adjustRestTime,
							"festivalOverWorkTime" : festivalOverWorkTime
						},
						success : function(returndata) {
							var data = eval("(" + returndata + ")").errcode;
							if (data == 0) {
								alert("上传成功");
							} else if (data == 3) {
								alert("该条记录已经上传,请勿重复上传");
							} else {
								alert("上传失败");
							}
						},
						error : function(XMLHttpRequest, textStatus,
								errorThrown) {
						}
					});
		} else {
			alert("你没有权限对此操作");
		}
	}
</script>
</head>

<body id="body" style="display: none;">
	<div id="pageAll">
		<div class="pageTop">
			<div class="page">
				<img src="../image/coin02.png" /><span><a href="#">首页</a>&nbsp;-&nbsp;<a
					href="#">考勤管理</a>&nbsp;-</span>&nbsp;上传下载考勤数据
			</div>
		</div>

		<div class="page">
			<!-- vip页面样式 -->
			<div class="vip">
				<div class="conform">
					<form>
						<div class="cfD">
							<Strong style="margin-right: 30px">查询条件：</Strong><select
								class="selCss" style="width: 80px;" id="year"
								onChange="changeDate()">
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
							</select><a style="margin-left: 20px"></a><select class="selCss"
								style="width: 80px;" id="month" onChange="changeDate()">
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
							</select><a style="margin-left: 20px"></a><select class="selCss"
								style="width: 80px;" id="date">
								<option value="01">1月</option>
								<option value="02">2月</option>
							</select> <a class="addA" style="width: 120px" onClick="getAllList()">生成</a>
						</div>
					</form>
				</div>

				<div style="width: 100%; margin-bottom: 30px;">

					<div class="conShow"
						style="width: 7%; float: left; margin-bottom: 30px;">
						<table id="tbName" style="width: 100%">
						</table>
					</div>

					<div class="conShow" style="width: 14%; float: left;">
						<table id="tbSchedule" style="width: 100%; overflow: auto">
						</table>
					</div>

					<div class="conShow" style="width: 4%; float: left;">
						<table id="tbDailyReport" style="width: 100%; overflow: auto">
						</table>
					</div>

				 	<!-- <div class="conShow" style="width: 4%; float: left;">
						<table id="tbWeekReport" style="width: 100%; overflow: auto">
						</table>
					</div>  -->

					<!-- <div class="conShow" style="width: 4%; float: left;">
						<table id="tbNextWeekPlan" style="width: 100%; overflow: auto">
						</table>
					</div> -->

					<!--  <div class="conShow" style="width: 4%; float: left;">
						<table id="tbProjectReport" style="width: 100%; overflow: auto">
						</table>
					</div>  -->

					<div class="conShow" style="width: 40%; float: left;">
						<table id="tbSign" style="width: 100%; overflow: auto">
						</table>
					</div>

					<div class="conShow" style="width: 15%; float: left;">
						<table id="tbRemark" style="width: 100%; overflow: auto">
						</table>
					</div>

					<div class="conShow" style="width: 4%; float: left;">
						<table id="tbOverWorkTime" style="width: 100%; overflow: auto">
						</table>
					</div>

					<div class="conShow" style="width: 4%; float: left;">
						<table id="tbAdjustRestTime" style="width: 100%; overflow: auto">
						</table>
					</div>

					<div class="conShow" style="width: 4%; float: left;">
						<table id="tbFestivalOverWorkTime"
							style="width: 100%; overflow: auto">
						</table>
					</div>

					<div class="conShow" style="width: 4%; float: left;">
						<table id="tbIsLate" style="width: 100%; overflow: auto">
						</table>
					</div>

					<div class="conShow" style="width: 4%; float: left;">
						<table id="tbOperation" style="width: 100%; overflow: auto">
						</table>
					</div>

				</div>

			</div>
			<!-- vip页面样式end -->
		</div>

	</div>

</body>
</html>