package kr.or.ddit.util;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


public class CookieManager {
	
	 //명시한 이름, 값, 유지 기간 조건으로 새로운 쿠키를 생성
    public static void makeCookie(HttpServletResponse response, String cName,
            String cValue, int cTime) {
        Cookie cookie = new Cookie(cName, cValue); //1.쿠키 생성
        cookie.setPath("/");         //2.경로 설정
        cookie.setMaxAge(cTime);     //3.유지 기간 설정
        response.addCookie(cookie);  //4.응답 객체에 추가
    }
    
  //명시한 이름, 값, 유지 기간 조건으로 새로운 쿠키를 생성
    public void makeCookie2(HttpServletResponse response, String cName,
            String cValue, int cTime) {
        Cookie cookie = new Cookie(cName, cValue); //1.쿠키 생성
        cookie.setPath("/");         //2.경로 설정
        cookie.setMaxAge(cTime);     //3.유지 기간 설정
        response.addCookie(cookie);  //4.응답 객체에 추가
    }

    // 명시한 이름의 쿠키를 찾아 그 값을 반환
    public static String readCookie(HttpServletRequest request, String cName) {
        String cookieValue = "";  // 반환 값

        Cookie[] cookies = request.getCookies();    //5.
        if (cookies != null) {
            for (Cookie c : cookies) {
                String cookieName = c.getName();
                if (cookieName.equals(cName)) {    //6.
                    cookieValue = c.getValue();  // 반환 값 갱신
                }
            }
        }
        return cookieValue;    //7.
    }
    
    // 명시한 이름의 쿠키를 찾아 그 값을 반환
    public String readCookie2(HttpServletRequest request, String cName) {
        String cookieValue = "";  // 반환 값

        Cookie[] cookies = request.getCookies();    //5.
        if (cookies != null) {
            for (Cookie c : cookies) {
                String cookieName = c.getName();
                if (cookieName.equals(cName)) {    //6.
                    cookieValue = c.getValue();  // 반환 값 갱신
                }
            }
        }
        return cookieValue;    //7.
    }

    // 명시한 이름의 쿠키를 삭제
    public static void deleteCookie(HttpServletResponse response, String cName) {
        makeCookie(response, cName, "", 0);    //8.
    }
}
