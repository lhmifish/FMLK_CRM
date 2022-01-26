package com.fmlk.entity;

import java.io.Serializable;

public class ContactUser implements Serializable {
	private static final long serialVersionUID = 1L;
	private int id;//id
	private String companyId;//客户id
	private String userName;//联系人
	private String tel;//电话
	private String email;//邮箱
	private String position;//职位
	private String department;//部门
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
	
	public String getUserName() {
		return this.userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}
	
	public String getTel() {
		return this.tel;
	}

	public void setTel(String tel) {
		this.tel = tel;
	}
	
	public String getEmail() {
		return this.email;
	}

	public void setEmail(String email) {
		this.email = email;
	}
	
	public String getPosition() {
		return this.position;
	}

	public void setPosition(String position) {
		this.position = position;
	}
	
	public String getDepartment() {
		return this.department;
	}

	public void setDepartment(String department) {
		this.department = department;
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
	
}
