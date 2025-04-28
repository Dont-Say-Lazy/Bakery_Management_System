<%-- 
    Document   : updateStock
    Created on : Apr 23, 2025, 11:12:43 PM
    Author     : Rain
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="../header.jsp"%>
<%@page import="java.util.ArrayList"%>
<%@page import="ict.bean.StockBean"%>

<h1>Warehouse Stock Management</h1>

<%-- Display any messages --%>
<% if (request.getAttribute("message") != null) { %>
    <div style="background-color: #d4edda; color: #155724; padding: 10px; margin-bottom: 15px; border-radius: 5px;">
        <%= request.getAttribute("message") %>
    </div>
<% } %>

<div style="margin-bottom: 20px;">
    <a href="<%=request.getContextPath()%>/stock?action=showUpdateForm" class="btn">Update Stock</a>
</div>

<!-- Filter Form -->
<div class="filter-section" style="margin-bottom: 20px; padding: 15px; background-color: #f8f9fa; border-radius: 5px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
    <h3 style="margin-top: 0; margin-bottom: 15px; color: #333;">Filter Stock</h3>
    <form action="<%=request.getContextPath()%>/stock" method="get">
        <input type="hidden" name="action" value="filter">
        <div style="display: flex; flex-wrap: wrap; gap: 15px;">
            <div style="flex: 1; min-width: 200px;">
                <label for="fruitName" style="display: block; margin-bottom: 5px; font-weight: bold;">Fruit Name:</label>
                <input type="text" id="fruitName" name="fruitName" value="${filterFruitName}" placeholder="Filter by fruit name" style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;">
            </div>
            <div style="flex: 2; min-width: 200px; display: flex; gap: 15px;">
                <div style="flex: 1;">
                    <label for="quantityMin" style="display: block; margin-bottom: 5px; font-weight: bold;">Min Quantity:</label>
                    <input type="number" id="quantityMin" name="quantityMin" value="${filterQuantityMin}" placeholder="Minimum" min="0" style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;">
                </div>
                <div style="flex: 1;">
                    <label for="quantityMax" style="display: block; margin-bottom: 5px; font-weight: bold;">Max Quantity:</label>
                    <input type="number" id="quantityMax" name="quantityMax" value="${filterQuantityMax}" placeholder="Maximum" min="0" style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;">
                </div>
            </div>
            <div style="flex-basis: 100%; display: flex; justify-content: flex-end; margin-top: 10px;">
                <button type="submit" class="btn" style="background-color: #4CAF50; color: white; margin-right: 10px;">Apply Filter</button>
                <a href="<%=request.getContextPath()%>/stock?action=view" class="btn" style="background-color: #f44336; color: white;">Clear Filter</a>
            </div>
        </div>
    </form>
</div>

<h2>Current Stock</h2>

<table>
    <thead>
        <tr>
            <th>Fruit</th>
            <th>Quantity</th>
            <th>Last Updated</th>
            <th>Actions</th>
        </tr>
    </thead>
    <tbody>
        <% 
            ArrayList<StockBean> stocks = (ArrayList<StockBean>) request.getAttribute("stocks");
            if (stocks != null && !stocks.isEmpty()) {
                for (StockBean stock : stocks) {
        %>
        <tr>
            <td><%= stock.getFruitName() %></td>
            <td><%= stock.getQuantity() %></td>
            <td><%= stock.getLastUpdated() %></td>
            <td>
                <a href="<%=request.getContextPath()%>/stock?action=showUpdateForm&fruitID=<%= stock.getFruitID() %>" class="btn">Update</a>
                <a href="<%=request.getContextPath()%>/stock?action=checkIn&fruitID=<%= stock.getFruitID() %>&quantity=10" class="btn" style="background-color: green;">Check In (+10)</a>
                <a href="<%=request.getContextPath()%>/stock?action=checkOut&fruitID=<%= stock.getFruitID() %>&quantity=10" class="btn btn-danger">Check Out (-10)</a>
            </td>
        </tr>
        <% 
                }
            } else {
        %>
        <tr>
            <td colspan="4">No stock data available</td>
        </tr>
        <% } %>
    </tbody>
</table>

<%@include file="../footer.jsp"%>