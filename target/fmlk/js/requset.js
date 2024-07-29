function post(mUrl,params,mTraditional){
	var ret = {}
	$.ajax({
		url : host + "/"+mUrl,
		type : 'POST',
		cache : false,
		dataType : "json",
		data : params,
		traditional : mTraditional,
		success : function(returndata) {
			ret.code = returndata.errcode;
		},
		error : function(XMLHttpRequest, textStatus) {
			ret.error = XMLHttpRequest.responseText;
		},
		complete:function(XMLHttpRequest,textStatus){  
			return ret
		}
	});
}