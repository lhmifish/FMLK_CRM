package com.fmlk.entity;

import java.io.Serializable;

public class WorkTimeAdjust implements Serializable{

	private static final long serialVersionUID = 1L;
	private int id;
	private String name;
	private String date;
	private double actualOverWorkTime4H;//实际加班超过4小时
	private double actualOverWorkTime;//实际加班低于4小时
	private double approvedRest;//已批准请假
	private double lastMonthTotal;//上月调休剩余
	private double thisMonthTotal;//本月调休剩余
	
	private double overWorkTime4H;//自动获取的加班超过4小时
	private double overWorkTime;//自动获取的加班低于4小时
	private double rest;//自动获取的请假
	
	public int getId() {
		return this.id;
	}

	public void setId(int id) {
		this.id = id;
	}
	
	public String getName() {
		return this.name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	public String getDate() {
		return this.date;
	}

	public void setDate(String date) {
		this.date = date;
	}
	
	public double getActualOverWorkTime4H() {
		return this.actualOverWorkTime4H;
	}

	public void setActualOverWorkTime4H(double actualOverWorkTime4H) {
		this.actualOverWorkTime4H = actualOverWorkTime4H;
	}
	
	public double getActualOverWorkTime() {
		return this.actualOverWorkTime;
	}

	public void setActualOverWorkTime(double actualOverWorkTime) {
		this.actualOverWorkTime = actualOverWorkTime;
	}
	
	public double getApprovedRest() {
		return this.approvedRest;
	}

	public void setApprovedRest(double approvedRest) {
		this.approvedRest = approvedRest;
	}
	
	public double getLastMonthTotal() {
		return this.lastMonthTotal;
	}

	public void setLastMonthTotal(double lastMonthTotal) {
		this.lastMonthTotal = lastMonthTotal;
	}
	
	public double getThisMonthTotal() {
		return this.thisMonthTotal;
	}

	public void setThisMonthTotal(double thisMonthTotal) {
		this.thisMonthTotal = thisMonthTotal;
	}
	
	public double getOverWorkTime4H() {
		return this.overWorkTime4H;
	}

	public void setOverWorkTime4H(double overWorkTime4H) {
		this.overWorkTime4H = overWorkTime4H;
	}
	
	public double getOverWorkTime() {
		return this.overWorkTime;
	}

	public void setOverWorkTime(double overWorkTime) {
		this.overWorkTime = overWorkTime;
	}
	
	public double getRest() {
		return this.rest;
	}

	public void setRest(double rest) {
		this.rest = rest;
	}
	
}

