package com.fmlk.entity;

import java.io.Serializable;

public class ProjectState implements Serializable{
	private static final long serialVersionUID = 1L;
	private int stateId;
	private int subStateId;
	private String stateName;
	private String subStateName;
	
	public int getStateId() {
		return this.stateId;
	}

	public void setStateId(int stateId) {
		this.stateId = stateId;
	}
	
	public int getSubStateId() {
		return this.subStateId;
	}

	public void setSubStateId(int subStateId) {
		this.subStateId = subStateId;
	}
	
	public String getStateName() {
		return this.stateName;
	}

	public void setStateName(String stateName) {
		this.stateName = stateName;
	}
	
	public String getSubStateName() {
		return this.subStateName;
	}

	public void setSubStateName(String subStateName) {
		this.subStateName = subStateName;
	}
	
	
}
