package com.fmlk.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import com.fmlk.entity.CaseType;
import com.fmlk.entity.Project;
import com.fmlk.entity.ProjectCase;
import com.fmlk.entity.ProjectReport;
import com.fmlk.entity.ProjectSubState;
import com.fmlk.util.DBConnection;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public class ProjectDao {

	private Connection con, con2 = null;
	private PreparedStatement pre, pre2 = null;
	private String sql, sql2 = null;
	private JSONObject jsonObject = null;
	private ResultSet res, res2 = null;
	private List<Project> pList = null;
	private List<ProjectReport> prList = null;
	private List<ProjectCase> pcList = null;
	private List<ProjectSubState> pssList = null;

	public String createProject(Project p) {
		jsonObject = new JSONObject();
		String projectId = p.getProjectId();
		String projectName = p.getProjectName();
		String companyId = p.getCompanyId();
		String contactUsers = p.getContactUsers();
		int salesId = p.getSalesId();
		int projectType = p.getProjectType();
		int projectManager = p.getProjectManager();
		String createDate = p.getCreateDate();
		String salesBeforeUsers  = p.getSalesBeforeUsers().trim();
		String salesAfterUsers  = p.getSalesAfterUsers().trim();

		try {
			sql2 = "select * from project where projectName like ? and isDeleted = ? and salesId = ? and companyId = ?";
			con2 = DBConnection.getConnection_Mysql();
			pre2 = con2.prepareStatement(sql2);
			pre2.setString(1, "%" + projectName + "%");
			pre2.setBoolean(2, false);
			pre2.setInt(3, salesId);
			pre2.setString(4, companyId);
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
			sql = "insert into project (projectName,projectId,companyId,salesId,createDate,contactUsers,projectType,projectManager,salesBeforeUsers,salesAfterUsers) values (?,?,?,?,?,?,?,?,?,?)";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, projectName);
			pre.setString(2, projectId);
			pre.setString(3, companyId);
			pre.setInt(4, salesId);
			pre.setString(5, createDate);
			pre.setString(6, contactUsers);
			pre.setInt(7, projectType);
			pre.setInt(8, projectManager);
			pre.setString(9, salesBeforeUsers);
			pre.setString(10, salesAfterUsers);
			
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

	public String getProjectList(Project mProject) {
		String companyId = mProject.getCompanyId();
		String projectName = mProject.getProjectName();
		int salesId = mProject.getSalesId();
		int projectManager = mProject.getProjectManager();

		try {
			sql = "select * from project where isDeleted = 0";
			if (salesId != 0 || !companyId.equals("") || projectManager != 0 || !projectName.equals("")) {

				if (salesId != 0) {
					sql += " and salesId = " + salesId;
				}
				if (!companyId.equals("")) {
					sql += " and companyId = '" + companyId + "'";
				}
				if (salesId != 0) {
					sql += " and projectManager = " + projectManager;
				}
				if (!projectName.equals("")) {
					sql += " and projectName like '%" + projectName + "%'";
				}
			}
			sql += " order by CAST(createDate AS datetime) desc";
			// System.out.println(sql);
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			res = pre.executeQuery();
			pList = new ArrayList<Project>();
			while (res.next()) {
				Project p = new Project();
				p.setId(res.getInt("id"));
				p.setProjectId(res.getString("projectId"));
				p.setProjectType(res.getInt("projectType"));
				p.setCompanyId(res.getString("companyId"));
				p.setSalesId(res.getInt("salesId"));
				p.setProjectName(res.getString("projectName"));
				p.setProjectManager(res.getInt("projectManager"));
				p.setContactUsers(res.getString("contactUsers"));
				p.setProjectState(res.getInt("projectState"));
				p.setProjectFailedReason(res.getString("projectFailedReason"));
				p.setProjectSubState(res.getInt("projectSubState"));
				p.setCreateDate(res.getString("createDate"));
				pList.add(p);
			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("projectList", JSONArray.fromObject(pList));
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

	public String getProjectByProjectId(String projectId) {
		try {
			sql = "select * from project where projectId = ?";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, projectId);
			res = pre.executeQuery();
			if (res.next()) {
				Project p = new Project();
				p.setId(res.getInt("id"));
				p.setProjectId(res.getString("projectId"));
				p.setProjectType(res.getInt("projectType"));
				p.setCompanyId(res.getString("companyId"));
				p.setSalesId(res.getInt("salesId"));
				p.setProjectName(res.getString("projectName"));
				p.setProjectManager(res.getInt("projectManager"));
				p.setContactUsers(res.getString("contactUsers"));
				p.setProjectState(res.getInt("projectState"));
				p.setSalesBeforeUsers(res.getString("salesBeforeUsers"));
				p.setSalesAfterUsers(res.getString("salesAfterUsers"));
				jsonObject = new JSONObject();
				jsonObject.put("errcode", "0");
				jsonObject.put("errmsg", "query");
				jsonObject.put("project", JSONArray.fromObject(p));
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

	public String deleteProject(int id) {
		jsonObject = new JSONObject();
		try {
			sql = "update project set isDeleted = ? where id = ?";
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

	public String getProject(int id) {
		try {
			sql = "select * from project where id = ?";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setInt(1, id);
			res = pre.executeQuery();
			if (res.next()) {
				Project project = new Project();
				project.setId(res.getInt("id"));
				project.setSalesId(res.getInt("salesId"));
				project.setProjectId(res.getString("projectId"));
				project.setProjectType(res.getInt("projectType"));
				project.setCompanyId(res.getString("companyId"));
				project.setProjectName(res.getString("projectName"));
				project.setProjectManager(res.getInt("projectManager"));
				project.setContactUsers(res.getString("contactUsers"));
				project.setProjectState(res.getInt("projectState"));
				project.setCreateDate(res.getString("createDate"));
				project.setSalesBeforeUsers(res.getString("salesBeforeUsers"));
				project.setSalesAfterUsers(res.getString("salesAfterUsers"));
				jsonObject = new JSONObject();
				jsonObject.put("errcode", "0");
				jsonObject.put("errmsg", "query");
				jsonObject.put("project", JSONArray.fromObject(project));
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

	public String createProjectReport(ProjectReport pr) {
		jsonObject = new JSONObject();
		try {
			sql = "insert into projectreport (projectId,contactDate,reportDesc,userId,reportType,fileName,createDate,caseId) values (?,?,?,?,?,?,?,?)";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, pr.getProjectId());
			pre.setString(2, pr.getContactDate());
			pre.setString(3, pr.getReportDesc());
			pre.setInt(4, pr.getUserId());
			pre.setInt(5, pr.getReportType());
			pre.setString(6, pr.getFileName());
			pre.setString(7, pr.getCreateDate());
			pre.setString(8, pr.getCaseId());
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

	public String getProjectReportList(String projectId) {
		try {
			sql = "select * from projectreport where isDeleted = 0 and projectId = ? order by CAST(contactDate AS datetime) desc,id desc";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, projectId);
			res = pre.executeQuery();
			prList = new ArrayList<ProjectReport>();
			while (res.next()) {
				ProjectReport pr = new ProjectReport();
				pr.setId(res.getInt("id"));
				pr.setProjectId(res.getString("projectId"));
				pr.setContactDate(res.getString("contactDate"));
				pr.setFileName(res.getString("fileName"));
				pr.setUserId(res.getInt("userId"));
				pr.setReportDesc(res.getString("reportDesc"));
				pr.setCreateDate(res.getString("createDate"));
				pr.setReportType(res.getInt("reportType"));
				pr.setCaseId(res.getString("caseId"));
				prList.add(pr);
			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("prList", JSONArray.fromObject(prList));
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

	public String editProject(Project project) {
		jsonObject = new JSONObject();
		try {
			sql = "update project set ";
			con = DBConnection.getConnection_Mysql();
			if (!project.getProjectName().equals("")) {
				sql += "projectName = '" + project.getProjectName() + "',";
			}
			if (project.getProjectType() != 0) {
				sql += "projectType = " + project.getProjectType() + ",";
			}
			if (project.getProjectManager() != 0) {
				sql += "projectManager = " + project.getProjectManager() + ",";
			}
			if (!project.getProjectFailedReason().equals("")) {
				sql += "projectFailedReason = '" + project.getProjectFailedReason() + "',";
			}
			if (!project.getContactUsers().equals("")) {
				sql += "contactUsers = '" + project.getContactUsers() + "',";
			}
			if (!project.getSalesBeforeUsers().equals("")) {
				sql += "salesBeforeUsers = '" + project.getSalesBeforeUsers() + "',";
			}
			if (!project.getSalesAfterUsers().equals("")) {
				sql += "salesAfterUsers = '" + project.getSalesAfterUsers() + "',";
			}
			if(project.getProjectSubState() != 99) {
				sql += "projectSubState = " + project.getProjectSubState() + ",";
			}
			sql += "projectState = ? where id = ?";
			System.out.println(sql);
			pre = con.prepareStatement(sql);
			pre.setInt(1, project.getProjectState());
			pre.setInt(2, project.getId());
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

	public String createProjectCase(ProjectCase pc) {
		jsonObject = new JSONObject();
		String caseId = pc.getCaseId();
		String projectId = pc.getProjectId();
		int salesId = pc.getSalesId();
		String contactUsers = pc.getContactUsers();
		String serviceDate = pc.getServiceDate();
		String caseType = pc.getCaseType();
		int serviceType = pc.getServiceType();
		String serviceContent = pc.getServiceContent();
		String deviceInfo = pc.getDeviceInfo();
		String createDate = pc.getCreateDate();
		String casePeriod = pc.getCasePeriod();
		String serviceEndDate = pc.getServiceEndDate();
		try {
			sql = "insert into projectcase (caseId,projectId,salesId,contactUsers,serviceDate,caseType,serviceType,"
					+ "serviceContent,deviceInfo,createDate,casePeriod,serviceEndDate) values (?,?,?,?,?,?,?,?,?,?,?,?)";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, caseId);
			pre.setString(2, projectId);
			pre.setInt(3, salesId);
			pre.setString(4, contactUsers);
			pre.setString(5, serviceDate);
			pre.setString(6, caseType);
			pre.setInt(7, serviceType);
			pre.setString(8, serviceContent);
			pre.setString(9, deviceInfo);
			pre.setString(10, createDate);
			pre.setString(11, casePeriod);
			pre.setString(12, serviceEndDate);
			int j = pre.executeUpdate();
			if (j > 0) {
				jsonObject.put("errcode", "0");
				jsonObject.put("caseId", caseId);
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

	public String getProjectCaseList(ProjectCase pc, String companyId, String projectName) {
		String tServiceUsers = pc.getServiceUsers();
		try {
			sql = "select projectId from project where isDeleted = 0";
			if (!companyId.equals("")) {
				sql += " and companyId = '" + companyId + "'";
			}

			if (!projectName.equals("")) {
				sql += " and projectName like '%" + projectName + "%'";
			}

			sql2 = "select * from projectcase where isDeleted = 0";

			if (pc.getSalesId() != 0) {
				sql2 += " and salesId = " + pc.getSalesId();
			}
			sql2 += " and projectId in (" + sql + ") order by CAST(serviceDate AS datetime) desc,id desc";
			// System.out.println(sql2);
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql2);
			res = pre.executeQuery();
			pcList = new ArrayList<ProjectCase>();
			while (res.next()) {
				String serviceUsers = res.getString("serviceUsers");
				ProjectCase pc2 = new ProjectCase();
				pc2.setId(res.getInt("id"));
				pc2.setCaseId(res.getString("caseId"));
				pc2.setProjectId(res.getString("projectId"));
				pc2.setSalesId(res.getInt("salesId"));
				pc2.setServiceUsers(serviceUsers);
				pc2.setServiceDate(res.getString("serviceDate"));
				pc2.setCaseType(res.getString("caseType"));
				pc2.setServiceType(res.getInt("serviceType"));
				pc2.setCreateDate(res.getString("createDate"));
				pc2.setIsChecked(res.getBoolean("isChecked"));
				pc2.setIsRejected(res.getBoolean("isRejected"));
				pc2.setCaseState(res.getInt("caseState"));
				if (tServiceUsers.equals("")) {
					// 搜索条件不含
					pcList.add(pc2);
				} else {
					if (serviceUsers != null && !serviceUsers.equals("")) {
						if (serviceUsers.contains(",")) {
							// 多个工程师
							String[] users = serviceUsers.split(",");
							boolean isExist = false;
							for (int i = 0; i < users.length; i++) {
								if (tServiceUsers.equals(users[i])) {
									isExist = true;
									break;
								}
							}
							if (isExist) {
								pcList.add(pc2);
							}
						} else {
							if (serviceUsers.equals(tServiceUsers)) {
								pcList.add(pc2);
							}
						}

					}
				}

			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("pclist", JSONArray.fromObject(pcList));
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

	public String getProjectCaseList(int caseState) {
		try {
			sql = "select * from projectcase where caseState = ? and isRejected = 0";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setInt(1, caseState);
			res = pre.executeQuery();
			pcList = new ArrayList<ProjectCase>();
			while (res.next()) {
				ProjectCase pc2 = new ProjectCase();
				pc2.setId(res.getInt("id"));
				pc2.setCaseId(res.getString("caseId"));
				pc2.setProjectId(res.getString("projectId"));
				pc2.setSalesId(res.getInt("salesId"));
				pc2.setServiceUsers(res.getString("serviceUsers"));
				pc2.setServiceDate(res.getString("serviceDate"));
				pc2.setCaseType(res.getString("caseType"));
				pc2.setServiceType(res.getInt("serviceType"));
				pc2.setCreateDate(res.getString("createDate"));
				pc2.setIsChecked(res.getBoolean("isChecked"));
				pc2.setIsRejected(res.getBoolean("isRejected"));
				pc2.setCaseState(res.getInt("caseState"));
				pcList.add(pc2);
			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("pclist", JSONArray.fromObject(pcList));
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

	public String getCaseTypeByTypeId(int typeId) {
		try {
			sql = "select * from casetype where id = ?";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setInt(1, typeId);
			res = pre.executeQuery();
			if (res.next()) {
				CaseType ct = new CaseType();
				ct.setId(res.getInt("id"));
				ct.setTypeName(res.getString("typeName"));
				jsonObject = new JSONObject();
				jsonObject.put("errcode", "0");
				jsonObject.put("errmsg", "query");
				jsonObject.put("caseType", JSONArray.fromObject(ct));
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

	public String deleteProjectCase(int id) {
		jsonObject = new JSONObject();
		try {
			sql = "update projectcase set isDeleted = ? where id = ?";
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

	public String getProjectCaseUnPatchList(int unPatchType) {
		try {
			if (unPatchType == 0) {
				// 销售未审核
				sql = "select * from projectcase where isDeleted = 0 and isChecked = 0 order by CAST(serviceDate AS datetime) desc,id desc";
			} else {
				// 技术未审核且销售已审核且审核未被拒绝
				sql = "select * from projectcase where isDeleted = 0 and isRejected = 0 and isChecked = 1 and (serviceUsers IS null or serviceUsers = '') order by CAST(serviceDate AS datetime) desc,id desc";
			}
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			res = pre.executeQuery();
			pcList = new ArrayList<ProjectCase>();
			while (res.next()) {
				ProjectCase pc2 = new ProjectCase();
				pc2.setId(res.getInt("id"));
				pc2.setCaseId(res.getString("caseId"));
				pc2.setProjectId(res.getString("projectId"));
				pc2.setSalesId(res.getInt("salesId"));
				pc2.setServiceUsers(res.getString("serviceUsers"));
				pc2.setServiceDate(res.getString("serviceDate"));
				pc2.setCaseType(res.getString("caseType"));
				pc2.setServiceType(res.getInt("serviceType"));
				pc2.setCreateDate(res.getString("createDate"));
				pc2.setIsChecked(res.getBoolean("isChecked"));
				pc2.setIsRejected(res.getBoolean("isRejected"));
				pcList.add(pc2);
			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("pclist", JSONArray.fromObject(pcList));
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

	public String getProjectCaseUnClosedList(int caseState) {
		try {
			sql = "select * from projectcase where caseState = ? and isRejected = 0";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setInt(1, caseState);
			res = pre.executeQuery();
			pcList = new ArrayList<ProjectCase>();
			while (res.next()) {
				ProjectCase pc2 = new ProjectCase();
				pc2.setId(res.getInt("id"));
				pc2.setCaseId(res.getString("caseId"));
				pc2.setProjectId(res.getString("projectId"));
				pc2.setSalesId(res.getInt("salesId"));
				pc2.setServiceUsers(res.getString("serviceUsers"));
				pc2.setServiceDate(res.getString("serviceDate"));
				pc2.setCaseType(res.getString("caseType"));
				pc2.setServiceType(res.getInt("serviceType"));
				pc2.setCreateDate(res.getString("createDate"));
				pc2.setIsChecked(res.getBoolean("isChecked"));
				pc2.setIsRejected(res.getBoolean("isRejected"));
				pc2.setCaseState(res.getInt("caseState"));
				pc2.setServiceContent(res.getString("serviceContent"));
				pc2.setLateTimes(res.getInt("lateTimes"));
				pcList.add(pc2);
			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("pclist", JSONArray.fromObject(pcList));
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

	public String getProjectCase(int id) {
		try {
			sql = "select * from projectcase where id = ?";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setInt(1, id);
			res = pre.executeQuery();
			if (res.next()) {
				ProjectCase pc2 = new ProjectCase();
				pc2.setId(res.getInt("id"));
				pc2.setCaseId(res.getString("caseId"));
				pc2.setProjectId(res.getString("projectId"));
				pc2.setSalesId(res.getInt("salesId"));
				pc2.setContactUsers(res.getString("contactUsers"));
				pc2.setServiceDate(res.getString("serviceDate"));
				pc2.setCaseType(res.getString("caseType"));
				pc2.setServiceType(res.getInt("serviceType"));
				pc2.setCaseState(res.getInt("caseState"));
				pc2.setServiceUsers(res.getString("serviceUsers"));
				pc2.setDeviceInfo(res.getString("deviceInfo"));
				pc2.setServiceContent(res.getString("serviceContent"));
				pc2.setCreateDate(res.getString("createDate"));
				pc2.setIsChecked(res.getBoolean("isChecked"));
				pc2.setIsRejected(res.getBoolean("isRejected"));
				pc2.setRejectReason(res.getString("rejectReason"));
				pc2.setCasePeriod(res.getString("casePeriod"));
				pc2.setRemark(res.getString("remark"));
				pc2.setServiceEndDate(res.getString("serviceEndDate"));
				jsonObject = new JSONObject();
				jsonObject.put("errcode", "0");
				jsonObject.put("errmsg", "query");
				jsonObject.put("projectCase", JSONArray.fromObject(pc2));
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

	public String getProjectCaseByCaseId(String caseId) {
		try {
			sql = "select * from projectcase where caseId = ?";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, caseId);
			res = pre.executeQuery();
			if (res.next()) {
				ProjectCase pc2 = new ProjectCase();
				pc2.setId(res.getInt("id"));
				pc2.setCaseId(res.getString("caseId"));
				pc2.setProjectId(res.getString("projectId"));
				pc2.setSalesId(res.getInt("salesId"));
				pc2.setContactUsers(res.getString("contactUsers"));
				pc2.setServiceDate(res.getString("serviceDate"));
				pc2.setCaseType(res.getString("caseType"));
				pc2.setServiceType(res.getInt("serviceType"));
				pc2.setCaseState(res.getInt("caseState"));
				pc2.setServiceUsers(res.getString("serviceUsers"));
				pc2.setDeviceInfo(res.getString("deviceInfo"));
				pc2.setServiceContent(res.getString("serviceContent"));
				pc2.setCreateDate(res.getString("createDate"));
				pc2.setIsChecked(res.getBoolean("isChecked"));
				pc2.setIsRejected(res.getBoolean("isRejected"));
				pc2.setRejectReason(res.getString("rejectReason"));
				pc2.setCasePeriod(res.getString("casePeriod"));

				String serviceEndDate = res.getString("serviceEndDate");
				if (serviceEndDate.equals("") || serviceEndDate == null) {
					pc2.setServiceEndDate(res.getString("serviceDate"));
				} else {
					pc2.setServiceEndDate(serviceEndDate);
				}
				pc2.setRemark(res.getString("remark"));
				jsonObject = new JSONObject();
				jsonObject.put("errcode", "0");
				jsonObject.put("errmsg", "query");
				jsonObject.put("projectCase", JSONArray.fromObject(pc2));
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

	public String editCaseRecord(ProjectCase pc, int checkResult, int type) {
		JSONObject mJsonObject = null;
		try {
			if (type == 1) {
				// 销售审核
				if (checkResult == 1) {
					sql = "update projectcase set isChecked = 1 where id = " + pc.getId();
				} else {
					sql = "update projectcase set isChecked = 1,isRejected = 1,caseState=3,rejectReason = '"
							+ pc.getRejectReason() + "' where id = " + pc.getId();
				}
			} else if (type == 2) {
				// 技术审核
				if (checkResult == 1) {
					sql = "update projectcase set caseState = 1,serviceUsers = '" + pc.getServiceUsers()
							+ "',remark = '" + pc.getRemark() + "' where id = " + pc.getId();
				} else {
					sql = "update projectcase set isRejected = 1,caseState=3,rejectReason = '" + pc.getRejectReason()
							+ "' where id = " + pc.getId();
				}
			} else {
				sql = "update projectcase set salesId = ?,caseType = ?,serviceDate = ?,serviceType=?, serviceContent = ?,"
						+ "deviceInfo=?,contactUsers = ?,serviceUsers = ?,casePeriod= ?,serviceEndDate= ? where id = ?";
			}
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			if (type == 0) {
				pre.setInt(1, pc.getSalesId());
				pre.setString(2, pc.getCaseType());
				pre.setString(3, pc.getServiceDate());
				pre.setInt(4, pc.getServiceType());
				pre.setString(5, pc.getServiceContent());
				pre.setString(6, pc.getDeviceInfo());
				pre.setString(7, pc.getContactUsers());
				pre.setString(8, pc.getServiceUsers());
				pre.setString(9, pc.getCasePeriod());
				pre.setString(10, pc.getServiceEndDate());
				pre.setInt(11, pc.getId());

			}
			int j = pre.executeUpdate();

			if (j > 0) {
				mJsonObject = new JSONObject();
				mJsonObject.put("errcode", "0");

				// 添加售前售后跟进工程师 mType 0 售前 2 售后 1.实施中
				String serviceUser = pc.getServiceUsers();
				if (!serviceUser.equals("") && serviceUser != null) {
					String projectStr = getProjectByProjectId(pc.getProjectId());
					JSONArray jsonArray = new JSONObject().fromObject(projectStr).getJSONArray("project");
					pList = new ArrayList<Project>();
					pList = (List<Project>) JSONArray.toCollection(jsonArray, Project.class);
					Project pj = pList.get(0);
					int mType = Integer.parseInt(pc.getCaseType().split("#")[0]);

					if (mType == 0) {
						pj.setSalesBeforeUsers(updateProjectUsers(pj.getSalesBeforeUsers(), serviceUser));
					} else {
						pj.setSalesAfterUsers(updateProjectUsers(pj.getSalesAfterUsers(), serviceUser));
					}
					editProject(pj);
				}
			} else {
				mJsonObject = new JSONObject();
				mJsonObject.put("errcode", "1");
			}
			return mJsonObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
			mJsonObject = new JSONObject();
			mJsonObject.put("errcode", "2");
			return mJsonObject.toString();
		} finally {
			DBConnection.closeCon(con);
			DBConnection.closePre(pre);
		}
	}

	public String editProjectCase(ProjectCase pc) {
		jsonObject = new JSONObject();
		try {
			sql = "update projectcase set caseState = ? where id = ?";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setInt(1, pc.getCaseState());
			pre.setInt(2, pc.getId());
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

	public String updateProjectUsers(String oldUsers, String newUsers) {
		String updateUsers = "";
		if (oldUsers.equals("") || oldUsers == null) {
			updateUsers = newUsers;
		} else if (!oldUsers.contains(",")) {
			// 原来只有一个
			if (!newUsers.contains(",")) {
				if (oldUsers.equals(newUsers)) {
					updateUsers = oldUsers;
				} else {
					updateUsers = oldUsers + "," + newUsers;
				}
			} else {
				String[] arrayNewUsers = newUsers.split(",");
				boolean isExist = false;
				for (int i = 0; i < arrayNewUsers.length; i++) {
					if (oldUsers.equals(arrayNewUsers[i])) {
						isExist = true;
						break;
					}
				}
				if (isExist) {
					updateUsers = newUsers;
				} else {
					updateUsers = oldUsers + "," + newUsers;
				}
			}
		} else {
			// 原来有多个
			if (!newUsers.contains(",")) {
				String[] arrayOldUsers = oldUsers.split(",");
				boolean isExist = false;
				for (int i = 0; i < arrayOldUsers.length; i++) {
					if (newUsers.equals(arrayOldUsers[i])) {
						isExist = true;
						break;
					}
				}
				if (isExist) {
					updateUsers = oldUsers;
				} else {
					updateUsers = oldUsers + "," + newUsers;
				}
			} else {
				String[] arrayNewUsers = newUsers.split(",");
				String[] arrayOldUsers = oldUsers.split(",");
				boolean isExist = false;
				for (int i = 0; i < arrayOldUsers.length; i++) {
					String newUser = "";
					for (int j = 0; j < arrayNewUsers.length; j++) {
						newUser = arrayNewUsers[j];
						if (arrayOldUsers[i].equals(newUser)) {
							isExist = true;
							break;
						}
					}
					if (!isExist) {
						oldUsers += "," + newUser;
						isExist = false;
					}
				}
				updateUsers = oldUsers;
			}
		}
		return updateUsers;
	}

	public String editAllProjectCase() {
		Calendar calendar = Calendar.getInstance();
		calendar.add(Calendar.DATE, 0);
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
		String todayString = formatter.format(calendar.getTime());// 今天
		jsonObject = new JSONObject();
		try {
			sql = "update projectcase set caseState = 2 where caseState = 1 and "
					+ "CAST(DATE_ADD(DATE_ADD(serviceDate,INTERVAL casePeriod DAY),INTERVAL 3 DAY) AS date)< CAST(? AS date)";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, todayString);
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

	public String updateLateTimes(ProjectCase pc) {
		jsonObject = new JSONObject();
		try {
			sql = "update projectcase set lateTimes = ? where id = ?";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setInt(1, pc.getLateTimes());
			pre.setInt(2, pc.getId());
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

	public String getProjectCaseUnClosedList2(int caseState, int year, int month) {
		try {
			// 时间范围
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
			Calendar calendar = Calendar.getInstance();
			Date thisDate = formatter.parse(year + "/" + month + "/1");
			calendar.setTime(thisDate);
			calendar.set(Calendar.DAY_OF_MONTH, 1);
			String dateString = formatter.format(calendar.getTime());// 月的第一天
			calendar.add(Calendar.MONTH, 1);
			calendar.set(Calendar.DATE, 0);
			String dateString2 = formatter.format(calendar.getTime());// 月的最后一天
			// System.out.println(dateString+"-"+dateString2);
			sql = "select * from projectcase where lateTimes > 0 and isDeleted = 0 and isRejected = 0 and "
					+ "CAST(DATE_ADD(DATE_ADD(serviceDate,INTERVAL casePeriod DAY),INTERVAL 4 DAY) AS date)>= CAST(? AS date) and "
					+ "CAST(DATE_ADD(DATE_ADD(serviceDate,INTERVAL casePeriod DAY),INTERVAL 4 DAY) AS date)<= CAST(? AS date)";
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			pre.setString(1, dateString);
			pre.setString(2, dateString2);

			res = pre.executeQuery();
			pcList = new ArrayList<ProjectCase>();
			while (res.next()) {
				ProjectCase pc2 = new ProjectCase();
				pc2.setId(res.getInt("id"));
				pc2.setCaseId(res.getString("caseId"));
				pc2.setProjectId(res.getString("projectId"));
				pc2.setSalesId(res.getInt("salesId"));
				pc2.setServiceUsers(res.getString("serviceUsers"));
				pc2.setServiceDate(res.getString("serviceDate"));
				pc2.setCaseType(res.getString("caseType"));
				pc2.setServiceType(res.getInt("serviceType"));
				pc2.setCreateDate(res.getString("createDate"));
				pc2.setIsChecked(res.getBoolean("isChecked"));
				pc2.setIsRejected(res.getBoolean("isRejected"));
				pc2.setCaseState(res.getInt("caseState"));
				pc2.setCasePeriod(res.getString("casePeriod"));
				pc2.setServiceContent(res.getString("serviceContent"));
				pc2.setLateTimes(res.getInt("lateTimes"));
				pcList.add(pc2);
			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("pclist", JSONArray.fromObject(pcList));
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

	public String getProjectSubStateList(int projectState, int projectType) {
		try {
			sql = "select * from projectsubstate where isDeleted = 0";
			sql += " and projectState = " + projectState;
			sql += " and projectType = " + projectType;
			sql += " order by projectType,projectState,pid";
			//System.out.println(sql);
			con = DBConnection.getConnection_Mysql();
			pre = con.prepareStatement(sql);
			res = pre.executeQuery();
			pssList = new ArrayList<ProjectSubState>();
			while (res.next()) {
				ProjectSubState pss = new ProjectSubState();
				pss.setPId(res.getInt("pid"));
				pss.setProjectState(res.getInt("projectState"));
				pss.setProjectType(res.getInt("projectType"));
				pss.setName(res.getString("name"));
				pssList.add(pss);
			}
			jsonObject = new JSONObject();
			jsonObject.put("errcode", "0");
			jsonObject.put("errmsg", "query");
			jsonObject.put("projectSubStateList", JSONArray.fromObject(pssList));
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
