package com.fmlk.util;

import java.io.FileInputStream;
import java.net.URLEncoder;
import java.util.Properties;

import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;

public class WeiXinEnterpriseUtils {

	/*public static String getAccessToken(String corpId, String corpSecret) {
		String url = String.format("https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid=%s&corpsecret=%s", corpId, corpSecret);
		JSONObject jb = get(url);
		return jb.getString("access_token");
	}*/
	
	public static JSONObject get(String url){
        JSONObject jb = null;
        HttpGet request = new HttpGet(url);
        CloseableHttpClient httpclient = HttpClients.createDefault();
        try {
        	HttpResponse response = httpclient.execute(request);
            String reposeContent = EntityUtils.toString(response.getEntity(),"utf-8");
            jb = JSON.parseObject(reposeContent);

        }catch (Exception e){
            jb = null;
        }
        return jb;
    }
	
	public static String getPreviousWechatUser(String accessToken, String code) {
		String url = String.format("https://qyapi.weixin.qq.com/cgi-bin/user/getuserinfo?access_token=%s&code=%s", accessToken, code);
		JSONObject jsonObject = get(url);
		String errcode = jsonObject.getString("errcode");
        if(errcode.equals("0")){
            return jsonObject.getString("UserId");
        }else {
            return null;
        }
	}
	
	public static String getWechatUserId(String code) {
		try {
			Properties prop = new Properties();
			String path = DBConnection.class.getResource("/").getPath();
			path = path.substring(1, path.indexOf("WEB-INF/classes")) + "property/wechat.properties";
			path = path.replaceAll("%20", " ");
			prop.load(new FileInputStream(path));
			String corpId = prop.getProperty("wechat.corpId");
			String corpSecret = prop.getProperty("wechat.secret");
			String accessToken = WeChatEnterpriseUtils.getAccessToken();
			return getPreviousWechatUser(accessToken,code);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "";
		
	}
}
