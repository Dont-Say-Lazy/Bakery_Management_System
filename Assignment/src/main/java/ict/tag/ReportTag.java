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

public class ReportTag extends SimpleTagSupport {
    private String type;
    private String location;
    private String period;
    
    public void setType(String type) {
        this.type = type;
    }
    
    public void setLocation(String location) {
        this.location = location;
    }
    
    public void setPeriod(String period) {
        this.period = period;
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
            
            if ("reserveNeeds".equals(type)) {
                generateReserveNeedsReport(conn, out);
            } else if ("consumption".equals(type)) {
                generateConsumptionReport(conn, out);
            } else {
                out.println("<p>Invalid report type specified.</p>");
            }
            
            conn.close();
        } catch (SQLException ex) {
            out.println("Error generating report: " + ex.getMessage());
        }
    }
    
    private void generateReserveNeedsReport(Connection conn, JspWriter out) throws SQLException, IOException {
        String query = "SELECT f.Name as FruitName, SUM(r.Quantity) as TotalQuantity, " +
                      "l.Country as Country, l.City as City " +
                      "FROM Reservations r " +
                      "JOIN Fruits f ON r.FruitID = f.FruitID " +
                      "JOIN Locations l ON r.ShopLocationID = l.LocationID ";
        
        // Filter by location if specified
        if (location != null && !location.isEmpty()) {
            if (location.matches("\\d+")) {
                // Location ID provided
                query += "WHERE r.ShopLocationID = " + location + " ";
            } else if (location.contains(",")) {
                // City and country provided
                String[] parts = location.split(",");
                if (parts.length == 2) {
                    query += "WHERE l.City = '" + parts[0].trim() + "' AND l.Country = '" + parts[1].trim() + "' ";
                }
            } else {
                // Country provided
                query += "WHERE l.Country = '" + location + "' ";
            }
        }
        
        query += "GROUP BY f.Name, l.Country, l.City " +
                "ORDER BY l.Country, l.City, TotalQuantity DESC";
        
        PreparedStatement pstmt = conn.prepareStatement(query);
        ResultSet rs = pstmt.executeQuery();
        
        out.println("<h2>Fruit Reservation Needs Report</h2>");
        if (location != null && !location.isEmpty()) {
            out.println("<p>Filtered by location: " + location + "</p>");
        }
        
        out.println("<table border='1'>");
        out.println("<tr><th>Fruit</th><th>Total Quantity Needed</th><th>Country</th><th>City</th></tr>");
        
        boolean hasData = false;
        while (rs.next()) {
            hasData = true;
            out.println("<tr>");
            out.println("<td>" + rs.getString("FruitName") + "</td>");
            out.println("<td>" + rs.getInt("TotalQuantity") + "</td>");
            out.println("<td>" + rs.getString("Country") + "</td>");
            out.println("<td>" + rs.getString("City") + "</td>");
            out.println("</tr>");
        }
        
        if (!hasData) {
            out.println("<tr><td colspan='4'>No reservation data available</td></tr>");
        }
        
        out.println("</table>");
        
        rs.close();
        pstmt.close();
    }
    
    private void generateConsumptionReport(Connection conn, JspWriter out) throws SQLException, IOException {
        String query = "SELECT f.Name as FruitName, SUM(c.Quantity) as TotalQuantity, " +
                      "l.Country as Country, l.City as City, c.Season as Season " +
                      "FROM Consumption c " +
                      "JOIN Fruits f ON c.FruitID = f.FruitID " +
                      "JOIN Locations l ON c.LocationID = l.LocationID ";
        
        // Filter by location if specified
        if (location != null && !location.isEmpty()) {
            if (location.matches("\\d+")) {
                // Location ID provided
                query += "WHERE c.LocationID = " + location + " ";
            } else if (location.contains(",")) {
                // City and country provided
                String[] parts = location.split(",");
                if (parts.length == 2) {
                    query += "WHERE l.City = '" + parts[0].trim() + "' AND l.Country = '" + parts[1].trim() + "' ";
                }
            } else {
                // Country provided
                query += "WHERE l.Country = '" + location + "' ";
            }
            
            // Add period filter if both location and period are specified
            if (period != null && !period.isEmpty()) {
                query += "AND c.Season = '" + period + "' ";
            }
        } else if (period != null && !period.isEmpty()) {
            // Only period is specified
            query += "WHERE c.Season = '" + period + "' ";
        }
        
        query += "GROUP BY f.Name, l.Country, l.City, c.Season " +
                "ORDER BY l.Country, l.City, c.Season, TotalQuantity DESC";
        
        PreparedStatement pstmt = conn.prepareStatement(query);
        ResultSet rs = pstmt.executeQuery();
        
        out.println("<h2>Fruit Consumption Report</h2>");
        if (location != null && !location.isEmpty()) {
            out.println("<p>Filtered by location: " + location + "</p>");
        }
        if (period != null && !period.isEmpty()) {
            out.println("<p>Filtered by season: " + period + "</p>");
        }
        
        out.println("<table border='1'>");
        out.println("<tr><th>Fruit</th><th>Total Quantity Consumed</th><th>Country</th><th>City</th><th>Season</th></tr>");
        
        boolean hasData = false;
        while (rs.next()) {
            hasData = true;
            out.println("<tr>");
            out.println("<td>" + rs.getString("FruitName") + "</td>");
            out.println("<td>" + rs.getInt("TotalQuantity") + "</td>");
            out.println("<td>" + rs.getString("Country") + "</td>");
            out.println("<td>" + rs.getString("City") + "</td>");
            out.println("<td>" + rs.getString("Season") + "</td>");
            out.println("</tr>");
        }
        
        if (!hasData) {
            out.println("<tr><td colspan='5'>No consumption data available</td></tr>");
        }
        
        out.println("</table>");
        
        rs.close();
        pstmt.close();
    }
}