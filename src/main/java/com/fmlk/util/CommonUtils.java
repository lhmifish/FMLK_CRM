package com.fmlk.util;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DateUtil;
import org.springframework.web.multipart.MultipartFile;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class CommonUtils {
	public synchronized static File saveImageFile(MultipartFile multipartFile, String folder)
			throws IllegalStateException, IOException {
		File mkDir = new File(folder);
		if (!mkDir.exists()) {
			mkDir.mkdirs();
		}
		File saveFile = new File(getPath(folder, multipartFile.getOriginalFilename()));
		multipartFile.transferTo(saveFile);
		return saveFile;
	}

	public static String getPath(String folder, String path) {
		if (folder.endsWith("\\") || folder.endsWith("/")) {
			return folder + path;
		} else {
			return folder + "/" + path;
		}
	}

	public synchronized static File saveExcelFile(MultipartFile multipartFile, String folder)
			throws IllegalStateException, IOException {
		String fileName = multipartFile.getOriginalFilename();
		String year = fileName.split("-")[0];
		String month = fileName.split("-")[1];
		switch (month) {
		case "1":
			month = "January";
			break;
		case "2":
			month = "February";
			break;
		case "3":
			month = "March";
			break;
		case "4":
			month = "April";
			break;
		case "5":
			month = "May";
			break;
		case "6":
			month = "June";
			break;
		case "7":
			month = "July";
			break;
		case "8":
			month = "Aguest";
			break;
		case "9":
			month = "September";
			break;
		case "10":
			month = "October";
			break;
		case "11":
			month = "November";
			break;
		case "12":
			month = "December";
			break;
		}
		folder = folder + "/" + year + "/" + month + "/";
		File mkDir = new File(folder);
		if (!mkDir.exists()) {
			mkDir.mkdirs();
		}
		File saveFile = new File(getPath(folder, fileName));
		multipartFile.transferTo(saveFile);
		return saveFile;
	}

	public static String getExcelValue(Cell cell) {
		String cellValue = "";
		if (cell != null) {
			switch (cell.getCellType()) {
			case Cell.CELL_TYPE_NUMERIC:
				// System.out.println("NUMERIC ");
				// 日期 时间 和数字都归类在 Cell.CELL_TYPE_NUMERIC里
				if (DateUtil.isCellDateFormatted(cell)) {
					// System.out.println("NUMERIC1 "+cell.getCellStyle().getDataFormat());
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
					double value = cell.getNumericCellValue();
					Date date = DateUtil.getJavaDate(value);
					if (cell.getCellStyle().getDataFormat() == 14) {
						cellValue = sdf.format(date).substring(0, 10);
						// System.out.println("日期 "+ cellValue);
					} else if (cell.getCellStyle().getDataFormat() == 178) {
						cellValue = sdf.format(date).substring(11, 16);
						// System.out.println("时间 "+ cellValue);
					}
				} else {
					// 纯数字
					cell.setCellType(Cell.CELL_TYPE_STRING);
					cellValue = cell.getStringCellValue();
					// System.out.println("数字 "+ cell.getStringCellValue());
				}
				break;
			case Cell.CELL_TYPE_STRING:
				cellValue = cell.getStringCellValue();
				break;
			case Cell.CELL_TYPE_BOOLEAN:
				cellValue = String.valueOf(cell.getBooleanCellValue());
				break;
			case Cell.CELL_TYPE_FORMULA:
				cellValue = String.valueOf(cell.getCellFormula());
				break;
			case Cell.CELL_TYPE_BLANK:
				cellValue = "";
				break;
			case Cell.CELL_TYPE_ERROR:
				cellValue = "";
				break;
			default:
				cellValue = cell.toString().trim();
				break;
			}
		}
		return cellValue.trim();

	}

	public static int getDays(String date) {
		String[] strs = date.split("/");
		int year = Integer.parseInt(strs[0]);
		int month = Integer.parseInt(strs[1]);
		int days = 0;

		if (month != 2) {
			switch (month) {
			case 1:
			case 3:
			case 5:
			case 7:
			case 8:
			case 10:
			case 12:
				days = 31;
				break;
			case 4:
			case 6:
			case 9:
			case 11:
				days = 30;

			}
		} else {
			// 闰年
			if (year % 4 == 0 && year % 100 != 0 || year % 400 == 0)
				days = 29;
			else
				days = 28;
		}
		return days;
	}

	/**
	 * 
	 * 利用SHA-256对源字符串进行加密
	 * 
	 * @param src
	 * @return 返回加密串，注：本例中，空串表示加密失败
	 */

	public static String encryptSHA256(String src) {
		byte[] btSource = src.getBytes();
		try {
            // 此处选择了SHA-256加密算法,实际可选的算法有"MD2、MD5、SHA-1、SHA-256、SHA-384、SHA-512"
			MessageDigest md = MessageDigest.getInstance("SHA-256");
			md.update(btSource);
			String result = bytes2Hex(md.digest()); // to HexString
			return result;
		} catch (NoSuchAlgorithmException e) {
			return "";
		}

	}
	
	/**
	 * 把字节数组输出成字符串
	 * @param bts
	 * @return
	 */
	private static String bytes2Hex(byte[] bts) {
        StringBuffer des = new StringBuffer();
        String tmp = null;
        for (int i = 0; i < bts.length; i++) {
            tmp = (Integer.toHexString(bts[i] & 0xFF));
            if (tmp.length() == 1) {
                des.append("0");
            }
            des.append(tmp);
        }
        return des.toString();
    }
}
