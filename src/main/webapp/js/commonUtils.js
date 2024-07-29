function toIndexPage() {
	window.location.href = host + "/page/techJobList";
}

function toBackPage() {
	window.history.back();
}

function toReloadPage() {
	window.location.reload();
}

function toErrorPage(){
	window.location.href = host + "/page/error";
}

function toCreateCompanyPage() {
	window.location.href = host + "/page/createCompany";
}

function toCompanyListPage() {
	window.location.href = host + "/page/companyList";
}

function toEditCompanyPage(companyId) {
	window.location.href = host + "/page/editCompany/"+companyId;
}

function toCreateProjectPage() {
	window.location.href = host + "/page/createProject";
}

function toProjectListPage() {
	window.location.href = host + "/page/projectList";
}

function toEditProjectPage(projectId) {
	window.location.href = host + "/page/editProject/"+projectId;
}

function toCreateProjectCasePage(){
	window.location.href = host + "/page/createProjectCase";
}

function toProjectCaseListPage(type){
	if(type==0){
		window.location.href = host + "/page/projectCaseList";
	}else if(type==1){
		window.location.href = host + "/page/checkProjectCase";
	}else{
		window.location.href = host + "/page/dispatchProjectCase";
	}
}


function toEditProjectCasePage(projectCaseId,type){
	window.location.href = host + "/page/editProjectCase/"+ type  +"/"+projectCaseId;
}


function toCreateTenderPage(){
	window.location.href = host + "/page/createTender";
}

function toTenderListPage(){
	window.location.href = host + "/page/tenderList";
}

function toEditTenderPage(tenderId){
	window.location.href = host + "/page/editTender/"+tenderId;
}

function toDailyArrangementList(){
	window.location.href = host + "/page/arrangementList";
}

function toEditContractPage(contractId){
	window.location.href = host + "/page/editContract/"+contractId;
}

function toCreateContractPage(){
	window.location.href = host + "/page/createContract";
}

function toContractListPage(){
	window.location.href = host + "/page/contractList";
}
