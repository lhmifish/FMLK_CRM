package com.fmlk.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.fmlk.entity.Client;
import com.fmlk.entity.ClientDetailInfo;
import com.fmlk.entity.Company;
import com.fmlk.entity.Contract;
import com.fmlk.entity.DailyReport;
import com.fmlk.entity.JobPosition;
import com.fmlk.entity.MonthReport;
import com.fmlk.entity.PermissionSetting;
import com.fmlk.entity.Project;
import com.fmlk.entity.ProjectCase;
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
public class EditObjectController implements ApplicationContextAware {

	private ApplicationContext ctx;
	private CompanyService mCompanyService;
	private ProjectService mProjectService;
	private TenderService mTenderService;
	private ContractService mContractService;
	private UserService mUserService;
	private Service mService;

	@Override
	public void setApplicationContext(ApplicationContext arg0) throws BeansException {
		this.ctx = arg0;
	}

	/**
	 * 编辑公司
	 * 
	 */
	@RequestMapping(value = "/editCompany", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String editCompany(HttpServletRequest request) {
		mCompanyService = new CompanyService();
		Company c = new Company();
		c.setCompanyName(request.getParameter("companyName"));
		c.setAbbrCompanyName(request.getParameter("abbrCompanyName"));
		c.setFieldId(Integer.parseInt(request.getParameter("fieldId")));
		c.setFieldLevel(Integer.parseInt(request.getParameter("fieldLevel")));
		c.setHospitalDataInfo(request.getParameter("hospitalDataInfo"));
		c.setSalesId(Integer.parseInt(request.getParameter("salesId")));
		c.setAddress(request.getParameter("address"));
		c.setAreaId(Integer.parseInt(request.getParameter("areaId")));
		c.setCompanySource(request.getParameter("companySource"));
		String[] arrayContact = request.getParameterValues("arrayContact");
		c.setId(Integer.parseInt(request.getParameter("id")));
		c.setCompanyId(request.getParameter("companyId"));
		c.setUpdateDate(new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date()));
		String jsonStr = mCompanyService.editCompany(c, arrayContact);
		return jsonStr;
	}

	/**
	 * 删除公司
	 * 
	 */
	@RequestMapping(value = "/deleteCompany", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String deleteCompany(HttpServletRequest request) {
		mCompanyService = new CompanyService();
		int id = Integer.parseInt(request.getParameter("id"));
		String updateDate = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date());
		String jsonStr = mCompanyService.deleteCompany(id, updateDate);
		return jsonStr;
	}

	/**
	 * 编辑标书
	 * 
	 */
	@RequestMapping(value = "/editTender", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String editTender(HttpServletRequest request) {
		mTenderService = new TenderService();
		Tender tender = new Tender();
		tender.setId(Integer.parseInt(request.getParameter("id")));
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
		tender.setProductStyle(Integer.parseInt(request.getParameter("productStyle")));
		tender.setProductBrand(Integer.parseInt(request.getParameter("productBrand")));
		tender.setTechnicalRequirment(request.getParameter("technicalRequirment"));
		tender.setEnterpriseQualificationRequirment(request.getParameter("enterpriseQualificationRequirment"));
		tender.setRemark(request.getParameter("remark"));
		tender.setTenderGuaranteeFee(Integer.parseInt(request.getParameter("tenderGuaranteeFee")));
		tender.setTenderIntent(Integer.parseInt(request.getParameter("tenderIntent")));
		tender.setTenderResult(Integer.parseInt(request.getParameter("tenderResult")));
		tender.setServiceExpense(Integer.parseInt(request.getParameter("serviceExpense")));
		tender.setTenderAmount(Integer.parseInt(request.getParameter("tenderAmount")));
		tender.setIsUploadTender(Boolean.parseBoolean(request.getParameter("isUploadTender")));
		tender.setUpdateDate(new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date()));
		String jsonStr = mTenderService.editTender(tender);
		return jsonStr;
	}

	/**
	 * 删除标书
	 * 
	 */
	@RequestMapping(value = "/deleteTender", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String deleteTender(HttpServletRequest request) {
		mTenderService = new TenderService();
		int id = Integer.parseInt(request.getParameter("id"));
		String updateDate = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date());
		String jsonStr = mTenderService.deleteTender(id, updateDate);
		return jsonStr;
	}

	/**
	 * 编辑项目
	 * 
	 */
	@RequestMapping(value = "/editProject", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String editProject(HttpServletRequest request) {
		mProjectService = new ProjectService();
		Project project = new Project();
		project.setId(Integer.parseInt(request.getParameter("id")));
		project.setProjectName(request.getParameter("projectName"));
		project.setProjectType(Integer.parseInt(request.getParameter("projectType")));
		project.setProjectManager(Integer.parseInt(request.getParameter("projectManager")));
		project.setProjectState(Integer.parseInt(request.getParameter("projectState")));
		project.setProjectFailedReason(request.getParameter("projectFailedReason"));
		String[] arrayContactUsers = request.getParameterValues("contactUsers");
		String[] arraySalesBeforeUsers = request.getParameterValues("salesBeforeUsers");
		String[] arraySalesAfterUsers = request.getParameterValues("salesAfterUsers");
		String[] arrayProductStyle = request.getParameterValues("productStyle");
		project.setStartDate(request.getParameter("startDate"));
		project.setEndDate(request.getParameter("endDate"));
		project.setProjectSubState(Integer.parseInt(request.getParameter("projectSubState")));
		project.setUpdateDate(new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date()));
		String contactUsers = "";
		for (int i = 0; i < arrayContactUsers.length; i++) {
			contactUsers += arrayContactUsers[i] + ",";
		}
		if (!contactUsers.equals("")) {
			contactUsers = contactUsers.substring(0, contactUsers.length() - 1);
		}
		project.setContactUsers(contactUsers);

		String productStyle = "";
		for (int i = 0; i < arrayProductStyle.length; i++) {
			productStyle += arrayProductStyle[i] + ",";
		}
		if (!productStyle.equals("")) {
			productStyle = productStyle.substring(0, productStyle.length() - 1);
		}
		project.setProductStyle(productStyle);

		String salesBeforeUsers = "";
		for (int i = 0; i < arraySalesBeforeUsers.length; i++) {
			salesBeforeUsers += arraySalesBeforeUsers[i] + ",";
		}
		if (!salesBeforeUsers.equals("")) {
			salesBeforeUsers = salesBeforeUsers.substring(0, salesBeforeUsers.length() - 1);
		}
		project.setSalesBeforeUsers(salesBeforeUsers);

		String salesAfterUsers = "";
		for (int i = 0; i < arraySalesAfterUsers.length; i++) {
			salesAfterUsers += arraySalesAfterUsers[i] + ",";
		}
		if (!salesAfterUsers.equals("")) {
			salesAfterUsers = salesAfterUsers.substring(0, salesAfterUsers.length() - 1);
		}
		project.setSalesAfterUsers(salesAfterUsers);
		String jsonStr = mProjectService.editProject(project);
		return jsonStr;
	}

	/**
	 * 删除项目
	 * 
	 */
	@RequestMapping(value = "/deleteProject", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String deleteProject(HttpServletRequest request) {
		mProjectService = new ProjectService();
		int id = Integer.parseInt(request.getParameter("id"));
		String updateDate = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date());
		String jsonStr = mProjectService.deleteProject(id, updateDate);
		return jsonStr;
	}

	/**
	 * 编辑标书
	 * 
	 */
	@RequestMapping(value = "/editContract", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String editContract(HttpServletRequest request) {
		mContractService = new ContractService();
		Contract ct = new Contract();
		ct.setId(Integer.parseInt(request.getParameter("id")));
		ct.setContractNum(request.getParameter("contractNum"));
		ct.setCompanyId(request.getParameter("companyId"));
		ct.setProjectId(request.getParameter("projectId"));
		ct.setSaleUser(Integer.parseInt(request.getParameter("saleUser")));
		ct.setDateForContract(request.getParameter("dateForContract"));
		ct.setContractAmount(request.getParameter("contractAmount"));
		String taxRate = request.getParameter("taxRate");
		if (taxRate.equals("") || taxRate == null) {
			ct.setTaxRate(-1);
		} else {
			ct.setTaxRate(Integer.parseInt(taxRate));
		}
		ct.setServiceDetails(request.getParameter("serviceDetails"));
		boolean isUploadContract = Integer.parseInt(request.getParameter("isUploadContract")) == 1;
		ct.setIsUploadContract(isUploadContract);
		ct.setUpdateDate(new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date()));
		String[] paymentInfo = request.getParameterValues("paymentInfo");
		String jsonStr = mContractService.editContract(ct, paymentInfo);
		return jsonStr;
	}

	/**
	 * 删除合同
	 * 
	 */
	@RequestMapping(value = "/deleteContract", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String deleteContract(HttpServletRequest request) {
		mContractService = new ContractService();
		int id = Integer.parseInt(request.getParameter("id"));
		String updateDate = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date());
		String jsonStr = mContractService.deleteContract(id, updateDate);
		return jsonStr;
	}

	/**
	 * 删除派工
	 * 
	 */
	@RequestMapping(value = "/deleteProjectCase", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String deleteProjectCase(HttpServletRequest request) {
		mProjectService = new ProjectService();
		int id = Integer.parseInt(request.getParameter("id"));
		int salesId = Integer.parseInt(request.getParameter("salesId"));
		String updateDate = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date());
		String jsonStr = mProjectService.deleteProjectCase(id, updateDate);
		boolean errcode2 = ((String) new Gson().fromJson(jsonStr, Map.class).get("errcode")).equals("0");
		if(errcode2) {
			//获取派工id
			String projectJSONStr = mProjectService.getProjectCase(id);
			errcode2 = ((String) new Gson().fromJson(projectJSONStr, Map.class).get("errcode")).equals("0");
			if(errcode2) {
				JSONArray myArr = new JSONObject().fromObject(projectJSONStr).getJSONArray("projectCase");
				ProjectCase projectCase = (ProjectCase) JSONObject.toBean((JSONObject) myArr.get(0), ProjectCase.class);
				String projectName = request.getParameter("projectName");
				String companyName = request.getParameter("companyName");
				mUserService = new UserService();
				List<User> userList = new ArrayList<User>();
				String userJsonStr = mUserService.getUserById(salesId);
				String salesName = "";
				errcode2 = ((String) new Gson().fromJson(userJsonStr, Map.class).get("errcode")).equals("0");
				if(errcode2) {
					myArr = new JSONObject().fromObject(userJsonStr).getJSONArray("user");
					User mUser = (User) JSONObject.toBean((JSONObject) myArr.get(0), User.class);
					salesName = mUser.getName();
					//通知到销售部经理和销售本人
					if(mUser.getRoleId() != 3) {
						userList = mUserService.getUserListByIds(salesId + ",3");
					}else {
						userList = mUserService.getUserListByIds("3");
					}
					String accessToken = WeChatEnterpriseUtils.getAccessToken();
					WeChatEnterpriseUtils.sendProjectCaseInform(accessToken,projectCase,userList, companyName, projectName,salesName,2);
				}
			}
		}
		return jsonStr;
	}

	/**
	 * 编辑派工单
	 * 
	 * @throws IOException
	 * 
	 */
	@RequestMapping(value = "/editCaseRecord", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String editCaseRecord(HttpServletRequest request) throws IOException {
		mProjectService = new ProjectService();
		ProjectCase pc = new ProjectCase();
		pc.setId(Integer.parseInt(request.getParameter("id")));
		pc.setProjectId(request.getParameter("projectId"));
		pc.setSalesId(Integer.parseInt(request.getParameter("salesId")));
		pc.setCaseType(request.getParameter("caseType"));
		pc.setServiceDate(request.getParameter("serviceDate"));
		pc.setServiceEndDate(request.getParameter("serviceEndDate"));
		pc.setServiceType(Integer.parseInt(request.getParameter("serviceType")));
		pc.setServiceContent(request.getParameter("serviceContent"));
		pc.setDeviceInfo(request.getParameter("deviceInfo"));
		pc.setRejectReason(request.getParameter("rejectReason"));
		pc.setRemark(request.getParameter("remark"));
		String contactUsers = "";
		String[] arrayContactUsers = request.getParameterValues("contactUsers");
		for (int i = 0; i < arrayContactUsers.length; i++) {
			contactUsers += arrayContactUsers[i] + ",";
		}
		contactUsers = contactUsers.substring(0, contactUsers.length() - 1);
		pc.setContactUsers(contactUsers);

		String serviceUsers = "";
		String[] arrayServiceUsers = request.getParameterValues("serviceUsers");
		for (int i = 0; i < arrayServiceUsers.length; i++) {
			serviceUsers += arrayServiceUsers[i] + ",";
		}
		serviceUsers = serviceUsers.substring(0, serviceUsers.length() - 1).trim();
		pc.setServiceUsers(serviceUsers);
        int checkResult = Integer.parseInt(request.getParameter("checkResult"));
		int type = Integer.parseInt(request.getParameter("type"));
		String jsonStr = mProjectService.editCaseRecord(pc, checkResult, type);
		String accessToken = WeChatEnterpriseUtils.getAccessToken();
		String companyName = request.getParameter("companyName");
		String projectName = request.getParameter("projectName");
		// 审核派工通知 type 0.编辑1.销审2.技审
		mUserService = new UserService();
		List<User> userList = new ArrayList<User>();// 无论通不通过都通知的人
		List<User> userList2 = new ArrayList<User>();// 不通过将不会通知的人
		String userJsonStr = mUserService.getUserById(pc.getSalesId());
		String salesName = "";
		String serviceUsersName = "";
		boolean errcode2 = ((String) new Gson().fromJson(userJsonStr, Map.class).get("errcode")).equals("0");
		if (errcode2) {
			JSONArray myArr = new JSONObject().fromObject(userJsonStr).getJSONArray("user");
			User mUser = (User) JSONObject.toBean((JSONObject) myArr.get(0), User.class);
			salesName = mUser.getName();
			if (mUser.getRoleId() != 3) {
				userList = mUserService.getUserListByIds(pc.getSalesId() + ",3");
			} else {
				userList = mUserService.getUserListByIds("3");
			}
			if (type > 0) {
				userList2 = mUserService.getUserListByRoleId(10);
				if (checkResult == 1) {
					// 通过
					userList.addAll(userList2);
					if (type == 2) {
						userList2 = mUserService.getUserListByIds(pc.getServiceUsers());
						userList.addAll(userList2);
						for (int i = 0; i < userList2.size(); i++) {
							serviceUsersName += userList2.get(i).getName() + ",";
						}
						serviceUsersName = serviceUsersName.substring(0, serviceUsersName.length() - 1).trim();
					}
				} else {
					// 驳回
					if (type == 2) {
						userList.addAll(userList2);
					}
				}
			}
			if (type > 0) {
				WeChatEnterpriseUtils.sendProjectCaseInform(accessToken, pc, checkResult, type, userList, companyName,
						projectName, salesName, serviceUsersName);
			} else {
				WeChatEnterpriseUtils.sendProjectCaseInform(accessToken, pc, userList, companyName, projectName,
						salesName, 1);
			}
		}
		return jsonStr;
	}

	/**
	 * 编辑派工单
	 * 
	 */
	@RequestMapping(value = "/editProjectCase", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String editProjectCase(HttpServletRequest request) {
		mProjectService = new ProjectService();
		ProjectCase pc = new ProjectCase();
		pc.setId(Integer.parseInt(request.getParameter("id")));
		pc.setCaseState(Integer.parseInt(request.getParameter("caseState")));
		pc.setCancelReason(request.getParameter("cancelReason"));
		String jsonStr = mProjectService.editProjectCase(pc);
		return jsonStr;
	}

	/**
	 * 编辑用户
	 * 
	 */
	@RequestMapping(value = "/editUser", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String editUser(HttpServletRequest request) {
		mUserService = new UserService();
		User user = new User();
		user.setUId(Integer.parseInt(request.getParameter("id")));
		user.setName(request.getParameter("name"));
		user.setNickName(request.getParameter("nickName").trim());
		String psd = request.getParameter("psd");

		if (!psd.equals("") && psd != null) {
			psd = CommonUtils.encryptSHA256(request.getParameter("nickName") + "_" + psd);
		} else {
			psd = null;
		}
		user.setPassword(psd);
		user.setEmail(request.getParameter("email"));
		user.setDepartmentId(Integer.parseInt(request.getParameter("departmentId")));
		user.setTel(request.getParameter("tel"));
		user.setState(request.getParameter("state"));
		user.setRoleId(Integer.parseInt(request.getParameter("roleId")));
		user.setUpdateDate(new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date()));
		String jsonStr = mUserService.editUser(user);
		return jsonStr;
	}

	/**
	 * 修改用户密码
	 * 
	 */
	@RequestMapping(value = "/checkAndUpdateUserPsd", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String checkAndUpdateUserPsd(HttpServletRequest request) {
		mUserService = new UserService();
		String nickName = request.getParameter("nickName").trim();
		String oldPsd = request.getParameter("oldpsd");
		String newPsd = request.getParameter("newpsd");
		int uId = Integer.parseInt(request.getParameter("uId"));
		oldPsd = CommonUtils.encryptSHA256(nickName + "_" + oldPsd);
		newPsd = CommonUtils.encryptSHA256(nickName + "_" + newPsd);
		User user = new User();
		user.setNickName(nickName);
		user.setPassword(oldPsd);
		user.setUId(uId);
		int result = mUserService.queryUser(user);
		if (result == 0) {
			user.setPassword(newPsd);
			user.setDepartmentId(0);
			user.setRoleId(-1);
			user.setUpdateDate(new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date()));
			String jsonStr = mUserService.editUser(user);
			return jsonStr;
		} else {
			JSONObject jsonObject = new JSONObject();
			jsonObject.put("errcode", result);
			return jsonObject.toString();
		}
	}

	/**
	 * 编辑角色
	 * 
	 */
	@RequestMapping(value = "/editRole", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String editRole(HttpServletRequest request) {
		mService = new Service();
		Role role = new Role();
		role.setId(Integer.parseInt(request.getParameter("roleId")));
		role.setRoleName(request.getParameter("roleName"));
		String jsonStr = mService.editRole(role);
		return jsonStr;
	}

	/**
	 * 配置角色权限
	 * 
	 */
	@RequestMapping(value = "/updatePermissionSetting", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String updatePermissionSetting(HttpServletRequest request) {
		mService = new Service();
		PermissionSetting ps = new PermissionSetting();
		ps.setRoleId(Integer.parseInt(request.getParameter("roleId")));
		ps.setPermissionId(Integer.parseInt(request.getParameter("permissionId")));
		int operation = Integer.parseInt(request.getParameter("operation"));
		String jsonStr = null;
		if (operation == 1) {
			// create
			jsonStr = mService.createPermissionSetting(ps);
		} else if (operation == 2) {
			// delete
			jsonStr = mService.editPermissionSetting(ps);
		}
		return jsonStr;
	}

	/**
	 * 编辑用户考勤数据
	 * 
	 */
	@RequestMapping(value = "/editWorkAttendance", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String editWorkAttendance(HttpServletRequest request) {
		mService = new Service();
		DailyReport dr = new DailyReport();
		dr.setName(request.getParameter("name"));
		dr.setDate(request.getParameter("date"));
		dr.setSchedule(request.getParameter("schedule"));
		dr.setDailyReport(request.getParameter("dailyReport"));
		dr.setWeekReport(request.getParameter("weekReport"));
		dr.setNextWeekPlan(request.getParameter("nextWeekPlan"));
		dr.setProjectReport(request.getParameter("projectReport"));
		dr.setSign(request.getParameter("sign"));
		dr.setRemark(request.getParameter("remark"));
		dr.setOverWorkTime(Double.parseDouble(request.getParameter("overWorkTime")));
		dr.setAdjustRestTime(Double.parseDouble(request.getParameter("adjustRestTime")));
		dr.setFestivalOverWorkTime(Double.parseDouble(request.getParameter("festivalOverWorkTime")));
		dr.setIsLate(Integer.parseInt(request.getParameter("isLate")));
		String jsonStr = mService.editWorkAttendance(dr);
		return jsonStr;
	}

	/**
	 * 编辑用户考勤数据
	 * 
	 */
	@RequestMapping(value = "/deleteThisWorkAttendance", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String deleteWorkAttendance(HttpServletRequest request) {
		mService = new Service();
		String date = request.getParameter("date");
		String jsonStr = mService.deleteWorkAttendance(date);
		return jsonStr;
	}

	/**
	 * 编辑用户统计数据
	 * 
	 */
	@RequestMapping(value = "/editMonthAccumulateData", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String editMonthAccumulateData(HttpServletRequest request) {
		mService = new Service();
		MonthReport mr = new MonthReport();
		mr.setName(request.getParameter("userId"));
		mr.setAccumulateOverWorkTime(Double.parseDouble(request.getParameter("accumulateOverWorkTime")));
		mr.setAccumulateYearVacation(Double.parseDouble(request.getParameter("accumulateYearVacation")));
		// mr.setOverWorkTime4H(Double.parseDouble(request.getParameter("overWorkTime4H")));
		mr.setDate(request.getParameter("date"));
		String jsonStr = mService.queryMonthAccumulateData(mr);
		return jsonStr;
	}

	/**
	 * 删除招聘职位
	 * 
	 */
	@RequestMapping(value = "/deletePosition", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String deletePosition(HttpServletRequest request) {
		mService = new Service();
		int id = Integer.parseInt(request.getParameter("id"));
		String jsonStr = mService.deletePosition(id);
		return jsonStr;
	}

	/**
	 * 编辑招聘职位
	 * 
	 */
	@RequestMapping(value = "/editPosition", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String editPosition(HttpServletRequest request) {
		mService = new Service();
		JobPosition jp = new JobPosition();
		jp.setId(Integer.parseInt(request.getParameter("id")));
		jp.setJobTitle(request.getParameter("jobTitle"));
		jp.setTechDemand(request.getParameter("techDemand"));
		jp.setLevel(request.getParameter("level"));
		jp.setSalary(request.getParameter("salary"));
		jp.setLevel(request.getParameter("level"));
		jp.setSalary(request.getParameter("salary"));
		jp.setEducationDemand(request.getParameter("educationDemand"));
		jp.setOtherDemand(request.getParameter("otherDemand"));
		String jsonStr = mService.editPosition(jp);
		return jsonStr;
	}

	/**
	 * 编辑公司基本信息
	 * 
	 */
	@RequestMapping(value = "/editCompanyInfo", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String editCompanyInfo(HttpServletRequest request) {
		mService = new Service();
		String address = request.getParameter("address");
		String tel = request.getParameter("tel");
		String mail = request.getParameter("mail");
		String jsonStr = mService.editCompanyInfo(address, tel, mail);
		return jsonStr;
	}

	/**
	 * 编辑合作客户
	 * 
	 */
	@RequestMapping(value = "/editCooperateClient", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String editCooperateClient(HttpServletRequest request) {
		int opt = Integer.parseInt(request.getParameter("operation"));
		mService = new Service();
		Client c = new Client();
		if (opt == 1) {
			// 添加
			c.setClientName(request.getParameter("clientName"));
		} else {
			// 删除
			c.setClientId(Integer.parseInt(request.getParameter("clientId")));
		}
		String jsonStr = mService.editCooperateClient(c, opt);
		return jsonStr;
	}

	/**
	 * 更改所有合作客户
	 * 
	 */
	@RequestMapping(value = "/editAllCooperateClient", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String editAllCooperateClient(HttpServletRequest request) throws Exception {
		String ret = null;
		MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
		MultipartFile uploadFile = multipartRequest.getFile("file");
		File file = File.createTempFile("temp", null);
		if (!uploadFile.isEmpty()) {
			uploadFile.transferTo(file);
		}
		FileInputStream inStream = null;
		inStream = new FileInputStream(file);
		Sheet sheet = null;
		Workbook workBook = WorkbookFactory.create(inStream);
		sheet = workBook.getSheet("Sheet0");
		int numOfRows = sheet.getLastRowNum();
		mService = new Service();
		boolean result = mService.clearCooperateClient();
		if (result) {
			for (int i = 0; i <= numOfRows; i++) {
				Client c = new Client();
				String cName = CommonUtils.getExcelValue(sheet.getRow(i).getCell(0));
				c.setClientName(cName);
				mService.editCooperateClient(c, 1);
			}
			ret = "客户清单提交成功";
		} else {
			ret = "客户清单已清除提交失败";
		}
		file.deleteOnExit();
		inStream.close();
		return ret;
	}

	/**
	 * 编辑项目子状态
	 * 
	 */
	@RequestMapping(value = "/editProjectSubState", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String editProjectSubState(HttpServletRequest request) {
		mProjectService = new ProjectService();
		String[] arraySubState = request.getParameterValues("subStateArr");
		int projectType = Integer.parseInt(request.getParameter("projectType"));
		String jsonStr = mProjectService.editProjectSubState(projectType, arraySubState);
		return jsonStr;
	}

	/**
	 * 编辑客户详细信息
	 * 
	 */
	@RequestMapping(value = "/editClientDetailInfo", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String editClientDetailInfo(HttpServletRequest request) {
		mService = new Service();
		ClientDetailInfo cdi = new ClientDetailInfo();
		cdi.setCompanyId(request.getParameter("companyId"));
		cdi.setCompetitor(request.getParameter("competitor"));
		cdi.setCurrentProblem(request.getParameter("currentProblem"));
		cdi.setCurrentStateDesc(request.getParameter("currentStateDesc"));
		cdi.setLeftProblem(request.getParameter("leftProblem"));
		cdi.setPutPosition(request.getParameter("putPosition"));
		cdi.setDemand(request.getParameter("demand"));
		cdi.setSolution(request.getParameter("solution"));
		cdi.setSchedule(Integer.parseInt(request.getParameter("schedule")));
		cdi.setQualifications(request.getParameter("qualifications"));
		cdi.setUpdateDate(new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date()));
		String jsonStr = mService.editClientDetailInfo(cdi);
		return jsonStr;
	}

}
