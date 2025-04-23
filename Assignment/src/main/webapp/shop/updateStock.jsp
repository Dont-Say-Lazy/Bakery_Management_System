<%-- 
    Document   : updateStock
    Created on : Apr 23, 2025, 11:12:09 PM
    Author     : Rain
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="../header.jsp"%>
<%@page import="java.util.ArrayList"%>
<%@page import="ict.bean.StockBean"%>

<h1>Shop Stock Management</h1>

<%-- Display any messages --%>
<% if (request.getAttribute("message") != null) { %>
    <div style="background-color: #d4edda; color: #155724; padding: 10px; margin-bottom: 15px; border-radius: 5px;">
        <%= request.getAttribute("message") %>
    </div>
<% } %>

<div style="margin-bottom: 20px;">
    <a href="<%=request.getContextPath()%>/stock?action=showUpdateForm" class="btn">Update Stock</a>
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
