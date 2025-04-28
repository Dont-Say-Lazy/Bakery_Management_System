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

<!-- Filter Form -->
<div class="filter-section" style="margin-bottom: 20px; padding: 15px; background-color: #f8f9fa; border-radius: 5px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
    <h3 style="margin-top: 0; margin-bottom: 15px; color: #333;">Filter Users</h3>
    <form action="<%=request.getContextPath()%>/user" method="get">
        <input type="hidden" name="action" value="filter">
        <div style="display: flex; flex-wrap: wrap; gap: 15px;">
            <div style="flex: 1; min-width: 200px;">
                <label for="username" style="display: block; margin-bottom: 5px; font-weight: bold;">Username:</label>
                <input type="text" id="username" name="username" value="${filterUsername}" placeholder="Filter by username" style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;">
            </div>
            <div style="flex: 1; min-width: 200px;">
                <label for="name" style="display: block; margin-bottom: 5px; font-weight: bold;">Name:</label>
                <input type="text" id="name" name="name" value="${filterName}" placeholder="Filter by name" style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;">
            </div>
            <div style="flex: 1; min-width: 200px;">
                <label for="role" style="display: block; margin-bottom: 5px; font-weight: bold;">Role:</label>
                <select id="role" name="role" style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; background-color: white;">
                    <option value="">All Roles</option>
                    <option value="senior_management" ${filterRole == 'senior_management' ? 'selected' : ''}>Senior Management</option>
                    <option value="warehouse_staff" ${filterRole == 'warehouse_staff' ? 'selected' : ''}>Warehouse Staff</option>
                    <option value="shop_staff" ${filterRole == 'shop_staff' ? 'selected' : ''}>Shop Staff</option>
                </select>
            </div>
            <div style="flex: 1; min-width: 200px;">
                <label for="locationID" style="display: block; margin-bottom: 5px; font-weight: bold;">Location:</label>
                <select id="locationID" name="locationID" style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; background-color: white;">
                    <option value="0">All Locations</option>
                    <%
                        ArrayList<LocationBean> filterLocations = (ArrayList<LocationBean>) request.getAttribute("locations");
                        String filterLocationID = (String) request.getAttribute("filterLocationID");
                        if (filterLocations != null) {
                            for (LocationBean loc : filterLocations) {
                                boolean isSelected = filterLocationID != null && filterLocationID.equals(String.valueOf(loc.getLocationID()));
                    %>
                    <option value="<%= loc.getLocationID()%>" <%= isSelected ? "selected" : ""%>><%= loc.getName()%></option>
                    <%
                            }
                        }
                    %>
                </select>
            </div>
            <div style="flex-basis: 100%; display: flex; justify-content: flex-end; margin-top: 10px;">
                <button type="submit" class="btn" style="background-color: #4CAF50; color: white; margin-right: 10px;">Apply Filter</button>
                <a href="<%=request.getContextPath()%>/user?action=list" class="btn" style="background-color: #f44336; color: white;">Clear Filter</a>
            </div>
        </div>
    </form>
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
