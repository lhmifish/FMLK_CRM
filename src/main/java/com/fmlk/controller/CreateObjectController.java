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
import com.fmlk.entity.VisitRecord;
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
		c.setSalesId(Integer.parseInt(request.getParameter("salesId")));
		c.setFieldId(Integer.parseInt(request.getParameter("fieldId")));
		c.setFieldLevel(Integer.parseInt(request.getParameter("fieldLevel")));
		c.setHospitalDataInfo(request.getParameter("hospitalDataInfo"));
		c.setAddress(request.getParameter("address"));
		c.setAreaId(Integer.parseInt(request.getParameter("areaId")));
		c.setCompanySource(request.getParameter("companySource"));
		c.setCreateDate(new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date()));
		c.setIsFmlkShare(Boolean.parseBoolean(request.getParameter("isFmlkShare")));
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
		String[] arrayContactUsers = request.getParameterValues("contactUsers");
		String contactUsers="";
		for(int i=0;i<arrayContactUsers.length;i++) {
			contactUsers += arrayContactUsers[i] + ",";
		}
		if(!contactUsers.equals("")) {
			contactUsers = contactUsers.substring(0, contactUsers.length()-1);
		}
		p.setContactUsers(contactUsers);
		String[] arrayProductStyle = request.getParameterValues("productStyle");
		String productStyle = "";
		for(int i=0;i<arrayProductStyle.length;i++) {
			productStyle += arrayProductStyle[i] + ",";
		}
		if(!productStyle.equals("")) {
			productStyle = productStyle.substring(0, productStyle.length()-1);
		}
		p.setProductStyle(productStyle);
		int projectManager = Integer.parseInt(request.getParameter("projectManager"));
		p.setProjectManager(projectManager);
		boolean isFmlkShare = Boolean.parseBoolean(request.getParameter("isFmlkShare"));
		p.setIsFmlkShare(isFmlkShare);
		p.setStartDate(request.getParameter("startDate"));
		p.setEndDate(request.getParameter("endDate"));
		p.setProjectState(Integer.parseInt(request.getParameter("projectState")));
		p.setCreateDate(new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date()));
		if(projectManager != 0 ) {
			p.setSalesBeforeUsers(projectManager+"");
			p.setSalesAfterUsers(projectManager+"");
		}else {
			p.setSalesBeforeUsers("");
			p.setSalesAfterUsers("");
		}
		String randNum = String.valueOf(Math.round((Math.random()*9+1)*10));
		randNum = new SimpleDateFormat("yyMMddHHmmss").format(new Date())+randNum;
		if(isFmlkShare) {
			p.setProjectId("CP" + randNum);
		}else {
			p.setProjectId("P" + randNum);
		}
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
		String tenderGuaranteeFee = request.getParameter("tenderGuaranteeFee");
		if(tenderGuaranteeFee == null || tenderGuaranteeFee.equals("")) {
			tender.setTenderGuaranteeFee(0);
		}else {
			tender.setTenderGuaranteeFee(Integer.parseInt(request.getParameter("tenderGuaranteeFee")));
		}
		tender.setCreateDate(new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date()));
		tender.setIsFmlkShare(Boolean.parseBoolean(request.getParameter("isFmlkShare")));
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
		contract.setContractAmount(request.getParameter("contractAmount"));
		String taxRate = request.getParameter("taxRate");
		if(taxRate.equals("")||taxRate==null) {
			contract.setTaxRate(-1);
		}else {
			contract.setTaxRate(Integer.parseInt(taxRate));
		}
		contract.setServiceDetails(request.getParameter("serviceDetails"));
		contract.setIsFmlkShare(Boolean.parseBoolean(request.getParameter("isFmlkShare")));
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
		pc.setCreateDate(new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date()));
		pc.setServiceEndDate(request.getParameter("serviceEndDate"));
		String[] arrayContact = request.getParameterValues("arrayContact");
		String contactUsers="";
		for(int i=0;i<arrayContact.length;i++) {
			contactUsers += arrayContact[i] + ",";
		}
		contactUsers = contactUsers.substring(0, contactUsers.length()-1);
		pc.setContactUsers(contactUsers);
		String randNum = String.valueOf(Math.round((Math.random()*9+1)*100000));
		pc.setCaseId("PC"+new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())+randNum);
		String jsonStr = mProjectService.createProjectCase(pc);
		boolean errcode2 = ((String) new Gson().fromJson(jsonStr, Map.class).get("errcode")).equals("0");
		if(errcode2) {
			String projectJSONStr = mProjectService.getProjectCaseByCaseId(pc.getCaseId());
			errcode2 = ((String) new Gson().fromJson(projectJSONStr, Map.class).get("errcode")).equals("0");
			if(errcode2) {
				JSONArray myArr = new JSONObject().fromObject(projectJSONStr).getJSONArray("projectCase");
				ProjectCase projectCase = (ProjectCase) JSONObject.toBean((JSONObject) myArr.get(0), ProjectCase.class);
				// 新建派工通知
				String companyName = request.getParameter("companyName");
				String projectName = request.getParameter("projectName");
				mUserService = new UserService();
				List<User> userList = new ArrayList<User>();
				String userJsonStr = mUserService.getUserById(pc.getSalesId());
				String salesName = "";
				errcode2 = ((String) new Gson().fromJson(userJsonStr, Map.class).get("errcode")).equals("0");
				if(errcode2) {
					myArr = new JSONObject().fromObject(userJsonStr).getJSONArray("user");
					User mUser = (User) JSONObject.toBean((JSONObject) myArr.get(0), User.class);
					salesName = mUser.getName();
					//通知到销售部经理和销售本人
					if(mUser.getRoleId() != 3) {
						userList = mUserService.getUserListByIds(pc.getSalesId() + ",3");
					}else {
						userList = mUserService.getUserListByIds("3");
					}
					String accessToken = WeChatEnterpriseUtils.getAccessToken();
					WeChatEnterpriseUtils.sendProjectCaseInform(accessToken,projectCase,userList, companyName, projectName,salesName,0);
				}
			}
		}
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
		dr.setWeekReport("");
		dr.setNextWeekPlan("");
		dr.setProjectReport("");
		String mSign = request.getParameter("sign");
		mSign = (mSign==null||mSign.equals(""))?"":mSign;	
		dr.setSign(mSign);
		String mRemark = request.getParameter("remark");
		mRemark = (mRemark==null||mRemark.equals(""))?"":mRemark;	
		dr.setRemark(mRemark);
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
	
	/**
	 * 创建拜访记录
	 * 
	 */
	@RequestMapping(value = "/createVisitRecord", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String createVisitRecord(HttpServletRequest request) {
		mService = new Service();
		VisitRecord vr = new VisitRecord();
		vr.setCompanyId(request.getParameter("companyId"));
		vr.setVisitDate(request.getParameter("visitDate"));
		vr.setSalesId(Integer.parseInt(request.getParameter("salesId")));
		vr.setVisitDesc(request.getParameter("desc"));
		vr.setCreateDate(new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date()));
		vr.setIsFmlkShare(Boolean.parseBoolean(request.getParameter("isFmlkShare")));
		String jsonStr = mService.createVisitRecord(vr);
        return jsonStr;
	}
}
