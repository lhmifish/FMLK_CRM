package com.fmlk.controller;

import java.awt.image.BufferedImage;
import java.util.ArrayList;
import java.util.List;
import javax.imageio.ImageIO;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.springframework.beans.BeansException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;
import com.fmlk.entity.User;
import com.fmlk.service.UserService;
import com.fmlk.util.CommonUtils;
import com.fmlk.util.FileServerUtils;
import com.fmlk.util.WeChatEnterpriseUtils;
import com.google.code.kaptcha.Constants;
import com.google.code.kaptcha.Producer;

import net.sf.json.JSONObject;

@Controller
public class CommonController implements ApplicationContextAware {

	private ApplicationContext ctx;
	private JSONObject jsonObject;
	private Producer captchaProducer = null;
	private UserService mUserService;

	@Autowired
	public void setCaptchaProducer(Producer captchaProducer) {
		this.captchaProducer = captchaProducer;
	}

	@Override
	public void setApplicationContext(ApplicationContext arg0) throws BeansException {
		this.ctx = arg0;
	}

	/**
	 * 上传项目报告
	 * 
	 */
	@RequestMapping(value = "/addProjectReport", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String addProjectReport(HttpServletRequest request) throws Exception {
		MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
		MultipartFile uploadFile = multipartRequest.getFile("file");
		int chunk = Integer.parseInt(request.getParameter("chunk"));
		int chunks = Integer.parseInt(request.getParameter("chunks"));
		long fileSize = Long.parseLong(request.getParameter("fileSize"));
		String fileName = request.getParameter("fileName");
		int reportType = Integer.parseInt(request.getParameter("reportType"));
		String projectId = request.getParameter("projectId");
		String createYear = request.getParameter("createYear");
		String boundary = multipartRequest.getContentType().split("=")[1];
        int salesId = Integer.parseInt(request.getParameter("salesId"));
		int userId = Integer.parseInt(request.getParameter("userId"));
		String projectName = request.getParameter("projectName");
		String companyName = request.getParameter("companyName");
		
		// 获取accessToken
		String accessToken = FileServerUtils.getAccessToken();
		System.out.println(accessToken);

		jsonObject = new JSONObject();
		if (!accessToken.equals("")) {
			if (chunk == 0) {
				// 创建文件夹
				String createFolder = FileServerUtils.createFolder(accessToken, createYear, projectId, reportType);
				if (createFolder.equals("")) {
					jsonObject.put("errcode", "2");
					jsonObject.put("errmsg", "创建文件夹失败");
					return jsonObject.toString();
				}
				System.out.println("创建文件夹                "+createFolder);
			}
			
			// 传数据
			String transferFile = FileServerUtils.createFile(accessToken, createYear, projectId, reportType, uploadFile,
					chunk, fileSize, fileName, chunks, boundary);
			if (transferFile.equals("")) {
				jsonObject.put("errcode", "3");
				jsonObject.put("errmsg", "第" + (chunk + 1) + "分片上传失败");
				return jsonObject.toString();
			} else {
				jsonObject.put("errcode", "0");
				jsonObject.put("errmsg", "第" + (chunk + 1) + "分片上传成功");
				jsonObject.put("info", transferFile);
				// 最后一个分片上传完通知
				if (chunks == (chunk + 1)  && reportType != 99) {
					System.out.println("附件上传通知");
					List<User> userList = new ArrayList<User>();
					mUserService = new UserService();
					if (salesId == userId) {
						if ((salesId != 3)) {
							userList = mUserService.getUserList(salesId + ",3");
						} else {
							userList = mUserService.getUserList("3");
						}
					} else {
						if (salesId != 3) {
							userList = mUserService.getUserList(salesId + "," + userId + ",3");
						} else {
							userList = mUserService.getUserList(userId + ",3");
						}
					}
					String accessToken2 = WeChatEnterpriseUtils.getAccessToken();
					WeChatEnterpriseUtils.sendProjectReportUploadInform(accessToken2, projectName, companyName, userList,
							salesId, userId, fileName, reportType);
				}
				return jsonObject.toString();
			}
		} else {
			jsonObject.put("errcode", "1");
			jsonObject.put("errmsg", "第" + (chunk + 1) + "分片获取不到accessToken");
			return jsonObject.toString();
		}
	}

	/**
	 * 获取上传文件列表
	 * 
	 */
	@RequestMapping(value = "/queryUploadFile", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String queryUploadFile(HttpServletRequest request) {
		String projectId = request.getParameter("projectId");
		String createYear = request.getParameter("createYear");
		int reportType = Integer.parseInt(request.getParameter("reportType"));
		// 获取accessToken
		String accessToken = FileServerUtils.getAccessToken();
		jsonObject = new JSONObject();
		if (!accessToken.equals("")) {
			// 创建文件夹
			String createFolder = FileServerUtils.createFolder(accessToken, createYear, projectId, reportType);
			if (createFolder.equals("")) {
				jsonObject.put("errcode", "2");
				jsonObject.put("errmsg", "创建文件夹失败");
				return jsonObject.toString();
			}
			String queryFileList = FileServerUtils.getFileList(accessToken, createYear, projectId, reportType);
			if (queryFileList.equals("")) {
				jsonObject.put("errcode", "3");
				jsonObject.put("errmsg", "获取文件列表失败");
				return jsonObject.toString();
			} else {
				jsonObject.put("errcode", "0");
				jsonObject.put("errmsg", "query");
				jsonObject.put("fileList", queryFileList);
				return jsonObject.toString();
			}
		} else {
			jsonObject.put("errcode", "1");
			jsonObject.put("errmsg", "获取不到accessToken");
			return jsonObject.toString();
		}
	}

	/**
	 * 下载文档
	 * 
	 */
	@RequestMapping(value = "/downloadFile", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String downloadFile(HttpServletRequest request) {
		String projectId = request.getParameter("projectId");
		int reportType = Integer.parseInt(request.getParameter("reportType"));
		String fileName = request.getParameter("fileName");
		String createYear = request.getParameter("createYear");

		// 获取accessToken
		String accessToken = FileServerUtils.getAccessToken();
		jsonObject = new JSONObject();
		if (!accessToken.equals("")) {
			String downloadLink = FileServerUtils.downloadFile(accessToken, createYear, projectId, reportType,
					fileName);
			if (downloadLink.equals("")) {
				jsonObject.put("errcode", "2");
				jsonObject.put("errmsg", "获取文件链接失败");
				return jsonObject.toString();
			} else {
				jsonObject.put("errcode", "0");
				jsonObject.put("errmsg", "query");
				jsonObject.put("fileLink", downloadLink);
				return jsonObject.toString();
			}
		} else {
			jsonObject.put("errcode", "1");
			jsonObject.put("errmsg", "获取不到accessToken");
			return jsonObject.toString();
		}
	}

	/**
	 * 获取验证码
	 * 
	 */
	@RequestMapping(value = "/getCheckCode")
	@ResponseBody
	public ModelAndView getCheckCode(HttpServletRequest request, HttpServletResponse response) throws Exception {
		response.setDateHeader("Expires", 0);
		response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
		response.addHeader("Cache-Control", "post-check=0, pre-check=0");
		response.setHeader("Pragma", "no-cache");
		response.setContentType("image/jpeg");
		String capText = captchaProducer.createText();
		request.getSession().setAttribute(Constants.KAPTCHA_SESSION_KEY, capText);
		BufferedImage bi = captchaProducer.createImage(capText);
		ServletOutputStream out = response.getOutputStream();
		ImageIO.write(bi, "png", out);
		try {
			out.flush();
		} finally {
			out.close();
		}
		return null;
	}

	/**
	 * 账号登入
	 * 
	 */
	@RequestMapping(value = "/login", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String login(HttpServletRequest request, HttpSession session) throws Exception {
		String kaptcha = (String) session.getAttribute(com.google.code.kaptcha.Constants.KAPTCHA_SESSION_KEY);
		String user = request.getParameter("user");
		String psd = request.getParameter("psd");
		String code = request.getParameter("code").toLowerCase();
		jsonObject = new JSONObject();
		if (!code.equals(kaptcha.toLowerCase())) {
			jsonObject.put("errcode", 1);
		} else {
			mUserService = new UserService();
			User user2 = new User();
			user2.setNickName(user);
			String psd2 = CommonUtils.encryptSHA256(user + "_" + psd);
			user2.setPassword(psd2);
			int result = mUserService.queryUser(user2);
			if (result == 0) {
				// 登入
				session.setAttribute("web_userid", user);
			}
			jsonObject.put("errcode", result);
		}
		return jsonObject.toString();
	}

}
