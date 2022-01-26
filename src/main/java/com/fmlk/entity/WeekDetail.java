package com.fmlk.entity;

import java.io.Serializable;

public class WeekDetail implements Serializable {
	private static final long serialVersionUID = 1L;
	private String name;
	private String MonSchedule;
	private String TuesSchedule;
	private String WedSchedule;
	private String ThurSchedule;
	private String FriSchedule;
	private String SatSchedule;
	private String SunSchedule;
	
	public String getName() {
		return this.name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getMonSchedule() {
		return this.MonSchedule;
	}

	public void setMonSchedule(String MonSchedule) {
		this.MonSchedule = MonSchedule;
	}
	
	public String getTuesSchedule() {
		return this.TuesSchedule;
	}

	public void setTuesSchedule(String TuesSchedule) {
		this.TuesSchedule = TuesSchedule;
	}
	
	public String getWedSchedule() {
		return this.WedSchedule;
	}

	public void setWedSchedule(String WedSchedule) {
		this.WedSchedule = WedSchedule;
	}
	
	public String getThurSchedule() {
		return this.ThurSchedule;
	}

	public void setThurSchedule(String ThurSchedule) {
		this.ThurSchedule = ThurSchedule;
	}
	
	public String getFriSchedule() {
		return this.FriSchedule;
	}

	public void setFriSchedule(String FriSchedule) {
		this.FriSchedule = FriSchedule;
	}
	
	public String getSatSchedule() {
		return this.SatSchedule;
	}

	public void setSatSchedule(String SatSchedule) {
		this.SatSchedule = SatSchedule;
	}
	
	public String getSunSchedule() {
		return this.SunSchedule;
	}

	public void setSunSchedule(String SunSchedule) {
		this.SunSchedule = SunSchedule;
	}
	
	

}
