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
import java.util.ArrayList;
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
        
        // Use ArrayLists to organize data by location
        ArrayList<String> locations = new ArrayList<>();
        ArrayList<ArrayList<String>> fruitNamesByLocation = new ArrayList<>();
        ArrayList<ArrayList<Integer>> quantitiesByLocation = new ArrayList<>();
        
        String currentLocation = "";
        ArrayList<String> currentFruitNames = null;
        ArrayList<Integer> currentQuantities = null;
        
        boolean hasData = false;
        while (rs.next()) {
            hasData = true;
            String fruitName = rs.getString("FruitName");
            int quantity = rs.getInt("TotalQuantity");
            String country = rs.getString("Country");
            String city = rs.getString("City");
            String locationStr = city + ", " + country;
            
            out.println("<tr>");
            out.println("<td>" + fruitName + "</td>");
            out.println("<td>" + quantity + "</td>");
            out.println("<td>" + country + "</td>");
            out.println("<td>" + city + "</td>");
            out.println("</tr>");
            
            // Group data by location for charts
            if (!locationStr.equals(currentLocation)) {
                currentLocation = locationStr;
                locations.add(currentLocation);
                currentFruitNames = new ArrayList<>();
                currentQuantities = new ArrayList<>();
                fruitNamesByLocation.add(currentFruitNames);
                quantitiesByLocation.add(currentQuantities);
            }
            
            // Add data to current location group
            currentFruitNames.add(fruitName);
            currentQuantities.add(quantity);
        }
        
        if (!hasData) {
            out.println("<tr><td colspan='4'>No reservation data available</td></tr>");
        }
        
        out.println("</table>");
        
        // Generate separate chart for each location if no specific location filter is applied
        if (hasData) {
            if (location == null || location.isEmpty()) {
                // Create container for multiple charts
                out.println("<div id='chartContainer' style='display: flex; flex-wrap: wrap;'>");
                
                // Generate a chart for each location
                for (int i = 0; i < locations.size(); i++) {
                    String chartId = "reserveChart" + i;
                    out.println("<div id='" + chartId + "' style='width: 45%; height: 400px; margin: 10px;'></div>");
                    generateBarChart(out, fruitNamesByLocation.get(i), quantitiesByLocation.get(i), 
                                    "Fruit Reservation Needs - " + locations.get(i), "Quantity", chartId);
                }
                
                out.println("</div>");
            } else {
                // Single location filter applied, use the main chart container
                ArrayList<String> allFruitNames = new ArrayList<>();
                ArrayList<Integer> allQuantities = new ArrayList<>();
                
                // Flatten all the data for a single chart
                for (int i = 0; i < fruitNamesByLocation.size(); i++) {
                    allFruitNames.addAll(fruitNamesByLocation.get(i));
                    allQuantities.addAll(quantitiesByLocation.get(i));
                }
                
                generateBarChart(out, allFruitNames, allQuantities, 
                                "Fruit Reservation Needs - " + (location != null ? location : "All Locations"), 
                                "Quantity", "reportChart");
            }
        }
        
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
        
        // Use ArrayLists to organize data by location and season
        ArrayList<String> groupKeys = new ArrayList<>();  // Format: "Location - Season"
        ArrayList<ArrayList<String>> fruitNamesByGroup = new ArrayList<>();
        ArrayList<ArrayList<Integer>> quantitiesByGroup = new ArrayList<>();
        
        String currentGroup = "";
        ArrayList<String> currentFruitNames = null;
        ArrayList<Integer> currentQuantities = null;
        
        boolean hasData = false;
        while (rs.next()) {
            hasData = true;
            String fruitName = rs.getString("FruitName");
            int quantity = rs.getInt("TotalQuantity");
            String country = rs.getString("Country");
            String city = rs.getString("City");
            String season = rs.getString("Season");
            String locationStr = city + ", " + country;
            String groupKey;
            
            // Determine how to group based on applied filters
            if (location == null || location.isEmpty()) {
                if (period == null || period.isEmpty()) {
                    // No filters - group by both location and season
                    groupKey = locationStr + " - " + season;
                } else {
                    // Only period filter - group by location
                    groupKey = locationStr;
                }
            } else {
                if (period == null || period.isEmpty()) {
                    // Only location filter - group by season
                    groupKey = season;
                } else {
                    // Both filters - single group
                    groupKey = locationStr + " - " + season;
                }
            }
            
            out.println("<tr>");
            out.println("<td>" + fruitName + "</td>");
            out.println("<td>" + quantity + "</td>");
            out.println("<td>" + country + "</td>");
            out.println("<td>" + city + "</td>");
            out.println("<td>" + season + "</td>");
            out.println("</tr>");
            
            // Group data for charts
            if (!groupKey.equals(currentGroup)) {
                currentGroup = groupKey;
                groupKeys.add(currentGroup);
                currentFruitNames = new ArrayList<>();
                currentQuantities = new ArrayList<>();
                fruitNamesByGroup.add(currentFruitNames);
                quantitiesByGroup.add(currentQuantities);
            }
            
            // Add data to current group
            currentFruitNames.add(fruitName);
            currentQuantities.add(quantity);
        }
        
        if (!hasData) {
            out.println("<tr><td colspan='5'>No consumption data available</td></tr>");
        }
        
        out.println("</table>");
        
        // Generate charts if data is available
        if (hasData) {
            if ((location == null || location.isEmpty() || period == null || period.isEmpty()) 
                    && groupKeys.size() > 1) {
                // Create container for multiple charts
                out.println("<div id='chartContainer' style='display: flex; flex-wrap: wrap;'>");
                
                // Generate a chart for each group
                for (int i = 0; i < groupKeys.size(); i++) {
                    String chartId = "consumptionChart" + i;
                    out.println("<div id='" + chartId + "' style='width: 45%; height: 400px; margin: 10px;'></div>");
                    generateBarChart(out, fruitNamesByGroup.get(i), quantitiesByGroup.get(i), 
                                    "Fruit Consumption - " + groupKeys.get(i), "Quantity", chartId);
                }
                
                out.println("</div>");
            } else {
                // Single group (both filters applied), use the main chart container
                ArrayList<String> allFruitNames = new ArrayList<>();
                ArrayList<Integer> allQuantities = new ArrayList<>();
                
                // Flatten all the data for a single chart
                for (int i = 0; i < fruitNamesByGroup.size(); i++) {
                    allFruitNames.addAll(fruitNamesByGroup.get(i));
                    allQuantities.addAll(quantitiesByGroup.get(i));
                }
                
                String title = "Fruit Consumption";
                if (location != null && !location.isEmpty()) {
                    title += " - " + location;
                }
                if (period != null && !period.isEmpty()) {
                    title += " in " + period;
                }
                
                generateBarChart(out, allFruitNames, allQuantities, title, "Quantity", "reportChart");
            }
        }
        
        rs.close();
        pstmt.close();
    }
    
    private void generateBarChart(JspWriter out, ArrayList<String> categories, ArrayList<Integer> values, 
                                  String title, String yAxisLabel, String chartId) throws IOException {
        if (categories.isEmpty() || values.isEmpty()) {
            return;
        }
        
        StringBuilder categoriesJson = new StringBuilder("[");
        for (int i = 0; i < categories.size(); i++) {
            if (i > 0) categoriesJson.append(", ");
            categoriesJson.append("'").append(categories.get(i)).append("'");
        }
        categoriesJson.append("]");
        
        StringBuilder valuesJson = new StringBuilder("[");
        for (int i = 0; i < values.size(); i++) {
            if (i > 0) valuesJson.append(", ");
            valuesJson.append(values.get(i));
        }
        valuesJson.append("]");
        
        // Output ECharts JavaScript
        out.println("<script>");
        out.println("document.addEventListener('DOMContentLoaded', function() {");
        out.println("    var chartDom = document.getElementById('" + chartId + "');");
        out.println("    var myChart = echarts.init(chartDom);");
        out.println("    var option = {");
        out.println("        title: {");
        out.println("            text: '" + title + "',");
        out.println("            left: 'center'");
        out.println("        },");
        out.println("        tooltip: {");
        out.println("            trigger: 'axis',");
        out.println("            axisPointer: {");
        out.println("                type: 'shadow'");
        out.println("            }");
        out.println("        },");
        out.println("        grid: {");
        out.println("            left: '3%',");
        out.println("            right: '4%',");
        out.println("            bottom: '3%',");
        out.println("            containLabel: true");
        out.println("        },");
        out.println("        xAxis: [");
        out.println("            {");
        out.println("                type: 'category',");
        out.println("                data: " + categoriesJson.toString() + ",");
        out.println("                axisTick: {");
        out.println("                    alignWithLabel: true");
        out.println("                },");
        out.println("                axisLabel: {");
        out.println("                    rotate: 45,");
        out.println("                    interval: 0");
        out.println("                }");
        out.println("            }");
        out.println("        ],");
        out.println("        yAxis: [");
        out.println("            {");
        out.println("                type: 'value',");
        out.println("                name: '" + yAxisLabel + "'");
        out.println("            }");
        out.println("        ],");
        out.println("        series: [");
        out.println("            {");
        out.println("                name: '" + yAxisLabel + "',");
        out.println("                type: 'bar',");
        out.println("                barWidth: '60%',");
        out.println("                data: " + valuesJson.toString() + ",");
        out.println("                itemStyle: {");
        out.println("                    color: function(params) {");
        out.println("                        var colorList = ['#c23531','#2f4554','#61a0a8','#d48265','#91c7ae','#749f83','#ca8622','#bda29a','#6e7074','#546570'];");
        out.println("                        return colorList[params.dataIndex % colorList.length];");
        out.println("                    }");
        out.println("                }");
        out.println("            }");
        out.println("        ]");
        out.println("    };");
        out.println("    myChart.setOption(option);");
        out.println("});");
        out.println("</script>");
    }
}