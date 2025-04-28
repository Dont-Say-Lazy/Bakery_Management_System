<%-- 
    Document   : confirmStockAction
    Created on : Apr 29, 2025, 12:10:51 AM
    Author     : AlexS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="../header.jsp"%>

<div style="max-width: 800px; margin: 0 auto; padding: 20px;">
    <h1 style="color: #4DD0C5; border-bottom: 2px solid #4DD0C5; padding-bottom: 10px; margin-bottom: 20px;">Confirm Stock Action</h1>

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
        String resultQuantity = actionType.equals("checkIn") ? 
                                String.valueOf(currentQuantity + quantity) : 
                                String.valueOf(currentQuantity - quantity);
    %>

    <div style="background-color: #f8f9fa; padding: 20px; margin-bottom: 20px; border-radius: 5px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
        <h3 style="margin-top: 0; color: #333; font-size: 1.3em;">Please Confirm <%= actionLabel %></h3>
        <p>You are about to <%= actionVerb %> <strong><%= quantity %></strong> units of <strong><%= fruitName %></strong> <%= actionType.equals("checkIn") ? "to" : "from" %> <strong><%= locationName %></strong>:</p>
        <p>Current quantity: <strong><%= currentQuantity %></strong></p>
        <p>After <%= actionLabel.toLowerCase() %>: <strong><%= resultQuantity %></strong></p>
        <p>Are you sure you want to proceed with this action?</p>
    </div>

    <div style="display: flex; gap: 10px;">
        <form action="<%=request.getContextPath()%>/stock" method="post" style="margin: 0;">
            <input type="hidden" name="action" value="<%= actionType %>">
            <input type="hidden" name="fruitID" value="<%= fruitID %>">
            <input type="hidden" name="quantity" value="<%= quantity %>">
            <input type="hidden" name="confirmed" value="true">
            
            <button type="submit" class="btn" style="background-color: #28a745; color: white; border-radius: 50px; padding: 10px 20px; border: none;">Confirm <%= actionLabel %></button>
        </form>
        <a href="<%=request.getContextPath()%>/stock?action=view" class="btn" style="background-color: #dc3545; color: white; border-radius: 50px; padding: 10px 20px; text-decoration: none; display: inline-block; text-align: center;">Cancel</a>
    </div>
</div>

<%@include file="../footer.jsp"%> 