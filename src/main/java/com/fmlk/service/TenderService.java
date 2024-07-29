package com.fmlk.service;

import com.fmlk.dao.TenderDao;
import com.fmlk.entity.Tender;

public class TenderService {

	private TenderDao dao = null;

	public String createTender(Tender tender) {
		dao = new TenderDao();
		return dao.createTender(tender);
	}

	public String editTender(Tender tender) {
		dao = new TenderDao();
		return dao.editTender(tender);
	}

	public String deleteTender(int id,String updateDate) {
		dao = new TenderDao();
		return dao.deleteTender(id,updateDate);
	}

	public String getTenderList(Tender tender, String date1, String date2) {
		dao = new TenderDao();
		return dao.getTenderList(tender, date1, date2);
	}

	public String getTenderById(int id) {
		dao = new TenderDao();
		return dao.getTenderById(id);
	}

	public String getTenderByCompanyId_Sales(int salesId, String companyId) {
		dao = new TenderDao();
		return dao.getTenderByCompanyId_Sales(salesId, companyId);
	}

	public String getTenderListUnInputContract() {
		dao = new TenderDao();
		return dao.getTenderListUnInputContract();
	}
}
