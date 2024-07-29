package com.fmlk.entity;

import java.io.Serializable;

public class VisitRecord implements Serializable{
	private static final long serialVersionUID = 1L;
	private String companyId;//公司id
	private int salesId;//销售
	private String visitDesc;//内容
	private String visitDate;//访问时间
	private String createDate;//创建时间
	private boolean isFmlkShare;//共享陪护客户
		
	public String getCompanyId() {
		return this.companyId;
	}

	public void setCompanyId(String companyId) {
		this.companyId = companyId;
	}
	
	public String getVisitDesc() {
		return this.visitDesc;
	}

	public void setVisitDesc(String visitDesc) {
		this.visitDesc = visitDesc;
	}
	
	public String getVisitDate() {
		return this.visitDate;
	}

	public void setVisitDate(String visitDate) {
		this.visitDate = visitDate;
	}
	
	public String getCreateDate() {
		return this.createDate;
	}

	public void setCreateDate(String createDate) {
		this.createDate = createDate;
	}
	
	public int getSalesId() {
		return this.salesId;
	}

	public void setSalesId(int salesId) {
		this.salesId = salesId;
	}
	
	public boolean getIsFmlkShare() {
		return this.isFmlkShare;
	}

	public void setIsFmlkShare(boolean isFmlkShare) {
		this.isFmlkShare = isFmlkShare;
	}
}
