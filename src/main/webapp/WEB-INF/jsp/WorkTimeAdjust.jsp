<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>加班/调休统计</title>
<link href='http://fonts.googleapis.com/css?family=Roboto'
	rel='stylesheet' type='text/css'>
<style type="text/css">
a {
	text-decoration: none;
}

ul, ol, li {
	list-style: none;
	padding: 0;
	margin: 0;
}

#demo {
	width: 300px;
	margin: 150px auto;
}

p {
	margin: 0;
}
</style>

<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.2.1.min.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/calendar.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery.jqprint-0.3.js"></script>
<script src="http://www.jq22.com/jquery/jquery-migrate-1.2.1.min.js"></script>

<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jszip.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/FileSaver.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/excel-gen.js"></script>

<script type="text/javascript">
	var mDate;
	var mDepartment;
	var arrayName;
	var lastMonth;

	$(document).ready(function() {
		getDate();
		getWorkTimeAdjustList();
	});

	function getDate() {
		var date = new Date();
		var y = date.getFullYear()
		var m = date.getMonth() + 1;
		$('#year').find("option[value=" + y + "]").attr("selected", true);
		$('#month').find("option[value=" + m + "]").attr("selected", true);
	}

	

	// Firefox, Google Chrome, Opera, Safari, Internet Explorer from version 9
	function OnApprovedRestChange(event) {
		if (event.target.value != "") {
			var tid = event.target.id.substring(12);
			var a = parseFloat($("#rest" + tid).text());
			var b = parseFloat($("#approvedRest" + tid).val());
			$("#neverApprovedRest" + tid).val(a - b);
		}
	}

	function OnNeverApprovedRestChange(event) {
		if (event.target.value != "") {
			var tid = event.target.id.substring(17);
			var a = parseFloat($("#rest" + tid).text());
			var b = parseFloat($("#neverApprovedRest" + tid).val());
			$("#approvedRest" + tid).val(a - b);
		}
	}

	function OnBalance(tid) {
		var a = parseFloat($("#lastMonthTotal" + tid).val());
		var b = parseFloat($("#actualOverWorkTime" + tid).val());
		var c = parseFloat($("#approvedRest" + tid).val());
		var d = parseFloat($("#neverApprovedRest" + tid).val());
		var e = parseFloat($("#rest" + tid).text());
		var f = parseFloat($("#overWorkTime" + tid).text())+parseFloat($("#overWorkTime4H" + tid).text());
		
		var result = a + b - c - 3 * d;
		if(isNaN(result)){
			alert("请输入所有公式所要的数值");
			return;
		}else if(c>e || d>e){
			alert("请假输入值有误，请检查");
			return;
		}else if(b>f){
			alert("实际加班输入值有误，请检查");
			return;
		}
		$("#thisMonthTotal" + tid).val(result);

	}

	function getWorkTimeAdjustList() {
		mDate = $('#year').val() + "/" + $('#month').val();
		mDepartment = $('#departmentSel').val();
		arrayName = new Array();
		
		if($('#month').val()==1){
			lastMonth = ($('#year').val()-1)+"/12";
		}else{
			lastMonth = $('#year').val() + "/" + ($('#month').val()-1);
		}
		
		$
				.ajax({
					url : "${pageContext.request.contextPath}/workTimeAdjustList",
					type : 'GET',
					data : {
						"date" : mDate,
						"departmentId" : mDepartment
					},
					cache : false,
					success : function(returndata) {
						var str = '';
						var str1;
						var str2;
						var str3;
						var str4;
						var str5;
						var str6;
						var str7;
						var str8;
						var str9;

						var data = eval("(" + returndata + ")").wtalist;
						for ( var i in data) {
							var overWorkTime = data[i].overWorkTime;
							if (overWorkTime != 0) {
								str1 = '<td style="width:9%;color:red;background:yellow" id="overWorkTime'
									    + i
									    + '"><strong>'
										+ overWorkTime + '</strong></td>'
							} else {
								str1 = '<td style="width:9%" id="overWorkTime'
									 + i
									 + '"><strong>'
									 + overWorkTime + '</strong></td>'
							}

							var overWorkTime4H = data[i].overWorkTime4H;
							if (overWorkTime4H != 0) {
								str2 = '<td style="width:9%;color:red;background:yellow" id="overWorkTime4H'
									+ i
									+ '"><strong>'
									+ overWorkTime4H + '</strong></td>'
							} else {
								str2 = '<td style="width:9%" id="overWorkTime4H'
									+ i
									+ '"><strong>'
									+ overWorkTime4H + '</strong></td>'
							}

							var rest = data[i].rest;
							if (rest != 0) {
								str3 = '<td style="width:9%;color:red;background:yellow" id="rest'
										+ i
										+ '"><strong>'
										+ rest
										+ '</strong></td>'
							} else {
								str3 = '<td style="width:9%" id="rest' + i
										+ '"><strong>' + rest
										+ '</strong></td>'
							}

						   var lastMonthTotalVal = getLastMonthTotal(
									data[i].name, lastMonth); 
                           if(lastMonthTotalVal==-1){
                            	//没找到
                        	   str4 = '<td style="width:9%;"><input type="text" id="lastMonthTotal'+ i
									 + '" style="font-weight:bold;width:98%;border: 0px;" placeholder="请输入" oninput="OnLastMonthTotalChange(event)"/></td>'
                            }else{
                            	str4 = '<td style="width:9%;"><input type="text" value="'+ lastMonthTotalVal +'" disabled="disabled" id="lastMonthTotal'+ i
								 + '" style="font-weight:bold;width:98%;border: 0px;" placeholder="请输入" oninput="OnLastMonthTotalChange(event)"/></td>'
                            } 
                            
                           var ThisMonthTotalVal = getThisMonthTotal(data[i].name, mDate)[3];
                           if(ThisMonthTotalVal==-1){
                           	//没找到
                       	        str5 ='<td style="width:9%;"><input type="text" id="thisMonthTotal'
								+ i
								+ '" style="font-weight:bold;width:98%;border: 0px;" disabled="disabled"/></td>'
							}else{
                        	   str5 ='<td style="width:9%;"><input type="text" id="thisMonthTotal'
   								+ i
   								+ '" style="font-weight:bold;width:98%;border: 0px;" disabled="disabled" value="'+ ThisMonthTotalVal +'"/></td>'
                           } 
                           
                           var actualOverWorkTimeVal = getThisMonthTotal(data[i].name, mDate)[0];
                           if(actualOverWorkTimeVal==-1){
                        	  
                           	//没找到
                       	        str6 ='<td style="width:9%;"><input type="text" id="actualOverWorkTime'
								+ i
								+ '" style="font-weight:bold;width:98%;border: 0px;" placeholder="请输入"/></td>'
                           }else{
                        	   str6 ='<td style="width:9%;"><input type="text" id="actualOverWorkTime'
   								+ i
   								+ '" style="font-weight:bold;width:98%;border: 0px;" placeholder="请输入" value="'+ actualOverWorkTimeVal +'"/></td>'
                               
                           } 
                           
                           var actualOverWorkTimeVal4H = getThisMonthTotal(data[i].name, mDate)[1];
                           if(actualOverWorkTimeVal4H==-1){
                           	//没找到
                       	        str7 ='<td style="width:9%;"><input type="text" id="actualOverWorkTime4H'
								+ i
								+ '" style="font-weight:bold;width:98%;border: 0px;" placeholder="请输入"/></td>'
                           }else{
                        	    str7 ='<td style="width:9%;"><input type="text" id="actualOverWorkTime4H'
								+ i
								+ '" style="font-weight:bold;width:98%;border: 0px;" placeholder="请输入" value="'+ actualOverWorkTimeVal4H +'"/></td>'
                           } 
                           
                           var approvedRestVal = getThisMonthTotal(data[i].name, mDate)[2];
                           if(approvedRestVal==-1){
                           	//没找到
                       	        str8 ='<td style="width:9%;"><input type="text" id="approvedRest'
								+ i
								+ '" style="font-weight:bold;width:98%;border: 0px;" placeholder="请输入" oninput="OnApprovedRestChange(event)" /></td>';
								
								str9 = '<td style="width:9%;"><input type="text" id="neverApprovedRest'
								+ i
								+ '" style="color:red;font-weight:bold;width:98%;border: 0px;" placeholder="请输入" oninput="OnNeverApprovedRestChange(event)"/></td>'
                           }else{
                        	    str8 ='<td style="width:9%;"><input type="text" id="approvedRest'
    								+ i
    								+ '" style="font-weight:bold;width:98%;border: 0px;" placeholder="请输入" oninput="OnApprovedRestChange(event)" value="'+ approvedRestVal +'"/></td>';
    							var dd = data[i].rest - approvedRestVal;
    							str9 = '<td style="width:9%;"><input type="text" id="neverApprovedRest'
								+ i
								+ '" style="color:red;font-weight:bold;width:98%;border: 0px;" placeholder="请输入" oninput="OnNeverApprovedRestChange(event)" value="'+ dd +'"/></td>'
                           }
							
                            arrayName.push(data[i].name);
							str += '<tr style="color: #000;width: 100%;">'
									+ '<td style="width:9%;"><strong>'
									+ data[i].name
									+ '</strong></td>'
									+ str1
									+ str2
									+ str6
									/* + '<td style="width:9%;"><input type="text" id="actualOverWorkTime'
									+ i
									+ '" style="font-weight:bold;width:98%;border: 0px;" placeholder="请输入"/></td>' */
									/* + '<td style="width:9%;"><input type="text" id="actualOverWorkTime4H'
									+ i
									+ '" style="font-weight:bold;width:98%;border: 0px;" placeholder="请输入"/></td>' */
									+ str7
									+ str3
									/* + '<td style="width:9%;"><input type="text" id="approvedRest'
									+ i
									+ '" style="font-weight:bold;width:98%;border: 0px;" placeholder="请输入" oninput="OnApprovedRestChange(event)" /></td>' */
									+ str8
									/* + '<td style="width:9%;"><input type="text" id="neverApprovedRest'
									+ i
									+ '" style="color:red;font-weight:bold;width:98%;border: 0px;" placeholder="请输入" oninput="OnNeverApprovedRestChange(event)"/></td>' */
									+ str9
									+ str4
									/* + '<td style="width:9%;"><input type="text" id="thisMonthTotal'
									+ i
									+ '" style="font-weight:bold;width:98%;border: 0px;" disabled="disabled"/></td>' */
									+ str5
									+ '<td style="width:9%;">'
									+ '<input type="button" value="结算" style="height:20px" onclick="OnBalance('+ i + ')" />'
									+ '<input type="button" value="确认" style="margin-left:10px;height:20px;" onclick="save( '+ i + ')"/>'
									+ '</td></tr>';

						}
						$("#tb").empty();
						$("#tb").append(str);
					},
					error : function(XMLHttpRequest, textStatus, errorThrown) {
					}
				});
	}

	function getLastMonthTotal(uName, date) {
		var returnVal;
		$.ajax({
			url : "${pageContext.request.contextPath}/getLastMonthTotal",
			type : 'GET',
			async : false,
			data : {
				"date" : date,
				"name" : uName
			},
			cache : false,
			success : function(returndata) {
				returnVal = eval("(" + returndata + ")").lmt;
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
		return returnVal;
	}
	
	function getThisMonthTotal(uName, date){
		var arrayThisMonthTotal = new Array();
		$.ajax({
			url : "${pageContext.request.contextPath}/getThisMonthTotal",
			type : 'GET',
			async : false,
			data : {
				"date" : date,
				"name" : uName
			},
			cache : false,
			success : function(returndata) {
			    arrayThisMonthTotal.push(eval("(" + returndata + ")").actualOverWorkTime);
				arrayThisMonthTotal.push(eval("(" + returndata + ")").actualOverWorkTime4H);
				arrayThisMonthTotal.push(eval("(" + returndata + ")").approvedRest);
				arrayThisMonthTotal.push(eval("(" + returndata + ")").thisMonthTotal);
				
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
		
		return arrayThisMonthTotal;
	}
	
	function save(a){
		var actualOverWorkTime = $("#actualOverWorkTime" + a).val();
		var actualOverWorkTime4H = $("#actualOverWorkTime4H" + a).val();
		var approvedRest = $("#approvedRest" + a).val();
		var lastMonthTotal = $("#lastMonthTotal" + a).val();
		var thisMonthTotal = $("#thisMonthTotal" + a).val();
		var name = arrayName[a];
		var date = mDate;
		if(thisMonthTotal == ""){
			alert("请先结算");
			return;
        }
		
		$.ajax({
			url : "${pageContext.request.contextPath}/updateWorkTimeAdjust",
			type : 'POST',
			cache : false,
			data : {
				"name" : name,
				"date" : date,
				"actualOverWorkTime4H" : actualOverWorkTime4H,
				"actualOverWorkTime" : actualOverWorkTime,
				"approvedRest" : approvedRest,
				"lastMonthTotal" : lastMonthTotal,
				"thisMonthTotal" : thisMonthTotal
			},
			success : function(returndata) {
				var data = eval("(" + returndata + ")").errcode;
				if (data == 0) {
					alert("更新成功");
				} else {
					alert("更新失败");
				}
            },
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
	}

	function queryList() {
		getWorkTimeAdjustList();
	}

	function printTable() {
		$("#div1").jqprint();
	}

	function outputExcelTable() {
		var tr1 = $("#tb2 tr:eq(0)");
		tr1.appendTo("#outTb");
		for (var i = 0; i < document.getElementById("tb").rows.length; i++) {
			var tr2 = $("#tb tr").eq(i).clone();
			tr2.appendTo("#outTb");
		}
		new ExcelGen({
			"src_id" : "outTb"
		}).generate();
		// window.location.reload();
		getReportList();
	}
</script>
</head>
<body>

	<div style="width: 100%; height: 30px">


		<div style="float: left; margin-left: 10px;" id="x2">
			<select id="departmentSel" onchange="selDpart()" style="width: 80px">
				<option value="0">所有部门</option>
				<option value="1">技术部</option>
				<option value="2">销售部</option>
				<option value="3">行政部</option>
				<option value="4">研发部</option>
			</select> <select id="year" style="width: 80px">
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
			</select> <select id="month" style="width: 80px">
				<option value="1">1月</option>
				<option value="2">2月</option>
				<option value="3">3月</option>
				<option value="4">4月</option>
				<option value="5">5月</option>
				<option value="6">6月</option>
				<option value="7">7月</option>
				<option value="8">8月</option>
				<option value="9">9月</option>
				<option value="10">10月</option>
				<option value="11">11月</option>
				<option value="12">12月</option>
			</select>
		</div>

		<div style="float: left; margin-left: 10px; width: 10%;">
			<input type="button" value="查询" onclick="queryList()" />
		</div>

		<div style="float: left; margin-left: 10px;">
			<a style="color: red">公式：本月调休结余 = 上月调休剩余 + 加班&lt;4H(实际) - 请假(已批准) -
				3*请假(未批准)</a>
		</div>

		<div style="float: right; margin-right: 20px;">
			<input type="button" value="导出excel表格" onclick="outputExcelTable()" />
		</div>

		<div style="float: right; margin-right: 20px;">
			<input type="button" value="打印" onclick="printTable()" />
		</div>
	</div>



	<form id="form1">
		<div id="div1"
			style="background-color: #39A4DA; padding: 5px; border-radius: 5px 5px 5px 5px; color: #fff; text-align: center; font-size: 12px">

			<table id="tb2"
				style="width: 100%; text-align: center; text-size: 10px; table-layout: fixed">
				<tr style="width: 100%;" id="tr1">
					<td style="width: 9%;"><strong>姓名</strong></td>
					<td style="width: 9%;"><strong>加班&lt;4H(自动)</strong></td>
					<td style="width: 9%;"><strong>加班&gt;4H(自动)</strong></td>
					<td style="width: 9%"><strong>加班&lt;4H(实际)</strong></td>
					<td style="width: 9%"><strong>加班&gt;4H(实际)</strong></td>
					<td style="width: 9%"><strong>请假(自动)</strong></td>
					<td style="width: 9%"><strong>请假(已批准)</strong></td>
					<td style="width: 9%"><strong>请假(未批准)</strong></td>
					<td style="width: 9%"><strong>上月调休剩余</strong></td>
					<td style="width: 9%"><strong>本月调休结余</strong></td>
					<td style="width: 9%"></td>

				</tr>
			</table>
			<table
				style="width: 100%; background: #fff; border-collapse: collapse; border-spacing: 0; margin: 0; padding: 0; text-align: center; table-layout: fixed"
				id="tb" border="1">
			</table>
			<table id="outTb" style="display: none"></table>
		</div>
	</form>
</body>
</html>