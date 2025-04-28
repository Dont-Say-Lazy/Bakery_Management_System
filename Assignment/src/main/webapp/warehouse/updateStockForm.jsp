<%-- 
    Document   : updateStockForm
    Created on : Apr 24, 2025, 1:12:27 AM
    Author     : Rain
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="../header.jsp"%>
<%@page import="java.util.ArrayList"%>
<%@page import="ict.bean.FruitBean"%>
<%@page import="ict.bean.StockBean"%>
<%@page import="ict.db.StockDB"%>

<h1>Update Warehouse Stock</h1>

<% 
    String dbUrl = application.getInitParameter("dbUrl");
    String dbUser = application.getInitParameter("dbUser");
    String dbPassword = application.getInitParameter("dbPassword");
    
    int fruitID = 0;
    if (request.getParameter("fruitID") != null) {
        fruitID = Integer.parseInt(request.getParameter("fruitID"));
    }
    
    StockDB stockDB = new StockDB(dbUrl, dbUser, dbPassword);
    StockBean currentStock = null;
    
    if (fruitID > 0) {
        currentStock = stockDB.getStockByLocationAndFruit(user.getLocationID(), fruitID);
    }
%>

<div style="background-color: #f8f9fa; padding: 15px; border-radius: 5px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); margin-bottom: 20px;">
    <form action="<%=request.getContextPath()%>/stock" method="post">
        <input type="hidden" name="action" value="update">
        
        <div class="form-group">
            <label for="fruitID" style="display: block; margin-bottom: 5px; font-weight: bold;">Fruit:</label>
            <select id="fruitID" name="fruitID" required <%= (fruitID > 0) ? "disabled" : ""%> style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;">
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
        
        <div class="form-group" style="margin-top: 15px;">
            <label for="quantity" style="display: block; margin-bottom: 5px; font-weight: bold;">Quantity:</label>
            <input type="number" id="quantity" name="quantity" min="0" value="<%= (currentStock != null) ? currentStock.getQuantity() : 0%>" required style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;">
        </div>
        
        <div style="margin-top: 20px;">
            <button type="submit" class="btn" style="background-color: #4CAF50; color: white;">Update Stock</button>
            <a href="<%=request.getContextPath()%>/stock?action=view" class="btn" style="background-color: #6c757d; color: white;">Cancel</a>
        </div>
    </form>
</div>

<%@include file="../footer.jsp"%> 