<%-- 
    Document   : updateStock
    Created on : Apr 23, 2025, 11:12:09 PM
    Author     : Rain
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="../header.jsp"%>
<%@page import="java.util.ArrayList"%>
<%@page import="ict.bean.StockBean"%>

<%
    ArrayList<StockBean> stocks = (ArrayList<StockBean>) request.getAttribute("stocks");
%>

<h1>Shop Stock Management</h1>

<%-- Display any messages --%>
<% if (request.getAttribute("message") != null) { %>
    <div style="background-color: #d4edda; color: #155724; padding: 10px; margin-bottom: 15px; border-radius: 5px;">
        <%= request.getAttribute("message") %>
    </div>
<% } %>

<div style="margin-bottom: 20px; display: flex; gap: 10px;">
    <a href="<%=request.getContextPath()%>/stock?action=showUpdateForm" class="btn">Update Stock</a>
</div>

<!-- Quick Stock Adjustment Form -->
<div class="quick-adjust-section" style="margin-bottom: 20px; padding: 15px; background-color: #f8f9fa; border-radius: 5px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
    <h3 style="margin-top: 0; margin-bottom: 15px; color: #333;">Quick Stock Adjustment</h3>
    <form action="<%=request.getContextPath()%>/stock" method="post" style="display: flex; flex-wrap: wrap; gap: 15px; align-items: flex-end;">
        <div style="flex: 1; min-width: 200px;">
            <label for="quickFruitID" style="display: block; margin-bottom: 5px; font-weight: bold;">Fruit:</label>
            <select id="quickFruitID" name="fruitID" required style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;">
                <option value="">Select Fruit</option>
                <% 
                    if (stocks != null && !stocks.isEmpty()) {
                        for (StockBean stock : stocks) {
                %>
                <option value="<%= stock.getFruitID() %>"><%= stock.getFruitName() %> (Current: <%= stock.getQuantity() %>)</option>
                <% 
                        }
                    }
                %>
            </select>
        </div>
        <div style="flex: 1; min-width: 120px;">
            <label for="quickQuantity" style="display: block; margin-bottom: 5px; font-weight: bold;">Quantity:</label>
            <input type="number" id="quickQuantity" name="quantity" min="1" value="1" required style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;">
        </div>
        <div style="flex: 1; min-width: 120px; display: flex; gap: 10px;">
            <button type="submit" name="action" value="checkIn" class="btn" style="flex: 1; background-color: #f8f9fa; color: #28a745; border: 1px solid #28a745;">Check In</button>
            <button type="submit" name="action" value="checkOut" class="btn" style="flex: 1; background-color: #f8f9fa; color: #dc3545; border: 1px solid #dc3545;">Check Out</button>
        </div>
    </form>
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
                <button type="submit" class="btn" style="background-color: #f8f9fa; color: #4CAF50; border: 1px solid #4CAF50; margin-right: 10px;">Apply Filter</button>
                <a href="<%=request.getContextPath()%>/stock?action=view" class="btn" style="background-color: #f8f9fa; color: #f44336; border: 1px solid #f44336;">Clear Filter</a>
            </div>
        </div>
    </form>
</div>

<div style="background-color: #f8f9fa; padding: 15px; border-radius: 5px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
    <h2 style="margin-top: 0; margin-bottom: 15px; color: #333;">Current Stock</h2>

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
                if (stocks != null && !stocks.isEmpty()) {
                    for (StockBean stock : stocks) {
            %>
            <tr>
                <td><%= stock.getFruitName() %></td>
                <td><%= stock.getQuantity() %></td>
                <td><%= stock.getLastUpdated() %></td>
                <td style="display: flex; gap: 5px;">
                    <a href="<%=request.getContextPath()%>/stock?action=showUpdateForm&fruitID=<%= stock.getFruitID() %>" class="btn" style="background-color: #f8f9fa; color: #333; border: 1px solid #ccc;">Update</a>
                    
                    <!-- Check-in button with form -->
                    <form action="<%=request.getContextPath()%>/stock" method="post" style="display: inline;">
                        <input type="hidden" name="action" value="checkIn">
                        <input type="hidden" name="fruitID" value="<%= stock.getFruitID() %>">
                        <input type="hidden" name="quantity" value="1">
                        <button type="submit" class="btn" style="background-color: #f8f9fa; color: #28a745; border: 1px solid #28a745;">+</button>
                    </form>
                    
                    <!-- Check-out button with form -->
                    <form action="<%=request.getContextPath()%>/stock" method="post" style="display: inline;">
                        <input type="hidden" name="action" value="checkOut">
                        <input type="hidden" name="fruitID" value="<%= stock.getFruitID() %>">
                        <input type="hidden" name="quantity" value="1">
                        <button type="submit" class="btn" style="background-color: #f8f9fa; color: #dc3545; border: 1px solid #dc3545;" <%= stock.getQuantity() < 1 ? "disabled" : "" %>>-</button>
                    </form>
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
</div>

<%@include file="../footer.jsp"%>
