<%-- 
    Document   : confirmAddUser
    Created on : May 20, 2025
    Author     : User
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="../header.jsp"%>

<h1>Confirm Add User</h1>

<div style="background-color: #d4edda; color: #155724; padding: 10px; margin-bottom: 15px; border-radius: 5px;">
    Please confirm that you want to add the following user:
</div>

<div style="margin-bottom: 20px; padding: 15px; background-color: #f8f9fa; border-radius: 5px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
    <p><strong>Username:</strong> <%= request.getAttribute("username") %></p>
    <p><strong>Password:</strong> ******** (hidden for security)</p>
    <p><strong>Role:</strong> <%= request.getAttribute("role") %></p>
    <p><strong>Name:</strong> <%= request.getAttribute("name") %></p>
    <p><strong>Location:</strong> <%= request.getAttribute("locationName") != null ? request.getAttribute("locationName") : "None" %></p>
</div>

<form action="<%= request.getContextPath() %>/user" method="post">
    <input type="hidden" name="action" value="add">
    <input type="hidden" name="username" value="<%= request.getAttribute("username") %>">
    <input type="hidden" name="password" value="<%= request.getAttribute("password") %>">
    <input type="hidden" name="role" value="<%= request.getAttribute("role") %>">
    <input type="hidden" name="name" value="<%= request.getAttribute("name") %>">
    <input type="hidden" name="locationID" value="<%= request.getAttribute("locationID") %>">
    
    <div style="display: flex; gap: 10px;">
        <button type="submit" class="btn" style="background-color: #4CAF50; color: white;">Confirm</button>
        <a href="<%= request.getContextPath() %>/user?action=showAddForm" class="btn" style="background-color: #f44336; color: white;">Cancel</a>
    </div>
</form>

<%@include file="../footer.jsp"%> 