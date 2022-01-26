package com.fmlk.util;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import com.fmlk.entity.Inform;
import com.fmlk.entity.User;
import com.fmlk.service.JobService;
import com.fmlk.service.UserService;
import com.fmlk.util.WeChatEnterpriseUtils;
import com.fmlk.entity.DailyUploadReport;
import com.fmlk.service.Service;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public class MyTimerTask4 {
	
	private Service service;
	private List<DailyUploadReport> durList = null;
	private JobService jService;
	private UserService uService;
	
	protected void execute4() {
		/*service = new Service();
		Calendar calendar = Calendar.getInstance();
		calendar.add(Calendar.DATE, -1);
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
		String yesterdayString = formatter.format(calendar.getTime());// 昨天
		String jsonStr3 = service.getAllDailyUploadReportList(yesterdayString);
		JSONArray arrayList3 = new JSONObject().fromObject(jsonStr3).getJSONArray("dailyuploadreportlist");
		durList = new ArrayList<DailyUploadReport>();
		durList = (List<DailyUploadReport>) JSONArray.toCollection(arrayList3, DailyUploadReport.class);
		if(durList.size()>0) {
		ExchangeMailUtil.sendDailyUploadReportEmail(yesterdayString,durList);
		}*/
		Calendar calendar = Calendar.getInstance();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
		String thisDate = formatter.format(calendar.getTime());
		calendar.add(Calendar.DATE, 1);
		String tomorrowString = formatter.format(calendar.getTime());
		//获取需要报警的通知
		jService = new JobService();
		String jsonStr = jService.getTomorrowInformList(tomorrowString);
		//更新报警通知的overTime
		String jsonStr2 = jService.editSendInformation(tomorrowString);
		//报警
		JSONArray informArr = new JSONObject().fromObject(jsonStr).getJSONArray("informlist");
		List<Inform> informList = new ArrayList<Inform>();		
		informList = (List<Inform>) JSONArray.toCollection(informArr, Inform.class);
		for(int i=0;i<informList.size();i++) {
			Inform inf = informList.get(i);
			int departmentId =inf.getDepartmentId(); 
			List<User> userList = null;
			if(departmentId != 0) {
	    		userList = new ArrayList<User>();
	    		uService = new UserService();
	    		User u = new User();
	    		u.setName("");
	    		u.setNickName("");
	    		u.setJobId("");
	    		u.setDepartmentId(departmentId);
	    		String uListJsonStr = uService.getUserList(u, thisDate, true);
	    		JSONArray myUserArr = new JSONObject().fromObject(uListJsonStr).getJSONArray("userlist");
	    		userList = (List<User>) JSONArray.toCollection(myUserArr, User.class);
	    	}
			WeChatEnterpriseUtils.sendInformation(inf,userList);
		}
		
	
	}
}
