package com.fmlk.entity;

import java.io.Serializable;

public class ClientField implements Serializable {
	private static final long serialVersionUID = 1L;
	private String clientField;//行业领域
	private int fieldId;//id
	
	public String getClientField() {
		return this.clientField;
	}

	public void setClientField(String clientField) {
		this.clientField = clientField;
	}
	
	public int getFieldId() {
		return this.fieldId;
	}

	public void setFieldId(int fieldId) {
		this.fieldId = fieldId;
	}
}