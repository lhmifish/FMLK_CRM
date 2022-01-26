package com.fmlk.util;

import java.util.ArrayList;
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

public class MyTimerTask {

	private ProjectService mProjectService;
	private UserService mUserService;
	private CompanyService mCompanyService;

	// 每早9点 派工超时通知     1.update派工状态2.企业微信通知
	protected void execute() {
		mProjectService = new ProjectService();
		mUserService = new UserService();
		mCompanyService = new CompanyService();
		String accessToken = WeChatEnterpriseUtils.getAccessToken();
		//更改派工状态至超时
		String jsonStr = mProjectService.editAllProjectCase();	
		//System.out.println("状态更改       "+jsonStr);
		//获取超时派工
		String jsonStr2 = mProjectService.getProjectCaseUnClosedList(2);
		//System.out.println("超时       "+jsonStr2);
		String mErrcode = (String) new Gson().fromJson(jsonStr2, Map.class).get("errcode");
		if (mErrcode.equals("0")) {
			JSONArray myArrayList = new JSONObject().fromObject(jsonStr2).getJSONArray("pclist");
			List<ProjectCase> mProjectCaseList = new ArrayList<ProjectCase>();
			mProjectCaseList = (List<ProjectCase>) JSONArray.toCollection(myArrayList, ProjectCase.class);
			for (int i = 0; i < mProjectCaseList.size(); i++) {
				ProjectCase pc = new ProjectCase();
				String projectName = "";
				String companyName = "";
				pc = mProjectCaseList.get(i);
				
				//更新报警次数
				int times = pc.getLateTimes();
				
				times = times + 1;
				pc.setLateTimes(times);
				mProjectService.updateLateTimes(pc);
				
				
				int uid = pc.getSalesId();
				//销+孙
				List<User> userList = new ArrayList<User>();
				//技术
				List<User> userList2 = new ArrayList<User>();
				if ((uid != 3) && (uid != 4)) {
					userList = mUserService.getUserList(pc.getSalesId() + ",2,3,4");
				} else {
					userList = mUserService.getUserList("2,3,4");
				}
				userList2 = mUserService.getUserList(pc.getServiceUsers());

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
					WeChatEnterpriseUtils.sendProjectCaseUnclosedInform(accessToken, pc, userList, userList2, companyName,
							projectName);
				}

			}

		}

	}

}
