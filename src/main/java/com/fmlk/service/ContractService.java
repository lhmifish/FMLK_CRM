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

	public String deleteContract(int id) {
		dao = new ContractDao();
		return dao.deleteContract(id);
	}
	
/*	
	public String getContractById(int id) {
		dao = new ContractDao();
		return dao.getContractById(id);
	}*/

}
