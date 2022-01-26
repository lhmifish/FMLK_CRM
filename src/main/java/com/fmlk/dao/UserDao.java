package com.fmlk.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import com.fmlk.entity.ContactUser;
import com.fmlk.entity.User;
import com.fmlk.util.DBConnection;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public class UserDao {

	private Connection con, con2 = null;
	private PreparedStatement pre, pre2 = null;
	private String sql, sql2 = null;
	private JSONObject jsonObject = null;
	private ResultSet res, res2 = null;
	private List<User> uList = null;
	private List<ContactUser> cuList = null;

	public String getUserList(User user, String date, boolean isHide) {
		try {
			if (!date.equals("")) {
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
				Date inputDate = sdf.parse(date);
				Date dateTemp = sdf.parse("2021/11/1");
				int compareTo = inputDate.compareTo(dateTemp);
				if (compareTo >= 0) {
					con = DBConnection.getConnection_Mysql();
				} else {
					con = DBConnection.getConnection_Mysql2();
				}
			}else {
				con = DBConnection.getConnection_Mysql();
			}
			int dpartId = user.getDepartmentId();
			String name = user.getName();
			String nickName = user.getNickName();
			String jobId = user.getJobId();
			sql = "select * from user where isDeleted = 0";
			if (dpartId == 99) {// 除领导以外
				sql += " and departmentId != 5 and departmentId != 6";
			} else if (dpartId == 100) {// 技术和销售
				sql += " and departmentId = 1 or departmentId = 2";
			} else if (dpartId == 101) {// 技术和销售和开发
				sql += " and departmentId = 1 or departmentId = 2 or departmentId = 4";
			} else if (dpartId == 102) {
				sql += " and departmentId = 1 or departmentId = 4 or departmentId = 7";
			} else if (dpartId != 0) {
				sql += " and departmentId = " + dpartId;
			}

			if (!name.equals("")) {
				sql += " and name like '%" + name + "%'";
			}

			if (!nickName.equals("")) {
				sql += " and nickName like '%" + nickName + "%'";
			}

			if (!jobId.equals("")) {
				sql += " and jobId = '" + jobId + "'";
			}
			sql += " order by departmentId,id";
		//	con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			res = pre.executeQuery();
			uList = new ArrayList<User>();
			while (res.next()) {
				User user2 = new User();
				user2.setUId(res.getInt("id"));
				user2.setName(res.getString("name"));
				user2.setNickName(res.getString("nickName"));
				user2.setDepartmentId(res.getInt("departmentId"));
				user2.setJobId(res.getString("jobId"));
				user2.setState(res.getString("state"));
				user2.setRoleId(res.getInt("roleId"));
				String userState = res.getString("state");
				DateFormat df = new SimpleDateFormat("yyyy/MM/dd");
				if (!isHide) {
					// 显示
					uList.add(user2);
				} else {
					// 不显示
					boolean IsDimission = userState.contains("离职");
					if (date.equals("")) {
						if (!IsDimission) {
							uList.add(user2);
						}
					} else {
						if (IsDimission) {
							String dimDate = userState.split("-")[1] + "/1";
							Date dt1 = df.parse(date);// 查看日期
							Date dt2 = df.parse(dimDate);// 离职日期
							if (dt1.getTime() < dt2.getTime()) {
								uList.add(user2);
							}
						} else {
							uList.add(user2);
						}
					}
				}
			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("userlist", JSONArray.fromObject(uList));
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

	public String getUserById(int uId) {
		try {
			sql = "select * from user where id = ?";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setInt(1, uId);
			res = pre.executeQuery();
			if (res.next()) {
				User user = new User();
				user.setUId(res.getInt("id"));
				user.setName(res.getString("name"));
				user.setNickName(res.getString("nickName"));
				user.setState(res.getString("state"));
				user.setDepartmentId(res.getInt("departmentId"));
				user.setJobId(res.getString("jobId"));
				user.setEmail(res.getString("email"));
				user.setTel(res.getString("tel"));
				user.setRoleId(res.getInt("roleId"));
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

	public String getUserByUserName(String uName) {
		try {
			sql = "select * from user where name = ?";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, uName);
			res = pre.executeQuery();
			if (res.next()) {
				User user = new User();
				user.setName(res.getString("name"));
				user.setNickName(res.getString("nickName"));
				user.setState(res.getString("state"));
				user.setDepartmentId(res.getInt("departmentId"));
				user.setUId(res.getInt("id"));
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

	public String getUserContactList(String companyId) {
		try {
			sql = "select * from contactuser where companyId = ? and isDeleted = 0 ORDER BY id";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, companyId);
			res = pre.executeQuery();
			cuList = new ArrayList<ContactUser>();
			while (res.next()) {
				ContactUser cu = new ContactUser();
				cu.setId(res.getInt("id"));
				cu.setCompanyId(res.getString("companyId"));
				cu.setDepartment(res.getString("department"));
				cu.setPosition(res.getString("position"));
				cu.setTel(res.getString("tel"));
				cu.setEmail(res.getString("email"));
				cu.setUserName(res.getString("userName"));
				cuList.add(cu);
			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("contactUserList", JSONArray.fromObject(cuList));
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

	// cuList数据库中有，但arrayContact中没有
	public List<ContactUser> checkNonExistContactUser(String companyId, String[] arrayContact,
			List<ContactUser> cuList) {
		List<ContactUser> newList = new ArrayList<ContactUser>();
		for (int i = 0; i < cuList.size(); i++) {
			boolean isFind = false;
			String userName = cuList.get(i).getUserName();
			for (int j = 0; j < arrayContact.length; j++) {
				if (arrayContact[j].split("#")[0].equals(userName)) {
					isFind = true;
					break;
				}
			}
			if (!isFind) {
				newList.add(cuList.get(i));
			}
		}
		return newList;
	}

	// 数据库和arrayContact中都有
	public List<ContactUser> checkExistContactUser(String companyId, String[] arrayContact, List<ContactUser> cuList) {
		List<ContactUser> newList = new ArrayList<ContactUser>();
		for (int i = 0; i < cuList.size(); i++) {
			boolean isFind = false;
			int id = 0;
			String tel = null;
			String email = null;
			String dept = null;
			String position = null;
			String userName = cuList.get(i).getUserName();
			for (int j = 0; j < arrayContact.length; j++) {
				if (arrayContact[j].split("#")[0].equals(userName)) {
					id = cuList.get(i).getId();
					tel = arrayContact[j].split("#")[1];
					email = arrayContact[j].split("#")[2];
					dept = arrayContact[j].split("#")[3];
					position = arrayContact[j].split("#")[4];
					isFind = true;
					break;
				}
			}
			if (isFind) {
				ContactUser cu = new ContactUser();
				cu.setId(id);
				cu.setTel(tel);
				cu.setEmail(email);
				cu.setDepartment(dept);
				cu.setPosition(position);
				newList.add(cu);
			}
		}
		return newList;
	}

	// 数据库中没有，但arrayContact中有
	public List<ContactUser> checkNonExistContactUser2(String companyId, String[] arrayContact,
			List<ContactUser> cuList) {
		List<ContactUser> newList = new ArrayList<ContactUser>();
		for (int i = 0; i < arrayContact.length; i++) {
			boolean isFind = false;
			String userName = arrayContact[i].split("#")[0];
			for (int j = 0; j < cuList.size(); j++) {
				if (userName.equals(cuList.get(j).getUserName())) {
					isFind = true;
					break;
				}
			}
			if (!isFind) {
				ContactUser cu = new ContactUser();
				cu.setCompanyId(companyId);
				cu.setUserName(arrayContact[i].split("#")[0]);
				cu.setTel(arrayContact[i].split("#")[1]);
				cu.setEmail(arrayContact[i].split("#")[2]);
				cu.setDepartment(arrayContact[i].split("#")[3]);
				cu.setPosition(arrayContact[i].split("#")[4]);
				cu.setCreateDate(new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date()));
				newList.add(cu);
			}
		}
		return newList;
	}

	public void createContactUser(List<ContactUser> contactUserList) {
		for (int i = 0; i < contactUserList.size(); i++) {
			try {
				sql = "insert into contactuser (companyId,userName,tel,email,department,position,createDate) values (?,?,?,?,?,?,?)";
				con = DBConnection.getConnection_Mysql();
				pre = con.prepareStatement(sql);
				pre.setString(1, contactUserList.get(i).getCompanyId());
				pre.setString(2, contactUserList.get(i).getUserName());
				pre.setString(3, contactUserList.get(i).getTel());
				pre.setString(4, contactUserList.get(i).getEmail());
				pre.setString(5, contactUserList.get(i).getDepartment());
				pre.setString(6, contactUserList.get(i).getPosition());
				pre.setString(7, contactUserList.get(i).getCreateDate());
				pre.executeUpdate();
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBConnection.closeCon(con);
				DBConnection.closePre(pre);
			}
		}
	}

	public void deleteContactUser(List<ContactUser> deletecuList) {
		for (int i = 0; i < deletecuList.size(); i++) {
			try {
				sql = "update contactuser set isDeleted = ? where id = ?";
				con = DBConnection.getConnection_Mysql();
				pre = con.prepareStatement(sql);
				pre.setBoolean(1, true);
				pre.setInt(2, deletecuList.get(i).getId());
				pre.executeUpdate();
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBConnection.closeCon(con);
				DBConnection.closePre(pre);
			}
		}
	}

	public void updateContactUser(List<ContactUser> updatecuList) {
		for (int i = 0; i < updatecuList.size(); i++) {
			try {
				sql = "update contactuser set tel = ?,email = ?,department = ?,position = ? where id = ? and isDeleted = 0";
				con = DBConnection.getConnection_Mysql();
				pre = con.prepareStatement(sql);
				pre.setString(1, updatecuList.get(i).getTel());
				pre.setString(2, updatecuList.get(i).getEmail());
				pre.setString(3, updatecuList.get(i).getDepartment());
				pre.setString(4, updatecuList.get(i).getPosition());
				pre.setInt(5, updatecuList.get(i).getId());
				int j = pre.executeUpdate();
				if (j > 0) {
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBConnection.closeCon(con);
				DBConnection.closePre(pre);
			}
		}
	}

	public String getUserByNickName(String nickName) {
		try {
			sql = "select * from user where nickName = ?";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, nickName);
			res = pre.executeQuery();
			if (res.next()) {
				User user = new User();
				user.setName(res.getString("name"));
				user.setNickName(res.getString("nickName"));
				user.setState(res.getString("state"));
				user.setDepartmentId(res.getInt("departmentId"));
				user.setUId(res.getInt("id"));
				user.setRoleId(res.getInt("roleId"));
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

	public String createUser(User user) {
		jsonObject = new JSONObject();
		try {
			sql2 = "select * from user where nickName = ? or jobId = ?";
			con2 = DBConnection.getConnection_Mysql();
			pre2 = con2.prepareStatement(sql2);
			pre2.setString(1, user.getNickName());
			pre2.setString(2, user.getJobId());
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
			sql = "insert into user (name,nickName,psd,jobId,email,departmentId,tel,createDate) values (?,?,?,?,?,?,?,?)";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, user.getName());
			pre.setString(2, user.getNickName());
			pre.setString(3, user.getPassword());
			pre.setString(4, user.getJobId());
			pre.setString(5, user.getEmail());
			pre.setInt(6, user.getDepartmentId());
			pre.setString(7, user.getTel());
			pre.setString(8, user.getCreateDate());
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

	public String editUser(User user) {
		jsonObject = new JSONObject();
		String userName = user.getName();
		String psd = user.getPassword();
		String email = user.getEmail();
		String tel = user.getTel();
		String state = user.getState();
		int departmentId = user.getDepartmentId();
		int roleId = user.getRoleId();
		String nickName = user.getNickName();
		try {
			sql = "update user set ";
			con = DBConnection.getConnection_Mysql();
			if (userName != null) {
				if (!userName.equals("")) {
					sql += "name = '" + userName + "',";
				}
			}
			if (psd != null) {
				if (!psd.equals("")) {
					sql += "psd = '" + psd + "',";
				}
			}
			if (email != null) {
				if (!email.equals("")) {
					sql += "email = '" + email + "',";
				}
			}

			if (tel != null) {
				if (!tel.equals("")) {
					sql += "tel = '" + tel + "',";
				}
			}

			if (state != null) {
				if (!state.equals("")) {
					sql += "state = '" + state + "',";
				}
			}

			if (departmentId != 0) {
				sql += "departmentId = " + departmentId + ",";
			}

			if (roleId != -1) {
				sql += "roleId = " + roleId + ",";
			}

			if (nickName != null) {
				if (!nickName.equals("")) {
					sql += "nickName = '" + nickName + "'";
				}
			}
			sql += " where id = ?";
			pre = con.prepareStatement(sql);
			pre.setInt(1, user.getUId());
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

	public int queryUser(User user) {
		try {
			sql = "select * from user where nickName = ? and psd = ? and isDeleted = 0 and state = ?";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, user.getNickName());
			pre.setString(2, user.getPassword());
			pre.setString(3, "在职");
			res = pre.executeQuery();
			if (res.next()) {
				return 0;
			} else {
				return 2;
			}

		} catch (Exception e) {
			e.printStackTrace();
			return 3;
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
			DBConnection.closeRes(res);
		}
	}

	public List<User> getUserList(String userIdStr) {
		uList = new ArrayList<User>();
		for (int i = 0; i < userIdStr.split(",").length; i++) {
			String mJsonStr = getUserById(Integer.parseInt(userIdStr.split(",")[i]));
			JSONArray jsonArray = new JSONObject().fromObject(mJsonStr).getJSONArray("user");
			User user = ((List<User>) JSONArray.toCollection(jsonArray, User.class)).get(0);
			uList.add(user);
		}
		// System.out.println(uList.size());
		return uList;
	}

}
