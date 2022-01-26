package com.fmlk.entity;

import java.io.Serializable;

public class MonthReport implements Serializable{
	private static final long serialVersionUID = 1L;
	private String name;// 姓名
	private int scheduleT;// 日程
	private int dailyReportT;// 日报
	private int weekReportT;// 周报
	private int nextWeekPlanT;// 下周计划
	private int crmUploadT;// crm上传
	private int projectReportT;// 项目报告
	private int othersT;// 其他
    private int noSignIn;//未签到
	private int noSignOut;// 未签退
	private int isLate;// 迟到
	private double overWorkTime;// 加班
	private double adjustRestTime;// 调休
	private double vacationOverWorkTime;// 放假加班
	private double festivalOverWorkTime;// 国定加班
	
	private double overWorkTime4H;// 加班超过4小时
	private double accumulateOverWorkTime;// 加班累计时间
	private double accumulateYearVacation;//累计年假
	private int month;//月份
	private String date;
	 
	
	public String getName() {
		return this.name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	public int getScheduleT() {
		return this.scheduleT;
	}

	public void setScheduleT(int scheduleT) {
		this.scheduleT = scheduleT;
	}
	
	public int getDailyReportT() {
		return this.dailyReportT;
	}

	public void setDailyReportT(int dailyReportT) {
		this.dailyReportT = dailyReportT;
	}
	
	public int getWeekReportT() {
		return this.weekReportT;
	}

	public void setWeekReportT(int weekReportT) {
		this.weekReportT = weekReportT;
	}
	
	public int getNextWeekPlanT() {
		return this.nextWeekPlanT;
	}

	public void setNextWeekPlanT(int nextWeekPlanT) {
		this.nextWeekPlanT = nextWeekPlanT;
	}
	
	public int getCrmUploadT() {
		return this.crmUploadT;
	}

	public void setCrmUploadT(int crmUploadT) {
		this.crmUploadT = crmUploadT;
	}
	
	public int getProjectReportT() {
		return this.projectReportT;
	}

	public void setProjectReportT(int projectReportT) {
		this.projectReportT = projectReportT;
	}
	
	public int getOthersT() {
		return this.othersT;
	}

	public void setOthersT(int othersT) {
		this.othersT = othersT;
	}
	
	public int getNoSignIn() {
		return this.noSignIn;
	}

	public void setNoSignIn(int noSignIn) {
		this.noSignIn = noSignIn;
	}
	
	public int getNoSignOut() {
		return this.noSignOut;
	}

	public void setNoSignOut(int noSignOut) {
		this.noSignOut = noSignOut;
	}
	
	public double getFestivalOverWorkTime() {
		return this.festivalOverWorkTime;
	}

	public void setFestivalOverWorkTime(double festivalOverWorkTime) {
		this.festivalOverWorkTime = festivalOverWorkTime;
	}
	
	public double getVacationOverWorkTime() {
		return this.vacationOverWorkTime;
	}

	public void setVacationOverWorkTime(double vacationOverWorkTime) {
		this.vacationOverWorkTime = vacationOverWorkTime;
	}
	
	public double getAdjustRestTime() {
		return this.adjustRestTime;
	}

	public void setAdjustRestTime(double adjustRestTime) {
		this.adjustRestTime = adjustRestTime;
	}
	
	public double getOverWorkTime() {
		return this.overWorkTime;
	}

	public void setOverWorkTime(double overWorkTime) {
		this.overWorkTime = overWorkTime;
	}
	
	public double getOverWorkTime4H() {
		return this.overWorkTime4H;
	}

	public void setOverWorkTime4H(double overWorkTime4H) {
		this.overWorkTime4H = overWorkTime4H;
	}
	
	public int getIsLate() {
		return this.isLate;
	}

	public void setIsLate(int isLate) {
		this.isLate = isLate;
	}
	
	public double getAccumulateOverWorkTime() {
		return this.accumulateOverWorkTime;
	}

	public void setAccumulateOverWorkTime(double accumulateOverWorkTime) {
		this.accumulateOverWorkTime = accumulateOverWorkTime;
	}
	
	public double getAccumulateYearVacation() {
		return this.accumulateYearVacation;
	}

	public void setAccumulateYearVacation(double accumulateYearVacation) {
		this.accumulateYearVacation = accumulateYearVacation;
	}
	
	public int getMonth() {
		return this.month;
	}

	public void setMonth(int month) {
		this.month = month;
	}
	
	public String getDate() {
		return this.date;
	}

	public void setDate(String date) {
		this.date = date;
	}
}
