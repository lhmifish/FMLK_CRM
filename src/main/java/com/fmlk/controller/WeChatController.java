package com.fmlk.controller;

import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.http.HttpServletRequest;
import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import com.fmlk.service.JobService;

@Controller
public class WeChatController implements ApplicationContextAware{

	private ApplicationContext ctx;
	private JobService mJobService;
	
	@Override
	public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
		this.ctx = applicationContext;
	}
	
	/**
	 * 创建工作
	 * 
	 */
	@RequestMapping(value = "/createWeekPlan", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String createWeekPlan(HttpServletRequest request) {
		mJobService = new JobService();
		int userId = Integer.parseInt(request.getParameter("userId"));
		String[] arrayWeekPlan = request.getParameterValues("weekPlanArray");
		String editDate = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date());
		String jsonStr = mJobService.createWeekPlan(userId,arrayWeekPlan,editDate);
		return jsonStr;
	}
	
	/**
	 * 获取工作计划列表
	 * 
	 */
	
	@RequestMapping(value = "/getWeekPlan", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getWeekPlan(HttpServletRequest request) {
		mJobService = new JobService();
		int uId = Integer.parseInt(request.getParameter("userId"));
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		String jsonStr = mJobService.getWeekPlan(uId,startDate,endDate);
		return jsonStr;
	}
	
	/**
	 * 获取员工日程列表
	 * 
	 */
	@RequestMapping(value = "/getDailyArrangementList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getDailyArrangementList(HttpServletRequest request) {
		mJobService = new JobService();
		String date = request.getParameter("date");
		String jsonStr = mJobService.getDailyArrangementList(date);
	    return jsonStr;
	}

	/**
	 * 获取所有人工作计划列表 2021_2_25
	 * 
	 */
	
	@RequestMapping(value = "/getAllWeekPlan", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getAllWeekPlan(HttpServletRequest request) {
		mJobService = new JobService();
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		String jsonStr = mJobService.getWeekPlan(0,startDate,endDate);
		return jsonStr;
	}
}
