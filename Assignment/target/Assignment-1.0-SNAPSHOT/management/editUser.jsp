<%-- 
    Document   : editUser
    Created on : Apr 23, 2025, 11:14:01 PM
    Author     : AlexS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="../header.jsp"%>
<%@page import="java.util.ArrayList"%>
<%@page import="ict.bean.UserBean"%>
<%@page import="ict.bean.LocationBean"%>

<%
    UserBean editUser = (UserBean) request.getAttribute("user");
    if (editUser == null) {
        response.sendRedirect(request.getContextPath() + "/user?action=list");
        return;
    }
%>

<h1>Edit User</h1>

<form action="<%=request.getContextPath()%>/user" method="post">
    <input type="hidden" name="action" value="edit">
    <input type="hidden" name="userID" value="<%= editUser.getUserID()%>">

    <div class="form-group">
        <label for="username">Username:</label>
        <input type="text" id="username" name="username" value="<%= editUser.getUsername()%>" required>
    </div>

    <div class="form-group">
        <label for="password">Password:</label>
        <input type="password" id="password" name="password" value="<%= editUser.getPassword()%>" required>
    </div>

    <div class="form-group">
        <label for="name">Name:</label>
        <input type="text" id="name" name="name" value="<%= editUser.getName()%>" required>
    </div>

    <div class="form-group">
        <label for="role">Role:</label>
        <select id="role" name="role" required onchange="handleRoleChange()">
            <option value="">Select Role</option>
            <option value="shop_staff" <%= editUser.getRole().equals("shop_staff") ? "selected" : ""%>>Shop Staff</option>
            <option value="warehouse_staff" <%= editUser.getRole().equals("warehouse_staff") ? "selected" : ""%>>Warehouse Staff</option>
            <option value="senior_management" <%= editUser.getRole().equals("senior_management") ? "selected" : ""%>>Senior Management</option>
        </select>
    </div>

    <div class="form-group" id="locationGroup">
        <label for="locationID">Location:</label>
        <select id="locationID" name="locationID">
            <option value="">Not Assigned</option>
            <%
                ArrayList<LocationBean> locations = (ArrayList<LocationBean>) request.getAttribute("locations");
                if (locations != null) {
                    for (LocationBean location : locations) {
            %>
            <option value="<%= location.getLocationID()%>" 
                    data-type="<%= location.getType()%>" 
                    <%= (editUser.getLocationID() == location.getLocationID()) ? "selected" : ""%>>
                <%= location.getName()%> (<%= location.getType()%>)
            </option>
            <%
                    }
                }
            %>
        </select>
    </div>

    <div style="margin-top: 20px;">
        <button type="submit" class="btn">Update User</button>
        <a href="<%=request.getContextPath()%>/user?action=list" class="btn" style="background-color: #ccc; color: #333;">Cancel</a>
    </div>
</form>

<script>
    function handleRoleChange() {
        var role = document.getElementById('role').value;
        var locationSelect = document.getElementById('locationID');
        var locationGroup = document.getElementById('locationGroup');

        if (role === 'senior_management') {
            locationGroup.style.display = 'none';
            locationSelect.value = '';
        } else {
            locationGroup.style.display = 'block';

            // Filter locations based on role
            var options = locationSelect.options;
            for (var i = 0; i < options.length; i++) {
                var option = options[i];
                var locationType = option.getAttribute('data-type');

                if (role === 'shop_staff' && locationType === 'shop') {
                    option.style.display = '';
                } else if (role === 'warehouse_staff' && (locationType === 'warehouse' || locationType === 'central_warehouse')) {
                    option.style.display = '';
                } else if (option.value === '') {
                    option.style.display = '';
                } else {
                    option.style.display = 'none';
                }
            }
        }
    }

    // Initialize on page load
    window.onload = function () {
        handleRoleChange();
    };
</script>

<%@include file="../footer.jsp"%>