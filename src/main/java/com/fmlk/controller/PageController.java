package com.fmlk.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import com.fmlk.util.WeChatEnterpriseUtils;
import com.fmlk.util.WeiXinEnterpriseUtils;

@Controller
public class PageController implements ApplicationContextAware {

	private ApplicationContext ctx;

	@Override
	public void setApplicationContext(ApplicationContext arg0) throws BeansException {
		this.ctx = arg0;
	}

	@RequestMapping(value = "/page/login", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getLoginPage(HttpServletRequest request, HttpSession session) {
		session.setAttribute("web_userid", null);
		ModelAndView mav = new ModelAndView("login");
		return mav;
	}

	@RequestMapping(value = "/page/index", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getIndexPage(HttpServletRequest request, HttpSession session) {
		String uId = (String) session.getAttribute("web_userid");
		ModelAndView mav = new ModelAndView("index");
		mav.addObject("sessionId", uId);
		return mav;
	}

	@RequestMapping(value = "/page/left", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getLeftPage(HttpServletRequest request, HttpSession session) {
		String uId = (String) session.getAttribute("web_userid");
		ModelAndView mav = new ModelAndView("left");
		mav.addObject("sessionId", uId);
		return mav;
	}

	@RequestMapping(value = "/page/head", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getHeadPage(HttpServletRequest request, HttpSession session) {
		String uId = (String) session.getAttribute("web_userid");
		ModelAndView mav = new ModelAndView("head");
		mav.addObject("sessionId", uId);
		return mav;
	}

	@RequestMapping(value = "/page/techJobList", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getTechJobListPage(HttpServletRequest request, HttpSession session) {
		String uId = (String) session.getAttribute("web_userid");
		ModelAndView mav = new ModelAndView("TechJobList");
		mav.addObject("sessionId", uId);
		return mav;
	}

	@RequestMapping(value = "/page/error", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getErrorPage(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("Error");
		return mav;
	}

	/*********** company *************/

	@RequestMapping(value = "/page/createCompany", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getCreateCompanyPage(HttpServletRequest request, HttpSession session) {
		String uId = (String) session.getAttribute("web_userid");
		ModelAndView mav = new ModelAndView("CreateCompany");
		mav.addObject("sessionId", uId);
		return mav;
	}

	@RequestMapping(value = "/page/companyList", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getCompanyListPage(HttpServletRequest request, HttpSession session) {
		String uId = (String) session.getAttribute("web_userid");
		ModelAndView mav = new ModelAndView("CompanyList");
		mav.addObject("sessionId", uId);
		return mav;
	}

	@RequestMapping(value = "/page/editCompany/{companyId}", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getEditCompanyPage(HttpServletRequest request, @PathVariable(value = "companyId") int id,
			HttpSession session) {
		String uId = (String) session.getAttribute("web_userid");
		ModelAndView mav = new ModelAndView("EditCompany");
		mav.addObject("mId", id);
		mav.addObject("sessionId", uId);
		return mav;
	}

	@RequestMapping(value = "/page/confirmCompany", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getConfirmCompanyPage(HttpServletRequest request, HttpSession session) {
		String uId = (String) session.getAttribute("web_userid");
		ModelAndView mav = new ModelAndView("ConfirmCompany");
		mav.addObject("sessionId", uId);
		return mav;
	}

	/*********** project *************/

	@RequestMapping(value = "/page/createProject", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getCreateProjectPage(HttpServletRequest request, HttpSession session) {
		String uId = (String) session.getAttribute("web_userid");
		ModelAndView mav = new ModelAndView("CreateProject");
		mav.addObject("sessionId", uId);
		return mav;
	}

	@RequestMapping(value = "/page/projectList", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getProjectListPage(HttpServletRequest request, HttpSession session) {
		String uId = (String) session.getAttribute("web_userid");
		ModelAndView mav = new ModelAndView("ProjectList");
		mav.addObject("sessionId", uId);
		return mav;
	}

	@RequestMapping(value = "/page/editProject/{projectId}", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getEditProjectPage(HttpServletRequest request, @PathVariable(value = "projectId") int id,
			HttpSession session) {
		String uId = (String) session.getAttribute("web_userid");
		ModelAndView mav = new ModelAndView("EditProject");
		mav.addObject("mId", id);
		mav.addObject("sessionId", uId);
		return mav;
	}

	@RequestMapping(value = "/page/confirmProject", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getConfirmProjectPage(HttpServletRequest request, HttpSession session) {
		String uId = (String) session.getAttribute("web_userid");
		ModelAndView mav = new ModelAndView("ConfirmProject");
		mav.addObject("sessionId", uId);
		return mav;
	}

	/*********** projectCase *************/

	@RequestMapping(value = "/page/createProjectCase", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getCreateProjectCasePage(HttpServletRequest request, HttpSession session) {
		String uId = (String) session.getAttribute("web_userid");
		ModelAndView mav = new ModelAndView("CreateProjectCase");
		mav.addObject("sessionId", uId);
		return mav;
	}

	@RequestMapping(value = "/page/projectCaseList", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getProjectCaseListPage(HttpServletRequest request, HttpSession session) {
		String uId = (String) session.getAttribute("web_userid");
		ModelAndView mav = new ModelAndView("ProjectCaseList");
		mav.addObject("sessionId", uId);
		return mav;
	}

	@RequestMapping(value = "/page/projectCaseUnClosedList/{year}/{month}", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getProjectCaseUnClosedListPage(HttpServletRequest request, HttpSession session,
			@PathVariable(value = "year") int mYear, @PathVariable(value = "month") int mMonth) {
		String uId = (String) session.getAttribute("web_userid");
		ModelAndView mav = new ModelAndView("ProjectCaseUnClosedList");
		if (uId != null && !uId.equals("")) {
			mav.addObject("sessionId", uId);
		} else {

			/*
			 * String accessToken =
			 * WeiXinEnterpriseUtils.getAccessToken("wxfca99e2643b26241",
			 * "Ki7b7dlx5TE2tAgpZ8mm0hXRJNGnA_wEkM2TSRkkXC4");
			 */

			String accessToken = WeChatEnterpriseUtils.getAccessToken();
			String wechatUserId = WeChatEnterpriseUtils.getWechatUserId(accessToken, request.getParameter("code"));
			mav.addObject("sessionId", wechatUserId);
		}
		mav.addObject("date", mYear + "/" + mMonth);
		return mav;
	}

	@RequestMapping(value = "/page/checkProjectCase", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getCheckProjectCasePage(HttpServletRequest request, HttpSession session) {
		String uId = (String) session.getAttribute("web_userid");
		ModelAndView mav = new ModelAndView("CheckProjectCase");
		mav.addObject("sessionId", uId);
		return mav;
	}

	@RequestMapping(value = "/page/dispatchProjectCase", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getDispatchProjectCasePage(HttpServletRequest request, HttpSession session) {
		String uId = (String) session.getAttribute("web_userid");
		ModelAndView mav = new ModelAndView("DispatchProjectCase");
		mav.addObject("sessionId", uId);
		return mav;
	}

	@RequestMapping(value = "/page/editProjectCase/{type}/{id}", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getEditProjectCasePage(HttpServletRequest request, @PathVariable(value = "id") int id,
			@PathVariable(value = "type") int type, HttpSession session) {
		String uId = (String) session.getAttribute("web_userid");
		ModelAndView mav = new ModelAndView("EditProjectCase");
		mav.addObject("mId", id);
		mav.addObject("mType", type);
		if (uId != null && !uId.equals("")) {
			mav.addObject("sessionId", uId);
		} else {
			/*
			 * String accessToken =
			 * WeiXinEnterpriseUtils.getAccessToken("wxfca99e2643b26241",
			 * "Ki7b7dlx5TE2tAgpZ8mm0hXRJNGnA_wEkM2TSRkkXC4");
			 */
			String accessToken = WeChatEnterpriseUtils.getAccessToken();
			String wechatUserId = WeChatEnterpriseUtils.getWechatUserId(accessToken, request.getParameter("code"));
			mav.addObject("sessionId", wechatUserId);
		}
		return mav;
	}

	@RequestMapping(value = "/page/editProjectCaseMobile/{type}/{id}", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getEditProjectCaseMobilePage(HttpServletRequest request, @PathVariable(value = "id") int id,
			@PathVariable(value = "type") int type, HttpSession session) {
		String uId = (String) session.getAttribute("web_userid");
		ModelAndView mav = new ModelAndView("MobileEditProjectCase");
		mav.addObject("mId", id);
		mav.addObject("mType", type);
		if (uId != null && !uId.equals("")) {
			mav.addObject("sessionId", uId);
		} else {
			/*
			 * String accessToken =
			 * WeiXinEnterpriseUtils.getAccessToken("wxfca99e2643b26241",
			 * "Ki7b7dlx5TE2tAgpZ8mm0hXRJNGnA_wEkM2TSRkkXC4");
			 */
			String accessToken = WeChatEnterpriseUtils.getAccessToken();
			String wechatUserId = WeChatEnterpriseUtils.getWechatUserId(accessToken, request.getParameter("code"));
			mav.addObject("sessionId", wechatUserId);
		}
		return mav;
	}

	/*********** tender *************/

	@RequestMapping(value = "/page/createTender", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getCreateTenderPage(HttpServletRequest request, HttpSession session) {
		String uId = (String) session.getAttribute("web_userid");
		ModelAndView mav = new ModelAndView("CreateTender");
		mav.addObject("sessionId", uId);
		return mav;
	}

	@RequestMapping(value = "/page/tenderList", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getTenderListPage(HttpServletRequest request, HttpSession session) {
		String uId = (String) session.getAttribute("web_userid");
		ModelAndView mav = new ModelAndView("TenderList");
		mav.addObject("sessionId", uId);
		return mav;
	}

	@RequestMapping(value = "/page/confirmTender", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getConfirmTenderPage(HttpServletRequest request, HttpSession session) {
		String uId = (String) session.getAttribute("web_userid");
		ModelAndView mav = new ModelAndView("ConfirmTender");
		mav.addObject("sessionId", uId);
		return mav;
	}

	@RequestMapping(value = "/page/editTender/{id}", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getEditTenderPage(HttpServletRequest request, @PathVariable(value = "id") int id,
			HttpSession session) {
		String uId = (String) session.getAttribute("web_userid");
		ModelAndView mav = new ModelAndView("EditTender");
		mav.addObject("mId", id);
		mav.addObject("sessionId", uId);
		return mav;
	}

	/*********** contract *************/

	@RequestMapping(value = "/page/createContract", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getCreateContractPage(HttpServletRequest request, HttpSession session) {
		String uId = (String) session.getAttribute("web_userid");
		ModelAndView mav = new ModelAndView("CreateContract");
		mav.addObject("sessionId", uId);
		return mav;
	}

	@RequestMapping(value = "/page/contractList", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getContractListPage(HttpServletRequest request, HttpSession session) {
		String uId = (String) session.getAttribute("web_userid");
		ModelAndView mav = new ModelAndView("ContractList");
		mav.addObject("sessionId", uId);
		return mav;
	}

	/*********** WorkAttendance *************/
	@RequestMapping(value = "/page/userWorkAttendanceList", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getUserWorkAttendanceListPage(HttpServletRequest request, HttpSession session) {
		String uId = (String) session.getAttribute("web_userid");
		ModelAndView mav = new ModelAndView("UserWorkAttendance");
		mav.addObject("sessionId", uId);
		return mav;
	}

	@RequestMapping(value = "/page/allWorkAttendanceList", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getAllWorkAttendanceListPage(HttpServletRequest request, HttpSession session) {
		String uId = (String) session.getAttribute("web_userid");
		ModelAndView mav = new ModelAndView("AllWorkAttendance");
		mav.addObject("sessionId", uId);
		return mav;
	}

	@RequestMapping(value = "/page/userMonthReportList", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getUserMonthReportListPage(HttpServletRequest request, HttpSession session) {
		String uId = (String) session.getAttribute("web_userid");
		ModelAndView mav = new ModelAndView("UserMonthReportList");
		mav.addObject("sessionId", uId);
		return mav;
	}

	@RequestMapping(value = "/page/allMonthReportList", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getAllMonthReportListPage(HttpServletRequest request, HttpSession session) {
		String uId = (String) session.getAttribute("web_userid");
		ModelAndView mav = new ModelAndView("AllMonthReportList");
		mav.addObject("sessionId", uId);
		return mav;
	}

	@RequestMapping(value = "/page/createDailyReportList", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getCreateDailyReportListPage(HttpServletRequest request, HttpSession session) {
		String uId = (String) session.getAttribute("web_userid");
		ModelAndView mav = new ModelAndView("CreateDailyReportList");
		mav.addObject("sessionId", uId);
		return mav;
	}

	@RequestMapping(value = "/page/createCrmDailyReport", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getCreateCrmDailyReportPage(HttpServletRequest request, HttpSession session) {
		String uId = (String) session.getAttribute("web_userid");
		ModelAndView mav = new ModelAndView("CreateCrmDailyReport");
		mav.addObject("sessionId", uId);
		return mav;
	}

	@RequestMapping(value = "/page/createCrmArrangement", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getCreateCrmArrangementPage(HttpServletRequest request, HttpSession session) {
		String uId = (String) session.getAttribute("web_userid");
		ModelAndView mav = new ModelAndView("CreateCrmArrangement");
		mav.addObject("sessionId", uId);
		return mav;
	}

	@RequestMapping(value = "/page/dailyArrangement", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getDailyArrangementPage(HttpServletRequest request) {
		String result = null;
		/*
		 * String accessToken =
		 * WeiXinEnterpriseUtils.getAccessToken("wxfca99e2643b26241",
		 * "Ki7b7dlx5TE2tAgpZ8mm0hXRJNGnA_wEkM2TSRkkXC4");
		 */
		String accessToken = WeChatEnterpriseUtils.getAccessToken();
		String code = request.getParameter("code");
		String url = String.format("https://qyapi.weixin.qq.com/cgi-bin/user/getuserinfo?access_token=%s&code=%s",
				accessToken, code);
		com.alibaba.fastjson.JSONObject jsonObject = WeiXinEnterpriseUtils.get(url);
		String errcode = jsonObject.getString("errcode");
		if (errcode.equals("0")) {
			result = jsonObject.getString("UserId");
		} else {
			result = null;
		}
		ModelAndView mav = new ModelAndView("DailyArrangement");
		mav.addObject("mUserId", result);
		return mav;
	}

	/****************************************/

	/*
	 * @RequestMapping(value = "/page/getMonthReport", method = RequestMethod.GET)
	 * 
	 * @ResponseBody public ModelAndView getMonthReportPage(HttpServletRequest
	 * request) { ModelAndView mav = new ModelAndView("MonthReport"); return mav; }
	 */

	@RequestMapping(value = "/page/getList", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getListPage(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("DailyList");
		return mav;
	}

	/*
	 * @RequestMapping(value = "/page/getUserList/{userName}/", method =
	 * RequestMethod.GET)
	 * 
	 * @ResponseBody public ModelAndView getUserListPage1(HttpServletRequest
	 * request, @PathVariable(value = "userName") String userName) { ModelAndView
	 * mav = new ModelAndView("UserDailyList"); mav.addObject("mUser", userName);
	 * return mav; }
	 */

	@RequestMapping(value = "/page/getWechatList", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getWechatListPage(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("WechatCheckDailyList");
		return mav;
	}

	@RequestMapping(value = "/page/getCardList", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getCardListPage(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("CardCheckDailyList");
		return mav;
	}

	@RequestMapping(value = "/page/getAllCheckList", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getAllCheckListPage(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("AllCheckDailyList");
		return mav;
	}

	/*
	 * @RequestMapping(value = "/page/getUserWechatList", method =
	 * RequestMethod.GET)
	 * 
	 * @ResponseBody public ModelAndView getUserWechatListPage(HttpServletRequest
	 * request) { ModelAndView mav = new ModelAndView("UserWechatCheckDailyList");
	 * return mav; }
	 */

	@RequestMapping(value = "/page/getWechatInfo", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getWechatInfo(HttpServletRequest request) {

		String result = null;
		/*
		 * String accessToken =
		 * WeiXinEnterpriseUtils.getAccessToken("wxfca99e2643b26241",
		 * "Ki7b7dlx5TE2tAgpZ8mm0hXRJNGnA_wEkM2TSRkkXC4");
		 */
		String accessToken = WeChatEnterpriseUtils.getAccessToken();
		String code = request.getParameter("code");
		System.out.println(code);
		String url = String.format("https://qyapi.weixin.qq.com/cgi-bin/user/getuserinfo?access_token=%s&code=%s",
				accessToken, code);
		com.alibaba.fastjson.JSONObject jsonObject = WeiXinEnterpriseUtils.get(url);
		String errcode = jsonObject.getString("errcode");
		System.out.println(errcode);
		if (errcode.equals("0")) {
			result = jsonObject.getString("UserId");
		} else {
			result = null;
		}
		ModelAndView mav = new ModelAndView("GetWechatInfo");
		mav.addObject("mUserId", result);
		return mav;
	}

	@RequestMapping(value = "/page/weekPlanDetails", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getWeekPlanDetailsPage(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("WeekPlanDetails");
		return mav;
	}

	@RequestMapping(value = "/page/homePage", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getHomePage(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("HomePage");
		return mav;
	}

	@RequestMapping(value = "/page/createAssignmentOrder", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getCreateAssignmentOrderPage(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("CreateAssignmentOrder");
		return mav;
	}

	@RequestMapping(value = "/page/assignmentList", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getAssignmentListPage(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("AssignmentList");
		return mav;
	}

	@RequestMapping(value = "/page/assignmentListMobile", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getAssignmentListMobilePage(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("AssignmentListMobile");
		return mav;
	}

	@RequestMapping(value = "/page/editAssignment/{assignmentId}", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getEditAssignmentPage(HttpServletRequest request,
			@PathVariable(value = "assignmentId") int id) {
		ModelAndView mav = new ModelAndView("EditAssignment");
		mav.addObject("mId", id);
		return mav;
	}

	@RequestMapping(value = "/page/moreAssignmentList/{type}", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getMoreAssignmentListPage(HttpServletRequest request, @PathVariable(value = "type") int type) {
		ModelAndView mav = new ModelAndView("MoreAssignmentList");
		mav.addObject("type", type);
		return mav;
	}

	@RequestMapping(value = "/page/moreAssignmentListMobile/{type}", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getMoreAssignmentListMobilePage(HttpServletRequest request,
			@PathVariable(value = "type") int type) {
		ModelAndView mav = new ModelAndView("MoreAssignmentListMobile");
		mav.addObject("type", type);
		return mav;
	}

	@RequestMapping(value = "/page/assignmentChart", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getAssignmentChartPage(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("AssignmentChart");
		return mav;
	}

	@RequestMapping(value = "/page/dataSourceAssignmentList", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getDataSourceAssignmentListPage(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("DataSourceAssignmentList");
		return mav;
	}

	@RequestMapping(value = "/page/ourLoveStory", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getOurLoveStoryPage(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("OurLoveStory");
		return mav;
	}

	@RequestMapping(value = "/page/weekUploadReport", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getWeekUploadReportPage(HttpServletRequest request) {

		String result = null;
		/*
		 * String accessToken =
		 * WeiXinEnterpriseUtils.getAccessToken("wxfca99e2643b26241",
		 * "Ki7b7dlx5TE2tAgpZ8mm0hXRJNGnA_wEkM2TSRkkXC4");
		 */
		String accessToken = WeChatEnterpriseUtils.getAccessToken();
		String code = request.getParameter("code");
		String url = String.format("https://qyapi.weixin.qq.com/cgi-bin/user/getuserinfo?access_token=%s&code=%s",
				accessToken, code);
		com.alibaba.fastjson.JSONObject jsonObject = WeiXinEnterpriseUtils.get(url);
		String errcode = jsonObject.getString("errcode");
		if (errcode.equals("0")) {
			result = jsonObject.getString("UserId");
		} else {
			result = null;
		}
		ModelAndView mav = new ModelAndView("WeekUploadReport");
		mav.addObject("mUserId", result);
		return mav;
	}

	@RequestMapping(value = "/page/dailyUploadReportList", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getDailyUploadReportListPage(HttpServletRequest request) {
		String result = null;
		/*
		 * String accessToken =
		 * WeiXinEnterpriseUtils.getAccessToken("wxfca99e2643b26241",
		 * "Ki7b7dlx5TE2tAgpZ8mm0hXRJNGnA_wEkM2TSRkkXC4");
		 */
		String accessToken = WeChatEnterpriseUtils.getAccessToken();
		String code = request.getParameter("code");
		String url = String.format("https://qyapi.weixin.qq.com/cgi-bin/user/getuserinfo?access_token=%s&code=%s",
				accessToken, code);
		com.alibaba.fastjson.JSONObject jsonObject = WeiXinEnterpriseUtils.get(url);
		String errcode = jsonObject.getString("errcode");
		if (errcode.equals("0")) {
			result = jsonObject.getString("UserId");
		} else {
			result = null;
		}
		ModelAndView mav = new ModelAndView("DailyUploadReportList");
		mav.addObject("mUserId", result);
		return mav;
	}

	@RequestMapping(value = "/page/editDailyUploadReport/{id}", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getEditDailyUploadReportPage(HttpServletRequest request, @PathVariable(value = "id") int id) {
		String result = null;
		/*
		 * String accessToken =
		 * WeiXinEnterpriseUtils.getAccessToken("wxfca99e2643b26241",
		 * "Ki7b7dlx5TE2tAgpZ8mm0hXRJNGnA_wEkM2TSRkkXC4");
		 */
		String accessToken = WeChatEnterpriseUtils.getAccessToken();
		String code = request.getParameter("code");
		String url = String.format("https://qyapi.weixin.qq.com/cgi-bin/user/getuserinfo?access_token=%s&code=%s",
				accessToken, code);
		com.alibaba.fastjson.JSONObject jsonObject = WeiXinEnterpriseUtils.get(url);
		String errcode = jsonObject.getString("errcode");
		if (errcode.equals("0")) {
			result = jsonObject.getString("UserId");
		} else {
			result = null;
		}
		ModelAndView mav = new ModelAndView("EditDailyUploadReport");
		mav.addObject("mId", id);
		mav.addObject("mUserId", result);
		return mav;
	}

	@RequestMapping(value = "/page/allDailyUploadReportList", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getAllDailyUploadReportListPage(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("AllDailyUploadReportList");
		return mav;
	}

	@RequestMapping(value = "/page/editArrangement/{id}", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getEditArrangementPage(HttpServletRequest request, @PathVariable(value = "id") int id) {
		String result = null;
		/*
		 * String accessToken =
		 * WeiXinEnterpriseUtils.getAccessToken("wxfca99e2643b26241",
		 * "Ki7b7dlx5TE2tAgpZ8mm0hXRJNGnA_wEkM2TSRkkXC4");
		 */
		String accessToken = WeChatEnterpriseUtils.getAccessToken();
		String code = request.getParameter("code");
		String url = String.format("https://qyapi.weixin.qq.com/cgi-bin/user/getuserinfo?access_token=%s&code=%s",
				accessToken, code);
		com.alibaba.fastjson.JSONObject jsonObject = WeiXinEnterpriseUtils.get(url);
		String errcode = jsonObject.getString("errcode");
		if (errcode.equals("0")) {
			result = jsonObject.getString("UserId");
		} else {
			result = null;
		}
		ModelAndView mav = new ModelAndView("EditArrangement");
		mav.addObject("mId", id);
		mav.addObject("mUserId", result);
		return mav;
	}

	@RequestMapping(value = "/page/editWeekUploadReport/{id}", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getEditWeekUploadReportPage(HttpServletRequest request, @PathVariable(value = "id") int id) {
		String result = null;
		String accessToken = WeChatEnterpriseUtils.getAccessToken();
		String code = request.getParameter("code");
		String url = String.format("https://qyapi.weixin.qq.com/cgi-bin/user/getuserinfo?access_token=%s&code=%s",
				accessToken, code);
		com.alibaba.fastjson.JSONObject jsonObject = WeiXinEnterpriseUtils.get(url);
		String errcode = jsonObject.getString("errcode");
		if (errcode.equals("0")) {
			result = jsonObject.getString("UserId");
		} else {
			result = null;
		}
		ModelAndView mav = new ModelAndView("EditWeekUploadReport");
		mav.addObject("mId", id);
		mav.addObject("mUserId", result);
		return mav;
	}

	@RequestMapping(value = "/page/workTimeAdjust", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getWorkTimeAdjustPage(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("WorkTimeAdjust");
		return mav;
	}

	@RequestMapping(value = "/page/editContract/{id}", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getEditContractPage(HttpServletRequest request, @PathVariable(value = "id") int id,HttpSession session) {
		String uId = (String) session.getAttribute("web_userid");
		ModelAndView mav = new ModelAndView("EditContract");
		mav.addObject("mId", id);
		mav.addObject("sessionId", uId);
		return mav;
	}

	@RequestMapping(value = "/page/confirmContract", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getConfirmContractPage(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("ConfirmContract");
		return mav;
	}

	@RequestMapping(value = "/page/createUser", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getCreateUserPage(HttpServletRequest request, HttpSession session) {
		String uId = (String) session.getAttribute("web_userid");
		ModelAndView mav = new ModelAndView("CreateUser");
		mav.addObject("sessionId", uId);
		return mav;
	}

	@RequestMapping(value = "/page/userList", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getUserListPage(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("UserList");
		return mav;
	}

	@RequestMapping(value = "/page/editUser/{uId}", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getEditUserPage(HttpServletRequest request, @PathVariable(value = "uId") int id) {
		ModelAndView mav = new ModelAndView("EditUser");
		mav.addObject("mId", id);
		return mav;
	}

	@RequestMapping(value = "/page/roleList", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getRoleListPage(HttpServletRequest request, HttpSession session) {
		String uId = (String) session.getAttribute("web_userid");
		ModelAndView mav = new ModelAndView("RoleList");
		mav.addObject("sessionId", uId);
		return mav;
	}

	@RequestMapping(value = "/page/netWebOrganize_jobPosition", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getNetWebOrganizePage(HttpServletRequest request, HttpSession session) {
		String uId = (String) session.getAttribute("web_userid");
		ModelAndView mav = new ModelAndView("JobPositionList");
		mav.addObject("sessionId", uId);
		return mav;
	}

	@RequestMapping(value = "/page/companyBasicInfo", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getCompanyBasicInfoPage(HttpServletRequest request, HttpSession session) {
		String uId = (String) session.getAttribute("web_userid");
		ModelAndView mav = new ModelAndView("CompanyBasicInfo");
		mav.addObject("sessionId", uId);
		return mav;
	}

	@RequestMapping(value = "/page/privacyPolicy", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getPrivacyPolicyPage(HttpServletRequest request, HttpSession session) {
		ModelAndView mav = new ModelAndView("PrivacyPolicy");
		return mav;
	}

	@RequestMapping(value = "/page/sendInformation", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getSendInformationPage(HttpServletRequest request, HttpSession session) {
		String uId = (String) session.getAttribute("web_userid");
		ModelAndView mav = new ModelAndView("SendInformation");
		mav.addObject("sessionId", uId);
		return mav;
	}

	// 企业号-周计划
	@RequestMapping(value = "/page/createWeekJob", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getWeekJobPage(HttpServletRequest request) {
		String accessToken = WeChatEnterpriseUtils.getAccessToken();
		String wechatUserId = WeChatEnterpriseUtils.getWechatUserId(accessToken, request.getParameter("code"));
		ModelAndView mav = new ModelAndView("WeekJob");
		mav.addObject("mUserId", wechatUserId);
		return mav;
	}

	// 企业号-日报
	@RequestMapping(value = "/page/dailyUploadReport", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getDailyUploadReportPage(HttpServletRequest request) {
		String result = null;
		String accessToken = WeChatEnterpriseUtils.getAccessToken();
		String code = request.getParameter("code");
		String url = String.format("https://qyapi.weixin.qq.com/cgi-bin/user/getuserinfo?access_token=%s&code=%s",
				accessToken, code);
		com.alibaba.fastjson.JSONObject jsonObject = WeiXinEnterpriseUtils.get(url);
		String errcode = jsonObject.getString("errcode");
		if (errcode.equals("0")) {
			result = jsonObject.getString("UserId");
		} else {
			result = null;
		}
		ModelAndView mav = new ModelAndView("DailyUploadReport");
		mav.addObject("mUserId", result);
		return mav;
	}

	// 企业号-所有周计划(废 2021_10_9)
	@RequestMapping(value = "/page/arrangementList", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getArrangementListPage(HttpServletRequest request) {
		String accessToken = WeChatEnterpriseUtils.getAccessToken();
		System.out.println(accessToken);
		String wechatUserId = WeChatEnterpriseUtils.getWechatUserId(accessToken, request.getParameter("code"));
		System.out.println(wechatUserId);
		ModelAndView mav = new ModelAndView("ArrangementList");
		mav.addObject("mUserId", wechatUserId);
		return mav;
	}

	// 企业号-获取用户自己的所有日程(废 2021_10_9)
	@RequestMapping(value = "/page/userArrangementList/{uId}", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getUserArrangementListPage(HttpServletRequest request,
			@PathVariable(value = "uId") String uId) {
		ModelAndView mav = new ModelAndView("UserArrangementList");
		mav.addObject("mUserId", uId);
		return mav;
	}

	// 企业号-获取所有日程
	@RequestMapping(value = "/page/allArrangementList", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getAllWeekArrangementListPage(HttpServletRequest request) {
		String accessToken = WeChatEnterpriseUtils.getAccessToken();
		String wechatUserId = WeChatEnterpriseUtils.getWechatUserId(accessToken, request.getParameter("code"));
		ModelAndView mav = new ModelAndView("AllArrangementList");
		mav.addObject("mUserId", wechatUserId);
		return mav;
	}

	// 企业号-获取所有周报
	@RequestMapping(value = "/page/allWeekUploadReportList", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getAllWeekUploadReportListPage(HttpServletRequest request) {
		String accessToken = WeChatEnterpriseUtils.getAccessToken();
		String wechatUserId = WeChatEnterpriseUtils.getWechatUserId(accessToken, request.getParameter("code"));
		ModelAndView mav = new ModelAndView("AllWeekUploadReportList");
		mav.addObject("mUserId", wechatUserId);
		return mav;
	}

	// 企业号-新建客户
	@RequestMapping(value = "/page/mobileCreateCompany", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView getMobileCreateCompanyPage(HttpServletRequest request) {
		String accessToken = WeChatEnterpriseUtils.getSalesAccessToken();
		String wechatUserId = WeChatEnterpriseUtils.getWechatUserId(accessToken, request.getParameter("code"));
		ModelAndView mav = new ModelAndView("MobileCreateCompany");
		mav.addObject("mUserId", wechatUserId);
		return mav;
	}

}
