package com.fmlk.entity;

import java.io.Serializable;

public class ProjectSubState implements Serializable {
	private static final long serialVersionUID = 1L;
	private int pid;
	private int projectState;
	private int projectType;
	private String name;
	private boolean isDelete;//已删除
	
	public int getPId() {
		return this.pid;
	}

	public void setPId(int pid) {
		this.pid = pid;
	}
	
	public int getProjectState() {
		return this.projectState;
	}

	public void setProjectState(int projectState) {
		this.projectState = projectState;
	}
	
	public int getProjectType() {
		return this.projectType;
	}

	public void setProjectType(int projectType) {
		this.projectType = projectType;
	}
	
	public String getName() {
		return this.name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	public boolean getIsDelete() {
		return this.isDelete;
	}

	public void setIsDelete(boolean isDelete) {
		this.isDelete = isDelete;
	}
}
