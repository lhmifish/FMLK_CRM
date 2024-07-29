package com.fmlk.util;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import com.fmlk.service.ContractService;
import com.google.gson.Gson;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public class MyTimerTask3 {
	
	private ContractService mContractService;

	//每天下午一点检测合同收付款报警
	protected void execute3() {
		//同济邮件报警,每两分钟查一次
		//ExchangeMailUtil.sendAlertEmail();
		mContractService = new ContractService();
		String jsonStr = mContractService.getDelayContractPaymentInfoList();	
		String mErrcode = (String) new Gson().fromJson(jsonStr, Map.class).get("errcode");
		if (mErrcode.equals("0")) {
			JSONArray myArrayList = new JSONObject().fromObject(jsonStr).getJSONArray("paymentInfolist");
			List<String> mContractInfoList = new ArrayList<String>();
			mContractInfoList = (List<String>) JSONArray.toCollection(myArrayList,String.class);
			WeChatEnterpriseUtils.projectContractInform(mContractInfoList);
		}
	}
}
