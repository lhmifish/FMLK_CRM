package com.fmlk.service;

import com.fmlk.entity.Inform;
import com.fmlk.dao.JobDao;

public class JobService {

	private JobDao dao = null;
	

	public String getJobList(String year, String month,int userId) {
		dao = new JobDao();
		return dao.getJobList(year,month,userId);
	}

	public String getWeekPlan(int uId, String startDate, String endDate) {
		dao = new JobDao();
		return dao.getWeekPlan(uId,startDate,endDate);
	}

	public String createWeekPlan(int userId, String[] arrayWeekPlan, String editDate) {
		dao = new JobDao();
		return dao.queryWeekPlan(userId,arrayWeekPlan,editDate);
	}

	public String getJob(int userId, String date) {
		dao = new JobDao();
		return dao.getJob(userId,date);
	}
	
	public String getDailyArrangementList(String date) {
		dao = new JobDao();
		return dao.getDailyArrangementList(date);
	}
	
	public String createSendInformation(Inform inf) {
		dao = new JobDao();
		return dao.createSendInformation(inf);
	}

	public String getTomorrowInformList(String tomorrowString) {
		dao = new JobDao();
		return dao.getTomorrowInformList(tomorrowString);
	}
	
	public String editSendInformation(String tomorrowString) {
		dao = new JobDao();
		return dao.editSendInformation(tomorrowString);
	}
}
