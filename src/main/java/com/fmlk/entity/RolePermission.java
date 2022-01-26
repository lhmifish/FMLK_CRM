package com.fmlk.entity;

import java.io.Serializable;

public class RolePermission implements Serializable {
	private static final long serialVersionUID = 1L;
	private int id;
	private String permissionDesc;
	private boolean isDelete;//已删除
	private int type;

	public int getId() {
		return this.id;
	}

	public void setId(int id) {
		this.id = id;
	}
	
	public String getPermissionDesc() {
		return this.permissionDesc;
	}

	public void setPermissionDesc(String permissionDesc) {
		this.permissionDesc = permissionDesc;
	}
	
	public boolean getIsDelete() {
		return this.isDelete;
	}

	public void setIsDelete(boolean isDelete) {
		this.isDelete = isDelete;
	}
	
	public int getType() {
		return this.type;
	}

	public void setType(int type) {
		this.type = type;
	}
}

