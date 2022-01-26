package com.fmlk.entity;

import java.io.Serializable;

public class Role implements Serializable {
	private static final long serialVersionUID = 1L;
	private int id;//id
	private String roleName;//角色名字
	private int departmentId;//部门id
	private boolean isDelete;//已删除
	
	public int getId() {
		return this.id;
	}

	public void setId(int id) {
		this.id = id;
	}
	
	public String getRoleName() {
		return this.roleName;
	}

	public void setRoleName(String roleName) {
		this.roleName = roleName;
	}
	
	public int getDepartmentId() {
		return this.departmentId;
	}

	public void setDepartmentId(int departmentId) {
		this.departmentId = departmentId;
	}
	
	public boolean getIsDelete() {
		return this.isDelete;
	}

	public void setIsDelete(boolean isDelete) {
		this.isDelete = isDelete;
	}
	
}

