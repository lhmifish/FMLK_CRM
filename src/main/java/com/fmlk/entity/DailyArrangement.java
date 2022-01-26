package com.fmlk.entity;

import java.io.Serializable;

public class DailyArrangement implements Serializable{
	private static final long serialVersionUID = 1L;
	private String userName;// 姓名
	private String accident;// 工作类型
	private String client;// 客户
	private String address;// 客户公司
	private int id;
	private String time;

	public int getId() {
		return this.id;
	}

	public void setId(int id) {
		this.id = id;
	}
	
	public String getTime() {
		return this.time;
	}

	public void setTime(String time) {
		this.time = time;
	}

	public String getUserName() {
		return this.userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getAccident() {
		return this.accident;
	}

	public void setAccident(String accident) {
		this.accident = accident;
	}

	public String getClient() {
		return this.client;
	}

	public void setClient(String client) {
		this.client = client;
	}

	public String getAddress() {
		return this.address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

}
