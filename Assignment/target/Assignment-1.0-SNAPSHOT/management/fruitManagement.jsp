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
