package com.fmlk.controller;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.fmlk.entity.Inform;
import com.fmlk.service.JobService;
import com.fmlk.entity.Company;
import com.fmlk.entity.Contract;
import com.fmlk.entity.DailyReport;
import com.fmlk.entity.JobPosition;
import com.fmlk.entity.Project;
import com.fmlk.entity.ProjectCase;
import com.fmlk.entity.ProjectReport;
import com.fmlk.entity.Role;
import com.fmlk.entity.Tender;
import com.fmlk.entity.User;
import com.fmlk.service.CompanyService;
import com.fmlk.service.ContractService;
import com.fmlk.service.ProjectService;
import com.fmlk.service.Service;
import com.fmlk.service.TenderService;
import com.fmlk.service.UserService;
import com.fmlk.util.CommonUtils;
import com.fmlk.util.WeChatEnterpriseUtils;
import com.google.gson.Gson;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Controller
public class CreateObjectController implements ApplicationContextAware {

	private ApplicationContext ctx;
	private TenderService mTservice;
	private CompanyService mCompanyService;
	private ProjectService mProjectService;
	private ContractService mContractService;
	private UserService mUserService;
	private Service mService;
	private JobService mJobService;
	
	@Override
	public void setApplicationContext(ApplicationContext arg0) throws BeansException {
		this.ctx = arg0;
	}

	/**
	 * 创建公司
	 * 
	 */
	@RequestMapping(value = "/createNewCompany", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String createCompany(HttpServletRequest request) {
		mCompanyService = new CompanyService();
		Company c = new Company();
		c.setCompanyName(request.getParameter("companyName"));
		c.setAbbrCompanyName(request.getParameter("abbrCompanyName"));
		c.setFieldId(Integer.parseInt(request.getParameter("fieldId")));
	    c.setSalesId(Integer.parseInt(request.getParameter("salesId")));
		c.setAddress(request.getParameter("address"));
		c.setAreaId(Integer.parseInt(request.getParameter("areaId")));
		c.setCompanySource(request.getParameter("companySource"));
		c.setCreateDate(new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date()));
		String[] arrayContact = request.getParameterValues("arrayContact");
		String randNum = String.valueOf(Math.round((Math.random()*9+1)*100000));
		c.setCompanyId("C"+new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())+randNum);
		String jsonStr = mCompanyService.createCompany(c,arrayContact);
		return jsonStr;
	}
	
	/**
	 * 创建项目
	 * 
	 */
	@RequestMapping(value = "/createNewProject", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String createProject(HttpServletRequest request) {
		mProjectService = new ProjectService();
		Project p = new Project();
		p.setProjectName(request.getParameter("projectName"));
		p.setCompanyId(request.getParameter("companyId"));
		p.setSalesId(Integer.parseInt(request.getParameter("salesId")));
		p.setProjectType(Integer.parseInt(request.getParameter("projectType")));
		int projectManager = Integer.parseInt(request.getParameter("projectManager"));
		p.setProjectManager(projectManager);
		if(projectManager != 0 ) {
			p.setSalesBeforeUsers(projectManager+"");
			p.setSalesAfterUsers(projectManager+"");
		}
		else {
			p.setSalesBeforeUsers("");
			p.setSalesAfterUsers("");
		}
		p.setCreateDate(new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date()));
		String[] arrayContactUsers = request.getParameterValues("contactUsers");
		String contactUsers="";
		for(int i=0;i<arrayContactUsers.length;i++) {
			contactUsers += arrayContactUsers[i] + ",";
		}
		contactUsers = contactUsers.substring(0, contactUsers.length()-1);
		p.setContactUsers(contactUsers);
		String randNum = String.valueOf(Math.round((Math.random()*9+1)*10));
		p.setProjectId("P" + new SimpleDateFormat("yyMMddHHmmss").format(new Date())+randNum);
		String jsonStr = mProjectService.createProject(p);
		return jsonStr;
	}
	
	/**
	 * 创建标书
	 * 
	 */
	@RequestMapping(value = "/createNewTender", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String createTender(HttpServletRequest request) {
		mTservice = new TenderService();
		Tender tender = new Tender();
		tender.setTenderNum(request.getParameter("tenderNum"));
		tender.setTenderCompany(request.getParameter("tenderCompany"));
		tender.setTenderAgency(Integer.parseInt(request.getParameter("tenderAgency")));
		tender.setProjectId(request.getParameter("projectId"));
		tender.setSaleUser(Integer.parseInt(request.getParameter("saleUser")));
		tender.setDateForBuy(request.getParameter("dateForBuy"));
		tender.setDateForSubmit(request.getParameter("dateForSubmit"));
		tender.setDateForOpen(request.getParameter("dateForOpen"));
		tender.setTenderStyle(Integer.parseInt(request.getParameter("tenderStyle")));
		tender.setTenderExpense(Integer.parseInt(request.getParameter("tenderExpense")));
        tender.setTenderIntent(Integer.parseInt(request.getParameter("tenderIntent")));
		tender.setTechnicalRequirment(request.getParameter("technicalRequirment"));
		tender.setEnterpriseQualificationRequirment(request.getParameter("enterpriseQualificationRequirment"));
		tender.setProductStyle(Integer.parseInt(request.getParameter("productStyle")));
		tender.setProductBrand(Integer.parseInt(request.getParameter("productBrand")));
		tender.setRemark(request.getParameter("remark"));
		tender.setTenderGuaranteeFee(Integer.parseInt(request.getParameter("tenderGuaranteeFee")));
		tender.setCreateDate(new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date()));
		String jsonStr = mTservice.createTender(tender);
		return jsonStr;
	}
	
	/**
	 * 创建工作
	 * 
	 */
/*	@RequestMapping(value = "/editJob", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String editJob(HttpServletRequest request) {
		mJobService = new JobService();
		String[] arrayJobA = request.getParameterValues("mJobArrA");
		String editDate = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date());
		String jsonStr = mJobService.editJob(arrayJobA,editDate);
		return jsonStr;
	}*/
	
	/**
	 * 创建合同
	 * 
	 */
	@RequestMapping(value = "/createNewContract", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String createContract(HttpServletRequest request) {
		mContractService = new ContractService();
		Contract contract = new Contract();
		contract.setContractNum(request.getParameter("contractNum"));
		contract.setCompanyId(request.getParameter("companyId"));
		contract.setSaleUser(Integer.parseInt(request.getParameter("salesId")));
		contract.setProjectId(request.getParameter("projectId"));
		contract.setDateForContract(request.getParameter("dateForContract"));
		contract.setContractAmount(Long.parseLong(request.getParameter("contractAmount")));
		contract.setTaxRate(Integer.parseInt(request.getParameter("taxRate")));
		contract.setServiceDetails(request.getParameter("serviceDetails"));
		String[] paymentInfo = request.getParameterValues("paymentInfo");
		contract.setCreateDate(new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date()));
		String jsonStr = mContractService.createContract(contract,paymentInfo);
		return jsonStr;
	}
	
	/**
	 * 创建项目报告
	 * 
	 */
	@RequestMapping(value = "/createProjectReport", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String createProjectReport(HttpServletRequest request) {
		mProjectService = new ProjectService();
		ProjectReport pr = new ProjectReport();
		pr.setProjectId(request.getParameter("projectId"));
		pr.setContactDate(request.getParameter("contactDate"));
		pr.setFileName(request.getParameter("fileName"));
		pr.setReportDesc(request.getParameter("reportDesc"));
		pr.setUserId(Integer.parseInt(request.getParameter("userId")));
		pr.setReportType(Integer.parseInt(request.getParameter("reportType")));
		pr.setCreateDate(new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date()));
		pr.setCaseId(request.getParameter("caseId"));
		String jsonStr = mProjectService.createProjectReport(pr);
		return jsonStr;
	}
	
	/**
	 * 创建派工单
	 * 
	 */
	@RequestMapping(value = "/createProjectCase", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String createProjectCase(HttpServletRequest request) {
		mProjectService = new ProjectService();
		ProjectCase pc = new ProjectCase();
		pc.setProjectId(request.getParameter("projectId"));
		pc.setSalesId(Integer.parseInt(request.getParameter("salesId"))); 
		pc.setServiceDate(request.getParameter("serviceDate"));
		pc.setCaseType(request.getParameter("caseType"));
		pc.setServiceType(Integer.parseInt(request.getParameter("serviceType")));
		pc.setServiceContent(request.getParameter("serviceContent"));
		pc.setDeviceInfo(request.getParameter("deviceInfo"));
		pc.setCasePeriod(request.getParameter("casePeriod"));
		pc.setCreateDate(new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date()));
		pc.setServiceEndDate(request.getParameter("serviceEndDate"));
		String[] arrayContact = request.getParameterValues("arrayContact");
		String contactUsers="";
		for(int i=0;i<arrayContact.length;i++) {
			contactUsers += arrayContact[i] + ",";
		}
		contactUsers = contactUsers.substring(0, contactUsers.length()-1);
		String randNum = String.valueOf(Math.round((Math.random()*9+1)*100000));
		pc.setCaseId("PC"+new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())+randNum);
		pc.setContactUsers(contactUsers);
		String jsonStr = mProjectService.createProjectCase(pc);
		
		String projectJSONStr = mProjectService.getProjectCaseByCaseId(pc.getCaseId());
		String errcode2 = (String) new Gson().fromJson(projectJSONStr, Map.class).get("errcode");
		if(errcode2.equals("0")) {
			JSONArray myProjectCaseArr = new JSONObject().fromObject(projectJSONStr).getJSONArray("projectCase");
			ProjectCase projectCase = (ProjectCase) JSONObject.toBean((JSONObject) myProjectCaseArr.get(0), ProjectCase.class);
			pc.setId(projectCase.getId());
		}
		
		// 新建派工通知
		String companyName = request.getParameter("companyName");
		String projectName = request.getParameter("projectName");
		mUserService = new UserService();
		List<User> userList = new ArrayList<User>();
		int uid = pc.getSalesId();		
		if((uid != 3) && (uid != 4)) {
			userList = mUserService.getUserList(pc.getSalesId() + ",3,4");
		}else {
			userList = mUserService.getUserList("3,4");
		}
		String accessToken = WeChatEnterpriseUtils.getAccessToken();
		WeChatEnterpriseUtils.sendProjectCaseInform(accessToken,pc,userList, companyName, projectName);
		return jsonStr;
		
	}
	
	
	/**
	 * 创建用户
	 * 
	 */
	@RequestMapping(value = "/createNewUser", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String createUser(HttpServletRequest request) {
		mUserService = new UserService();
		User user = new User();
		user.setName(request.getParameter("name"));
		user.setNickName(request.getParameter("nickName"));
		String psd = CommonUtils.encryptSHA256(request.getParameter("nickName")+"_"+request.getParameter("psd"));
		user.setPassword(psd);
		user.setJobId(request.getParameter("jobId"));
		user.setEmail(request.getParameter("email"));
		user.setDepartmentId(Integer.parseInt(request.getParameter("departmentId")));
		user.setTel(request.getParameter("tel"));
		user.setCreateDate(new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date()));
		String jsonStr = mUserService.createUser(user);
		return jsonStr;
	}
	
	/**
	 * 创建角色
	 * 
	 */
	@RequestMapping(value = "/createNewRole", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String createRole(HttpServletRequest request) {
		mService = new Service();
		Role role = new Role();
		role.setRoleName(request.getParameter("roleName"));
		role.setDepartmentId(Integer.parseInt(request.getParameter("departmentId")));
		String jsonStr = mService.createRole(role);
		return jsonStr;
	}
	
	/**
	 * 创建考勤数据
	 * 
	 */
	@RequestMapping(value = "/createWorkAttendance", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String createWorkAttendance(HttpServletRequest request) {
		mService = new Service();
		DailyReport dr = new DailyReport();
		dr.setDate(request.getParameter("date"));
		dr.setName(request.getParameter("name"));
		dr.setSchedule(request.getParameter("schedule"));
		dr.setDailyReport(request.getParameter("dailyReport"));
		dr.setWeekReport(request.getParameter("weekReport"));
		dr.setNextWeekPlan(request.getParameter("nextWeekPlan"));
		dr.setProjectReport(request.getParameter("projectReport"));
		dr.setSign(request.getParameter("sign"));
		dr.setRemark(request.getParameter("remark"));
		dr.setIsLate(Integer.parseInt(request.getParameter("isLate")));
		dr.setOverWorkTime(Double.parseDouble(request.getParameter("overWorkTime")));
        dr.setAdjustRestTime(Double.parseDouble(request.getParameter("adjustRestTime")));
		dr.setFestivalOverWorkTime(Double.parseDouble(request.getParameter("festivalOverWorkTime")));
        String jsonStr = mService.createWorkAttendance(dr);
		return jsonStr;
	}
	
	/**
	 * 创建招聘职位
	 * 
	 */
	@RequestMapping(value = "/createNewPosition", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String createNewPosition(HttpServletRequest request) {
		mService = new Service();
		JobPosition jp = new JobPosition();
		jp.setJobTitle(request.getParameter("jobTitle"));
		jp.setTechDemand(request.getParameter("techDemand"));
		jp.setLevel(request.getParameter("level"));
		jp.setSalary(request.getParameter("salary"));
		jp.setEducationDemand(request.getParameter("educationDemand"));
		jp.setOtherDemand(request.getParameter("otherDemand"));
		String jsonStr = mService.createPosition(jp);
		return jsonStr;
	}
	
	/**
	 * 创建通知消息
	 * 
	 */
	@RequestMapping(value = "/createInformation", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String createInformation(HttpServletRequest request) {
		String title = request.getParameter("title");
		String content = request.getParameter("informContent");
		boolean needSave = Boolean.parseBoolean(request.getParameter("needSave"));
		String result = null;
		if(needSave) {
			//存表
			result = WeChatEnterpriseUtils.sendInformation(title,content);
		}else {
			//直接发送
			result = WeChatEnterpriseUtils.sendInformation(title,content);
		}
		
		return result;
	}
	
	/**
	 * 创建文本通知消息
	 * 
	 */
	@RequestMapping(value = "/createTextInformation", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String createTextInformation(HttpServletRequest request) {
		System.out.println("controller");
		Inform inf= new Inform();
		inf.setTitle(request.getParameter("title"));
		inf.setContent(request.getParameter("informContent"));
		inf.setDepartmentId(Integer.parseInt(request.getParameter("departmentId")));
		inf.setInformType(Integer.parseInt(request.getParameter("informType")));
		inf.setInformDate(request.getParameter("informDate"));
		String result = null;
	    mJobService = new JobService();
		//先存表
	    String jsonStr = mJobService.createSendInformation(inf);
	    String errcode = (String) new Gson().fromJson(jsonStr, Map.class).get("errcode");
	    if (errcode.equals("0")) {
	    	//再发送
	    	List<User> userList = null;
	    	if(inf.getDepartmentId() != 0) {
	    		userList = new ArrayList<User>();
	    		mUserService = new UserService();
	    		User u = new User();
	    		u.setName("");
	    		u.setNickName("");
	    		u.setJobId("");
	    		u.setDepartmentId(inf.getDepartmentId());
	    		String uListJsonStr = mUserService.getUserList(u, request.getParameter("thisDate"), true);
	    		JSONArray myUserArr = new JSONObject().fromObject(uListJsonStr).getJSONArray("userlist");
	    		userList = (List<User>) JSONArray.toCollection(myUserArr, User.class);
	    	}
	    	result = WeChatEnterpriseUtils.sendInformation(inf,userList);
	    }
		return result;
	}
	
	/**
	 * 创建图片通知消息
	 * 
	 */
	@RequestMapping(value = "/createImageInformation", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String createImageInformation(HttpServletRequest request) {
		MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
		MultipartFile uploadFile = multipartRequest.getFile("imgFile");
		Inform inf= new Inform();
		inf.setDepartmentId(Integer.parseInt(request.getParameter("departmentId")));
		inf.setInformType(Integer.parseInt(request.getParameter("informType")));
		inf.setInformDate(request.getParameter("informDate"));
		String uploadResult = WeChatEnterpriseUtils.uploadInformImage(uploadFile); 
		
		
		
		String result = null;
	    
		return result;
	}
}
