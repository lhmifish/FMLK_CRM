package com.fmlk.controller;

import javax.servlet.http.HttpServletRequest;
import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import com.fmlk.entity.JobPosition;
import com.fmlk.service.WebService;

@Controller
public class WebController implements ApplicationContextAware{

	private ApplicationContext ctx;
	private WebService mWserService;
	
	@Override
	public void setApplicationContext(ApplicationContext arg0) throws BeansException {
		this.ctx = arg0;
	}
	
	/**
	 * 获取招聘职位列表
	 * 
	 */
	@RequestMapping(value = "/jobPositionList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String jobPositionList(HttpServletRequest request) {
		mWserService = new WebService();
		String jsonStr = mWserService.getJobPositionList();
		return jsonStr;
	}
}
