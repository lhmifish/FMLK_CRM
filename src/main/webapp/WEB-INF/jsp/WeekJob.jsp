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
<title>周计划</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/showbox.css" />
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/flatpickr.material_blue.min.css">
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/xcConfirm.css?v=2010" />
<link href='http://fonts.googleapis.com/css?family=Roboto'
	rel='stylesheet' type='text/css'>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.2.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/jweixin-1.0.0.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/flatpickr.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/xcConfirm.js"></script>
<script src="${pageContext.request.contextPath}/js/getObjectList.js"></script>
<style>
.mask-layer-loading {
	position: fixed;
	width: 100%;
	height: 100%;
	z-index: 999999;
	top: 0;
	left: 0;
	text-align: center;
	display: none;
}

.mask-layer-loading i, .mask-layer-loading img {
	text-align: center;
	color: #000000;
	font-size: 50px;
	position: relative;
	top: 50%;
}

input:-webkit-autofill, textarea:-webkit-autofill, select:-webkit-autofill
	{
	background-color: rgba(217, 217, 217, 0.29);
}

input {
	border: 0;
	background: #fff;
}

body {
	max-width: 640px;
	color: #444;
}
/*独立*/
.form {
	margin-top: 10px;
	width: 100%;
	background-color: #F5F5F5
}

.form div {
	background-color: #FFF;
}

.form p {
	height: 20px;
	line-height: 20px;
	margin-left: 5px;
	font-size: 12px;
}

.form img {
	width: 15px;
	height: 15px;
	position: relative;
	top: 6px;
	margin-right: 5px;
}

.form .mes {
	margin-left: 25px;
	border-bottom: 2px solid #F5F5F5;
}

.form .mes2 {
	margin-left: 10px;
	border-bottom: 2px solid #F5F5F5;
	height: auto;
	line-height: 13px;
}

.form .mes3 {
	margin-left: 10px;
	border-bottom: 2px solid #F5F5F5;
	height: auto;
	line-height: 13px;
}

.form .button-submit {
	height: 80px;
	line-height: 80px;
	text-align: center;
	background-color: #F5F5F5;
}

.button-submit button {
	position: fixed;
	bottom: 0;
	z-index: 9999;
	width: 100%;
	max-width: 640px;
	height: 40px;
	background-color: #459BFE;
	color: #FFF;
	border: 0;
}

select { /*很关键：将默认的select选择框样式清除*/
	appearance: none;
	-moz-appearance: none;
	-webkit-appearance: none;
	/*在选择框的最右侧中间显示小箭头图片*/
	background: url("${pageContext.request.contextPath}/image/arrow.png")
		no-repeat scroll right center transparent;
	/*为下拉小箭头留出一点位置，避免被文字覆盖*/
	padding-right: 14px;
	border: 0;
	width: 95%;
}
/*清除ie的默认选择框样式清除，隐藏下拉箭头*/
select::-ms-expand {
	display: none;
}

#pickdate {
	border: 0;
	width: 95%;
	background: url("./images/images/gd/arrow.png") no-repeat scroll right
		center transparent;
}

.evaluate_right {
	float: left;
	width: 100%;
	height: 100%;
}

.evaluate_right .rate_content {
	border: 0;
	background: #fff;
}

.evaluate_right_three {
	height: 50px;
	width: 60px;
	line-height: 55px;
	background: #fff;
}

.evaluate_right_imgs {
	margin-top: 17px;
}

.evaluate_right_four {
	margin-top: 23px;
}

.evaluate_right_two {
	bottom: -17px;
}

.evaluate_right .input-file {
	width: 50px;
	height: 50px;
}

.test .right_imgs li {
	float: left;
	display: block;
	height: 50px;
	width: 50px;
	background: no-repeat center center;
	background-size: cover;
	margin-right: 5px;
	position: relative;
}

.right_imgs li>span {
	position: absolute;
	cursor: pointer;
	text-align: center;
	top: -5px;
	right: -5px;
	width: 13px;
	height: 13px;
	line-height: 13px;
	z-index: 3;
	font-size: 12px;
	background-color: #000;
	opacity: .8;
	filter: alpha(opacity = 80);
	color: #FFF;
	text-decoration: none;
	border-radius: 50%;
	display: block;
}

.verticalAlign {
	vertical-align: top;
	display: inline-block;
	height: 100%;
	margin-left: -1px;
}

.xcConfirm .popBox {
	background-color: #ffffff;
	width: 320px;
	height: 480px;
	margin-left: -160px;
	border-radius: 5px;
	font-weight: bold;
	color: #535e66;
	top: 180px;
}

.xcConfirm .popBox .ttBox {
	height: 20px;
	line-height: 20px;
	border-bottom: solid 1px #eef0f1;
	padding: 10px 20px;
}

.xcConfirm .popBox .ttBox .tt {
	font-size: 12px;
	display: block;
	height: 15px;
}

.xcConfirm .popBox .txtBox {
	margin: 5px 5px;
	height: 380px;
	overflow: hidden;
}

.xcConfirm .popBox .btnGroup .sgBtn {
	margin-top: 10px;
	margin-right: 10px;
}

.xcConfirm .popBox .txtBox p {
	height: 400px;
	margin: 5px;
	line-height: 16px;
	overflow-x: hidden;
	overflow-y: auto;
}

.xcConfirm .popBox .sgBtn {
	display: block;
	cursor: pointer;
	width: 95px;
	height: 25px;
	line-height: 25px;
	text-align: center;
	color: #FFFFFF;
	border-radius: 5px;
	font-size: 12px;
}

.not-arrow {
	padding: 5px 10px;
	border: 1px solid #dcd8d8;
	-webkit-appearance: none;
	-moz-appearance: none;
	appearance: none;
}

.not-arrow::-ms-expand {
	display: none;
}
/*独立*/
</style>
<script type="text/javascript">
	var sId;
	var host;
	var today, DayOfWeek;
	var tMon, tTue, tWed, tThu, tFir, tSat, tSun;
	var divThisWeekPlan;
	var nMon, nTue, nWed, nThu, nFir, nSat, nSun;
	var tMonNum, tTueNum, tWedNum, tThuNum, tFirNum, tSatNum, tSunNum;
	var nMonNum, nTueNum, nWedNum, nThuNum, nFirNum, nSatNum, nSunNum;

	$(document).ready(
			function() {
				sId = "${mUserId}";
				host = "${pageContext.request.contextPath}";
				$(document).attr("title", getUser(sId).name + "的周计划");
				tMonNum = 1, tTueNum = 1, tWedNum = 1, tThuNum = 1,
						tFirNum = 1, tSatNum = 1, tSunNum = 1;
				nMonNum = 1, nTueNum = 1, nWedNum = 1, nThuNum = 1,
						nFirNum = 1, nSatNum = 1, nSunNum = 1;
				initalDate();
                getWeekPlan();
			});

	function getUser(nName) {
		var user;
		$.ajax({
			url : host + "/getUserByNickName",
			type : 'GET',
			data : {
				"nickName" : nName
			},
			cache : false,
			async : false,
			success : function(returndata) {
				user = eval("(" + returndata + ")").user[0];
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
		return user;
	}


	function initalDate() {
		today = new Date();
		DayOfWeek = (today.getDay() == 0) ? 7 : today.getDay();
		var year = today.getFullYear();
		var month = today.getMonth();
		var date = today.getDate();
		tMon = formatDate(new Date(year, month, date - DayOfWeek + 1))
				.substring(0, 10);
		tTue = formatDate(new Date(year, month, date - DayOfWeek + 2))
				.substring(0, 10);
		tWed = formatDate(new Date(year, month, date - DayOfWeek + 3))
				.substring(0, 10);
		tThu = formatDate(new Date(year, month, date - DayOfWeek + 4))
				.substring(0, 10);
		tFir = formatDate(new Date(year, month, date - DayOfWeek + 5))
				.substring(0, 10);
		tSat = formatDate(new Date(year, month, date - DayOfWeek + 6))
				.substring(0, 10);
		tSun = formatDate(new Date(year, month, date - DayOfWeek + 7))
				.substring(0, 10);
		nMon = formatDate(new Date(year, month, date - DayOfWeek + 8))
				.substring(0, 10);
		nTue = formatDate(new Date(year, month, date - DayOfWeek + 9))
				.substring(0, 10);
		nWed = formatDate(new Date(year, month, date - DayOfWeek + 10))
				.substring(0, 10);
		nThu = formatDate(new Date(year, month, date - DayOfWeek + 11))
				.substring(0, 10);
		nFir = formatDate(new Date(year, month, date - DayOfWeek + 12))
				.substring(0, 10);
		nSat = formatDate(new Date(year, month, date - DayOfWeek + 13))
				.substring(0, 10);
		nSun = formatDate(new Date(year, month, date - DayOfWeek + 14))
				.substring(0, 10);

		$("#tWeek").html(tMon + "   至   " + tSun);
		$("#nWeek").html(nMon + "   至   " + nSun);

		$("#tMonDate").html(tMon);
		$("#tTueDate").html(tTue);
		$("#tWedDate").html(tWed);
		$("#tThuDate").html(tThu);
		$("#tFirDate").html(tFir);
		$("#tSatDate").html(tSat);
		$("#tSunDate").html(tSun);
		$("#nMonDate").html(nMon);
		$("#nTueDate").html(nTue);
		$("#nWedDate").html(nWed);
		$("#nThuDate").html(nThu);
		$("#nFirDate").html(nFir);
		$("#nSatDate").html(nSat);
		$("#nSunDate").html(nSun);
		
		//周六开始才能看到下周
 		if (today >= new Date(tSat)) {
			$("#divNextWeek").attr("style", "display:block;");
			$("#aThisWeed").show();

		} else {
			$("#divNextWeek").attr("style", "display:none;");
			$("#aThisWeed").hide();
		}
	}

	function setInSideValue2(arr,dateDiv,addDiv,idDate1,idDate2,idClient){
		var str2;
		for (var a = 0; a <= 23; a++) {
			if (a < 10) {
				str2 += '<option>0' + a + ':00</option>' + '<option>0' + a
						+ ':30</option>';
			} else {
				str2 += '<option>' + a + ':00</option>' + '<option>' + a
						+ ':30</option>';
			}
		}
		$("#"+idDate1+"1").append(str2);
		$("#"+idDate2+"1").append(str2);
		$("#"+idDate1+"1").find("option:contains(" + arr[0].split("#")[0] + ")").attr("selected", true);
		$("#"+idDate2+"1").find("option:contains(" + arr[0].split("#")[1] + ")").attr("selected", true);
		$("#"+idClient+"1").val(arr[0].split("#")[2]);
		
		for(var i=2;i<=arr.length;i++){
			//先append字符串再赋值
			var str = '<div id="' + addDiv + i + '" style="width:100%">';
			str += '<p><strong>时间：</strong>';
			str += '<select id="' + idDate1 + i 
					+ '" style="width: 35%; margin-left: 10px"></select>';
			str += '<strong>至 </strong>';
			str += '<select id="' + idDate2 + i 
					+ '" style="width: 35%; margin-left: 10px;"></select></p>';
			str += '<div style="height: 60px; font-size: 12px; margin-left: 5px;"><strong style="float: left">事件：</strong>';
			str += '<textarea id="' + idClient + i 
					+ '" style="width: 70%; margin-left: 10px; border: 0; resize: none" rows="3"></textarea></div></div>';
			$("#" + dateDiv).append(str);
			
			$("#"+ idDate1 + i ).append(str2);
			$("#"+idDate2 + i ).append(str2);
			$("#"+idDate1 + i ).find("option:contains(" + arr[i-1].split("#")[0] + ")").attr("selected", true);
			$("#"+idDate2 + i ).find("option:contains(" + arr[i-1].split("#")[1] + ")").attr("selected", true);
			$("#"+idClient + i ).val(arr[i-1].split("#")[2]);
			
		}
	}
	
	
	
	function setInSideValue(arr,dateId,dateId2,desc){
		var str2;
		for (var a = 0; a <= 23; a++) {
			if (a < 10) {
				str2 += '<option>0' + a + ':00</option>' + '<option>0' + a
						+ ':30</option>';
			} else {
				str2 += '<option>' + a + ':00</option>' + '<option>' + a
						+ ':30</option>';
			}
		}
		if(arr.length==0){
			$("#"+dateId).append(str2);
			$("#"+dateId2).append(str2);
			$("#"+dateId).val("08:00");
			$("#"+dateId2).val("17:00");
		}else if(arr.length==1){
			$("#"+dateId).append(str2);
			$("#"+dateId2).append(str2);
			$("#"+dateId).find("option:contains(" + arr[0].split("#")[0] + ")").attr("selected", true);
			$("#"+dateId2).find("option:contains(" + arr[0].split("#")[1] + ")").attr("selected", true);
			$("#"+desc).val(arr[0].split("#")[2]);
		}
	}
	
	
	
	function setValue(idNo,arr){
		
		if(arr.length<=1){
			//数组只有一条或没有数据
			var dateId,dateId2,desc;
			if(idNo==1){
				dateId = "tMonTime_1_1";
				dateId2 = "tMonTime_2_1";
				desc = "tMonClient_1"
			}else if(idNo==2){
				dateId = "tTueTime_1_1";
				dateId2 = "tTueTime_2_1";
				desc = "tTueClient_1"
			}else if(idNo==3){
				dateId = "tWedTime_1_1";
				dateId2 = "tWedTime_2_1";
				desc = "tWedClient_1"
			}else if(idNo==4){
				dateId = "tThuTime_1_1";
				dateId2 = "tThuTime_2_1";
				desc = "tThuClient_1"
			}else if(idNo==5){
				dateId = "tFirTime_1_1";
				dateId2 = "tFirTime_2_1";
				desc = "tFirClient_1"
			}else if(idNo==6){
				dateId = "tSatTime_1_1";
				dateId2 = "tSatTime_2_1";
				desc = "tSatClient_1"
			}else if(idNo==7){
				dateId = "tSunTime_1_1";
				dateId2 = "tSunTime_2_1";
				desc = "tSunClient_1"
			}else if(idNo==8){
				dateId = "nMonTime_1_1";
				dateId2 = "nMonTime_2_1";
				desc = "nMonClient_1"
			}else if(idNo==9){
				dateId = "nTueTime_1_1";
				dateId2 = "nTueTime_2_1";
				desc = "nTueClient_1"
			}else if(idNo==10){
				dateId = "nWedTime_1_1";
				dateId2 = "nWedTime_2_1";
				desc = "nWedClient_1"
			}else if(idNo==11){
				dateId = "nThuTime_1_1";
				dateId2 = "nThuTime_2_1";
				desc = "nThuClient_1"
			}else if(idNo==12){
				dateId = "nFirTime_1_1";
				dateId2 = "nFirTime_2_1";
				desc = "nFirClient_1"
			}else if(idNo==13){
				dateId = "nSatTime_1_1";
				dateId2 = "nSatTime_2_1";
				desc = "nSatClient_1"
			}else if(idNo==14){
				dateId = "nSunTime_1_1";
				dateId2 = "nSunTime_2_1";
				desc = "nSunClient_1"
			}
			setInSideValue(arr,dateId,dateId2,desc);
		}else{
			//数组有多条数据
			var dateDiv,addDiv,idDate1,idDate2,idClient;
			if(idNo==1){
				tMonNum = arr.length;
				dateDiv = "tMonDiv";
				addDiv = "div_tMon_"
				idDate1 = "tMonTime_1_";
				idDate2 = "tMonTime_2_";
				idClient = "tMonClient_";
			}else if(idNo==2){
				tTueNum = arr.length;
				dateDiv = "tTueDiv";
				addDiv = "div_tTue_";
				idDate1 = "tTueTime_1_";
				idDate2 = "tTueTime_2_";
				idClient = "tTueClient_";
			}else if(idNo==3){
				tWedNum = arr.length;
				dateDiv = "tWedDiv";
				addDiv = "div_tWed_";
				idDate1 = "tWedTime_1_";
				idDate2 = "tWedTime_2_";
				idClient = "tWedClient_";
			}else if(idNo==4){
				tThuNum = arr.length;
				dateDiv = "tThuDiv";
				addDiv = "div_tThu_";
				idDate1 = "tThuTime_1_";
				idDate2 = "tThuTime_2_";
				idClient = "tThuClient_";
			}else if(idNo==5){
				tFirNum = arr.length;
				dateDiv = "tFirDiv";
				addDiv = "div_tFir_";
				idDate1 = "tFirTime_1_";
				idDate2 = "tFirTime_2_";
				idClient = "tFirClient_";
			}else if(idNo==6){
				tSatNum = arr.length;
				dateDiv = "tSatDiv";
				addDiv = "div_tSat_";
				idDate1 = "tSatTime_1_";
				idDate2 = "tSatTime_2_";
				idClient = "tSatClient_";
			}else if(idNo==7){
				tSunNum = arr.length;
				dateDiv = "tSunDiv";
				addDiv = "div_tSun_";
				idDate1 = "tSunTime_1_";
				idDate2 = "tSunTime_2_";
				idClient = "tSunClient_";
			}else if(idNo==8){
				nMonNum = arr.length;
				dateDiv = "nMonDiv";
				addDiv = "div_nMon_"
				idDate1 = "nMonTime_1_";
				idDate2 = "nMonTime_2_";
				idClient = "nMonClient_";
			}else if(idNo==9){
				nTueNum = arr.length;
				dateDiv = "nTueDiv";
				addDiv = "div_nTue_";
				idDate1 = "nTueTime_1_";
				idDate2 = "nTueTime_2_";
				idClient = "nTueClient_";
			}else if(idNo==10){
				nWedNum = arr.length;
				dateDiv = "nWedDiv";
				addDiv = "div_nWed_";
				idDate1 = "nWedTime_1_";
				idDate2 = "nWedTime_2_";
				idClient = "nWedClient_";
			}else if(idNo==11){
				nThuNum = arr.length;
				dateDiv = "nThuDiv";
				addDiv = "div_nThu_";
				idDate1 = "nThuTime_1_";
				idDate2 = "nThuTime_2_";
				idClient = "nThuClient_";
			}else if(idNo==12){
				nFirNum = arr.length;
				dateDiv = "nFirDiv";
				addDiv = "div_nFir_";
				idDate1 = "nFirTime_1_";
				idDate2 = "nFirTime_2_";
				idClient = "nFirClient_";
			}else if(idNo==13){
				nSatNum = arr.length;
				dateDiv = "nSatDiv";
				addDiv = "div_nSat_";
				idDate1 = "nSatTime_1_";
				idDate2 = "nSatTime_2_";
				idClient = "nSatClient_";
			}else if(idNo==14){
				nSunNum = arr.length;
				dateDiv = "nSunDiv";
				addDiv = "div_nSun_";
				idDate1 = "nSunTime_1_";
				idDate2 = "nSunTime_2_";
				idClient = "nSunClient_";
			}
			setInSideValue2(arr,dateDiv,addDiv,idDate1,idDate2,idClient);
		}
		
		
		
		
	}

	function getWeekPlan() {
		$.ajax({
			url : host + "/getWeekPlan",
			type : 'GET',
			data : {
				"userId" : getUser(sId).UId,
				"startDate" : tMon,
				"endDate" : nSun
			},
			cache : false,
			async : false,
			success : function(returndata) {
				var data = eval("(" + returndata + ")").joblist;
				var tMonArr = new Array(),tTueArr = new Array(),tWedArr = new Array(),tThuArr = new Array(),
				tFirArr = new Array(),tSatArr = new Array(),tSunArr = new Array();
				var nMonArr = new Array(),nTueArr = new Array(),nWedArr = new Array(),nThuArr = new Array(),
				nFirArr = new Array(),nSatArr = new Array(),nSunArr = new Array();
				
				for ( var i in data) {
					var mTime = data[i].time;
					var mJobDescriptionP = data[i].jobDescriptionP;
					var mDate = data[i].date;
					time1 = mTime.split("-")[0];
					time2 = mTime.split("-")[1];
                    
					if (mDate == tMon) {
						tMonArr.push(time1+"#"+time2+"#"+mJobDescriptionP);
					} else if (mDate == tTue) {
						tTueArr.push(time1+"#"+time2+"#"+mJobDescriptionP);
					} else if (mDate == tWed) {
						tWedArr.push(time1+"#"+time2+"#"+mJobDescriptionP);
					} else if (mDate == tThu) {
						tThuArr.push(time1+"#"+time2+"#"+mJobDescriptionP);
					} else if (mDate == tFir) {
						tFirArr.push(time1+"#"+time2+"#"+mJobDescriptionP);
                    } else if (mDate == tSat) {
                    	tSatArr.push(time1+"#"+time2+"#"+mJobDescriptionP);
					} else if (mDate == tSun) {
						tSunArr.push(time1+"#"+time2+"#"+mJobDescriptionP);
					} else if (mDate == nMon) {
						nMonArr.push(time1+"#"+time2+"#"+mJobDescriptionP);
					} else if (mDate == nTue) {
						nTueArr.push(time1+"#"+time2+"#"+mJobDescriptionP);
					} else if (mDate == nWed) {
						nWedArr.push(time1+"#"+time2+"#"+mJobDescriptionP);
					} else if (mDate == nThu) {
						nThuArr.push(time1+"#"+time2+"#"+mJobDescriptionP);
					} else if (mDate == nFir) {
						nFirArr.push(time1+"#"+time2+"#"+mJobDescriptionP);
					} else if (mDate == nSat) {
						nSatArr.push(time1+"#"+time2+"#"+mJobDescriptionP);
					} else if (mDate == nSun) {
						nSunArr.push(time1+"#"+time2+"#"+mJobDescriptionP);
					}

				}
				setValue(1,tMonArr);
				setValue(2,tTueArr);
				setValue(3,tWedArr);
				setValue(4,tThuArr);
				setValue(5,tFirArr);
				setValue(6,tSatArr);
				setValue(7,tSunArr);
				setValue(8,nMonArr);
				setValue(9,nTueArr);
				setValue(10,nWedArr);
				setValue(11,nThuArr);
				setValue(12,nFirArr);
				setValue(13,nSatArr);
				setValue(14,nSunArr);
			}
		});

	}

	function createWeekPlan() {
		var weekPlanArray = new Array();
		for(var i=1;i<=tMonNum;i++){
			var tMonTime = $("#tMonTime_1_"+i+" option:selected").text() + "-"
			+ $("#tMonTime_2_"+i+" option:selected").text();
			var tMonClient = $("#tMonClient_"+i).val();
			if (tMonClient != "") {
				weekPlanArray.push(tMon + "#" + tMonTime + "#" + tMonClient);
			}
		}
		
		for(var i=1;i<=tTueNum;i++){
			var tTueTime = $("#tTueTime_1_"+i+" option:selected").text() + "-"
			+ $("#tTueTime_2_"+i+" option:selected").text();
			var tTueClient = $("#tTueClient_"+i).val();
			if (tTueClient != "") {
				weekPlanArray.push(tTue + "#" + tTueTime + "#" + tTueClient);
			}
		}
		
		for(var i=1;i<=tWedNum;i++){
			var tWedTime = $("#tWedTime_1_"+i+" option:selected").text() + "-"
			+ $("#tWedTime_2_"+i+" option:selected").text();
			var tWedClient = $("#tWedClient_"+i).val();
			if (tWedClient != "") {
				weekPlanArray.push(tWed + "#" + tWedTime + "#" + tWedClient);
			}
		}
		
		for(var i=1;i<=tThuNum;i++){
			var tThuTime = $("#tThuTime_1_"+i+" option:selected").text() + "-"
			+ $("#tThuTime_2_"+i+" option:selected").text();
			var tThuClient = $("#tThuClient_"+i).val();
			if (tThuClient != "") {
				weekPlanArray.push(tThu + "#" + tThuTime + "#" + tThuClient);
			}
		}
		
		for(var i=1;i<=tFirNum;i++){
			var tFirTime = $("#tFirTime_1_"+i+" option:selected").text() + "-"
			+ $("#tFirTime_2_"+i+" option:selected").text();
			var tFirClient = $("#tFirClient_"+i).val();
			if (tFirClient != "") {
				weekPlanArray.push(tFir + "#" + tFirTime + "#" + tFirClient);
			}
		}
		
		for(var i=1;i<=tSatNum;i++){
			var tSatTime = $("#tSatTime_1_"+i+" option:selected").text() + "-"
			+ $("#tSatTime_2_"+i+" option:selected").text();
			var tSatClient = $("#tSatClient_"+i).val();
			if (tSatClient != "") {
				weekPlanArray.push(tSat + "#" + tSatTime + "#" + tSatClient);
			}
		}
		
		for(var i=1;i<=tSunNum;i++){
			var tSunTime = $("#tSunTime_1_"+i+" option:selected").text() + "-"
			+ $("#tSunTime_2_"+i+" option:selected").text();
			var tSunClient = $("#tSunClient_"+i).val();
			if (tSunClient != "") {
				weekPlanArray.push(tSun + "#" + tSunTime + "#" + tSunClient);
			}
		}
		
		
		if(today >= new Date(tSat)){
			
			for(var i=1;i<=nMonNum;i++){
				var nMonTime = $("#nMonTime_1_"+i+" option:selected").text() + "-"
				+ $("#nMonTime_2_"+i+" option:selected").text();
				var nMonClient = $("#nMonClient_"+i).val();
				if (nMonClient != "") {
					weekPlanArray.push(nMon + "#" + nMonTime + "#" + nMonClient);
				}
			}
			
			for(var i=1;i<=nTueNum;i++){
				var nTueTime = $("#nTueTime_1_"+i+" option:selected").text() + "-"
				+ $("#nTueTime_2_"+i+" option:selected").text();
				var nTueClient = $("#nTueClient_"+i).val();
				if (nTueClient != "") {
					weekPlanArray.push(nTue + "#" + nTueTime + "#" + nTueClient);
				}
			}
			
			for(var i=1;i<=nWedNum;i++){
				var nWedTime = $("#nWedTime_1_"+i+" option:selected").text() + "-"
				+ $("#nWedTime_2_"+i+" option:selected").text();
				var nWedClient = $("#nWedClient_"+i).val();
				if (nWedClient != "") {
					weekPlanArray.push(nWed + "#" + nWedTime + "#" + nWedClient);
				}
			}
			
			for(var i=1;i<=nThuNum;i++){
				var nThuTime = $("#nThuTime_1_"+i+" option:selected").text() + "-"
				+ $("#nThuTime_2_"+i+" option:selected").text();
				var nThuClient = $("#nThuClient_"+i).val();
				if (nThuClient != "") {
					weekPlanArray.push(nThu + "#" + nThuTime + "#" + nThuClient);
				}
			}
			
			for(var i=1;i<=nFirNum;i++){
				var nFirTime = $("#nFirTime_1_"+i+" option:selected").text() + "-"
				+ $("#nFirTime_2_"+i+" option:selected").text();
				var nFirClient = $("#nFirClient_"+i).val();
				if (nFirClient != "") {
					weekPlanArray.push(nFir + "#" + nFirTime + "#" + nFirClient);
				}
			}
			
			for(var i=1;i<=nSatNum;i++){
				var nSatTime = $("#nSatTime_1_"+i+" option:selected").text() + "-"
				+ $("#nSatTime_2_"+i+" option:selected").text();
				var nSatClient = $("#nSatClient_"+i).val();
				if (nSatClient != "") {
					weekPlanArray.push(nSat + "#" + nSatTime + "#" + nSatClient);
				}
			}
			
			for(var i=1;i<=nSunNum;i++){
				var nSunTime = $("#nSunTime_1_"+i+" option:selected").text() + "-"
				+ $("#nSunTime_2_"+i+" option:selected").text();
				var nSunClient = $("#nSunClient_"+i).val();
				if (nSunClient != "") {
					weekPlanArray.push(nSun + "#" + nSunTime + "#" + nSunClient);
				}
			}	
		}
		$.ajax({
			url : host + "/createWeekPlan",
			type : 'POST',
			cache : false,
			dataType : "json",
			data : {
				"userId" : getUser(sId).UId,
				"weekPlanArray" : weekPlanArray
			},
			traditional : true,
			success : function(returndata) {
				var data = returndata.errcode;
				if (data == 0) {
					alert("提交成功");
					setTimeout(function() {
						//这个可以关闭安卓系统的手机  
						document.addEventListener('WeixinJSBridgeReady',
								function() {
									WeixinJSBridge.call('closeWindow');
								}, false);
						//这个可以关闭ios系统的手机  
						WeixinJSBridge.call('closeWindow');
					}, 500)
				} else {
					alert("提交失败");
				}

			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});

	}

	function nextWeekPlan() {
		$("body").scrollTop(996);
	}

	function thisWeekPlan() {
		$("body").scrollTop(0);
	}

	function scrollPage() {

	}

	function updateNewTime(dateId, num) {
		var str2;
		for (var a = 0; a <= 23; a++) {
			if (a < 10) {
				str2 += '<option>0' + a + ':00</option>' + '<option>0' + a
						+ ':30</option>';
			} else {
				str2 += '<option>' + a + ':00</option>' + '<option>' + a
						+ ':30</option>';
			}
		}
		var mStr1, mStr2;
		if (dateId == 1) {
			mStr1 = "tMonTime_1_" + num;
			mStr2 = "tMonTime_2_" + num;
        } else if (dateId == 2) {
        	mStr1 = "tTueTime_1_" + num;
			mStr2 = "tTueTime_2_" + num;
		} else if (dateId == 3) {
        	mStr1 = "tWedTime_1_" + num;
			mStr2 = "tWedTime_2_" + num;
		} else if (dateId == 4) {
        	mStr1 = "tThuTime_1_" + num;
			mStr2 = "tThuTime_2_" + num;
		} else if (dateId == 5) {
        	mStr1 = "tFirTime_1_" + num;
			mStr2 = "tFirTime_2_" + num;
		} else if (dateId == 6) {
        	mStr1 = "tSatTime_1_" + num;
			mStr2 = "tSatTime_2_" + num;
		} else if (dateId == 7) {
        	mStr1 = "tSunTime_1_" + num;
			mStr2 = "tSunTime_2_" + num;
		} else if (dateId == 8) {
			mStr1 = "nMonTime_1_" + num;
			mStr2 = "nMonTime_2_" + num;
        } else if (dateId == 9) {
        	mStr1 = "nTueTime_1_" + num;
			mStr2 = "nTueTime_2_" + num;
		} else if (dateId == 10) {
        	mStr1 = "nWedTime_1_" + num;
			mStr2 = "nWedTime_2_" + num;
		} else if (dateId == 11) {
        	mStr1 = "nThuTime_1_" + num;
			mStr2 = "nThuTime_2_" + num;
		} else if (dateId == 12) {
        	mStr1 = "nFirTime_1_" + num;
			mStr2 = "nFirTime_2_" + num;
		} else if (dateId == 13) {
        	mStr1 = "nSatTime_1_" + num;
			mStr2 = "nSatTime_2_" + num;
		} else if (dateId == 14) {
        	mStr1 = "nSunTime_1_" + num;
			mStr2 = "nSunTime_2_" + num;
		}
		$("#" + mStr1).append(str2);
        $("#" + mStr2).append(str2);
		$("#" + mStr1).val("08:00");
		$("#" + mStr2).val("17:00");

	}

	function add(dateId) {
	   var dateDiv, addDiv, idDate1, idDate2, idClient, dateNum;
       if (dateId == 1) {
			if(tMonNum==3){
				alert("当天最多只能添加三个行程");
				return;
			}
    	    tMonNum++;
			dateDiv = "tMonDiv";
			addDiv = "div_tMon_" + tMonNum;
			idDate1 = "tMonTime_1_" + tMonNum;
			idDate2 = "tMonTime_2_" + tMonNum;
			idClient = "tMonClient_" + tMonNum;
			dateNum = tMonNum;
		} else if (dateId == 2) {
			if(tTueNum==3){
				alert("当天最多只能添加三个行程");
				return;
			}
			tTueNum++;
			dateDiv = "tTueDiv";
			addDiv = "div_tTue_" + tTueNum;
			idDate1 = "tTueTime_1_" + tTueNum;
			idDate2 = "tTueTime_2_" + tTueNum;
			idClient = "tTueClient_" + tTueNum;
			dateNum = tTueNum;
		} else if (dateId == 3) {
			if(tWedNum==3){
				alert("当天最多只能添加三个行程");
				return;
			}
			tWedNum++;
			dateDiv = "tWedDiv";
			addDiv = "div_tWed_" + tWedNum;
			idDate1 = "tWedTime_1_" + tWedNum;
			idDate2 = "tWedTime_2_" + tWedNum;
			idClient = "tWedClient_" + tWedNum;
			dateNum = tWedNum;
		} else if (dateId == 4) {
			if(tThuNum==3){
				alert("当天最多只能添加三个行程");
				return;
			}
			tThuNum++;
			dateDiv = "tThuDiv";
			addDiv = "div_tThu_" + tThuNum;
			idDate1 = "tThuTime_1_" + tThuNum;
			idDate2 = "tThuTime_2_" + tThuNum;
			idClient = "tThuClient_" + tThuNum;
			dateNum = tThuNum;
		} else if (dateId == 5) {
			if(tFirNum==3){
				alert("当天最多只能添加三个行程");
				return;
			}
			tFirNum++;
			dateDiv = "tFirDiv";
			addDiv = "div_tFir_" + tFirNum;
			idDate1 = "tFirTime_1_" + tFirNum;
			idDate2 = "tFirTime_2_" + tFirNum;
			idClient = "tFirClient_" + tFirNum;
			dateNum = tFirNum;
		} else if (dateId == 6) {
			if(tSatNum==3){
				alert("当天最多只能添加三个行程");
				return;
			}
			tSatNum++;
			dateDiv = "tSatDiv";
			addDiv = "div_tSat_" + tSatNum;
			idDate1 = "tSatTime_1_" + tSatNum;
			idDate2 = "tSatTime_2_" + tSatNum;
			idClient = "tSatClient_" + tSatNum;
			dateNum = tSatNum;
		} else if (dateId == 7) {
			if(tSunNum==3){
				alert("当天最多只能添加三个行程");
				return;
			}
			tSunNum++;
			dateDiv = "tSunDiv";
			addDiv = "div_tSun_" + tSunNum;
			idDate1 = "tSunTime_1_" + tSunNum;
			idDate2 = "tSunTime_2_" + tSunNum;
			idClient = "tSunClient_" + tSunNum;
			dateNum = tSunNum;
		} else if(dateId == 8){
			if(nMonNum==3){
				alert("当天最多只能添加三个行程");
				return;
			}
    	    nMonNum++;
			dateDiv = "nMonDiv";
			addDiv = "div_nMon_" + nMonNum;
			idDate1 = "nMonTime_1_" + nMonNum;
			idDate2 = "nMonTime_2_" + nMonNum;
			idClient = "nMonClient_" + nMonNum;
			dateNum = nMonNum;
		}else if (dateId == 9) {
			if(nTueNum==3){
				alert("当天最多只能添加三个行程");
				return;
			}
			nTueNum++;
			dateDiv = "nTueDiv";
			addDiv = "div_nTue_" + nTueNum;
			idDate1 = "nTueTime_1_" + nTueNum;
			idDate2 = "nTueTime_2_" + nTueNum;
			idClient = "nTueClient_" + nTueNum;
			dateNum = nTueNum;
		} else if (dateId == 10) {
			if(nWedNum==3){
				alert("当天最多只能添加三个行程");
				return;
			}
			nWedNum++;
			dateDiv = "nWedDiv";
			addDiv = "div_nWed_" + nWedNum;
			idDate1 = "nWedTime_1_" + nWedNum;
			idDate2 = "nWedTime_2_" + nWedNum;
			idClient = "nWedClient_" + nWedNum;
			dateNum = nWedNum;
		} else if (dateId == 11) {
			if(nThuNum==3){
				alert("当天最多只能添加三个行程");
				return;
			}
			nThuNum++;
			dateDiv = "nThuDiv";
			addDiv = "div_nThu_" + nThuNum;
			idDate1 = "nThuTime_1_" + nThuNum;
			idDate2 = "nThuTime_2_" + nThuNum;
			idClient = "nThuClient_" + nThuNum;
			dateNum = nThuNum;
		} else if (dateId == 12) {
			if(nFirNum==3){
				alert("当天最多只能添加三个行程");
				return;
			}
			nFirNum++;
			dateDiv = "nFirDiv";
			addDiv = "div_nFir_" + nFirNum;
			idDate1 = "nFirTime_1_" + nFirNum;
			idDate2 = "nFirTime_2_" + nFirNum;
			idClient = "nFirClient_" + nFirNum;
			dateNum = nFirNum;
		} else if (dateId == 13) {
			if(nSatNum==3){
				alert("当天最多只能添加三个行程");
				return;
			}
			nSatNum++;
			dateDiv = "nSatDiv";
			addDiv = "div_nSat_" + nSatNum;
			idDate1 = "nSatTime_1_" + nSatNum;
			idDate2 = "nSatTime_2_" + nSatNum;
			idClient = "nSatClient_" + nSatNum;
			dateNum = nSatNum;
		} else if (dateId == 14) {
			if(nSunNum==3){
				alert("当天最多只能添加三个行程");
				return;
			}
			nSunNum++;
			dateDiv = "nSunDiv";
			addDiv = "div_nSun_" + nSunNum;
			idDate1 = "nSunTime_1_" + nSunNum;
			idDate2 = "nSunTime_2_" + nSunNum;
			idClient = "nSunClient_" + nSunNum;
			dateNum = nSunNum;
		}
        appendNewJob(dateDiv, addDiv, idDate1, idDate2, idClient, dateId,
				dateNum);
	}

	function appendNewJob(dateDiv, addDiv, idDate1, idDate2, idClient, dateId,
			dateNum) {

		var str = '<div id="' + addDiv + '" style="width:100%">';
		str += '<p><strong>时间：</strong>';
		str += '<select id="' + idDate1
				+ '" style="width: 35%; margin-left: 10px"></select>';
		str += '<strong>至 </strong>';
		str += '<select id="' + idDate2
				+ '" style="width: 35%; margin-left: 10px;"></select></p>';
		str += '<div style="height: 60px; font-size: 12px; margin-left: 5px;"><strong style="float: left">事件：</strong>';
		str += '<textarea id="'
				+ idClient
				+ '" style="width: 70%; margin-left: 10px; border: 0; resize: none" rows="3"></textarea></div></div>';
		$("#" + dateDiv).append(str);
		updateNewTime(dateId, dateNum);

	}

	function reduce(dateId) {
		if (dateId == 1) {
			if (tMonNum == 1) {
				alert("当日安排至少需要一个");
				return;
			} else {
                $("#div_tMon_" + tMonNum).remove();
				tMonNum--;
			}
        }else if(dateId==2){
        	if (tTueNum == 1) {
				alert("当日安排至少需要一个");
				return;
			} else {
                $("#div_tTue_" + tTueNum).remove();
                tTueNum--;
			}
        }else if(dateId==3){
        	if (tWedNum == 1) {
				alert("当日安排至少需要一个");
				return;
			} else {
                $("#div_tWed_" + tWedNum).remove();
                tWedNum--;
			}
        }else if(dateId==4){
        	if (tThuNum == 1) {
				alert("当日安排至少需要一个");
				return;
			} else {
                $("#div_tThu_" + tThuNum).remove();
                tThuNum--;
			}
        	
        }else if(dateId==5){
        	if (tFirNum == 1) {
				alert("当日安排至少需要一个");
				return;
			} else {
                $("#div_tFir_" + tFirNum).remove();
                tFirNum--;
			}
        }else if(dateId==6){
        	if (tSatNum == 1) {
				alert("当日安排至少需要一个");
				return;
			} else {
                $("#div_tSat_" + tSatNum).remove();
                tSatNum--;
			}
        }else if(dateId==7){
        	if (tSunNum == 1) {
				alert("当日安排至少需要一个");
				return;
			} else {
                $("#div_tSun_" + tSunNum).remove();
                tSunNum--;
			}
        }else if(dateId == 8) {
			if (nMonNum == 1) {
				alert("当日安排至少需要一个");
				return;
			} else {
                $("#div_nMon_" + nMonNum).remove();
                nMonNum--;
			}
        }else if(dateId==9){
        	if (nTueNum == 1) {
				alert("当日安排至少需要一个");
				return;
			} else {
                $("#div_nTue_" + nTueNum).remove();
                nTueNum--;
			}
        }else if(dateId==10){
        	if (nWedNum == 1) {
				alert("当日安排至少需要一个");
				return;
			} else {
                $("#div_nWed_" + nWedNum).remove();
                nWedNum--;
			}
        }else if(dateId==11){
        	if (nThuNum == 1) {
				alert("当日安排至少需要一个");
				return;
			} else {
                $("#div_nThu_" + nThuNum).remove();
                nThuNum--;
			}
        	
        }else if(dateId==12){
        	if (nFirNum == 1) {
				alert("当日安排至少需要一个");
				return;
			} else {
                $("#div_nFir_" + nFirNum).remove();
                nFirNum--;
			}
        }else if(dateId==13){
        	if (nSatNum == 1) {
				alert("当日安排至少需要一个");
				return;
			} else {
                $("#div_nSat_" + nSatNum).remove();
                nSatNum--;
			}
        }else if(dateId==14){
        	if (nSunNum == 1) {
				alert("当日安排至少需要一个");
				return;
			} else {
                $("#div_nSun_" + nSunNum).remove();
                nSunNum--;
			}
        }
		

	}
</script>
</head>



<body class="body-gray" style="margin: auto; background-color: #fff"
	id="mBody" onscroll="scrollPage()">
	<div class="form">

		<div class="top" style="width: 100%;">


			<div id="topDiv"
				style="width: 97%; margin-bottom: 5px; margin-top: 5px; margin-left: 10px;">
				<Strong style="font-size: 12px;">本周日期：</Strong><label id="tWeek"
					style="font-size: 12px;"></label> <a id="aThisWeed"
					style="float: right; margin-right: 20px; font-size: 12px; margin-top: 4px; display: none"
					href="javascript:void(0)" onclick="nextWeekPlan();return false;">下周计划</a>
			</div>

			<div id="list" style="width: 100%;">
				<div
					style="width: 97%; border: 1px solid black; margin: 5px; height: auto;"
					id="tMonDiv">
					<p>
						<strong>日期：</strong><label id="tMonDate" style="margin-left: 10px"></label>&nbsp;&nbsp;&nbsp;周一
						<button style="margin-right: 15px; float: right"
							onclick="reduce(1)">减少日程</button>
						<button style="margin-right: 15px; float: right" onclick="add(1)">增加日程</button>
					</p>

					<div id="div_tMon_1" style="width: 100%">
						<p>
							<strong>时间：</strong><select id="tMonTime_1_1"
								style="width: 35%; margin-left: 10px"></select><strong>至 </strong><select id="tMonTime_2_1"
								style="width: 35%; margin-left: 10px;"></select>
						</p>
						<div style="height: 60px; font-size: 12px; margin-left: 5px;">
							<strong style="float: left">事件：</strong>
							<textarea id="tMonClient_1"
								style="width: 70%; margin-left: 10px; border: 0; resize: none"
								rows="3"></textarea>
						</div>
					</div>

				</div>

				<div
					style="width: 97%; border: 1px solid black; margin: 5px; height: auto;"
					id="tTueDiv">
					<p>
						<strong>日期：</strong><label id="tTueDate" style="margin-left: 10px"></label>&nbsp;&nbsp;&nbsp;周二
						<button style="margin-right: 15px; float: right"
							onclick="reduce(2)">减少日程</button>
						<button style="margin-right: 15px; float: right" onclick="add(2)">增加日程</button>
					</p>
					<div id="div_tTue_1" style="width: 100%">
						<p>
							<strong>时间：</strong> <select id="tTueTime_1_1"
								style="width: 35%; margin-left: 10px"></select><strong>至</strong><select id="tTueTime_2_1" 
								style="width: 35%; margin-left: 10px"></select>
						</p>
						<div style="height: 60px; font-size: 12px; margin-left: 5px">
							<strong style="float: left">事件：</strong>
							<textarea id="tTueClient_1"
								style="width: 70%; margin-left: 10px; border: 0; resize: none"
								rows="3"></textarea>
						</div>
					</div>
				</div>

				<div
					style="width: 97%; border: 1px solid black; margin: 5px; height: auto;"
					id="tWedDiv">
					<p>
						<strong>日期：</strong><label id="tWedDate" style="margin-left: 10px"></label>&nbsp;&nbsp;&nbsp;周三
						<button style="margin-right: 15px; float: right"
							onclick="reduce(3)">减少日程</button>
						<button style="margin-right: 15px; float: right" onclick="add(3)">增加日程</button>
					</p>
					<div id="div_tWed_1" style="width: 100%">
						<p>
							<strong>时间：</strong> <select id="tWedTime_1_1"
								style="width: 35%; margin-left: 10px"></select><strong>至</strong><select id="tWedTime_2_1" 
								style="width: 35%; margin-left: 10px"></select>
						</p>
						<div style="height: 60px; font-size: 12px; margin-left: 5px">
							<strong style="float: left">事件：</strong>
							<textarea id="tWedClient_1"
								style="width: 70%; margin-left: 10px; border: 0; resize: none"
								rows="3"></textarea>
						</div>
					</div>
				</div>

				<div
					style="width: 97%; border: 1px solid black; margin: 5px; height: auto;"
					id="tThuDiv">
					<p>
						<strong>日期：</strong><label id="tThuDate" style="margin-left: 10px"></label>&nbsp;&nbsp;&nbsp;周四
						<button style="margin-right: 15px; float: right"
							onclick="reduce(4)">减少日程</button>
						<button style="margin-right: 15px; float: right" onclick="add(4)">增加日程</button>
					</p>
					<div id="div_tThu_1" style="width: 100%">
						<p>
							<strong>时间：</strong> <select id="tThuTime_1_1"
								style="width: 35%; margin-left: 10px"></select><strong>至</strong><select id="tThuTime_2_1" 
								style="width: 35%; margin-left: 10px"></select>
						</p>
						<div style="height: 60px; font-size: 12px; margin-left: 5px">
							<strong style="float: left">事件：</strong>
							<textarea id="tThuClient_1"
								style="width: 70%; margin-left: 10px; border: 0; resize: none"
								rows="3"></textarea>
						</div>
					</div>
				</div>

				<div
					style="width: 97%; border: 1px solid black; margin: 5px; height: auto;"
					id="tFirDiv">
					<p>
						<strong>日期：</strong><label id="tFirDate" style="margin-left: 10px"></label>&nbsp;&nbsp;&nbsp;周五
						<button style="margin-right: 15px; float: right"
							onclick="reduce(5)">减少日程</button>
						<button style="margin-right: 15px; float: right" onclick="add(5)">增加日程</button>
					</p>
					<div id="div_tFir_1" style="width: 100%">
						<p>
							<strong>时间：</strong> <select id="tFirTime_1_1"
								style="width: 35%; margin-left: 10px"></select><strong>至</strong><select id="tFirTime_2_1" 
								style="width: 35%; margin-left: 10px"></select>
						</p>
						<div style="height: 60px; font-size: 12px; margin-left: 5px">
							<strong style="float: left">事件：</strong>
							<textarea id="tFirClient_1"
								style="width: 70%; margin-left: 10px; border: 0; resize: none"
								rows="3"></textarea>
						</div>
					</div>
				</div>

				<div
					style="width: 97%; border: 1px solid black; margin: 5px; height: auto;"
					id="tSatDiv">
					<p>
						<strong>日期：</strong><label id="tSatDate" style="margin-left: 10px"></label>&nbsp;&nbsp;&nbsp;周六
						<button style="margin-right: 15px; float: right"
							onclick="reduce(6)">减少日程</button>
						<button style="margin-right: 15px; float: right" onclick="add(6)">增加日程</button>
					</p>
					<div id="div_tSat_1" style="width: 100%">
						<p>
							<strong>时间：</strong> <select id="tSatTime_1_1"
								style="width: 35%; margin-left: 10px"></select><strong>至</strong><select id="tSatTime_2_1" 
								style="width: 35%; margin-left: 10px"></select>
						</p>
						<div style="height: 60px; font-size: 12px; margin-left: 5px">
							<strong style="float: left">事件：</strong>
							<textarea id="tSatClient_1"
								style="width: 70%; margin-left: 10px; border: 0; resize: none"
								rows="3"></textarea>
						</div>
					</div>
				</div>

				<div
					style="width: 97%; border: 1px solid black; margin: 5px; height: auto; margin-bottom: 50px"
					id="tSunDiv">
					<p>
						<strong>日期：</strong><label id="tSunDate" style="margin-left: 10px"></label>&nbsp;&nbsp;&nbsp;周日
						<button style="margin-right: 15px; float: right"
							onclick="reduce(7)">减少日程</button>
						<button style="margin-right: 15px; float: right" onclick="add(7)">增加日程</button>
					</p>
					<div id="div_tSun_1" style="width: 100%">
						<p>
							<strong>时间：</strong> <select id="tSunTime_1_1"
								style="width: 35%; margin-left: 10px"></select><strong>至</strong><select id="tSunTime_2_1" 
								style="width: 35%; margin-left: 10px"></select>
						</p>
						<div style="height: 60px; font-size: 12px; margin-left: 5px">
							<strong style="float: left">事件：</strong>
							<textarea id="tSunClient_1"
								style="width: 70%; margin-left: 10px; border: 0; resize: none"
								rows="3"></textarea>
						</div>
					</div>
				</div>
				<div id="divNextWeek" style="display: none">
					<div
						style="width: 97%; margin-bottom: 5px; margin-top: 5px; margin-left: 10px;">
						<Strong style="font-size: 12px;">下周日期：</Strong><label id="nWeek"
							style="font-size: 12px;"></label> <a href="#"
							style="float: right; margin-right: 20px; font-size: 12px; margin-top: 4px;"
							href="javascript:void(0)" onclick="thisWeekPlan();return false;">本周计划</a>
					</div>

					<div id="list" style="width: 100%;">
						<div
							style="width: 97%; border: 1px solid black; margin: 5px; height: auto;"
							id="nMonDiv">
							<p>
								<strong>日期：</strong><label id="nMonDate"
									style="margin-left: 10px"></label>&nbsp;&nbsp;&nbsp;周一
								<button style="margin-right: 15px; float: right"
									onclick="reduce(8)">减少日程</button>
								<button style="margin-right: 15px; float: right"
									onclick="add(8)">增加日程</button>
							</p>
							<p>
								<strong>时间：</strong><select id="nMonTime_1_1"
									style="width: 35%; margin-left: 10px"></select><strong>至 </strong><select id="nMonTime_2_1"
									style="width: 35%; margin-left: 10px;"></select>
							</p>
							<div style="height: 60px; font-size: 12px; margin-left: 5px;">
								<strong style="float: left">事件：</strong>
								<textarea id="nMonClient_1"
									style="width: 70%; margin-left: 10px; border: 0; resize: none"
									rows="3"></textarea>
							</div>

						</div>

						<div
							style="width: 97%; border: 1px solid black; margin: 5px; height: auto;"
							id="nTueDiv">
							<p>
								<strong>日期：</strong><label id="nTueDate"
									style="margin-left: 10px"></label>&nbsp;&nbsp;&nbsp;周二
									<button style="margin-right: 15px; float: right"
									onclick="reduce(9)">减少日程</button>
								<button style="margin-right: 15px; float: right"
									onclick="add(9)">增加日程</button>
							</p>
							<p>
								<strong>时间：</strong> <select id="nTueTime_1_1"
									style="width: 35%; margin-left: 10px"></select><strong>至</strong><select id="nTueTime_2_1"
									style="width: 35%; margin-left: 10px"></select>
							</p>
							<div style="height: 60px; font-size: 12px; margin-left: 5px">
								<strong style="float: left">事件：</strong>
								<textarea id="nTueClient_1"
									style="width: 70%; margin-left: 10px; border: 0; resize: none"
									rows="3"></textarea>
							</div>
						</div>

						<div
							style="width: 97%; border: 1px solid black; margin: 5px; height: auto;"
							id="nWedDiv">
							<p>
								<strong>日期：</strong><label id="nWedDate"
									style="margin-left: 10px"></label>&nbsp;&nbsp;&nbsp;周三
									<button style="margin-right: 15px; float: right"
									onclick="reduce(10)">减少日程</button>
								<button style="margin-right: 15px; float: right"
									onclick="add(10)">增加日程</button>
							</p>

							<p>
								<strong>时间：</strong> <select id="nWedTime_1_1"
									style="width: 35%; margin-left: 10px"></select><strong>至</strong><select id="nWedTime_2_1"
									style="width: 35%; margin-left: 10px"></select>
							</p>
							<div style="height: 60px; font-size: 12px; margin-left: 5px">
								<strong style="float: left">事件：</strong>
								<textarea id="nWedClient_1"
									style="width: 70%; margin-left: 10px; border: 0; resize: none"
									rows="3"></textarea>
							</div>
						</div>

						<div
							style="width: 97%; border: 1px solid black; margin: 5px; height: auto;"
							id="nThuDiv">
							<p>
								<strong>日期：</strong><label id="nThuDate"
									style="margin-left: 10px"></label>&nbsp;&nbsp;&nbsp;周四
									<button style="margin-right: 15px; float: right"
									onclick="reduce(11)">减少日程</button>
								<button style="margin-right: 15px; float: right"
									onclick="add(11)">增加日程</button>
							</p>
							<p>
								<strong>时间：</strong> <select id="nThuTime_1_1"
									style="width: 35%; margin-left: 10px"></select><strong>至</strong><select id="nThuTime_2_1"
									style="width: 35%; margin-left: 10px"></select>
							</p>
							<div style="height: 60px; font-size: 12px; margin-left: 5px">
								<strong style="float: left">事件：</strong>
								<textarea id="nThuClient_1"
									style="width: 70%; margin-left: 10px; border: 0; resize: none"
									rows="3"></textarea>
							</div>
						</div>

						<div
							style="width: 97%; border: 1px solid black; margin: 5px; height: auto;"
							id="nFirDiv">
							<p>
								<strong>日期：</strong><label id="nFirDate"
									style="margin-left: 10px"></label>&nbsp;&nbsp;&nbsp;周五
									<button style="margin-right: 15px; float: right"
									onclick="reduce(12)">减少日程</button>
								<button style="margin-right: 15px; float: right"
									onclick="add(12)">增加日程</button>
							</p>
							<p>
								<strong>时间：</strong> <select id="nFirTime_1_1"
									style="width: 35%; margin-left: 10px"></select><strong>至</strong><select id="nFirTime_2_1"
									style="width: 35%; margin-left: 10px"></select>
							</p>
							<div style="height: 60px; font-size: 12px; margin-left: 5px">
								<strong style="float: left">事件：</strong>
								<textarea id="nFirClient_1"
									style="width: 70%; margin-left: 10px; border: 0; resize: none"
									rows="3"></textarea>
							</div>
						</div>

						<div
							style="width: 97%; border: 1px solid black; margin: 5px; height: auto; font-size: 14px"
							id="nSatDiv">
							<p>
								<strong>日期：</strong><label id="nSatDate"
									style="margin-left: 10px"></label>&nbsp;&nbsp;&nbsp;周六
									<button style="margin-right: 15px; float: right"
									onclick="reduce(13)">减少日程</button>
								<button style="margin-right: 15px; float: right"
									onclick="add(13)">增加日程</button>
							</p>
							<p>
								<strong>时间：</strong> <select id="nSatTime_1_1"
									style="width: 35%; margin-left: 10px"></select><strong>至</strong><select id="nSatTime_2_1"
									style="width: 35%; margin-left: 10px"></select>
							</p>
							<div style="height: 60px; font-size: 12px; margin-left: 5px">
								<strong style="float: left">事件：</strong>
								<textarea id="nSatClient_1"
									style="width: 70%; margin-left: 10px; border: 0; resize: none"
									rows="3"></textarea>
							</div>
						</div>

						<div
							style="width: 97%; border: 1px solid black; margin: 5px; height: auto; margin-bottom: 50px"
							id="nSunDiv">
							<p>
								<strong>日期：</strong><label id="nSunDate"
									style="margin-left: 10px"></label>&nbsp;&nbsp;&nbsp;周日
									<button style="margin-right: 15px; float: right"
									onclick="reduce(14)">减少日程</button>
								<button style="margin-right: 15px; float: right"
									onclick="add(14)">增加日程</button>
							</p>
							<p>
								<strong>时间：</strong> <select id="nSunTime_1_1"
									style="width: 35%; margin-left: 10px"></select><strong>至</strong><select id="nSunTime_2_1"
									style="width: 35%; margin-left: 10px"></select>
							</p>
							<div style="height: 60px; font-size: 12px; margin-left: 5px">
								<strong style="float: left">事件：</strong>
								<textarea id="nSunClient_1"
									style="width: 70%; margin-left: 10px; border: 0; resize: none"
									rows="3"></textarea>
							</div>
						</div>

					</div>

				</div>
			</div>
		</div>
	</div>
	<div class="button-submit">
		<button type="button" onclick="createWeekPlan();"
			class="btn btn-primary">提交</button>
	</div>
</body>
</html>