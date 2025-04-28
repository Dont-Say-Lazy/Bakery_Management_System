<%-- 
    Document   : confirmAddFruit
    Created on : May 20, 2025
    Author     : User
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="../header.jsp"%>

<h1>Confirm Add Fruit</h1>

<div style="background-color: #d4edda; color: #155724; padding: 10px; margin-bottom: 15px; border-radius: 5px;">
    Please confirm that you want to add the following fruit:
</div>

<div style="margin-bottom: 20px; padding: 15px; background-color: #f8f9fa; border-radius: 5px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
    <p><strong>Name:</strong> <%= request.getAttribute("name") %></p>
    <p><strong>Description:</strong> <%= request.getAttribute("description") %></p>
    <p><strong>Source Country:</strong> <%= request.getAttribute("sourceCountry") %></p>
</div>

<form action="<%= request.getContextPath() %>/fruit" method="post">
    <input type="hidden" name="action" value="add">
    <input type="hidden" name="name" value="<%= request.getAttribute("name") %>">
    <input type="hidden" name="description" value="<%= request.getAttribute("description") %>">
    <input type="hidden" name="sourceCountry" value="<%= request.getAttribute("sourceCountry") %>">
    
    <div style="display: flex; gap: 10px;">
        <button type="submit" class="btn" style="background-color: #4CAF50; color: white;">Confirm</button>
        <a href="<%= request.getContextPath() %>/fruit?action=showAddForm" class="btn" style="background-color: #f44336; color: white;">Cancel</a>
    </div>
</form>

<%@include file="../footer.jsp"%> 