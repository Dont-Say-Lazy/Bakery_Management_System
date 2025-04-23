/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ict.tag;

/**
 *
 * @author Rain
 */
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.tagext.SimpleTagSupport;
import ict.db.DBConnection;

public class StockLevelTag extends SimpleTagSupport {
    private int locationID;
    
    public void setLocationID(int locationID) {
        this.locationID = locationID;
    }
    
    @Override
    public void doTag() throws JspException, IOException {
        PageContext pageContext = (PageContext) getJspContext();
        JspWriter out = pageContext.getOut();
        
        String dbUrl = pageContext.getServletContext().getInitParameter("dbUrl");
        String dbUser = pageContext.getServletContext().getInitParameter("dbUser");
        String dbPassword = pageContext.getServletContext().getInitParameter("dbPassword");
        
        DBConnection dbConnection = new DBConnection(dbUrl, dbUser, dbPassword);
        
        try {
            Connection conn = dbConnection.getConnection();
            String query = "SELECT f.Name, s.Quantity FROM Stock s " +
                           "JOIN Fruits f ON s.FruitID = f.FruitID " +
                           "WHERE s.LocationID = ?";
            
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, locationID);
            ResultSet rs = pstmt.executeQuery();
            
            out.println("<table border='1'>");
            out.println("<tr><th>Fruit</th><th>Quantity</th></tr>");
            
            boolean hasData = false;
            while (rs.next()) {
                hasData = true;
                out.println("<tr>");
                out.println("<td>" + rs.getString("Name") + "</td>");
                out.println("<td>" + rs.getInt("Quantity") + "</td>");
                out.println("</tr>");
            }
            
            if (!hasData) {
                out.println("<tr><td colspan='2'>No stock data available</td></tr>");
            }
            
            out.println("</table>");
            
            rs.close();
            pstmt.close();
            conn.close();
        } catch (SQLException ex) {
            out.println("Error: " + ex.getMessage());
        }
    }
}
