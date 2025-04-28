<%-- 
    Document   : confirmStockUpdate
    Created on : Apr 29, 2025, 12:45:47 AM
    Author     : AlexS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="../header.jsp"%>

<h1>Confirm Stock Update</h1>

<%
    Integer fruitID = (Integer) request.getAttribute("fruitID");
    Integer locationID = (Integer) request.getAttribute("locationID");
    Integer quantity = (Integer) request.getAttribute("quantity");
    String fruitName = (String) request.getAttribute("fruitName");
    String locationName = (String) request.getAttribute("locationName");
    Integer currentQuantity = (Integer) request.getAttribute("currentQuantity");
    
    if (fruitID == null || locationID == null || quantity == null || fruitName == null || locationName == null || currentQuantity == null) {
        response.sendRedirect(request.getContextPath() + "/stock?action=view");
        return;
    }
%>

<div style="background-color: #fff3cd; color: #856404; padding: 15px; margin-bottom: 20px; border-radius: 5px; border-left: 5px solid #ffeeba;">
    <h3 style="margin-top: 0;">Please Confirm</h3>
    <p>You are about to update the stock of <strong><%= fruitName %></strong> at <strong><%= locationName %></strong>:</p>
    <ul>
        <li>Current quantity: <strong><%= currentQuantity %></strong></li>
        <li>New quantity: <strong><%= quantity %></strong></li>
        <li>Change: <strong><%= quantity - currentQuantity %></strong> units</li>
    </ul>
    <p>Are you sure you want to proceed with this update?</p>
</div>

<form action="<%=request.getContextPath()%>/stock" method="post" style="display: flex; gap: 10px;">
    <input type="hidden" name="action" value="update">
    <input type="hidden" name="fruitID" value="<%= fruitID %>">
    <input type="hidden" name="locationID" value="<%= locationID %>">
    <input type="hidden" name="quantity" value="<%= quantity %>">
    <input type="hidden" name="confirmed" value="true">
    
    <button type="submit" class="btn" style="background-color: #28a745; color: white;">Confirm Update</button>
    <a href="<%=request.getContextPath()%>/stock?action=view" class="btn" style="background-color: #dc3545; color: white;">Cancel</a>
</form>

<%@include file="../footer.jsp"%> 