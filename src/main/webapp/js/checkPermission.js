function checkMenuPremission() {
	var xhr = createxmlHttpRequest();
	xhr.open("GET", host + "/getUserPermissionList?nickName=" + sId, true);
	xhr.onreadystatechange = function() {
		if (this.readyState == 4) {
			var data = eval("(" + xhr.responseText + ")").permissionSettingList;
			for ( var i in data) {
				if (data[i].permissionId == 1) {
					$('#line_company').show();
				} else if (data[i].permissionId == 11) {
					$('#line_project').show();
				} else if (data[i].permissionId == 21) {
					$('#line_projectCase').show();
				} else if (data[i].permissionId == 31) {
					$('#line_tender').show();
				} else if (data[i].permissionId == 41) {
					$('#line_contract').show();
				} else if (data[i].permissionId == 51) {
					$('#line_user').show();
				} else if (data[i].permissionId == 61) {
					$('#line_system').show();
				} else if (data[i].permissionId == 71) {
					$('#line_attence').show();
				}
			}
			initialPage();
		}
	};
	xhr.send();
}

function checkViewPremission(permissionViewId) {
	if (sId == null || sId == "") {
		parent.location.href = host + "/page/login";
	} else {
		isPermissionView = false;
		var xhr = createxmlHttpRequest();
		xhr.open("GET", host + "/getUserPermissionList?nickName=" + sId, true);
		xhr.onreadystatechange = function() {
			if (this.readyState == 4) {
				var data = eval("(" + xhr.responseText + ")").permissionSettingList;
				for ( var i in data) {
					if ((data[i].permissionId == permissionViewId)
							&& (permissionViewId != 0)) {
						isPermissionView = true;
						break;
					}
				}
				if (!isPermissionView) {
					window.location.href = host + "/page/error";
				} else {
					$('#body').show();
					initialPage();
				}
			}
		};
		xhr.send();
	}
}

function checkEditPremission(permissionEditId, permissionDeleteId) {
	if (sId == null || sId == "") {
		parent.location.href = host + "/page/login";
	} else {
		isPermissionEdit = false;
		isPermissionDelete = false;
		var xhr = createxmlHttpRequest();
		xhr.open("GET", host + "/getUserPermissionList?nickName=" + sId, true);
		xhr.onreadystatechange = function() {
			if (this.readyState == 4) {
				var data = eval("(" + xhr.responseText + ")").permissionSettingList;
				for ( var i in data) {
					if ((data[i].permissionId == permissionEditId)
							&& (permissionEditId != 0)) {
						isPermissionEdit = true;
					} else if ((data[i].permissionId == permissionDeleteId)
							&& (permissionDeleteId != 0)) {
						isPermissionDelete = true;
					}
				}
				initialPage();
			}
		};
		xhr.send();
	}
}

function checkEditPremission2(permissionEditId, permissionCheckId,
		permissionDispatchId) {
	if (sId == null || sId == "") {
		parent.location.href = host + "/page/login";
	} else {
		isPermissionEdit = false;
		isPermissionCheck = false;
		isPermissionDispatch = false;
		var xhr = createxmlHttpRequest();
		xhr.open("GET", host + "/getUserPermissionList?nickName=" + sId, true);
		xhr.onreadystatechange = function() {
			if (this.readyState == 4) {
				var data = eval("(" + xhr.responseText + ")").permissionSettingList;
				for ( var i in data) {
					if ((data[i].permissionId == permissionEditId)
							&& (type == 0)) {
						isPermissionEdit = true;
					} else if ((data[i].permissionId == permissionCheckId)
							&& (type == 1)) {
						isPermissionCheck = true;
					} else if ((data[i].permissionId == permissionDispatchId)
							&& (type == 2)) {
						isPermissionDispatch = true;
					}
				}
				initialPage();
			}
		};
		xhr.send();
	}
}

function matchUserPremission(objectArr) {
	if (objectArr.length > 0 && isPermissionEdit) {
		isPermissionEditArr = new Array();
		var xhr = createxmlHttpRequest();
		xhr.open("GET", host + "/getUserByNickName?nickName=" + sId, true);
		xhr.onreadystatechange = function() {
			if (this.readyState == 4) {
				var data = eval("(" + xhr.responseText + ")").user;
				var tId = data[0].UId;
				var tRoleId = data[0].roleId;
				var arrImg = document.getElementsByName("img_edit");
				for (var j = 0; j < arrImg.length; j++) {
					if (objectArr[j] == tId || tRoleId == 11) {
						isPermissionEditArr.push(true);
						arrImg[j].setAttribute("title", "编辑");
						document.getElementsByName("a_edit")[j].innerHTML = "编辑";
					} else {
						isPermissionEditArr.push(false);
					}
				}
			}
		};
		xhr.send();
	}
}

function matchEdit(object) {
	var xhr = createxmlHttpRequest();
	xhr.open("GET", host + "/getUserByNickName?nickName=" + sId, true);
	xhr.onreadystatechange = function() {
		if (this.readyState == 4) {
			var data = eval("(" + xhr.responseText + ")").user;
			var tId = data[0].UId;
			var tRoleId = data[0].roleId;
			if (salesId == tId || tRoleId == 11) {
				// 更新 isPermissionEdit
				isPermissionEdit = true;
				$('#operation').show();
				document.getElementById("span_title1").innerHTML = "编辑"
						+ object + "信息";
				document.getElementById("span_title2").innerHTML = "编辑"
						+ object + "信息";
			} else {
				isPermissionEdit = false;
				document.getElementById("span_title1").innerHTML = "查看"
						+ object + "信息";
				document.getElementById("span_title2").innerHTML = "查看"
						+ object + "信息";
			}

		}
	};
	xhr.send();
}

function matchEdit2(object) {
	var xhr = createxmlHttpRequest();
	xhr.open("GET", host + "/getUserByNickName?nickName=" + sId, true);
	xhr.onreadystatechange = function() {
		if (this.readyState == 4) {
			var data = eval("(" + xhr.responseText + ")").user;
			var tId = data[0].UId;
			var tRoleId = data[0].roleId;
			
			if(isPermissionCheck){
			    $('#operation').show();
				document.getElementById("span_title1").innerHTML = "销售审核";
				document.getElementById("span_title2").innerHTML = "销售审核";
				document.getElementById('okclick').innerHTML = "审核";
			}else if(isPermissionDispatch){
			    $('#operation').show();
				document.getElementById("span_title1").innerHTML = "技术派工";
				document.getElementById("span_title2").innerHTML = "技术派工";
				document.getElementById('okclick').innerHTML = "派工";
			}else if((salesId == tId || tRoleId == 11) && (checkResult != 2)){
				isPermissionEdit = true;
			    $('#operation').show();
				document.getElementById("span_title1").innerHTML = "编辑"
					+ object;
				document.getElementById("span_title2").innerHTML = "编辑"
					+ object;
			}else{
			    isPermissionEdit = false;
				document.getElementById("span_title1").innerHTML = "查看"
					+ object;
				document.getElementById("span_title2").innerHTML = "查看"
					+ object;
			}
		}
	};
	xhr.send();
}

function matchUpload() {
	var xhr = createxmlHttpRequest();
	xhr.open("GET", host + "/getUserByNickName?nickName=" + sId, true);
	xhr.onreadystatechange = function() {
		if (this.readyState == 4) {
			var data = eval("(" + xhr.responseText + ")").user;
			userId = data[0].UId;
			var tRoleId = data[0].roleId;
			isPermissionUpload = new Array();
			if (salesId == userId || tRoleId == 11) {
				isPermissionUpload.push(true);
			} else {
				isPermissionUpload.push(false);
			}

			var isFind = false;
			if (salesBeforeUsersArr.length > 0) {
				for (var i = 0; i < salesBeforeUsersArr.length; i++) {
					if (salesBeforeUsersArr[i] == userId || tRoleId == 11) {
						isFind = true;
						break;
					}
				}
			} else {
				if (tRoleId == 11) {
					isFind = true;
				}
			}

			if (isFind) {
				isPermissionUpload.push(true);
			} else {
				isPermissionUpload.push(false);
			}

			var isFind2 = false;
			if (salesAfterUsersArr.length > 0) {
				for (var i = 0; i < salesAfterUsersArr.length; i++) {
					if (salesAfterUsersArr[i] == userId || tRoleId == 11) {
						isFind2 = true;
						break;
					}
				}
			} else {
				if (tRoleId == 11) {
					isFind2 = true;
				}
			}

			if (isFind2) {
				isPermissionUpload.push(true);
			} else {
				isPermissionUpload.push(false);
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