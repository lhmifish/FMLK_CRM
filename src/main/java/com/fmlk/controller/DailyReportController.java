package com.fmlk.controller;

import java.io.File;
import java.io.FileInputStream;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import javax.servlet.http.HttpServletRequest;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import com.fmlk.entity.AssignmentOrder;
import com.fmlk.entity.DailyArrangement;
import com.fmlk.entity.DailyReport;
import com.fmlk.entity.DailyUploadReport;
import com.fmlk.entity.Tender;
import com.fmlk.entity.WechatCheck;
import com.fmlk.entity.WeekUploadReport;
import com.fmlk.entity.WorkTimeAdjust;
import com.fmlk.service.Service;
import com.fmlk.util.CommonUtils;
import com.fmlk.util.ExchangeMailUtil;
import com.fmlk.util.UpdateCheckList;
import com.google.gson.Gson;

@Controller
public class DailyReportController implements ApplicationContextAware {

	private ApplicationContext ctx;
	private Service service;

	@Override
	public void setApplicationContext(ApplicationContext arg0) throws BeansException {
		this.ctx = arg0;
	}
	
	/**
	 * 月统计
	 * 
	 */
	@RequestMapping(value = "/monthList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getMonthList(HttpServletRequest request) {
		service = new Service();
		String date = request.getParameter("date");
	    int dept = Integer.parseInt(request.getParameter("department"));
		String jsonStr = service.getMonthList(date, dept);
		return jsonStr;
	}

	/**
	 * 上传excel
	 * 
	 */
	@RequestMapping(value = "/addDailyReport", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String addDailyReport(HttpServletRequest request) throws Exception {
		MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
		MultipartFile uploadFile = multipartRequest.getFile("myFile");
		File file = null;
		Properties props = new Properties();
		String path = ExchangeMailUtil.class.getResource("/").getPath();
		path = path.substring(1, path.indexOf("WEB-INF/classes")) + "property/upload.properties";
		path = path.replaceAll("%20"," ");
		props.load(new FileInputStream(path));
		String saveFileDir = props.getProperty("upload.excelUrl");
		if (!uploadFile.isEmpty()) {
			file = CommonUtils.saveExcelFile(uploadFile, saveFileDir);
		}
		FileInputStream inStream = null;
		inStream = new FileInputStream(file);
		Sheet sheet = null;
		Workbook workBook = WorkbookFactory.create(inStream);
		sheet = workBook.getSheet("Sheet1");
		inStream.close();
		int numOfRows = sheet.getLastRowNum();
		service = new Service();
		for (int i = 1; i <= numOfRows; i++) {
			Row row = sheet.getRow(i);
			DailyReport dp = new DailyReport();
			dp.setDate(CommonUtils.getExcelValue(row.getCell(0)));
			dp.setName(CommonUtils.getExcelValue(row.getCell(1)));
			dp.setSchedule(CommonUtils.getExcelValue(row.getCell(2)));
			dp.setScheduleState(CommonUtils.getExcelValue(row.getCell(3)));
			dp.setDailyReport(CommonUtils.getExcelValue(row.getCell(4)));
			dp.setWeekReport(CommonUtils.getExcelValue(row.getCell(5)));
			dp.setNextWeekPlan(CommonUtils.getExcelValue(row.getCell(6)));
			dp.setCrmUpload(CommonUtils.getExcelValue(row.getCell(7)));
			dp.setProjectReport(CommonUtils.getExcelValue(row.getCell(8)));
			dp.setOthers(CommonUtils.getExcelValue(row.getCell(9)));
			dp.setSign(CommonUtils.getExcelValue(row.getCell(10)));
			dp.setRemark(CommonUtils.getExcelValue(row.getCell(11)));
			dp.setOverWorkTime(Double.parseDouble(CommonUtils.getExcelValue(row.getCell(12))));
			dp.setAdjustRestTime(Double.parseDouble(CommonUtils.getExcelValue(row.getCell(13))));
			dp.setVacationOverWorkTime(Double.parseDouble(CommonUtils.getExcelValue(row.getCell(14))));
			dp.setFestivalOverWorkTime(Double.parseDouble(CommonUtils.getExcelValue(row.getCell(15))));
			dp.setIsLate(Integer.parseInt(CommonUtils.getExcelValue(row.getCell(16))));
			service.add(dp);
		}
		return "日程上传成功";
	}

	

	/**
	 * 日统计
	 * 
	 */
	@RequestMapping(value = "/dailyList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getDailyList(HttpServletRequest request) {
		service = new Service();
		// 根据具体日期
		String date = request.getParameter("date");
		// 根据某个月份和某个人
		String date2 = request.getParameter("date2");
		String name = request.getParameter("name");
		String jsonStr = null;
		if (date.equals("")) {
			jsonStr = service.getDailyList(name, date2);
		} else {
			jsonStr = service.getDailyList(date);
		}
		return jsonStr;
	}

	/**
	 * 个人日统计
	 * 
	 */
	@RequestMapping(value = "/userDailyList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getUserDailyList(HttpServletRequest request) {
		service = new Service();
		// 根据某个月份和某个人
		String date2 = request.getParameter("date2");
		String name = request.getParameter("name");
		String jsonStr = service.getDailyList2(name, date2);
		return jsonStr;
	}

	/**
	 * 获取微信一天所有的签到记录
	 * 
	 */
	@RequestMapping(value = "/wechatList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getWechatCheckList(HttpServletRequest request) {
		service = new Service();
		String date = request.getParameter("date");
		int dept = Integer.parseInt(request.getParameter("department"));
		String jsonStr = service.getWechatCheckList(date, dept);
		return jsonStr;
	}

	/**
	 * 获取公司的打卡记录
	 * 
	 */
	@RequestMapping(value = "/cardList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getCardCheckList(HttpServletRequest request) {
		service = new Service();
		String date = request.getParameter("date");
		int dept = Integer.parseInt(request.getParameter("department"));
		String jsonStr = service.getCardCheckList(date, dept);
		return jsonStr;
	}

	/**
	 * 获取公司的打卡记录
	 * 
	 */
	@RequestMapping(value = "/allCheckList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getAllUserCheckList(HttpServletRequest request) {
		service = new Service();
		String date = request.getParameter("date");
		int dept = Integer.parseInt(request.getParameter("department"));
		String jsonStr = service.getAllCheckList(date, dept);
		return jsonStr;
	}

	/**
	 * 获取微信一天所有的签到记录按人的统计
	 * 
	 */
	@RequestMapping(value = "/wechatUserList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getWechatUserList(HttpServletRequest request) {
		service = new Service();
		String date = request.getParameter("date");
		String jsonStr = service.getWechatUserList(date);
		return jsonStr;
	}
	
	/**
	 * 获取一周日程安排
	 * 
	 */
	@RequestMapping(value = "/weekPlanDetails", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getWeekPlanDetails(HttpServletRequest request) {
		service = new Service();
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		String jsonStr = service.getWeekPlanDetails(startDate,endDate);
		return jsonStr;
	}

	/////////////////////////////////

	@RequestMapping(value = "/checkList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getCheckList(HttpServletRequest request) {
		service = new Service();
		String date = request.getParameter("date");
		String jsonStr = service.getCheckList(date);
		return jsonStr;
	}

	@RequestMapping(value = "/saveCheck", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String saveCheck(HttpServletRequest request) throws ParseException {
		service = new Service();
		// System.out.println("step1 "+request.getParameterValues("arr").length);
		String date = request.getParameter("date");
		String[] arr = request.getParameterValues("arr");
		ArrayList<WechatCheck> list = new ArrayList<WechatCheck>();
		boolean isSaved = UpdateCheckList.getList(arr, date);
		return "0";
	}

	@RequestMapping(value = "/checkErrorList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getCheckErrorList(HttpServletRequest request) {
		service = new Service();
		String date = request.getParameter("date");
		String jsonStr = service.getCheckErrorList(date);
		return jsonStr;
	}

	@RequestMapping(value = "/sendMail", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String sendMail(HttpServletRequest request) {
		String[] arr = request.getParameterValues("arr");
		// ExchangeMailUtil.send("用户", "09:32:22", "10:02:02", 1, "mail", "2018/03/07");
		List<WechatCheck> list = new ArrayList<WechatCheck>();
		for (int i = 0; i < arr.length; i++) {
			String[] obj = arr[i].split("#");
			WechatCheck wc = new WechatCheck();
			wc.setDate(obj[0]);
			wc.setUserName(obj[1]);
			wc.setCheckFlag(obj[2]);
			wc.setCheckTime(obj[3]);
			wc.setAddress(obj[4]);
			wc.setId(Integer.parseInt(obj[5]));
			list.add(wc);
		}
		String hostUrl = request.getRequestURL().toString().replace("sendMail", "").trim();
		ExchangeMailUtil.send(list, hostUrl);
		return "";
	}

	@RequestMapping(value = "/checkUpdate/{state}/{checkId}", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String checkUpdate(HttpServletRequest request, @PathVariable(value = "state") int state,
			@PathVariable(value = "checkId") int checkId) {
		service = new Service();
		String result = service.checkUpdate(state, checkId);
		if (new Gson().fromJson(result, Map.class).get("errcode").equals("0")) {
			WechatCheck wCheck = new WechatCheck();
			wCheck = service.getWechatCheck(checkId);
			String name = wCheck.getUserName();
			String checkTime = wCheck.getCheckTime();
			if (state == 2) {
				return "你修改的员工" + name + " 考勤时间为" + checkTime + " 确认为合规";
			} else if (state == 1) {
				return "你修改的员工" + name + " 考勤时间为" + checkTime + " 确认为不合规";
			}
		} else {
			return "修改失败";
		}
		return result;

	}
	
	/**
	 * 考勤统计
	 * 
	 */
	@RequestMapping(value = "/statisticsList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getStatisticsList(HttpServletRequest request) {
		service = new Service();
		String date = request.getParameter("date");
		int dept = Integer.parseInt(request.getParameter("department"));
		String jsonStr = service.getStatisticsList(date, dept);
		return jsonStr;
	}
	
	
	
	
	/**
	 * 通过用户名获取用户信息
	 * 
	 */
/*	@RequestMapping(value = "/getUserInfoByNickName", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getUserInfoByNickName(HttpServletRequest request) {
		service = new Service();
		String uName = request.getParameter("name");
		String jsonStr = service.getUserInfoByNickName(uName);
	    return jsonStr;
	}*/
	
	/**
	 * 拼音名获取用户信息
	 * 
	 */
	@RequestMapping(value = "/getUserName", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getUserName(HttpServletRequest request) {
		service = new Service();
		String nickName = request.getParameter("uID");
		String jsonStr = service.getUserName(nickName);
		return jsonStr;
	}
	
	/**
	 * 获取项目经理的客户公司
	 * 
	 */
	@RequestMapping(value = "/getClientCompany", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getClientCompany(HttpServletRequest request) {
		service = new Service();
		String jsonStr = service.getClientCompany();
	    return jsonStr;
	}
	
	/**
	 * 获取客户公司的所有项目
	 * 
	 */
	@RequestMapping(value = "/getProjectList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getProjectList(HttpServletRequest request) {
		service = new Service();
		String companyId = request.getParameter("companyId");
		String jsonStr = service.getProjectList(companyId);
	    return jsonStr;
	}
	
	/**
	 * 获取客户公司的联系人
	 * 
	 */
	@RequestMapping(value = "/getContactList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getContactList(HttpServletRequest request) {
		service = new Service();
		String companyId = request.getParameter("companyId");
		String jsonStr = service.getContactList(companyId);
	    return jsonStr;
	}
	
	/**
	 * 保存新的事务单
	 * 
	 */
	@RequestMapping(value = "/createNewAssignment", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String createNewAssignment(HttpServletRequest request) {
		String dateNow = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date());
		service = new Service();
		String name = request.getParameter("name");
		String company = request.getParameter("company");
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		String projectName = request.getParameter("projectName");
		String serviceContent = request.getParameter("serviceContent");
		String contact = request.getParameter("contact");
		String[] member = request.getParameterValues("member");
		String userList="";
		for(int i=0;i<member.length;i++) {
			userList += member[i] + ",";
		}
		userList = userList.substring(0, userList.length()-1);
		int projectState = Integer.parseInt(request.getParameter("projectState"));
		int rank = Integer.parseInt(request.getParameter("projectRank"));
		AssignmentOrder ao = new AssignmentOrder();
		ao.setClientCompany(company);
		ao.setClientContact(contact);
		ao.setProjectName(projectName);
		ao.setName(name);
		ao.setDate(dateNow);
		ao.setStartDate(startDate);
		ao.setEndDate(endDate);
		ao.setServiceContent(serviceContent);
		ao.setUserList(userList);
		ao.setState(projectState);
		ao.setRank(rank);
		String jsonStr = service.createNewAssignment(ao);
	    return jsonStr;
	}
	
	
	/**
	 * 获取所有事务列表
	 * 
	 */
	@RequestMapping(value = "/getAssignmentList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getAssignmentList(HttpServletRequest request) {
		service = new Service();
		String jsonStr = service.getAssignmentList();
		return jsonStr;
	}
	
	/**
	 * 获取所有事务列表
	 * 
	 */
	@RequestMapping(value = "/getAssignmentList2", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getAssignmentList2(HttpServletRequest request) {
		service = new Service();
		String saleUser = request.getParameter("saleUser").trim();
		String techUser = request.getParameter("techUser").trim();
		String clientCompany = request.getParameter("company").trim();
		String jsonStr = service.getAssignmentList(saleUser,techUser,clientCompany);
		return jsonStr;
	}
	
	/**
	 * 查看事务信息
	 * 
	 */
	@RequestMapping(value = "/getAssignment", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getAssignment(HttpServletRequest request) {
		service = new Service();
		String sId = request.getParameter("assignmentId");
		String jsonStr = service.getAssignment(sId);
		return jsonStr;
	}
	
	/**
	 * 保存新的事务单
	 * 
	 */
	@RequestMapping(value = "/editAssignment", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String editAssignment(HttpServletRequest request) {
		service = new Service();
		String name = request.getParameter("name");
		String company = request.getParameter("company");
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		String projectName = request.getParameter("projectName");
		String serviceContent = request.getParameter("serviceContent");
		String contact = request.getParameter("contact");
		String[] member = request.getParameterValues("member");
		String userList="";
		for(int i=0;i<member.length;i++) {
			userList += member[i] + ",";
		}
		userList = userList.substring(0, userList.length()-1);
		int projectState = Integer.parseInt(request.getParameter("projectState"));
		int rank = Integer.parseInt(request.getParameter("projectRank"));
		int id = Integer.parseInt(request.getParameter("assignmentId"));
		AssignmentOrder ao = new AssignmentOrder();
		ao.setId(id);
		ao.setClientCompany(company);
		ao.setClientContact(contact);
		ao.setProjectName(projectName);
		ao.setName(name);
		ao.setStartDate(startDate);
		ao.setEndDate(endDate);
		ao.setServiceContent(serviceContent);
		ao.setUserList(userList);
		ao.setState(projectState);
		ao.setRank(rank);
		String jsonStr = service.editAssignment(ao);
	    return jsonStr;
	}
	
	/**
	 * 查看更多事务信息
	 * 
	 */
	@RequestMapping(value = "/getMoreAssignmentList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getMoreAssignmentList(HttpServletRequest request) {
		service = new Service();
		int type = Integer.parseInt(request.getParameter("type"));
		String jsonStr = service.getMoreAssignmentList(type);
		return jsonStr;
	}
	
	/**
	 * 查看更多事务信息
	 * 
	 */
	@RequestMapping(value = "/getMoreAssignmentList2", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getMoreAssignmentList2(HttpServletRequest request) {
		service = new Service();
		int type = Integer.parseInt(request.getParameter("type"));
		String saleUser = request.getParameter("saleUser").trim();
		String techUser = request.getParameter("techUser").trim();
		String clientCompany = request.getParameter("company").trim();
		String jsonStr = service.getMoreAssignmentList(type,saleUser,techUser,clientCompany);
		return jsonStr;
	}
	
	/**
	 * 获取数据库原始派工单
	 * 
	 */
/*	@RequestMapping(value = "/dataSourceAssignmentList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getDataSourceAssignmentList(HttpServletRequest request) {
		service = new Service();
		String jsonStr = service.getDataSourceAssignmentList();
		return jsonStr;
	}*/

	/********************************************************************************/
	
	
	
	/**
	 * 员工创建日报
	 * 
	 */
	@RequestMapping(value = "/createDailyUploadReport", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String createDailyUploadReport(HttpServletRequest request) {
		service = new Service();
		DailyUploadReport dur = new DailyUploadReport();
		dur.setUserName(request.getParameter("userName"));
		dur.setDate(request.getParameter("date"));
		dur.setClient(request.getParameter("client"));
	    dur.setCrmNum(request.getParameter("crmNum"));
		dur.setJobContent(request.getParameter("jobContent"));
	    dur.setTime(request.getParameter("time"));
		String jsonStr = service.createDailyUploadReport(dur);
		return jsonStr;
	}
	
	/**
	 * 拼音名获取用户信息
	 * 
	 */
	@RequestMapping(value = "/getDailyUploadReportList/{uId}/", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getUserName(HttpServletRequest request, @PathVariable(value = "uId") String nickName) {
		service = new Service();
		String jsonStr = service.getDailyUploadReportList(nickName);
		return jsonStr;
	}
	
	/**
	 * 根据id获取日报
	 * 
	 */
	@RequestMapping(value = "/getDailyUploadReport", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getDailyUploadReport(HttpServletRequest request) {
		service = new Service();
	//	String userName = request.getParameter("userName");
		int id = Integer.parseInt(request.getParameter("id"));
		String jsonStr = service.getDailyUploadReport(id);
		return jsonStr;
	}
	
	/**
	 * 编辑日报
	 * 
	 */
	@RequestMapping(value = "/editDailyUploadReport", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String editDailyUploadReport(HttpServletRequest request) {
		service = new Service();
		DailyUploadReport dur = new DailyUploadReport();
		dur.setId(Integer.parseInt(request.getParameter("id")));
		dur.setUserName(request.getParameter("userName"));
		dur.setDate(request.getParameter("date"));
		dur.setJobType(request.getParameter("jobType"));
		dur.setClient(request.getParameter("client"));
		dur.setClientUser(request.getParameter("clientUser"));
		dur.setCrmNum(request.getParameter("crmNum"));
		dur.setJobContent(request.getParameter("jobContent"));
		dur.setLaterSupport(request.getParameter("laterSupport"));
		dur.setRemark(request.getParameter("remark"));
		dur.setTime(request.getParameter("time"));
		String jsonStr = service.editDailyUploadReport(dur);
		return jsonStr;
	}
	
	/**
	 * 员工创建日程
	 * 
	 */
	@RequestMapping(value = "/createDailyArrangement", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String createDailyArrangement(HttpServletRequest request) {
		service = new Service();
		DailyArrangement da = new DailyArrangement();
		da.setUserName(request.getParameter("userName"));
		da.setTime(request.getParameter("time"));
		da.setAccident(request.getParameter("accident"));
		da.setClient(request.getParameter("client"));
		da.setAddress(request.getParameter("address"));
		String jsonStr = service.createDailyArrangement(da);
		return jsonStr;
	}
	
	
	
	/**
	 * 获取员工日报列表
	 * 
	 */
	@RequestMapping(value = "/getAllDailyUploadReportList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getAllDailyUploadReportList(HttpServletRequest request) {
		service = new Service();
		String date = request.getParameter("date");
		String jsonStr = service.getAllDailyUploadReportList(date);
	    return jsonStr;
	}
	
	/**
	 * 根据id获取日报
	 * 
	 */
	@RequestMapping(value = "/getArrangement", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getArrangement(HttpServletRequest request) {
		service = new Service();
	    int id = Integer.parseInt(request.getParameter("id"));
		String jsonStr = service.getArrangement(id);
		return jsonStr;
	}
	
	/**
	 * 编辑日程
	 * 
	 */
	@RequestMapping(value = "/editArrangement", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String editArrangement(HttpServletRequest request) {
		service = new Service();
		DailyArrangement da = new DailyArrangement();
		da.setId(Integer.parseInt(request.getParameter("id")));
		da.setUserName(request.getParameter("userName"));
		da.setClient(request.getParameter("client"));
		da.setAddress(request.getParameter("address"));
		da.setAccident(request.getParameter("accident"));
		da.setTime(request.getParameter("time"));
		String jsonStr = service.editArrangement(da);
		return jsonStr;
	}
	
	/**
	 * 	根据crm编号获取项目名称
	 * 
	 */
	@RequestMapping(value = "/getProjectName", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getProjectName(HttpServletRequest request) {
		service = new Service();
		String CRMNum= request.getParameter("crmNum");
		String jsonStr = service.getProjectName(CRMNum);
		return jsonStr;
	}
	
/*	*//**
	 * 	根据姓名和日期获取日报列表
	 * 
	 *//*
	@RequestMapping(value = "/getOtherInfo", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getOtherInfo(HttpServletRequest request) {
		service = new Service();
		String userName= request.getParameter("userName");
		String startDate= request.getParameter("date");//本周
		String endDate= request.getParameter("date2");
		String startDate2= request.getParameter("lastDate");//上周
		String endDate2= request.getParameter("lastDate2");
		String jsonStr = service.getOtherInfo(userName,startDate,endDate,startDate2,endDate2);
		return jsonStr;
	}*/
	
	/**
	 * 员工创建周报
	 * 
	 */
	@RequestMapping(value = "/createWeekReport", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String createWeekReport(HttpServletRequest request) {
		service = new Service();
		WeekUploadReport wur = new WeekUploadReport();
		wur.setUserName(request.getParameter("userName"));
		wur.setStartDate(request.getParameter("startDate"));
		wur.setEndDate(request.getParameter("endDate"));
		wur.setWeekReport(request.getParameter("weekReport"));
		String jsonStr = service.createWeekReport(wur);
		return jsonStr;
	}
	
	/**
	 * 获取员工周报列表
	 * 2019.10.30修改
	 */
	@RequestMapping(value = "/getAllWeekUploadReportList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getAllWeekUploadReportList(HttpServletRequest request) {
		service = new Service();
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		String jsonStr = service.getAllWeekUploadReportList(startDate,endDate);
		System.out.println(jsonStr);
	    return jsonStr;
	}
	
	/**
	 * 获取员工整年日报
	 * 2021.11.2修改
	 */
	@RequestMapping(value = "/getUserYearUploadReportList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getUserYearUploadReportList(HttpServletRequest request) {
		service = new Service();
		int year = Integer.parseInt(request.getParameter("year"));
		String userNickName = request.getParameter("nickName");
		String jsonStr = service.getUserYearUploadReportList(year,userNickName);
		System.out.println(jsonStr);
		return jsonStr;
	}
	
	/**
	 * 获取员工日报列表
	 * 
	 */
	@RequestMapping(value = "/getDailyUploadReportList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getDailyUploadReportList(HttpServletRequest request) {
		service = new Service();
		String userName = request.getParameter("userName");
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		String jsonStr = service.getDailyUploadReportList(userName,startDate,endDate);
	    return jsonStr;
	}
	
	/**
	 * 获取员工周报
	 * 
	 */
	@RequestMapping(value = "/getWeekUploadReport", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getWeekUploadReport(HttpServletRequest request) {
		service = new Service();
		String userName = request.getParameter("userName");
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		String jsonStr = service.getWeekUploadReport(userName,startDate,endDate);
	    return jsonStr;
	}
	
	/**
	 * 获取员工周报
	 * 
	 */
	@RequestMapping(value = "/getWeekUploadReport2", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getWeekUploadReport2(HttpServletRequest request) {
		service = new Service();
		int id = Integer.parseInt(request.getParameter("id"));
		String jsonStr = service.getWeekUploadReport(id);
	    return jsonStr;
	}
	
	/**
	 * 编辑周报
	 * 
	 */
	@RequestMapping(value = "/editWeekUploadReport", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String editWeekUploadReport(HttpServletRequest request) {
		service = new Service();
		WeekUploadReport wur = new WeekUploadReport();
		wur.setId(Integer.parseInt(request.getParameter("id")));
		wur.setUserName(request.getParameter("userName"));
		wur.setStartDate(request.getParameter("startDate"));
		wur.setEndDate(request.getParameter("endDate"));
		wur.setWeekReport(request.getParameter("weekReport"));
		String jsonStr = service.editWeekUploadReport(wur);
		return jsonStr;
	}
	
	/**
	 * 获取加班请假统计记录
	 * 
	 */
	@RequestMapping(value = "/workTimeAdjustList", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getWorkTimeAdjustList(HttpServletRequest request) {
		service = new Service();
		String date = request.getParameter("date");
	    int dept = Integer.parseInt(request.getParameter("departmentId"));
		String jsonStr = service.getWorkTimeAdjustList(date, dept);
		return jsonStr;
	}
	
	/**
	 * 获取某个人上月的累计加班数
	 * 
	 */
	@RequestMapping(value = "/getLastMonthTotal", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getLastMonthTotal(HttpServletRequest request) {
		service = new Service();
		String date = request.getParameter("date");
	    String name = request.getParameter("name");
		String jsonStr = service.getLastMonthTotal(name, date);
		return jsonStr;
	}
	
	/**
	 * 保存或编辑累计加班数
	 * 
	 */
	@RequestMapping(value = "/updateWorkTimeAdjust", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String updateWorkTimeAdjust(HttpServletRequest request) {
		service = new Service();
		WorkTimeAdjust wta = new WorkTimeAdjust();
	    wta.setName(request.getParameter("name"));
	    wta.setDate(request.getParameter("date"));
	    wta.setActualOverWorkTime(Double.parseDouble(request.getParameter("actualOverWorkTime")));
	    wta.setActualOverWorkTime4H(Double.parseDouble(request.getParameter("actualOverWorkTime4H")));
	    wta.setApprovedRest(Double.parseDouble(request.getParameter("approvedRest")));
	    wta.setLastMonthTotal(Double.parseDouble(request.getParameter("lastMonthTotal")));
	    wta.setThisMonthTotal(Double.parseDouble(request.getParameter("thisMonthTotal")));
	    String jsonStr = service.updateWorkTimeAdjust(wta);
		return jsonStr;
	}
	
	/**
	 * 获取某个人本月的累计加班数
	 * 
	 */
	@RequestMapping(value = "/getThisMonthTotal", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getThisMonthTotal(HttpServletRequest request) {
		service = new Service();
		String date = request.getParameter("date");
	    String name = request.getParameter("name");
		String jsonStr = service.getThisMonthTotal(name, date);
		return jsonStr;
	}
	
	/**
	 * 审核标书
	 * 
	 */
	@RequestMapping(value = "/confirmTender", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String confirmTender(HttpServletRequest request) {
		service = new Service();
		Tender tender = new Tender();
		tender.setId(Integer.parseInt(request.getParameter("id")));
		tender.setTenderNum(request.getParameter("tenderNum"));
		tender.setTenderState(Integer.parseInt(request.getParameter("tenderState")));
		String jsonStr = service.confirmTender(tender);
		return jsonStr;
	}
	
	
	/**
	 * 创建代理
	 * 
	 */
	@RequestMapping(value = "/createAgency", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String createAgency(HttpServletRequest request) {
		service = new Service();
		String jsonStr = service.createAgency(request.getParameter("agencyName"));
		return jsonStr;
	}
	
    /**
	 * 获取行业
	 * 
	 */
	@RequestMapping(value = "/getClientField", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getClientField(HttpServletRequest request) {
		service = new Service();
		int fieldId = Integer.parseInt(request.getParameter("fieldId"));
		String jsonStr = service.getClientField(fieldId);
	    return jsonStr;
	}
	
	/**
	 * 获取区域
	 * 
	 */
	@RequestMapping(value = "/getArea", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String getArea(HttpServletRequest request) {
		service = new Service();
		int areaId = Integer.parseInt(request.getParameter("areaId"));
		String jsonStr = service.getArea(areaId);
	    return jsonStr;
	}
	
}
