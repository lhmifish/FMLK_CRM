
function changePsd(mUid, mNickName,mHost) {
	var oldpsd = $("#oldPsd").val().trim();
	var newpsd = $("#newPsd").val().trim();
	if (oldpsd == "" || newpsd == "") {
		alert("新旧密码都不能为空");
		return;
	} else if (newpsd == oldpsd) {
		alert("新旧密码不能相同");
		return;
	} else if (newpsd.length < 6) {
		alert("新密码不能少于6位");
		return;
	}

	var data = new FormData();
	data.append("oldpsd", oldpsd);
	data.append("newpsd", newpsd);
	data.append("nickName", mNickName);
	data.append("uId", mUid);
	var xhr = createxmlHttpRequest();
	xhr.open("POST", mHost + "/checkAndUpdateUserPsd", true);
	xhr.addEventListener("readystatechange", function() {
		if (this.readyState === 4) {
			var data = eval("(" + xhr.responseText + ")").errcode;
			if (data == 0) {
				alert("修改密码成功,请重新登入");
				setTimeout(function() {
					$(".banDel").hide();
					parent.location.href = mHost + "/page/login";
				}, 500);
			} else if (data == 2) {
				alert("旧密码输入错误,请重新输入");
				$("#oldPsd").val("");
			} else {
				alert("修改密码错误");
			}
		}

	});
	xhr.send(data);
}

function closeConfirmBox() {
	$(".banDel").hide();
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