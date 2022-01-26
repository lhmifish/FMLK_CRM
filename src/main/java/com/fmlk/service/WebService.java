package com.fmlk.service;

import com.fmlk.dao.WebDao;

public class WebService {
	private WebDao dao = null;
	
	public String getJobPositionList() {
		dao = new WebDao();
		return dao.getJobPositionList();
	}
}
