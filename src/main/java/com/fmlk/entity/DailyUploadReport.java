package com.fmlk.entity;

import java.io.Serializable;

public class DailyUploadReport implements Serializable {
	private static final long serialVersionUID = 1L;
	private String date;// 日期
	private String userName;// 姓名
	private String jobType;// 工作类型
	private String client;// 客户
	private String clientUser;// 客户公司
	private String crmNum;// crm编号
	private String jobContent;// 工作内容
	private String laterSupport;// 后续支持
	private String remark;// 备注
	private int id;
	private String time;
	private boolean isFmlkShare;//共享陪护客户

	public int getId() {
		return this.id;
	}

	public void setId(int id) {
		this.id = id;
	}
	
	public String getTime() {
		return this.time;
	}

	public void setTime(String time) {
		this.time = time;
	}

	public String getDate() {
		return this.date;
	}

	public void setDate(String date) {
		this.date = date;
	}

	public String getUserName() {
		return this.userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getJobType() {
		return this.jobType;
	}

	public void setJobType(String jobType) {
		this.jobType = jobType;
	}

	public String getClient() {
		return this.client;
	}

	public void setClient(String client) {
		this.client = client;
	}

	public String getClientUser() {
		return this.clientUser;
	}

	public void setClientUser(String clientUser) {
		this.clientUser = clientUser;
	}

	public String getCrmNum() {
		return this.crmNum;
	}

	public void setCrmNum(String crmNum) {
		this.crmNum = crmNum;
	}

	public String getJobContent() {
		return this.jobContent;
	}

	public void setJobContent(String jobContent) {
		this.jobContent = jobContent;
	}

	public String getLaterSupport() {
		return this.laterSupport;
	}

	public void setLaterSupport(String laterSupport) {
		this.laterSupport = laterSupport;
	}

	public String getRemark() {
		return this.remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}
    
	public boolean getIsFmlkShare() {
		return this.isFmlkShare;
	}

	public void setIsFmlkShare(boolean isFmlkShare) {
		this.isFmlkShare = isFmlkShare;
	}
}
