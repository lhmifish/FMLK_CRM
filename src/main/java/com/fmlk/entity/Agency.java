package com.fmlk.entity;

import java.io.Serializable;

public class Agency implements Serializable {
	private static final long serialVersionUID = 1L;
	private String agencyName;
	private int agencyId;
	
	public String getAgencyName() {
		return this.agencyName;
	}

	public void setAgencyName(String agencyName) {
		this.agencyName = agencyName;
	}
	
	public int getAgencyId() {
		return this.agencyId;
	}

	public void setAgencyId(int agencyId) {
		this.agencyId = agencyId;
	}
}
