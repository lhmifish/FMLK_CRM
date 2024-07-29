package com.fmlk.entity;

import java.io.Serializable;

public class ProjectCase implements Serializable {
	private static final long serialVersionUID = 1L;
	private int id;
	private String caseId;//派工单id
	private String projectId;//项目id
	private int salesId;//销售
	private String createDate;//创建日期
	private boolean isDelete;//已删除
	private String contactUsers;//联系人 
	private String serviceDate;//服务时间
	private int caseState;//派工单状态 0.待审批 1.处理中 2.已超时 3.已取消 4.超时完成    5.正常完成
	private String caseType;//派工类型()()
	private String serviceUsers;//服务人员
	private int serviceType;//服务级别
	private String serviceContent;//服务内容
	private String deviceInfo;//设备信息
	private boolean isChecked;//销售审核
	private boolean isRejected;//销售审核
	private String rejectReason;//拒绝理由
	private String casePeriod;//服务时长
	private String remark;//备注
	private int lateTimes;//超时次数
	private String serviceEndDate;
	private String updateDate;//更新日期
	private String cancelReason;//取消理由
	
	public int getId() {
		return this.id;
	}

	public void setId(int id) {
		this.id = id;
	}
	
	public String getCaseId() {
		return this.caseId;
	}

	public void setCaseId(String caseId) {
		this.caseId = caseId;
	}
	
	public String getProjectId() {
		return this.projectId;
	}

	public void setProjectId(String projectId) {
		this.projectId = projectId;
	}
	
	public int getSalesId() {
		return this.salesId;
	}

	public void setSalesId(int salesId) {
		this.salesId = salesId;
	}
	
	public String getCreateDate() {
		return this.createDate;
	}

	public void setCreateDate(String createDate) {
		this.createDate = createDate;
	}
	
	public boolean getIsDelete() {
		return this.isDelete;
	}

	public void setIsDelete(boolean isDelete) {
		this.isDelete = isDelete;
	}
	
	public String getContactUsers() {
		return this.contactUsers;
	}

	public void setContactUsers(String contactUsers) {
		this.contactUsers = contactUsers;
	}
	
	public String getServiceDate() {
		return this.serviceDate;
	}

	public void setServiceDate(String serviceDate) {
		this.serviceDate = serviceDate;
	}
	
	public String getServiceEndDate() {
		return this.serviceEndDate;
	}

	public void setServiceEndDate(String serviceEndDate) {
		this.serviceEndDate = serviceEndDate;
	}
	
	public int getCaseState() {
		return this.caseState;
	}

	public void setCaseState(int caseState) {
		this.caseState = caseState;
	}
	
	public String getCaseType() {
		return this.caseType;
	}

	public void setCaseType(String caseType) {
		this.caseType = caseType;
	}
	
	public String getServiceUsers() {
		return this.serviceUsers;
	}

	public void setServiceUsers(String serviceUsers) {
		this.serviceUsers = serviceUsers;
	}
	
	public int getServiceType() {
		return this.serviceType;
	}

	public void setServiceType(int serviceType) {
		this.serviceType = serviceType;
	}
	
	public String getServiceContent() {
		return this.serviceContent;
	}

	public void setServiceContent(String serviceContent) {
		this.serviceContent = serviceContent;
	}
	
	public String getDeviceInfo() {
		return this.deviceInfo;
	}

	public void setDeviceInfo(String deviceInfo) {
		this.deviceInfo = deviceInfo;
	}
	
	public boolean getIsChecked() {
		return this.isChecked;
	}

	public void setIsChecked(boolean isChecked) {
		this.isChecked = isChecked;
	}
	
	public boolean getIsRejected() {
		return this.isRejected;
	}

	public void setIsRejected(boolean isRejected) {
		this.isRejected = isRejected;
	}
	
	public String getRejectReason() {
		return this.rejectReason;
	}

	public void setRejectReason(String rejectReason) {
		this.rejectReason = rejectReason;
	}
	
	public String getCasePeriod() {
		return this.casePeriod;
	}

	public void setCasePeriod(String casePeriod) {
		this.casePeriod = casePeriod;
	}
	
	public String getRemark() {
		return this.remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}
	
	public int getLateTimes() {
		return this.lateTimes;
	}

	public void setLateTimes(int lateTimes) {
		this.lateTimes = lateTimes;
	}
	
	public String getUpdateDate() {
		return this.updateDate;
	}

	public void setUpdateDate(String updateDate) {
		this.updateDate = updateDate;
	}
	
	public String getCancelReason() {
		return this.cancelReason;
	}

	public void setCancelReason(String cancelReason) {
		this.cancelReason = cancelReason;
	}
}


