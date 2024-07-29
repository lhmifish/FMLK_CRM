package com.fmlk.entity;

import java.io.Serializable;

public class Client implements Serializable {
	private static final long serialVersionUID = 1L;
	private int clientId;
	private String clientName;
	private boolean isDeleted;//已删除
	
	public String getClientName() {
		return this.clientName;
	}

	public void setClientName(String clientName) {
		this.clientName = clientName;
	}
	
	public int getClientId() {
		return this.clientId;
	}

	public void setClientId(int clientId) {
		this.clientId = clientId;
	}
	
	public boolean getIsDeleted() {
		return this.isDeleted;
	}

	public void setIsDeleted(boolean isDeleted) {
		this.isDeleted = isDeleted;
	}
}