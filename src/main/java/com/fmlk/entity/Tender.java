package com.fmlk.entity;

import java.io.Serializable;

public class Tender implements Serializable{

	private static final long serialVersionUID = 1L;
	private int id;
	private String tenderNum;//招标编号
	private String tenderCompany;// 招标公司
	private int tenderAgency;//招标代理机构
	private String projectId;//项目id
	private int saleUser;//对应人员
	private String dateForBuy;//购标日期
	private String dateForSubmit;//投标日期
	private String dateForOpen;//开标日期
	private int tenderStyle;//投标类型
	private int tenderExpense;//购标费
	private int tenderIntent;//购标意图1.投标2.购标(其他用处)
	private int productStyle;// 产品类型  1.交换机2.服务器
	private int productBrand;//产品品牌 1.思科2.华为
	private String enterpriseQualificationRequirment;//企业资质要求
	private String technicalRequirment;//技术要求
	private String remark;//备注
	private String createDate;//创建日期
	private boolean isDelete;//已删除
	private int serviceExpense;//中标服务费
	private int tenderResult;//投标结果1.中标2.投标未中3.未投标/弃标
	private int tenderGuaranteeFee;//投标保证金
	private boolean isUploadTender;//已上传标书
	private boolean isFmlkShare;//共享陪护客户
	private String updateDate;//更新日期
	private int tenderState;//标书状态 0.待审核 1.拒绝2.同意
	private int tenderAmount;//中标金额
	
	public int getId() {
		return this.id;
	}

	public void setId(int id) {
		this.id = id;
	}
	
	public String getDateForBuy() {
		return this.dateForBuy;
	}

	public void setDateForBuy(String dateForBuy) {
		this.dateForBuy = dateForBuy;
	}
	
	public String getDateForOpen() {
		return this.dateForOpen;
	}

	public void setDateForOpen(String dateForOpen) {
		this.dateForOpen = dateForOpen;
	}
	
	public String getDateForSubmit() {
		return this.dateForSubmit;
	}

	public void setDateForSubmit(String dateForSubmit) {
		this.dateForSubmit = dateForSubmit;
	}
	
	public String getCreateDate() {
		return this.createDate;
	}

	public void setCreateDate(String createDate) {
		this.createDate = createDate;
	}
	
	public String getTenderNum() {
		return this.tenderNum;
	}

	public void setTenderNum(String tenderNum) {
		this.tenderNum = tenderNum;
	}
	
	public String getTenderCompany() {
		return this.tenderCompany;
	}

	public void setTenderCompany(String tenderCompany) {
		this.tenderCompany = tenderCompany;
	}
	
	public int getTenderAgency() {
		return this.tenderAgency;
	}

	public void setTenderAgency(int tenderAgency) {
		this.tenderAgency = tenderAgency;
	}
	
	public int getProductStyle() {
		return this.productStyle;
	}

	public void setProductStyle(int productStyle) {
		this.productStyle = productStyle;
	}
	
	public int getTenderStyle() {
		return this.tenderStyle;
	}

	public void setTenderStyle(int tenderStyle) {
		this.tenderStyle = tenderStyle;
	}
	
	public int getProductBrand() {
		return this.productBrand;
	}

	public void setProductBrand(int productBrand) {
		this.productBrand = productBrand;
	}
	
	public int getSaleUser() {
		return this.saleUser;
	}

	public void setSaleUser(int saleUser) {
		this.saleUser = saleUser;
	}
	
	public int getTenderExpense() {
		return this.tenderExpense;
	}

	public void setTenderExpense(int tenderExpense) {
		this.tenderExpense = tenderExpense;
	}
	
	public int getServiceExpense() {
		return this.serviceExpense;
	}

	public void setServiceExpense(int serviceExpense) {
		this.serviceExpense = serviceExpense;
	}
	
	public int getTenderResult() {
		return this.tenderResult;
	}

	public void setTenderResult(int tenderResult) {
		this.tenderResult = tenderResult;
	}
	
	public int getTenderIntent() {
		return this.tenderIntent;
	}

	public void setTenderIntent(int tenderIntent) {
		this.tenderIntent = tenderIntent;
	}
	
	public boolean getIsDelete() {
		return this.isDelete;
	}

	public void setIsDelete(boolean isDelete) {
		this.isDelete = isDelete;
	}
	
	public String getRemark() {
		return this.remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}
	
	public String getEnterpriseQualificationRequirment() {
		return this.enterpriseQualificationRequirment;
	}

	public void setEnterpriseQualificationRequirment(String enterpriseQualificationRequirment) {
		this.enterpriseQualificationRequirment = enterpriseQualificationRequirment;
	}
	
	public String getTechnicalRequirment() {
		return this.technicalRequirment;
	}

	public void setTechnicalRequirment(String technicalRequirment) {
		this.technicalRequirment = technicalRequirment;
	}
	
	public String getProjectId() {
		return this.projectId;
	}

	public void setProjectId(String projectId) {
		this.projectId = projectId;
	}
	
	public int getTenderState() {
		return this.tenderState;
	}

	public void setTenderState(int tenderState) {
		this.tenderState = tenderState;
	}
	
	public int getTenderGuaranteeFee() {
		return this.tenderGuaranteeFee;
	}

	public void setTenderGuaranteeFee(int tenderGuaranteeFee) {
		this.tenderGuaranteeFee = tenderGuaranteeFee;
	}
	
	public boolean getIsUploadTender() {
		return this.isUploadTender;
	}

	public void setIsUploadTender(boolean isUploadTender) {
		this.isUploadTender = isUploadTender;
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
	
	public int getTenderAmount() {
		return this.tenderAmount;
	}

	public void setTenderAmount(int tenderAmount) {
		this.tenderAmount = tenderAmount;
	}
}
