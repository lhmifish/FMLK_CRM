package com.fmlk.entity;

import java.io.Serializable;

public class TenderStyle implements Serializable {
	private static final long serialVersionUID = 1L;
	private int id;
	private String styleName;
	
	
	public int getId() {
		return this.id;
	}

	public void setId(int id) {
		this.id = id;
	}
	
	public String getStyleName() {
		return this.styleName;
	}

	public void setStyleName(String styleName) {
		this.styleName = styleName;
	}
	
	
}

