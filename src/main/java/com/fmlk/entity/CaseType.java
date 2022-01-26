package com.fmlk.entity;

import java.io.Serializable;

public class CaseType implements Serializable {
	private static final long serialVersionUID = 1L;
	private int id;
	private String typeName;
	
	public int getId() {
		return this.id;
	}

	public void setId(int id) {
		this.id = id;
	}
	
	public String getTypeName() {
		return this.typeName;
	}

	public void setTypeName(String typeName) {
		this.typeName = typeName;
	}
	
	
}