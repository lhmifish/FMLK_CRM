package com.fmlk.entity;

import java.io.Serializable;

public class ScheduleReport implements Serializable {
	private static final long serialVersionUID = 1L;
	private String name;
	private String date;
	private String topic;
	private String timePeriod;
	private int islate;
	
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
	
	public String getTopic() {
		return this.topic;
	}

	public void setTopic(String topic) {
		this.topic = topic;
	}
	
	public String getTimePeriod() {
		return this.timePeriod;
	}

	public void setTimePeriod(String timePeriod) {
		this.timePeriod = timePeriod;
	}
	
	public int getIsLate() {
		return this.islate;
	}

	public void setIsLate(int islate) {
		this.islate = islate;
	}
	
}

