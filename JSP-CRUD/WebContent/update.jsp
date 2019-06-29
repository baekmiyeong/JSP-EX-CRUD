<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>    
<%@ page import="ki.Ki" %>
<%@ page import="ki.KiDAO" %>  
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width",initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<title>JSP 웹 게시판</title>
</head>
<body>
	<%
		String userID = null;
		if(session.getAttribute("userID") != null){
			userID = (String)session.getAttribute("userID");
		}
		if(userID == null) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인을 하세요')");
			script.println("location.href ='login.jsp'");
			script.println("</script>");
		}
		int kiID = 0;
		if(request.getParameter("kiID") != null) {
			kiID = Integer.parseInt(request.getParameter("kiID"));
		} 
		if(kiID ==0) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 글입니다')");
			script.println("location.href ='bbs.jsp'");
			script.println("</script>");
		}
		// 현재 작성글이 본인인지 확인 세션관리
		Ki ki = new KiDAO().getKi(kiID);
		//
		if(!userID.equals(ki.getUserID())){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('권한이 없습니다')");
			script.println("location.href ='bbs.jsp'");
			script.println("</script>");
		}
	%>
	<nav class="navbar navbar-default">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed"
				data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
				aria-expanded="false">
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				</button>
				<a class="navbar-brand" href="main.jsp">JSP 게시판</a>
		</div>
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li><a href="main.jsp">메인</a></li>
				<li class="active"><a href="bbs.jsp">게시판</a></li>
			</ul> 
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="botton" aria-haspopup="true"
						aria-expanded="false">회원관리<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="logoutAction.jsp">로그아웃</a>
					</ul>
				</li>
			</ul>

				
		</div>
	</nav>
	<!-- 게시판 만들기 -->
	<div class="container">
		<div class="row"> 
		<!-- 게시판 글쓰기 양식 -->
		<form method="post" action="updateAction.jsp?kiID=<%= kiID %>">
			<table class="table table-striped" style="text-align: center; border: ipx solid #dddddd">
				<thead> 
					<tr>
						<th colspan="2" style="background-color: #eeeeee; text-align: center;">게시판 글수정 양식</th>	
					</tr>
				</thead>
				<tbody>
					<tr>
						<td><input type="text" class="form-control" placeholder="글 제목" name="kiTitle" maxlength="50" value="<%= ki.getKiTitle() %>"></td>
					</tr> 
					<tr>
						<td><textarea class="form-control" placeholder="글 내용" name="kiContent" maxlength="2048" style="height: 350px;"><%= ki.getKiContent() %>></textarea></td>
					</tr>
				</tbody>
			</table>	
			<input type="submit" class="btn btn-primary pull-right" value="글수정">			
		</form>
			
		</div>
	</div>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
