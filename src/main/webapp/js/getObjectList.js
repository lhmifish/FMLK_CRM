function getSalesList(mSalesId) {
	var today = formatDate(new Date()).substring(0, 10);
	var xhr = createxmlHttpRequest();
	xhr.open("GET", host + "/userList?date=" + today
			+ "&dpartId=2&name=&nickName=&jobId=&isHide=true", true);
	xhr.onreadystatechange = function() {
		if (this.readyState == 4) {
			var str = '<option value="0">请选择...</option>';
			var data = eval("(" + xhr.responseText + ")").userlist;
			for ( var i in data) {
				str += '<option value="' + data[i].UId + '">' + data[i].name
						+ '</option>';
			}
			$("#salesId").empty();
			$("#salesId").append(str);
			$("#salesId").find('option[value="' + mSalesId + '"]').attr(
					"selected", true);
		}
	};
	xhr.send();
}

function getFieldList(mFieldId) {
	var xhr = createxmlHttpRequest();
	xhr.open("GET", host + "/clientFieldList", true);
	xhr.onreadystatechange = function() {
		if (this.readyState == 4) {
			var str = '<option value="0">请选择...</option>';
			var data = eval("(" + xhr.responseText + ")").cflist;
			for ( var i in data) {
				str += '<option value="' + data[i].fieldId + '">'
						+ data[i].clientField + '</option>';
			}
			$("#fieldId").empty();
			$("#fieldId").append(str);
			$("#fieldId").find('option[value="' + mFieldId + '"]').attr(
					"selected", true);

		}
	};
	xhr.send();
}

function getAreaList(mAreaId) {
	var xhr = createxmlHttpRequest();
	xhr.open("GET", host + "/areaList", true);
	xhr.onreadystatechange = function() {
		if (this.readyState == 4) {
			var str = '<option value="0">请选择...</option>';
			var data = eval("(" + xhr.responseText + ")").alist;
			for ( var i in data) {
				str += '<option value="' + data[i].areaId + '">'
						+ data[i].areaName + '</option>';
			}
			$("#areaId").empty();
			$("#areaId").append(str);
			$("#areaId").find('option[value="' + mAreaId + '"]').attr(
					"selected", true);

		}
	};
	xhr.send();
}

function getCompanyList(mCompanyName, mSalesId, mId, mType) {
	var xhr = createxmlHttpRequest();
	xhr.open("GET", host + "/companyList?salesId=" + mSalesId + "&companyName="
			+ mCompanyName, true);
	xhr.onreadystatechange = function() {
		if (this.readyState == 4) {
			var str = '<option value="0">请选择...</option>';
			var data = eval("(" + xhr.responseText + ")").companylist;
			for ( var i in data) {
				if (mType == 0) {
					str += '<option value="' + data[i].id + '">'
							+ data[i].companyName + '</option>';
				} else if (mType == 1) {
					str += '<option value="' + data[i].companyId + '">'
							+ data[i].companyName + '</option>';
				}
			}
			$("#companyId").empty();
			$("#companyId").append(str);
			$("#companyId").find('option[value="' + mId + '"]').attr(
					"selected", true);
		}
	};
	xhr.send();
}

function getProjectTypeList(mProjectType) {
	var xhr = createxmlHttpRequest();
	xhr.open("GET", host + "/projectTypeList", true);
	xhr.onreadystatechange = function() {
		if (this.readyState == 4) {
			var str = '<option value="0">请选择...</option>';
			var data = eval("(" + xhr.responseText + ")").ptlist;
			for ( var i in data) {
				str += '<option value="' + data[i].id + '">' + data[i].typeName
						+ '</option>';
			}
			$("#projectType").empty();
			$("#projectType").append(str);
			$("#projectType").find('option[value="' + mProjectType + '"]')
					.attr("selected", true);
		}
	};
	xhr.send();
}

function getProjectManagerList(mProjectManager, mSalesBeforeUsersArr,
		mSalesAfterUsersArr) {
	var today = formatDate(new Date()).substring(0, 10);
	var xhr = createxmlHttpRequest();
	xhr.open("GET", host + "/userList?date=" + today
			+ "&dpartId=1&name=&nickName=&jobId=&isHide=true", true);
	xhr.onreadystatechange = function() {
		if (this.readyState == 4) {
			var str = '<option value="0">请选择...</option>';
			var str2 = '';
			var data = eval("(" + xhr.responseText + ")").userlist;
			for ( var i in data) {
				str2 += '<option value="' + data[i].UId + '">' + data[i].name
						+ '</option>';
			}
			$("#projectManager").empty();
			$("#projectManager").append(str + str2);
			$("#projectManager")
					.find('option[value="' + mProjectManager + '"]').attr(
							"selected", true);
			if (mSalesBeforeUsersArr != null) {
				$("#salesBeforeUsers").empty();
				$("#salesBeforeUsers").append(str2);
				$('#salesBeforeUsers').val(mSalesBeforeUsersArr).trigger(
						"change");
			}
			if (mSalesAfterUsersArr != null) {
				$("#salesAfterUsers").empty();
				$("#salesAfterUsers").append(str2);
				$('#salesAfterUsers').val(mSalesAfterUsersArr)
						.trigger("change");
			}
		}
	};
	xhr.send();
}

function getMultiContactUsersList(mCompanyId, mContactUsersArr) {
	var xhr = createxmlHttpRequest();
	xhr.open("GET", host + "/userContactList?companyId=" + mCompanyId, true);
	xhr.onreadystatechange = function() {
		if (this.readyState == 4) {
			var str = '';
			var data = eval("(" + xhr.responseText + ")").contactUserList;
			for ( var i in data) {
				str += '<option value="' + data[i].id + '">' + data[i].userName
						+ '</option>';
			}
			$("#contactUsers").empty();
			$("#contactUsers").append(str);
			if (mContactUsersArr != null) {
				$('#contactUsers').val(mContactUsersArr).trigger("change");
			}
		}
	};
	xhr.send();
}

function getProjectStateList(mProjectState) {
	var str = '<option value="0">售前服务</option><option value="1">售中服务</option>'
			+ '<option value="2">售后服务</option>'
			+ '<option value="3">项目结束关闭</option>'
			+ '<option value="4">项目失败关闭</option>';
	$("#projectState").empty();
	$("#projectState").append(str);
	$("#projectState").find('option[value="' + mProjectState + '"]').attr(
			"selected", true);
}

function getCaseTypeList(mCaseType) {
	var xhr = createxmlHttpRequest();
	xhr.open("GET", host + "/caseTypeList", true);
	xhr.onreadystatechange = function() {
		if (this.readyState == 4) {
			var str = '<option value="0">请选择...</option>';
			var data = eval("(" + xhr.responseText + ")").ctList;
			for ( var i in data) {
				str += '<option value="' + data[i].id + '">' + data[i].typeName
						+ '</option>';
			}
			$("#caseType").empty();
			$("#caseType").append(str);
			$("#caseType").find('option[value="' + mCaseType + '"]').attr(
					"selected", true);
		}
	};
	xhr.send();
}

function getProjectList(mCompanyId, mProjectId) {
	var xhr = createxmlHttpRequest();
	xhr.open("GET", host + "/projectList?companyId=" + mCompanyId
			+ "&projectName=&salesId=0&projectManager=0", true);
	xhr.onreadystatechange = function() {
		if (this.readyState == 4) {
			var str = '';
			var data = eval("(" + xhr.responseText + ")").projectList;
			for ( var i in data) {
				str += '<option value="' + data[i].projectId + '">'
						+ data[i].projectName + '</option>';
			}
			$("#projectId").empty();
			$("#projectId").append(str);
			$("#projectId").find('option[value="' + mProjectId + '"]').attr(
					"selected", true);
			changeProject();
		}
	};
	xhr.send();
}

function getServiceUsersList(mServiceUser) {
	var today = formatDate(new Date()).substring(0, 10);
	var xhr = createxmlHttpRequest();
	xhr.open("GET", host + "/userList?date=" + today
			+ "&dpartId=1&name=&nickName=&jobId=&isHide=true", true);
	xhr.onreadystatechange = function() {
		if (this.readyState == 4) {
			var str = '<option value="0">请选择...</option>';
			var data = eval("(" + xhr.responseText + ")").userlist;
			for ( var i in data) {
				str += '<option value="' + data[i].UId + '">' + data[i].name
						+ '</option>';
			}
			$("#serviceUsers").empty();
			$("#serviceUsers").append(str);
			$("#serviceUsers").find('option[value="' + mServiceUser + '"]')
					.attr("selected", true);
		}
	};
	xhr.send();
}

function getServiceTypeList(mServiceType) {
	var str = '<option value="0">请选择...</option><option value="1">一般</option>'
			+ '<option value="2">紧急</option>';
	$("#serviceType").empty();
	$("#serviceType").append(str);
	$("#serviceType").find('option[value="' + mServiceType + '"]').attr(
			"selected", true);
}

function getCasePeriodList(mCasePeriod) {
	var str = '<option value="0">请选择...</option><option value="0.5">半天</option>'
			+ '<option value="1">1天</option>'
			+ '<option value="2">2天</option>'
			+ '<option value="3">3天</option>'
			+ '<option value="4">4天</option>'
			+ '<option value="5">5天</option>'
			+ '<option value="6">6天</option>'
			+ '<option value="7">1周</option>'
			+ '<option value="8">8天</option>'
			+ '<option value="9">9天</option>'
			+ '<option value="10">10天</option>'
			+ '<option value="11">11天</option>'
			+ '<option value="12">12天</option>'
			+ '<option value="13">13天</option>'
			+ '<option value="14">2周</option>'
			+ '<option value="21">3周</option>'
			+ '<option value="30">1月</option>'
			+ '<option value="60">2月</option>'
			+ '<option value="90">3月</option>';
	$("#casePeriod").empty();
	$("#casePeriod").append(str);
	$("#casePeriod").find('option[value="' + mCasePeriod + '"]').attr(
			"selected", true);
}

function getProjectCaseUploadFile(mCaseId, mProjectId) {
	var xhr = createxmlHttpRequest();
	xhr.open("GET", host + "/projectReportList?projectId=" + mProjectId, true);
	xhr.onreadystatechange = function() {
		if (this.readyState == 4) {
			var str = '';
			var data = eval("(" + xhr.responseText + ")").prList;
			var mNum = 0;
			for ( var i in data) {
				var caseId = data[i].caseId;
				if (caseId == mCaseId) {
					mNum++;
					str += '<tr><td style="padding-left: 10px;text-align:left;border:none;height:20px">'
							+ '<a href="#" onclick="downloadFile(\''
							+ data[i].fileName
							+ '\',99,\''
							+ mProjectId
							+ '\')">' + data[i].fileName + '</a></td></tr>';
				}
			}
			if (mNum > 0) {
				$("#filelist").append(str);
				$("#upFileDiv").show();
			}

		}
	};
	xhr.send();
}

function getMultiServiceUsersList(mServiceUserArr) {
	var today = formatDate(new Date()).substring(0, 10);
	var xhr = createxmlHttpRequest();
	xhr.open("GET", host + "/userList?date=" + today
			+ "&dpartId=1&name=&nickName=&jobId=&isHide=true", true);
	xhr.onreadystatechange = function() {
		if (this.readyState == 4) {
			var str = '<option value="0">请选择...</option>';
			var data = eval("(" + xhr.responseText + ")").userlist;
			for ( var i in data) {
				str += '<option value="' + data[i].UId + '">' + data[i].name
						+ '</option>';
			}
			$("#serviceUsers").empty();
			$("#serviceUsers").append(str);
			if (mServiceUserArr != null) {
				$('#serviceUsers').val(mServiceUserArr).trigger("change");
			}
		}
	};
	xhr.send();
}

function getAgencyList(mAgency) {
	var xhr = createxmlHttpRequest();
	xhr.open("GET", host + "/agencyList", true);
	xhr.onreadystatechange = function() {
		if (this.readyState == 4) {
			var str = '<option value="0">请选择...</option>';
			var data = eval("(" + xhr.responseText + ")").agencylist;
			for ( var i in data) {
				str += '<option value="' + data[i].agencyId + '">'
						+ data[i].agencyName + '</option>';
			}
			$("#tenderAgency").empty();
			$("#tenderAgency").append(str);
			$("#tenderAgency").find('option[value="' + mAgency + '"]').attr(
					"selected", true);

		}
	};
	xhr.send();
}

function getTenderStyleList(mTenderStyle) {
	var xhr = createxmlHttpRequest();
	xhr.open("GET", host + "/tenderStyleList", true);
	xhr.onreadystatechange = function() {
		if (this.readyState == 4) {
			var str = '<option value="0">请选择...</option>';
			var data = eval("(" + xhr.responseText + ")").tslist;
			for ( var i in data) {
				str += '<option value="' + data[i].id + '">'
						+ data[i].styleName + '</option>';
			}
			$("#tenderStyle").empty();
			$("#tenderStyle").append(str);
			$("#tenderStyle").find('option[value="' + mTenderStyle + '"]')
					.attr("selected", true);
		}
	};
	xhr.send();
}

function getProductStyleList(mProductStyle) {
	var xhr = createxmlHttpRequest();
	xhr.open("GET", host + "/productStyleList", true);
	xhr.onreadystatechange = function() {
		if (this.readyState == 4) {
			var str = '<option value="0">请选择...</option>';
			var data = eval("(" + xhr.responseText + ")").pslist;
			for ( var i in data) {
				str += '<option value="' + data[i].id + '">'
						+ data[i].styleName + '</option>';
			}
			$("#productStyle").empty();
			$("#productStyle").append(str);
			$("#productStyle").find('option[value="' + mProductStyle + '"]')
					.attr("selected", true);
		}
	};
	xhr.send();
}

function getProductBrandList(mProductBrand) {
	var xhr = createxmlHttpRequest();
	xhr.open("GET", host + "/productBrandList", true);
	xhr.onreadystatechange = function() {
		if (this.readyState == 4) {
			var str = '<option value="0">请选择...</option>';
			var data = eval("(" + xhr.responseText + ")").pblist;
			for ( var i in data) {
				str += '<option value="' + data[i].id + '">'
						+ data[i].brandName + '</option>';
			}
			$("#productBrand").empty();
			$("#productBrand").append(str);
			$("#productBrand").find('option[value="' + mProductBrand + '"]')
					.attr("selected", true);
		}
	};
	xhr.send();
}

function getUnCheckedTenderList() {
	var num = 0;
	var today = formatDate(new Date()).substring(0, 10);
	var xhr = createxmlHttpRequest();
	xhr
			.open(
					"GET",
					host
							+ "/getTenderList?tenderStyle=0&tenderResult=0&tenderCompany=&tenderAgency=0"
							+ "&projectId=&saleUser=0&date1=2019/01/01&date2="
							+ today, true);
	xhr.onreadystatechange = function() {
		if (this.readyState == 4) {
			var data = eval("(" + xhr.responseText + ")").tenderlist;
			for ( var i in data) {
				if (data[i].tenderResult == 0) {
					num++;
				}
			}
			document.getElementById('p4_2').innerHTML = "标书信息管理";
			document.getElementById('p4_2').style.color = "black";
			if (num != 0) {
				document.getElementById('p4').innerHTML = "(" + num + ")";
				document.getElementById('p4_2').innerHTML += "  (" + num + ")";
				document.getElementById('p4_2').style.color = "red";
			}
		}
	};
	xhr.send();
}

function getUnInputContract() {
	var xhr = createxmlHttpRequest();
	xhr.open("GET", host + "/getTenderListUnInputContract", true);
	xhr.onreadystatechange = function() {
		if (this.readyState == 4) {
			var data = eval("(" + xhr.responseText + ")").tenderlist;
			document.getElementById('p5_1').innerHTML = "新建合同";
			document.getElementById('p5_1').style.color = "black";
			if (data.length != 0) {
				document.getElementById('p5').innerHTML = "(" + data.length
						+ ")";
				document.getElementById('p5_1').innerHTML += "  ("
						+ data.length + ")";
				document.getElementById('p5_1').style.color = "red";
			}
		}
	};
	xhr.send();
}

function getUnDispatchProjectCaseList(mUnPatch) {
	var num;
	var xhr = createxmlHttpRequest();
	xhr.open("GET", host + "/projectCaseUnPatchList?unPatch=" + mUnPatch, true);
	xhr.onreadystatechange = function() {
		if (this.readyState == 4) {
			var data = eval("(" + xhr.responseText + ")").pclist;
			num = data.length;
			if (mUnPatch == 0) {
				document.getElementById('p3_3_1').innerHTML = "销售审核";
				document.getElementById('p3_3_1').style.color = "black";
				if (num != 0) {
					document.getElementById('p3_3_1').innerHTML += "  (" + num
							+ ")";
					document.getElementById('p3_3_1').style.color = "red";
				}

			} else {
				document.getElementById('p3_3_2').innerHTML = "技术派工";
				document.getElementById('p3_3_2').style.color = "black";
				if (num != 0) {
					document.getElementById('p3_3_2').innerHTML += "  (" + num
							+ ")";
					document.getElementById('p3_3_2').style.color = "red";
				}
			}
			projectCaseNum += num;
			document.getElementById('p3_3').innerHTML = "派工单审核";
			if (projectCaseNum != 0) {
				document.getElementById('p3').innerHTML = "(" + projectCaseNum
						+ ")";
				document.getElementById('p3_3').innerHTML += "  ("
						+ projectCaseNum + ")";
				document.getElementById('p3_3').style.color = "red";
			}
		}
	};
	xhr.send();
}

function createxmlHttpRequest() {
	var xmlHttp;
	try {
		// Firefox, Opera 8.0+, Safari
		xmlHttp = new XMLHttpRequest();
	} catch (e) {
		// Internet Explorer
		try {
			xmlHttp = new ActiveXObject("Msxml2.XMLHTTP");
		} catch (e) {
			try {
				xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
			} catch (e) {
				alert("您的浏览器不支持AJAX！");
				return false;
			}
		}
	}
	return xmlHttp;
}

function getThisWeekList(mDateStr) {
	var str = '<option value="' + MonStr + '">' + MonStr + '</option>'
			+ '<option value="' + TuesStr + '">' + TuesStr + '</option>'
			+ '<option value="' + WedStr + '">' + WedStr + '</option>'
			+ '<option value="' + ThurStr + '">' + ThurStr + '</option>'
			+ '<option value="' + FriStr + '">' + FriStr + '</option>'
			+ '<option value="' + SatStr + '">' + SatStr + '</option>'
			+ '<option value="' + SunStr + '">' + SunStr + '</option>';
	$("#date").empty();
	$("#date").append(str);
	$("#date").find('option[value="' + mDateStr + '"]').attr("selected", true);
}

function getTimeList() {
	var str;
	for (var a = 0; a <= 23; a++) {
		if (a < 10) {
			str += '<option>0' + a + ':00</option>' + '<option>0' + a
					+ ':30</option>';
		} else {
			str += '<option>' + a + ':00</option>' + '<option>' + a
					+ ':30</option>';
		}
	}
	$("#time1").empty();
	$("#time2").empty();
	$("#time1").append(str);
	$("#time2").append(str);
	$("#time1").val("08:00");
	$("#time2").val("17:00");
}

function getCrmDailyReportList() {
	var str;
	var xhr = createxmlHttpRequest();
	xhr.open("GET", host + "/getDailyUploadReportList?userName=" + sId
			+ "&startDate=" + MonStr + "&endDate=" + SunStr, true);
	xhr.onreadystatechange = function() {
		if (this.readyState == 4) {
			var data = eval("(" + xhr.responseText + ")").dailyuploadreportlist;
			var num = data.length;
			if (num > 0) {
				for ( var i in data) {
					str += '<tr><td style="width: 14%;" class="tdColor2">'
							+ data[i].date
							+ '<br/>'
							+ data[i].time
							+ '</td><td style="width: 35%;" class="tdColor2">'
							+ getCompany(data[i].client).companyName
							+ '<br/>'
							+ getProject(data[i].crmNum).projectName
							+ '</td><td style="width: 45%;text-align: left; padding: 5px" class="tdColor2">'
							+ data[i].jobContent
							+ '</td><td style="width: 6%;" class="tdColor2">'
							+ '<img name="img_edit" title="编辑" style="vertical-align:middle" class="operation" src="../image/update.png" onclick="showEditDailyUploadProjectWin('
							+ data[i].id + ')"/></td></tr>';
				}
			} else {
				str += '<tr style="text-align: center;height:40px;"><td style="color:red;width:100%;" border=0>你没有填写本周日报</td></tr>';
			}
			$("#tb").empty();
			$("#tb").append(str);
		}
	};
	xhr.send();
}


function getProjectSubStateList(mProjectState,mProjectType,mProjectSubState) {
	var str;
	var xhr = createxmlHttpRequest();
	xhr.open("GET", host + "/projectSubStateList?projectState=" + mProjectState + "&projectType="
			+ mProjectType, true);
	xhr.onreadystatechange = function() {
		if (this.readyState == 4) {
			var data = eval("(" + xhr.responseText + ")").projectSubStateList;
			for ( var i in data) {
				str += '<option value="' + data[i].PId + '">'
							+ data[i].name + '</option>';
			}
			$("#projectSubState").empty();
			$("#projectSubState").append(str);
			$("#projectSubState").find('option[value="' + mProjectSubState + '"]').attr(
					"selected", true);
		}
	};
	xhr.send();
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