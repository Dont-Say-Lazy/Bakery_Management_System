<%-- 
    Document   : updateStockForm
    Created on : Apr 23, 2025, 11:12:27 PM
    Author     : AlexS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="../header.jsp"%>
<%@page import="java.util.ArrayList"%>
<%@page import="ict.bean.FruitBean"%>
<%@page import="ict.bean.StockBean"%>
<%@page import="ict.db.StockDB"%>

<div style="max-width: 800px; margin: 0 auto; padding: 20px;">
    <h1 style="color: #4DD0C5; border-bottom: 2px solid #4DD0C5; padding-bottom: 10px; margin-bottom: 20px;">Confirm Stock Update</h1>

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
        
        // Determine the fruit name if a fruit is selected
        String fruitName = "";
        if (fruitID > 0) {
            ArrayList<FruitBean> fruits = (ArrayList<FruitBean>) request.getAttribute("fruits");
            if (fruits != null) {
                for (FruitBean fruit : fruits) {
                    if (fruit.getFruitID() == fruitID) {
                        fruitName = fruit.getName();
                        break;
                    }
                }
            }
        }
        
        // Calculate change in quantity if form is submitted with a new quantity
        String newQuantityStr = request.getParameter("quantity");
        int newQuantity = (currentStock != null) ? currentStock.getQuantity() : 0;
        if (newQuantityStr != null && !newQuantityStr.isEmpty()) {
            try {
                newQuantity = Integer.parseInt(newQuantityStr);
            } catch (NumberFormatException e) {
                // Use default if parsing fails
            }
        }
        int change = (currentStock != null) ? newQuantity - currentStock.getQuantity() : newQuantity;
    %>

    <% if (fruitID > 0 && currentStock != null) { %>
    <div style="background-color: #FFF8E1; padding: 20px; margin-bottom: 20px; border-radius: 5px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
        <h3 style="margin-top: 0; color: #8B6914; font-size: 1.3em;">Please Confirm</h3>
        <p>You are about to update the stock of <strong><%= fruitName %></strong>:</p>
        <ul style="padding-left: 20px;">
            <li>Current quantity: <strong><%= currentStock.getQuantity() %></strong></li>
            <li>New quantity: <strong><%= newQuantity %></strong></li>
            <li>Change: <strong><%= change %></strong> units</li>
        </ul>
        <p>Are you sure you want to proceed with this update?</p>
    </div>

    <form action="<%=request.getContextPath()%>/stock" method="post" style="display: inline-block; margin-right: 10px;">
        <input type="hidden" name="action" value="update">
        <input type="hidden" name="fruitID" value="<%= fruitID %>">
        <input type="hidden" name="quantity" value="<%= newQuantity %>">
        <button type="submit" class="btn" style="background-color: #28a745; color: white; border-radius: 50px; padding: 10px 30px; border: none; font-size: 16px;">Confirm Update</button>
    </form>
    <a href="<%=request.getContextPath()%>/stock?action=view" class="btn" style="background-color: #dc3545; color: white; border-radius: 50px; padding: 10px 30px; text-decoration: none; display: inline-block; text-align: center; font-size: 16px;">Cancel</a>
    <% } else { %>
    <div style="background-color: #f8f9fa; padding: 20px; margin-bottom: 20px; border-radius: 5px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
        <h3 style="margin-top: 0; color: #333;">Select Fruit to Update</h3>
        <form action="<%=request.getContextPath()%>/stock" method="post">
            <input type="hidden" name="action" value="update">

            <div style="margin-bottom: 15px;">
                <label for="fruitID" style="display: block; margin-bottom: 5px; font-weight: bold;">Fruit:</label>
                <select id="fruitID" name="fruitID" required style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px;">
                    <option value="">Select Fruit</option>
                    <%
                        ArrayList<FruitBean> fruits = (ArrayList<FruitBean>) request.getAttribute("fruits");
                        if (fruits != null) {
                            for (FruitBean fruit : fruits) {
                    %>
                    <option value="<%= fruit.getFruitID()%>"><%= fruit.getName()%></option>
                    <%
                            }
                        }
                    %>
                </select>
            </div>

            <div style="margin-bottom: 15px;">
                <label for="quantity" style="display: block; margin-bottom: 5px; font-weight: bold;">Quantity:</label>
                <input type="number" id="quantity" name="quantity" min="0" value="0" required style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px;">
            </div>

            <div style="margin-top: 20px;">
                <button type="submit" class="btn" style="background-color: #28a745; color: white; border-radius: 50px; padding: 10px 30px; border: none; font-size: 16px;">Update Stock</button>
                <a href="<%=request.getContextPath()%>/stock?action=view" class="btn" style="background-color: #dc3545; color: white; border-radius: 50px; padding: 10px 30px; text-decoration: none; display: inline-block; text-align: center; margin-left: 10px; font-size: 16px;">Cancel</a>
            </div>
        </form>
    </div>
    <% } %>
</div>

<%@include file="../footer.jsp"%>
