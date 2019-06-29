<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="ki.KiDAO"%>
<%@ page import="java.io.PrintWriter"%>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="ki" class="ki.Ki" scope="page"/>
<jsp:setProperty name="ki" property="kiTitle"/>
<jsp:setProperty name="ki" property="kiContent"/>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<%
		String userID = null;
			if (session.getAttribute("userID") != null) {
		userID = (String) session.getAttribute("userID"); //자신에게 할당된 세션값을 ID에 
			}
			if (userID == null) { //접속이되어야 글을 쓸수 있기때문에
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 하세요')");
		script.println("location.href ='login.jsp'");
		script.println("</script>");
			} else {
		if (ki.getKiContent() == null || ki.getKiTitle() == null ) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('입력이 안된 사항이 있습니다')");
			script.println("history.back()"); //이전 페이지로 돌려보내기 
			script.println("</script>");
		} else {
			KiDAO kiDAO = new KiDAO();
			int result = kiDAO.write(ki.getKiTitle(), userID , ki.getKiContent());

			if (result == -1) {
				PrintWriter script = response.getWriter();
				script.println("<script>");
					script.println("alert('글쓰기에 실패했습니다')");
					script.println("history.back()"); //이전 페이지로 돌려보내기 
					script.println("</script>");
				} else {
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("location.href ='bbs.jsp'");
					script.println("</script>");
				}
			}

		}
	%>
</body>
</html>