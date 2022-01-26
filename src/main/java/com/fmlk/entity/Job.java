package com.fmlk.entity;

public class Job {
	private static final long serialVersionUID = 1L;
	private String date;
	private int userId;
	private String createDate;
	private String editDate;
	private String jobDescriptionP;
	private String jobDescriptionA;
	private String time;
	
	public String getDate() {
		return this.date;
	}

	public void setDate(String date) {
		this.date = date;
	}
	
	public int getUserId() {
		return this.userId;
	}

	public void setUserId(int userId) {
		this.userId = userId;
	}
	
	public String getEditDate() {
		return this.editDate;
	}

	public void setEditDate(String editDate) {
		this.editDate = editDate;
	}
	
	public String getCreateDate() {
		return this.createDate;
	}

	public void setCreateDate(String createDate) {
		this.createDate = createDate;
	}
	
	public String getJobDescriptionP() {
		return this.jobDescriptionP;
	}

	public void setJobDescriptionP(String jobDescriptionP) {
		this.jobDescriptionP = jobDescriptionP;
	}
	
	public String getJobDescriptionA() {
		return this.jobDescriptionA;
	}

	public void setJobDescriptionA(String jobDescriptionA) {
		this.jobDescriptionA = jobDescriptionA;
	}
	
	public String getTime() {
		return this.time;
	}

	public void setTime(String time) {
		this.time = time;
	}
}
