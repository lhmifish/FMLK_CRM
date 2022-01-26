package com.fmlk.entity;

import java.io.Serializable;

public class CheckStatistics implements Serializable{
	private static final long serialVersionUID = 1L;
	private String name;// 姓名
	private int lateT;// 迟到次数
	private int beforeT;// 早退次数
	private int outT;// 旷工次数

	public String getName() {
		return this.name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	public int getLateT() {
		return this.lateT;
	}

	public void setLateT(int lateT) {
		this.lateT = lateT;
	}
	
	public int getBeforeT() {
		return this.beforeT;
	}

	public void setBeforeT(int beforeT) {
		this.beforeT = beforeT;
	}
	
	public int getOutT() {
		return this.outT;
	}

	public void setOutT(int outT) {
		this.outT = outT;
	}
	
}
