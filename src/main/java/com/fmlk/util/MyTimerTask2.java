package com.fmlk.util;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.Map;
import com.fmlk.entity.Company;
import com.fmlk.entity.Project;
import com.fmlk.entity.ProjectCase;
import com.fmlk.entity.User;
import com.fmlk.service.CompanyService;
import com.fmlk.service.ProjectService;
import com.fmlk.service.UserService;
import com.google.gson.Gson;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public class MyTimerTask2 {

	private ProjectService mProjectService;
	private UserService mUserService;
	private CompanyService mCompanyService;

	// 每月1日10点统计上个月报警次数
	protected void execute2() {
		mProjectService = new ProjectService();
		mUserService = new UserService();
		mCompanyService = new CompanyService();
		Calendar calendar = Calendar.getInstance();
		calendar.add(Calendar.MONTH, -1);
		int year = calendar.get(Calendar.YEAR);
		int month = calendar.get(Calendar.MONTH)+1;
		String jsonStr = mProjectService.getProjectCaseUnClosedList2(2,year,month);
		String errcode = (String) new Gson().fromJson(jsonStr, Map.class).get("errcode");
		if (errcode.equals("0")) {
			JSONArray myArrayList = new JSONObject().fromObject(jsonStr).getJSONArray("pclist");
			List<ProjectCase> mProjectCaseList = new ArrayList<ProjectCase>();
			mProjectCaseList = (List<ProjectCase>) JSONArray.toCollection(myArrayList, ProjectCase.class);
			List<ProjectCase> mProjectCaseList2 = new ArrayList<ProjectCase>();
			for (int i = 0; i < mProjectCaseList.size(); i++) {
				ProjectCase pc = new ProjectCase();
				String projectName = "";
				String companyName = "";
				String salesName = "";
				String usersName = "";
				pc = mProjectCaseList.get(i);
				String projectJSONStr = mProjectService.getProjectByProjectId(pc.getProjectId());
				String errcode2 = (String) new Gson().fromJson(projectJSONStr, Map.class).get("errcode");
				if (errcode2.equals("0")) {
					JSONArray myProjectArr = new JSONObject().fromObject(projectJSONStr).getJSONArray("project");
					Project project = (Project) JSONObject.toBean((JSONObject) myProjectArr.get(0), Project.class);
					projectName = project.getProjectName();
					String companyJSONStr = mCompanyService.getCompanyByCompanyId(project.getCompanyId());
					String errcode3 = (String) new Gson().fromJson(companyJSONStr, Map.class).get("errcode");
					if (errcode3.equals("0")) {
						JSONArray myCompanyArr = new JSONObject().fromObject(companyJSONStr).getJSONArray("company");
						Company company = (Company) JSONObject.toBean((JSONObject) myCompanyArr.get(0), Company.class);
						companyName = company.getCompanyName();
					}
					List<User> userList = new ArrayList<User>();
					userList = mUserService.getUserListByIds(pc.getServiceUsers() + "," + pc.getSalesId());

					pc.setProjectId(projectName);
					pc.setCaseId(companyName);
					for (User user : userList) {
						if (user.getDepartmentId() == 2) {
							// 销售
							salesName = user.getName().trim();
						} else {
							// 技术
							usersName += user.getName() + ",";
						}
					}
					usersName = usersName.substring(0, usersName.length() - 1).trim();
					pc.setServiceUsers("销售：" + salesName + "   服务工程师：" + usersName);
				}
				mProjectCaseList2.add(pc);
			}
			String accessToken = WeChatEnterpriseUtils.getAccessToken();
			WeChatEnterpriseUtils.sendProjectCaseUnclosedInform2(accessToken, mProjectCaseList2,year,month);
		}
	}
}
