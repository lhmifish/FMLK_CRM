/*获取用户信息*/
function getUser(paramsName,paramsValue){
	var user;
	if(paramsName=="nickName"){
		get("getUserByNickName",{nickName : paramsValue},false);
	}else if(paramsName=="uId"){
		get("getUserById",{uId : paramsValue},false);
	}
	if(requestReturn.result == "error"){
		alert(requestReturn.error);
	}else{
		user = requestReturn.data.user[0];
	}
	return user;
}

/*获取行业信息*/
function getField(paramsName,paramsValue){
	var field;
	if(paramsName=="fieldId"){
		get("getClientField",{fieldId : paramsValue},false);
	}
	if(requestReturn.result == "error"){
		alert(requestReturn.error);
	}else{
		field = requestReturn.data.clientField[0];
	}
	return field;
}

/*获取地区信息*/
function getArea(paramsName,paramsValue){
	var area;
	if(paramsName=="areaId"){
		get("getArea",{areaId : paramsValue},false);
	}
	if(requestReturn.result == "error"){
		alert(requestReturn.error);
	}else{
		area = requestReturn.data.area[0];
	}
	return area;
}

/*获取项目信息*/
function getProject(paramsName,paramsValue){
	var project;
	if(paramsName=="projectId"){
		get("getProjectByProjectId",{projectId : paramsValue},false);
	}else if(paramsName=="id"){
		get("getProject",{id : paramsValue},false);
	}
	if(requestReturn.result == "error"){
		alert(requestReturn.error);
	}else{
		project = requestReturn.data.project[0];
	}
	return project;
}

/*获取客户信息*/
function getCompany(paramsName,paramsValue) {
	var company;
	if(paramsName=="companyId"){
		get("getCompanyByCompanyId",{companyId : paramsValue},false);
	}else if(paramsName=="id"){
		get("getCompanyById",{id : paramsValue},false);
	}else if(paramsName=="projectId"){
		get("getCompanyByProjectId",{projectId : paramsValue},false);
	}
	if(requestReturn.result == "error"){
		alert(requestReturn.error);
	}else{
		company = requestReturn.data.company[0];
	}
	return company;
}

/*获取客户级别*/
function getFieldLevel(paramsName,paramsValue){
	var mFieldLevel;
	if(paramsName=="levelId"){
		get("getFieldLevel",{levelId : paramsValue},false);
	}
	if(requestReturn.result == "error"){
		alert(requestReturn.error);
	}else{
		mFieldLevel = requestReturn.data.fieldLevel[0];
	}
	return mFieldLevel;
}

/*获取派工类型*/
function getCaseType(paramsName,paramsValue){
	var mCaseType;
	if(paramsName=="typeId"){
		get("getCaseTypeByTypeId",{typeId : paramsValue},false);
	}
	if(requestReturn.result == "error"){
		alert(requestReturn.error);
	}else{
		mCaseType = requestReturn.data.caseType[0];
	}
	return mCaseType;
}