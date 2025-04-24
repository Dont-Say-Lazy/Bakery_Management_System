<%-- 
    Document   : userManagement
    Created on : Apr 23, 2025, 11:13:28 PM
    Author     : AlexS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="../header.jsp"%>
<%@page import="java.util.ArrayList"%>
<%@page import="ict.bean.UserBean"%>
<%@page import="ict.bean.LocationBean"%>

<h1>User Management</h1>

<%-- Display any messages --%>
<% if (request.getAttribute("message") != null) {%>
<div style="background-color: #d4edda; color: #155724; padding: 10px; margin-bottom: 15px; border-radius: 5px;">
    <%= request.getAttribute("message")%>
</div>
<% }%>

<div style="margin-bottom: 20px;">
    <a href="<%=request.getContextPath()%>/user?action=showAddForm" class="btn">Add New User</a>
</div>

<table>
    <thead>
        <tr>
            <th>ID</th>
            <th>Username</th>
            <th>Name</th>
            <th>Role</th>
            <th>Location</th>
            <th>Actions</th>
        </tr>
    </thead>
    <tbody>
        <%
            ArrayList<UserBean> users = (ArrayList<UserBean>) request.getAttribute("users");
            ArrayList<LocationBean> locations = (ArrayList<LocationBean>) request.getAttribute("locations");

            if (users != null && !users.isEmpty()) {
                for (UserBean u : users) {
                    // Skip current user (cannot edit self)
                    if (u.getUserID() == user.getUserID()) {
                        continue;
                    }

                    String locationName = "Not Assigned";
                    if (u.getLocationID() > 0) {
                        for (LocationBean location : locations) {
                            if (location.getLocationID() == u.getLocationID()) {
                                locationName = location.getName();
                                break;
                            }
                        }
                    }
        %>
        <tr>
            <td><%= u.getUserID()%></td>
            <td><%= u.getUsername()%></td>
            <td><%= u.getName()%></td>
            <td><%= u.getRole()%></td>
            <td><%= locationName%></td>
            <td>
                <a href="<%=request.getContextPath()%>/user?action=showEditForm&userID=<%= u.getUserID()%>" class="btn">Edit</a>
                <a href="<%=request.getContextPath()%>/user?action=delete&userID=<%= u.getUserID()%>" class="btn btn-danger" onclick="return confirm('Are you sure you want to delete this user?')">Delete</a>
            </td>
        </tr>
        <%
            }
        } else {
        %>
        <tr>
            <td colspan="6">No users found</td>
        </tr>
        <% }%>
    </tbody>
</table>

<%@include file="../footer.jsp"%>
