package com.fmlk.entity;

import java.io.Serializable;

public class Area implements Serializable {
	private static final long serialVersionUID = 1L;
	private String areaName;
	private int areaId;
	
	
	public String getAreaName() {
		return this.areaName;
	}

	public void setAreaName(String areaName) {
		this.areaName = areaName;
	}
	
	public int getAreaId() {
		return this.areaId;
	}

	public void setAreaId(int areaId) {
		this.areaId = areaId;
	}
	
}

