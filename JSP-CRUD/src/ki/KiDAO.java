package ki;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class KiDAO {
	//DB에 접근해서 데이터 가져오는 DAO
	private Connection conn;
	private ResultSet rs; 
	
	public KiDAO() {  //mysql접속 하는
		try {
			String dbUrl = "jdbc:mysql://localhost:3306/Ki?serverTimezone=UTC";
			String dbID = "root";
			String dbPassword = "1234";
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection(dbUrl,dbID,dbPassword);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	//글 작성시 현재 시간을 가지고오는 함수
	public String getDate() {
		String SQL = "SELECT NOW()";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery(); //실행했을시 결과를 가지고 온다
			if(rs.next()) {
				return rs.getString(1); // 현재 날짜 반환
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return ""; //데이터베이스 오류
	}
	
	public int getNext() {
		String SQL = "SELECT kiID FROM ki ORDER BY kiID DESC";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery(); //실행했을시 결과를 가지고 온다
			if(rs.next()) {
				return rs.getInt(1) +1; // 1을더해서 게시물 번호가 붙을수 있게 
			}
			return 1; //첫번째 게시물은 1
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; //데이터베이스 오류
	}
	
	public int write(String kiTitle, String userID, String kiContent) {
		String SQL = "INSERT INTO KI VALUEs(?,?,?,?,?,?)";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext()); //첫번째가 kiID 이니까 getNext
			pstmt.setString(2, kiTitle);
			pstmt.setString(3, userID);
			pstmt.setString(4, getDate());
			pstmt.setString(5, kiContent);
			pstmt.setInt(6, 1); // 마지막은 available 이니가 1이 나온다 
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; //데이터베이스 오류
	}
	
	public ArrayList<Ki> getList(int pageNumber){
		// 10개 제한해서 10개까지
		String SQL = "SELECT *FROM KI WHERE kiID<? AND kiAvailable=1 ORDER BY kiID DESC LIMIT 10";
		ArrayList<Ki> list = new ArrayList<Ki>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext() - (pageNumber -1) *10 ); //getNext 다음번호니까  
			rs = pstmt.executeQuery(); //실행했을시 결과를 가지고 온다
			while(rs.next()) {
				Ki ki = new Ki();
				ki.setKiID(rs.getInt(1));
				ki.setKiTitle(rs.getString(2));
				ki.setUserID(rs.getString(3));
				ki.setKiDate(rs.getString(4));
				ki.setKiContent(rs.getString(5));
				ki.setKiAvailable(rs.getInt(6));
				list.add(ki);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list; //데이터베이스 오류
	}
	
	// 10단위로 게시글이 끊기면 다음페이지라는 버튼이 없어야 하기때문에 페이징 처리를 위해서
	public boolean nextPage(int pageNumber) {
		String SQL = "SELECT *FROM KI WHERE kiID<? AND kiAvailable=1 ORDER BY kiID DESC LIMIT 10";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext() - (pageNumber -1) *10 ); //getNext 다음번호니까  
			rs = pstmt.executeQuery(); //실행했을시 결과를 가지고 온다
			if(rs.next()) {
				return true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false; //데이터베이스 오류
	}
	
	//하나의 글을 불러오는 메서드 추가
	public Ki getKi(int kiID) {
		String SQL = "SELECT *FROM ki WHERE kiID = ? ";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, kiID); //id값을 통해서 그번호를 보고 게시글 가지고 온다
			rs = pstmt.executeQuery(); 
			if(rs.next()) {
				Ki ki = new Ki();
				ki.setKiID(rs.getInt(1));
				ki.setKiTitle(rs.getString(2));
				ki.setUserID(rs.getString(3));
				ki.setKiDate(rs.getString(4));
				ki.setKiContent(rs.getString(5));
				ki.setKiAvailable(rs.getInt(6));
				return ki;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null; //글이 없다면 null
	}
	
	//글 수정함수
	public int update(int kiID, String kiTitle, String kiContent) {
		String SQL = "UPDATE KI SET kiTitle = ?, kiContent = ? WHERE kiID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, kiTitle); 
			pstmt.setString(2, kiContent);
			pstmt.setInt(3, kiID); 
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	//글을 삭제해도 정보를 남길수 있게 available값을 0으로 바꾸겠다.
	public int delete(int kiID) {
		String SQL = "UPDATE KI SET kiAvailable = 0 WHERE kiID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, kiID); 
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
}
