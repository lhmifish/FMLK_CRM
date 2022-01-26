package com.fmlk.service;

import java.util.List;

import com.fmlk.dao.UserDao;
import com.fmlk.entity.User;

public class UserService {
	private UserDao dao = null;
	
	public String getUserList(User user,String date, boolean isHide) {
		dao = new UserDao();
		return dao.getUserList(user,date,isHide);
	}
	
	public String getUserContactList(String companyId) {
		dao = new UserDao();
		return dao.getUserContactList(companyId);
	}
	
	public String getUserById(int uId) {
		dao = new UserDao();
		return dao.getUserById(uId);
	}
	
	public String getUserByUserName(String uName) {
		dao = new UserDao();
		return dao.getUserByUserName(uName);
	}

	public String getUserByNickName(String nickName) {
		dao = new UserDao();
		return dao.getUserByNickName(nickName);
	}

	public String createUser(User user) {
		dao = new UserDao();
		return dao.createUser(user);
	}

	public String editUser(User user) {
		dao = new UserDao();
		return dao.editUser(user);
	}
	
	public int queryUser(User user) {
		dao = new UserDao();
		return dao.queryUser(user);
	}

	public List<User> getUserList(String userIdStr) {
		dao = new UserDao();
		return dao.getUserList(userIdStr);
	}
}
