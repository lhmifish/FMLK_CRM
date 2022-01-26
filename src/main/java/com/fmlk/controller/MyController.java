package com.fmlk.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class MyController implements ApplicationContextAware{

	private ApplicationContext ctx;
	
	@Override
	public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
		this.ctx = applicationContext;
	}
	
	@RequestMapping(value = "", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getLoginPage(HttpServletRequest request,HttpSession session) {
		ModelAndView mav = new ModelAndView("OfficialNet");
		return mav;
	}
	
	@RequestMapping(value = "/aboutUs", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getAboutUsPage(HttpServletRequest request,HttpSession session) {
		ModelAndView mav = new ModelAndView("AboutUs");
		return mav;
	}
	
	@RequestMapping(value = "/partners", method = RequestMethod.GET)
	public ModelAndView getPartnersPage(HttpServletRequest request,HttpSession session) {
		ModelAndView mav = new ModelAndView("Partners");
		return mav;
	}
	
	@RequestMapping(value = "/contactUs", method = RequestMethod.GET)
	public ModelAndView getContactUsPage(HttpServletRequest request,HttpSession session) {
		ModelAndView mav = new ModelAndView("ContactUs");
		return mav;
	}
	
	@RequestMapping(value = "/ourProducts", method = RequestMethod.GET)
	public ModelAndView getOurProductsPage(HttpServletRequest request,HttpSession session) {
		ModelAndView mav = new ModelAndView("OurProducts");
		return mav;
	}
	
	@RequestMapping(value = "/medicalSolution", method = RequestMethod.GET)
	public ModelAndView getMedicalSolutionPage(HttpServletRequest request,HttpSession session) {
		ModelAndView mav = new ModelAndView("MedicalSolution");
		return mav;
	}
	
	@RequestMapping(value = "/solutionOne", method = RequestMethod.GET)
	public ModelAndView getSolutionOnePage(HttpServletRequest request,HttpSession session) {
		ModelAndView mav = new ModelAndView("SolutionOne");
		return mav;
	}
	
	@RequestMapping(value = "/solutionTwo", method = RequestMethod.GET)
	public ModelAndView getSolutionTwoPage(HttpServletRequest request,HttpSession session) {
		ModelAndView mav = new ModelAndView("SolutionTwo");
		return mav;
	}
	
	@RequestMapping(value = "/solutionThree", method = RequestMethod.GET)
	public ModelAndView getSolutionThreePage(HttpServletRequest request,HttpSession session) {
		ModelAndView mav = new ModelAndView("SolutionThree");
		return mav;
	}
	
	@RequestMapping(value = "/jobPosition", method = RequestMethod.GET)
	public ModelAndView getJobPositionPage(HttpServletRequest request,HttpSession session) {
		ModelAndView mav = new ModelAndView("JobPosition");
		return mav;
	}
	
	@RequestMapping(value = "/aboutApp", method = RequestMethod.GET)
	public ModelAndView getAboutAppPage(HttpServletRequest request,HttpSession session) {
		ModelAndView mav = new ModelAndView("AboutApp");
		return mav;
	}
	
	@RequestMapping(value = "/appAdvantage", method = RequestMethod.GET)
	public ModelAndView getAppAdvantagePage(HttpServletRequest request,HttpSession session) {
		ModelAndView mav = new ModelAndView("AppAdvantage");
		return mav;
	}

}
