package com.fmlk.util;

import java.io.FileInputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;
import org.apache.log4j.Logger;

public class DBConnection {
	
	public static Logger log = Logger.getLogger(DBConnection.class);


	public static Connection getConnection_Mysql() {

		try {
			Properties prop = new Properties();
			String path = DBConnection.class.getResource("/").getPath();
			path = path.substring(1, path.indexOf("WEB-INF/classes"))+"property/jdbc.properties";
		    path = path.replaceAll("%20"," ");
			prop.load(new FileInputStream(path));
			Class.forName(prop.getProperty("jdbc.mysql.className"));
			String DBURL = prop.getProperty("jdbc.mysql.url");
	        String USERNAME = prop.getProperty("jdbc.mysql.user");
	        String PASSWORD = prop.getProperty("jdbc.mysql.password");
	        Connection con = DriverManager.getConnection(DBURL,USERNAME,PASSWORD);
			return con;
		} catch (Exception e) {
			e.printStackTrace();
		}

		return null;
	}
	
	public static Connection getConnection_Mysql2() {

		try {
			Properties prop = new Properties();
			String path = DBConnection.class.getResource("/").getPath();
			path = path.substring(1, path.indexOf("WEB-INF/classes"))+"property/jdbc.properties";
		    path = path.replaceAll("%20"," ");
			prop.load(new FileInputStream(path));
			Class.forName(prop.getProperty("jdbc.mysql.className"));
			String DBURL = prop.getProperty("jdbc.mysql.url2");
	        String USERNAME = prop.getProperty("jdbc.mysql.user");
	        String PASSWORD = prop.getProperty("jdbc.mysql.password");
	        Connection con = DriverManager.getConnection(DBURL,USERNAME,PASSWORD);
			return con;
		} catch (Exception e) {
			e.printStackTrace();
		}

		return null;
	}
	
	public static Connection getConnection2() {
       try {
			Properties prop = new Properties();
			String path = DBConnection.class.getResource("/").getPath();
			path = path.substring(1, path.indexOf("WEB-INF/classes"))+"property/jdbc.properties";
			path = path.replaceAll("%20"," ");
			prop.load(new FileInputStream(path));
			Class.forName(prop.getProperty("jdbc.sqlserver.className"));
			String DBURL = prop.getProperty("jdbc.sqlserver.crmUrl");
	        String USERNAME = prop.getProperty("jdbc.sqlserver.user");
	        String PASSWORD = prop.getProperty("jdbc.sqlserver.password");
	        Connection con = DriverManager.getConnection(DBURL,USERNAME,PASSWORD);
			return con;
		} catch (Exception e) {
			e.printStackTrace();
		}

		return null;
	}
	
	public static Connection getConnection3() {

		try {
			Properties prop = new Properties();
			String path = DBConnection.class.getResource("/").getPath();
			path = path.substring(1, path.indexOf("WEB-INF/classes"))+"property/jdbc.properties";
			path = path.replaceAll("%20"," ");
			prop.load(new FileInputStream(path));
			Class.forName(prop.getProperty("jdbc.sqlserver.className"));
			String DBURL = prop.getProperty("jdbc.sqlserver.cardUrl");
	        String USERNAME = prop.getProperty("jdbc.sqlserver.user");
	        String PASSWORD = prop.getProperty("jdbc.sqlserver.password");
	        Connection con = DriverManager.getConnection(DBURL,USERNAME,PASSWORD);
			return con;
		} catch (Exception e) {
			e.printStackTrace();
		}

		return null;
	}

	// 关闭连接
	public static void closeCon(Connection con) {
		try {
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	// 关闭实例
	public static void closePre(PreparedStatement pre) {
		try {
			pre.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	// 关闭结果集
	public static void closeRes(ResultSet res) {
		try {
			res.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	
}
