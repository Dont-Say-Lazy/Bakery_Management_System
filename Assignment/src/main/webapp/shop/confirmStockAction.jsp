<%-- 
    Document   : confirmStockAction
    Created on : Apr 28, 2025, 11:28:54 PM
    Author     : AlexS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="../header.jsp"%>

<h1>Confirm Stock Action</h1>

<%
    Integer fruitID = (Integer) request.getAttribute("fruitID");
    Integer quantity = (Integer) request.getAttribute("quantity");
    String fruitName = (String) request.getAttribute("fruitName");
    String locationName = (String) request.getAttribute("locationName");
    Integer currentQuantity = (Integer) request.getAttribute("currentQuantity");
    String actionType = (String) request.getAttribute("actionType");
    
    if (fruitID == null || quantity == null || fruitName == null || locationName == null || currentQuantity == null || actionType == null) {
        response.sendRedirect(request.getContextPath() + "/stock?action=view");
        return;
    }
    
    String actionLabel = actionType.equals("checkIn") ? "Check In" : "Check Out";
    String actionVerb = actionType.equals("checkIn") ? "check in" : "check out";
    String iconClass = actionType.equals("checkIn") ? "fa-arrow-down" : "fa-arrow-up";
    String resultQuantity = actionType.equals("checkIn") ? 
                            String.valueOf(currentQuantity + quantity) : 
                            String.valueOf(currentQuantity - quantity);
    String backgroundColor = actionType.equals("checkIn") ? "#cce5ff" : "#f8d7da";
    String textColor = actionType.equals("checkIn") ? "#004085" : "#721c24";
    String borderColor = actionType.equals("checkIn") ? "#b8daff" : "#f5c6cb";
%>

<div style="background-color: <%= backgroundColor %>; color: <%= textColor %>; padding: 15px; margin-bottom: 20px; border-radius: 5px; border-left: 5px solid <%= borderColor %>;">
    <h3 style="margin-top: 0;">Please Confirm <%= actionLabel %></h3>
    <p>You are about to <%= actionVerb %> <strong><%= quantity %></strong> units of <strong><%= fruitName %></strong> <%= actionType.equals("checkIn") ? "to" : "from" %> <strong><%= locationName %></strong>:</p>
    <ul>
        <li>Current quantity: <strong><%= currentQuantity %></strong></li>
        <li>After <%= actionLabel.toLowerCase() %>: <strong><%= resultQuantity %></strong></li>
    </ul>
    <p>Are you sure you want to proceed with this action?</p>
</div>

<form action="<%=request.getContextPath()%>/stock" method="post" style="display: flex; gap: 10px;">
    <input type="hidden" name="action" value="<%= actionType %>">
    <input type="hidden" name="fruitID" value="<%= fruitID %>">
    <input type="hidden" name="quantity" value="<%= quantity %>">
    <input type="hidden" name="confirmed" value="true">
    
    <button type="submit" class="btn" style="background-color: #28a745; color: white;">Confirm <%= actionLabel %></button>
    <a href="<%=request.getContextPath()%>/stock?action=view" class="btn" style="background-color: #dc3545; color: white;">Cancel</a>
</form>

<%@include file="../footer.jsp"%> 