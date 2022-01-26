package com.fmlk.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import javax.activation.DataHandler;
import javax.activation.DataSource;
import javax.activation.FileDataSource;
import javax.mail.Authenticator;
import javax.mail.Flags;
import javax.mail.Folder;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.mail.internet.MimeUtility;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import com.fmlk.dao.Dao;
import com.fmlk.entity.AssignmentOrder;
import com.fmlk.entity.DailyReport;
import com.fmlk.entity.DailyUploadReport;
import com.fmlk.entity.ProjectCase;
import com.fmlk.entity.User;
import com.fmlk.entity.WechatCheck;
import com.google.gson.Gson;
import com.sun.mail.imap.IMAPFolder;
import com.sun.mail.imap.IMAPStore;

public class ExchangeMailUtil {

	public static String send(List<WechatCheck> list, String hostUrl) {
		try {
			Properties props = new Properties();
			String path = ExchangeMailUtil.class.getResource("/").getPath();
			path = path.substring(1, path.indexOf("WEB-INF/classes")) + "property/mail.properties";
			path = path.replaceAll("%20", " ");
			props.load(new FileInputStream(path));
			final String mailFromAddress = props.getProperty("mail.fromAddress");
			final String psd = props.getProperty("mail.fromPassword");
			Session session = Session.getDefaultInstance(props, new Authenticator() {
				public PasswordAuthentication getPasswordAuthentication() {
					return new PasswordAuthentication(mailFromAddress, psd);
				}
			});

			MimeMessage message = new MimeMessage(session);
			message.setFrom(new InternetAddress(mailFromAddress));// 发件箱
			message.addRecipient(Message.RecipientType.TO, new InternetAddress("695739869@qq.com"));// 收件箱
			message.setSubject("员工打卡异常待确认");// 邮件标题
			String text = "你有以下员工考勤异常，请确认";
			StringBuffer urlConfirm = new StringBuffer();
			urlConfirm.append(
					"<div style='background-color: #39A4DA; padding: 5px; border-radius: 5px 5px 5px 5px; color: #fff; text-align: center; font-size: 12px'>");
			urlConfirm.append("<table style='width: 100%; text-align: center;'>");
			urlConfirm.append("<tr style='width: 100%;'>");
			urlConfirm.append("<td style='width: 15%;'>姓名</td>");
			urlConfirm.append("<td style='width: 15%'>类型</td>");
			urlConfirm.append("<td style='width: 15%'>日期/时间</td>");
			urlConfirm.append("<td style='width: 20%'>地址</td>");
			urlConfirm.append("<td style=''width: 35%'>考勤确认</td>");
			urlConfirm.append("</tr></table>");
			urlConfirm.append(
					"<table style='width: 100%; background: #fff; border-collapse: collapse; border-spacing: 0; margin: 0; padding: 0; text-align: center;' border='1'>");
			String str = "";
			for (int i = 0; i < list.size(); i++) {
				WechatCheck wCheck = new WechatCheck();
				wCheck = list.get(i);
				String flag = wCheck.getCheckFlag();
				String state = "";
				if (flag.equals("签到") || flag.equals("打卡进")) {
					state = "迟到";
				} else {
					state = "早退";
				}

				str += "<tr style='color: #000;width: 100%;'>" + "<td style='width:15%;'><a>" + wCheck.getUserName()
						+ "</a></td>" + "<td style='width:15%;'><a>" + state + "</a></td>"
						+ "<td style='width:15%;'><a>" + wCheck.getDate() + " " + wCheck.getCheckTime() + "</a></td>"
						+ "<td style='width:20%;'><a>" + wCheck.getAddress() + "</a></td>" + "<td style='width:35%;'>"
						+ "<a href = " + hostUrl + "checkUpdate/2/" + wCheck.getId() + ">"
						+ "<input type='button' style ='background: #daff45;width: 100px; margin: 10px;' value='合规'/></a>"
						+ "<a href = " + hostUrl + "checkUpdate/1/" + wCheck.getId() + ">"
						+ "<input type='button' style ='background: #daff45;width: 100px; margin: 10px;' value='不合规'/></a>"
						+ "</td></tr>";
			}
			urlConfirm.append(str);
			urlConfirm.append("</table></div>");
			String body = text + "</br>" + urlConfirm.toString();// 邮件内容
			MimeMultipart mainPart = new MimeMultipart();
			MimeBodyPart contentBody = new MimeBodyPart();
			contentBody.setContent(body, "text/html; charset=utf-8");
			mainPart.addBodyPart(contentBody);
			message.setContent(mainPart);
			Transport.send(message);
			return "Sent message successfully";
		} catch (Exception e) {
			e.printStackTrace();
			return "Sent message failure";
		}

	}

	public static void send(List<DailyReport> dailyList) {
		try {
			Properties props = new Properties();
			String path = ExchangeMailUtil.class.getResource("/").getPath();
			path = path.substring(1, path.indexOf("WEB-INF/classes")) + "property/mail.properties";
			path = path.replaceAll("%20", " ");
			props.load(new FileInputStream(path));
			final String mailFromAddress = props.getProperty("mail.fromAddress");
			final String psd = props.getProperty("mail.fromPassword");
			Session session = Session.getDefaultInstance(props, new Authenticator() {
				public PasswordAuthentication getPasswordAuthentication() {
					return new PasswordAuthentication(mailFromAddress, psd);
				}
			});

			MimeMessage message = new MimeMessage(session);
			message.setFrom(new InternetAddress(mailFromAddress));// 发件箱
			message.addRecipient(Message.RecipientType.TO, new InternetAddress("695739869@qq.com"));// 收件箱
			message.setSubject("员工日程");// 邮件标题
			StringBuffer urlConfirm = new StringBuffer();
			urlConfirm.append(
					"<div style='background-color: #39A4DA; padding: 5px; border-radius: 5px 5px 5px 5px; color: #fff; text-align: center; font-size: 6px'>");
			urlConfirm.append("<table style='width: 100%; text-align: center;table-layout:fixed'>");
			String str = "";
			String str1 = "";
			String str7 = "";
			str += "<tr style='width: 100%;'>" + "<td style='width:6%;'><a>日期</a></td>"
					+ "<td style='width:4%;'><a>姓名</a></td>" + "<td style='width:10%'><a>日程</a></td>"
					+ "<td style='width:6%;'><a>日程发送时间</a></td>" + "<td style='width:4%;'><a>日报</a></td>"
					+ "<td style='width:4%'><a>周报</a></td>" + "<td style='width:4%'><a>下周计划</a></td>"
					+ "<td style='width:4%'><a>crm上传</a></td>" + "<td style='width:4%'><a>项目计划</a></td>"
					+ "<td style='width:20%'><a>签到/签退</a></td>" + "<td style='width:10%'><a>备注/日程调整</a></td>"
					+ "<td style='width:4%;'><a>加班</a></td>" + "<td style='width:4%;'><a>调休</a></td>"
					+ "<td style='width:6%;'><a>放假期间加班</a></td>" + "<td style='width:6%;'><a>国定假日加班</a></td>"
					+ "<td style='width:4%;'><a>迟到</a></td>" + "</tr>";
			urlConfirm.append(str);
			urlConfirm.append("</table>");
			urlConfirm.append("<table style='width: 100%; background: #fff; border-collapse: collapse; "
					+ "border-spacing: 0; margin: 0; padding: 0; text-align: center;table-layout:fixed' border='1'>");

			for (int i = 0; i < dailyList.size(); i++) {
				DailyReport dr = new DailyReport();
				dr = dailyList.get(i);
				if (dr.getIsLate() != 0) {
					str7 = "<td style='width:4%;'><a>迟到</a></td>";
				} else {
					str7 = "<td style='width:4%'><a></a></td>";
				}
				str1 += "<tr style='color: #000;width: 100%;'>" + "<td style='width:6%;'><a>" + dr.getDate()
						+ "</a></td>" + "<td style='width:4%;'><a>" + dr.getName() + "</a></td>"
						+ "<td style='width:10%;word-wrap:break-word;'><a>" + dr.getSchedule() + "</a></td>"
						+ "<td style='width:6%;'><a>" + dr.getScheduleState() + "</a></td>"
						+ "<td style='width:4%;'><a>" + dr.getDailyReport() + "</a></td>" + "<td style='width:4%'><a>"
						+ dr.getWeekReport() + "</a></td>" + "<td style='width:4%'><a>" + dr.getNextWeekPlan()
						+ "</a></td>" + "<td style='width:4%'><a>" + dr.getCrmUpload() + "</a></td>"
						+ "<td style='width:4%'><a>" + dr.getProjectReport() + "</a></td>"
						+ "<td style='width:20%;word-wrap:break-word;'><a>" + dr.getSign() + "</a></td>"
						+ "<td style='width:10%;word-wrap:break-word;'><a>" + dr.getRemark() + "</a></td>"
						+ "<td style='width:4%;'><a>" + dr.getOverWorkTime() + "</a></td>" + "<td style='width:4%;'><a>"
						+ dr.getAdjustRestTime() + "</a></td>" + "<td style='width:6%;'><a>"
						+ dr.getVacationOverWorkTime() + "</a></td>" + "<td style='width:6%;'><a>"
						+ dr.getFestivalOverWorkTime() + "</a></td>" + str7 + "</tr>";
			}
			urlConfirm.append(str1);
			urlConfirm.append("</table></div>");
			String body = urlConfirm.toString();// 邮件内容
			MimeMultipart mainPart = new MimeMultipart();
			MimeBodyPart contentBody = new MimeBodyPart();
			contentBody.setContent(body, "text/html; charset=utf-8");
			mainPart.addBodyPart(contentBody);
			message.setContent(mainPart);
			Transport.send(message);

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static void sendAssignmentEmail(List<AssignmentOrder> overTimeList) {
		try {
			Properties props = new Properties();
			String path = ExchangeMailUtil.class.getResource("/").getPath();
			path = path.substring(1, path.indexOf("WEB-INF/classes")) + "property/mail.properties";
			path = path.replaceAll("%20", " ");
			props.load(new FileInputStream(path));
			final String mailFromAddress = props.getProperty("mail.fromAddress");
			final String psd = props.getProperty("mail.fromPassword");
			Session session = Session.getDefaultInstance(props, new Authenticator() {
				public PasswordAuthentication getPasswordAuthentication() {
					return new PasswordAuthentication(mailFromAddress, psd);
				}
			});

			// 超时未完成的事务推送
			if (overTimeList.size() > 0) {
				final String bossAddress = props.getProperty("mail.toBossAddress");
				int addressNum = bossAddress.split(",").length;

				for (int i = 0; i < overTimeList.size(); i++) {
					String userList = overTimeList.get(i).getUserList();
					Dao dao = new Dao();
					List<User> uList = new ArrayList<User>();
					uList = dao.getUserList(userList.split(","));
					InternetAddress[] mailTobossAddress = new InternetAddress[addressNum + uList.size()];
					for (int j = 0; j < addressNum; j++) {
						mailTobossAddress[j] = new InternetAddress(bossAddress.split(",")[j]);
					}
					for (int k = 0; k < uList.size(); k++) {
						mailTobossAddress[addressNum + k] = new InternetAddress(uList.get(k).getEmail());
					}
					List<AssignmentOrder> newList = new ArrayList<AssignmentOrder>();
					newList.add(overTimeList.get(i));
					// System.out.print(overTimeList.get(i).getProjectName()+"
					// "+mailTobossAddress.length);
					sendAssignmentMessage(session, "项目超时未完成通知", "以下项目超时未完成，请悉知", mailFromAddress, mailTobossAddress,
							newList);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static void sendAssignmentEmail(List<AssignmentOrder> startJobList, List<AssignmentOrder> overTimeList,
			List<AssignmentOrder> deadLineList) {
		try {
			Properties props = new Properties();
			String path = ExchangeMailUtil.class.getResource("/").getPath();
			path = path.substring(1, path.indexOf("WEB-INF/classes")) + "property/mail.properties";
			path = path.replaceAll("%20", " ");
			props.load(new FileInputStream(path));
			final String mailFromAddress = props.getProperty("mail.fromAddress");
			final String psd = props.getProperty("mail.fromPassword");
			Session session = Session.getDefaultInstance(props, new Authenticator() {
				public PasswordAuthentication getPasswordAuthentication() {
					return new PasswordAuthentication(mailFromAddress, psd);
				}
			});

			// 超时未完成的事务推送
			if (overTimeList.size() > 0) {

				final String bossAddress = props.getProperty("mail.toBossAddress");
				int addressNum = bossAddress.split(",").length;// property读取的默认发送的数量

				/*
				 * InternetAddress[] mailTobossAddress = new InternetAddress[addressNum]; for
				 * (int k = 0; k < addressNum; k++) { mailTobossAddress[k] = new
				 * InternetAddress(bossAddress.split(",")[k]); }
				 */
				// sendAssignmentMessage(session,"项目超时未完成通知", "以下项目超时未完成，请悉知",
				// mailFromAddress,mailTobossAddress,overTimeList);
				// 2018-04-25 修改可以发送给项目参与人

				for (int i = 0; i < overTimeList.size(); i++) {
					String userList = overTimeList.get(i).getUserList();
					Dao dao = new Dao();
					List<User> uList = new ArrayList<User>();
					uList = dao.getUserList(userList.split(","));
					InternetAddress[] mailTobossAddress = new InternetAddress[addressNum + uList.size()];
					for (int j = 0; j < addressNum; j++) {
						mailTobossAddress[j] = new InternetAddress(bossAddress.split(",")[j]);
					}
					for (int k = 0; k < uList.size(); k++) {
						mailTobossAddress[addressNum + k] = new InternetAddress(uList.get(k).getEmail());
					}
					List<AssignmentOrder> newList = new ArrayList<AssignmentOrder>();
					newList.add(overTimeList.get(i));
					System.out.print(overTimeList.get(i).getProjectName() + "   " + mailTobossAddress.length);
					sendAssignmentMessage(session, "项目超时未完成通知", "以下项目超时未完成，请悉知", mailFromAddress, mailTobossAddress,
							newList);
				}
			}
			// 天当开始事务的推送
			if (startJobList.size() > 0) {
				for (int i = 0; i < startJobList.size(); i++) {
					String userList = startJobList.get(i).getUserList();
					Dao dao = new Dao();
					List<User> uList = new ArrayList<User>();
					uList = dao.getUserList(userList.split(","));
					InternetAddress[] mailToAddress = new InternetAddress[uList.size()];
					for (int j = 0; j < uList.size(); j++) {
						mailToAddress[j] = new InternetAddress(uList.get(j).getEmail());
					}
					List<AssignmentOrder> newList = new ArrayList<AssignmentOrder>();
					newList.add(startJobList.get(i));
					sendAssignmentMessage(session, "新的项目开始通知", "以下项目今天开始启动，你是项目参与人，请悉知", mailFromAddress, mailToAddress,
							newList);
				}
			}
			// 天当结束事务的推送
			if (deadLineList.size() > 0) {
				for (int i = 0; i < deadLineList.size(); i++) {
					String userList = deadLineList.get(i).getUserList();
					Dao dao = new Dao();
					List<User> uList = new ArrayList<User>();
					uList = dao.getUserList(userList.split(","));
					InternetAddress[] mailToAddress = new InternetAddress[uList.size()];
					for (int j = 0; j < uList.size(); j++) {
						String addStr = uList.get(j).getEmail();
						mailToAddress[j] = new InternetAddress(addStr);
					}
					List<AssignmentOrder> newList = new ArrayList<AssignmentOrder>();
					newList.add(deadLineList.get(i));
					sendAssignmentMessage(session, "项目即将到期通知", "以下项目今天是截止日期，你是项目参与人，请悉知。</br>若已完成，通知管理员修改项目状态。",
							mailFromAddress, mailToAddress, newList);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private static void sendAssignmentMessage(Session se, String title, String text, String mailFrom,
			InternetAddress[] mailTo, List<AssignmentOrder> assignmentList) throws IOException {
		try {
			MimeMessage message = new MimeMessage(se);
			message.setFrom(new InternetAddress(mailFrom));// 发件箱
			message.addRecipients(Message.RecipientType.TO, mailTo);// 收件箱
			message.setSubject(title);// 邮件标题
			StringBuffer urlConfirm = new StringBuffer();

			AssignmentOrder ao = new AssignmentOrder();
			ao = assignmentList.get(0);
			urlConfirm.append("<div><table  border='0'>");
			urlConfirm.append("<tr><td><a>项目名称：" + ao.getProjectName() + "</a></td></tr>");
			urlConfirm.append("<tr><td><a>项目内容：" + ao.getServiceContent() + "</a></td></tr>");
			urlConfirm.append("<tr><td><a>客户公司：" + ao.getClientCompany() + "</a></td></tr>");
			urlConfirm.append("<tr><td><a>客户联系人：" + ao.getClientContact() + "</a></td></tr>");
			urlConfirm.append("<tr><td><a>开始：" + ao.getStartDate() + "</a></td></tr>");
			urlConfirm.append("<tr><td><a>结束：" + ao.getEndDate() + "</a></td></tr>");
			urlConfirm.append("<tr><td><a>参与人：" + ao.getUserList() + "</a></td></tr></table></div>");

			String body = text + "</br></br>" + urlConfirm.toString();// 邮件内容
			MimeMultipart mainPart = new MimeMultipart();
			MimeBodyPart contentBody = new MimeBodyPart();
			contentBody.setContent(body, "text/html; charset=utf-8");
			mainPart.addBodyPart(contentBody);
			message.setContent(mainPart);

			// test20181228
			Properties props = new Properties();
			String path = ExchangeMailUtil.class.getResource("/").getPath();
			path = path.substring(1, path.indexOf("WEB-INF/classes")) + "property/upload.properties";
			path = path.replaceAll("%20", " ");
			props.load(new FileInputStream(path));
			String saveFileDir = props.getProperty("upload.logUrl");
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd_HH-mm-ss");
			// 文件夹
			saveFileDir = saveFileDir + "/" + format.format(new Date());
			File file = new File(saveFileDir);
			if (!file.exists()) {
				file.mkdirs();
			}
			// 文件
			String fileName = ao.getProjectName() + ".txt";
			File file2 = new File(file, fileName);
			if (!file2.exists()) {
				file2.createNewFile();
			}

			FileOutputStream out = new FileOutputStream(file2, true);
			StringBuffer sb = new StringBuffer();
			StringBuffer sb2 = new StringBuffer();
			InternetAddress ia = new InternetAddress();
			for (int k = 0; k < mailTo.length; k++) {
				ia = mailTo[k];
				sb2.append(ia.toString() + "\r\n");
			}
			sb.append(ao.getProjectName() + "\r\n");
			sb.append(mailTo.length + "\r\n");
			sb.append(sb2.toString());
			out.write(sb.toString().getBytes("utf-8"));
			out.close();
			// end of test

			Transport.send(message);

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static void sendDailyUploadReportEmail(String date, List<DailyUploadReport> durList) {
		try {
			Properties props = new Properties();
			String path = ExchangeMailUtil.class.getResource("/").getPath();
			String path1 = path.substring(1, path.indexOf("WEB-INF/classes")) + "property/mail.properties";
			path1 = path1.replaceAll("%20", " ");
			props.load(new FileInputStream(path1));
			final String mailFromAddress = props.getProperty("mail.fromAddress");
			final String psd = props.getProperty("mail.fromPassword");
			Session session = Session.getDefaultInstance(props, new Authenticator() {
				public PasswordAuthentication getPasswordAuthentication() {
					return new PasswordAuthentication(mailFromAddress, psd);
				}
			});

			final String bossAddress = props.getProperty("mail.toBossAddress");
			int addressNum = bossAddress.split(",").length;

			InternetAddress[] mailTobossAddress = new InternetAddress[addressNum];
			for (int j = 0; j < addressNum; j++) {
				mailTobossAddress[j] = new InternetAddress(bossAddress.split(",")[j]);
			}

			Properties props2 = new Properties();
			String path2 = path.substring(1, path.indexOf("WEB-INF/classes")) + "property/upload.properties";
			path2 = path2.replaceAll("%20", " ");
			props2.load(new FileInputStream(path2));
			String saveFileDir = props2.getProperty("upload.excelUrl");
			// 昨天的日报转存到本地excel
			createExcelFile(saveFileDir, date, durList);
			sendDailyUploadReportMessage(saveFileDir, date, session, mailFromAddress, mailTobossAddress);

		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	private static void sendDailyUploadReportMessage(String fileDir, String date, Session se, String mailFrom,
			InternetAddress[] mailTo) {
		try {
			MimeMessage message = new MimeMessage(se);
			message.setFrom(new InternetAddress(mailFrom));// 发件箱
			message.addRecipients(Message.RecipientType.TO, mailTo);// 收件箱

			// message.addRecipients(Message.RecipientType.TO, new InternetAddress[]{new
			// InternetAddress("lu.haiming@lanstarnet.com")});
			message.setSubject(date.replaceAll("/", "-") + " 日报");// 邮件标题
			MimeMultipart mainPart = new MimeMultipart();
			MimeBodyPart attch = new MimeBodyPart();
			mainPart.addBodyPart(attch);// 附件加入消息体

			MimeBodyPart contentBody = new MimeBodyPart();
			contentBody.setContent("附件是 " + date.replaceAll("/", "-") + " 日报" + ", 请查收", "text/html; charset=utf-8");
			mainPart.addBodyPart(contentBody);

			DataSource ds1 = new FileDataSource(new File(fileDir + date.replaceAll("/", "-") + " 日报.xls"));
			DataHandler dh1 = new DataHandler(ds1);
			// 设置第一个附件的数据
			attch.setDataHandler(dh1);
			// 设置第一个附件的文件名
			attch.setFileName(MimeUtility.encodeText(date.replaceAll("/", "-") + " 日报.xls"));
			message.setContent(mainPart);
			Transport.send(message);

		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	private static void createExcelFile(String fileDir, String date, List<DailyUploadReport> durList) {
		try {
			Workbook wb = new HSSFWorkbook();
			Sheet sheet1 = wb.createSheet(date.replaceAll("/", "-") + " 日报");
			Dao dao = new Dao();
			List<User> uList = new ArrayList<User>();
			uList = dao.getUserList2(date, 12);
			Row row = sheet1.createRow(0);
			row.createCell(0).setCellValue("姓名");
			row.createCell(1).setCellValue("时间");
			row.createCell(2).setCellValue("CRM编号");
			row.createCell(3).setCellValue("项目名称");
			row.createCell(4).setCellValue("工作内容");
			row.createCell(5).setCellValue("后续支持");
			row.createCell(6).setCellValue("备注");
			int thisLine = 1;
			for (int i = 0; i < uList.size(); i++) {
				boolean isExist = false;
				String uName = uList.get(i).getName();
				List<DailyUploadReport> newList = new ArrayList<DailyUploadReport>();

				for (int j = 0; j < durList.size(); j++) {
					if (durList.get(j).getUserName().equals(uName)) {
						isExist = true;
						newList.add(durList.get(j));
						// newList只需要技术和销售
					}
				}
				if (!uName.equals("杨惠芳") && !uName.equals("张鸿星")) {
					if (!isExist) {
						// 未发日报
						Row row1 = sheet1.createRow(thisLine);
						row1.createCell(0).setCellValue(uName);
						thisLine = thisLine + 1;
					} else {
						// 已发日报
						for (int k = 0; k < newList.size(); k++) {
							Row row1 = sheet1.createRow(thisLine);
							if (k == 0) {
								row1.createCell(0).setCellValue(uName);
							}
							row1.createCell(1).setCellValue(newList.get(k).getTime());
							row1.createCell(2).setCellValue(newList.get(k).getCrmNum());
							// 销售没有crm编号 ，这里要排除
							if (!newList.get(k).getCrmNum().equals("")) {
								String jsonProjectName = dao.getProjectName(newList.get(k).getCrmNum());
								String name = new Gson().fromJson(jsonProjectName, Map.class).get("projectName")
										.toString();
								row1.createCell(3).setCellValue(name);
							}
							row1.createCell(4).setCellValue(newList.get(k).getJobContent());
							row1.createCell(5).setCellValue(newList.get(k).getLaterSupport());
							row1.createCell(6).setCellValue(newList.get(k).getRemark());
							thisLine = thisLine + 1;
						}
					}
				}
			}

			String mYear = date.split("/")[0];
			String mMonth = date.split("/")[1];
			switch (mMonth) {
			case "1":
				mMonth = "January";
				break;
			case "2":
				mMonth = "February";
				break;
			case "3":
				mMonth = "March";
				break;
			case "4":
				mMonth = "April";
				break;
			case "5":
				mMonth = "May";
				break;
			case "6":
				mMonth = "June";
				break;
			case "7":
				mMonth = "July";
				break;
			case "8":
				mMonth = "Aguest";
				break;
			case "9":
				mMonth = "September";
				break;
			case "10":
				mMonth = "October";
				break;
			case "11":
				mMonth = "November";
				break;
			case "12":
				mMonth = "December";
				break;
			}

			FileOutputStream fileOut = new FileOutputStream(
					fileDir + "/" + mYear + "/" + mMonth + "/" + date.replaceAll("/", "-") + " 日报.xls");
			wb.write(fileOut);
			fileOut.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public static String sendProjectCaseInform(ProjectCase pc, int checkResult, int type, List<User> userList,
			String companyName, String projectName) throws IOException {
		// checkResult 1.通过 2.拒绝
		// type 1.编辑2.销售审核 2. 技术审核
		try {
			Properties props = new Properties();
			String path = ExchangeMailUtil.class.getResource("/").getPath();
			path = path.substring(1, path.indexOf("WEB-INF/classes")) + "property/mail.properties";
			path = path.replaceAll("%20", " ");
			props.load(new FileInputStream(path));
			final String mailFromAddress = props.getProperty("mail.fromAddress");
			final String psd = props.getProperty("mail.fromPassword");
			final String dispatchUserAddress = props.getProperty("mail.dispatchUserAddress");
			Session session = Session.getDefaultInstance(props, new Authenticator() {
				public PasswordAuthentication getPasswordAuthentication() {
					return new PasswordAuthentication(mailFromAddress, psd);
				}
			});

			final String bossAddress = props.getProperty("mail.toBossAddress");
			InternetAddress[] mailTobossAddress;
			String nameList = "";
			if (type == 1) {
				// 销售审核
				mailTobossAddress = new InternetAddress[2];
				mailTobossAddress[0] = new InternetAddress(bossAddress);
				mailTobossAddress[1] = new InternetAddress(dispatchUserAddress);
			} else {
				// 技术派工
				mailTobossAddress = new InternetAddress[userList.size() + 1];
				for (int i = 0; i < userList.size(); i++) {
					mailTobossAddress[i] = new InternetAddress(userList.get(i).getEmail());
					nameList += userList.get(i).getName() + ",";
				}
				mailTobossAddress[userList.size()] = new InternetAddress(bossAddress);
			}
			MimeMessage message = new MimeMessage(session);
			message.setFrom(new InternetAddress(mailFromAddress));// 发件箱
			message.addRecipients(Message.RecipientType.TO, mailTobossAddress);// 收件箱

			if (type == 1) {
				message.setSubject("[销售审核通知]");// 邮件标题
			} else {
				message.setSubject("[技术派工通知]");// 邮件标题
			}
			StringBuffer urlConfirm = new StringBuffer();

			urlConfirm.append("<div><table  border='0'>");
			urlConfirm.append("<tr><td><a>项目名称：" + projectName + "</a></td></tr>");
			urlConfirm.append("<tr><td><a>客户名称：" + companyName + "</a></td></tr>");
			urlConfirm.append("<tr><td><a>服务时间：" + pc.getServiceDate() + "</a></td></tr>");
			urlConfirm.append("<tr><td><a>服务内容：" + pc.getServiceContent() + "</a></td></tr>");
			urlConfirm.append("<tr><td><a>审核结果：" + (checkResult != 1 ? "拒绝" : "通过") + "</a></td></tr>");
			if (checkResult != 1) {
				urlConfirm.append("<tr><td><a>拒绝理由：" + pc.getRejectReason() + "</a></td></tr></table></div>");
			} else if (type == 2) {
				urlConfirm.append("<tr><td><a>销售&服务工程师：" + nameList.trim() + "</a></td></tr></table></div>");
			}
			String body = urlConfirm.toString();// 邮件内容
			MimeMultipart mainPart = new MimeMultipart();
			MimeBodyPart contentBody = new MimeBodyPart();
			contentBody.setContent(body, "text/html; charset=utf-8");
			mainPart.addBodyPart(contentBody);
			message.setContent(mainPart);
			Transport.send(message);
		} catch (Exception e) {
			e.printStackTrace();
			return "Sent message failure";
		}
		return null;
	}

	public static void sendAlertEmail() {
		try {
			Properties props = new Properties();
			String path = ExchangeMailUtil.class.getResource("/").getPath();
			path = path.substring(1, path.indexOf("WEB-INF/classes")) + "property/mail.properties";
			path = path.replaceAll("%20", " ");
			props.load(new FileInputStream(path));
			final String mail = props.getProperty("mail.163.user");
			final String psd = props.getProperty("mail.163.password");// 授权码
			final String protocol = props.getProperty("mail.store.protocol");
			Session session = Session.getDefaultInstance(props, new Authenticator() {
				public PasswordAuthentication getPasswordAuthentication() {
					return new PasswordAuthentication(mail, psd);
				}
			});
			IMAPStore store = (IMAPStore) session.getStore(protocol);
			store.connect(mail, psd);
			IMAPFolder folder = (IMAPFolder) store.getFolder("INBOX");
			folder.open(Folder.READ_WRITE);
		//	System.out.println("新邮件数量    " + folder.getNewMessageCount());
			if(folder.getNewMessageCount() !=0) {
				Message[] messages = folder.getMessages(folder.getMessageCount()-folder.getNewMessageCount()+1,folder.getMessageCount());
				for (int i = 0; i < messages.length; i++) {
					Message msg = messages[i];
					String title = MimeUtility.decodeText(msg.getSubject());
					String mContent = MimeUtility.decodeText(new String(msg.getContent().toString().getBytes("ISO8859_1"),"GBK"));
					SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
					String time = formatter.format(msg.getSentDate());
					String accessToken = WeChatEnterpriseUtils.getAccessToken();
					
					if(title.contains("CactiEZ")) {
						//推送
						WeChatEnterpriseUtils.sendTongJiAlert(accessToken, title,mContent,time);
					}
					msg.setFlag(Flags.Flag.SEEN, true);
				}
			}
			
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}


}
