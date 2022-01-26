package com.fmlk.entity;

import java.io.Serializable;

public class WeekUploadReport implements Serializable {
	private static final long serialVersionUID = 1L;
	private String userName;// 姓名
	private String startDate;// 开始日期
	private String endDate;// 结束日期
	private String weekReport;// 周总结
	private int id;
	

	public int getId() {
		return this.id;
	}

	public void setId(int id) {
		this.id = id;
	}
	
	public String getEndDate() {
		return this.endDate;
	}

	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}

	public String getStartDate() {
		return this.startDate;
	}

	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}

	public String getUserName() {
		return this.userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getWeekReport() {
		return this.weekReport;
	}

	public void setWeekReport(String weekReport) {
		this.weekReport = weekReport;
	}
}

