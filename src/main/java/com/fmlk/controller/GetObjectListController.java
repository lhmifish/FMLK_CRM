package com.fmlk.controller;

import javax.servlet.http.HttpServletRequest;
import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import com.fmlk.entity.Contract;
import com.fmlk.entity.PermissionSetting;
import com.fmlk.entity.Project;
import com.fmlk.entity.ProjectCase;
import com.fmlk.entity.Tender;
import com.fmlk.entity.User;
import com.fmlk.service.CompanyService;
import com.fmlk.service.ContractService;
import com.fmlk.service.JobService;
import com.fmlk.service.ProjectService;
import com.fmlk.service.Service;
import com.fmlk.service.TenderService;
import com.fmlk.service.UserService;

@Controller
public class GetObjectListController implements ApplicationContextAware {

	private ApplicationContext ctx;
	private UserService mUserService;
	private CompanyService mCompanyService;
	private ProjectService mProjectService;
	private TenderService mTenderService;
	private JobService mJobService;
	private ContractService mContractService;
	private Service service;

	@Override
	public void setApplicationContext(ApplicationContext arg0) throws BeansException {
		this.ctx = arg0;
	}

	/**
	 * 获取用户列表
	 * 
	 */
	@RequestMapping(value = "/userList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getUserList(HttpServletRequest request) {
		mUserService = new UserService();
		String date = request.getParameter("date");
		User user = new User();
		user.setName(request.getParameter("name"));
		user.setNickName(request.getParameter("nickName"));
		user.setDepartmentId(Integer.parseInt(request.getParameter("dpartId")));
		user.setJobId(request.getParameter("jobId"));
		boolean isHide = Boolean.parseBoolean(request.getParameter("isHide"));
		String jsonStr = mUserService.getUserList(user, date,isHide);
		return jsonStr;
	}

	/**
	 * 获取行业领域列表
	 * 
	 */
	@RequestMapping(value = "/clientFieldList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getClientFieldList(HttpServletRequest request) {
		service = new Service();
		String jsonStr = service.getClientFieldList();
		return jsonStr;
	}

	/**
	 * 获取区域列表
	 * 
	 */
	@RequestMapping(value = "/fieldLevelList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getFieldLevelList(HttpServletRequest request) {
		service = new Service();
		String jsonStr = service.getFieldLevelList();
		return jsonStr;
	}
	
	/**
	 * 获取区域列表
	 * 
	 */
	@RequestMapping(value = "/areaList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getAreaList(HttpServletRequest request) {
		service = new Service();
		String jsonStr = service.getAreaList();
		return jsonStr;
	}

	/**
	 * 获取客户公司列表
	 * 
	 */
	@RequestMapping(value = "/companyList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getCompanyList(HttpServletRequest request) {
		mCompanyService = new CompanyService();
		int salesId = Integer.parseInt(request.getParameter("salesId"));
		String companyName = request.getParameter("companyName");
		boolean isFmlkShare = Boolean.parseBoolean(request.getParameter("isFmlkShare"));
		String jsonStr = mCompanyService.getCompanyList(salesId, companyName,isFmlkShare);
		return jsonStr;
	}

	/**
	 * 获取项目类型列表
	 * 
	 */
	@RequestMapping(value = "/projectTypeList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getProjectTypeList(HttpServletRequest request) {
		service = new Service();
		boolean isFmlkShare = Boolean.parseBoolean(request.getParameter("isFmlkShare"));
		String jsonStr = service.getProjectTypeList(isFmlkShare);
		return jsonStr;
	}

	/**
	 * 获取客户联系人列表
	 * 
	 */
	@RequestMapping(value = "/userContactList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getUserContactList(HttpServletRequest request) {
		mUserService = new UserService();
		String companyId = request.getParameter("companyId");
		String jsonStr = mUserService.getUserContactList(companyId);
		return jsonStr;
	}

	/**
	 * 获取招标代理机构列表
	 * 
	 */
	@RequestMapping(value = "/agencyList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getAgencyList(HttpServletRequest request) {
		service = new Service();
		String jsonStr = service.getAgencyList();
		return jsonStr;
	}

	/**
	 * 获取投标类型列表
	 * 
	 */
	@RequestMapping(value = "/tenderStyleList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getTenderStyleList(HttpServletRequest request) {
		service = new Service();
		String jsonStr = service.getTenderStyleList();
		return jsonStr;
	}

	/**
	 * 获取产品类型列表
	 * 
	 */
	@RequestMapping(value = "/productStyleList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getProductStyleList(HttpServletRequest request) {
		service = new Service();
		boolean isFmlkShare = Boolean.parseBoolean(request.getParameter("isFmlkShare"));
		String jsonStr = service.getProductStyleList(isFmlkShare);
		return jsonStr;
	}

	/**
	 * 获取产品品牌列表
	 * 
	 */
	@RequestMapping(value = "/productBrandList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getProductBrandList(HttpServletRequest request) {
		service = new Service();
		String jsonStr = service.getProductBrandList();
		return jsonStr;
	}

	/**
	 * 获取项目列表
	 * 
	 */
	@RequestMapping(value = "/projectList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getProjectListByCompanyId(HttpServletRequest request) {
		mProjectService = new ProjectService();
		Project p = new Project();
		p.setCompanyId(request.getParameter("companyId"));
		p.setProjectName(request.getParameter("projectName"));
		p.setSalesId(Integer.parseInt(request.getParameter("salesId")));
		p.setProductStyle(request.getParameter("productStyle")+"");
		p.setProjectType(Integer.parseInt(request.getParameter("projectType")));
		boolean isFmlkShare = Boolean.parseBoolean(request.getParameter("isFmlkShare"));
		String jsonStr = mProjectService.getProjectList(p,isFmlkShare);
		return jsonStr;
	}

	/**
	 * 获取招标信息列表
	 * 
	 */
	@RequestMapping(value = "/getTenderList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getTenderList(HttpServletRequest request) {
		mTenderService = new TenderService();
		String date1 = request.getParameter("date1");
		String date2 = request.getParameter("date2");
		Tender tender = new Tender();
		tender.setProductStyle(Integer.parseInt(request.getParameter("productStyle")));
		tender.setTenderStyle(Integer.parseInt(request.getParameter("tenderStyle")));
		tender.setTenderResult(Integer.parseInt(request.getParameter("tenderResult")));
		tender.setTenderCompany(request.getParameter("tenderCompany"));
		//tender.setTenderAgency(Integer.parseInt(request.getParameter("tenderAgency")));
		tender.setProjectId(request.getParameter("projectId"));
		tender.setSaleUser(Integer.parseInt(request.getParameter("saleUser")));
		tender.setIsFmlkShare(Boolean.parseBoolean(request.getParameter("isFmlkShare")));
		String jsonStr = mTenderService.getTenderList(tender, date1, date2);
		return jsonStr;
	}

	/**
	 * 获取工作列表
	 * 
	 */
	@RequestMapping(value = "/getJobList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getJobList(HttpServletRequest request) {
		mJobService = new JobService();
		String year = request.getParameter("year");
		String month = request.getParameter("month");
		int userId = Integer.parseInt(request.getParameter("userId"));
		String jsonStr = mJobService.getJobList(year, month, userId);
		return jsonStr;
	}

	/**
	 * 获取合同列表
	 * 
	 */
	@RequestMapping(value = "/getContractList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getContractList(HttpServletRequest request) {
		mContractService = new ContractService();
		Contract contract = new Contract();
		contract.setProjectId(request.getParameter("projectId"));
		contract.setDateForContract(request.getParameter("dateForContract"));
		contract.setSaleUser(Integer.parseInt(request.getParameter("salesId")));
		contract.setCompanyId(request.getParameter("companyId"));
		contract.setIsFmlkShare(Boolean.parseBoolean(request.getParameter("isFmlkShare")));
		String jsonStr = mContractService.getContractList(contract);
		return jsonStr;
	}

	/**
	 * 获取已中标未录入合同的标书列表
	 * 
	 */
	@RequestMapping(value = "/getTenderListUnInputContract", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getContractListUnInput(HttpServletRequest request) {
		mTenderService = new TenderService();
		String jsonStr = mTenderService.getTenderListUnInputContract();
		return jsonStr;
	}
	
	/**
	 * 获取项目报告列表
	 * 
	 */
	@RequestMapping(value = "/projectReportList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getProjectReportList(HttpServletRequest request) {
		mProjectService = new ProjectService();
		String projectId = request.getParameter("projectId");
		String jsonStr = mProjectService.getProjectReportList(projectId);
		return jsonStr;
	}
	
	/**
	 * 获取派工类型列表
	 * 
	 */
	@RequestMapping(value = "/caseTypeList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getCaseTypeList(HttpServletRequest request) {
		service = new Service();
		String jsonStr = service.getCaseTypeList();
		return jsonStr;
	}
	
	/**
	 * 获取派工单列表
	 * 
	 */
	@RequestMapping(value = "/projectCaseList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getProjectCaseList(HttpServletRequest request) {
		mProjectService = new ProjectService();
		ProjectCase pc = new ProjectCase();
		pc.setSalesId(Integer.parseInt(request.getParameter("salesId")));
		pc.setServiceUsers(request.getParameter("serviceUsers"));
		String companyId = request.getParameter("companyId");
		String projectName = request.getParameter("projectName");
		String jsonStr = mProjectService.getProjectCaseList(pc,companyId,projectName);
		return jsonStr;
	}
	
	/**
	 * 获取派工单列表
	 * 
	 */
	@RequestMapping(value = "/projectCaseUnPatchList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getProjectCaseUnPatchList(HttpServletRequest request) {
		mProjectService = new ProjectService();
		String jsonStr = mProjectService.getProjectCaseUnPatchList(Integer.parseInt(request.getParameter("unPatch")));
		return jsonStr;
	}
	
	/**
	 * 获取上月派工单超时报警列表
	 * 
	 */
	@RequestMapping(value = "/getProjectCaseUnClosedList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getProjectCaseUnClosedList(HttpServletRequest request) {
		mProjectService = new ProjectService();
		int caseState = Integer.parseInt(request.getParameter("caseState"));
		int year = Integer.parseInt(request.getParameter("year"));
		int month = Integer.parseInt(request.getParameter("month"));
		String jsonStr = mProjectService.getProjectCaseUnClosedList2(caseState,year,month);
		return jsonStr;
	}
	
	/**
	 * 获取部门列表
	 * 
	 */
	@RequestMapping(value = "/departmentList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getDepartmentList(HttpServletRequest request) {
		service = new Service();
		String jsonStr = service.getDepartmentList();
		return jsonStr;
	}
	
	/**
	 * 获取角色列表
	 * 
	 */
	@RequestMapping(value = "/roleList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getRoleList(HttpServletRequest request) {
		service = new Service();
		String jsonStr = service.getRoleList();
		return jsonStr;
	}
	
	/**
	 * 获取角色权限列表
	 * 
	 */
	@RequestMapping(value = "/rolePermissionList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getRolePermissionList(HttpServletRequest request) {
		service = new Service();
		String jsonStr = service.getRolePermissionList();
		return jsonStr;
	}
	
	/**
	 * 获取权限设置列表
	 * 
	 */
	@RequestMapping(value = "/permissionSettingList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getPermissionSettingList(HttpServletRequest request) {
		service = new Service();
		PermissionSetting ps = new PermissionSetting();
		ps.setRoleId(Integer.parseInt(request.getParameter("roleId")));
		String jsonStr = service.getPermissionSettingList(ps);
		return jsonStr;
	}
	
	/**
	 * 获取指定用户权限列表
	 * 
	 */
	@RequestMapping(value = "/getUserPermissionList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getUserPermissionListByNickName(HttpServletRequest request) {
		service = new Service();
		String nickName = request.getParameter("nickName");
		String jsonStr = service.getUserPermissionListByNickName(nickName);
		return jsonStr;
		
		
	}
	
	/**
	 * 获取用户指定月份考勤数据
	 * 
	 */
	@RequestMapping(value = "/getUserWorkAttendanceList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getUserWorkAttendanceList(HttpServletRequest request) {
		service = new Service();
		String nickName = request.getParameter("nickName");
		String date = request.getParameter("date");
		String date2 = request.getParameter("date2");
		String jsonStr;
		if(date2.equals("")) {
			//按人
			jsonStr = service.getUserWorkAttendanceList(date,nickName);
		}else {
			//按日期
			jsonStr = service.getUserWorkAttendanceList(date2);
		}
		return jsonStr;
	}
	
	/**
	 * 获取用户指定年份统计数据
	 * 2021_11_2
	 */
	@RequestMapping(value = "/getUserMonthReportList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getUserMonthReportList(HttpServletRequest request) {
		service = new Service();
		String nickName = request.getParameter("nickName");
		String year = request.getParameter("year");
		String month = request.getParameter("month");
		String jsonStr;
		if(month.equals("")) {
			jsonStr = service.getUserMonthReportList(year,nickName);
		}else {
			jsonStr = service.getUserMonthReportList(year+"/"+month);
		}
		return jsonStr;
	}

	/**
	 * 获取项目子状态列表
	 * 
	 */
	@RequestMapping(value = "/projectSubStateList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getProjectSubStateList(HttpServletRequest request) {
		mProjectService = new ProjectService();
        int projectState = Integer.parseInt(request.getParameter("projectState"));
		int projectType = Integer.parseInt(request.getParameter("projectType"));
		String jsonStr = mProjectService.getProjectSubStateList(projectState, projectType);
		return jsonStr;
	}
	
	/**
	 * 获取合同收款交货说明
	 * 
	 */
	@RequestMapping(value = "/getContractPaymentInfoList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getContractPaymentInfoList(HttpServletRequest request) {
		mContractService = new ContractService();
		String contractNum = request.getParameter("contractNum");
		String jsonStr = mContractService.getContractPaymentInfoList(contractNum);		
		return jsonStr;
	}
	
	/**
	 * 获取所有在当日前未交货收款的合同说明
	 * 
	 */
	@RequestMapping(value = "/getDelayContractPaymentInfoList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getDelayContractPaymentInfoList(HttpServletRequest request) {
		mContractService = new ContractService();
		String jsonStr = mContractService.getDelayContractPaymentInfoList();		
		return jsonStr;
	}
	
	/**
	 * 获取合作客户列表
	 * 
	 */
	@RequestMapping(value = "/clientList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getClientList(HttpServletRequest request) {
		service = new Service();
		String jsonStr = service.getClientList();
		return jsonStr;
	}
	
	/**
	 * 获取拜访记录列表
	 * 
	 */
	@RequestMapping(value = "/visitRecordList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getVisitRecordList(HttpServletRequest request) {
		service = new Service();
		String companyId = request.getParameter("companyId");
		int userId = Integer.parseInt(request.getParameter("userId"));
		String year = request.getParameter("year");
		String month = request.getParameter("month");
		String jsonStr = service.getVisitRecordList(companyId,userId,year,month);
		return jsonStr;
	}

}
