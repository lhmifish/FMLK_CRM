package com.fmlk.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import com.fmlk.entity.Inform;
import com.fmlk.entity.Job;
import com.fmlk.util.DBConnection;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public class JobDao {

	private Connection con = null;
	private PreparedStatement pre = null;
	private String sql = null;
	private JSONObject jsonObject = null;
	private ResultSet res = null;
	private List<Job> jobList = null;
	private List<Inform> iList = null;
	
	private boolean queryJob2(String date, int userId,String time) {
		boolean isExist = false;
		try {
			sql = "select * from job where date = ? and userId = ? and time = ?";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, date);
			pre.setInt(2, userId);
			pre.setString(3, time);
			res = pre.executeQuery();
			if (res.next()) {
				isExist = true;
			}
			return isExist;
		} catch (Exception e) {
			e.printStackTrace();
			return isExist;
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
		}
	}
	
	public String editJob(String date, int userId, String descriptionA, String editDate) {
		jsonObject = new JSONObject();
		try {
			sql = "update job set jobDescriptionA = ? ,editDate = ? where date = ? and userId = ?";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, descriptionA);
			pre.setString(2, editDate);
			pre.setString(3, date);
			pre.setInt(4, userId);
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
	
	public String createJob(String date, int userId, String descriptionA, String editDate) {
		jsonObject = new JSONObject();
		try {
			sql = "insert into job (date,userId,jobDescriptionA,createDate,editDate) values (?,?,?,?,?)";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, date);
			pre.setInt(2, userId);
			pre.setString(3, descriptionA);
			pre.setString(4, editDate);
			pre.setString(5, editDate);
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
	
	public String getJobList(String year, String month, int userId) {
		try {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
			Date inputDate = sdf.parse(year+"/"+month+"/1");
			Date dateTemp = sdf.parse("2021/11/1");
			int compareTo = inputDate.compareTo(dateTemp);
			if(compareTo>=0) {
				con = DBConnection.getConnection_Mysql();
			}else {
				con = DBConnection.getConnection_Mysql2();
			}
			sql = "select * from job where SUBSTR(date,6,2) = ? and SUBSTR(date,1,4) = ?";
			if (userId != 0) {
				sql += " and userId = " + userId;
			}
			sql += " order by CAST(date AS datetime),userId";
			pre = con.prepareStatement(sql);
			pre.setString(1, month);
			pre.setString(2, year);
			res = pre.executeQuery();
			jobList = new ArrayList<Job>();
			while (res.next()) {
				Job job = new Job();
				job.setDate(res.getString("date"));
				job.setUserId(res.getInt("userId"));
				job.setJobDescriptionP(res.getString("jobDescriptionP"));
				job.setJobDescriptionA(res.getString("jobDescriptionA"));
				job.setTime(res.getString("time"));
				job.setCreateDate(res.getString("createDate"));
				jobList.add(job);
			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("joblist", JSONArray.fromObject(jobList));
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

	public String getWeekPlan(int uId, String startDate, String endDate) {
		try {
			sql = "select * from job where CAST(date AS datetime)>=CAST(? AS datetime) "
					+ "and CAST(date AS datetime)<=CAST(? AS datetime)";
			if(uId != 0) {
				sql += " and userId = "+uId;
			}
			sql += " order by CAST(date AS datetime)";
			
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, startDate);
			pre.setString(2, endDate);
			res = pre.executeQuery();
			jobList = new ArrayList<Job>();
			while (res.next()) {
				Job job = new Job();
				job.setDate(res.getString("date"));
				job.setUserId(res.getInt("userId"));
				job.setTime(res.getString("time"));
				job.setJobDescriptionP(res.getString("jobDescriptionP"));
				jobList.add(job);
			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("joblist", JSONArray.fromObject(jobList));
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

	public String queryWeekPlan(int userId, String[] arrayWeekPlan, String editDate) {
		jsonObject = new JSONObject();
		String returnStr = "";
		for (int i = 0; i < arrayWeekPlan.length; i++) {
			String date = arrayWeekPlan[i].split("#")[0];
			//先删除这个用户所有date的job记录
			deleteWeekPlan(userId,date);
		}
		for(int i = 0; i < arrayWeekPlan.length; i++) {
			// 全部重新添加
			String date = arrayWeekPlan[i].split("#")[0];
			String time = arrayWeekPlan[i].split("#")[1];
			String descriptionP = arrayWeekPlan[i].split("#")[2];
			returnStr = createWeekPlan(date, time, userId, descriptionP, editDate);
		}
		return returnStr;
	}
	
	public String deleteWeekPlan(int userId,String date) {
		jsonObject = new JSONObject();
		try {
			sql = "delete from job where date = ? and userId = ?";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, date);
			pre.setInt(2, userId);
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

	public String editWeekPlan(String date, String time, int userId, String descriptionP, String editDate) {
		jsonObject = new JSONObject();
		try {
			sql = "update job set jobDescriptionP = ? ,time = ? ,editDate = ? where date = ? and userId = ?";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, descriptionP);
			pre.setString(2, time);
			pre.setString(3, editDate);
			pre.setString(4, date);
			pre.setInt(5, userId);
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

	public String createWeekPlan(String date, String time, int userId, String descriptionP, String editDate) {
		jsonObject = new JSONObject();
		try {
			sql = "insert into job (date,userId,jobDescriptionP,time,createDate,editDate) values (?,?,?,?,?,?)";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, date);
			pre.setInt(2, userId);
			pre.setString(3, descriptionP);
			pre.setString(4, time);
			pre.setString(5, editDate);
			pre.setString(6, editDate);
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

	

	

	public String getJob(int userId, String date) {
		try {
			sql = "select * from job where userId = ? and date = ?";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setInt(1, userId);
			pre.setString(2, date);
			res = pre.executeQuery();
			if (res.next()) {
				Job j = new Job();
				j.setTime(res.getString("time"));
				j.setJobDescriptionP(res.getString("jobDescriptionP"));
				j.setDate(res.getString("date"));
				j.setJobDescriptionA(res.getString("jobDescriptionA"));
				j.setUserId(res.getInt("userId"));
				jsonObject = new JSONObject();
				jsonObject.put("errcode", "0");
				jsonObject.put("errmsg", "query");
				jsonObject.put("job", JSONArray.fromObject(j));
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
	
	public String getDailyArrangementList(String date) {
		try {
			sql = "select a.date,a.userId,a.time,a.jobDescriptionP from job a,`user` b where a.userId = b.id and a.date = ? ORDER BY b.departmentId,b.id,CAST(a.date AS datetime)";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, date);
			res = pre.executeQuery();
			jobList = new ArrayList<Job>();
			while (res.next()) {
				Job job = new Job();
				job.setDate(res.getString("date"));
				job.setUserId(res.getInt("userId"));
				job.setTime(res.getString("time"));
				job.setJobDescriptionP(res.getString("jobDescriptionP"));
				jobList.add(job);
			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("dailyarrangementlist", JSONArray.fromObject(jobList));
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

	public String createSendInformation(Inform inf) {
		jsonObject = new JSONObject();
		String title = inf.getTitle();
		String content = inf.getContent();
		int departmentId = inf.getDepartmentId();
		int informType = inf.getInformType();//1.立即2.且报警
		String informDate = inf.getInformDate();
		Boolean isOverTime = false;
		if(informType==1) {
			isOverTime = true;
		}
		try {
			sql = "insert into inform (title,content,departmentId,informType,informDate,isOverTime) values (?,?,?,?,?,?)";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, title);
			pre.setString(2, content);
			pre.setInt(3, departmentId);
			pre.setInt(4, informType);
			pre.setString(5, informDate);
			pre.setBoolean(6, isOverTime);
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

	public String getTomorrowInformList(String tomorrowString) {
		try {
			sql = "select * from inform where isOverTime = ? and informType = ? and informDate= ?";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setBoolean(1, false);
			pre.setInt(2, 2);
			pre.setString(3, tomorrowString);
			res = pre.executeQuery();
			iList = new ArrayList<Inform>();
			while (res.next()) {
				Inform inf = new Inform();
				inf.setTitle(res.getString("title"));
				inf.setContent(res.getString("content"));
				inf.setDepartmentId(res.getInt("departmentId"));
				iList.add(inf);
			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("informlist", JSONArray.fromObject(iList));
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

	public String editSendInformation(String tomorrowString) {
		jsonObject = new JSONObject();
		try {
			sql = "update inform set isOverTime=? where informDate = ?";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setBoolean(1, true);
			pre.setString(2, tomorrowString);
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
}
