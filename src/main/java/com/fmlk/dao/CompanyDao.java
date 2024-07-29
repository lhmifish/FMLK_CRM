package com.fmlk.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import com.fmlk.entity.Company;
import com.fmlk.entity.ContactUser;
import com.fmlk.util.DBConnection;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public class CompanyDao {
	private Connection con, con2 = null;
	private PreparedStatement pre, pre2 = null;
	private String sql, sql2 = null;
	private JSONObject jsonObject = null;
	private ResultSet res, res2 = null;
	private List<ContactUser> cuList = null;
	private List<Company> cList = null;

	public String createCompany(Company c, String[] arrayContact) {
		jsonObject = new JSONObject();
		String companyName = c.getCompanyName();
		String abbrCompanyName = c.getAbbrCompanyName();
		int fieldId = c.getFieldId();
		int salesId = c.getSalesId();
		String address = c.getAddress();
		int areaId = c.getAreaId();
		String companySource = c.getCompanySource();
		String createDate = c.getCreateDate();
		String companyId = c.getCompanyId();
		boolean isFmlkShare = c.getIsFmlkShare();

		try {
			sql2 = "select * from company where companyName like ? and isDeleted = ? and salesId = ?";
			con2 = DBConnection.getConnection_Mysql();
			pre2 = con2.prepareStatement(sql2);
			pre2.setString(1, "%" + companyName + "%");
			pre2.setBoolean(2, false);
			pre2.setInt(3, salesId);
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
			sql = "insert into company (companyName,fieldId,salesId,address,createDate,abbrCompanyName,areaId,companySource,companyId,isFmlkShare) values (?,?,?,?,?,?,?,?,?,?)";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, companyName);
			pre.setInt(2, fieldId);
			pre.setInt(3, salesId);
			pre.setString(4, address);
			pre.setString(5, createDate);
			pre.setString(6, abbrCompanyName);
			pre.setInt(7, areaId);
			pre.setString(8, companySource);
			pre.setString(9, companyId);
			pre.setBoolean(10, isFmlkShare);
			int j = pre.executeUpdate();
			if (j > 0) {
				jsonObject.put("errcode", "0");
				cuList = new ArrayList<ContactUser>();
				for (int i = 0; i < arrayContact.length; i++) {
					ContactUser cu = new ContactUser();
					cu.setCompanyId(companyId);
					cu.setUserName(arrayContact[i].split("#")[0]);
					cu.setTel(arrayContact[i].split("#")[1]);
					cu.setEmail(arrayContact[i].split("#")[2]);
					cu.setDepartment(arrayContact[i].split("#")[3]);
					cu.setPosition(arrayContact[i].split("#")[4]);
					cu.setCreateDate(createDate);
					cuList.add(cu);
				}
				UserDao ud = new UserDao();
				ud.createContactUser(cuList);
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

	public String editCompany(Company c, String[] arrayContact) {
		jsonObject = new JSONObject();
		try {
			sql = "update company set companyName = ?,abbrCompanyName = ?,fieldId = ? ,salesId = ?,address = ?,areaId = ?,companySource = ? where id = ?";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, c.getCompanyName());
			pre.setString(2, c.getAbbrCompanyName());
			pre.setInt(3, c.getFieldId());
			pre.setInt(4, c.getSalesId());
			pre.setString(5, c.getAddress());
			pre.setInt(6, c.getAreaId());
			pre.setString(7, c.getCompanySource());
			pre.setInt(8, c.getId());
			int j = pre.executeUpdate();
			// deletecuList 数据库中有，但arrayContact中没有
			// updatecuList 数据库和arrayContact中都有
			// newcuList数据库中没有，但arrayContact中有
			// 获取数据库cuList
			UserDao ud = new UserDao();
			String userListJson = ud.getUserContactList(c.getCompanyId());
		    JSONArray arrayList = new JSONObject().fromObject(userListJson).getJSONArray("contactUserList");
			List<ContactUser> cuList = new ArrayList<ContactUser>();
			cuList = (List<ContactUser>) JSONArray.toCollection(arrayList, ContactUser.class);
			List<ContactUser> deletecuList = new ArrayList<ContactUser>();
			List<ContactUser> updatecuList = new ArrayList<ContactUser>();
			List<ContactUser> newcuList = new ArrayList<ContactUser>();
		    deletecuList = ud.checkNonExistContactUser(c.getCompanyId(), arrayContact, cuList);
			updatecuList = ud.checkExistContactUser(c.getCompanyId(), arrayContact, cuList);
			newcuList = ud.checkNonExistContactUser2(c.getCompanyId(), arrayContact, cuList);
			if (j >= 0) {
				jsonObject.put("errcode", "0");
				ud.deleteContactUser(deletecuList);
				ud.updateContactUser(updatecuList);
				ud.createContactUser(newcuList);
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

	public String deleteCompany(int id) {
		jsonObject = new JSONObject();
		try {
			sql = "update company set isDeleted = ? where id = ?";
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

	public String getCompanyList(int salesId, String companyName) {
		try {
			sql = "select * from company where isDeleted = 0";
			if (salesId != 0 || !companyName.equals("")) {

				if (salesId != 0) {
					sql += " and salesId = " + salesId;
				}
				if (!companyName.equals("")) {
					sql += " and companyName like '%" + companyName + "%'";
				}
			}
			sql += " order by companyName";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			res = pre.executeQuery();
			cList = new ArrayList<Company>();
			while (res.next()) {
				Company company = new Company();
				company.setCompanyId(res.getString("companyId"));
				company.setId(res.getInt("id"));
				company.setCompanyName(res.getString("companyName"));
				company.setFieldId(res.getInt("fieldId"));
				company.setAreaId(res.getInt("areaId"));
				company.setSalesId(res.getInt("salesId"));
				company.setCompanySource(res.getString("companySource"));
				company.setAddress(res.getString("address"));
				company.setAbbrCompanyName(res.getString("abbrCompanyName"));
				cList.add(company);
			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("companylist", JSONArray.fromObject(cList));
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

	public String getCompanyByCompanyId(String companyId) {
		try {
			sql = "select * from company where companyId = ?";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, companyId);
			res = pre.executeQuery();
			if (res.next()) {
				Company c = new Company();
				c.setId(res.getInt("id"));
				c.setCompanyName(res.getString("companyName"));
				c.setCompanyId(res.getString("companyId"));
				c.setAbbrCompanyName(res.getString("abbrCompanyName"));
				c.setSalesId(res.getInt("salesId"));
				c.setFieldId(res.getInt("fieldId"));
				c.setAreaId(res.getInt("areaId"));
				c.setAddress(res.getString("address"));
				c.setCompanySource(res.getString("companySource"));
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

	public String getCompanyById(int id) {
		try {
			sql = "select * from company where id = ?";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setInt(1, id);
			res = pre.executeQuery();
			if (res.next()) {
				Company c = new Company();
				c.setId(res.getInt("id"));
				c.setCompanyName(res.getString("companyName"));
				c.setCompanyId(res.getString("companyId"));
				c.setAbbrCompanyName(res.getString("abbrCompanyName"));
				c.setSalesId(res.getInt("salesId"));
				c.setFieldId(res.getInt("fieldId"));
				c.setAreaId(res.getInt("areaId"));
				c.setAddress(res.getString("address"));
				c.setCompanySource(res.getString("companySource"));
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

	public String getCompanyByProjectId(String projectId) {
		try {
			sql = "select a.companyName,a.companyId from company a,project b where a.companyId = b.companyId and b.projectId = ?";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, projectId);
			res = pre.executeQuery();
			if (res.next()) {
				Company c = new Company();
				c.setCompanyName(res.getString("companyName"));
				c.setCompanyId(res.getString("companyId"));
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
}
