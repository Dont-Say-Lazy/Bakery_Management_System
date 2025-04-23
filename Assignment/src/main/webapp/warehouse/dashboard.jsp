<%-- 
    Document   : dashboard
    Created on : Apr 23, 2025, 11:19:13 PM
    Author     : Rain
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="../header.jsp"%>
<%@ taglib uri="/WEB-INF/tlds/stocklevels" prefix="stock" %>

<h1>Warehouse Dashboard</h1>

<h2>Current Stock Levels</h2>
<stock:displayStock locationID="<%= user.getLocationID() %>"/>

<h2>Quick Actions</h2>
<div style="display: flex; justify-content: space-between; margin-top: 20px;">
    <a href="<%=request.getContextPath()%>/stock?action=showUpdateForm" class="btn">Update Stock</a>
    <a href="<%=request.getContextPath()%>/reservation?action=list" class="btn">Approve Fruit Reservations</a>
    <a href="<%=request.getContextPath()%>/warehouse/arrangeDelivery.jsp" class="btn">Arrange Deliveries</a>
</div>

<%@include file="../footer.jsp"%>
