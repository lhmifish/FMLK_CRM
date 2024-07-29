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
		int salesId = c.getSalesId();
		int fieldId = c.getFieldId();
		int fieldLevel = c.getFieldLevel();
		String hospitalDataInfo = c.getHospitalDataInfo();
		String address = c.getAddress();
		int areaId = c.getAreaId();
		String companySource = c.getCompanySource();
		String createDate = c.getCreateDate();
		String companyId = c.getCompanyId();
		boolean isFmlkShare = c.getIsFmlkShare();
		try {
			sql2 = "select * from company where companyName like ? and isDeleted = ? and isFmlkShare = ?";
			con2 = DBConnection.getConnection_Mysql();
			pre2 = con2.prepareStatement(sql2);
			pre2.setString(1, "%" + companyName + "%");
			pre2.setBoolean(2, false);
			pre2.setBoolean(3, isFmlkShare);
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
			sql = "insert into company (companyName,fieldId,salesId,address,createDate,abbrCompanyName,areaId,companySource,companyId,isFmlkShare,updateDate,fieldLevel,hospitalDataInfo) values (?,?,?,?,?,?,?,?,?,?,?,?,?)";
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
			pre.setString(11, createDate);
			pre.setInt(12, fieldLevel);
			pre.setString(13, hospitalDataInfo);
			
			int j = pre.executeUpdate();
			if (j > 0) {
				if(arrayContact != null && arrayContact.length>0){
					cuList = new ArrayList<ContactUser>();
					for (int i = 0; i < arrayContact.length; i++) {
						ContactUser cu = new ContactUser();
						cu.setCompanyId(companyId);
						cu.setUserName(arrayContact[i].split("#")[0]);
						String tel = arrayContact[i].split("#")[1].equals("null")?"":arrayContact[i].split("#")[1];
						String email = arrayContact[i].split("#")[2].equals("null")?"":arrayContact[i].split("#")[2];
						String department = arrayContact[i].split("#")[3].equals("null")?"":arrayContact[i].split("#")[3];
						String position = arrayContact[i].split("#")[4].equals("null")?"":arrayContact[i].split("#")[4];
						String wechatNo = arrayContact[i].split("#")[5].equals("null")?"":arrayContact[i].split("#")[5];
						cu.setTel(tel);
						cu.setEmail(email);
						cu.setDepartment(department);
						cu.setPosition(position);
						cu.setCreateDate(createDate);
						cu.setUpdateDate(createDate);
						cu.setWechatNo(wechatNo);
						cuList.add(cu);
					}
					UserDao ud = new UserDao();
					String ret = ud.createContactUser(cuList);
					jsonObject.put("errcode", ret);
				}else {
					jsonObject.put("errcode", "0");
				}
				return jsonObject.toString();
			} else {
				jsonObject.put("errcode", "1");
				return jsonObject.toString();
			}
		} catch (Exception e) {
			e.printStackTrace();
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "4");
			return jsonObject.toString();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
		}
	}

	public String editCompany(Company c, String[] arrayContact) {
		jsonObject = new JSONObject();
		try {
			sql = "update company set companyName = ?,abbrCompanyName = ?,fieldId = ? ,salesId = ?,address = ?,areaId = ?,companySource = ?,updateDate=?,fieldLevel=?,hospitalDataInfo=? where id = ?";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, c.getCompanyName());
			pre.setString(2, c.getAbbrCompanyName());
			pre.setInt(3, c.getFieldId());
			pre.setInt(4, c.getSalesId());
			pre.setString(5, c.getAddress());
			pre.setInt(6, c.getAreaId());
			pre.setString(7, c.getCompanySource());
			pre.setString(8, c.getUpdateDate());
			pre.setInt(9, c.getFieldLevel());
			pre.setString(10, c.getHospitalDataInfo());
			pre.setInt(11, c.getId());
			int j = pre.executeUpdate();
			// updatecuList 数据库和arrayContact中都有
			// newcuList数据库中没有，但arrayContact中有
			// 获取数据库cuList
			UserDao ud = new UserDao();
			List<ContactUser> updatecuList = new ArrayList<ContactUser>();
			List<ContactUser> newcuList = new ArrayList<ContactUser>();
			updatecuList = ud.checkExistContactUser(c.getCompanyId(), arrayContact);
			newcuList = ud.checkNonExistContactUser(c.getCompanyId(), arrayContact);
			if (j >= 0) {
				jsonObject.put("errcode", "0");
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

	public String deleteCompany(int id,String updateDate) {
		jsonObject = new JSONObject();
		try {
			sql = "update company set isDeleted = ?,updateDate = ? where id = ?";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setBoolean(1, true);
			pre.setString(2, updateDate);
			pre.setInt(3, id);
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

	public String getCompanyList(int salesId, String companyName,boolean isFmlkShare) {
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
			sql += " and isFmlkShare = ?";
			sql += " order by companyName";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setBoolean(1, isFmlkShare);
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
				c.setIsFmlkShare(res.getBoolean("isFmlkShare"));
				c.setFieldLevel(res.getInt("fieldLevel"));
				c.setHospitalDataInfo(res.getString("hospitalDataInfo"));
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
				c.setIsFmlkShare(res.getBoolean("isFmlkShare"));
				c.setFieldLevel(res.getInt("fieldLevel"));
				c.setHospitalDataInfo(res.getString("hospitalDataInfo"));
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
