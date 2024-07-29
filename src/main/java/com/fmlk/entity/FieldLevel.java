package com.fmlk.entity;

import java.io.Serializable;

public class FieldLevel implements Serializable{
	private static final long serialVersionUID = 1L;
	private String levelName;
	private int levelId;
	
	public String getLevelName() {
		return this.levelName;
	}

	public void setLevelName(String levelName) {
		this.levelName = levelName;
	}
	
	public int getLevelId() {
		return this.levelId;
	}

	public void setLevelId(int levelId) {
		this.levelId = levelId;
	}
	
}