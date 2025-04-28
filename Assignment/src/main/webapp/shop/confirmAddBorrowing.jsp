<%-- 
    Document   : confirmAddBorrowing
    Created on : May 21, 2025
    Author     : User
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="../header.jsp"%>

<h1>Confirm Borrowing Request</h1>

<div style="background-color: #d4edda; color: #155724; padding: 10px; margin-bottom: 15px; border-radius: 5px;">
    Please confirm that you want to request to borrow the following fruit:
</div>

<div style="margin-bottom: 20px; padding: 15px; background-color: #f8f9fa; border-radius: 5px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
    <p><strong>Fruit:</strong> <%= request.getAttribute("fruitName") %></p>
    <p><strong>Quantity:</strong> <%= request.getAttribute("quantity") %></p>
    <p><strong>Source Shop:</strong> <%= request.getAttribute("sourceShopName") %></p>
    <p><strong>Destination Shop:</strong> <%= request.getAttribute("destShopName") %></p>
</div>

<form action="<%= request.getContextPath() %>/borrowing" method="post">
    <input type="hidden" name="action" value="add">
    <input type="hidden" name="fruitID" value="<%= request.getAttribute("fruitID") %>">
    <input type="hidden" name="quantity" value="<%= request.getAttribute("quantity") %>">
    <input type="hidden" name="sourceShopID" value="<%= request.getAttribute("sourceShopID") %>">
    
    <div style="display: flex; gap: 10px;">
        <button type="submit" class="btn" style="background-color: #4CAF50; color: white;">Confirm</button>
        <a href="<%= request.getContextPath() %>/borrowing?action=showAddForm" class="btn" style="background-color: #f44336; color: white;">Cancel</a>
    </div>
</form>

<%@include file="../footer.jsp"%> 