package com.fmlk.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.fmlk.entity.DailyReport;
import com.fmlk.entity.JobPosition;
import com.fmlk.entity.MonthReport;
import com.fmlk.entity.PermissionSetting;
import com.fmlk.util.DBConnection;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public class WebDao {
	
	private Connection con, con2, con3 = null;
	private PreparedStatement pre, pre2, pre3 = null;
	private String sql, sql2, sql3 = null;
	private JSONObject jsonObject = null;
	private ResultSet res, res2, res3 = null;
	private List<JobPosition> list = null;

	public String getJobPositionList() {
		try {
			sql = "select * from jobposition where isDeleted = 0 ORDER BY jobTitle,id";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			res = pre.executeQuery();
			list = new ArrayList<JobPosition>();
			while (res.next()) {
				JobPosition jp = new JobPosition();
				jp.setId(res.getInt("id"));
				jp.setJobTitle(res.getString("jobTitle"));
				jp.setTechDemand(res.getString("techDemand"));
				jp.setLevel(res.getString("level"));
				jp.setSalary(res.getString("salary"));
				jp.setEducationDemand(res.getString("educationDemand"));
				jp.setOtherDemand(res.getString("otherDemand"));
				list.add(jp);
			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("jobPositionList", JSONArray.fromObject(list));
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

}
