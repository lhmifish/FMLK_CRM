package com.fmlk.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import com.fmlk.entity.Contract;
import com.fmlk.util.DBConnection;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public class ContractDao {
	private Connection con, con2, con3 = null;
	private PreparedStatement pre, pre2, pre3 = null;
	private String sql, sql2, sql3 = null;
	private JSONObject jsonObject = null;
	private ResultSet res, res2, res3 = null;
	private List<Contract> ctList = null;
	private List<String> objList = null;

	public String queryContract(Contract contract, String[] paymentInfo) {
		jsonObject = new JSONObject();
		try {
			sql = "select * from contract where companyId = ? and projectId = ?";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, contract.getCompanyId());
			pre.setString(2, contract.getProjectId());
			res = pre.executeQuery();
			if (res.next()) {
				// 找到了
				jsonObject.put("errcode", "3");
				return jsonObject.toString();
			} else {
				return createContract(contract, paymentInfo);
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

	private String createContract(Contract contract, String[] paymentInfo) {
		jsonObject = new JSONObject();
		try {
			sql2 = "insert into contract (contractNum,companyId,saleUser,projectId,dateForContract,"
					+ "contractAmount,taxRate,serviceDetails,createDate) values (?,?,?,?,?,?,?,?,?)";
			con2 = DBConnection.getConnection_Mysql();
			pre2 = con2.prepareStatement(sql2);
			pre2.setString(1, contract.getContractNum());
			pre2.setString(2, contract.getCompanyId());
			pre2.setInt(3, contract.getSaleUser());
			pre2.setString(4, contract.getProjectId());
			pre2.setString(5, contract.getDateForContract());
			pre2.setLong(6, contract.getContractAmount());
			pre2.setString(7, contract.getTaxRate() + "%");
			pre2.setString(8, contract.getServiceDetails());
			pre2.setString(9, contract.getCreateDate());
			int j = pre2.executeUpdate();
			if (j > 0) {
				return createPaymentInfo(contract.getContractNum(), paymentInfo, contract.getCreateDate());
			} else {
				jsonObject.put("errcode", "1");
			}
			return jsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
			jsonObject.put("errcode", "2");
			return jsonObject.toString();
		} finally {
			DBConnection.closeCon(con2);
			DBConnection.closePre(pre2);
		}
	}

	private String createPaymentInfo(String contractNum, String[] paymentInfo, String createDate) {
		jsonObject = new JSONObject();
		String returnStr = "";
		for (int i = 0; i < paymentInfo.length; i++) {
			System.out.println(paymentInfo[i]);
			int type = Integer.parseInt(paymentInfo[i].split("#")[0]);
			String time = paymentInfo[i].split("#")[1];
			String actTime = paymentInfo[i].split("#")[2];
			String desc = paymentInfo[i].split("#")[3];
			Boolean IsFinished = paymentInfo[i].split("#")[4].equals("0") ? false : true;
			try {
				sql3 = "insert into contractpaymentinfo (type,time,actTime,description,contractNum,createDate,isFinished) values (?,?,?,?,?,?,?)";
				con3 = DBConnection.getConnection_Mysql();
				pre3 = con3.prepareStatement(sql3);
				pre3.setInt(1, type);
				pre3.setString(2, time);
				pre3.setString(3, actTime);
				pre3.setString(4, desc);
				pre3.setString(5, contractNum);
				pre3.setString(6, createDate);
				pre3.setBoolean(7, IsFinished);
				int j = pre3.executeUpdate();
				if (j > 0) {
					System.out.println("22222");
					jsonObject.put("errcode", "0");
				} else {
					jsonObject.put("errcode", "1");
				}
				returnStr = jsonObject.toString();
			} catch (Exception e) {
				e.printStackTrace();
				jsonObject.put("errcode", "2");
				returnStr = jsonObject.toString();
			} finally {
				DBConnection.closeCon(con3);
				DBConnection.closePre(pre3);
			}
		}
		return returnStr;
	}

	public String getContractList(Contract contract) {
		try {
			sql = "select * from contract where isDeleted = 0 ";
			con = DBConnection.getConnection_Mysql();
			if (!contract.getContractNum().equals("")) {
				sql += "and contractNum like '%" + contract.getContractNum() + "%' ";
			}
			if (!contract.getCompanyId().equals("")) {
				sql += "and companyId = '" + contract.getCompanyId() + "' ";
			}

			if (!contract.getProjectId().equals("")) {
				sql += "and projectId = '" + contract.getProjectId() + "' ";
			}

			if (contract.getSaleUser() != 0) {
				sql += "and saleUser = " + contract.getSaleUser() + " ";
			}
			String dateForStartContract = "";
			String dateForEndContract = "";
			if (!contract.getDateForContract().equals("none-none")) {
				String dateForContract = contract.getDateForContract();
				dateForStartContract = dateForContract.split("-")[0];
				dateForEndContract = dateForContract.split("-")[1];
				if (!dateForStartContract.equals("none")) {
					sql += "and CAST(SUBSTR(dateForContract,1,10) AS date) >= CAST('" + dateForStartContract
							+ "' AS date) ";
				}
				if (!dateForEndContract.equals("none")) {
					sql += "and CAST(SUBSTR(dateForContract,12,21) AS date) <= CAST('" + dateForEndContract
							+ "' AS date) ";
				}
			}
			sql += "ORDER BY id desc";
			pre = con.prepareStatement(sql);
			res = pre.executeQuery();
			ctList = new ArrayList<Contract>();
			while (res.next()) {
				Contract mContract = new Contract();
				mContract.setId(res.getInt("id"));
				mContract.setContractNum(res.getString("contractNum"));
				mContract.setProjectId(res.getString("projectId"));
				mContract.setCompanyId(res.getString("companyId"));
				mContract.setSaleUser(res.getInt("saleUser"));
				mContract.setDateForContract(res.getString("dateForContract"));
				mContract.setIsUploadContract(res.getBoolean("isUploadContract"));
				ctList.add(mContract);
			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("contractlist", JSONArray.fromObject(ctList));
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

	public String deleteContract(int id) {
		jsonObject = new JSONObject();
		try {
			sql = "update contract set isDeleted = ? where id = ?";
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

	public String getContractById(int id) {
		try {
			sql = "select * from contract where id = ?";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setInt(1, id);
			res = pre.executeQuery();
			if (res.next()) {
				Contract ct = new Contract();
				ct.setId(res.getInt("id"));
				ct.setContractNum(res.getString("contractNum"));
				ct.setProjectId(res.getString("projectId"));
				ct.setCompanyId(res.getString("companyId"));
				ct.setSaleUser(res.getInt("saleUser"));
				ct.setDateForContract(res.getString("dateForContract"));
				ct.setContractAmount(res.getLong("contractAmount"));
				String taxStr = res.getString("taxRate");
				ct.setTaxRate(Integer.parseInt(taxStr.substring(0, taxStr.length() - 1)));
				ct.setServiceDetails(res.getString("serviceDetails"));
				ct.setIsUploadContract(res.getBoolean("isUploadContract"));
				jsonObject = new JSONObject();
				jsonObject.put("errcode", "0");
				jsonObject.put("errmsg", "query");
				jsonObject.put("contract", JSONArray.fromObject(ct));
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

	public String editContract(Contract ct, String[] paymentInfo) {
		jsonObject = new JSONObject();
		try {
			sql = "update contract set ";
			con = DBConnection.getConnection_Mysql();
			if (!ct.getCompanyId().equals("")) {
				sql += "companyId = '" + ct.getCompanyId() + "',";
			}
			if (ct.getSaleUser() != 0) {
				sql += "saleUser = " + ct.getSaleUser() + ",";
			}
			if (!ct.getProjectId().equals("")) {
				sql += "projectId = '" + ct.getProjectId() + "',";
			}

			String dateForContract = ct.getDateForContract();
			String dateForStartContract = dateForContract.split("-")[0];
			String dateForEndContract = dateForContract.split("-")[1];
			if (!dateForStartContract.equals("none") && !dateForEndContract.equals("none")) {
				sql += "dateForContract = '" + ct.getDateForContract() + "',";
			}

			if (ct.getContractAmount() != 0) {
				sql += "contractAmount = " + ct.getContractAmount() + ",";
			}

			if (ct.getTaxRate() != 0) {
				sql += "taxRate = '" + ct.getTaxRate() + "%',";
			}

			if (!ct.getServiceDetails().equals("")) {
				sql += "serviceDetails = '" + ct.getServiceDetails() + "',";
			}

			sql += "isUploadContract = ?,";
			
			sql += "contractNum = ? where id = ?";

            pre = con.prepareStatement(sql);
			pre.setBoolean(1, ct.getIsUploadContract());
			pre.setString(2, ct.getContractNum());
			pre.setInt(3, ct.getId());
			
			int j = pre.executeUpdate();
			if (paymentInfo.length < 2) {
				if (j > 0) {
					System.out.println("111");
					jsonObject.put("errcode", "0");
				} else {
					System.out.println("222");
					jsonObject.put("errcode", "1");
				}
			} else {
				System.out.println("333");
				return deletePaymentInfo(ct, paymentInfo);
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

	public String deletePaymentInfo(Contract ct, String[] paymentInfo) {
		jsonObject = new JSONObject();
		try {
			sql = "delete from contractpaymentinfo where contractNum = ?";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, ct.getContractNum());
			int j = pre.executeUpdate();
			String update = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date());
			return createPaymentInfo(ct.getContractNum(), paymentInfo, update);

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

	public String getContractPaymentInfoList(String contractNum) {
		try {
			sql = "select * from contractpaymentinfo  where contractNum = ? order by type,id";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, contractNum);
			res = pre.executeQuery();
			objList = new ArrayList<String>();
			while (res.next()) {
				String time = res.getString("time");
				String actTime = res.getString("actTime");
				String desc = res.getString("description");
				int type = res.getInt("type");
				String isFinished = res.getBoolean("isFinished") ? "1" : "0";
				objList.add(time + "#" + actTime + "#" + desc + "#" + type + "#" + isFinished);
			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("paymentInfolist", JSONArray.fromObject(objList));
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
