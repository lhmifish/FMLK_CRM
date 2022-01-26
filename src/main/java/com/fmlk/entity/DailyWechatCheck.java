package com.fmlk.entity;

import java.io.Serializable;

public class DailyWechatCheck implements Serializable{

	private static final long serialVersionUID = 1L;
	private String date;// 日期
	private String name;
	private String endTime;// 下班时间
	private String startTime;//上班时间
	private String detail;//考勤详情列表

	public String getDate() {
		return this.date;
	}

	public void setDate(String date) {
		this.date = date;
	}

	public String getName() {
		return this.name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getStartTime() {
		return this.startTime;
	}

	public void setStartTime(String startTime) {
		this.startTime = startTime;
	}

	public String getEndTime() {
		return this.endTime;
	}

	public void setEndTime(String endTime) {
		this.endTime = endTime;
	}
	
	public String getDetail() {
		return this.detail;
	}

	public void setDetail(String detail) {
		this.detail = detail;
	}

}
