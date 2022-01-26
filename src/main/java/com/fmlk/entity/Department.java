package com.fmlk.entity;

import java.io.Serializable;

public class Department implements Serializable {
	private static final long serialVersionUID = 1L;
	private int id;//id
	private String departmentName;//部门名字
	private boolean isDelete;//已删除
	
	public int getId() {
		return this.id;
	}

	public void setId(int id) {
		this.id = id;
	}
	
	public String getDepartmentName() {
		return this.departmentName;
	}

	public void setDepartmentName(String departmentName) {
		this.departmentName = departmentName;
	}
	
	public boolean getIsDelete() {
		return this.isDelete;
	}

	public void setIsDelete(boolean isDelete) {
		this.isDelete = isDelete;
	}
	
}
