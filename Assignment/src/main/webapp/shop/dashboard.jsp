<%-- 
    Document   : dashboard
    Created on : Apr 23, 2025, 11:03:50 PM
    Author     : Rain
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="../header.jsp"%>
<%@ taglib uri="/WEB-INF/tlds/stocklevels" prefix="stock" %>

<h1>Shop Dashboard</h1>

<h2>Current Stock Levels</h2>
<stock:displayStock locationID="<%= user.getLocationID() %>"/>

<h2>Quick Actions</h2>
<div style="display: flex; justify-content: space-between; margin-top: 20px;">
    <a href="reserveFruit.jsp" class="btn">Reserve Fruits</a>
    <a href="borrowFruit.jsp" class="btn">Borrow Fruits</a>
    <a href="checkReserves.jsp" class="btn">Check Reservations</a>
    <a href="updateStock.jsp" class="btn">Update Stock</a>
</div>

<%@include file="../footer.jsp"%>
