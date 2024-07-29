package com.fmlk.service;

import com.fmlk.dao.ProjectDao;
import com.fmlk.entity.Project;
import com.fmlk.entity.ProjectCase;
import com.fmlk.entity.ProjectReport;

public class ProjectService {
	private ProjectDao dao = null;

	public String createProject(Project p) {
		dao = new ProjectDao();
		return dao.createProject(p);
	}

	public String getProjectList(Project p,boolean isFmlkShare) {
		dao = new ProjectDao();
		return dao.getProjectList(p,isFmlkShare);
	}

	public String getProjectByProjectId(String projectId) {
		dao = new ProjectDao();
		return dao.getProjectByProjectId(projectId);
	}
	
	public String deleteProject(int id,String updateDate) {
		dao = new ProjectDao();
		return dao.deleteProject(id,updateDate);
	}
	
	public String getProject(int id) {
		dao = new ProjectDao();
		return dao.getProject(id);
	}

	public String createProjectReport(ProjectReport pr) {
		dao = new ProjectDao();
		return dao.createProjectReport(pr);
	}

	public String getProjectReportList(String projectId) {
		dao = new ProjectDao();
		return dao.getProjectReportList(projectId);
	}

	public String editProject(Project project) {
		dao = new ProjectDao();
		return dao.editProject(project);
	}

	public String createProjectCase(ProjectCase pc) {
		dao = new ProjectDao();
		return dao.createProjectCase(pc);
	}

	public String getProjectCaseList(ProjectCase pc, String companyId, String projectName) {
		dao = new ProjectDao();
		return dao.getProjectCaseList(pc,companyId,projectName);
	}

	public String getCaseTypeByTypeId(int typeId) {
		dao = new ProjectDao();
		return dao.getCaseTypeByTypeId(typeId);
	}

	public String deleteProjectCase(int id,String updateDate) {
		dao = new ProjectDao();
		return dao.deleteProjectCase(id,updateDate);
	}

	public String getProjectCaseUnPatchList(int unPatchType) {
		dao = new ProjectDao();
		return dao.getProjectCaseUnPatchList(unPatchType);
	}

	public String getProjectCase(int id) {
		dao = new ProjectDao();
		return dao.getProjectCase(id);
	}
	
	public String getProjectCaseByCaseId(String caseId) {
		dao = new ProjectDao();
		return dao.getProjectCaseByCaseId(caseId);
	}

	public String editCaseRecord(ProjectCase pc, int checkResult, int type) {
		dao = new ProjectDao();
		return dao.editCaseRecord(pc,checkResult,type);
	}

	public String editProjectCase(ProjectCase pc) {
		dao = new ProjectDao();
		return dao.editProjectCase(pc);
	}
	
	public String editAllProjectCase() {
		dao = new ProjectDao();
		return dao.editAllProjectCase();
	}
	
	//所有的
	public String getProjectCaseUnClosedList(int caseState) {
		dao = new ProjectDao();
		return dao.getProjectCaseUnClosedList(caseState);
	}
	
	//单个月的
	public String getProjectCaseUnClosedList2(int caseState,int year,int month) {
		dao = new ProjectDao();
		return dao.getProjectCaseUnClosedList2(caseState,year,month);
	}

	public String updateLateTimes(ProjectCase pc) {
		dao = new ProjectDao();
		return dao.updateLateTimes(pc);
	}

	public String getProjectSubStateList(int projectState, int projectType) {
		dao = new ProjectDao();
		return dao.getProjectSubStateList(projectState, projectType);
	}
	
	public String getProjectState(int projectState, int projectSubState, int projectType) {
		dao = new ProjectDao();
		return dao.getProjectState(projectState, projectSubState, projectType);
	}
	
	public String editProjectSubState(int projectType,String[] arraySubState) {
		dao = new ProjectDao();
		return dao.editProjectSubState(projectType,arraySubState);
	}
}
