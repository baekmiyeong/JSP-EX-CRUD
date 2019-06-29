<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>    
<%@ page import="ki.KiDAO"%>  
<%@ page import="ki.Ki"%>  
<%@ page import="java.util.ArrayList"%>  
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width",initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<title>JSP 掲示板</title>
<style type="text/css">
	a,a:hover {
	color: #000000;
	text-decoration: none;
	}
</style>
</head>
<body>
	<%
		String userID = null;
		if(session.getAttribute("userID") != null){
			userID = (String)session.getAttribute("userID");
		}
		int pageNumber =1; // 기본페이지 숫자
		if(request.getParameter("pageNumber") != null) {
			pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
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
				<a class="navbar-brand" href="main.jsp">JSP 掲示板</a>
		</div>
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li><a href="main.jsp">메인</a></li>
				<li class="active"><a href="bbs.jsp">掲示板</a></li>
			</ul>
			<!--아이디 값 확인해서 없으면 진행 아이디 값이 있으면 로그인되있는 사람들이 볼수 있는 페이지로 이동 -->
			<%
				if(userID == null) {
			%>	
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="botton" aria-haspopup="true"
						aria-expanded="false">Enter<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="login.jsp">Login</a>
						<li><a href="join.jsp">Sign</a>
					</ul>
				</li>
			</ul>
			<%
				} else {
		
			%>
			
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="botton" aria-haspopup="true"
						aria-expanded="false">会員管理<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="logoutAction.jsp">Logout</a>
					</ul>
				</li>
			</ul>
			<%
				}
			%>
			
				
		</div>
	</nav>
	<!-- 게시판 만들기 -->
	<div class="container">
		<div class="row"> <!-- table들어갈수 있는 공간을 만든다 -->
		<!-- 홀수 짝수 색 다르게변경, 회색 -->
			<table class="table table-striped" style="text-align: center; border: ipx solid #dddddd">
				<thead> <!-- 테이블 제목 -->
					<tr>
						<th style="background-color: #eeeeee; text-align: center;">No</th>
						<th style="background-color: #eeeeee; text-align: center;">Title</th>
						<th style="background-color: #eeeeee; text-align: center;">Name</th>
						<th style="background-color: #eeeeee; text-align: center;">Date</th>
					</tr>
				</thead>
				<tbody>
					<%
						KiDAO kiDAO = new KiDAO();
						ArrayList<Ki> list = kiDAO.getList(pageNumber);
						for(int i=0; i <list.size(); i++){
					%>
					<tr>
						<td><%= list.get(i).getKiID() %></td>
						<!-- 크로스 사이트 스크립팅 공격을 방어하기 위해서 치환해줍니다 -->
						<td><a href="view.jsp?kiID=<%= list.get(i).getKiID() %>"><%= list.get(i).getKiTitle().replaceAll(" ", "&nbsp;").replaceAll("<","&lt;").replaceAll(">","&gt;").replaceAll("\n","<br>")%></a></td>
						<td><%= list.get(i).getUserID() %></td>
						<td><%= list.get(i).getKiDate().substring(0,11)+list.get(i).getKiDate().substring(11,13) +"시" +list.get(i).getKiDate().substring(14,16) +"분" %></td>
					</tr>
					<%
						}
					%>
					
				</tbody>
			</table>
			<%-- 게시판 메인페이지에 이전 버튼과 다음 버튼 --%>
			<%
				if(pageNumber != 1) {
			%>
				<a href="bbs.jsp?pageNumber=<%= pageNumber-1%>" class="btn btn-success btn-arrow-left">이전</a>
			<% 	
				} if(kiDAO.nextPage(pageNumber)) {
			%>			
				<a href="bbs.jsp?pageNumber=<%= pageNumber+1%>" class="btn btn-success btn-arrow-left">다음</a>
			<%
				}	
			%>
			<a href="write.jsp" class="btn btn-primary pull-right">Write</a> <!-- 오른쪽 글쓰기 버튼 고정 -->
		</div>
	</div>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
