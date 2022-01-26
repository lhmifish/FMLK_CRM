package com.fmlk.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import com.fmlk.entity.Tender;
import com.fmlk.util.DBConnection;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public class TenderDao {

	private Connection con, con2 = null;
	private PreparedStatement pre, pre2 = null;
	private String sql, sql2 = null;
	private JSONObject jsonObject = null;
	private ResultSet res, res2 = null;
	private List<Tender> tList = null;

	public String createTender(Tender tender) {
		jsonObject = new JSONObject();
		try {
			sql2 = "select * from tender where tenderNum = ? and projectId = ?";
			con2 = DBConnection.getConnection_Mysql();
			pre2 = con2.prepareStatement(sql2);
			pre2.setString(1, tender.getTenderNum());
			pre2.setString(2, tender.getProjectId());
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
			sql = "insert into tender (tenderNum,tenderCompany,tenderAgency,projectId,dateForBuy,dateForSubmit,dateForOpen,"
					+ "saleUser,tenderStyle,tenderExpense,tenderIntent,productStyle,productBrand,enterpriseQualificationRequirment,"
					+ "technicalRequirment,remark,tenderGuaranteeFee,createDate) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, tender.getTenderNum());
			pre.setString(2, tender.getTenderCompany());
			pre.setInt(3, tender.getTenderAgency());
			pre.setString(4, tender.getProjectId());
			pre.setString(5, tender.getDateForBuy());
			pre.setString(6, tender.getDateForSubmit());
			pre.setString(7, tender.getDateForOpen());
			pre.setInt(8, tender.getSaleUser());
			pre.setInt(9, tender.getTenderStyle());
			pre.setInt(10, tender.getTenderExpense());
			pre.setInt(11, tender.getTenderIntent());
			pre.setInt(12, tender.getProductStyle());
			pre.setInt(13, tender.getProductBrand());
			pre.setString(14, tender.getEnterpriseQualificationRequirment());
			pre.setString(15, tender.getTechnicalRequirment());
			pre.setString(16, tender.getRemark());
			pre.setInt(17, tender.getTenderGuaranteeFee());
			pre.setString(18, tender.getCreateDate());
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

	public String editTender(Tender tender) {
		jsonObject = new JSONObject();
		try {
			sql = "update tender set ";
			con = DBConnection.getConnection_Mysql();
			if(!tender.getTenderCompany().equals("")) {
				sql += "tenderCompany = '" + tender.getTenderCompany() + "',";
			}
			if(tender.getTenderAgency() != 0) {
				sql += "tenderAgency = " + tender.getTenderAgency() + ",";
			}
			if(!tender.getProjectId().equals("")) {
				sql += "projectId = '" + tender.getProjectId() + "',";
			}
			if(!tender.getDateForBuy().equals("")) {
				sql += "dateForBuy = '" + tender.getDateForBuy() + "',";
			}
			if(!tender.getDateForSubmit().equals("")) {
				sql += "dateForSubmit = '" + tender.getDateForSubmit() + "',";
			}
			if(!tender.getDateForOpen().equals("")) {
				sql += "dateForOpen = '" + tender.getDateForOpen() + "',";
			}
			if(tender.getSaleUser() != 0) {
				sql += "saleUser = " + tender.getSaleUser() + ",";
			}
			if(tender.getTenderStyle() != 0) {
				sql += "tenderStyle = " + tender.getTenderStyle() + ",";
			}
			if(tender.getTenderExpense() != 0) {
				sql += "tenderExpense = " + tender.getTenderExpense() + ",";
			}
			if(tender.getTenderResult() != 0) {
				sql += "tenderResult = " + tender.getTenderResult() + ",";
			}
			if(tender.getTenderIntent() != 0) {
				sql += "tenderIntent = " + tender.getTenderIntent() + ",";
			}
			if(tender.getProductStyle() != 0) {
				sql += "productStyle = " + tender.getProductStyle() + ",";
			}
			if(tender.getProductBrand() != 0) {
				sql += "productBrand = " + tender.getProductBrand() + ",";
			}
			if(!tender.getEnterpriseQualificationRequirment().equals("")) {
				sql += "enterpriseQualificationRequirment = '" + tender.getEnterpriseQualificationRequirment() + "',";
			}
			if(!tender.getTechnicalRequirment().equals("")) {
				sql += "technicalRequirment = '" + tender.getTechnicalRequirment() + "',";
			}
			if(!tender.getRemark().equals("")) {
				sql += "remark = '" + tender.getRemark() + "',";
			}
			if(tender.getServiceExpense() != 0) {
				sql += "serviceExpense = " + tender.getServiceExpense() + ",";
			}
			if(tender.getIsUploadTender()) {
				sql += "isUploadTender = " + tender.getIsUploadTender() + ",";
			}
			sql += "tenderNum = ? where id = ?";
			pre = con.prepareStatement(sql);
			pre.setString(1, tender.getTenderNum());
			pre.setInt(2, tender.getId());
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

	public String deleteTender(int id) {
		jsonObject = new JSONObject();
		try {
			sql = "update tender set isDeleted = ? where id = ?";
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

	public String getTenderList(Tender tender, String date1, String date2) {
		try {
			sql = "select * from tender where isDeleted = 0 ";
			con = DBConnection.getConnection_Mysql();

			if (tender.getTenderStyle() != 0) {
				sql += "and tenderStyle = " + tender.getTenderStyle() + " ";
			}
			if (tender.getTenderResult() != 0) {
				sql += "and tenderResult = " + tender.getTenderResult() + " ";
			}
			if (!tender.getTenderCompany().equals("")) {
				sql += "and tenderCompany = '" + tender.getTenderCompany() + "' ";
			}
			if (tender.getTenderAgency() != 0) {
				sql += "and tenderAgency = " + tender.getTenderAgency() + " ";
			}
			if (!tender.getProjectId().equals("")) {
				sql += "and projectId = '" + tender.getProjectId() + "' ";
			}
			if (tender.getSaleUser() != 0) {
				sql += "and saleUser = " + tender.getSaleUser() + " ";
			}
			if (!date1.equals("")) {
				sql += "and CAST(dateForSubmit AS date) >= CAST('" + date1 + "' AS date) ";
			}
			if (!date2.equals("")) {
				sql += "and CAST(dateForSubmit AS date) <= CAST('" + date2 + "' AS date) ";
			}
			sql += "order by CAST(dateForSubmit AS datetime) desc";
			// System.out.println(sql);
			pre = con.prepareStatement(sql);
			res = pre.executeQuery();
			tList = new ArrayList<Tender>();
			while (res.next()) {
				Tender mTender = new Tender();
				mTender.setId(res.getInt("id"));
				mTender.setTenderNum(res.getString("tenderNum"));
				mTender.setTenderCompany(res.getString("tenderCompany"));
				mTender.setProjectId(res.getString("projectId"));
				mTender.setDateForSubmit(res.getString("dateForSubmit"));
				mTender.setSaleUser(res.getInt("saleUser"));
				mTender.setTenderResult(res.getInt("tenderResult"));
				mTender.setIsUploadTender(res.getBoolean("isUploadTender"));
				tList.add(mTender);
			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("tenderlist", JSONArray.fromObject(tList));
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

	public String getTenderById(int id) {
		try {
			sql = "select * from tender where id = ?";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setInt(1, id);
			res = pre.executeQuery();
			if (res.next()) {
				Tender tender = new Tender();
				tender.setId(res.getInt("id"));
				tender.setTenderNum(res.getString("tenderNum"));
				tender.setTenderCompany(res.getString("tenderCompany"));
				tender.setTenderAgency(res.getInt("tenderAgency"));
				tender.setProjectId(res.getString("projectId"));
				tender.setSaleUser(res.getInt("saleUser"));
				tender.setDateForBuy(res.getString("dateForBuy"));
				tender.setDateForSubmit(res.getString("dateForSubmit"));
				tender.setDateForOpen(res.getString("dateForOpen"));
				tender.setTenderStyle(res.getInt("tenderStyle"));
				tender.setTenderExpense(res.getInt("tenderExpense"));
				tender.setTenderGuaranteeFee(res.getInt("tenderGuaranteeFee"));
				tender.setTenderResult(res.getInt("tenderResult"));
				tender.setTenderIntent(res.getInt("tenderIntent"));
				tender.setProductStyle(res.getInt("productStyle"));
				tender.setProductBrand(res.getInt("productBrand"));
				tender.setTechnicalRequirment(res.getString("technicalRequirment"));
				tender.setEnterpriseQualificationRequirment(res.getString("enterpriseQualificationRequirment"));
				tender.setRemark(res.getString("remark"));
				tender.setServiceExpense(res.getInt("serviceExpense"));
				jsonObject = new JSONObject();
				jsonObject.put("errcode", "0");
				jsonObject.put("errmsg", "query");
				jsonObject.put("tender", JSONArray.fromObject(tender));
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

	public String getTenderByCompanyId_Sales(int salesId, String companyId) {
		try {
			sql = "select * from tender where saleUser = ? and tenderCompany = ?";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setInt(1, salesId);
			pre.setString(2, companyId);
			res = pre.executeQuery();
			if (res.next()) {
				Tender tender = new Tender();
				tender.setId(res.getInt("id"));
				tender.setTenderNum(res.getString("tenderNum"));
				tender.setTenderCompany(res.getString("tenderCompany"));
				tender.setTenderAgency(res.getInt("tenderAgency"));
				tender.setProjectId(res.getString("projectName"));
				tender.setSaleUser(res.getInt("saleUser"));
				tender.setDateForBuy(res.getString("dateForBuy"));
				tender.setDateForSubmit(res.getString("dateForSubmit"));
				tender.setDateForOpen(res.getString("dateForOpen"));
				tender.setTenderStyle(res.getInt("tenderStyle"));
				tender.setTenderExpense(res.getInt("tenderExpense"));
				tender.setTenderResult(res.getInt("tenderResult"));
				tender.setTenderIntent(res.getInt("tenderIntent"));
				tender.setProductStyle(res.getInt("productStyle"));
				tender.setProductBrand(res.getInt("productBrand"));
				tender.setTechnicalRequirment(res.getString("technicalRequirment"));
				tender.setEnterpriseQualificationRequirment(res.getString("enterpriseQualificationRequirment"));
				tender.setRemark(res.getString("remark"));
				jsonObject = new JSONObject();
				jsonObject.put("errcode", "0");
				jsonObject.put("errmsg", "query");
				jsonObject.put("tender", JSONArray.fromObject(tender));
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

	public String getTenderListUnInputContract() {
		jsonObject = new JSONObject();
		tList = new ArrayList<Tender>();
		tList = getTenderList(1);
		if (tList != null && tList.size() > 0) {
			List<Tender> newList = new ArrayList<Tender>();
			for (int i = 0; i < tList.size(); i++) {
				try {
					sql = "select * from contract where isDeleted = 0 and projectId = ? and companyId = ? and saleUser = ?";
					con = DBConnection.getConnection_Mysql();
					pre = con.prepareStatement(sql);
					pre.setString(1, tList.get(i).getProjectId());
					pre.setString(2, tList.get(i).getTenderCompany());
					pre.setInt(3, tList.get(i).getSaleUser());
					res = pre.executeQuery();
					if (res.next()) {

					} else {
						newList.add(tList.get(i));
					}
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
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("tenderlist", JSONArray.fromObject(newList));
			return jsonObject.toString();
		}
		//没找到中标的
		jsonObject.put("errcode", "1");
		return jsonObject.toString();
	}

	private List<Tender> getTenderList(int tenderResult) {
		try {
			sql = "select * from tender where isDeleted = 0 and tenderResult = 1 order by CAST(dateForSubmit AS datetime) desc";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			res = pre.executeQuery();
			tList = new ArrayList<Tender>();
			while (res.next()) {
				Tender mTender = new Tender();
				mTender.setId(res.getInt("id"));
				mTender.setTenderCompany(res.getString("tenderCompany"));
				mTender.setProjectId(res.getString("projectId"));
				mTender.setSaleUser(res.getInt("saleUser"));
				tList.add(mTender);
			}
			return tList;

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
