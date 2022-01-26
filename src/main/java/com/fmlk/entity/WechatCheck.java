package com.fmlk.entity;

import java.io.Serializable;

public class WechatCheck implements Serializable{

	private static final long serialVersionUID = 1L;
	private String date;// 日期
	private String userName;
	private String checkFlag;// In,Out
	private String checkTime;//hh:mm:ss
	private String address;
    private int state;//考勤状态 0.异常待确认1.已确认异常2.已确认正常
    private int id;

    public int getId() {
		return this.id;
	}

	public void setId(int id) {
		this.id = id;
	}
    
    public String getDate() {
		return this.date;
	}

	public void setDate(String date) {
		this.date = date;
	}

	public String getUserName() {
		return this.userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getCheckFlag() {
		return this.checkFlag;
	}

	public void setCheckFlag(String checkFlag) {
		this.checkFlag = checkFlag;
	}

	public String getCheckTime() {
		return this.checkTime;
	}

	public void setCheckTime(String checkTime) {
		this.checkTime = checkTime;
	}
	
	public String getAddress() {
		return this.address;
	}

	public void setAddress(String address) {
		this.address = address;
	}
	
	public int getState() {
		return this.state;
	}

	public void setState(int state) {
		this.state = state;
	}
}
