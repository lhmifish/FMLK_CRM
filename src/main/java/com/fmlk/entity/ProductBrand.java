package com.fmlk.entity;

import java.io.Serializable;

public class ProductBrand implements Serializable {
	private static final long serialVersionUID = 1L;
	private int id;
	private String brandName;
	
	
	public int getId() {
		return this.id;
	}

	public void setId(int id) {
		this.id = id;
	}
	
	public String getBrandName() {
		return this.brandName;
	}

	public void setBrandName(String brandName) {
		this.brandName = brandName;
	}
	
	
}
