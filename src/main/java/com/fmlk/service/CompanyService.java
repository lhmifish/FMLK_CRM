package com.fmlk.service;

import com.fmlk.dao.CompanyDao;
import com.fmlk.entity.Company;

public class CompanyService {
	private CompanyDao dao = null;

	public String createCompany(Company c, String[] arrayContact) {
		dao = new CompanyDao();
		return dao.createCompany(c, arrayContact);
	}

	public String editCompany(Company c, String[] arrayContact) {
		dao = new CompanyDao();
		return dao.editCompany(c, arrayContact);
	}

	public String deleteCompany(int id,String updateDate) {
		dao = new CompanyDao();
		return dao.deleteCompany(id,updateDate);
	}

	public String getCompanyList(int salesId, String companyName,boolean isFmlkShare) {
		dao = new CompanyDao();
		return dao.getCompanyList(salesId, companyName,isFmlkShare);
	}

	public String getCompanyByCompanyId(String companyId) {
		dao = new CompanyDao();
		return dao.getCompanyByCompanyId(companyId);
	}

	public String getCompanyById(int id) {
		dao = new CompanyDao();
		return dao.getCompanyById(id);
	}

	public String getCompanyByProjectId(String projectId) {
		dao = new CompanyDao();
		return dao.getCompanyByProjectId(projectId);
	}
}
