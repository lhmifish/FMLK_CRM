package com.fmlk.entity;

import java.io.Serializable;

public class ClientDetailInfo implements Serializable{
	private static final long serialVersionUID = 1L;
	private String companyId;//公司id
	private int schedule;//进度
	private String putPosition;//投放位置
	private String currentProblem;//目前问题
	private String demand;//用户需求
	private String currentStateDesc;//现状
	private String leftProblem;//遗留问题
	private String solution;//解决方案
	private String qualifications;//资质
	private String competitor;//竞争对手
	private String createDate;//创建时间
	private String updateDate;//更新时间
	
	public String getCompanyId() {
		return this.companyId;
	}

	public void setCompanyId(String companyId) {
		this.companyId = companyId;
	}
	
	public int getSchedule() {
		return this.schedule;
	}

	public void setSchedule(int schedule) {
		this.schedule = schedule;
	}
	
	public String getPutPosition() {
		return this.putPosition;
	}

	public void setPutPosition(String putPosition) {
		this.putPosition = putPosition;
	}
	
	public String getCurrentProblem() {
		return this.currentProblem;
	}

	public void setCurrentProblem(String currentProblem) {
		this.currentProblem = currentProblem;
	}
	
	public String getDemand() {
		return this.demand;
	}

	public void setDemand(String demand) {
		this.demand = demand;
	}
	
	public String getCurrentStateDesc() {
		return this.currentStateDesc;
	}

	public void setCurrentStateDesc(String currentStateDesc) {
		this.currentStateDesc = currentStateDesc;
	}
	
	public String getLeftProblem() {
		return this.leftProblem;
	}

	public void setLeftProblem(String leftProblem) {
		this.leftProblem = leftProblem;
	}
	
	public String getSolution() {
		return this.solution;
	}

	public void setSolution(String solution) {
		this.solution = solution;
	}
	
	public String getQualifications() {
		return this.qualifications;
	}

	public void setQualifications(String qualifications) {
		this.qualifications = qualifications;
	}
	
	public String getCompetitor() {
		return this.competitor;
	}

	public void setCompetitor(String competitor) {
		this.competitor = competitor;
	}
	
	public String getCreateDate() {
		return this.createDate;
	}

	public void setCreateDate(String createDate) {
		this.createDate = createDate;
	}
	
	public String getUpdateDate() {
		return this.updateDate;
	}

	public void setUpdateDate(String updateDate) {
		this.updateDate = updateDate;
	}
}
