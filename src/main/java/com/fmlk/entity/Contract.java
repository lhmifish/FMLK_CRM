package com.fmlk.entity;

import java.io.Serializable;

public class Contract implements Serializable {

	private static final long serialVersionUID = 1L;
	private int id;
	private String contractNum;//合同号
	private String companyId;//用户名称
	private int saleUser;//销售人员
	private String projectId;//项目编号
	private String dateForContract;// 合同实施日期
	private String contractAmount;//合同金额（含税）
	private int taxRate;//税率
	private String serviceDetails;//服务内容说明
	private boolean isDelete;//已删除
	private String createDate;//创建日期
	private boolean isFmlkShare;//共享陪护客户
	private String updateDate;//更新日期
	private String purchaseDetails;//采购说明
	private String deliveryDetails;//合同交货说明
	private String dateForRequirementDelivery;// 合同要求交货日期
	private String dateForActuallyDelivery;// 合同实际交货日期
	private boolean needPurchase;//是否需要采购
	private boolean isUploadContract;//已上传合同
	
	public int getId() {
		return this.id;
	}

	public void setId(int id) {
		this.id = id;
	}
	
	public String getContractNum() {
		return this.contractNum;
	}

	public void setContractNum(String contractNum) {
		this.contractNum = contractNum;
	}
	
	public String getProjectId() {
		return this.projectId;
	}

	public void setProjectId(String projectId) {
		this.projectId = projectId;
	}
	
	public String getDateForContract() {
		return this.dateForContract;
	}

	public void setDateForContract(String dateForContract) {
		this.dateForContract = dateForContract;
	}
	
	
	public int getSaleUser() {
		return this.saleUser;
	}

	public void setSaleUser(int saleUser) {
		this.saleUser = saleUser;
	}
	
	public String getCompanyId() {
		return this.companyId;
	}

	public void setCompanyId(String companyId) {
		this.companyId = companyId;
	}
	
	public String getContractAmount() {
		return this.contractAmount;
	}

	public void setContractAmount(String contractAmount) {
		this.contractAmount = contractAmount;
	}
	
	public int getTaxRate() {
		return this.taxRate;
	}

	public void setTaxRate(int taxRate) {
		this.taxRate = taxRate;
	}
	
	public String getServiceDetails() {
		return this.serviceDetails;
	}

	public void setServiceDetails(String serviceDetails) {
		this.serviceDetails = serviceDetails;
	}
	
	public String getDeliveryDetails() {
		return this.deliveryDetails;
	}

	public void setDeliveryDetails(String deliveryDetails) {
		this.deliveryDetails = deliveryDetails;
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
	
	public String getPurchaseDetails() {
		return this.purchaseDetails;
	}

	public void setPurchaseDetails(String purchaseDetails) {
		this.purchaseDetails = purchaseDetails;
	}
	
	public boolean getNeedPurchase() {
		return this.needPurchase;
	}

	public void setNeedPurchase(boolean needPurchase) {
		this.needPurchase = needPurchase;
	}
	
	public boolean getIsUploadContract() {
		return this.isUploadContract;
	}

	public void setIsUploadContract(boolean isUploadContract) {
		this.isUploadContract = isUploadContract;
	}
	
	public boolean getIsFmlkShare() {
		return this.isFmlkShare;
	}

	public void setIsFmlkShare(boolean isFmlkShare) {
		this.isFmlkShare = isFmlkShare;
	}
	
	public String getUpdateDate() {
		return this.updateDate;
	}

	public void setUpdateDate(String updateDate) {
		this.updateDate = updateDate;
	}
}
