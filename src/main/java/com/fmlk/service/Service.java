package com.fmlk.service;

import com.fmlk.dao.Dao;
import com.fmlk.entity.AssignmentOrder;
import com.fmlk.entity.Client;
import com.fmlk.entity.ClientDetailInfo;
import com.fmlk.entity.Contract;
import com.fmlk.entity.DailyArrangement;
import com.fmlk.entity.DailyReport;
import com.fmlk.entity.DailyUploadReport;
import com.fmlk.entity.JobPosition;
import com.fmlk.entity.MonthReport;
import com.fmlk.entity.PermissionSetting;
import com.fmlk.entity.Role;
import com.fmlk.entity.Tender;
import com.fmlk.entity.VisitRecord;
import com.fmlk.entity.WechatCheck;
import com.fmlk.entity.WeekUploadReport;
import com.fmlk.entity.WorkTimeAdjust;

public class Service {

	private Dao dao = null;

	public boolean add(DailyReport dp) {
		dao = new Dao();
		return dao.add(dp);
	}

	public String getMonthList(String month, int dept) {
		dao = new Dao();
		return dao.getMonthList(month, dept);
	}

	public String getDailyList(String date) {
		dao = new Dao();
		return dao.getDailyList(date);
	}

	// name 真实姓名 卢海明
	public String getDailyList(String name, String date) {
		dao = new Dao();
		return dao.getDailyList(name, date);
	}

	public String getAgencyList() {
		dao = new Dao();
		return dao.getAgencyList();
	}

	// name 拼音姓名lu.haiming
	public String getDailyList2(String name, String date) {
		dao = new Dao();
		return dao.getDailyList2(name, date);
	}

	public String getWechatCheckList(String date, int dept) {
		dao = new Dao();
		return dao.getWechatCheckList(date, dept);
	}

	public String getCardCheckList(String date, int dept) {
		dao = new Dao();
		return dao.getCardCheckList(date, dept);
	}

	public String getAllCheckList(String date, int dept) {
		dao = new Dao();
		return dao.getAllCheckList(date, dept);
	}

	public String getWechatUserList(String date) {
		dao = new Dao();
		return dao.getWechatUserList(date);
	}
	//////////////////////////////////////////////

	public String getCheckList(String date) {
		dao = new Dao();
		return dao.getCheckList(date);
	}

	public String getCheckErrorList(String date) {
		dao = new Dao();
		return dao.getCheckErrorList(date);
	}

	public String checkUpdate(int state, int checkId) {
		dao = new Dao();
		return dao.checkUpdate(state, checkId);
	}

	public WechatCheck getWechatCheck(int checkId) {
		dao = new Dao();
		return dao.getWechatCheck(checkId);
	}

	public String getStatisticsList(String month, int dept) {
		dao = new Dao();
		return dao.getStatisticsList(month, dept);
	}

	public String getWeekPlanDetails(String startDate, String endDate) {
		dao = new Dao();
		return dao.getWeekPlanDetails(startDate, endDate);
	}

	public String getClientCompany() {
		dao = new Dao();
		return dao.getClientCompany();
	}

	public String getProjectList(String companyId) {
		dao = new Dao();
		return dao.getProjectList(companyId);
	}

	public String getContactList(String companyId) {
		dao = new Dao();
		return dao.getContactList(companyId);
	}

	public String createNewAssignment(AssignmentOrder ao) {
		dao = new Dao();
		return dao.createNewAssignment(ao);
	}

	public String getAssignmentList() {
		dao = new Dao();
		return dao.getAssignmentList();
	}

	public String getAssignmentList(String saleUser, String techUser, String clientCompany) {
		dao = new Dao();
		return dao.getAssignmentList(saleUser, techUser, clientCompany);
	}

	public String getAssignment(String sId) {
		dao = new Dao();
		return dao.getAssignment(sId);
	}

	public String editAssignment(AssignmentOrder ao) {
		dao = new Dao();
		return dao.editAssignment(ao);
	}

	public String getMoreAssignmentList(int type) {
		dao = new Dao();
		return dao.getMoreAssignmentList(type);
	}

	public String getMoreAssignmentList(int type, String saleUser, String techUser, String clientCompany) {
		dao = new Dao();
		return dao.getMoreAssignmentList(type, saleUser, techUser, clientCompany);
	}

	public String autoUpdateAssignment() {
		dao = new Dao();
		return dao.autoUpdateAssignment();
	}

	public String getStartJobAssignmentList() {
		dao = new Dao();
		return dao.getStartJobAssignmentList();
	}

	public String getOverTimeAssignmentList() {
		dao = new Dao();
		return dao.getOverTimeAssignmentList();
	}

	public String getDeadLineAssignmentList() {
		dao = new Dao();
		return dao.getDeadLineAssignmentList();
	}

	public String getDataSourceAssignmentList() {
		dao = new Dao();
		return dao.getDataSourceAssignmentList();
	}

	public String getOverDateAssignment() {
		dao = new Dao();
		return dao.getOverDateAssignment();
	}

	public String createDailyUploadReport(DailyUploadReport dur) {
		dao = new Dao();
		return dao.createDailyUploadReport(dur);
	}

	public String getDailyUploadReportList(String nickName) {
		dao = new Dao();
		return dao.getDailyUploadReportList(nickName);
	}

	public String getDailyUploadReport(int id) {
		dao = new Dao();
		return dao.getDailyUploadReport(id);
	}

	public String editDailyUploadReport(DailyUploadReport dur) {
		dao = new Dao();
		return dao.editDailyUploadReport(dur);
	}

	public String createDailyArrangement(DailyArrangement da) {
		dao = new Dao();
		return dao.createDailyUploadReport(da);
	}

	

	public String getAllDailyUploadReportList(String date) {
		dao = new Dao();
		return dao.getAllDailyUploadReportList(date);
	}

	public String getArrangement(int id) {
		dao = new Dao();
		return dao.getArrangement(id);
	}

	public String editArrangement(DailyArrangement da) {
		dao = new Dao();
		return dao.editArrangement(da);
	}

	public String getProjectName(String crmNum) {
		dao = new Dao();
		return dao.getProjectName(crmNum);
	}

	public String getOtherInfo(String userName, String startDate, String endDate, String startDate2, String endDate2) {
		dao = new Dao();
		return dao.getOtherInfo(userName, startDate, endDate, startDate2, endDate2);
	}

	public String createWeekReport(WeekUploadReport wur) {
		dao = new Dao();
		return dao.createWeekReport(wur);
	}

	public String getAllWeekUploadReportList(String startDate, String endDate) {
		dao = new Dao();
		return dao.getAllWeekUploadReportList(startDate, endDate);
	}
	
	public String getSalesWeekUploadReportList(String startDate, String endDate) {
		dao = new Dao();
		return dao.getSalesWeekUploadReportList(startDate, endDate);
	}
	
	public String getUserYearUploadReportList(int year,String userNickName) {
		dao = new Dao();
		return dao.getUserYearUploadReportList(year, userNickName);
	}

	public String getDailyUploadReportList(String userName, String startDate, String endDate) {
		dao = new Dao();
		return dao.getDailyUploadReportList(userName, startDate, endDate);
	}

	public String getWeekUploadReport(String userName, String startDate, String endDate) {
		dao = new Dao();
		return dao.getWeekUploadReport(userName, startDate, endDate);
	}

	public String getWeekUploadReport(int id) {
		dao = new Dao();
		return dao.getWeekUploadReport(id);
	}

	public String editWeekUploadReport(WeekUploadReport wur) {
		dao = new Dao();
		return dao.editWeekUploadReport(wur);
	}

	public String getWorkTimeAdjustList(String date, int dept) {
		dao = new Dao();
		return dao.getWorkTimeAdjustList(date, dept);
	}

	public String getLastMonthTotal(String name, String date) {
		dao = new Dao();
		return dao.getLastMonthTotal(name, date);
	}

	public String updateWorkTimeAdjust(WorkTimeAdjust wta) {
		dao = new Dao();
		return dao.updateWorkTimeAdjust(wta);
	}

	public String getThisMonthTotal(String name, String date) {
		dao = new Dao();
		return dao.getThisMonthTotal(name, date);
	}

	public String confirmTender(Tender tender) {
		dao = new Dao();
		return dao.confirmTender(tender);
	}

	public String createAgency(String agencyName) {
		dao = new Dao();
		return dao.createAgency(agencyName);
	}

	public String getClientFieldList() {
		dao = new Dao();
		return dao.getClientFieldList();
	}

	public String getAreaList() {
		dao = new Dao();
		return dao.getAreaList();
	}

	public String getFieldLevelList() {
		dao = new Dao();
		return dao.getFieldLevelList();
	}

	public String getClientField(int fieldId) {
		dao = new Dao();
		return dao.getClientField(fieldId);
	}

	public String getArea(int areaId) {
		dao = new Dao();
		return dao.getArea(areaId);
	}

	public String getUserName(String nickName) {
		dao = new Dao();
		return dao.getUserName(nickName);
	}

	public String getTenderStyleList() {
		dao = new Dao();
		return dao.getTenderStyleList();
	}

	public String getProductStyleList(boolean isFmlkShare) {
		dao = new Dao();
		return dao.getProductStyleList(isFmlkShare);
	}

	public String getProductBrandList() {
		dao = new Dao();
		return dao.getProductBrandList();
	}

	public String getProjectTypeList(boolean isFmlkShare) {
		dao = new Dao();
		return dao.getProjectTypeList(isFmlkShare);
	}

	public String getCaseTypeList() {
		dao = new Dao();
		return dao.getCaseTypeList();
	}

	public String getDepartmentList() {
		dao = new Dao();
		return dao.getDepartmentList();
	}

	public String getRoleList() {
		dao = new Dao();
		return dao.getRoleList();
	}

	public String createRole(Role role) {
		dao = new Dao();
		return dao.createRole(role);
	}

	public String editRole(Role role) {
		dao = new Dao();
		return dao.editRole(role);
	}

	public String getRolePermissionList() {
		dao = new Dao();
		return dao.getRolePermissionList();
	}

	public String getPermissionSettingList(PermissionSetting ps) {
		dao = new Dao();
		return dao.getPermissionSettingList(ps);
	}

	public String createPermissionSetting(PermissionSetting ps) {
		dao = new Dao();
		return dao.createPermissionSetting(ps);
	}

	public String editPermissionSetting(PermissionSetting ps) {
		dao = new Dao();
		return dao.editPermissionSetting(ps);
	}

	public String getUserPermissionListByNickName(String nickName) {
		dao = new Dao();
		return dao.getUserPermissionListByNickName(nickName);
	}

	public String getUserWorkAttendanceList(String date, String nickName) {
		dao = new Dao();
		return dao.getUserWorkAttendanceList(date,nickName);
	}
	
	public String getUserWorkAttendanceList(String date) {
		dao = new Dao();
		return dao.getUserWorkAttendanceList(date);
	}


	public String getUserMonthReportList(String year, String nickName) {
		dao = new Dao();
		return dao.getUserMonthReportList(year,nickName);
	}
	
	public String getUserMonthReportList(String date) {
		dao = new Dao();
		return dao.getUserMonthReportList(date);
	}

	public String getMonthAccumulateData(String date, String nickName) {
		dao = new Dao();
		return dao.getMonthAccumulateData(date,nickName);
	}

	public String editWorkAttendance(DailyReport dr) {
		dao = new Dao();
		return dao.editWorkAttendance(dr);
	}

	public String queryMonthAccumulateData(MonthReport mr) {
		dao = new Dao();
		return dao.queryMonthAccumulateData(mr);
	}

	public String createWorkAttendance(DailyReport dr) {
		dao = new Dao();
		return dao.createWorkAttendance(dr);
	}

	public String deletePosition(int id) {
		dao = new Dao();
		return dao.deletePosition(id);
	}

	public String editPosition(JobPosition jp) {
		dao = new Dao();
		return dao.editPosition(jp);
	}

	public String createPosition(JobPosition jp) {
		dao = new Dao();
		return dao.createPosition(jp);
	}

	public String getCompanyInfo() {
		dao = new Dao();
		return dao.getCompanyInfo();
	}

	public String editCompanyInfo(String address, String tel, String mail) {
		dao = new Dao();
		return dao.editCompanyInfo(address,tel,mail);
	}

	public String deleteWorkAttendance(String date) {
		dao = new Dao();
		return dao.deleteWorkAttendance(date);
	}

	public String getClientList() {
		dao = new Dao();
		return dao.getClientList();
	}

	public String editCooperateClient(Client c, int opt) {
		dao = new Dao();
		if(opt==1) {
			//添加
			return dao.checkCooperateClient(c);
		}else {
			return dao.deleteCooperateClient(c);
		}
	}
	
	public boolean clearCooperateClient() {
		dao = new Dao();
		return dao.clearCooperateClient();
	}
	
	public String getProductStyle(int productId) {
		dao = new Dao();
		return dao.getProductStyle(productId);
	}
	
	public String getFieldLevel(int levelId) {
		dao = new Dao();
		return dao.getFieldLevel(levelId);
	}
	
	public String getClientDetailInfo(String companyId) {
		dao = new Dao();
		return dao.getClientDetailInfo(companyId);
	}
	
	public String getVisitRecordList(String companyId,int userId,String year,String month) {
		dao = new Dao();
		return dao.getVisitRecordList(companyId,userId,year,month);
	}

	public String editClientDetailInfo(ClientDetailInfo cdi) {
		dao = new Dao();
		return dao.editClientDetailInfo(cdi);
	}

	public String createVisitRecord(VisitRecord vr) {
		dao = new Dao();
		return dao.createVisitRecord(vr);
	}
}
