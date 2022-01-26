package com.fmlk.entity;

import java.io.Serializable;

public class Inform implements Serializable{
	private static final long serialVersionUID = 1L;
	private String title;
	private String content;
	private int departmentId;
	private int informType;//1.立即发送2.发送且提前一天报警
	private String informDate;
	
	public String getTitle() {
		return this.title;
	}

	public void setTitle(String title) {
		this.title = title;
	}
	
	public String getContent() {
		return this.content;
	}

	public void setContent(String content) {
		this.content = content;
	}
	
	public int getDepartmentId() {
		return this.departmentId;
	}

	public void setDepartmentId(int departmentId) {
		this.departmentId = departmentId;
	}
	
	public int getInformType() {
		return this.informType;
	}

	public void setInformType(int informType) {
		this.informType = informType;
	}
	
	public String getInformDate() {
		return this.informDate;
	}

	public void setInformDate(String informDate) {
		this.informDate = informDate;
	}
}
