<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="pragma" content="no-cache" />
<meta http-equiv="cache-control" content="no-cache" />
<title>技术工作表</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/showbox.css" />
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/flatpickr.material_blue.min.css">
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/xcConfirm.css?v=2010" />
<link href='http://fonts.googleapis.com/css?family=Roboto'
	rel='stylesheet' type='text/css'>
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/css.css?v=1990" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/select4.css?v=1999" />
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.2.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/select3.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/xcConfirm.js"></script>
<script src="${pageContext.request.contextPath}/js/changePsd.js"></script>
<style type="text/css">
a:link {
	color: #000
} /* 未访问的链接 */
a:hover {
	color: #FF00FF
} /* 鼠标移动到链接上 */

</style>

<script type="text/javascript">
	var userNum;
	var dayNum;
	var userArr;
	var jobArrP;
	var jobArrA;
	var jobArrA_previous;
	var year;
	var month;
	var DayOfWeek;
	var startWeekStr;
	var timer;
	var len;//滚轮长度
	var sId;
	$(document)
			.ready(
					function() {
						sId = "${sessionId}";
						if(sId == null || sId == ""){
							parent.location.href = "${pageContext.request.contextPath}/page/login";
						}else{
							var w = document.documentElement.clientWidth;
							document.getElementById('scrollBody').style.width = (w - 200)
									+ "px";
							var da = new Date();
							year = da.getFullYear();
							month = da.getMonth() + 1;
							dayNum = new Date(year, month, 0).getDate();//当月天数
							DayOfWeek = (da.getDay() == 0) ? 7 : da.getDay();
							startWeekStr = formatDate(
									new Date(year, month - 1, da.getDate()
											- DayOfWeek + 1)).substring(0, 10);//当前周第一天

							$("#year").val(year);
							month = month < 10 ? "0" + month : month;
							$("#month").val(month);
							getUserList(year, month);
							getTableList();
							getJobList();
							if (parseInt(startWeekStr.split("/")[1]) == month) {
								var position = (startWeekStr.split("/")[2] - 1) * 140 - 1;
								$('#scrollBody').scrollLeft(position);
							}
							$("#year").select2({});
							$("#month").select2({});
						}
					});

	function getUserList(year, month) {
		$
				.ajax({
					url : "${pageContext.request.contextPath}/userList",
					type : 'GET',
					data : {
						"dpartId" : 101,
						"date" : year + "/" + month + "/1",
						"name" : "",
						"nickName" : "",
						"jobId" : "",
						"isHide" : true
					},
					cache : false,
					async : false,
					success : function(returndata) {
						userArr = new Array();
						var str = '<tr id="corner" style="height:25px;color: #a10333;width: 120px;"><td><Strong>姓名/日期</Strong></td></tr>';
						var data2 = eval("(" + returndata + ")").userlist;
						userNum = data2.length;
						//alert(userNum);
						for ( var i in data2) {
							str += '<tr style="width: 140px;height:38px;" id="tr_'+i+'" ><td><strong>'
									+ data2[i].name + '</strong></td></tr>';
							userArr.push(data2[i].UId + "#" + data2[i].name);
						}
						$("#tb1").empty();
						$("#tb1").append(str);

					},
					error : function(XMLHttpRequest, textStatus, errorThrown) {
					}
				});
	}

	function getTableList() {
		var str = '<tr style="width: 100%; float: left; height: 25px;background-color: #eee;">';
		for (var i = 0; i < dayNum; i++) {
			str += '<td style="width: 140px; height: 25px;"><Strong>' + (i + 1)
					+ '日</Strong></td>';
		}
		str += '</tr>';
		for (var j = 0; j < userNum; j++) {
			var str2 = '<tr style="width: 100%; float: left; height: 38px; overflow-y: hidden;">';
			for (var k = 0; k < dayNum; k++) {
				str2 += '<td style="width: 140px;height: 38px;" id="'
						+ j
						+ "_"
						+ k
						+ '">'
						+ '<input id="'
						+ j
						+ "_"
						+ k
						+ '_1" type="text" style="border:0px;font-size:12px;text-indent:1px;height:30px" '
						+ 'disabled="disabled" >'
						+ '<input id="'
						+ j
						+ "_"
						+ k
						+ '_2" type="text" style="border:0px;font-size:12px;text-indent:1px;height:30px;display:none" '
						+ 'disabled="disabled" >'
						+ '</td>'
			}
			str2 += '</tr>';
			str = str + str2;
		}
		document.getElementById("tb2").style.width = dayNum * 140 + 'px';
		$("#tb2").empty();
		$("#tb2").append(str);

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
		return (myyear + "/" + mymonth + "/" + myweekday + " " + hour + ":" + minute);
	}

	function getList() {
		year = $("#year").val();
		month = $("#month").val();
		dayNum = new Date(year, month, 0).getDate();
		getUserList(year, month);
		getTableList();
		getJobList();
		var da = new Date();
		var thisMonth = da.getMonth() + 1;
		var thisYear = da.getFullYear();
		if (thisMonth == month && thisYear == year) {
			var position = (startWeekStr.split("/")[2] - 1) * 140 - 1;
			$('#scrollBody').scrollLeft(position);
		} else {
			$('#scrollBody').scrollLeft(1);
		}
	}
	
	function updateNewArr(arr){
		jobArrA = new Array();
		for(var i=0;i<arr.length;i++){
			var isExist = false;
			for(var j=0;j<jobArrA_previous.length;j++){
				if(arr[i] == jobArrA_previous[j]){
					isExist = true;
					break;
				}
			}
			if(!isExist){
				jobArrA.push(arr[i]);
			}
		}
		return jobArrA;
	}

	function save() {
		jobArrA = new Array();
		for (var i = 0; i < userNum; i++) {
			for (var j = 0; j < dayNum; j++) {
				var userId = userArr[i].split("#")[0];
				var day = j+1;
				day = day<10?"0"+day:day;
				var mDate = year + "/" + month + "/" + day
				var id2 = i + "_" + j + "_2";
				var id2_1 = i + "_" + j + "_2_1";
				var jobDescA = $("#" + id2).val().trim() + "%"
						+ $("#" + id2_1).val().trim();
				var newData = userId + "#" + mDate + "#" + jobDescA;
				jobArrA.push(newData);
			}
		}
		jobArrA = updateNewArr(jobArrA);
		$.ajax({
				url : "${pageContext.request.contextPath}/editJob",
				type : 'POST',
				cache : false,
				dataType : "json",
				data : {
					"mJobArrA" : jobArrA
				},
				traditional : true,
				success : function(returndata) {
					var data = returndata.errcode;
					if (data == 0) {
						alert("保存成功");
						setTimeout(function() {
							location.reload();
						}, 500);
					} else {
						alert("保存失败");
					}
				},
				error : function(XMLHttpRequest, textStatus, errorThrown) {
				}
			});
		} 
	
	function getJobList() {
		$.ajax({
			url : "${pageContext.request.contextPath}/getJobList",
			type : 'GET',
			data : {
				"year" : year,
				"month" : month,
				"userId" : 0
			},
			cache : false,
			async : false,
			success : function(returndata) {
				//alert(returndata);
				var data2 = eval("(" + returndata + ")").joblist;
				jobArrA_previous = new Array();
				
				
				for ( var i in data2) {
					var jobDescriptionP = data2[i].jobDescriptionP;
					var jobDescriptionA = data2[i].jobDescriptionA;
					var time = data2[i].time;
					var day = parseInt(data2[i].date.split("/")[2]) - 1;
					var line = 1000;//设置一个较大的值
					for ( var j in userArr) {
						//userlist的userId跟job的userId对的上
						
						
						if (data2[i].userId == userArr[j].split("#")[0]) {
							line = j;
						}
					}
					if (line != 1000) {
						var mId = line + "_" + day + "_1";
						var tId = line + "_" + day + "_2";
						/* var mId_1 = line + "_" + day + "_1_1";
						var mId2 = line + "_" + day + "_2";
						var mId2_1 = line + "_" + day + "_2_1"; */
						var mTd = line + "_" + day;

						var mTitle = userArr[line].split("#")[1]
								+ parseInt(month) + "月" + parseInt(day + 1)
								+ "日计划\n";

						if (jobDescriptionP != "") {
							var previousValue = $("#" + mId).val();
							var newValue;
							
							if(previousValue != "" && previousValue !=null){
							  newValue = previousValue+";"+jobDescriptionP;
							}else{
								newValue = jobDescriptionP;
							}
							$("#" + mId).val(newValue);
						}

						if (time != "") {
							
							if (time.split(";")[0] != "00:00-00:00") {
								var previousDesc = $("#" + tId).val();
								if(previousDesc !="" && previousDesc != null){
									$("#" + tId).val(previousDesc + time.split(";")[0] + "#" + jobDescriptionP.split("%")[0] + "#");
								}else{
									$("#" + tId).val(time.split(";")[0] + "#" + jobDescriptionP.split("%")[0] + "#");
								}
							}
						}
								var reg = new RegExp("#","g")
								var tTitle = $("#" + tId).val().replace(reg,'\n');
								mTitle = mTitle + tTitle;
								

						$("#" + mId).val() != "" ? $("#" + mId).css({
							"background-color" : "green",
							"color" : "white"
						}) : "";
						document.getElementById(mTd).setAttribute("title",
								mTitle);
					}
				}
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
	};
	
</script>

</head>
<body>
	<div id="pageAll" style="margin-bottom: 30px;">

		<div style="width: 100%; margin: 10px">
			<Strong
				style="text-align: center; margin-left: 50px; width: 150px; margin-right: 50px">查询：</Strong>
			<select class="selCss" style="width: 100px;" id="year">
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
			</select><span style="margin-right: 30px"></span><select class="selCss"
				style="width: 80px;" id="month">
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
			</select> <a class="addA" onClick="getList()">跳转</a> <a class="addA"
				onClick="save()" style="float: right; margin-right: 50px;display:none" >保存</a>
		</div>

		<div
			style="width: 120px; float: left; background-color: #eee; height: auto; margin-top: 10px; margin-left: 20px; margin-bottom: 20px;">
			<table id="tb1"
				style="width: 100%; text-align: center; height: auto;" border="1">
			</table>
		</div>
		<div id="scrollBody"
			style="overflow: auto;float: left; height: auto; margin-top: 10px; margin-right: 20px; margin-bottom: 20px;">

			<table id="tb2"
				style="width: 6200px; text-align: center; overflow: auto;">
			</table>
		</div>
	</div>
	
</body>
</html>