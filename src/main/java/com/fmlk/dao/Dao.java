package com.fmlk.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.List;
import com.fmlk.entity.Agency;
import com.fmlk.entity.Area;
import com.fmlk.entity.AssignmentOrder;
import com.fmlk.entity.CaseType;
import com.fmlk.entity.CheckStatistics;
import com.fmlk.entity.ClientField;
import com.fmlk.entity.Company;
import com.fmlk.entity.ContactUser;
import com.fmlk.entity.DailyArrangement;
import com.fmlk.entity.DailyReport;
import com.fmlk.entity.DailyUploadReport;
import com.fmlk.entity.DailyWechatCheck;
import com.fmlk.entity.Department;
import com.fmlk.entity.JobPosition;
import com.fmlk.entity.MonthReport;
import com.fmlk.entity.PermissionSetting;
import com.fmlk.entity.ProductBrand;
import com.fmlk.entity.ProductStyle;
import com.fmlk.entity.Project;
import com.fmlk.entity.ProjectType;
import com.fmlk.entity.Role;
import com.fmlk.entity.RolePermission;
import com.fmlk.entity.ScheduleReport;
import com.fmlk.entity.Tender;
import com.fmlk.entity.TenderStyle;
import com.fmlk.entity.User;
import com.fmlk.entity.WechatCheck;
import com.fmlk.entity.WeekDetail;
import com.fmlk.entity.WeekUploadReport;
import com.fmlk.entity.WorkTimeAdjust;
import com.fmlk.util.CommonUtils;
import com.fmlk.util.DBConnection;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public class Dao {

	private Connection con, con2, con3 = null;
	private PreparedStatement pre, pre2, pre3 = null;
	private String sql, sql2, sql3 = null;
	private JSONObject jsonObject = null;
	private ResultSet res, res2, res3 = null;
	private List<DailyReport> list = null;
	private List<MonthReport> list2 = null;
	private List<User> uList = null;
	private List<WechatCheck> wList = null;
	private List<DailyWechatCheck> dwList = null;
	private List<CheckStatistics> csList = null;
	private List<WeekDetail> wdList = null;
	private List<ScheduleReport> spList = null;
	private List<Company> cList = null;
	private List<Project> pList = null;
	private List<AssignmentOrder> aoList = null;
	private List<DailyUploadReport> durList = null;
	private List<WorkTimeAdjust> wtaList = null;
	private List<Agency> aList = null;
	private List<ClientField> cfList = null;
	private List<Area> areaList = null;
	private List<TenderStyle> tsList = null;
	private List<ProductStyle> psList = null;
	private List<ProductBrand> pbList = null;
	private List<ProjectType> ptList = null;
	private List<CaseType> ctList = null;
	private List<Department> dList = null;
	private List<Role> rList = null;
	private List<RolePermission> rpList = null;
	private List<PermissionSetting> psetList = null;

	public boolean add(DailyReport dp) {
		try {
			sql = "insert into daily_report (date,name,schedule,scheduleState,dailyReport,weekReport,nextWeekPlan,crmUpload,"
					+ "projectReport,others,sign,remark,islate,overWorkTime,adjustRestTime,vacationOverWorkTime,festivalOverWorkTime) "
					+ "values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, dp.getDate());
			pre.setString(2, dp.getName());
			pre.setString(3, dp.getSchedule());
			pre.setString(4, dp.getScheduleState());
			pre.setString(5, dp.getDailyReport());
			pre.setString(6, dp.getWeekReport());
			pre.setString(7, dp.getNextWeekPlan());
			pre.setString(8, dp.getCrmUpload());
			pre.setString(9, dp.getProjectReport());
			pre.setString(10, dp.getOthers());
			pre.setString(11, dp.getSign());
			pre.setString(12, dp.getRemark());
			pre.setInt(13, dp.getIsLate());
			pre.setDouble(14, dp.getOverWorkTime());
			pre.setDouble(15, dp.getAdjustRestTime());
			pre.setDouble(16, dp.getVacationOverWorkTime());
			pre.setDouble(17, dp.getFestivalOverWorkTime());
			int i = pre.executeUpdate();
			if (i > 0) {
				return true;
			} else {
				return false;
			}
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
		}
	}

	public String getMonthList(String date, int dept) {
		// System.out.println("1 "+date);
		// System.out.println("1 "+dept);
		try {
			sql = "select * from daily_report where CAST(date AS datetime)>=CAST(? AS datetime) "
					+ "and CAST(date AS datetime)<=CAST(? AS datetime)";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, date + "/1");
			pre.setString(2, date + "/" + CommonUtils.getDays(date));
			res = pre.executeQuery();
			list = new ArrayList<DailyReport>();
			while (res.next()) {
				DailyReport dr = new DailyReport();
				dr.setDate(res.getString("date"));
				dr.setName(res.getString("name"));
				dr.setSchedule(res.getString("schedule"));
				dr.setScheduleState(res.getString("scheduleState"));
				dr.setDailyReport(res.getString("dailyReport"));
				dr.setWeekReport(res.getString("weekReport"));
				dr.setNextWeekPlan(res.getString("nextWeekPlan"));
				dr.setCrmUpload(res.getString("crmUpload"));
				dr.setProjectReport(res.getString("projectReport"));
				dr.setOthers(res.getString("others"));
				dr.setSign(res.getString("sign"));
				dr.setRemark(res.getString("remark"));
				dr.setIsLate(res.getInt("islate"));
				dr.setOverWorkTime(res.getDouble("overWorkTime"));
				dr.setAdjustRestTime(res.getDouble("adjustRestTime"));
				dr.setVacationOverWorkTime(res.getDouble("vacationOverWorkTime"));
				dr.setFestivalOverWorkTime(res.getDouble("festivalOverWorkTime"));
				list.add(dr);
			}

			uList = new ArrayList<User>();
			uList = getUserList2(date + "/1", dept);
			list2 = new ArrayList<MonthReport>();
			for (int i = 0; i < uList.size(); i++) {
				String name = uList.get(i).getName();
				int scheduleT = 0, dailyReportT = 0, weekReportT = 0, nextWeekPlanT = 0;
				int crmUploadT = 0, projectReportT = 0, othersT = 0;
				int noSignIn = 0, noSignOut = 0, isLateT = 0;
				double overWorkTimeT = 0, adjustRestTimeT = 0, vacationOverWorkTimeT = 0, festivalOverWorkTimeT = 0;
				double overWorkTimeT4H = 0, accumulateOverWorkTimeT = 0;
				MonthReport mReport = new MonthReport();
				for (int j = 0; j < list.size(); j++) {
					if (name.equals(list.get(j).getName())) {
						DailyReport dReport = list.get(j);
						if (!dReport.getScheduleState().equals("正常") && !dReport.getScheduleState().equals("")) {
							scheduleT++;
						}
						if (dReport.getDailyReport().equals("未发")) {
							dailyReportT++;
						}
						if (dReport.getWeekReport().equals("未发")) {
							weekReportT++;
						}
						if (dReport.getNextWeekPlan().equals("未发")) {
							nextWeekPlanT++;
						}
						if (dReport.getCrmUpload().equals("未上传")) {
							crmUploadT++;
						}
						if (dReport.getProjectReport().equals("未发")) {
							projectReportT++;
						}
						if (dReport.getOthers().equals("未发")) {
							othersT++;
						}
						if (!dReport.getSign().equals("")) {
							String[] str = dReport.getSign().split(";");
							for (int k = 0; k < str.length; k++) {
								if (str[k].split("-")[0].equals("未签到")) {
									noSignIn++;
								}
								if (str[k].split("-")[1].equals("未签退")) {
									noSignOut++;
								}
							}
						}
						isLateT = isLateT + dReport.getIsLate();
						if (dReport.getOverWorkTime() > 3.9) {
							overWorkTimeT = overWorkTimeT + 4.0;
							overWorkTimeT4H = overWorkTimeT4H + (dReport.getOverWorkTime() - 4.0);
						} else {
							overWorkTimeT = overWorkTimeT + dReport.getOverWorkTime();
						}

						adjustRestTimeT = adjustRestTimeT + dReport.getAdjustRestTime();
						vacationOverWorkTimeT = vacationOverWorkTimeT + dReport.getVacationOverWorkTime();
						festivalOverWorkTimeT = festivalOverWorkTimeT + dReport.getFestivalOverWorkTime();
					}
				}
				mReport.setName(name);
				mReport.setScheduleT(scheduleT);
				mReport.setDailyReportT(dailyReportT);
				mReport.setWeekReportT(weekReportT);
				mReport.setNextWeekPlanT(nextWeekPlanT);
				mReport.setCrmUploadT(crmUploadT);
				mReport.setProjectReportT(projectReportT);
				mReport.setNoSignIn(noSignIn);
				mReport.setNoSignOut(noSignOut);
				mReport.setIsLate(isLateT);
				mReport.setOverWorkTime(overWorkTimeT);
				mReport.setAdjustRestTime(adjustRestTimeT);
				mReport.setVacationOverWorkTime(vacationOverWorkTimeT);
				mReport.setFestivalOverWorkTime(festivalOverWorkTimeT);
				mReport.setOverWorkTime4H(overWorkTimeT4H);
				mReport.setAccumulateOverWorkTime(0.0);
				list2.add(mReport);
			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("monthlist", JSONArray.fromObject(list2));
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
			DBConnection.closeRes(res);
		}
		return null;
	}

	public String getDailyList(String date) {
		try {
			sql = "select * from daily_report where date = ?";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, date);
			res = pre.executeQuery();
			list = new ArrayList<DailyReport>();
			while (res.next()) {
				DailyReport dr = new DailyReport();
				dr.setDate(res.getString("date"));
				dr.setName(res.getString("name"));
				dr.setSchedule(res.getString("schedule"));
				dr.setScheduleState(res.getString("scheduleState"));
				dr.setDailyReport(res.getString("dailyReport"));
				dr.setWeekReport(res.getString("weekReport"));
				dr.setNextWeekPlan(res.getString("nextWeekPlan"));
				dr.setCrmUpload(res.getString("crmUpload"));
				dr.setProjectReport(res.getString("projectReport"));
				dr.setOthers(res.getString("others"));
				dr.setSign(res.getString("sign"));
				dr.setRemark(res.getString("remark"));
				dr.setIsLate(res.getInt("islate"));
				dr.setOverWorkTime(res.getDouble("overWorkTime"));
				dr.setAdjustRestTime(res.getDouble("adjustRestTime"));
				dr.setVacationOverWorkTime(res.getDouble("vacationOverWorkTime"));
				dr.setFestivalOverWorkTime(res.getDouble("festivalOverWorkTime"));
				list.add(dr);
			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("dailylist", JSONArray.fromObject(list));
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
			DBConnection.closeRes(res);
		}
		return null;
	}

	public String getDailyList(String name, String date) {
		try {
			sql = "select * from daily_report where name = ? " + "and CAST(date AS datetime)>=CAST(? AS datetime)"
					+ "and CAST(date AS datetime)<=CAST(? AS datetime) " + "order by CAST(date AS datetime)";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, name);
			pre.setString(2, date + "/1");
			pre.setString(3, date + "/" + CommonUtils.getDays(date));
			res = pre.executeQuery();
			list = new ArrayList<DailyReport>();
			while (res.next()) {
				DailyReport dr = new DailyReport();
				dr.setDate(res.getString("date"));
				dr.setName(res.getString("name"));
				dr.setSchedule(res.getString("schedule"));
				dr.setScheduleState(res.getString("scheduleState"));
				dr.setDailyReport(res.getString("dailyReport"));
				dr.setWeekReport(res.getString("weekReport"));
				dr.setNextWeekPlan(res.getString("nextWeekPlan"));
				dr.setCrmUpload(res.getString("crmUpload"));
				dr.setProjectReport(res.getString("projectReport"));
				dr.setOthers(res.getString("others"));
				dr.setSign(res.getString("sign"));
				dr.setRemark(res.getString("remark"));
				dr.setIsLate(res.getInt("islate"));
				dr.setOverWorkTime(res.getDouble("overWorkTime"));
				dr.setAdjustRestTime(res.getDouble("adjustRestTime"));
				dr.setVacationOverWorkTime(res.getDouble("vacationOverWorkTime"));
				dr.setFestivalOverWorkTime(res.getDouble("festivalOverWorkTime"));
				list.add(dr);
			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("dailylist", JSONArray.fromObject(list));
			// System.out.println(JSONArray.fromObject(list));
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
			DBConnection.closeRes(res);
		}
		return null;
	}

	public String getAgencyList() {
		try {
			sql = "select * from agency order by agencyName";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			res = pre.executeQuery();
			aList = new ArrayList<Agency>();
			while (res.next()) {
				Agency agency = new Agency();
				agency.setAgencyId(res.getInt("id"));
				agency.setAgencyName(res.getString("agencyName"));
				aList.add(agency);
			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("agencylist", JSONArray.fromObject(aList));
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
			DBConnection.closeRes(res);
		}
		return null;
	}

	public String getDailyList2(String name, String date) {
		try {
			sql = "select * from daily_report a,user b where b.nickName = ? "
					+ "and CAST(date AS datetime)>=CAST(? AS datetime)"
					+ "and CAST(date AS datetime)<=CAST(? AS datetime) " + "and a.name = b.name "
					+ "order by CAST(date AS datetime)";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, name);
			pre.setString(2, date + "/1");
			pre.setString(3, date + "/" + CommonUtils.getDays(date));
			res = pre.executeQuery();
			list = new ArrayList<DailyReport>();
			while (res.next()) {
				DailyReport dr = new DailyReport();
				dr.setDate(res.getString("date"));
				dr.setName(res.getString("name"));
				dr.setSchedule(res.getString("schedule"));
				dr.setScheduleState(res.getString("scheduleState"));
				dr.setDailyReport(res.getString("dailyReport"));
				dr.setWeekReport(res.getString("weekReport"));
				dr.setNextWeekPlan(res.getString("nextWeekPlan"));
				dr.setCrmUpload(res.getString("crmUpload"));
				dr.setProjectReport(res.getString("projectReport"));
				dr.setOthers(res.getString("others"));
				dr.setSign(res.getString("sign"));
				dr.setRemark(res.getString("remark"));
				list.add(dr);
			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("dailylist", JSONArray.fromObject(list));
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
			DBConnection.closeRes(res);
		}
		return null;
	}

	// 根据在职状态获得用户列表
	public List<User> getUserList2(String date, int dept) {
		try {
			sql = "select * from user where isDeleted = 0";
			if (dept == 99) {// 除领导以外
				sql += " and departmentId != 5 and departmentId != 6";
			} else if (dept == 100) {// 技术和销售
				sql += " and departmentId = 1 or departmentId = 2";
			} else if (dept != 0) {
				sql += " and departmentId = " + dept;
			}
			sql += " order by departmentId,id";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			res = pre.executeQuery();
			uList = new ArrayList<User>();
			while (res.next()) {
				User user = new User();
				user.setUId(res.getInt("id"));
				user.setName(res.getString("name"));
				user.setNickName(res.getString("nickName"));
				user.setDepartmentId(res.getInt("departmentId"));
				user.setJobId(res.getString("jobId"));
				user.setState(res.getString("state"));
				user.setRoleId(res.getInt("roleId"));
				String userState = res.getString("state");
				DateFormat df = new SimpleDateFormat("yyyy/MM/dd");
				boolean IsDimission = userState.contains("离职");
				if (IsDimission) {
					String dimDate = userState.split("-")[1] + "/1";
					Date dt1 = df.parse(date + "/1");// 查看日期
					Date dt2 = df.parse(dimDate);// 离职日期
					if (dt1.getTime() < dt2.getTime()) {
						uList.add(user);
					}
				} else {
					uList.add(user);
				}
			}
			return uList;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
			DBConnection.closeRes(res);
		}
		return null;
	}

	public String getWechatCheckList(String date, int dept) {
		try {
			sql2 = "select b.NICKNAME,CASE a.checkflg WHEN 'In' THEN '签到' ELSE '签退' END checkflgRes,a.address,a.checktime from dbo.WX_TimeRec a,dbo.User_WebUser b "
					+ "where CAST(a.checktime AS date) = CAST(? AS date) and a.userName=b.USERNAME order by a.checktime";

			con2 = DBConnection.getConnection2();
			pre2 = con2.prepareStatement(sql2);
			pre2.setString(1, date);
			res2 = pre2.executeQuery();
			wList = new ArrayList<WechatCheck>();
			uList = new ArrayList<User>();
			uList = getUserList2(date, dept);

			while (res2.next()) {
				WechatCheck wc = new WechatCheck();
				wc.setUserName(res2.getString("NICKNAME").trim());
				wc.setCheckFlag(res2.getString("checkflgRes"));
				wc.setAddress(res2.getString("address"));
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
				String dateStr = sdf.format(res2.getTimestamp("checktime"));
				wc.setDate(dateStr.substring(0, 10));
				wc.setCheckTime(dateStr.substring(11, dateStr.length()));
				for (int i = 0; i < uList.size(); i++) {
					if (wc.getUserName().equals(uList.get(i).getName())) {
						wList.add(wc);
					}
				}
			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("wechatlist", JSONArray.fromObject(wList));
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.closeCon(con2);
			DBConnection.closePre(pre2);
			DBConnection.closeRes(res2);
		}
		return null;
	}

	public String getCardCheckList(String date, int dept) {
		try {
			sql2 = "select a.f_ConsumerName,CASE c.f_ReaderID WHEN 1 THEN '打卡进' ELSE '打卡出' END f_ReaderIDRes,c.f_ReadDate "
					+ "from dbo.t_b_Consumer a,dbo.t_b_IDCard b,dbo.t_d_CardRecord c "
					+ "where a.f_ConsumerID=b.f_ConsumerID and b.f_CardNO = c.f_CardNO "
					+ "and cast(? as date)=cast(c.f_ReadDate as date) ORDER BY c.f_ReadDate";
			con2 = DBConnection.getConnection3();
			pre2 = con2.prepareStatement(sql2);
			pre2.setString(1, date);
			res2 = pre2.executeQuery();
			wList = new ArrayList<WechatCheck>();
			uList = new ArrayList<User>();
			uList = getUserList2(date, dept);

			while (res2.next()) {
				String mName = res2.getString("f_ConsumerName");
				if (!mName.equals("阿姨") && !mName.equals("吕总")) {
					WechatCheck wc = new WechatCheck();
					wc.setUserName(mName);
					wc.setCheckFlag(res2.getString("f_ReaderIDRes"));
					wc.setAddress("公司");
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
					String dateStr = sdf.format(res2.getTimestamp("f_ReadDate"));
					wc.setDate(dateStr.substring(0, 10));
					wc.setCheckTime(dateStr.substring(11, dateStr.length()));
					for (int i = 0; i < uList.size(); i++) {
						if (wc.getUserName().equals(uList.get(i).getName())) {
							wList.add(wc);
						}
					}
				}
			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("cardlist", JSONArray.fromObject(wList));
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.closeCon(con2);
			DBConnection.closePre(pre2);
			DBConnection.closeRes(res2);
		}
		return null;
	}

	public String getWechatUserList(String date) {
		try {

			String innerSql = "select * from dbo.WX_TimeRec b "
					+ "WHERE CAST(b.checktime AS datetime) > CAST(? AS datetime) "
					+ "and CAST(b.checktime AS datetime) < CAST(? AS datetime) " + "and b.checkflg='Out' ";
			sql2 = "select * from dbo.WX_TimeRec a " + "where CAST(a.checktime AS date) = CAST(? AS date) " + "union "
					+ innerSql + "order by a.checktime";

			con2 = DBConnection.getConnection2();
			pre2 = con2.prepareStatement(sql2);
			pre2.setString(1, date);

			SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
			SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
			Date thisDay = sdf.parse(date);
			Calendar c = Calendar.getInstance();
			c.setTime(thisDay);
			c.add(Calendar.DAY_OF_MONTH, 1);// +1天
			String nextDate = sdf.format(c.getTime());
			pre2.setString(2, nextDate + " 00:00:00");
			pre2.setString(3, nextDate + " 10:00:00");// 第二天10点前

			res2 = pre2.executeQuery();
			wList = new ArrayList<WechatCheck>();

			while (res2.next()) {
				WechatCheck wc = new WechatCheck();
				String dateStr = sdf2.format(res2.getTimestamp("checktime"));
				wc.setDate(dateStr.substring(0, 10));
				wc.setUserName(res2.getString("userName"));
				wc.setCheckFlag(res2.getString("checkflg"));
				wc.setAddress(res2.getString("address"));
				wc.setCheckTime(dateStr.substring(11, dateStr.length()));
				wList.add(wc);
			}
			uList = new ArrayList<User>();
			uList = getUserList2(date, 0);

			dwList = new ArrayList<DailyWechatCheck>();

			List<WechatCheck> wList2 = null;

			for (int i = 0; i < uList.size(); i++) {
				String nickName = uList.get(i).getNickName();
				String startTime = "", endTime = "", detail = "";
				wList2 = new ArrayList<WechatCheck>();
				for (int j = 0; j < wList.size(); j++) {
					WechatCheck wCheck = new WechatCheck();
					wCheck = wList.get(j);
					if (wCheck.getUserName().equals(nickName)) {
						wList2.add(wCheck);
						// 获取一个人一天所有的记录
					}
				}
				DailyWechatCheck dwc = new DailyWechatCheck();
				dwc.setDate(date);
				dwc.setName(uList.get(i).getName());
				System.out.println("用户    " + uList.get(i).getName());
				// wList2 一个人的所有考勤 休息和打卡没办法判断，所以没记录一律为空
				if (wList2.size() > 0) {

					for (int k = 0; k < wList2.size(); k++) {
						if (wList2.get(k).getCheckFlag().equals("签到") || wList2.get(k).getCheckFlag().equals("打卡进")) {
							startTime = wList2.get(k).getCheckTime();
							break;
						}
					}

					for (int l = wList2.size() - 1; l >= 0; l--) {
						if (wList2.get(l).getCheckFlag().equals("签退") || wList2.get(l).getCheckFlag().equals("打卡出")) {
							endTime = wList2.get(l).getCheckTime();
							break;
						}
					}
					if (endTime.equals("")) {
						endTime = "no signOut";
					}

					dwc.setStartTime(startTime);
					dwc.setEndTime(endTime);
					dwc.setDetail(JSONArray.fromObject(wList2).toString());
					dwList.add(dwc);
				} else {
					dwc.setStartTime(startTime);
					dwc.setEndTime(endTime);
					dwList.add(dwc);
				}
			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("dailywechatlist", JSONArray.fromObject(dwList));
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.closeCon(con2);
			DBConnection.closePre(pre2);
			DBConnection.closeRes(res2);
		}
		return null;
	}

	public String getAllCheckList(String date, int dept) {
		wList = new ArrayList<WechatCheck>();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
		SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
		try {

			sql = "select b.NICKNAME,CASE a.checkflg WHEN 'In' THEN '签到' ELSE '签退' END checkflgRes,a.address,a.checktime "
					+ "from dbo.WX_TimeRec a ,dbo.User_WebUser b "
					+ "where CAST(a.checktime AS date) = CAST(? AS date) " + "and a.userName=b.USERNAME "
					+ "union select d.NICKNAME,CASE c.checkflg WHEN 'In' THEN '签到' ELSE '签退' END checkflgRes,c.address,c.checktime "
					+ "from dbo.WX_TimeRec c ,dbo.User_WebUser d "
					+ "WHERE CAST(c.checktime AS datetime) > CAST(? AS datetime) "
					+ "and CAST(c.checktime AS datetime) < CAST(? AS datetime) "
					+ "and c.checkflg='Out' and c.userName=d.USERNAME order by a.checktime";

			con = DBConnection.getConnection2();
			pre = con.prepareStatement(sql);
			pre.setString(1, date);
			Date thisDay = sdf.parse(date);
			Calendar c = Calendar.getInstance();
			c.setTime(thisDay);
			c.add(Calendar.DAY_OF_MONTH, 1);// +1天
			String nextDate = sdf.format(c.getTime());
			pre.setString(2, nextDate + " 00:00:00");
			pre.setString(3, nextDate + " 10:00:00");// 第二天10点前
			res = pre.executeQuery();
			while (res.next()) {
				WechatCheck wc = new WechatCheck();
				wc.setUserName(res.getString("NICKNAME").trim());
				wc.setCheckFlag(res.getString("checkflgRes"));
				wc.setAddress(res.getString("address"));
				String dateStr = sdf2.format(res.getTimestamp("checktime"));
				wc.setCheckTime(dateStr.substring(11, dateStr.length()));
				wc.setDate(dateStr.substring(0, 10));
				wList.add(wc);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
			DBConnection.closeRes(res);
		}

		try {
			sql2 = "select a.f_ConsumerName,CASE c.f_ReaderID WHEN 1 THEN '打卡进' ELSE '打卡出' END f_ReaderIDRes,c.f_ReadDate "
					+ "from dbo.t_b_Consumer a,dbo.t_b_IDCard b,dbo.t_d_CardRecord c "
					+ "where a.f_ConsumerID=b.f_ConsumerID and b.f_CardNO = c.f_CardNO "
					+ "and cast(? as date)=cast(c.f_ReadDate as date)";
			con2 = DBConnection.getConnection3();
			pre2 = con2.prepareStatement(sql2);
			pre2.setString(1, date);
			res2 = pre2.executeQuery();
			while (res2.next()) {
				String mName = res2.getString("f_ConsumerName").trim();
				if (!mName.equals("阿姨") && !mName.equals("吕总")) {
					WechatCheck wc2 = new WechatCheck();
					wc2.setUserName(mName);
					wc2.setCheckFlag(res2.getString("f_ReaderIDRes"));
					wc2.setAddress("公司");
					String dateStr = sdf2.format(res2.getTimestamp("f_ReadDate"));
					wc2.setCheckTime(dateStr.substring(11, dateStr.length()));
					wc2.setDate(dateStr.substring(0, 10));
					wList.add(wc2);
				}
			}
			// 按时间排序
			Collections.sort(wList, new Comparator<WechatCheck>() {

				@Override
				public int compare(WechatCheck wc1, WechatCheck wc2) {
					String date = wc1.getDate() + " " + wc1.getCheckTime();
					String date2 = wc2.getDate() + " " + wc2.getCheckTime();
					SimpleDateFormat sdf3 = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
					Date d1, d2;
					int t = 0;
					try {
						d1 = sdf3.parse(date);
						d2 = sdf3.parse(date2);
						if (d1.getTime() > d2.getTime()) {
							t = 1;
						} else {
							t = -1;
						}
					} catch (ParseException e) {
						e.printStackTrace();
					}
					return t;
				}

			});
			/** 这里已获取了所有微信签到和刷门卡的记录 ，并按时间排序 **/
			uList = new ArrayList<User>();
			uList = getUserList2(date, dept);// 除去领导
			dwList = new ArrayList<DailyWechatCheck>();
			List<WechatCheck> wList2 = null;

			for (int i = 0; i < uList.size(); i++) {
				String name = uList.get(i).getName();// 真实姓名
				String startTime = "", endTime = "", detail = "";
				wList2 = new ArrayList<WechatCheck>();

				for (int j = 0; j < wList.size(); j++) {
					if (wList.get(j).getUserName().equals(name)) {
						wList2.add(wList.get(j));
					}
				}
				JSONObject jo = new JSONObject();
				jo.put("list", JSONArray.fromObject(wList2));
				DailyWechatCheck dwc = new DailyWechatCheck();
				dwc.setDate(date);
				dwc.setName(name);
				dwc.setDetail(jo.toString());

				if (wList2.size() > 0) {
					if (wList2.size() == 1) {
						WechatCheck object = wList2.get(0);
						String time = object.getCheckTime();
						int t = Integer.parseInt(time.substring(0, 2));

						if (object.getCheckFlag().equals("签到") || object.getCheckFlag().equals("打卡进")) {
							// 只有签到
							startTime = time;
							endTime = "未签退";
						} else if (t >= 10) {
							// 只有一条超过10点退出的记录
							// 若只有一条10点前的退出记录，则不算上班
							endTime = time;
							startTime = "未签到";
						}
					} else {
						WechatCheck object2 = new WechatCheck();
						WechatCheck object3 = new WechatCheck();
						for (int k = 0; k < wList2.size(); k++) {
							object2 = new WechatCheck();
							object2 = wList2.get(k);
							if (object2.getCheckFlag().equals("签到") || object2.getCheckFlag().equals("打卡进")) {
								startTime = wList2.get(k).getCheckTime();
								break;
							}
						}

						if (startTime.equals("")) {
							startTime = "未签到";
						}

						for (int l = wList2.size() - 1; l >= 0; l--) {
							object3 = new WechatCheck();
							object3 = wList2.get(l);
							if (object3.getCheckFlag().equals("签退") || object3.getCheckFlag().equals("打卡出")) {

								if (!startTime.equals("未签到")) {
									Date tEnd = sdf.parse(object3.getDate());
									Date tStart = sdf.parse(object2.getDate());

									if (tEnd.getTime() > tStart.getTime()) {
										endTime = "次日" + wList2.get(l).getCheckTime();
									} else {
										endTime = wList2.get(l).getCheckTime();
									}
								} else {
									endTime = wList2.get(l).getCheckTime();
								}
								break;
							}
						}

						if (endTime.equals("")) {
							endTime = "未签退";
						}

					}
				}
				dwc.setStartTime(startTime);
				dwc.setEndTime(endTime);
				dwList.add(dwc);
			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("wechatlist", JSONArray.fromObject(dwList));
			// System.out.println(JSONArray.fromObject(dwList));
			return jsonObject.toString();

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.closeCon(con2);
			DBConnection.closePre(pre2);
			DBConnection.closeRes(res2);
		}
		return null;
	}
	////////////////////////////////////////////

	public String getCheckList(String date) {
		wList = new ArrayList<WechatCheck>();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
		SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
		try {

			sql = "select b.NICKNAME,CASE a.checkflg WHEN 'In' THEN '签到' ELSE '签退' END checkflgRes,a.address,a.checktime "
					+ "from dbo.WX_TimeRec a ,dbo.User_WebUser b "
					+ "where CAST(a.checktime AS date) = CAST(? AS date) " + "and a.userName=b.USERNAME "
					+ "union select d.NICKNAME,CASE c.checkflg WHEN 'In' THEN '签到' ELSE '签退' END checkflgRes,c.address,c.checktime "
					+ "from dbo.WX_TimeRec c ,dbo.User_WebUser d "
					+ "WHERE CAST(c.checktime AS datetime) > CAST(? AS datetime) "
					+ "and CAST(c.checktime AS datetime) < CAST(? AS datetime) "
					+ "and c.checkflg='Out' and c.userName=d.USERNAME order by a.checktime";

			con = DBConnection.getConnection2();
			pre = con.prepareStatement(sql);
			pre.setString(1, date);
			Date thisDay = sdf.parse(date);
			Calendar c = Calendar.getInstance();
			c.setTime(thisDay);
			c.add(Calendar.DAY_OF_MONTH, 1);// +1天
			String nextDate = sdf.format(c.getTime());
			pre.setString(2, nextDate + " 00:00:00");
			pre.setString(3, nextDate + " 10:00:00");// 第二天10点前
			res = pre.executeQuery();
			while (res.next()) {
				WechatCheck wc = new WechatCheck();
				wc.setUserName(res.getString("NICKNAME").trim());
				wc.setCheckFlag(res.getString("checkflgRes"));
				wc.setAddress(res.getString("address"));
				String dateStr = sdf2.format(res.getTimestamp("checktime"));
				wc.setCheckTime(dateStr.substring(11, dateStr.length()));
				wc.setDate(dateStr.substring(0, 10));
				wList.add(wc);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
			DBConnection.closeRes(res);
		}

		try {
			sql2 = "select a.f_ConsumerName,CASE c.f_ReaderID WHEN 1 THEN '打卡进' ELSE '打卡出' END f_ReaderIDRes,c.f_ReadDate "
					+ "from dbo.t_b_Consumer a,dbo.t_b_IDCard b,dbo.t_d_CardRecord c "
					+ "where a.f_ConsumerID=b.f_ConsumerID and b.f_CardNO = c.f_CardNO "
					+ "and cast(? as date)=cast(c.f_ReadDate as date)";
			con2 = DBConnection.getConnection3();
			pre2 = con2.prepareStatement(sql2);
			pre2.setString(1, date);
			res2 = pre2.executeQuery();
			while (res2.next()) {
				String mName = res2.getString("f_ConsumerName").trim();
				if (!mName.equals("阿姨") && !mName.equals("吕总")) {
					WechatCheck wc2 = new WechatCheck();
					wc2.setUserName(mName);
					wc2.setCheckFlag(res2.getString("f_ReaderIDRes"));
					wc2.setAddress("公司");
					String dateStr = sdf2.format(res2.getTimestamp("f_ReadDate"));
					wc2.setCheckTime(dateStr.substring(11, dateStr.length()));
					wc2.setDate(dateStr.substring(0, 10));
					wList.add(wc2);
				}
			}

			Collections.sort(wList, new Comparator<WechatCheck>() {

				@Override
				public int compare(WechatCheck wc1, WechatCheck wc2) {
					String date = wc1.getDate() + " " + wc1.getCheckTime();
					String date2 = wc2.getDate() + " " + wc2.getCheckTime();
					SimpleDateFormat sdf3 = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
					Date d1, d2;
					int t = 0;
					try {
						d1 = sdf3.parse(date);
						d2 = sdf3.parse(date2);
						if (d1.getTime() > d2.getTime()) {
							t = 1;
						} else {
							t = -1;
						}
					} catch (ParseException e) {
						e.printStackTrace();
					}
					return t;
				}

			});
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("checklist", JSONArray.fromObject(wList));
			// System.out.println(JSONArray.fromObject(wList));
			return jsonObject.toString();

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.closeCon(con2);
			DBConnection.closePre(pre2);
			DBConnection.closeRes(res2);
		}
		return null;

	}

	public boolean saveCheck(WechatCheck obj) {
		try {
			sql = "insert into checkrecord (date,name,checkTime,checkFlag,address,state) values (?,?,?,?,?,?)";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, obj.getDate());
			pre.setString(2, obj.getUserName());
			pre.setString(3, obj.getCheckTime());
			pre.setString(4, obj.getCheckFlag());
			pre.setString(5, obj.getAddress());
			pre.setInt(6, obj.getState());

			int i = pre.executeUpdate();
			if (i > 0) {
				return true;
			} else {
				return false;
			}
		} catch (Exception e) {

			e.printStackTrace();
			return false;
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
		}
	}

	public String getCheckErrorList(String date) {
		try {
			sql = "select * from checkrecord where cast(date as date) = cast(? as date) and state = ?";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, date);
			pre.setInt(2, 0);
			res = pre.executeQuery();
			wList = new ArrayList<WechatCheck>();
			while (res.next()) {
				WechatCheck wc = new WechatCheck();
				wc.setId(res.getInt("id"));
				wc.setDate(date);
				wc.setUserName(res.getString("name"));
				wc.setCheckTime(res.getString("checkTime"));
				wc.setCheckFlag(res.getString("checkFlag"));
				wc.setAddress(res.getString("address"));
				wc.setState(res.getInt("state"));
				wList.add(wc);
			}
			System.out.println(JSONArray.fromObject(wList));
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("errorlist", JSONArray.fromObject(wList));
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
			DBConnection.closeRes(res);
		}
		return null;
	}

	public String checkUpdate(int state, int checkId) {
		try {
			sql = "update checkrecord set state = ? where id = ?";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setInt(1, state);
			pre.setInt(2, checkId);
			pre.executeUpdate();
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "update");
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "10001");
			jsonObject.put("errmsg", e.getMessage());
			return jsonObject.toString();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
		}
	}

	public WechatCheck getWechatCheck(int checkId) {
		try {
			sql = "select * from checkrecord where id = ?";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setInt(1, checkId);
			res = pre.executeQuery();
			wList = new ArrayList<WechatCheck>();
			if (res.next()) {
				WechatCheck wc = new WechatCheck();
				wc.setId(res.getInt("id"));
				wc.setDate(res.getString("date"));
				wc.setUserName(res.getString("name"));
				wc.setCheckTime(res.getString("checkTime"));
				wc.setCheckFlag(res.getString("checkFlag"));
				wc.setAddress(res.getString("address"));
				wc.setState(res.getInt("state"));
				return wc;
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
			DBConnection.closeRes(res);
		}
		return null;
	}

	public String getStatisticsList(String date, int dept) {
		SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
		try {
			sql = "select * from checkrecord  where CAST(date AS date)>=CAST(? AS date) "
					+ "and CAST(date AS date)<=CAST(? AS date) and state=1";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, date + "/1");
			pre.setString(2, date + "/" + CommonUtils.getDays(date));
			res = pre.executeQuery();
			wList = new ArrayList<WechatCheck>();
			while (res.next()) {

				WechatCheck wCheck = new WechatCheck();
				wCheck.setId(res.getInt("id"));
				wCheck.setDate(res.getString("date"));
				wCheck.setUserName(res.getString("name"));
				wCheck.setCheckTime(res.getString("checkTime"));
				wCheck.setCheckFlag(res.getString("checkFlag"));
				wCheck.setAddress(res.getString("address"));
				wCheck.setState(res.getInt("state"));

				wList.add(wCheck);
			}
			uList = new ArrayList<User>();
			uList = getUserList2(date + "/1", dept);

			csList = new ArrayList<CheckStatistics>();
			for (int i = 0; i < uList.size(); i++) {
				String name = uList.get(i).getName();
				int lateT = 0, beforeT = 0, outT = 0;
				CheckStatistics cs = new CheckStatistics();
				for (int j = 0; j < wList.size(); j++) {
					if (name.equals(wList.get(j).getUserName())) {
						WechatCheck wc = wList.get(j);
						String checkDate = wc.getDate() + " " + wc.getCheckTime();
						Date checkDateTime = sdf2.parse(checkDate);
						Date beginDate = sdf2.parse(wc.getDate() + " 09:00:00");
						Date endDate = sdf2.parse(wc.getDate() + " 17:00:00");

						if (checkDateTime.after(beginDate)
								&& (wc.getCheckFlag().equals("签到") || wc.getCheckFlag().equals("打卡进"))) {
							lateT++;
						}
						if (checkDateTime.before(endDate)
								&& (wc.getCheckFlag().equals("签退") || wc.getCheckFlag().equals("打卡出"))) {
							beforeT++;
						}

					}
				}
				cs.setName(name);
				cs.setBeforeT(beforeT);
				cs.setLateT(lateT);
				cs.setOutT(outT);
				csList.add(cs);
			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("list", JSONArray.fromObject(csList));
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
			DBConnection.closeRes(res);
		}
		return null;
	}

	public String getWeekPlanDetails(String startDate, String endDate) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
		try {
			sql = "select b.NICKNAME,convert(varchar,a.YEARTO,111) date1,(RTRIM(a.HOURFROM)+'-'+a.HOURTO) period,a.TOPIC,"
					+ "case WHEN(cast(SUBSTRING(a.CREATEDAT, 0, 5)+'/'+SUBSTRING(a.CREATEDAT, 5, 2)+'/'+SUBSTRING(a.CREATEDAT, 7, 2) as date)<=cast(? as date)) THEN 0 ELSE 1 END AS islate"
					+ " from Time_Timepiece a , User_WebUser b"
					+ " where a.USERID = b.ID and cast(YEARTO as date)>=cast(? as date)"
					+ " and cast(YEARTO as date)<=cast(? as date)";
			con = DBConnection.getConnection2();
			pre = con.prepareStatement(sql);
			pre.setString(1, startDate);
			pre.setString(2, startDate);
			pre.setString(3, endDate);

			res = pre.executeQuery();
			spList = new ArrayList<ScheduleReport>();
			while (res.next()) {
				ScheduleReport sp = new ScheduleReport();
				sp.setName(res.getString("NICKNAME").trim());
				sp.setDate(res.getString("date1"));
				sp.setTimePeriod(res.getString("period"));
				sp.setTopic(res.getString("TOPIC"));
				sp.setIsLate(res.getInt("islate"));
				spList.add(sp);
			}
			uList = new ArrayList<User>();
			uList = getUserList2(startDate, 12);
			wdList = new ArrayList<WeekDetail>();
			for (int i = 0; i < uList.size(); i++) {
				String name = uList.get(i).getName();
				int departmentId = uList.get(i).getDepartmentId();
				WeekDetail wd = new WeekDetail();
				String MonStr = "";
				String TuesStr = "";
				String WedStr = "";
				String ThurStr = "";
				String FriStr = "";
				String SatStr = "";
				String SunStr = "";

				for (int j = 0; j < spList.size(); j++) {
					if (name.equals(spList.get(j).getName())) {
						Date date = sdf.parse(spList.get(j).getDate());
						Calendar cal = Calendar.getInstance();
						cal.setTime(date);
						if (cal.get(Calendar.DAY_OF_WEEK) - 1 == 0) {
							if (spList.get(j).getIsLate() == 1 && departmentId == 1) {
								SunStr += "<a style='color:blue'>"
										+ (spList.get(j).getTimePeriod() + spList.get(j).getTopic() + "</a><br>");
							} else {
								SunStr += (spList.get(j).getTimePeriod() + spList.get(j).getTopic() + "<br>");
							}
						} else if (cal.get(Calendar.DAY_OF_WEEK) - 1 == 1) {
							if (spList.get(j).getIsLate() == 1 && departmentId == 1 && MonStr.equals("")) {
								MonStr += "<a style='color:red'>"
										+ (spList.get(j).getTimePeriod() + spList.get(j).getTopic() + "</a><br>");
							} else if (spList.get(j).getIsLate() == 1 && departmentId == 1) {
								MonStr += "<a style='color:blue'>"
										+ (spList.get(j).getTimePeriod() + spList.get(j).getTopic() + "</a><br>");
							} else {
								MonStr += (spList.get(j).getTimePeriod() + spList.get(j).getTopic() + "<br>");
							}
						} else if (cal.get(Calendar.DAY_OF_WEEK) - 1 == 2) {
							if (spList.get(j).getIsLate() == 1 && departmentId == 1 && TuesStr.equals("")) {
								TuesStr += "<a style='color:red'>"
										+ (spList.get(j).getTimePeriod() + spList.get(j).getTopic() + "</a><br>");
							} else if (spList.get(j).getIsLate() == 1 && departmentId == 1) {
								TuesStr += "<a style='color:blue'>"
										+ (spList.get(j).getTimePeriod() + spList.get(j).getTopic() + "</a><br>");
							} else {
								TuesStr += (spList.get(j).getTimePeriod() + spList.get(j).getTopic() + "<br>");
							}
						} else if (cal.get(Calendar.DAY_OF_WEEK) - 1 == 3) {
							if (spList.get(j).getIsLate() == 1 && departmentId == 1 && WedStr.equals("")) {
								WedStr += "<a style='color:red'>"
										+ (spList.get(j).getTimePeriod() + spList.get(j).getTopic() + "</a><br>");
							} else if (spList.get(j).getIsLate() == 1 && departmentId == 1) {
								WedStr += "<a style='color:blue'>"
										+ (spList.get(j).getTimePeriod() + spList.get(j).getTopic() + "</a><br>");
							} else {
								WedStr += (spList.get(j).getTimePeriod() + spList.get(j).getTopic() + "<br>");
							}
						} else if (cal.get(Calendar.DAY_OF_WEEK) - 1 == 4) {
							if (spList.get(j).getIsLate() == 1 && departmentId == 1 && ThurStr.equals("")) {
								ThurStr += "<a style='color:red'>"
										+ (spList.get(j).getTimePeriod() + spList.get(j).getTopic() + "</a><br>");
							} else if (spList.get(j).getIsLate() == 1 && departmentId == 1) {
								ThurStr += "<a style='color:blue'>"
										+ (spList.get(j).getTimePeriod() + spList.get(j).getTopic() + "</a><br>");
							} else {
								ThurStr += (spList.get(j).getTimePeriod() + spList.get(j).getTopic() + "<br>");
							}
						} else if (cal.get(Calendar.DAY_OF_WEEK) - 1 == 5) {
							if (spList.get(j).getIsLate() == 1 && departmentId == 1 && FriStr.equals("")) {
								FriStr += "<a style='color:red'>"
										+ (spList.get(j).getTimePeriod() + spList.get(j).getTopic() + "</a><br>");
							} else if (spList.get(j).getIsLate() == 1 && departmentId == 1) {
								FriStr += "<a style='color:blue'>"
										+ (spList.get(j).getTimePeriod() + spList.get(j).getTopic() + "</a><br>");
							} else {
								FriStr += (spList.get(j).getTimePeriod() + spList.get(j).getTopic() + "<br>");
							}
						} else if (cal.get(Calendar.DAY_OF_WEEK) - 1 == 6) {
							if (spList.get(j).getIsLate() == 1 && departmentId == 1) {
								SatStr += "<a style='color:blue'>"
										+ (spList.get(j).getTimePeriod() + spList.get(j).getTopic() + "</a><br>");
							} else {
								SatStr += (spList.get(j).getTimePeriod() + spList.get(j).getTopic() + "<br>");
							}
						}
					}
				}
				wd.setName(name);
				wd.setMonSchedule(MonStr);
				wd.setTuesSchedule(TuesStr);
				wd.setWedSchedule(WedStr);
				wd.setThurSchedule(ThurStr);
				wd.setFriSchedule(FriStr);
				wd.setSatSchedule(SatStr);
				wd.setSunSchedule(SunStr);
				wdList.add(wd);
			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("weekDetailsList", JSONArray.fromObject(wdList));
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
			DBConnection.closeRes(res);
		}
		return null;
	}

	public String getClientCompany() {
		try {
			sql2 = "select * from dbo.Product_Company";
			con2 = DBConnection.getConnection2();
			pre2 = con2.prepareStatement(sql2);
			res2 = pre2.executeQuery();
			cList = new ArrayList<Company>();
			while (res2.next()) {
				Company c = new Company();
				c.setCompanyName(res2.getString("CAPTION").trim());
				c.setCompanyId(res2.getString("UUID"));
				cList.add(c);
			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("companylist", JSONArray.fromObject(cList));
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.closeCon(con2);
			DBConnection.closePre(pre2);
			DBConnection.closeRes(res2);
		}
		return null;
	}

	public String getProjectList(String companyId) {
		try {
			sql2 = "select * from dbo.Product_Project b where b.COMPANY= ?";
			con2 = DBConnection.getConnection2();
			pre2 = con2.prepareStatement(sql2);
			pre2.setString(1, companyId);
			res2 = pre2.executeQuery();
			pList = new ArrayList<Project>();
			while (res2.next()) {
				Project project = new Project();
				project.setProjectId(res2.getString("UUID").trim());
				project.setProjectName(res2.getString("O_OPPRTUNITYNAME").trim());
				pList.add(project);
			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("projectlist", JSONArray.fromObject(pList));
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.closeCon(con2);
			DBConnection.closePre(pre2);
			DBConnection.closeRes(res2);
		}
		return null;
	}

	public String getContactList(String companyId) {
		try {
			sql2 = "select * from dbo.Product_Customer b where b.COMPANY= ?";
			con2 = DBConnection.getConnection2();
			pre2 = con2.prepareStatement(sql2);
			pre2.setString(1, companyId);
			res2 = pre2.executeQuery();
			uList = new ArrayList<User>();
			while (res2.next()) {
				User user = new User();
				user.setName(res2.getString("NAME").trim());
				uList.add(user);
			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("contactlist", JSONArray.fromObject(uList));
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.closeCon(con2);
			DBConnection.closePre(pre2);
			DBConnection.closeRes(res2);
		}
		return null;
	}

	public String createNewAssignment(AssignmentOrder ao) {
		try {
			sql = "insert into assign_order (clientCompany,clientContact,projectName,name,userList,date,"
					+ "startDate,endDate,serviceContent,state,rank,projectId) values (?,?,?,?,?,?,?,?,?,?,?,?)";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, ao.getClientCompany());
			pre.setString(2, ao.getClientContact());
			pre.setString(3, ao.getProjectName());
			pre.setString(4, ao.getName());
			pre.setString(5, ao.getUserList());
			pre.setString(6, ao.getDate());
			pre.setString(7, ao.getStartDate());
			pre.setString(8, ao.getEndDate());
			pre.setString(9, ao.getServiceContent());
			pre.setInt(10, ao.getState());
			pre.setInt(11, ao.getRank());
			pre.setString(12, ao.getProjectId());
			int i = pre.executeUpdate();
			jsonObject = new JSONObject();
			if (i > 0) {
				jsonObject.put("errcode", "0");
			} else {
				jsonObject.put("errcode", "1");
			}
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "2");
			return jsonObject.toString();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
		}
	}

	public String getAssignmentList() {
		try {
			sql = "select * from assign_order where isDelete = 0 order by CAST(date AS datetime) desc";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			res = pre.executeQuery();
			aoList = new ArrayList<AssignmentOrder>();
			while (res.next()) {
				AssignmentOrder aOrder = new AssignmentOrder();
				aOrder.setId(res.getInt("id"));
				aOrder.setProjectId(res.getString("projectId"));
				aOrder.setClientCompany(res.getString("clientCompany"));
				aOrder.setClientContact(res.getString("clientContact"));
				aOrder.setProjectName(res.getString("projectName"));
				aOrder.setName(res.getString("name"));
				aOrder.setServiceContent(res.getString("serviceContent"));
				aOrder.setState(res.getInt("state"));
				aOrder.setDate(res.getString("date"));
				aOrder.setStartDate(res.getString("startDate"));
				aOrder.setEndDate(res.getString("endDate"));
				aOrder.setUserList(res.getString("userList"));
				aOrder.setRank(res.getInt("rank"));
				aoList.add(aOrder);
			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("assignlist", JSONArray.fromObject(aoList));
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
			DBConnection.closeRes(res);
		}
		return null;
	}

	public String getAssignmentList(String saleUser, String techUser, String clientCompany) {
		try {
			sql = "select * from assign_order where isDelete = 0 ";
			if (!saleUser.equals("")) {
				sql += "and name = '" + saleUser + "' ";
			}

			if (!clientCompany.equals("")) {
				sql += "and clientCompany = '" + clientCompany + "' ";
			}
			if (!techUser.equals("")) {
				sql += "and userList like '%" + techUser + "%' ";
			}

			sql += "order by CAST(date AS datetime) desc";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			res = pre.executeQuery();
			aoList = new ArrayList<AssignmentOrder>();
			while (res.next()) {
				AssignmentOrder aOrder = new AssignmentOrder();
				aOrder.setId(res.getInt("id"));
				aOrder.setProjectId(res.getString("projectId"));
				aOrder.setClientCompany(res.getString("clientCompany"));
				aOrder.setClientContact(res.getString("clientContact"));
				aOrder.setProjectName(res.getString("projectName"));
				aOrder.setName(res.getString("name"));
				aOrder.setServiceContent(res.getString("serviceContent"));
				aOrder.setState(res.getInt("state"));
				aOrder.setDate(res.getString("date"));
				aOrder.setStartDate(res.getString("startDate"));
				aOrder.setEndDate(res.getString("endDate"));
				aOrder.setUserList(res.getString("userList"));
				aOrder.setRank(res.getInt("rank"));
				aoList.add(aOrder);
			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("assignlist", JSONArray.fromObject(aoList));
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
			DBConnection.closeRes(res);
		}
		return null;
	}

	public String getAssignment(String sId) {
		try {
			sql = "select * from assign_order where isDelete = 0 and id=?";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setInt(1, Integer.parseInt(sId.trim()));
			res = pre.executeQuery();
			AssignmentOrder aOrder = new AssignmentOrder();
			if (res.next()) {
				aOrder.setId(res.getInt("id"));
				aOrder.setProjectId(res.getString("projectId"));
				aOrder.setClientCompany(res.getString("clientCompany"));
				aOrder.setClientContact(res.getString("clientContact"));
				aOrder.setProjectName(res.getString("projectName"));
				aOrder.setName(res.getString("name"));
				aOrder.setServiceContent(res.getString("serviceContent"));
				aOrder.setState(res.getInt("state"));
				aOrder.setDate(res.getString("date"));
				aOrder.setStartDate(res.getString("startDate"));
				aOrder.setEndDate(res.getString("endDate"));
				aOrder.setUserList(res.getString("userList"));
				aOrder.setRank(res.getInt("rank"));
			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("assign", JSONObject.fromObject(aOrder));
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
			DBConnection.closeRes(res);
		}
		return null;
	}

	public String editAssignment(AssignmentOrder ao) {

		try {
			sql = "update assign_order set clientCompany = ?,clientContact = ?,projectName = ?,"
					+ "name = ?,userList = ?,startDate = ?,endDate = ?,serviceContent = ?,state = ?,"
					+ "rank = ?,actEndDate = ?  where id = ?";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, ao.getClientCompany());
			pre.setString(2, ao.getClientContact());
			pre.setString(3, ao.getProjectName());
			pre.setString(4, ao.getName());
			pre.setString(5, ao.getUserList());
			pre.setString(6, ao.getStartDate());
			pre.setString(7, ao.getEndDate());
			pre.setString(8, ao.getServiceContent());
			pre.setInt(9, ao.getState());
			pre.setInt(10, ao.getRank());

			Calendar calendar = Calendar.getInstance();
			calendar.add(Calendar.DATE, 0);
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd HH:mm");
			String todayString = formatter.format(calendar.getTime());// 今天
			pre.setString(11, todayString);
			pre.setInt(12, ao.getId());
			int i = pre.executeUpdate();
			jsonObject = new JSONObject();
			if (i > 0) {
				jsonObject.put("errcode", "0");
			} else {
				jsonObject.put("errcode", "1");
			}
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "2");
			return jsonObject.toString();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
		}
	}

	public String getMoreAssignmentList(int type) {
		// type 1.未开始2.处理中3.超时未完成4.已完成5.已完成正常6.已完成超时7.重要8.所有9.待销售确认

		try {
			sql = "select * from assign_order where isDelete = 0 ";
			if (type == 1) {
				sql += "and state=1";
			} else if (type == 2) {
				sql += "and state=2";
			} else if (type == 3) {
				sql += "and state=3";
			} else if (type == 4) {
				sql += "and (state=4 or state=5)";
			} else if (type == 5) {
				sql += "and state=4";// 已完成(正常)
			} else if (type == 6) {
				sql += "and state=5";// 已完成(超时)
			} else if (type == 9) {
				sql += "and state=6";// 待销售确认
			} else if (type == 7) {
				sql += "and rank=1";
			} else if (type == 8) {

			}

			sql += " order by CAST(date AS datetime) desc";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			res = pre.executeQuery();
			aoList = new ArrayList<AssignmentOrder>();
			while (res.next()) {
				AssignmentOrder aOrder = new AssignmentOrder();
				aOrder.setId(res.getInt("id"));
				aOrder.setProjectId(res.getString("projectId"));
				aOrder.setClientCompany(res.getString("clientCompany"));
				aOrder.setClientContact(res.getString("clientContact"));
				aOrder.setProjectName(res.getString("projectName"));
				aOrder.setName(res.getString("name"));
				aOrder.setServiceContent(res.getString("serviceContent"));
				aOrder.setState(res.getInt("state"));
				aOrder.setDate(res.getString("date"));
				aOrder.setStartDate(res.getString("startDate"));
				aOrder.setEndDate(res.getString("endDate"));
				aOrder.setUserList(res.getString("userList"));
				aOrder.setRank(res.getInt("rank"));
				aoList.add(aOrder);
			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("assignlist", JSONArray.fromObject(aoList));
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
			DBConnection.closeRes(res);
		}
		return null;
	}

	public String getMoreAssignmentList(int type, String saleUser, String techUser, String clientCompany) {
		// type 1.未开始2.处理中3.超时未完成4.已完成5.已完成正常6.已完成超时7.重要8.所有9.待销售确认

		try {
			sql = "select * from assign_order where isDelete = 0 ";

			if (!saleUser.equals("")) {
				sql += "and name = '" + saleUser + "' ";
			}

			if (!clientCompany.equals("")) {
				sql += "and clientCompany = '" + clientCompany + "' ";
			}
			if (!techUser.equals("")) {
				sql += "and userList like '%" + techUser + "%' ";
			}

			if (type == 1) {
				sql += "and state=1 ";
			} else if (type == 2) {
				sql += "and state=2 ";
			} else if (type == 3) {
				sql += "and state=3 ";
			} else if (type == 4) {
				sql += "and (state=4 or state=5) ";
			} else if (type == 5) {
				sql += "and state=4 ";// 已完成(正常)
			} else if (type == 6) {
				sql += "and state=5 ";// 已完成(超时)
			} else if (type == 9) {
				sql += "and state=6 ";// 待销售确认
			} else if (type == 7) {
				sql += "and rank=1 ";
			} else if (type == 8) {

			}

			sql += "order by CAST(date AS datetime) desc";
            con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			res = pre.executeQuery();
			aoList = new ArrayList<AssignmentOrder>();
			while (res.next()) {
				AssignmentOrder aOrder = new AssignmentOrder();
				aOrder.setId(res.getInt("id"));
				aOrder.setProjectId(res.getString("projectId"));
				aOrder.setClientCompany(res.getString("clientCompany"));
				aOrder.setClientContact(res.getString("clientContact"));
				aOrder.setProjectName(res.getString("projectName"));
				aOrder.setName(res.getString("name"));
				aOrder.setServiceContent(res.getString("serviceContent"));
				aOrder.setState(res.getInt("state"));
				aOrder.setDate(res.getString("date"));
				aOrder.setStartDate(res.getString("startDate"));
				aOrder.setEndDate(res.getString("endDate"));
				aOrder.setUserList(res.getString("userList"));
				aOrder.setRank(res.getInt("rank"));
				aoList.add(aOrder);
			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("assignlist", JSONArray.fromObject(aoList));
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
			DBConnection.closeRes(res);
		}
		return null;
	}

	public String autoUpdateAssignment() {
		Calendar calendar = Calendar.getInstance();
		calendar.add(Calendar.DATE, 0);
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
		String todayString = formatter.format(calendar.getTime());// 今天
		calendar.add(Calendar.DATE, -1);
		String yesterdayString = formatter.format(calendar.getTime());// 昨天

		jsonObject = new JSONObject();
		try {
			sql = "update assign_order set state = 2 where isDelete = 0 and state = 1 "
					+ "and cast(startDate as date) = cast(? as date)";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, todayString);
			int i = pre.executeUpdate();
			if (i > 0) {
				jsonObject.put("errcodeStartJob", "0");
			} else {
				jsonObject.put("errcodeStartJob", "1");
			}
		} catch (Exception e) {
			e.printStackTrace();
			jsonObject = new JSONObject();
			jsonObject.put("errcodeStartJob", "2");
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
		}

		try {
			sql2 = "update assign_order set state = 3 where isDelete = 0 and state = 2 "
					+ "and cast(endDate as date) = cast(? as date)";
			con2 = DBConnection.getConnection_Mysql();
			pre2 = con2.prepareStatement(sql2);
			pre2.setString(1, yesterdayString);
			int j = pre2.executeUpdate();
			if (j > 0) {
				jsonObject.put("errcodeEndJob", "0");
			} else {
				jsonObject.put("errcodeEndJob", "1");
			}
		} catch (Exception e) {
			e.printStackTrace();
			jsonObject = new JSONObject();
			jsonObject.put("errcodeEndJob", "2");
		} finally {
			DBConnection.closeCon(con2);
			DBConnection.closePre(pre2);
		}
		return jsonObject.toString();
	}

	public String getStartJobAssignmentList() {
		Calendar calendar = Calendar.getInstance();
		calendar.add(Calendar.DATE, 0);
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
		String todayString = formatter.format(calendar.getTime());// 今天
		try {
			sql = "select * from assign_order where isDelete = 0 and state = 2 "
					+ "and cast(startDate as date) = cast(? as date) order by CAST(date AS datetime) desc";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, todayString);
			res = pre.executeQuery();
			aoList = new ArrayList<AssignmentOrder>();
			while (res.next()) {
				AssignmentOrder aOrder = new AssignmentOrder();
				aOrder.setId(res.getInt("id"));
				aOrder.setProjectId(res.getString("projectId"));
				aOrder.setClientCompany(res.getString("clientCompany"));
				aOrder.setClientContact(res.getString("clientContact"));
				aOrder.setProjectName(res.getString("projectName"));
				aOrder.setName(res.getString("name"));
				aOrder.setServiceContent(res.getString("serviceContent"));
				aOrder.setState(res.getInt("state"));
				aOrder.setDate(res.getString("date"));
				aOrder.setStartDate(res.getString("startDate"));
				aOrder.setEndDate(res.getString("endDate"));
				aOrder.setUserList(res.getString("userList"));
				aOrder.setRank(res.getInt("rank"));
				aoList.add(aOrder);
			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("assignlist", JSONArray.fromObject(aoList));
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
			DBConnection.closeRes(res);
		}
		return null;
	}

	public String getOverTimeAssignmentList() {
		try {
			sql = "select * from assign_order where isDelete = 0 and state = 3 order by CAST(date AS datetime) desc";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			res = pre.executeQuery();
			aoList = new ArrayList<AssignmentOrder>();
			while (res.next()) {
				AssignmentOrder aOrder = new AssignmentOrder();
				aOrder.setId(res.getInt("id"));
				aOrder.setProjectId(res.getString("projectId"));
				aOrder.setClientCompany(res.getString("clientCompany"));
				aOrder.setClientContact(res.getString("clientContact"));
				aOrder.setProjectName(res.getString("projectName"));
				aOrder.setName(res.getString("name"));
				aOrder.setServiceContent(res.getString("serviceContent"));
				aOrder.setState(res.getInt("state"));
				aOrder.setDate(res.getString("date"));
				aOrder.setStartDate(res.getString("startDate"));
				aOrder.setEndDate(res.getString("endDate"));
				aOrder.setUserList(res.getString("userList"));
				aOrder.setRank(res.getInt("rank"));
				aoList.add(aOrder);
			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("assignlist", JSONArray.fromObject(aoList));
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
			DBConnection.closeRes(res);
		}
		return null;
	}

	public String getDeadLineAssignmentList() {
		Calendar calendar = Calendar.getInstance();
		calendar.add(Calendar.DATE, 0);
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
		String todayString = formatter.format(calendar.getTime());// 今天
		try {
			sql = "select * from assign_order where isDelete = 0 and state = 2 "
					+ "and cast(endDate as date) = cast(? as date) order by CAST(date AS datetime) desc";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, todayString);
			res = pre.executeQuery();
			aoList = new ArrayList<AssignmentOrder>();
			while (res.next()) {
				AssignmentOrder aOrder = new AssignmentOrder();
				aOrder.setId(res.getInt("id"));
				aOrder.setProjectId(res.getString("projectId"));
				aOrder.setClientCompany(res.getString("clientCompany"));
				aOrder.setClientContact(res.getString("clientContact"));
				aOrder.setProjectName(res.getString("projectName"));
				aOrder.setName(res.getString("name"));
				aOrder.setServiceContent(res.getString("serviceContent"));
				aOrder.setState(res.getInt("state"));
				aOrder.setDate(res.getString("date"));
				aOrder.setStartDate(res.getString("startDate"));
				aOrder.setEndDate(res.getString("endDate"));
				aOrder.setUserList(res.getString("userList"));
				aOrder.setRank(res.getInt("rank"));
				aoList.add(aOrder);
			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("assignlist", JSONArray.fromObject(aoList));
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
			DBConnection.closeRes(res);
		}
		return null;
	}

	public List<User> getUserList(String[] userName) {
		try {
			sql = "select * from user where state= ? and name = ?";
			con = DBConnection.getConnection_Mysql();
			for (int i = 1; i < userName.length; i++) {
				sql += " or name = ?";
			}
			pre = con.prepareStatement(sql);
			pre.setString(1, "在职");
			pre.setString(2, userName[0]);
			for (int j = 1; j < userName.length; j++) {
				pre.setString(j + 2, userName[j]);
			}
			res = pre.executeQuery();
			uList = new ArrayList<User>();
			while (res.next()) {
				User user = new User();
				user.setName(res.getString("name"));
				user.setNickName(res.getString("nickName"));
				user.setEmail(res.getString("email"));
				uList.add(user);
			}
			return uList;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
			DBConnection.closeRes(res);
		}
		return null;
	}

	public String getDataSourceAssignmentList() {
		try {
			sql = "select b.NICKNAME,c.CAPTION,d.NAME,e.O_OPPRTUNITYNAME,a.ServiceContent,a.ProjectID"
					+ ",Convert(varchar,a.CreateDate,120) createDate,Convert(varchar,a.RequestDate,111) startDate"
					+ ",Convert(varchar,DATEADD(day,30,a.RequestDate),111) endDate"
					+ " from Tac_AssignEngineer a,User_WebUser b,Product_Company c,Product_Customer d,Product_Project e"
					+ " where a.SalerID=b.ID and a.CompanyID = c.UUID and a.ContactID=d.ID and a.ProjectID=e.UUID"
					+ " order by CAST(a.CreateDate AS datetime) desc;";
			con = DBConnection.getConnection2();
			pre = con.prepareStatement(sql);
			res = pre.executeQuery();
			aoList = new ArrayList<AssignmentOrder>();
			while (res.next()) {
				AssignmentOrder aOrder = new AssignmentOrder();
				aOrder.setName(res.getString("NICKNAME"));
				aOrder.setClientCompany(res.getString("CAPTION").trim());
				aOrder.setClientContact(res.getString("NAME"));
				aOrder.setProjectName(res.getString("O_OPPRTUNITYNAME").trim());
				aOrder.setServiceContent(res.getString("ServiceContent").trim());
				aOrder.setState(4);
				aOrder.setDate(res.getString("createDate"));
				aOrder.setStartDate(res.getString("startDate"));
				aOrder.setEndDate(res.getString("endDate"));
				aOrder.setUserList(getDataSourceFollowList(res.getString("ProjectID").trim()));
				aOrder.setRank(0);
				aOrder.setProjectId(res.getString("ProjectID").trim());
				createNewAssignment(aOrder);
				aoList.add(aOrder);
			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("assignlist", JSONArray.fromObject(aoList));
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
			DBConnection.closeRes(res);
		}
		return null;
	}

	public String getDataSourceFollowList(String projectId) {
		try {
			sql2 = "select NICKNAME from Crm_FollowUser a,User_WebUser b"
					+ " where a.PROJECT = ? and a.FOLLOWEDUSER=b.ID"
					+ " UNION select NICKNAME from Tac_FollowUser c,User_WebUser d"
					+ " where c.PROJECTID = ? and c.USERID=d.ID";
			con2 = DBConnection.getConnection2();
			pre2 = con2.prepareStatement(sql2);
			pre2.setString(1, projectId);
			pre2.setString(2, projectId);
			res2 = pre2.executeQuery();
			String userList = "";
			while (res2.next()) {
				userList += res2.getString("NICKNAME").trim() + ",";
			}
			if (!userList.equals("")) {
				return userList.substring(0, userList.length() - 1).trim();
			} else {
				return userList;
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.closeCon(con2);
			DBConnection.closePre(pre2);
			DBConnection.closeRes(res2);
		}
		return null;
	}

	public String getOverDateAssignment() {
		Calendar calendar = Calendar.getInstance();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
		calendar.add(Calendar.DATE, -1);
		String yesterdayString = formatter.format(calendar.getTime());// 昨天

		jsonObject = new JSONObject();

		try {
			sql = "select * from assign_order where isDelete = 0 and state = 3 "
					+ "and cast(endDate as date) = cast(? as date)";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, yesterdayString);
			int i = pre.executeUpdate();
			if (i > 0) {
				jsonObject.put("errcodeEndJob", "0");
			} else {
				jsonObject.put("errcodeEndJob", "1");
			}
		} catch (Exception e) {
			e.printStackTrace();
			jsonObject = new JSONObject();
			jsonObject.put("errcodeEndJob", "2");
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
		}
		return jsonObject.toString();
	}

	public String createDailyUploadReport(DailyUploadReport dur) {
		jsonObject = new JSONObject();
		try {
			sql2 = "select * from dailyuploadreport where userName = ? and date = ? and time = ?";
			con2 = DBConnection.getConnection_Mysql();
			pre2 = con2.prepareStatement(sql2);
			pre2.setString(1, dur.getUserName());
			pre2.setString(2, dur.getDate());
			pre2.setString(3, dur.getTime());
			res2 = pre2.executeQuery();
			if (res2.next()) {
				jsonObject.put("errcode", "3");
				jsonObject.put("message", "请勿重复上传相同时间段的日报");
				return jsonObject.toString();
			}
		} catch (Exception e) {
			e.printStackTrace();
			jsonObject.put("errcode", "2");
			jsonObject.put("message", "mysql 访问出错");
			return jsonObject.toString();
		} finally {
			DBConnection.closeCon(con2);
			DBConnection.closePre(pre2);
			DBConnection.closeRes(res2);
		}

		try {
			sql = "insert into dailyuploadreport (userName,date,client,crmNum,"
					+ "jobContent,time) values (?,?,?,?,?,?)";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, dur.getUserName());
			pre.setString(2, dur.getDate());
			pre.setString(3, dur.getClient());
			pre.setString(4, dur.getCrmNum());
			pre.setString(5, dur.getJobContent());
			pre.setString(6, dur.getTime());
			int j = pre.executeUpdate();
			if (j > 0) {
				jsonObject.put("errcode", "0");
			} else {
				jsonObject.put("errcode", "1");
				jsonObject.put("message", "执行sql 语句错误");
			}
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "2");
			jsonObject.put("message", "mysql 访问出错");
			return jsonObject.toString();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
		}
	}

	public String getDailyUploadReportList(String nickName) {
		try {
			sql = "select a.id,a.userName,a.date,a.jobType,a.crmNum,a.client,a.clientUser,a.jobContent"
					+ ",a.laterSupport,a.remark,a.time"
					+ " from dailyuploadreport a,`user` b where a.userName = b.`name` and b.nickName = ? ORDER BY cast(date as DATE),id";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			if (nickName.equals("leigh.zhang")) {
				nickName = "Leigh.zhang";
			}
			pre.setString(1, nickName);
			res = pre.executeQuery();
			durList = new ArrayList<DailyUploadReport>();
			while (res.next()) {
				DailyUploadReport dur = new DailyUploadReport();
				dur.setId(res.getInt("id"));
				dur.setUserName(res.getString("userName"));
				dur.setDate(res.getString("date"));
				dur.setJobType(res.getString("jobType"));
				dur.setCrmNum(res.getString("crmNum"));
				dur.setClient(res.getString("client"));
				dur.setClientUser(res.getString("clientUser"));
				dur.setJobContent(res.getString("jobContent"));
				dur.setLaterSupport(res.getString("laterSupport"));
				dur.setRemark(res.getString("remark"));
				dur.setTime(res.getString("time"));
				durList.add(dur);
			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("dailyuploadreportlist", JSONArray.fromObject(durList));
			return jsonObject.toString();

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
			DBConnection.closeRes(res);
		}
		return null;
	}

	public String getDailyUploadReport(int id) {
		try {
			sql = "select * from dailyuploadreport where id = ?";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setInt(1, id);
			res = pre.executeQuery();
			if (res.next()) {
				DailyUploadReport dur = new DailyUploadReport();
				dur.setId(res.getInt("id"));
				dur.setUserName(res.getString("userName"));
				dur.setDate(res.getString("date"));
				dur.setCrmNum(res.getString("crmNum"));
				dur.setClient(res.getString("client"));
				dur.setJobContent(res.getString("jobContent"));
				dur.setTime(res.getString("time"));
				jsonObject = new JSONObject();
				jsonObject.put("errcode", "0");
				jsonObject.put("errmsg", "query");
				jsonObject.put("dailyUploadReport", JSONArray.fromObject(dur));
				return jsonObject.toString();
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
			DBConnection.closeRes(res);
		}
		return null;
	}

	public String editDailyUploadReport(DailyUploadReport dur) {

		jsonObject = new JSONObject();

		try {
			sql2 = "select * from dailyuploadreport where userName = ? and date = ? and time = ? and id != ?";
			con2 = DBConnection.getConnection_Mysql();
			pre2 = con2.prepareStatement(sql2);
			pre2.setString(1, dur.getUserName());
			pre2.setString(2, dur.getDate());
			pre2.setString(3, dur.getTime());
			pre2.setInt(4, dur.getId());
			res2 = pre2.executeQuery();
			if (res2.next()) {
				jsonObject.put("errcode", "3");
				return jsonObject.toString();
			}
		} catch (Exception e) {
			e.printStackTrace();
			jsonObject.put("errcode", "2");
			return jsonObject.toString();
		} finally {
			DBConnection.closeCon(con2);
			DBConnection.closePre(pre2);
			DBConnection.closeRes(res2);
		}

		try {
			sql = "update dailyuploadreport set jobType = ?,crmNum = ?,client = ?,"
					+ "clientUser = ?,jobContent = ?,laterSupport = ?,remark = ?,time=? "
					+ "where userName = ? and date = ? and id = ?";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, dur.getJobType());
			pre.setString(2, dur.getCrmNum());
			pre.setString(3, dur.getClient());
			pre.setString(4, dur.getClientUser());
			pre.setString(5, dur.getJobContent());
			pre.setString(6, dur.getLaterSupport());
			pre.setString(7, dur.getRemark());
			pre.setString(8, dur.getTime());

			pre.setString(9, dur.getUserName());
			pre.setString(10, dur.getDate());
			pre.setInt(11, dur.getId());
			int i = pre.executeUpdate();
			jsonObject = new JSONObject();
			if (i > 0) {
				jsonObject.put("errcode", "0");
			} else {
				jsonObject.put("errcode", "1");
			}
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "2");
			return jsonObject.toString();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
		}
	}

	public String createDailyUploadReport(DailyArrangement da) {
		jsonObject = new JSONObject();

		try {
			sql2 = "select * from dailyarrangement where userName = ? and time = ?";
			con2 = DBConnection.getConnection_Mysql();
			pre2 = con2.prepareStatement(sql2);
			pre2.setString(1, da.getUserName());
			pre2.setString(2, da.getTime());
			res2 = pre2.executeQuery();
			if (res2.next()) {
				jsonObject.put("errcode", "3");
				return jsonObject.toString();
			}
		} catch (Exception e) {
			e.printStackTrace();
			jsonObject.put("errcode", "2");
			return jsonObject.toString();
		} finally {
			DBConnection.closeCon(con2);
			DBConnection.closePre(pre2);
			DBConnection.closeRes(res2);
		}

		try {
			sql = "insert into dailyarrangement (userName,time,accident,client,address) values (?,?,?,?,?)";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, da.getUserName());
			pre.setString(2, da.getTime());
			pre.setString(3, da.getAccident());
			pre.setString(4, da.getClient());
			pre.setString(5, da.getAddress());
			int j = pre.executeUpdate();
			if (j > 0) {
				jsonObject.put("errcode", "0");
			} else {
				jsonObject.put("errcode", "1");
			}
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
			jsonObject.put("errcode", "2");
			return jsonObject.toString();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
		}
	}

	public String getAllDailyUploadReportList(String date) {
		try {
			sql = "select a.id,a.userName,a.date,a.time,a.client,a.crmNum,a.jobContent"
					+ " from dailyuploadreport a,`user` b"
					+ " where a.userName = b.nickName and a.date = ? ORDER BY b.departmentId,b.id,a.id";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, date);
			res = pre.executeQuery();
			durList = new ArrayList<DailyUploadReport>();
			while (res.next()) {
				DailyUploadReport dur = new DailyUploadReport();
				dur.setId(res.getInt("id"));
				dur.setUserName(res.getString("userName"));
				dur.setTime(res.getString("time"));
				dur.setDate(res.getString("date"));
				dur.setClient(res.getString("client"));
				dur.setCrmNum(res.getString("crmNum"));
				dur.setJobContent(res.getString("jobContent"));
				if (!dur.getUserName().equals("杨惠芳")) {
					durList.add(dur);
				}
			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("dailyuploadreportlist", JSONArray.fromObject(durList));
			return jsonObject.toString();

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
			DBConnection.closeRes(res);
		}
		return null;
	}

	public String getArrangement(int id) {
		try {
			sql = "select * from dailyarrangement where id = ?";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setInt(1, id);
			res = pre.executeQuery();
			if (res.next()) {
				DailyArrangement da = new DailyArrangement();
				da.setId(res.getInt("id"));
				da.setUserName(res.getString("userName"));
				da.setTime(res.getString("time"));
				da.setAccident(res.getString("accident"));
				da.setAddress(res.getString("address"));
				da.setClient(res.getString("client"));
				jsonObject = new JSONObject();
				jsonObject.put("errcode", "0");
				jsonObject.put("errmsg", "query");
				jsonObject.put("dailyarrangement", JSONArray.fromObject(da));
				return jsonObject.toString();
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
			DBConnection.closeRes(res);
		}
		return null;
	}

	public String editArrangement(DailyArrangement da) {
		jsonObject = new JSONObject();
		try {
			sql2 = "select * from dailyarrangement where userName = ? and time = ? and id != ?";
			con2 = DBConnection.getConnection_Mysql();
			pre2 = con2.prepareStatement(sql2);
			pre2.setString(1, da.getUserName());
			pre2.setString(2, da.getTime());
			pre2.setInt(3, da.getId());
			res2 = pre2.executeQuery();
			if (res2.next()) {
				jsonObject.put("errcode", "3");
				return jsonObject.toString();
			}
		} catch (Exception e) {
			e.printStackTrace();
			jsonObject.put("errcode", "2");
			return jsonObject.toString();
		} finally {
			DBConnection.closeCon(con2);
			DBConnection.closePre(pre2);
			DBConnection.closeRes(res2);
		}

		try {
			sql = "update dailyarrangement set time = ?,accident = ?,client = ?,"
					+ "address = ? where userName = ? and id = ?";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, da.getTime());
			pre.setString(2, da.getAccident());
			pre.setString(3, da.getClient());
			pre.setString(4, da.getAddress());
			pre.setString(5, da.getUserName());
			pre.setInt(6, da.getId());
			int i = pre.executeUpdate();
			jsonObject = new JSONObject();
			if (i > 0) {
				jsonObject.put("errcode", "0");
			} else {
				jsonObject.put("errcode", "1");
			}
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "2");
			return jsonObject.toString();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
		}
	}

	public String getProjectName(String crmNum) {
		jsonObject = new JSONObject();
		try {
			sql2 = "select * from Product_Project where UUID = ?";
			con2 = DBConnection.getConnection2();
			pre2 = con2.prepareStatement(sql2);
			pre2.setString(1, crmNum.trim());
			res2 = pre2.executeQuery();
			if (res2.next()) {
				jsonObject.put("errcode", "0");
				jsonObject.put("projectName", res2.getString("O_OPPRTUNITYNAME"));
				return jsonObject.toString();
			}
		} catch (Exception e) {
			e.printStackTrace();
			jsonObject.put("errcode", "1");
			return jsonObject.toString();
		} finally {
			DBConnection.closeCon(con2);
			DBConnection.closePre(pre2);
			DBConnection.closeRes(res2);
		}
		return "";
	}

	public String getOtherInfo(String userName, String startDate, String endDate, String startDate2, String endDate2) {
		jsonObject = new JSONObject();
		try {
			sql = "select * from dailyuploadreport where userName = ? and"
					+ " CAST(date AS date) >= CAST(? AS date) and CAST(date AS date) <= CAST(? AS date)";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, userName);
			pre.setString(2, startDate);
			pre.setString(3, endDate);
			res = pre.executeQuery();
			durList = new ArrayList<DailyUploadReport>();
			while (res.next()) {
				DailyUploadReport dur = new DailyUploadReport();
				dur.setId(res.getInt("id"));
				dur.setUserName(res.getString("userName"));
				dur.setTime(res.getString("time"));
				dur.setDate(res.getString("date"));
				dur.setJobType(res.getString("jobType"));
				dur.setClient(res.getString("client"));
				dur.setClientUser(res.getString("clientUser"));
				dur.setCrmNum(res.getString("crmNum"));
				dur.setJobContent(res.getString("jobContent"));
				dur.setLaterSupport(res.getString("laterSupport"));
				dur.setRemark(res.getString("remark"));
				durList.add(dur);
			}

			jsonObject.put("errmsg", "query");
			jsonObject.put("dailyuploadreportlist", JSONArray.fromObject(durList));

		} catch (Exception e) {
			e.printStackTrace();
			jsonObject.put("errcode", "1");
			return jsonObject.toString();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
			DBConnection.closeRes(res);
		}

		try {
			sql2 = "select * from weekuploadreport where userName = ? and startDate = ? and endDate = ?";
			con2 = DBConnection.getConnection_Mysql();
			pre2 = con2.prepareStatement(sql2);
			pre2.setString(1, userName);
			pre2.setString(2, startDate2);
			pre2.setString(3, endDate2);
			res2 = pre2.executeQuery();
			if (res2.next()) {
				WeekUploadReport wur = new WeekUploadReport();
				wur.setId(res2.getInt("id"));
				wur.setUserName(res2.getString("userName"));
				wur.setStartDate(res2.getString("startDate"));
				wur.setEndDate(res2.getString("endDate"));
				wur.setWeekReport(res2.getString("weekReport"));

				jsonObject.put("errcode", "0");
				jsonObject.put("weekuploadreport", JSONArray.fromObject(wur));
				return jsonObject.toString();
			} else {
				jsonObject.put("errcode", "2");
				return jsonObject.toString();
			}
		} catch (Exception e) {
			e.printStackTrace();
			jsonObject.put("errcode", "1");
			return jsonObject.toString();
		} finally {
			DBConnection.closeCon(con2);
			DBConnection.closePre(pre2);
			DBConnection.closeRes(res2);
		}

	}

	public String createWeekReport(WeekUploadReport wur) {
		jsonObject = new JSONObject();
		try {
			sql2 = "select * from weekuploadreport where userName = ? and startDate = ? and endDate = ?";
			con2 = DBConnection.getConnection_Mysql();
			pre2 = con2.prepareStatement(sql2);
			pre2.setString(1, wur.getUserName());
			pre2.setString(2, wur.getStartDate());
			pre2.setString(3, wur.getEndDate());
			res2 = pre2.executeQuery();
			if (res2.next()) {
				jsonObject.put("errcode", "3");
				return jsonObject.toString();
			}
		} catch (Exception e) {
			e.printStackTrace();
			jsonObject.put("errcode", "2");
			return jsonObject.toString();
		} finally {
			DBConnection.closeCon(con2);
			DBConnection.closePre(pre2);
			DBConnection.closeRes(res2);
		}

		try {
			sql = "insert into weekuploadreport (userName,startDate,endDate,weekReport) values (?,?,?,?)";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, wur.getUserName());
			pre.setString(2, wur.getStartDate());
			pre.setString(3, wur.getEndDate());
			pre.setString(4, wur.getWeekReport());
			int j = pre.executeUpdate();
			if (j > 0) {
				jsonObject.put("errcode", "0");
			} else {
				jsonObject.put("errcode", "1");
			}
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "2");
			return jsonObject.toString();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
		}
	}

	public String getAllWeekUploadReportList(String startDate, String endDate) {
		try {
			sql = "select a.id,a.userName,a.date,a.time,a.client,a.crmNum,a.jobContent from dailyuploadreport a,`user` b"
					+ " where CAST(date AS date) >= CAST(? AS date) and CAST(date AS date) <= CAST(? AS date) and a.userName = b.nickName ORDER BY b.departmentId,b.id,CAST(date AS date)";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, startDate);
			pre.setString(2, endDate);
			res = pre.executeQuery();
			durList = new ArrayList<DailyUploadReport>();
			while (res.next()) {
				DailyUploadReport dur = new DailyUploadReport();
				dur.setId(res.getInt("id"));
				dur.setUserName(res.getString("userName"));
				dur.setDate(res.getString("date"));
				dur.setTime(res.getString("time"));
				dur.setClient(res.getString("client"));
				dur.setCrmNum(res.getString("crmNum"));
				dur.setJobContent(res.getString("jobContent"));
				durList.add(dur);
			}
			System.out.println(durList.size());
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("weekuploadreportlist", JSONArray.fromObject(durList));
			return jsonObject.toString();

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
			DBConnection.closeRes(res);
		}
		return null;
	}

	public String getUserYearUploadReportList(int year, String userNickName) {
		System.out.println(year + "");
		System.out.println(userNickName);
		try {
			con2 = DBConnection.getConnection_Mysql2();
			con = DBConnection.getConnection_Mysql();
			if (year <= 2020) {
				// 老库
				System.out.println("<= 2020");
				sql2 = "select a.date,a.time,b.companyName,c.projectName,jobContent from dailyuploadreport a ,company b,project c "
						+ "where a.userName = ? and SUBSTR(a.date,1,4) = ? and b.companyId = a.client and c.projectId = a.crmNum order by CAST(a.date AS date),a.id";
				pre2 = con2.prepareStatement(sql2);
				pre2.setString(1, userNickName);
				pre2.setInt(2, year);
				res2 = pre2.executeQuery();
				durList = new ArrayList<DailyUploadReport>();
				while (res2.next()) {
					DailyUploadReport dur = new DailyUploadReport();
					dur.setDate(res2.getString("date"));
					dur.setTime(res2.getString("time"));
					dur.setClient(res2.getString("companyName"));
					dur.setCrmNum(res2.getString("projectName"));
					dur.setJobContent(res2.getString("jobContent"));
					durList.add(dur);
				}
			} else if (year > 2021) {
				System.out.println("> 2021");
				// 新库
				sql = "select a.date,a.time,b.companyName,c.projectName,jobContent from dailyuploadreport a ,company b,project c "
						+ "where a.userName = ? and SUBSTR(a.date,1,4) = ? and b.companyId = a.client and c.projectId = a.crmNum order by CAST(a.date AS date),a.id";
				pre = con.prepareStatement(sql);
				pre.setString(1, userNickName);
				pre.setInt(2, year);
				res = pre.executeQuery();
				durList = new ArrayList<DailyUploadReport>();
				while (res.next()) {
					DailyUploadReport dur = new DailyUploadReport();
					dur.setDate(res.getString("date"));
					dur.setTime(res.getString("time"));
					dur.setClient(res.getString("companyName"));
					dur.setCrmNum(res.getString("projectName"));
					dur.setJobContent(res.getString("jobContent"));
					durList.add(dur);
				}
			} else {
				System.out.println("= 2021");
				// 11月前老库
				sql2 = "select a.date,a.time,b.companyName,c.projectName,jobContent from dailyuploadreport a ,company b,project c "
						+ "where a.userName = ? and CAST(a.date AS date)<=CAST(? AS date) and CAST(a.date AS date)>=CAST(? AS date) "
						+ "and b.companyId = a.client and c.projectId = a.crmNum order by CAST(a.date AS date),a.id";
				pre2 = con2.prepareStatement(sql2);
				pre2.setString(1, userNickName);
				pre2.setString(2, "2021/10/31");
				pre2.setString(3, "2021/01/01");
				res2 = pre2.executeQuery();
				durList = new ArrayList<DailyUploadReport>();
				while (res2.next()) {
					DailyUploadReport dur = new DailyUploadReport();
					dur.setDate(res2.getString("date"));
					dur.setTime(res2.getString("time"));
					dur.setClient(res2.getString("companyName"));
					dur.setCrmNum(res2.getString("projectName"));
					dur.setJobContent(res2.getString("jobContent"));
					durList.add(dur);
				}
				// System.out.println("老库："+durList.size());
				// 11月后新库
				sql = "select a.date,a.time,b.companyName,c.projectName,jobContent from dailyuploadreport a ,company b,project c "
						+ "where a.userName = ? and CAST(a.date AS date)>=CAST(? AS date) "
						+ "and b.companyId = a.client and c.projectId = a.crmNum order by CAST(a.date AS date),a.id";

				pre = con.prepareStatement(sql);
				pre.setString(1, userNickName);
				pre.setString(2, "2021/11/01");
				res = pre.executeQuery();
				while (res.next()) {
					DailyUploadReport dur = new DailyUploadReport();
					dur.setDate(res.getString("date"));
					dur.setTime(res.getString("time"));
					dur.setClient(res.getString("companyName"));
					dur.setCrmNum(res.getString("projectName"));
					dur.setJobContent(res.getString("jobContent"));
					durList.add(dur);
				}
			}

			System.out.println(durList.size());
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("yearuploadreportlist", JSONArray.fromObject(durList));
			return jsonObject.toString();

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(con!=null&&pre!=null&&res!=null) {
				DBConnection.closeCon(con);
				DBConnection.closePre(pre);
				DBConnection.closeRes(res);
			}else if(con2!=null&&pre2!=null&&res2!=null) {
				DBConnection.closeCon(con2);
				DBConnection.closePre(pre2);
				DBConnection.closeRes(res2);
			}
		}
		return null;
	}

	public String getDailyUploadReportList(String userName, String startDate, String endDate) {
		try {
			sql = "select * from dailyuploadreport where userName = ? "
					+ "and CAST(date AS date) >= CAST(? AS date) and CAST(date AS date) <= CAST(? AS date) ORDER BY CAST(date AS date)";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, userName);
			pre.setString(2, startDate);
			pre.setString(3, endDate);
			res = pre.executeQuery();
			durList = new ArrayList<DailyUploadReport>();
			while (res.next()) {
				DailyUploadReport dur = new DailyUploadReport();
				dur.setId(res.getInt("id"));
				dur.setUserName(res.getString("userName"));
				dur.setTime(res.getString("time"));
				dur.setDate(res.getString("date"));
				dur.setJobType(res.getString("jobType"));
				dur.setClient(res.getString("client"));
				dur.setClientUser(res.getString("clientUser"));
				dur.setCrmNum(res.getString("crmNum"));
				dur.setJobContent(res.getString("jobContent"));
				dur.setLaterSupport(res.getString("laterSupport"));
				dur.setRemark(res.getString("remark"));
				durList.add(dur);
			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("dailyuploadreportlist", JSONArray.fromObject(durList));
			return jsonObject.toString();

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
			DBConnection.closeRes(res);
		}
		return null;
	}

	public String getWeekUploadReport(String userName, String startDate, String endDate) {
		jsonObject = new JSONObject();
		try {
			sql = "select * from weekuploadreport where userName = ? and startDate = ? and endDate = ?";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, userName);
			pre.setString(2, startDate);
			pre.setString(3, endDate);
			res = pre.executeQuery();
			if (res.next()) {
				WeekUploadReport wur = new WeekUploadReport();
				wur.setId(res.getInt("id"));
				wur.setUserName(res.getString("userName"));
				wur.setStartDate(res.getString("startDate"));
				wur.setEndDate(res.getString("endDate"));
				wur.setWeekReport(res.getString("weekReport"));
				jsonObject.put("errcode", "0");
				jsonObject.put("weekuploadreport", JSONArray.fromObject(wur));
			} else {
				jsonObject.put("errcode", "1");
			}
			return jsonObject.toString();

		} catch (Exception e) {
			e.printStackTrace();
			jsonObject.put("errcode", "2");
			return jsonObject.toString();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
			DBConnection.closeRes(res);
		}
	}

	public String getWeekUploadReport(int id) {
		jsonObject = new JSONObject();
		try {
			sql = "select * from weekuploadreport where id = ?";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setInt(1, id);
			res = pre.executeQuery();
			if (res.next()) {
				WeekUploadReport wur = new WeekUploadReport();
				wur.setId(res.getInt("id"));
				wur.setUserName(res.getString("userName"));
				wur.setStartDate(res.getString("startDate"));
				wur.setEndDate(res.getString("endDate"));
				wur.setWeekReport(res.getString("weekReport"));
				jsonObject.put("errcode", "0");
				jsonObject.put("weekuploadreport", JSONArray.fromObject(wur));
			} else {
				jsonObject.put("errcode", "1");
			}
			return jsonObject.toString();

		} catch (Exception e) {
			e.printStackTrace();
			jsonObject.put("errcode", "2");
			return jsonObject.toString();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
			DBConnection.closeRes(res);
		}
	}

	public String editWeekUploadReport(WeekUploadReport wur) {
		jsonObject = new JSONObject();
		try {
			sql = "update weekuploadreport set weekReport = ? where id = ?";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, wur.getWeekReport());
			pre.setInt(2, wur.getId());
			int i = pre.executeUpdate();
			jsonObject = new JSONObject();
			if (i > 0) {
				jsonObject.put("errcode", "0");
			} else {
				jsonObject.put("errcode", "1");
			}
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "2");
			return jsonObject.toString();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
		}
	}

	public String getWorkTimeAdjustList(String date, int dept) {
		try {
			sql = "select * from daily_report " + "where CAST(date AS datetime)>=CAST(? AS datetime) "
					+ "and CAST(date AS datetime)<=CAST(? AS datetime)";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, date + "/1");
			pre.setString(2, date + "/" + CommonUtils.getDays(date));
			res = pre.executeQuery();
			list = new ArrayList<DailyReport>();
			while (res.next()) {
				DailyReport dr = new DailyReport();
				dr.setDate(res.getString("date"));
				dr.setName(res.getString("name"));
				dr.setSchedule(res.getString("schedule"));
				dr.setScheduleState(res.getString("scheduleState"));
				dr.setDailyReport(res.getString("dailyReport"));
				dr.setWeekReport(res.getString("weekReport"));
				dr.setNextWeekPlan(res.getString("nextWeekPlan"));
				dr.setCrmUpload(res.getString("crmUpload"));
				dr.setProjectReport(res.getString("projectReport"));
				dr.setOthers(res.getString("others"));
				dr.setSign(res.getString("sign"));
				dr.setRemark(res.getString("remark"));
				dr.setIsLate(res.getInt("islate"));
				dr.setOverWorkTime(res.getDouble("overWorkTime"));
				dr.setAdjustRestTime(res.getDouble("adjustRestTime"));
				dr.setVacationOverWorkTime(res.getDouble("vacationOverWorkTime"));
				dr.setFestivalOverWorkTime(res.getDouble("festivalOverWorkTime"));
				list.add(dr);
			}

			uList = new ArrayList<User>();
			uList = getUserList2(date + "/1", dept);
			wtaList = new ArrayList<WorkTimeAdjust>();
			for (int i = 0; i < uList.size(); i++) {
				String name = uList.get(i).getName();
				double overWorkTimeT = 0, adjustRestTimeT = 0, overWorkTimeT4H = 0;
				double vacationOverWorkTimeT = 0, festivalOverWorkTimeT = 0, accumulateOverWorkTimeT = 0;
				WorkTimeAdjust wta = new WorkTimeAdjust();

				for (int j = 0; j < list.size(); j++) {
					if (name.equals(list.get(j).getName())) {
						DailyReport dReport = list.get(j);

						if (dReport.getOverWorkTime() > 3.9) {
							overWorkTimeT = overWorkTimeT + 4.0;
							overWorkTimeT4H = overWorkTimeT4H + (dReport.getOverWorkTime() - 4.0);
						} else {
							overWorkTimeT = overWorkTimeT + dReport.getOverWorkTime();
						}
						adjustRestTimeT = adjustRestTimeT + dReport.getAdjustRestTime();
						vacationOverWorkTimeT = vacationOverWorkTimeT + dReport.getVacationOverWorkTime();
						festivalOverWorkTimeT = festivalOverWorkTimeT + dReport.getFestivalOverWorkTime();
					}
				}
				wta.setName(name);
				wta.setDate(date);
				wta.setOverWorkTime4H(overWorkTimeT4H);
				wta.setOverWorkTime(overWorkTimeT);
				wta.setRest(adjustRestTimeT);
				wtaList.add(wta);
			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("wtalist", JSONArray.fromObject(wtaList));
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
			DBConnection.closeRes(res);
		}
		return null;
	}

	public String getLastMonthTotal(String name, String date) {
		try {
			sql = "select * from worktimeadjust where name = ? and date= ?";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, name);
			pre.setString(2, date);
			res = pre.executeQuery();
			list = new ArrayList<DailyReport>();
			double lmt = -1.0;
			while (res.next()) {
				lmt = res.getDouble("thisMonthTotal");
			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("lmt", lmt);
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
			DBConnection.closeRes(res);
		}
		return null;
	}

	public String updateWorkTimeAdjust(WorkTimeAdjust wta) {
		try {
			sql = "select * from worktimeadjust where name = ? and date= ?";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, wta.getName());
			pre.setString(2, wta.getDate());
			res = pre.executeQuery();
			while (res.next()) {
				return editWorkTimeAdjust(wta);
			}
			return addWorkTimeAdjust(wta);
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
			DBConnection.closeRes(res);
		}
	}

	public String addWorkTimeAdjust(WorkTimeAdjust wta) {
		jsonObject = new JSONObject();
		try {
			sql = "insert into worktimeadjust (name,date,actualOverWorkTime4H,actualOverWorkTime,approvedRest,lastMonthTotal,thisMonthTotal)"
					+ " values (?,?,?,?,?,?,?)";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, wta.getName());
			pre.setString(2, wta.getDate());
			pre.setDouble(3, wta.getActualOverWorkTime4H());
			pre.setDouble(4, wta.getActualOverWorkTime());
			pre.setDouble(5, wta.getApprovedRest());
			pre.setDouble(6, wta.getLastMonthTotal());
			pre.setDouble(7, wta.getThisMonthTotal());
			int j = pre.executeUpdate();
			if (j > 0) {
				jsonObject.put("errcode", "0");
			} else {
				jsonObject.put("errcode", "1");
			}
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
			jsonObject.put("errcode", "2");
			return jsonObject.toString();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
		}
	}

	public String editWorkTimeAdjust(WorkTimeAdjust wta) {
		jsonObject = new JSONObject();
		try {
			sql = "update worktimeadjust set actualOverWorkTime4H=?,actualOverWorkTime=?,"
					+ "approvedRest=?,lastMonthTotal=?,thisMonthTotal=? where name = ? and date = ?";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setDouble(1, wta.getActualOverWorkTime4H());
			pre.setDouble(2, wta.getActualOverWorkTime());
			pre.setDouble(3, wta.getApprovedRest());
			pre.setDouble(4, wta.getLastMonthTotal());
			pre.setDouble(5, wta.getThisMonthTotal());
			pre.setString(6, wta.getName());
			pre.setString(7, wta.getDate());
			int j = pre.executeUpdate();
			if (j > 0) {
				jsonObject.put("errcode", "0");
			} else {
				jsonObject.put("errcode", "1");
			}
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
			jsonObject.put("errcode", "2");
			return jsonObject.toString();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
		}
	}

	public String getThisMonthTotal(String name, String date) {
		try {
			sql = "select * from worktimeadjust where name = ? and date= ?";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, name);
			pre.setString(2, date);
			res = pre.executeQuery();
			double actualOverWorkTime = -1.0;
			double actualOverWorkTime4H = -1.0;
			double approvedRest = -1.0;
			double thisMonthTotal = -1.0;
			while (res.next()) {
				actualOverWorkTime = res.getDouble("actualOverWorkTime");
				actualOverWorkTime4H = res.getDouble("actualOverWorkTime4H");
				approvedRest = res.getDouble("approvedRest");
				thisMonthTotal = res.getDouble("thisMonthTotal");
			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("actualOverWorkTime", actualOverWorkTime);
			jsonObject.put("actualOverWorkTime4H", actualOverWorkTime4H);
			jsonObject.put("approvedRest", approvedRest);
			jsonObject.put("thisMonthTotal", thisMonthTotal);

			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
			DBConnection.closeRes(res);
		}
		return null;
	}

	public String confirmTender(Tender tender) {
		jsonObject = new JSONObject();
		try {
			sql = "update tender set tenderState = ? where id = ? and tenderNum = ?";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setInt(1, tender.getTenderState());
			pre.setInt(2, tender.getId());
			pre.setString(3, tender.getTenderNum());

			int j = pre.executeUpdate();
			if (j > 0) {
				jsonObject.put("errcode", "0");
			} else {
				jsonObject.put("errcode", "1");
			}
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "2");
			return jsonObject.toString();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
		}
	}

	public String createAgency(String agencyName) {
		jsonObject = new JSONObject();
		try {
			sql2 = "select * from agency where agencyName like ?";
			con2 = DBConnection.getConnection_Mysql();
			pre2 = con2.prepareStatement(sql2);
			pre2.setString(1, "%" + agencyName + "%");
			res2 = pre2.executeQuery();
			if (res2.next()) {
				// 找到了
				jsonObject.put("errcode", "3");
				return jsonObject.toString();
			}
		} catch (Exception e) {
			e.printStackTrace();
			jsonObject.put("errcode", "2");
			return jsonObject.toString();
		} finally {
			DBConnection.closeCon(con2);
			DBConnection.closePre(pre2);
			DBConnection.closeRes(res2);
		}

		try {
			sql = "insert into agency (agencyName) values (?)";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, agencyName);

			int j = pre.executeUpdate();
			if (j > 0) {
				jsonObject.put("errcode", "0");
			} else {
				jsonObject.put("errcode", "1");
			}
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "2");
			return jsonObject.toString();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
		}
	}

	public String getClientFieldList() {
		try {
			sql = "select * from clientfield order by fieldId";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			res = pre.executeQuery();
			cfList = new ArrayList<ClientField>();
			while (res.next()) {
				ClientField cf = new ClientField();
				cf.setFieldId(res.getInt("fieldId"));
				cf.setClientField(res.getString("clientField"));
				cfList.add(cf);
			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("cflist", JSONArray.fromObject(cfList));
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
			DBConnection.closeRes(res);
		}
		return null;
	}

	public String getAreaList() {
		try {
			sql = "select * from area order by areaId";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			res = pre.executeQuery();
			areaList = new ArrayList<Area>();
			while (res.next()) {
				Area area = new Area();
				area.setAreaId(res.getInt("areaId"));
				area.setAreaName(res.getString("areaName"));
				areaList.add(area);
			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("alist", JSONArray.fromObject(areaList));
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
			DBConnection.closeRes(res);
		}
		return null;
	}

	public String getClientField(int fieldId) {
		try {
			sql = "select * from clientfield where fieldId = ?";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setInt(1, fieldId);
			res = pre.executeQuery();
			if (res.next()) {
				ClientField cf = new ClientField();
				cf.setClientField(res.getString("clientField"));
				cf.setFieldId(res.getInt("fieldId"));
				jsonObject = new JSONObject();
				jsonObject.put("errcode", "0");
				jsonObject.put("errmsg", "query");
				jsonObject.put("clientField", JSONArray.fromObject(cf));
				return jsonObject.toString();
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
			DBConnection.closeRes(res);
		}
		return null;
	}

	public String getArea(int areaId) {
		try {
			sql = "select * from area where areaId = ?";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setInt(1, areaId);
			res = pre.executeQuery();
			if (res.next()) {
				Area area = new Area();
				area.setAreaId(res.getInt("areaId"));
				area.setAreaName(res.getString("areaName"));
				jsonObject = new JSONObject();
				jsonObject.put("errcode", "0");
				jsonObject.put("errmsg", "query");
				jsonObject.put("area", JSONArray.fromObject(area));
				return jsonObject.toString();
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
			DBConnection.closeRes(res);
		}
		return null;
	}

	public String getUserName(String nickName) {
		try {
			sql = "select * from user where nickName = ?";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			if (nickName.equals("leigh.zhang")) {
				nickName = "Leigh.zhang";
			}
			pre.setString(1, nickName);
			res = pre.executeQuery();
			if (res.next()) {
				User user = new User();
				user.setUId(res.getInt("id"));
				user.setName(res.getString("name"));
				user.setNickName(res.getString("nickName"));
				user.setState(res.getString("state"));
				user.setDepartmentId(res.getInt("departmentId"));
				user.setEmail(res.getString("email"));
				jsonObject = new JSONObject();
				jsonObject.put("errcode", "0");
				jsonObject.put("errmsg", "query");
				jsonObject.put("user", JSONArray.fromObject(user));
				return jsonObject.toString();
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
			DBConnection.closeRes(res);
		}
		return null;
	}

	public String getTenderStyleList() {
		try {
			sql = "select * from tenderstyle order by id";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			res = pre.executeQuery();
			tsList = new ArrayList<TenderStyle>();
			while (res.next()) {
				TenderStyle ts = new TenderStyle();
				ts.setId(res.getInt("id"));
				ts.setStyleName(res.getString("styleName"));
				tsList.add(ts);
			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("tslist", JSONArray.fromObject(tsList));
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
			DBConnection.closeRes(res);
		}
		return null;
	}

	public String getProductStyleList() {
		try {
			sql = "select * from productstyle order by id";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			res = pre.executeQuery();
			psList = new ArrayList<ProductStyle>();
			while (res.next()) {
				ProductStyle ps = new ProductStyle();
				ps.setId(res.getInt("id"));
				ps.setStyleName(res.getString("styleName"));
				psList.add(ps);
			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("pslist", JSONArray.fromObject(psList));
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
			DBConnection.closeRes(res);
		}
		return null;
	}

	public String getProductBrandList() {
		try {
			sql = "select * from productbrand order by id";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			res = pre.executeQuery();
			pbList = new ArrayList<ProductBrand>();
			while (res.next()) {
				ProductBrand pb = new ProductBrand();
				pb.setId(res.getInt("id"));
				pb.setBrandName(res.getString("brandName"));
				pbList.add(pb);
			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("pblist", JSONArray.fromObject(pbList));
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
			DBConnection.closeRes(res);
		}
		return null;
	}

	public String getProjectTypeList() {
		try {
			sql = "select * from projecttype order by id";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			res = pre.executeQuery();
			ptList = new ArrayList<ProjectType>();
			while (res.next()) {
				ProjectType pt = new ProjectType();
				pt.setId(res.getInt("id"));
				pt.setTypeName(res.getString("typeName"));
				ptList.add(pt);
			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("ptlist", JSONArray.fromObject(ptList));
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
			DBConnection.closeRes(res);
		}
		return null;
	}

	public String getCaseTypeList() {
		try {
			sql = "select * from caseType order by id";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			res = pre.executeQuery();
			ctList = new ArrayList<CaseType>();
			while (res.next()) {
				CaseType ct = new CaseType();
				ct.setId(res.getInt("id"));
				ct.setTypeName(res.getString("typeName"));
				ctList.add(ct);
			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("ctList", JSONArray.fromObject(ctList));
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
			DBConnection.closeRes(res);
		}
		return null;
	}

	public String getDepartmentList() {
		try {
			sql = "select * from department where isDeleted = 0 order by id";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			res = pre.executeQuery();
			dList = new ArrayList<Department>();
			while (res.next()) {
				Department department = new Department();
				department.setId(res.getInt("id"));
				department.setDepartmentName(res.getString("departmentName"));
				dList.add(department);
			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("dList", JSONArray.fromObject(dList));
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
			DBConnection.closeRes(res);
		}
		return null;
	}

	public String getRoleList() {
		try {
			sql = "select * from role where isDeleted = 0 order by departmentId,roleName";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			res = pre.executeQuery();
			rList = new ArrayList<Role>();
			while (res.next()) {
				Role role = new Role();
				role.setId(res.getInt("id"));
				role.setRoleName(res.getString("roleName"));
				role.setDepartmentId(res.getInt("departmentId"));
				rList.add(role);
			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("roleList", JSONArray.fromObject(rList));
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
			DBConnection.closeRes(res);
		}
		return null;
	}

	public String createRole(Role role) {
		jsonObject = new JSONObject();
		try {
			sql2 = "select * from role where roleName = ? and departmentId = ?";
			con2 = DBConnection.getConnection_Mysql();
			pre2 = con2.prepareStatement(sql2);
			pre2.setString(1, role.getRoleName());
			pre2.setInt(2, role.getDepartmentId());
			res2 = pre2.executeQuery();
			if (res2.next()) {
				// 找到了
				jsonObject.put("errcode", "3");
				return jsonObject.toString();
			}
		} catch (Exception e) {
			e.printStackTrace();
			jsonObject.put("errcode", "2");
			return jsonObject.toString();
		} finally {
			DBConnection.closeCon(con2);
			DBConnection.closePre(pre2);
			DBConnection.closeRes(res2);
		}

		try {
			sql = "insert into role (roleName,departmentId) values (?,?)";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, role.getRoleName());
			pre.setInt(2, role.getDepartmentId());
			int j = pre.executeUpdate();
			if (j > 0) {
				jsonObject.put("errcode", "0");
			} else {
				jsonObject.put("errcode", "1");
			}
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "2");
			return jsonObject.toString();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
		}
	}

	public String editRole(Role role) {
		jsonObject = new JSONObject();
		try {
			sql = "update role set roleName = ? where id = ?";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, role.getRoleName());
			pre.setInt(2, role.getId());
			int j = pre.executeUpdate();
			if (j > 0) {
				jsonObject.put("errcode", "0");
			} else {
				jsonObject.put("errcode", "1");
			}
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "2");
			return jsonObject.toString();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
		}
	}

	public String getRolePermissionList() {
		try {
			sql = "select * from rolePermission where isDeleted = 0 order by type,id";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			res = pre.executeQuery();
			rpList = new ArrayList<RolePermission>();
			while (res.next()) {
				RolePermission rp = new RolePermission();
				rp.setId(res.getInt("id"));
				rp.setPermissionDesc(res.getString("permissionDesc"));
				rp.setType(res.getInt("type"));
				rpList.add(rp);
			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("rpList", JSONArray.fromObject(rpList));
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
			DBConnection.closeRes(res);
		}
		return null;
	}

	public String getPermissionSettingList(PermissionSetting ps) {
		try {
			sql = "select * from permissionSetting where roleId = ? order by permissionId";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setInt(1, ps.getRoleId());
			res = pre.executeQuery();
			psetList = new ArrayList<PermissionSetting>();
			while (res.next()) {
				PermissionSetting pset = new PermissionSetting();
				pset.setId(res.getInt("id"));
				pset.setPermissionId(res.getInt("permissionId"));
				pset.setRoleId(res.getInt("roleId"));
				psetList.add(pset);
			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("permissionSettingList", JSONArray.fromObject(psetList));
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
			DBConnection.closeRes(res);
		}
		return null;
	}

	public String createPermissionSetting(PermissionSetting ps) {
		jsonObject = new JSONObject();
		try {
			sql = "insert into permissionSetting (roleId,permissionId) values (?,?)";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setInt(1, ps.getRoleId());
			pre.setInt(2, ps.getPermissionId());
			int j = pre.executeUpdate();
			if (j > 0) {
				jsonObject.put("errcode", "0");
			} else {
				jsonObject.put("errcode", "1");
			}
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "2");
			return jsonObject.toString();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
		}
	}

	public String editPermissionSetting(PermissionSetting ps) {
		jsonObject = new JSONObject();
		try {
			sql = "delete from permissionSetting where permissionId = ? and roleId = ?";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setInt(1, ps.getPermissionId());
			pre.setInt(2, ps.getRoleId());
			int j = pre.executeUpdate();
			if (j > 0) {
				jsonObject.put("errcode", "0");
			} else {
				jsonObject.put("errcode", "1");
			}
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "2");
			return jsonObject.toString();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
		}
	}

	public String getUserPermissionListByNickName(String nickName) {
		try {
			sql = "select * from permissionSetting a,`user` b where a.roleId = b.roleId and b.nickName=? ORDER BY a.permissionId;";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, nickName);
			res = pre.executeQuery();
			psetList = new ArrayList<PermissionSetting>();
			while (res.next()) {
				PermissionSetting pset = new PermissionSetting();
				pset.setPermissionId(res.getInt("permissionId"));
				psetList.add(pset);
			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("permissionSettingList", JSONArray.fromObject(psetList));
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
			DBConnection.closeRes(res);
		}
		return null;
	}

	public String getUserWorkAttendanceList(String date, String nickName) {
		try {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
			Date inputDate = sdf.parse(date + "/1");
			Date dateTemp = sdf.parse("2021/11/1");
			int compareTo = inputDate.compareTo(dateTemp);
			sql = "select * from daily_report a,`user` b where b.nickName = ? and a.`name` = b.name "
					+ "and CAST(date AS datetime)>=CAST(? AS datetime) and CAST(date AS datetime)<=CAST(? AS datetime) "
					+ "order by CAST(date AS datetime)";
			if (compareTo < 0) {
				// 旧库
				con = DBConnection.getConnection_Mysql2();
			} else {
				// 新库
				con = DBConnection.getConnection_Mysql();
			}
			pre = con.prepareStatement(sql);
			pre.setString(1, nickName);
			pre.setString(2, date + "/1");
			pre.setString(3, date + "/" + CommonUtils.getDays(date));
			res = pre.executeQuery();
			list = new ArrayList<DailyReport>();
			while (res.next()) {
				DailyReport dr = new DailyReport();
				dr.setDate(res.getString("date"));
				dr.setName(res.getString("name"));
				dr.setSchedule(res.getString("schedule"));
				dr.setDailyReport(res.getString("dailyReport"));
				dr.setWeekReport(res.getString("weekReport"));
				dr.setNextWeekPlan(res.getString("nextWeekPlan"));
				dr.setProjectReport(res.getString("projectReport"));
				dr.setSign(res.getString("sign"));
				dr.setRemark(res.getString("remark"));
				dr.setOverWorkTime(res.getDouble("overWorkTime"));
				dr.setAdjustRestTime(res.getDouble("adjustRestTime"));
				dr.setVacationOverWorkTime(res.getDouble("vacationOverWorkTime"));
				dr.setFestivalOverWorkTime(res.getDouble("festivalOverWorkTime"));
				dr.setIsLate(res.getInt("islate"));
				list.add(dr);
			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("dailylist", JSONArray.fromObject(list));
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
			DBConnection.closeRes(res);
		}
		return null;
	}

	public String getUserMonthReportList(String year, String nickName) {
		try {
			int yint = Integer.parseInt(year);
			if (yint > 2021) {
				sql = "select * from daily_report a ,`user` b where SUBSTR(date,1,4) = ? "
						+ "and b.nickName = ? and a.`name` = b.`name` ORDER BY CAST(date AS datetime)";
				con = DBConnection.getConnection_Mysql();
				pre = con.prepareStatement(sql);
				pre.setString(1, year);
				pre.setString(2, nickName);
				res = pre.executeQuery();
				list = new ArrayList<DailyReport>();
				while (res.next()) {
					DailyReport dr = new DailyReport();
					dr.setDate(res.getString("date"));
					dr.setSchedule(res.getString("schedule"));
					dr.setDailyReport(res.getString("dailyReport"));
					dr.setWeekReport(res.getString("weekReport"));
					dr.setNextWeekPlan(res.getString("nextWeekPlan"));
					dr.setProjectReport(res.getString("projectReport"));
					dr.setSign(res.getString("sign"));
					dr.setRemark(res.getString("remark"));
					dr.setIsLate(res.getInt("islate"));
					dr.setOverWorkTime(res.getDouble("overWorkTime"));
					dr.setAdjustRestTime(res.getDouble("adjustRestTime"));
					dr.setFestivalOverWorkTime(res.getDouble("festivalOverWorkTime"));
					list.add(dr);
				}
			} else if (yint < 2021) {
				sql2 = "select * from daily_report a ,`user` b where SUBSTR(date,1,4) = ? "
						+ "and b.nickName = ? and a.`name` = b.`name` ORDER BY CAST(date AS datetime)";
				con2 = DBConnection.getConnection_Mysql2();
				pre2 = con2.prepareStatement(sql2);
				pre2.setString(1, year);
				pre2.setString(2, nickName);
				res2 = pre2.executeQuery();
				list = new ArrayList<DailyReport>();
				while (res2.next()) {
					DailyReport dr = new DailyReport();
					dr.setDate(res2.getString("date"));
					dr.setSchedule(res2.getString("schedule"));
					dr.setDailyReport(res2.getString("dailyReport"));
					dr.setWeekReport(res2.getString("weekReport"));
					dr.setNextWeekPlan(res2.getString("nextWeekPlan"));
					dr.setProjectReport(res2.getString("projectReport"));
					dr.setSign(res2.getString("sign"));
					dr.setRemark(res2.getString("remark"));
					dr.setIsLate(res2.getInt("islate"));
					dr.setOverWorkTime(res2.getDouble("overWorkTime"));
					dr.setAdjustRestTime(res2.getDouble("adjustRestTime"));
					dr.setFestivalOverWorkTime(res2.getDouble("festivalOverWorkTime"));
					list.add(dr);
				}
			} else {
				// 老库
				sql2 = "select * from daily_report a ,`user` b where b.nickName = ? and a.`name` = b.`name` "
						+ "and CAST(a.date AS datetime)<=CAST(? AS datetime) "
						+ "and CAST(a.date AS datetime)>=CAST(? AS datetime) " + "ORDER BY CAST(a.date AS datetime)";
				con2 = DBConnection.getConnection_Mysql2();
				pre2 = con2.prepareStatement(sql2);
				pre2.setString(1, nickName);
				pre2.setString(2, "2021/10/31");
				pre2.setString(3, "2021/01/01");
				res2 = pre2.executeQuery();
				list = new ArrayList<DailyReport>();
				while (res2.next()) {
					DailyReport dr = new DailyReport();
					dr.setDate(res2.getString("date"));
					dr.setSchedule(res2.getString("schedule"));
					dr.setDailyReport(res2.getString("dailyReport"));
					dr.setWeekReport(res2.getString("weekReport"));
					dr.setNextWeekPlan(res2.getString("nextWeekPlan"));
					dr.setProjectReport(res2.getString("projectReport"));
					dr.setSign(res2.getString("sign"));
					dr.setRemark(res2.getString("remark"));
					dr.setIsLate(res2.getInt("islate"));
					dr.setOverWorkTime(res2.getDouble("overWorkTime"));
					dr.setAdjustRestTime(res2.getDouble("adjustRestTime"));
					dr.setFestivalOverWorkTime(res2.getDouble("festivalOverWorkTime"));
					list.add(dr);
				}
				// 新库
				sql = "select * from daily_report a ,`user` b where b.nickName = ? and a.`name` = b.`name` "
						+ "and CAST(date AS datetime)<=CAST(? AS datetime) "
						+ "and CAST(date AS datetime)>=CAST(? AS datetime) " + "ORDER BY CAST(date AS datetime)";
				con = DBConnection.getConnection_Mysql();
				pre = con.prepareStatement(sql);
				pre.setString(1, nickName);
				pre.setString(2, "2021/12/31");
				pre.setString(3, "2021/11/01");
				res = pre.executeQuery();
				while (res.next()) {
					DailyReport dr = new DailyReport();
					dr.setDate(res.getString("date"));
					dr.setSchedule(res.getString("schedule"));
					dr.setDailyReport(res.getString("dailyReport"));
					dr.setWeekReport(res.getString("weekReport"));
					dr.setNextWeekPlan(res.getString("nextWeekPlan"));
					dr.setProjectReport(res.getString("projectReport"));
					dr.setSign(res.getString("sign"));
					dr.setRemark(res.getString("remark"));
					dr.setIsLate(res.getInt("islate"));
					dr.setOverWorkTime(res.getDouble("overWorkTime"));
					dr.setAdjustRestTime(res.getDouble("adjustRestTime"));
					dr.setFestivalOverWorkTime(res.getDouble("festivalOverWorkTime"));
					list.add(dr);
				}
			}
			
			System.out.println(list.size());
			
			List<DailyReport> list1st = new ArrayList<DailyReport>(), list2nd = new ArrayList<DailyReport>();
			List<DailyReport> list3rd = new ArrayList<DailyReport>(), list4th = new ArrayList<DailyReport>();
			List<DailyReport> list5th = new ArrayList<DailyReport>(), list6th = new ArrayList<DailyReport>();
			List<DailyReport> list7th = new ArrayList<DailyReport>(), list8th = new ArrayList<DailyReport>();
			List<DailyReport> list9th = new ArrayList<DailyReport>(), list10th = new ArrayList<DailyReport>();
			List<DailyReport> list11th = new ArrayList<DailyReport>(), list12th = new ArrayList<DailyReport>();

			for (int i = 0; i < list.size(); i++) {
				int month = Integer.parseInt(list.get(i).getDate().substring(5, 7));
				System.out.println("month:"+month);
				if (month == 1) {
					list1st.add(list.get(i));
				} else if (month == 2) {
					list2nd.add(list.get(i));
				} else if (month == 3) {
					list3rd.add(list.get(i));
				} else if (month == 4) {
					list4th.add(list.get(i));
				} else if (month == 5) {
					list5th.add(list.get(i));
				} else if (month == 6) {
					list6th.add(list.get(i));
				} else if (month == 7) {
					list7th.add(list.get(i));
				} else if (month == 8) {
					list8th.add(list.get(i));
				} else if (month == 9) {
					list9th.add(list.get(i));
				} else if (month == 10) {
					list10th.add(list.get(i));
				} else if (month == 11) {
					list11th.add(list.get(i));
					System.out.println(list11th);
				} else if (month == 12) {
					list12th.add(list.get(i));
				}
			}
			List<List<DailyReport>> newList = new ArrayList<List<DailyReport>>();
			newList.add(list1st);
			newList.add(list2nd);
			newList.add(list3rd);
			newList.add(list4th);
			newList.add(list5th);
			newList.add(list6th);
			newList.add(list7th);
			newList.add(list8th);
			newList.add(list9th);
			newList.add(list10th);
			newList.add(list11th);
			newList.add(list12th);
			
			MonthReport mReport = new MonthReport();
			list2 = new ArrayList<MonthReport>();
			for (int j = 0; j < 12; j++) {
				mReport = getMonthReport(newList.get(j));
				if (mReport != null) {
					list2.add(mReport);
				}
			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("monthlist", JSONArray.fromObject(list2));
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(con!=null&&pre!=null&&res!=null) {
				DBConnection.closeCon(con);
				DBConnection.closePre(pre);
				DBConnection.closeRes(res);
			}else if(con2!=null&&pre2!=null&&res2!=null) {
				DBConnection.closeCon(con2);
				DBConnection.closePre(pre2);
				DBConnection.closeRes(res2);
			}
		}
		return null;
	}

	private MonthReport getMonthReport(List<DailyReport> mylist) {
		
		int scheduleT = 0, dailyReportT = 0, weekReportT = 0, nextWeekPlanT = 0, projectReportT = 0, noSignIn = 0,
				noSignOut = 0, isLateT = 0;
		double overWorkTimeT = 0, adjustRestTimeT = 0, festivalOverWorkTimeT = 0;
		if (mylist.size() > 0) {
			for (int i = 0; i < mylist.size(); i++) {
				
				if (mylist.get(i).getSchedule().equals("未发")) {
					scheduleT++;
				}
				if (mylist.get(i).getDailyReport().equals("未发")) {
					dailyReportT++;
				}
				/*if (mylist.get(i).getWeekReport().equals("未发")) {
					weekReportT++;
				}
				if (mylist.get(i).getNextWeekPlan().equals("未发")) {
					nextWeekPlanT++;
				}
				if (mylist.get(i).getProjectReport().equals("未发")) {
					projectReportT++;
				}*/
				if (mylist.get(i).getSign().contains("未签到")) {
					noSignIn++;
				}
				if (mylist.get(i).getSign().contains("未签退")) {
					noSignOut++;
				}
				isLateT = isLateT + mylist.get(i).getIsLate();
				overWorkTimeT = overWorkTimeT + mylist.get(i).getOverWorkTime();
				adjustRestTimeT = adjustRestTimeT + mylist.get(i).getAdjustRestTime();
				festivalOverWorkTimeT = festivalOverWorkTimeT + mylist.get(i).getFestivalOverWorkTime();
			}
			MonthReport mp = new MonthReport();
			mp.setMonth(Integer.parseInt(mylist.get(0).getDate().substring(5, 7)));
			mp.setName(mylist.get(0).getName());
			mp.setScheduleT(scheduleT);
			mp.setDailyReportT(dailyReportT);
			mp.setWeekReportT(weekReportT);
			mp.setNextWeekPlanT(nextWeekPlanT);
			mp.setProjectReportT(projectReportT);
			mp.setNoSignIn(noSignIn);
			mp.setNoSignOut(noSignOut);
			mp.setIsLate(isLateT);
			mp.setOverWorkTime(overWorkTimeT);
			mp.setAdjustRestTime(adjustRestTimeT);
			mp.setFestivalOverWorkTime(festivalOverWorkTimeT);
			return mp;
		} 
        return null;
		

	}

	public String getMonthAccumulateData(String date, String nickName) {
		try {
			sql = "select * from month_report a,`user` b where a.userId = b.id and b.nickName=? and a.date = ?";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, nickName);
			pre.setString(2, date);
			res = pre.executeQuery();
			double accumulateOverWorkTime = 0.0;
			double accumulateYearVacation = 0.0;
			double overWorkTime4H = 0.0;
			while (res.next()) {
				accumulateOverWorkTime = res.getDouble("accumulateOverWorkTime");
				accumulateYearVacation = res.getDouble("accumulateYearVacation");
				overWorkTime4H = res.getDouble("overWorkTime4H");
			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("date", date);
			jsonObject.put("accumulateOverWorkTime", accumulateOverWorkTime);
			jsonObject.put("accumulateYearVacation", accumulateYearVacation);
			jsonObject.put("overWorkTime4H", overWorkTime4H);
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
			DBConnection.closeRes(res);
		}
		return null;
	}

	public String getUserWorkAttendanceList(String date) {
		//System.out.println("sssss  "+date);
		try {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
			Date inputDate = sdf.parse(date);
			Date dateTemp = sdf.parse("2021/11/1");
			int compareTo = inputDate.compareTo(dateTemp);
			if(compareTo>=0) {
				con = DBConnection.getConnection_Mysql();
			}else {
				con = DBConnection.getConnection_Mysql2();
			}
			sql = "select * from daily_report a,`user` b where date = ? and a.name = b.`name` order by b.departmentId,b.id";
			pre = con.prepareStatement(sql);
			pre.setString(1, date);
			res = pre.executeQuery();
			list = new ArrayList<DailyReport>();
			while (res.next()) {
				DailyReport dr = new DailyReport();
				dr.setDate(res.getString("date"));
				dr.setName(res.getString("name"));
				dr.setSchedule(res.getString("schedule"));
				dr.setDailyReport(res.getString("dailyReport"));
				dr.setWeekReport(res.getString("weekReport"));
				dr.setNextWeekPlan(res.getString("nextWeekPlan"));
				dr.setProjectReport(res.getString("projectReport"));
				dr.setSign(res.getString("sign"));
				dr.setRemark(res.getString("remark"));
				dr.setOverWorkTime(res.getDouble("overWorkTime"));
				dr.setAdjustRestTime(res.getDouble("adjustRestTime"));
				dr.setVacationOverWorkTime(res.getDouble("vacationOverWorkTime"));
				dr.setFestivalOverWorkTime(res.getDouble("festivalOverWorkTime"));
				dr.setIsLate(res.getInt("islate"));
				list.add(dr);
			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("dailylist", JSONArray.fromObject(list));
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
			DBConnection.closeRes(res);
		}
		return null;
	}

	public String editWorkAttendance(DailyReport mDr) {
		jsonObject = new JSONObject();
		try {
			sql = "update daily_report set `schedule`= ?, dailyReport = ?,weekReport = ?,nextWeekPlan = ?,"
					+ "projectReport = ?,sign = ?,remark = ?,overWorkTime = ?,adjustRestTime = ?,festivalOverWorkTime = ?,"
					+ "isLate = ? where `name` = ? and date = ?";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, mDr.getSchedule());
			pre.setString(2, mDr.getDailyReport());
			pre.setString(3, mDr.getWeekReport());
			pre.setString(4, mDr.getNextWeekPlan());
			pre.setString(5, mDr.getProjectReport());
			pre.setString(6, mDr.getSign());
			pre.setString(7, mDr.getRemark());
			pre.setDouble(8, mDr.getOverWorkTime());
			pre.setDouble(9, mDr.getAdjustRestTime());
			pre.setDouble(10, mDr.getFestivalOverWorkTime());
			pre.setInt(11, mDr.getIsLate());
			pre.setString(12, mDr.getName());
			pre.setString(13, mDr.getDate());
			int j = pre.executeUpdate();
			if (j > 0) {
				jsonObject.put("errcode", "0");
			} else {
				jsonObject.put("errcode", "1");
			}
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
			jsonObject.put("errcode", "2");
			return jsonObject.toString();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
		}
	}
	
	public String deleteWorkAttendance(String date) {
		jsonObject = new JSONObject();
		try {
			sql = "delete from daily_report where date = ?";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1,date);
			int j = pre.executeUpdate();
			if (j > 0) {
				jsonObject.put("errcode", "0");
			} else {
				jsonObject.put("errcode", "1");
			}
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
			jsonObject.put("errcode", "2");
			return jsonObject.toString();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
		}
	}

	public String getUserMonthReportList(String date) {
		try {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
			Date inputDate = sdf.parse(date + "/1");
			Date dateTemp = sdf.parse("2021/11/1");
			int compareTo = inputDate.compareTo(dateTemp);
			if (compareTo >= 0) {
				// 新库
				con = DBConnection.getConnection_Mysql();
			} else if (compareTo < 0) {
				// 老库
				con = DBConnection.getConnection_Mysql2();
			}

			sql = "select * from daily_report where SUBSTR(date,1,7) = ? ORDER BY CAST(date AS datetime)";
			pre = con.prepareStatement(sql);
			pre.setString(1, date);
			res = pre.executeQuery();
			list = new ArrayList<DailyReport>();
			while (res.next()) {
				DailyReport dr = new DailyReport();
				dr.setDate(res.getString("date"));
				dr.setName(res.getString("name"));
				dr.setSchedule(res.getString("schedule"));
				dr.setDailyReport(res.getString("dailyReport"));
				dr.setWeekReport(res.getString("weekReport"));
				dr.setNextWeekPlan(res.getString("nextWeekPlan"));
				dr.setProjectReport(res.getString("projectReport"));
				dr.setSign(res.getString("sign"));
				dr.setRemark(res.getString("remark"));
				dr.setIsLate(res.getInt("islate"));
				dr.setOverWorkTime(res.getDouble("overWorkTime"));
				dr.setAdjustRestTime(res.getDouble("adjustRestTime"));
				dr.setFestivalOverWorkTime(res.getDouble("festivalOverWorkTime"));
				list.add(dr);
			}
			uList = new ArrayList<User>();
			uList = getUserList2(date, 99);
			List<List<DailyReport>> newList = new ArrayList<List<DailyReport>>();
			for (int i = 0; i < uList.size(); i++) {
				String name = uList.get(i).getName();
				List<DailyReport> listUserList = new ArrayList<DailyReport>();
				for (int j = 0; j < list.size(); j++) {
					if (list.get(j).getName().equals(name)) {
						listUserList.add(list.get(j));
					}
				}
				newList.add(listUserList);
			}
			MonthReport mReport = new MonthReport();
			list2 = new ArrayList<MonthReport>();
			for (int k = 0; k < newList.size(); k++) {
				mReport = getMonthReport(newList.get(k));
				if (mReport != null) {
					list2.add(mReport);
				}
			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("monthlist", JSONArray.fromObject(list2));
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
			DBConnection.closeRes(res);
		}
		return null;
	}

	public String queryMonthAccumulateData(MonthReport mr) {
		jsonObject = new JSONObject();
		try {
			sql2 = "select * from month_report where date = ? and userId = ?";
			con2 = DBConnection.getConnection_Mysql();
			pre2 = con2.prepareStatement(sql2);
			pre2.setString(1, mr.getDate());
			pre2.setInt(2, Integer.parseInt(mr.getName()));
			res2 = pre2.executeQuery();
			if (res2.next()) {
				// 编辑
				return editMonthAccumulateData(mr);
			} else {
				// 新建
				return createMonthAccumulateData(mr);
			}
		} catch (Exception e) {
			e.printStackTrace();
			jsonObject.put("errcode", "2");
			return jsonObject.toString();
		} finally {
			DBConnection.closeCon(con2);
			DBConnection.closePre(pre2);
			DBConnection.closeRes(res2);
		}

	}

	private String editMonthAccumulateData(MonthReport mr) {
		jsonObject = new JSONObject();
		try {
			sql = "update month_report set accumulateOverWorkTime = ?,accumulateYearVacation = ? where date = ? and userId = ?";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setDouble(1, mr.getAccumulateOverWorkTime());
			pre.setDouble(2, mr.getAccumulateYearVacation());
			// pre.setDouble(3, mr.getOverWorkTime4H());
			pre.setString(3, mr.getDate());
			pre.setInt(4, Integer.parseInt(mr.getName()));
			int j = pre.executeUpdate();
			if (j > 0) {
				jsonObject.put("errcode", "0");
			} else {
				jsonObject.put("errcode", "1");
			}
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "2");
			return jsonObject.toString();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
		}
	}

	private String createMonthAccumulateData(MonthReport mr) {
		try {
			sql = "insert into month_report (date,userId,accumulateOverWorkTime,accumulateYearVacation) values (?,?,?,?)";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, mr.getDate());
			pre.setInt(2, Integer.parseInt(mr.getName()));
			pre.setDouble(3, mr.getAccumulateOverWorkTime());
			pre.setDouble(4, mr.getAccumulateYearVacation());
			// pre.setDouble(5, mr.getOverWorkTime4H());
			int j = pre.executeUpdate();
			if (j > 0) {
				jsonObject.put("errcode", "0");
			} else {
				jsonObject.put("errcode", "1");
			}
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "2");
			return jsonObject.toString();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
		}
	}

	public String createWorkAttendance(DailyReport dr) {
		jsonObject = new JSONObject();
		try {
			sql = "insert into daily_report (date,name,schedule,dailyReport,weekReport,nextWeekPlan,projectReport,sign,remark,islate,overWorkTime,adjustRestTime,festivalOverWorkTime) values (?,?,?,?,?,?,?,?,?,?,?,?,?)";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, dr.getDate());
			pre.setString(2, dr.getName());
			pre.setString(3, dr.getSchedule());
			pre.setString(4, dr.getDailyReport());
			pre.setString(5, dr.getWeekReport());
			pre.setString(6, dr.getNextWeekPlan());
			pre.setString(7, dr.getProjectReport());
			pre.setString(8, dr.getSign());
			pre.setString(9, dr.getRemark());
			pre.setInt(10, dr.getIsLate());
			pre.setDouble(11, dr.getOverWorkTime());
			pre.setDouble(12, dr.getAdjustRestTime());
			pre.setDouble(13, dr.getFestivalOverWorkTime());
			int j = pre.executeUpdate();
			if (j > 0) {
				jsonObject.put("errcode", "0");
			} else {
				jsonObject.put("errcode", "1");
			}
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "2");
			return jsonObject.toString();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
		}
	}

	public String deletePosition(int id) {
		jsonObject = new JSONObject();
		try {
			sql = "update jobposition set isDeleted = ? where id = ?";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setBoolean(1, true);
			pre.setInt(2, id);
			int j = pre.executeUpdate();
			if (j > 0) {
				jsonObject.put("errcode", "0");
			} else {
				jsonObject.put("errcode", "1");
			}
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "2");
			return jsonObject.toString();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
		}
	}

	public String editPosition(JobPosition jp) {
		jsonObject = new JSONObject();
		try {
			sql = "update jobposition set jobTitle = ?,techDemand = ?,level = ? ,salary = ? ,educationDemand = ?,otherDemand = ? where id = ?";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, jp.getJobTitle());
			pre.setString(2, jp.getTechDemand());
			pre.setString(3, jp.getLevel());
			pre.setString(4, jp.getSalary());
			pre.setInt(7, jp.getId());
			pre.setString(5, jp.getEducationDemand());
			pre.setString(6, jp.getOtherDemand());

			int j = pre.executeUpdate();
			if (j >= 0) {
				jsonObject.put("errcode", "0");
			} else {
				jsonObject.put("errcode", "1");
			}
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "2");
			return jsonObject.toString();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
		}
	}

	public String createPosition(JobPosition jp) {
		jsonObject = new JSONObject();
		String jobTitle = jp.getJobTitle();
		String techDemand = jp.getTechDemand();
		String level = jp.getLevel();
		String salary = jp.getSalary();
		String educationDemand = jp.getEducationDemand();
		String otherDemand = jp.getOtherDemand();

		try {
			sql2 = "select * from jobposition where jobTitle = ? and techDemand = ? and isDeleted = ?";
			con2 = DBConnection.getConnection_Mysql();
			pre2 = con2.prepareStatement(sql2);
			pre2.setString(1, jobTitle);
			pre2.setString(2, techDemand);
			pre2.setBoolean(3, false);

			res2 = pre2.executeQuery();
			if (res2.next()) {
				// 找到了
				jsonObject.put("errcode", "3");
				return jsonObject.toString();
			}
		} catch (Exception e) {
			e.printStackTrace();
			jsonObject.put("errcode", "2");
			return jsonObject.toString();
		} finally {
			DBConnection.closeCon(con2);
			DBConnection.closePre(pre2);
			DBConnection.closeRes(res2);
		}

		try {
			sql = "insert into jobposition (jobTitle,techDemand,level,salary,educationDemand,otherDemand) values (?,?,?,?,?,?)";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, jobTitle);
			pre.setString(2, techDemand);
			pre.setString(3, level);
			pre.setString(4, salary);
			pre.setString(5, educationDemand);
			pre.setString(6, otherDemand);
			int j = pre.executeUpdate();
			if (j > 0) {
				jsonObject.put("errcode", "0");
			} else {
				jsonObject.put("errcode", "1");
			}
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "2");
			return jsonObject.toString();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
		}
	}

	public String getCompanyInfo() {
		try {
			sql = "select * from companyInfo";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			res = pre.executeQuery();
			if (res.next()) {
				Company c = new Company();
				c.setCompanyName(res.getString("mail"));
				c.setCompanyId(res.getString("tel"));
				c.setAddress(res.getString("address"));
				jsonObject = new JSONObject();
				jsonObject.put("errcode", "0");
				jsonObject.put("errmsg", "query");
				jsonObject.put("company", JSONArray.fromObject(c));
				return jsonObject.toString();
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
			DBConnection.closeRes(res);
		}
		return null;
	}

	public String editCompanyInfo(String address, String tel, String mail) {
		jsonObject = new JSONObject();
		try {
			sql = "update companyInfo set address = ?,tel = ?,mail = ?";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, address);
			pre.setString(2, tel);
			pre.setString(3, mail);
			int j = pre.executeUpdate();
			if (j >= 0) {
				jsonObject.put("errcode", "0");
			} else {
				jsonObject.put("errcode", "1");
			}
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "2");
			return jsonObject.toString();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
		}
	}

	

}
