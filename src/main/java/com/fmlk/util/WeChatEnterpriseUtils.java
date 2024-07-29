package com.fmlk.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.charset.Charset;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;
import java.util.Properties;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.ContentType;
import org.apache.http.entity.StringEntity;
import org.apache.http.entity.mime.MultipartEntityBuilder;
import org.apache.http.entity.mime.content.FileBody;
import org.apache.http.entity.mime.content.StringBody;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.message.BasicHeader;
import org.apache.http.protocol.HTTP;
import org.apache.http.util.CharsetUtils;
import org.apache.http.util.EntityUtils;
import org.springframework.web.multipart.MultipartFile;
import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.fmlk.entity.Inform;
import com.fmlk.entity.ProjectCase;
import com.fmlk.entity.User;

public class WeChatEnterpriseUtils {
	private static String checkInfoTitle = "[销售审核通知]";
	private static String dispatchInfoTitle = "[技术派工通知]";
	private static String createProjectCaseInfoTitle = "[销售开派工单通知]";
	private static String editProjectCaseInfoTitle = "[已更改]";
	private static String unclosedProjectCaseInfoTitle = "[！！！派工超时3天未关闭警告通知！！！]";
	private static String uploadProjectReportInfoTitle = "[上传项目报告通知]";
	private static String agentId = null;
	private static String informUserNickName = null;
	private static String informUserNickName2 = null;
	private static String tongJiAlertTitle = "[同济报警通知]";
	private static String projectContractTitle = "[合同交货收款超时报警]";

	public static JSONObject get(String url) {
		JSONObject jb = null;
		HttpGet request = new HttpGet(url);
		CloseableHttpClient httpclient = HttpClients.createDefault();
		try {
			HttpResponse response = httpclient.execute(request);
			String reposeContent = EntityUtils.toString(response.getEntity(), "utf-8");
			jb = JSON.parseObject(reposeContent);
		} catch (Exception e) {
			jb = null;
		}
		return jb;
	}

	public static JSONObject post(String url, JSONObject jsonObject) {
		JSONObject jb = null;
		try {
			CloseableHttpClient httpclient = HttpClients.createDefault();
			HttpPost httpPost = new HttpPost(url);
			String jsonStr = jsonObject.toJSONString();
			StringEntity se = new StringEntity(jsonStr, "UTF-8");
			se.setContentType("text/json");
			se.setContentEncoding(new BasicHeader(HTTP.CONTENT_TYPE, "application/json"));
			httpPost.setEntity(se);
			HttpResponse response = httpclient.execute(httpPost);
			String reposeContent = EntityUtils.toString(response.getEntity(), Charset.forName("UTF-8"));
			jb = JSON.parseObject(reposeContent);
		} catch (Exception e) {
			jb = null;
		}
		return jb;
	}
	
	public static File toFile(MultipartFile uploadFile) throws Exception{
		File file = null;
		InputStream ins = uploadFile.getInputStream();
		file = new File(uploadFile.getOriginalFilename());
		OutputStream os = new FileOutputStream(file);
		int bytesRead = 0;
		byte[] buffer = new byte[8192];
		while((bytesRead = ins.read(buffer, 0, 8192)) != -1) {
			os.write(buffer, 0, bytesRead);
		}
		os.close();
		ins.close();
		return file;
	}
	
	public static JSONObject post(String url,MultipartFile uploadFile) {
		JSONObject jb = null;
		try {
			CloseableHttpClient httpclient = HttpClients.createDefault();
			HttpPost httpPost = new HttpPost(url);
			File file = toFile(uploadFile);
			FileBody fileBody = new FileBody(file);
			StringBody nameBody = new StringBody("media",ContentType.TEXT_PLAIN);
			HttpEntity reqEntity = MultipartEntityBuilder.create().addPart("file", fileBody)
					.addPart("name", nameBody).setCharset(CharsetUtils.get("UTF-8")).build();
			httpPost.setEntity(reqEntity);
			HttpResponse response = httpclient.execute(httpPost);
			String reposeContent = EntityUtils.toString(response.getEntity(), Charset.forName("UTF-8"));
			jb = JSON.parseObject(reposeContent);
		} catch (Exception e) {
			jb = null;
		}
		return jb;
	}


	public static String getAccessToken() {
		try {
			Properties prop = new Properties();
			String path = DBConnection.class.getResource("/").getPath();
			path = path.substring(1, path.indexOf("WEB-INF/classes")) + "property/wechat.properties";
			path = path.replaceAll("%20", " ");
			prop.load(new FileInputStream(path));
			String corpId = prop.getProperty("wechat.corpId");
			String corpSecret = prop.getProperty("wechat.secret");
			agentId = prop.getProperty("wechat.agentId");
			informUserNickName = prop.getProperty("wechat.informUser");
			informUserNickName2 = prop.getProperty("wechat.informUser2");
			String url = String.format("https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid=%s&corpsecret=%s", corpId,
					corpSecret);
			JSONObject jb = get(url);
			return jb.getString("access_token");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "";
	}
	
	public static String getSalesAccessToken() {
		try {
			Properties prop = new Properties();
			String path = DBConnection.class.getResource("/").getPath();
			path = path.substring(1, path.indexOf("WEB-INF/classes")) + "property/wechat.properties";
			path = path.replaceAll("%20", " ");
			prop.load(new FileInputStream(path));
			String corpId = prop.getProperty("wechat.corpId");
			String corpSecret = prop.getProperty("wechat.sales.secret");
			agentId = prop.getProperty("wechat.sales.agentId");
			//informUserNickName = prop.getProperty("wechat.informUser");
			//informUserNickName2 = prop.getProperty("wechat.informUser2");
			String url = String.format("https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid=%s&corpsecret=%s", corpId,
					corpSecret);
			JSONObject jb = get(url);
			return jb.getString("access_token");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "";
	}

	public static String getWechatUserId(String accessToken, String code) {
		String url = String.format("https://qyapi.weixin.qq.com/cgi-bin/user/getuserinfo?access_token=%s&code=%s",
				accessToken, code);
		JSONObject jsonObject = get(url);
		return jsonObject.getString("UserId");
	}

	// 审核和派工推送消息
	// 发推送消息 https://work.weixin.qq.com/api/doc#90001/90143/90372
	public static String sendProjectCaseInform(String accessToken, ProjectCase pc, int checkResult, int type,
			List<User> userList,String companyName, String projectName,String mSalesName,String mServiceUsersName) {
		Calendar calendar = Calendar.getInstance();
		calendar.add(Calendar.DATE, 0);
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy年MM月dd日");
		String todayString = formatter.format(calendar.getTime());// 今天
		String url = String.format("https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token=%s", accessToken);
		String title = null;
		informUserNickName = "lv.zhong|lu.haiming|lin.lin";
		// 审核派工通知 type 1.销审2.技审
		String content = todayString + "\n项目名称：" + projectName + "\n客户名称：" + companyName + "\n销售：" + mSalesName
				+ "\n服务时间："+ pc.getServiceDate() +" 至 "+pc.getServiceEndDate() + "\n服务内容：" + pc.getServiceContent() + "\n审核结果："
				+ (checkResult != 1 ? "驳回" : "通过");
	    if(type == 1) {
	    	title = checkInfoTitle;
	    }else if(type==2) {
	    	title = dispatchInfoTitle;
	    }
	    for (int i = 0; i < userList.size(); i++) {
			// 销售
			informUserNickName += "|" + userList.get(i).getNickName();
		}
	   /* informUserNickName = "lu.haiming";
	    System.out.println("通知的人=="+informUserNickName);*/
	    JSONObject jsonContent = new JSONObject();
		JSONObject textObject = new JSONObject();
		JSONObject jsonObject = new JSONObject();
		jsonObject.put("msgtype", "textcard");
		jsonObject.put("agentid", agentId);
		
		textObject.put("title", title);
		content = checkResult != 1?content + "\n驳回理由：" + pc.getRejectReason():content;	
		if(type == 2 && checkResult == 1) {
			content += "\n服务工程师："+mServiceUsersName;
			if(pc.getRemark() != null && !pc.getRemark().equals("")) {
				content += "\n备注：" + pc.getRemark();
			}
			content += "\n☆☆☆请工程师合理安排好工作时间☆☆☆\n☆☆☆完成指派任务后上传项目报告☆☆☆";
		}else if(type == 1 && checkResult == 1) {
			content += "\n☆☆☆请尽快派工☆☆☆";
		}
		textObject.put("description","<div>" + content + "</div>");
		textObject.put("url",
				"https://open.weixin.qq.com/connect/oauth2/authorize?appid=ww59df2fdaef20da86&redirect_uri=crm.family-care.cn%2fpage%2feditProjectCaseMobile%2f2%2f"
						+ pc.getId() + "&response_type=code&scope=snsapi_base&agentid=1000003#wechat_redirect");
		jsonObject.put("textcard", textObject);
		jsonObject.put("touser", informUserNickName);
		jsonContent = post(url, jsonObject);
		return jsonContent.getString("errcode");
	}

	// 新建派工推送消息
	public static String sendProjectCaseInform(String accessToken, ProjectCase pc, List<User> userList,
			String companyName, String projectName,String mSalesName,boolean isEdit) {
		Calendar calendar = Calendar.getInstance();
		calendar.add(Calendar.DATE, 0);
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy年MM月dd日");
		String todayString = formatter.format(calendar.getTime());// 今天
		// 审核链接
		String url = String.format("https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token=%s", accessToken);
		String title = createProjectCaseInfoTitle;
		title = isEdit?"[已重新提审]"+title:title;
		String content = "项目名称：" + projectName + "\n客户名称：" + companyName + "\n销售：" + mSalesName+"\n服务时间：" + pc.getServiceDate()+" 至 "+pc.getServiceEndDate() + "\n服务内容："
				+ pc.getServiceContent();
		String informUserNickName = "lv.zhong|lu.haiming|lin.lin";
		for (int i = 0; i < userList.size(); i++) {
			informUserNickName += "|" + userList.get(i).getNickName();
		}
		/*informUserNickName = "lu.haiming";
		System.out.println("通知的人=="+informUserNickName);*/
		JSONObject textObject = new JSONObject();
		textObject.put("title", title);
		textObject.put("description",
				"<div class=\"gray\">" + todayString + "</div><div class=\"normal\">" + content + "</div>");
		textObject.put("url",
				"https://open.weixin.qq.com/connect/oauth2/authorize?appid=ww59df2fdaef20da86&redirect_uri=crm.family-care.cn%2fpage%2feditProjectCaseMobile%2f1%2f"
						+ pc.getId() + "&response_type=code&scope=snsapi_base&agentid=1000003#wechat_redirect");
		JSONObject jsonObject = new JSONObject();
		jsonObject.put("touser", informUserNickName);
		jsonObject.put("msgtype", "textcard");
		jsonObject.put("agentid", agentId);
		jsonObject.put("textcard", textObject);
		JSONObject jsonContent = post(url, jsonObject);
		return jsonContent.getString("errcode");
	}

	// 超时派工推送
	public static String sendProjectCaseUnclosedInform(String accessToken, ProjectCase pc, List<User> userList,
			List<User> userList2, String companyName, String projectName) {
		Calendar calendar = Calendar.getInstance();
		calendar.add(Calendar.DATE, 0);
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy年MM月dd日");
		String todayString = formatter.format(calendar.getTime());// 今天
		String url = String.format("https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token=%s", accessToken);
		String title = unclosedProjectCaseInfoTitle;
		String content = todayString + "\n项目名称：" + projectName + "\n客户名称：" + companyName + "\n服务时间："
				+ pc.getServiceDate() + "\n服务内容：" + pc.getServiceContent();
		String salesName = "";
		String nameList = "";
		informUserNickName = "lu.haiming|lv.zhong|wang.fan";
		for (int i = 0; i < userList.size(); i++) {
			if (pc.getSalesId() == userList.get(i).getUId()) {
				salesName = userList.get(i).getName();
			}
			informUserNickName += "|" + userList.get(i).getNickName();
		}
		content += "\n销售：" + salesName.trim();
		for (int j = 0; j < userList2.size(); j++) {
			// 被指派的人
			nameList += userList2.get(j).getName() + ",";
			informUserNickName += "|" + userList2.get(j).getNickName();
		}
		content += "\n服务工程师：" + nameList.substring(0, nameList.length() - 1).trim();
		content += "\n☆☆☆☆☆工程师请尽快完成指派的工作☆☆☆☆☆";
		content += "\n☆☆☆☆☆☆☆☆并上传项目报告☆☆☆☆☆☆☆☆";
		JSONObject textObject = new JSONObject();
		textObject.put("title", title);
		textObject.put("description", content);
		textObject.put("url",
				"https://open.weixin.qq.com/connect/oauth2/authorize?appid=ww59df2fdaef20da86&redirect_uri=www.family-care.cn%2fpage%2feditProjectCaseMobile%2f2%2f"
						+ pc.getId() + "&response_type=code&scope=snsapi_base&agentid=1000003#wechat_redirect");
		JSONObject jsonObject = new JSONObject();
		jsonObject.put("touser", informUserNickName);
		jsonObject.put("msgtype", "textcard");
		jsonObject.put("agentid", agentId);
		jsonObject.put("textcard", textObject);
		JSONObject jsonContent = post(url, jsonObject);
		return jsonContent.getString("errcode");
	}

	// 上传项目报告推送
	public static String sendProjectReportUploadInform(String accessToken, String projectName, String companyName,
			List<User> informUserList, int salesId, int userId, String fileName, int reportType) {
		Calendar calendar = Calendar.getInstance();
		calendar.add(Calendar.DATE, 0);
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy年MM月dd日");
		String todayString = formatter.format(calendar.getTime());// 今天
		String url = String.format("https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token=%s", accessToken);
		String title = uploadProjectReportInfoTitle;
		String content = todayString + "\n项目名称：" + projectName + "\n客户名称：" + companyName;
		String salesName = "";
		String userName = "";
		informUserNickName = "lv.zhong";
		for (int i = 0; i < informUserList.size(); i++) {
			if (salesId == informUserList.get(i).getUId()) {
				salesName = informUserList.get(i).getName();
			}
			if (userId == informUserList.get(i).getUId()) {
				userName = informUserList.get(i).getName();
			}
			informUserNickName += "|" + informUserList.get(i).getNickName();
		}
		content += "\n销售：" + salesName.trim();

		if (reportType == 1) {
			content += "\n销售进展报告：" + fileName;
		} else if (reportType == 2) {
			content += "\n售前工程师进展报告：" + fileName;
			content += "\n☆☆☆☆☆销售请确认上传文档☆☆☆☆☆";
		} else {
			content += "\n售后工程师进展报告：" + fileName;
			content += "\n☆☆☆☆☆销售请确认上传文档☆☆☆☆☆";
		}
		content += "\n上传人：" + userName.trim();
		JSONObject textObject = new JSONObject();
		textObject.put("title", title);
		textObject.put("description", content);
		textObject.put("url",
				"https://open.weixin.qq.com/connect/oauth2/authorize?appid=ww59df2fdaef20da86&redirect_uri=crm.lanstarnet.com%3a8082%2fdailyUploadProject%2fpage%2findex&response_type=code&scope=snsapi_base&agentid=1#wechat_redirect");
		JSONObject jsonObject = new JSONObject();
		jsonObject.put("touser", informUserNickName);
		jsonObject.put("msgtype", "textcard");
		jsonObject.put("agentid", agentId);
		jsonObject.put("textcard", textObject);
		JSONObject jsonContent = post(url, jsonObject);
		return jsonContent.getString("errcode");
	}

	// 更改派工单通知
	public static String sendProjectCaseInform(String accessToken, ProjectCase pc,int type,
			List<User> userList,List<User> userList2, String mCompanyName, String mProjectName, boolean isChecked) {
		Calendar calendar = Calendar.getInstance();
		calendar.add(Calendar.DATE, 0);
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy年MM月dd日");
		String todayString = formatter.format(calendar.getTime());// 今天

		// 审核链接
		String url = String.format("https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token=%s", accessToken);
		String title = editProjectCaseInfoTitle;
		String content = "项目名称：" + mProjectName + "\n客户名称：" + mCompanyName + "\n服务时间：" + pc.getServiceDate() +" to "+pc.getServiceEndDate() + "\n服务内容："
				+ pc.getServiceContent();
		String salesName = "";
		String mUrl = "";
		informUserNickName = "lu.haiming|lv.zhong";
		for (int i = 0; i < userList.size(); i++) {
			if (pc.getSalesId() == userList.get(i).getUId()) {
				salesName = userList.get(i).getName();
			}
			informUserNickName += "|" + userList.get(i).getNickName();
		}
		content += "\n销售：" + salesName.trim();
		JSONObject textObject = new JSONObject();
		
		if(isChecked) {
			content += "\n审核结果：通过";
			title += dispatchInfoTitle;
			if(!pc.getServiceUsers().equals("")&&pc.getServiceUsers() != null) {
				//已派工
				String nameList = "";
				for (int j = 0; j < userList2.size(); j++) {
					// 被指派的人
					nameList += userList2.get(j).getName() + ",";
				}
				content += "\n服务工程师："+ nameList.substring(0, nameList.length() - 1).trim() + "\n备注：" + pc.getRemark();
				content += "\n☆☆☆☆☆请工程师合理安排好工作时间☆☆☆☆☆\n☆☆☆☆☆完成指派任务后上传项目报告☆☆☆☆☆";
				mUrl = "https://open.weixin.qq.com/connect/oauth2/authorize?appid=ww59df2fdaef20da86&redirect_uri=crm.family-care.cn%2fpage%2feditProjectCaseMobile%2f2%2f"
						+ pc.getId() + "&response_type=code&scope=snsapi_base&agentid=1000003#wechat_redirect";
			}else {
				//未派工
				content += "\n☆☆☆☆☆请尽快派工☆☆☆☆☆";
				mUrl = "https://open.weixin.qq.com/connect/oauth2/authorize?appid=ww59df2fdaef20da86&redirect_uri=crm.family-care.cn%2fpage%2feditProjectCaseMobile%2f2%2f"
						+ pc.getId() + "&response_type=code&scope=snsapi_base&agentid=1000003#wechat_redirect";
			}
		}else {
			title += createProjectCaseInfoTitle;
			mUrl = "https://open.weixin.qq.com/connect/oauth2/authorize?appid=ww59df2fdaef20da86&redirect_uri=crm.family-care.cn%2fpage%2feditProjectCaseMobile%2f1%2f"
					+ pc.getId() + "&response_type=code&scope=snsapi_base&agentid=1000003#wechat_redirect";
		}
		textObject.put("title", title);
		textObject.put("description","<div class=\"gray\">" + todayString + "</div>" + content);
		textObject.put("url",mUrl);
		JSONObject jsonObject = new JSONObject();
		jsonObject.put("touser", informUserNickName);
		jsonObject.put("msgtype", "textcard");
		jsonObject.put("agentid", agentId);
		jsonObject.put("textcard", textObject);
		JSONObject jsonContent = post(url, jsonObject);
		return jsonContent.getString("errcode");
	}

	//给所有人发通知 上月报警的统计
	public static void sendProjectCaseUnclosedInform2(String accessToken, List<ProjectCase> mProjectCaseList2,int mYear,int mMonth) {
		String title = mYear+"年"+mMonth+"月派工报警汇总(点击查看所有)";
		String url = String.format("https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token=%s", accessToken);
		String content = "";
		if(mProjectCaseList2.size()==0) {
			content = "Good Job,EveryOne！！！\n上个月无派工超时报警,这个月请保持";
		}else {
			content = "上个月有"+mProjectCaseList2.size()+"个派工有超时报警,明细如下：";
			String mContent="\n==============================\n";
			for (ProjectCase pc : mProjectCaseList2) {
				mContent += "项目名称：" + pc.getProjectId()+"\n客户名称："+pc.getCaseId()+"\n"+pc.getServiceUsers()+
						"\n报警次数："+ pc.getLateTimes()+"\n==============================\n";
			}
			content += mContent.trim();
		}
		JSONObject textObject = new JSONObject();
		textObject.put("title", title);
		textObject.put("description", content);
		textObject.put("url",
				"https://open.weixin.qq.com/connect/oauth2/authorize?appid=ww59df2fdaef20da86&redirect_uri=crm.family-care.cn%2fpage%2fprojectCaseUnClosedList%2f"+mYear+"%2f"+mMonth+"&response_type=code&scope=snsapi_base&agentid=1000003#wechat_redirect");
		JSONObject jsonObject = new JSONObject();
		jsonObject.put("touser", "@all");
		jsonObject.put("msgtype", "textcard");
		jsonObject.put("agentid", agentId);
		jsonObject.put("textcard", textObject);
		JSONObject jsonContent = post(url, jsonObject);
	}

	public static void sendTongJiAlert(String accessToken, String mTitle, String mContent,String time) {
		String url = String.format("https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token=%s", accessToken);
		String title = tongJiAlertTitle;
		String content = mTitle+"\n"+mContent;
		JSONObject textObject = new JSONObject();
		textObject.put("title", title);
		textObject.put("description", content);
		textObject.put("url",
				"https://www.baidu.com");
		JSONObject jsonObject = new JSONObject();
		jsonObject.put("touser", "lv.shenghua|lu.haiming|qian.hao|yang.huifang|sun.ke");
		jsonObject.put("msgtype", "textcard");
		jsonObject.put("agentid", agentId);
		jsonObject.put("textcard", textObject);
		JSONObject jsonContent = post(url, jsonObject);
	}
	
	public static String sendInformation(String title,String informContent) {
		String accessToken = getAccessToken();
		String url = String.format("https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token=%s", accessToken);
		JSONObject textObject = new JSONObject();
		textObject.put("title", title);
		textObject.put("description", informContent);
		textObject.put("url","https://www.baidu.com");
		JSONObject jsonObject = new JSONObject();
		jsonObject.put("touser", "@all");
		//jsonObject.put("touser", "lu.haiming");
		jsonObject.put("msgtype", "textcard");
		jsonObject.put("agentid", agentId);
		jsonObject.put("textcard", textObject);
		JSONObject jsonContent = post(url, jsonObject);
		return jsonContent.toString();
	}
	
	public static String sendInformation(Inform inf,List<User> userList) {
		String accessToken = getAccessToken();
		String url = String.format("https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token=%s", accessToken);
		JSONObject textObject = new JSONObject();
		textObject.put("title", inf.getTitle());
		textObject.put("description", inf.getContent());
		textObject.put("url","https://www.baidu.com");
		JSONObject jsonObject = new JSONObject();
		informUserNickName = "";
		if(userList != null) {
			for (int i = 0; i < userList.size(); i++) {
				informUserNickName += userList.get(i).getNickName() + "|";
			}
			informUserNickName = informUserNickName.substring(0, informUserNickName.length() - 1).trim();
		}else {
			informUserNickName = "@all";
		}
		jsonObject.put("touser", informUserNickName);
		jsonObject.put("msgtype", "textcard");
		jsonObject.put("agentid", agentId);
		jsonObject.put("textcard", textObject);
		JSONObject jsonContent = post(url, jsonObject);
		return jsonContent.toString();
	}
	
	public static String uploadInformImage(MultipartFile uploadFile) {
		String accessToken = getAccessToken();
		String url = String.format("https://qyapi.weixin.qq.com/cgi-bin/media/upload?access_token=%s&type=image", accessToken);
		JSONObject jsonContent = post(url, uploadFile);
		
		
		return null;
	}
	
	public static void projectContractInform(List<String> list){
		String accessToken = getAccessToken();
		String url = String.format("https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token=%s", accessToken);
		String title = projectContractTitle;
		String content;
		for(int i=0;i<list.size();i++) {
			String type = list.get(i).split("#")[2].equals("1")?"收款":"交货";
			content = "你有以下合同交货或收款时间超时未处理\n合同编号：" + list.get(i).split("#")[6] + "\n项目名称：" + list.get(i).split("#")[4] + "\n客户名称："
					+ list.get(i).split("#")[3] + "\n合同"+type+"时间：" + list.get(i).split("#")[0]+ "\n"+type+"说明：" + list.get(i).split("#")[1];
			informUserNickName = list.get(i).split("#")[5];	
			content += "\n☆☆☆☆☆请尽快前往crm-合同管理处理☆☆☆☆☆";
			JSONObject textObject = new JSONObject();
			textObject.put("title", title);
			textObject.put("description", content);
			textObject.put("url",
					"http://www.family-care.cn/page/login");
			JSONObject jsonObject = new JSONObject();
			jsonObject.put("touser", informUserNickName);
			jsonObject.put("msgtype", "textcard");
			jsonObject.put("agentid", agentId);
			jsonObject.put("textcard", textObject);
			JSONObject jsonContent = post(url, jsonObject);
		}
	}
}
