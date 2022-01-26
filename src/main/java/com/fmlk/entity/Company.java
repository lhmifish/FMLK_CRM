package com.fmlk.entity;

import java.io.Serializable;

public class Company implements Serializable {
	private static final long serialVersionUID = 1L;
	private int id;//id
	private String companyId;//公司id
	private String companyName;//客户全称
	private String abbrCompanyName;//客户简称
	private int salesId;//销售
	private int fieldId;//行业
	private String address;//公司地址
	private int areaId;//地区
	private String companySource;//客户来源
	private String createDate;//创建日期
	private boolean isDelete;//已删除
	
	public int getId() {
		return this.id;
	}

	public void setId(int id) {
		this.id = id;
	}
	
	public String getCompanyId() {
		return this.companyId;
	}

	public void setCompanyId(String companyId) {
		this.companyId = companyId;
	}
	
	public String getCompanyName() {
		return this.companyName;
	}

	public void setCompanyName(String companyName) {
		this.companyName = companyName;
	}
	
	public String getAbbrCompanyName() {
		return this.abbrCompanyName;
	}

	public void setAbbrCompanyName(String abbrCompanyName) {
		this.abbrCompanyName = abbrCompanyName;
	}
	
	public int getSalesId() {
		return this.salesId;
	}

	public void setSalesId(int salesId) {
		this.salesId = salesId;
	}
	
	public int getFieldId() {
		return this.fieldId;
	}

	public void setFieldId(int fieldId) {
		this.fieldId = fieldId;
	}
	
	public int getAreaId() {
		return this.areaId;
	}

	public void setAreaId(int areaId) {
		this.areaId = areaId;
	}
	
	public String getAddress() {
		return this.address;
	}

	public void setAddress(String address) {
		this.address = address;
	}
	
	public String getCreateDate() {
		return this.createDate;
	}

	public void setCreateDate(String createDate) {
		this.createDate = createDate;
	}
	
	public boolean getIsDelete() {
		return this.isDelete;
	}

	public void setIsDelete(boolean isDelete) {
		this.isDelete = isDelete;
	}
	
	public String getCompanySource() {
		return this.companySource;
	}

	public void setCompanySource(String companySource) {
		this.companySource = companySource;
	}
}
