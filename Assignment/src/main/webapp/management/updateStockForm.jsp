<%-- 
    Document   : updateStockForm
    Created on : Apr 29, 2025, 12:35:14 AM
    Author     : AlexS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="../header.jsp"%>
<%@page import="java.util.ArrayList"%>
<%@page import="ict.bean.FruitBean"%>
<%@page import="ict.bean.LocationBean"%>
<%@page import="ict.bean.StockBean"%>
<%@page import="ict.db.StockDB"%>
<%@page import="ict.db.LocationDB"%>

<h1>Update Stock (Management)</h1>

<% 
    String dbUrl = application.getInitParameter("dbUrl");
    String dbUser = application.getInitParameter("dbUser");
    String dbPassword = application.getInitParameter("dbPassword");
    
    int fruitID = 0;
    if (request.getParameter("fruitID") != null) {
        fruitID = Integer.parseInt(request.getParameter("fruitID"));
    }
    
    int locationID = 0;
    if (request.getParameter("locationID") != null) {
        locationID = Integer.parseInt(request.getParameter("locationID"));
    } else {
        locationID = user.getLocationID(); // Default to user's location
    }
    
    StockDB stockDB = new StockDB(dbUrl, dbUser, dbPassword);
    LocationDB locationDB = new LocationDB(dbUrl, dbUser, dbPassword);
    StockBean currentStock = null;
    
    if (fruitID > 0 && locationID > 0) {
        currentStock = stockDB.getStockByLocationAndFruit(locationID, fruitID);
    }
    
    // Get the location for the form
    ArrayList<LocationBean> locations = locationDB.queryLocation();
%>

<form action="<%=request.getContextPath()%>/stock" method="post">
    <input type="hidden" name="action" value="update">
    
    <div class="form-group">
        <label for="locationID">Location:</label>
        <select id="locationID" name="locationID" required <%= (locationID > 0) ? "disabled" : "" %>>
            <option value="">Select Location</option>
            <% 
                if (locations != null) {
                    for (LocationBean location : locations) {
            %>
                <option value="<%= location.getLocationID() %>" <%= (locationID == location.getLocationID()) ? "selected" : "" %>><%= location.getName() %></option>
            <% 
                    }
                }
            %>
        </select>
        <% if (locationID > 0) { %>
            <input type="hidden" name="locationID" value="<%= locationID %>">
        <% } %>
    </div>
    
    <div class="form-group">
        <label for="fruitID">Fruit:</label>
        <select id="fruitID" name="fruitID" required <%= (fruitID > 0) ? "disabled" : "" %>>
            <option value="">Select Fruit</option>
            <% 
                ArrayList<FruitBean> fruits = (ArrayList<FruitBean>) request.getAttribute("fruits");
                if (fruits != null) {
                    for (FruitBean fruit : fruits) {
            %>
                <option value="<%= fruit.getFruitID() %>" <%= (fruitID == fruit.getFruitID()) ? "selected" : "" %>><%= fruit.getName() %></option>
            <% 
                    }
                }
            %>
        </select>
        <% if (fruitID > 0) { %>
            <input type="hidden" name="fruitID" value="<%= fruitID %>">
        <% } %>
    </div>
    
    <div class="form-group">
        <label for="quantity">Quantity:</label>
        <input type="number" id="quantity" name="quantity" min="0" value="<%= (currentStock != null) ? currentStock.getQuantity() : 0 %>" required>
    </div>
    
    <div style="margin-top: 20px;">
        <button type="submit" class="btn">Update Stock</button>
        <a href="<%=request.getContextPath()%>/stock?action=view" class="btn" style="background-color: #ccc; color: #333;">Cancel</a>
    </div>
</form>

<%@include file="../footer.jsp"%> 