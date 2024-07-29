package com.fmlk.entity;

import java.io.Serializable;

public class DailyReport implements Serializable {
	private static final long serialVersionUID = 1L;
	private String date;// 日期
	private String name;// 姓名
	private String schedule;// 日程
	private String scheduleState;// 日程发送时间
	private String dailyReport;// 日报
	private String weekReport;// 周报
	private String nextWeekPlan;// 下周计划
	private String crmUpload;// crm上传
	private String projectReport;// 项目报告
	private String others;// 其他
	private String sign;// 签到签退
	private String remark;// 备注
	private int isLate;// 是否迟到1迟到0未迟到
	private double overWorkTime;// 加班
	private double adjustRestTime;// 调休
	private double vacationOverWorkTime;// 非3倍工资法定假加班
	private double festivalOverWorkTime;// 3倍工资法定假加班
	private int roleId;//角色id

	public String getDate() {
		return this.date;
	}

	public void setDate(String date) {
		this.date = date;
	}

	public String getName() {
		return this.name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getSchedule() {
		return this.schedule;
	}

	public void setSchedule(String schedule) {
		this.schedule = schedule;
	}

	public String getDailyReport() {
		return this.dailyReport;
	}

	public void setDailyReport(String dailyReport) {
		this.dailyReport = dailyReport;
	}

	public String getWeekReport() {
		return this.weekReport;
	}

	public void setWeekReport(String weekReport) {
		this.weekReport = weekReport;
	}

	public String getNextWeekPlan() {
		return this.nextWeekPlan;
	}

	public void setNextWeekPlan(String nextWeekPlan) {
		this.nextWeekPlan = nextWeekPlan;
	}

	public String getCrmUpload() {
		return this.crmUpload;
	}

	public void setCrmUpload(String crmUpload) {
		this.crmUpload = crmUpload;
	}

	public String getProjectReport() {
		return this.projectReport;
	}

	public void setProjectReport(String projectReport) {
		this.projectReport = projectReport;
	}

	public String getOthers() {
		return this.others;
	}

	public void setOthers(String others) {
		this.others = others;
	}

	public String getSign() {
		return this.sign;
	}

	public void setSign(String sign) {
		this.sign = sign;
	}

	public String getRemark() {
		return this.remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public String getScheduleState() {
		return this.scheduleState;
	}

	public void setScheduleState(String scheduleState) {
		this.scheduleState = scheduleState;
	}

	public int getIsLate() {
		return this.isLate;
	}

	public void setIsLate(int isLate) {
		this.isLate = isLate;
	}

	public double getOverWorkTime() {
		return this.overWorkTime;
	}

	public void setOverWorkTime(double overWorkTime) {
		this.overWorkTime = overWorkTime;
	}

	public double getAdjustRestTime() {
		return this.adjustRestTime;
	}

	public void setAdjustRestTime(double adjustRestTime) {
		this.adjustRestTime = adjustRestTime;
	}

	public double getVacationOverWorkTime() {
		return this.vacationOverWorkTime;
	}

	public void setVacationOverWorkTime(double vacationOverWorkTime) {
		this.vacationOverWorkTime = vacationOverWorkTime;
	}

	public double getFestivalOverWorkTime() {
		return this.festivalOverWorkTime;
	}

	public void setFestivalOverWorkTime(double festivalOverWorkTime) {
		this.festivalOverWorkTime = festivalOverWorkTime;
	}
	
	public int getRoleId() {
		return this.roleId;
	}
	
	public void setRoleId(int roleId) {
		this.roleId = roleId;
	}

}
