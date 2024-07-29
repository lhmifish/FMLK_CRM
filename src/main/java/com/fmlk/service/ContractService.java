package com.fmlk.service;

import com.fmlk.dao.ContractDao;
import com.fmlk.entity.Contract;

public class ContractService {
	private ContractDao dao = null;

	public String createContract(Contract contract, String[] paymentInfo) {
		dao = new ContractDao();
		return dao.queryContract(contract, paymentInfo);
	}

	public String getContractList(Contract contract) {
		dao = new ContractDao();
		return dao.getContractList(contract);
	}

	public String deleteContract(int id,String updateDate) {
		dao = new ContractDao();
		return dao.deleteContract(id,updateDate);
	}
	
	
	public String getContractById(int id) {
		dao = new ContractDao();
		return dao.getContractById(id);
	}

	public String editContract(Contract ct,String[] paymentInfo) {
		dao = new ContractDao();
		return dao.editContract(ct,paymentInfo);
	}

	public String getContractPaymentInfoList(String contractNum) {
		dao = new ContractDao();
		return dao.getContractPaymentInfoList(contractNum);
	}

	public String getDelayContractPaymentInfoList() {
		dao = new ContractDao();
		return dao.getDelayContractPaymentInfoList();
	}

}
