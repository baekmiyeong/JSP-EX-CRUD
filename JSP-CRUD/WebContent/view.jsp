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
<title>Insert title here</title>
</head>
<body>
	<%
		String userID = null;
		if(session.getAttribute("userID") != null){
			userID = (String)session.getAttribute("userID");
		}
		// 게시판에서 글을 눌렀을시 아이디 값이 넘어왔다면 view페이지 안에서는 이용해서 kiID에 담아서 사용
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
		Ki ki = new KiDAO().getKi(kiID);
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
			<!--아이디 값 확인해서 없으면 진행 아이디 값이 있으면 로그인되있는 사람들이 볼수 있는 페이지로 이동 -->
			<%
				if(userID == null) {
			%>	
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="botton" aria-haspopup="true"
						aria-expanded="false">접속하기<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="login.jsp">로그인</a>
						<li><a href="join.jsp">회원가입</a>
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
						aria-expanded="false">회원관리<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="logoutAction.jsp">로그아웃</a>
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
		<div class="row"> 
		<!-- 게시판 글쓰기 양식 -->
		<table class="table table-striped" style="text-align: center; border: ipx solid #dddddd">
				<thead>
					<tr>
						<th colspan="3"
							style="background-color: #eeeeee; text-align: center;">게시판 글 보기</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td style="width: 20%">글 제목</td>
						<!-- 크로스 사이트 스크립팅 공격을 방어하기 위해서 치환해줍니다 -->
						<td colspan="2"><%= ki.getKiTitle().replaceAll(" ", "&nbsp;").replaceAll("<","&lt;").replaceAll(">","&gt;").replaceAll("\n","<br>") %></td>
					</tr>
					<tr>
						<td>작성자</td>
						<td colspan="2"><%= ki.getUserID()%></td>
					</tr>
					<tr>
						<td>작성일자</td>
						<td colspan="2"><%= ki.getKiDate().substring(0,11)+ki.getKiDate().substring(11,13) +"시" +ki.getKiDate().substring(14,16) +"분"  %></td>
					</tr>
					<tr>
						<td>내용</td>
						<!-- 내용에서 특수문자들은 html이랑 헷갈리기 때문에 특수문자도 나오게 만듬 -->
						<td colspan="2" style="min-height: 200px; text-align: left;"><%= ki.getKiContent().replaceAll(" ", "&nbsp;").replaceAll("<","&lt;").replaceAll(">","&gt;").replaceAll("\n","<br>") %></td>
					</tr>
				</tbody>
			</table>
		<a href="bbs.jsp" class="btn btn-primary">목록</a>
		<!-- 해당작성자가 본인이라면 수정과 삭제가능하게 -->
		<%
			if(userID != null && userID.equals(ki.getUserID())) {
		%>
			<a href="update.jsp?kiID=<%= kiID %>" class="btn btn-primary">수정</a>
			<a onclick="return confirm('정말로 삭제하시겠습니까?')" href="deleteAction.jsp?kiID=<%= kiID %>" class="btn btn-primary">삭제</a>
		<% 
			}
		%>	
		<input type="submit" class="btn btn-primary pull-right" value="글쓰기">			
		</div>
	</div>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
