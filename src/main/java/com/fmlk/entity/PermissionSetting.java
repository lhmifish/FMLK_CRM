package com.fmlk.entity;

import java.io.Serializable;

public class PermissionSetting implements Serializable {
	private static final long serialVersionUID = 1L;
	private int id;
	private int permissionId;
	private int roleId;

	public int getId() {
		return this.id;
	}

	public void setId(int id) {
		this.id = id;
	}
	
	public int getPermissionId() {
		return this.permissionId;
	}

	public void setPermissionId(int permissionId) {
		this.permissionId = permissionId;
	}

	public int getRoleId() {
		return this.roleId;
	}

	public void setRoleId(int roleId) {
		this.roleId = roleId;
	}
}


