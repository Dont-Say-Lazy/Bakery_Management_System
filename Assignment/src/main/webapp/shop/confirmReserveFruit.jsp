<%-- 
    Document   : confirmReserveFruit
    Created on : May 21, 2025
    Author     : User
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="../header.jsp"%>

<h1>Confirm Fruit Reservation</h1>

<div style="background-color: #d4edda; color: #155724; padding: 10px; margin-bottom: 15px; border-radius: 5px;">
    Please confirm that you want to reserve the following fruit:
</div>

<div style="margin-bottom: 20px; padding: 15px; background-color: #f8f9fa; border-radius: 5px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
    <p><strong>Fruit:</strong> <%= request.getAttribute("fruitName") %></p>
    <p><strong>Quantity:</strong> <%= request.getAttribute("quantity") %></p>
    <p><strong>Delivery Date:</strong> <%= request.getAttribute("deliveryDate") %></p>
    <p><strong>Warehouse:</strong> <%= request.getAttribute("warehouseName") %></p>
</div>

<form action="<%= request.getContextPath() %>/reservation" method="post">
    <input type="hidden" name="action" value="add">
    <input type="hidden" name="fruitID" value="<%= request.getAttribute("fruitID") %>">
    <input type="hidden" name="quantity" value="<%= request.getAttribute("quantity") %>">
    <input type="hidden" name="deliveryDate" value="<%= request.getAttribute("deliveryDate") %>">
    <input type="hidden" name="warehouseID" value="<%= request.getAttribute("warehouseID") %>">
    
    <div style="display: flex; gap: 10px;">
        <button type="submit" class="btn" style="background-color: #4CAF50; color: white;">Confirm</button>
        <a href="<%= request.getContextPath() %>/reservation?action=showAddForm" class="btn" style="background-color: #f44336; color: white;">Cancel</a>
    </div>
</form>

<%@include file="../footer.jsp"%> 