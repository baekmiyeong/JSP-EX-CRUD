<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="ki.KiDAO"%>
<%@ page import="ki.Ki"%>
<%@ page import="java.io.PrintWriter"%>
<%
	request.setCharacterEncoding("UTF-8");
%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>JSP 掲示板</title>
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
			script.println("alert('ログインしてください')");
			script.println("location.href ='login.jsp'");
			script.println("</script>");
		}

		int kiID = 0;
		if (request.getParameter("kiID") != null) {
			kiID = Integer.parseInt(request.getParameter("kiID"));
		}
		if (kiID == 0) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 글입니다')");
			script.println("location.href ='bbs.jsp'");
			script.println("</script>");
		}
		// 현재 작성글이 본인인지 확인 세션관리
		Ki ki = new KiDAO().getKi(kiID);
		//
		if (!userID.equals(ki.getUserID())) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('권한이 없습니다')");
			script.println("location.href ='bbs.jsp'");
			script.println("</script>");
		} else { //beans를 사용하지 않기때문에 파라미터로 비교할 필요가 있다
			// 글삭제 
			KiDAO kiDAO = new KiDAO();
			int result = kiDAO.delete(kiID);

			if (result == -1) {
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('글삭제에 실패했습니다')");
				script.println("history.back()"); //이전 페이지로 돌려보내기 
				script.println("</script>");
			} else {
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("location.href ='bbs.jsp'");
				script.println("</script>");
			}

		}
	%>
</body>
</html>