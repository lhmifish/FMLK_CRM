function post(mUrl,params,mTraditional){
	requestReturn = {}
	$.ajax({
		url : host + "/"+mUrl,
		type : 'POST',
		cache : false,
		async : false,
		dataType : "json",
		data : params,
		traditional : mTraditional,
		success : function(returndata) {
			requestReturn.result = "success";
			requestReturn.data = returndata;
			requestReturn.code = returndata.errcode;
		},
		error : function(XMLHttpRequest, textStatus) {
			requestReturn.result = "error";
			requestReturn.error = XMLHttpRequest.responseText;
		}
	});
}

function get(mUrl,params,mTraditional){
	requestReturn = {}
	$.ajax({
		url : host + "/"+mUrl,
		type : 'GET',
		cache : false,
		async : false,
		dataType : "json",
		data : params,
		traditional : mTraditional,
		success : function(returndata) {
			requestReturn.result = "success";
			requestReturn.data = returndata;
			requestReturn.code = returndata.errcode;
		},
		error : function(XMLHttpRequest, textStatus, errorThrown) {
			requestReturn.result = "error";
			requestReturn.error = XMLHttpRequest.responseText;
		}
	});
}