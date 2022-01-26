package com.fmlk.entity;

import java.io.Serializable;

public class JobPosition implements Serializable {
	private static final long serialVersionUID = 1L;
	private int id;//id
	private String jobTitle;
	private String techDemand;
	private String level;
	private String salary;
	private boolean isDeleted;//已删除
	private String educationDemand;
	private String otherDemand;
	
	public int getId() {
		return this.id;
	}

	public void setId(int id) {
		this.id = id;
	}
	
	public String getJobTitle() {
		return this.jobTitle;
	}

	public void setJobTitle(String jobTitle) {
		this.jobTitle = jobTitle;
	}
	
	public String getTechDemand() {
		return this.techDemand;
	}

	public void setTechDemand(String techDemand) {
		this.techDemand = techDemand;
	}
	
	public String getLevel() {
		return this.level;
	}

	public void setLevel(String level) {
		this.level = level;
	}
	
	public String getSalary() {
		return this.salary;
	}

	public void setSalary(String salary) {
		this.salary = salary;
	}
	
	public boolean getIsDeleted() {
		return this.isDeleted;
	}

	public void setIsDeleted(boolean isDeleted) {
		this.isDeleted = isDeleted;
	}
	
	public String getEducationDemand() {
		return this.educationDemand;
	}

	public void setEducationDemand(String educationDemand) {
		this.educationDemand = educationDemand;
	}
	
	public String getOtherDemand() {
		return this.otherDemand;
	}

	public void setOtherDemand(String otherDemand) {
		this.otherDemand = otherDemand;
	}
}
