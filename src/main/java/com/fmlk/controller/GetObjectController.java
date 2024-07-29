package com.fmlk.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import com.fmlk.service.CompanyService;
import com.fmlk.service.ContractService;
import com.fmlk.service.JobService;
import com.fmlk.service.ProjectService;
import com.fmlk.service.Service;
import com.fmlk.service.TenderService;
import com.fmlk.service.UserService;

@Controller
public class GetObjectController implements ApplicationContextAware {

	private ApplicationContext ctx;
	private UserService mUserService;
	private CompanyService mCompanyService;
	private ProjectService mProjectService;
	private TenderService mTenderService;
	private ContractService mContractService;
	private JobService mJobService;
	private Service mService;
	
	@Override
	public void setApplicationContext(ApplicationContext arg0) throws BeansException {
		this.ctx = arg0;
	}

	/**
	 * 通过id获取用户
	 * 
	 */
	@RequestMapping(value = "/getUserById", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getUserById(HttpServletRequest request) {
		mUserService = new UserService();
		int uId = Integer.parseInt(request.getParameter("uId"));
		String jsonStr = mUserService.getUserById(uId);
	    return jsonStr;
	}
	
	/**
	 * 通过用户名获取用户
	 * 
	 */
	@RequestMapping(value = "/getUserByUserName", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getUserInfo(HttpServletRequest request) {
		mUserService = new UserService();
		String uName = request.getParameter("userName");
		String jsonStr = mUserService.getUserByUserName(uName);
	    return jsonStr;
	}
	
	/**
	 * 通过用户名拼音获取用户
	 * 
	 */
	@RequestMapping(value = "/getUserByNickName", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getUserInfo2(HttpServletRequest request) {
		mUserService = new UserService();
		String nickName = request.getParameter("nickName");
		String jsonStr = mUserService.getUserByNickName(nickName);
		return jsonStr;
	}
	
	/*****************************************************************************/
	
	
	/**
	 * 通过companyId获取公司
	 * 
	 */
	@RequestMapping(value = "/getCompanyByCompanyId", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getCompanyByCompanyId(HttpServletRequest request) {
		mCompanyService = new CompanyService();
		String companyId = request.getParameter("companyId");
		String jsonStr = mCompanyService.getCompanyByCompanyId(companyId);
	    return jsonStr;
	}
	
	/**
	 * 通过id获取公司
	 * 
	 */
	@RequestMapping(value = "/getCompanyById", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getCompany(HttpServletRequest request) {
		mCompanyService = new CompanyService();
		int id = Integer.parseInt(request.getParameter("id"));
		String jsonStr = mCompanyService.getCompanyById(id);
	    return jsonStr;
	}
	
	/**
	 * 通过projectId获取公司
	 * 
	 */
	@RequestMapping(value = "/getCompanyByProjectId", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getCompanyByProjectId(HttpServletRequest request) {
		mCompanyService = new CompanyService();
		String projectId = request.getParameter("projectId");
		String jsonStr = mCompanyService.getCompanyByProjectId(projectId);
	    return jsonStr;
	}
	
	
	/*****************************************************************************/
	
	/**
	 * 通过id获取项目
	 * 
	 */
	@RequestMapping(value = "/getProject", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getProject(HttpServletRequest request) {
		mProjectService = new ProjectService();
		int id = Integer.parseInt(request.getParameter("id"));
		String jsonStr = mProjectService.getProject(id);
	    return jsonStr;
	}
	
	/**
	 * 通过projectId获取项目
	 * 
	 */
	@RequestMapping(value = "/getProjectByProjectId", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getProjectByProjectId(HttpServletRequest request) {
		mProjectService = new ProjectService();
		String projectId = request.getParameter("projectId");
		String jsonStr = mProjectService.getProjectByProjectId(projectId);
	    return jsonStr;
	}
	
	/*****************************************************************************/
	
	/**
	 * 通过id获取标书
	 * 
	 */
	@RequestMapping(value = "/getTenderById", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getTender(HttpServletRequest request) {
		mTenderService = new TenderService();
		int id = Integer.parseInt(request.getParameter("id"));
		String jsonStr = mTenderService.getTenderById(id);
	    return jsonStr;
	}
	
	/**
	 * 获取标书
	 * 
	 */
	@RequestMapping(value = "/getTenderByCompanyId_Sales", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getTenderByCompanyId_Sales(HttpServletRequest request) {
		mTenderService = new TenderService();
		int salesId = Integer.parseInt(request.getParameter("salesId"));
		String companyId = request.getParameter("companyId");
		String jsonStr = mTenderService.getTenderByCompanyId_Sales(salesId,companyId);
	    return jsonStr;
	}
	
	/*****************************************************************************/
	
	/**
	 * 获取工作计划
	 * 
	 */
	@RequestMapping(value = "/getJob", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getJob(HttpServletRequest request) {
		mJobService = new JobService();
		int userId = Integer.parseInt(request.getParameter("userId"));
		String date = request.getParameter("date");
		String jsonStr = mJobService.getJob(userId,date);
	    return jsonStr;
	}
	
	/*****************************************************************************/
     /**
	 * 获取合同
	 * 
	 */
	@RequestMapping(value = "/getContractById", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getContractById(HttpServletRequest request) {
		mContractService = new ContractService();
		int id = Integer.parseInt(request.getParameter("id"));
		String jsonStr = mContractService.getContractById(id);
	    return jsonStr;
	}
	
	/**
	 * 获取派工类型
	 * 
	 */
	@RequestMapping(value = "/getCaseTypeByTypeId", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getCaseTypeByTypeId(HttpServletRequest request) {
		mProjectService = new ProjectService();
		int typeId = Integer.parseInt(request.getParameter("typeId"));
		String jsonStr = mProjectService.getCaseTypeByTypeId(typeId);
	    return jsonStr;
	}
	
	/*****************************************************************************/
	/**
	 * 获取派工单
	 * 
	 */
	@RequestMapping(value = "/getProjectCase", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getProjectCase(HttpServletRequest request) {
		mProjectService = new ProjectService();
		int id = Integer.parseInt(request.getParameter("id"));
		String jsonStr = mProjectService.getProjectCase(id);
		return jsonStr;
	}
	
	
	/**
	 * 获取用户月统计数据
	 * 
	 */
	@RequestMapping(value = "/getMonthAccumulateData", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getMonthAccumulateData(HttpServletRequest request) {
		mService = new Service();
		String date = request.getParameter("date");
		String nickName = request.getParameter("nickName");
		String jsonStr = mService.getMonthAccumulateData(date,nickName);
	    return jsonStr;
	}
	
	/**
	 * 获取公司信息
	 * 
	 */
	@RequestMapping(value = "/getCompanyInfo", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getCompanyInfo(HttpServletRequest request) {
		mService = new Service();
		String jsonStr = mService.getCompanyInfo();
	    return jsonStr;
	}
	
	/**
	 * 获取产品类别
	 * 
	 */
	@RequestMapping(value = "/getProductStyleById", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getProductStyle(HttpServletRequest request) {
		mService = new Service();
		int productId = Integer.parseInt(request.getParameter("pid"));
		String jsonStr = mService.getProductStyle(productId);
	    return jsonStr;
	}
	
	/**
	 * 获取项目状态
	 * 
	 */
	@RequestMapping(value = "/getProjectState", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getProjectState(HttpServletRequest request) {
		mProjectService = new ProjectService();
		int projectState = Integer.parseInt(request.getParameter("projectState"));
		int projectSubState = Integer.parseInt(request.getParameter("projectSubState"));
		int projectType = Integer.parseInt(request.getParameter("projectType"));
		String jsonStr = mProjectService.getProjectState(projectState,projectSubState,projectType);
	    return jsonStr;
	}
	
	/**
	 * 获取行业等级
	 * 
	 */
	@RequestMapping(value = "/getFieldLevel", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getFieldLevel(HttpServletRequest request) {
		mService = new Service();
		int levelId = Integer.parseInt(request.getParameter("levelId"));
		String jsonStr = mService.getFieldLevel(levelId);
	    return jsonStr;
	}
	
	/**
	 * 获取客户详细信息
	 * 
	 */
	@RequestMapping(value = "/getClientDetailInfo", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getClientDetailInfo(HttpServletRequest request) {
		mService = new Service();
		String companyId = request.getParameter("companyId");
		String jsonStr = mService.getClientDetailInfo(companyId);
	    return jsonStr;
	}
	
	
}
