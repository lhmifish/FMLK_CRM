package com.fmlk.entity;

import java.io.Serializable;

public class AssignmentOrder implements Serializable {
	private static final long serialVersionUID = 1L;
	private int id;
	private String clientCompany;//客户公司
	private String clientContact;//客户联系人
	private String projectName;//项目名称
	private String name;// 项目经理
	private String date;//派工日期
	private String userList;// 参与人员
	private String serviceContent;//服务内容
	private String startDate;//开始日期
	private String endDate;//结束日期
	private boolean isDelete;//已删除
	private int state;//1.未开始2.处理中3.超时未完成4.已完成(正常)5.已完成(超时)6.待销售确认
	private int rank;
	private String projectId;
	private String actEndDate;//实际结束日期
	
	public int getId() {
		return this.id;
	}

	public void setId(int id) {
		this.id = id;
	}
	
	public String getClientCompany() {
		return this.clientCompany;
	}

	public void setClientCompany(String clientCompany) {
		this.clientCompany = clientCompany;
	}
	
	public String getClientContact() {
		return this.clientContact;
	}

	public void setClientContact(String clientContact) {
		this.clientContact = clientContact;
	}
	
	public String getProjectName() {
		return this.projectName;
	}

	public void setProjectName(String projectName) {
		this.projectName = projectName;
	}
	
	public String getName() {
		return this.name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getDate() {
		return this.date;
	}

	public void setDate(String date) {
		this.date = date;
	}
	
    public String getUserList() {
		return this.userList;
	}

	public void setUserList(String userList) {
		this.userList = userList;
	}
	
	public String getServiceContent() {
		return this.serviceContent;
	}

	public void setServiceContent(String serviceContent) {
		this.serviceContent = serviceContent;
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
	
	public String getActEndDate() {
		return this.actEndDate;
	}

	public void setActEndDate(String actEndDate) {
		this.actEndDate = actEndDate;
	}
	
	public boolean getIsDelete() {
		return this.isDelete;
	}

	public void setIsDelete(boolean isDelete) {
		this.isDelete = isDelete;
	}
	
	public int getState() {
		return this.state;
	}

	public void setState(int state) {
		this.state = state;
	}
	
	public int getRank() {
		return this.rank;
	}

	public void setRank(int rank) {
		this.rank = rank;
	}
	
	public String getProjectId() {
		return this.projectId;
	}

	public void setProjectId(String projectId) {
		this.projectId = projectId;
	}
}
