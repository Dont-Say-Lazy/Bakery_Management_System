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
<div class="filter-section" style="margin-bottom: 20px; padding: 15px; background-color: #f8f9fa; border-radius: 5px;">
    <h3>Filter Stock</h3>
    <form action="<%=request.getContextPath()%>/stock" method="get">
        <input type="hidden" name="action" value="filter">
        <div style="display: flex; flex-wrap: wrap; gap: 10px;">
            <div>
                <label for="fruitName">Fruit Name:</label>
                <input type="text" id="fruitName" name="fruitName" value="${filterFruitName}" placeholder="Filter by fruit name">
            </div>
            <div>
                <label for="quantityMin">Min Quantity:</label>
                <input type="number" id="quantityMin" name="quantityMin" value="${filterQuantityMin}" placeholder="Minimum" min="0">
            </div>
            <div>
                <label for="quantityMax">Max Quantity:</label>
                <input type="number" id="quantityMax" name="quantityMax" value="${filterQuantityMax}" placeholder="Maximum" min="0">
            </div>
            <div style="align-self: flex-end;">
                <button type="submit" class="btn">Apply Filter</button>
                <a href="<%=request.getContextPath()%>/stock?action=view" class="btn">Clear Filter</a>
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