package com.fmlk.entity;

import java.io.Serializable;

public class Project implements Serializable {
	private static final long serialVersionUID = 1L;
	private int id;
	private String projectId;//项目id
	private int projectType;//项目类型 1.工程项目 2.设备&网络维保 3.产品供货99其他
	private int salesId;//销售
	private String companyId;
	private String createDate;//创建日期
	private boolean isDelete;//已删除
	private int projectState;//项目状态
	private String projectName;//项目名
	private String contactUsers;//联系人 
	private String salesBeforeUsers;//售前
	private String salesAfterUsers;//售后
	private int projectManager;//项目经理
	private String projectFailedReason;//项目失败原因
	private boolean isFmlkShare;//共享陪护客户
	private int projectSubState;//项目子状态
	private String productStyle;//产品类型
	private String updateDate;//更新日期
	private String startDate;//项目开始时间
	private String endDate;//项目结束时间
	
	public int getId() {
		return this.id;
	}

	public void setId(int id) {
		this.id = id;
	}
	
	public String getProjectId() {
		return this.projectId;
	}

	public void setProjectId(String projectId) {
		this.projectId = projectId;
	}
	
	public int getProjectType() {
		return this.projectType;
	}

	public void setProjectType(int projectType) {
		this.projectType = projectType;
	}
	
	public int getSalesId() {
		return this.salesId;
	}

	public void setSalesId(int salesId) {
		this.salesId = salesId;
	}
	
	public String getCompanyId() {
		return this.companyId;
	}

	public void setCompanyId(String companyId) {
		this.companyId = companyId;
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
	
	public int getProjectState() {
		return this.projectState;
	}

	public void setProjectState(int projectState) {
		this.projectState = projectState;
	}
	
	
	public String getProjectName() {
		return this.projectName;
	}

	public void setProjectName(String projectName) {
		this.projectName = projectName;
	}
	
	public String getContactUsers() {
		return this.contactUsers;
	}

	public void setContactUsers(String contactUsers) {
		this.contactUsers = contactUsers;
	}
	
	public int getProjectManager() {
		return this.projectManager;
	}

	public void setProjectManager(int projectManager) {
		this.projectManager = projectManager;
	}
	
	public String getProjectFailedReason() {
		return this.projectFailedReason;
	}

	public void setProjectFailedReason(String projectFailedReason) {
		this.projectFailedReason = projectFailedReason;
	}
	
	public String getSalesBeforeUsers() {
		return this.salesBeforeUsers;
	}

	public void setSalesBeforeUsers(String salesBeforeUsers) {
		this.salesBeforeUsers = salesBeforeUsers;
	}
	
	public String getSalesAfterUsers() {
		return this.salesAfterUsers;
	}

	public void setSalesAfterUsers(String salesAfterUsers) {
		this.salesAfterUsers = salesAfterUsers;
	}
	
	public int getProjectSubState() {
		return this.projectSubState;
	}

	public void setProjectSubState(int projectSubState) {
		this.projectSubState = projectSubState;
	}
	
	public boolean getIsFmlkShare() {
		return this.isFmlkShare;
	}

	public void setIsFmlkShare(boolean isFmlkShare) {
		this.isFmlkShare = isFmlkShare;
	}
	
	public String getProductStyle() {
		return this.productStyle;
	}

	public void setProductStyle(String productStyle) {
		this.productStyle = productStyle;
	}
	
	public String getUpdateDate() {
		return this.updateDate;
	}

	public void setUpdateDate(String updateDate) {
		this.updateDate = updateDate;
	}
	
	public String getStartDate() {
		return this.startDate;
	}

	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}
	
	public String getEndDate() {
		return this.endDate;
	}

	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}
}

