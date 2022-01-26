package com.fmlk.entity;

import java.io.Serializable;

public class ProjectReport implements Serializable {
	private static final long serialVersionUID = 1L;
	private int id;
	private String projectId;//项目id
	private String contactDate;//沟通时间
	private int userId;//上传用户
	private String reportDesc;//报告描述
	private int reportType;//报告类型 1.销售  2.售前 3.售后 4.采购 5.行政 99.派工case附件 100.其他  
	private String fileName;//文件名
	private String createDate;//创建日期
	private boolean isDelete;//已删除
	private String caseId;
	
	
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
	
	public String getContactDate() {
		return this.contactDate;
	}

	public void setContactDate(String contactDate) {
		this.contactDate = contactDate;
	}
	
	public int getUserId() {
		return this.userId;
	}

	public void setUserId(int userId) {
		this.userId = userId;
	}
	
	public String getReportDesc() {
		return this.reportDesc;
	}

	public void setReportDesc(String reportDesc) {
		this.reportDesc = reportDesc;
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
	
	public int getReportType() {
		return this.reportType;
	}

	public void setReportType(int reportType) {
		this.reportType = reportType;
	}
	
	
	public String getFileName() {
		return this.fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	
	public String getCaseId() {
		return this.caseId;
	}

	public void setCaseId(String caseId) {
		this.caseId = caseId;
	}
}


