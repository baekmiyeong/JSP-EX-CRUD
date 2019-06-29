package ki;

public class Ki {
	//게시판 DB Beans 생성
	private int kiID;
	private String kiTitle;
	private String userID;
	private String kiDate;
	private String kiContent;
	private int kiAvailable;
	public int getKiID() {
		return kiID;
	}
	public void setKiID(int kiID) {
		this.kiID = kiID;
	}
	public void setKiAvailable(int kiAvailable) {
		this.kiAvailable = kiAvailable;
	}
	public String getKiTitle() {
		return kiTitle;
	}
	public void setKiTitle(String kiTitle) {
		this.kiTitle = kiTitle;
	}
	public String getUserID() {
		return userID;
	}
	public void setUserID(String userID) {
		this.userID = userID;
	}
	public String getKiDate() {
		return kiDate;
	}
	public void setKiDate(String kiDate) {
		this.kiDate = kiDate;
	}
	public String getKiContent() {
		return kiContent;
	}
	public void setKiContent(String kiContent) {
		this.kiContent = kiContent;
	}
	public int getKiAvailable() {
		return kiAvailable;
	}
	
}
