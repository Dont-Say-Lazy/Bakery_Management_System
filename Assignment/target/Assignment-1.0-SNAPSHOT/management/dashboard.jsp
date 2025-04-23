<%-- 
    Document   : dashboard
    Created on : Apr 23, 2025, 11:18:35 PM
    Author     : Rain
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="../header.jsp"%>

<h1>Senior Management Dashboard</h1>

<div style="margin-top: 20px;">
    <div class="row" style="display: flex; margin: -10px;">
        <div class="col" style="flex: 1; padding: 10px;">
            <div style="background-color: #f9f9f9; padding: 20px; border-radius: 5px; text-align: center;">
                <h3>User Management</h3>
                <p>Create, update, and delete user accounts</p>
                <a href="<%=request.getContextPath()%>/user?action=list" class="btn">Manage Users</a>
            </div>
        </div>
        <div class="col" style="flex: 1; padding: 10px;">
            <div style="background-color: #f9f9f9; padding: 20px; border-radius: 5px; text-align: center;">
                <h3>Fruit Management</h3>
                <p>Manage fruit types in the system</p>
                <a href="<%=request.getContextPath()%>/fruit?action=list" class="btn">Manage Fruits</a>
            </div>
        </div>
        <div class="col" style="flex: 1; padding: 10px;">
            <div style="background-color: #f9f9f9; padding: 20px; border-radius: 5px; text-align: center;">
                <h3>Reports</h3>
                <p>View reports and analytics</p>
                <a href="<%=request.getContextPath()%>/management/reports.jsp" class="btn">View Reports</a>
            </div>
        </div>
    </div>
</div>

<%@include file="../footer.jsp"%>
