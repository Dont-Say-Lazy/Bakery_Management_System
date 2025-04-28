<%-- 
    Document   : fruitManagement
    Created on : Apr 23, 2025, 11:05:09 PM
    Author     : AlexS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="../header.jsp"%>
<%@page import="java.util.ArrayList"%>
<%@page import="ict.bean.FruitBean"%>

<h1>Fruit Management</h1>

<%-- Display message if available --%>
<% if (request.getAttribute("message") != null) {%>
<div style="background-color: #d4edda; color: #155724; padding: 10px; margin-bottom: 15px; border-radius: 5px;">
    <%= request.getAttribute("message")%>
</div>
<% }%>

<div style="margin-bottom: 20px;">
    <a href="<%=request.getContextPath()%>/fruit?action=showAddForm" class="btn">Add New Fruit</a>
</div>

<!-- Filter Form -->
<div class="filter-section" style="margin-bottom: 20px; padding: 15px; background-color: #f8f9fa; border-radius: 5px;">
    <h3>Filter Fruits</h3>
    <form action="<%=request.getContextPath()%>/fruit" method="get">
        <input type="hidden" name="action" value="filter">
        <div style="display: flex; flex-wrap: wrap; gap: 10px;">
            <div>
                <label for="name">Name:</label>
                <input type="text" id="name" name="name" value="${filterName}" placeholder="Filter by name">
            </div>
            <div>
                <label for="sourceCountry">Source Country:</label>
                <input type="text" id="sourceCountry" name="sourceCountry" value="${filterSourceCountry}" placeholder="Filter by country">
            </div>
            <div style="align-self: flex-end;">
                <button type="submit" class="btn">Apply Filter</button>
                <a href="<%=request.getContextPath()%>/fruit?action=list" class="btn">Clear Filter</a>
            </div>
        </div>
    </form>
</div>

<table>
    <thead>
        <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Description</th>
            <th>Source Country</th>
            <th>Actions</th>
        </tr>
    </thead>
    <tbody>
        <%
            ArrayList<FruitBean> fruits = (ArrayList<FruitBean>) request.getAttribute("fruits");
            if (fruits != null && !fruits.isEmpty()) {
                for (FruitBean fruit : fruits) {
        %>
        <tr>
            <td><%= fruit.getFruitID()%></td>
            <td><%= fruit.getName()%></td>
            <td><%= fruit.getDescription()%></td>
            <td><%= fruit.getSourceCountry()%></td>
            <td>
                <a href="<%=request.getContextPath()%>/fruit?action=showEditForm&fruitID=<%= fruit.getFruitID()%>" class="btn">Edit</a>
                <a href="<%=request.getContextPath()%>/fruit?action=delete&fruitID=<%= fruit.getFruitID()%>" class="btn btn-danger" onclick="return confirm('Are you sure you want to delete this fruit?')">Delete</a>
            </td>
        </tr>
        <%
            }
        } else {
        %>
        <tr>
            <td colspan="5">No fruits found</td>
        </tr>
        <% }%>
    </tbody>
</table>

<%@include file="../footer.jsp"%>
