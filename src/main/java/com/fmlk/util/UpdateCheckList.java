package com.fmlk.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import com.fmlk.dao.Dao;
import com.fmlk.entity.User;
import com.fmlk.entity.WechatCheck;

public class UpdateCheckList {
	private static List<WechatCheck> list = null;
	private static List<WechatCheck> objList = null;
	private static List<User> userList = null;
	private static Dao dao= null;
	private static SimpleDateFormat sdf3 = null;

	public static boolean getList(String[] arr,String date) throws ParseException {
		list = new ArrayList<WechatCheck>();
        for (int i = 0; i < arr.length; i++) {
			String[] obj = arr[i].split("#");
			WechatCheck wc = new WechatCheck();
			wc.setDate(obj[0]);
			wc.setUserName(obj[1]);
			wc.setCheckFlag(obj[2]);
			wc.setCheckTime(obj[3]);
			wc.setAddress(obj[4]);
			list.add(wc);
		}
		
        userList = new ArrayList<User>();
        dao = new Dao();
        userList = dao.getUserList2(date, 0);
        
        for(int i=0;i<userList.size();i++) {
        	objList = new ArrayList<WechatCheck>();
        	
        	for(int j=0;j<list.size();j++) {
        		if(userList.get(i).getName().equals(list.get(j).getUserName())) {
        			objList.add(list.get(j));
        		}
        	}
        	if(objList.size()>0) {
        	updateList(objList,date);
        	}
        }
        return true;
	}

	private static void updateList(List<WechatCheck> mlist, String date) throws ParseException {
		WechatCheck obj = new WechatCheck();
		sdf3 = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
		for(int i=0;i<mlist.size();i++) {
			obj = mlist.get(i);
			Date objDate = sdf3.parse(date+" "+obj.getCheckTime());
			Date beginDate = sdf3.parse(date+" 09:00:00");
			Date endDate = sdf3.parse(date+" 17:00:00");
			if(i==0 && objDate.after(beginDate)) {
				obj.setState(0);
			}else if(i==list.size()-1 && objDate.before(endDate)) {
				obj.setState(0);
			}else {
				obj.setState(2);
			}
			dao.saveCheck(obj);
		}
	}
	
	
}
