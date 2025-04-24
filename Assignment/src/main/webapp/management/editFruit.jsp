<%-- 
    Document   : editFruit
    Created on : Apr 23, 2025, 11:06:15 PM
    Author     : AlexS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="../header.jsp"%>
<%@page import="ict.bean.FruitBean"%>

<%
    FruitBean fruit = (FruitBean) request.getAttribute("fruit");
    if (fruit == null) {
        response.sendRedirect(request.getContextPath() + "/fruit?action=list");
        return;
    }
%>

<h1>Edit Fruit</h1>

<form action="<%=request.getContextPath()%>/fruit" method="post">
    <input type="hidden" name="action" value="edit">
    <input type="hidden" name="fruitID" value="<%= fruit.getFruitID()%>">

    <div class="form-group">
        <label for="name">Name:</label>
        <input type="text" id="name" name="name" value="<%= fruit.getName()%>" required>
    </div>

    <div class="form-group">
        <label for="description">Description:</label>
        <textarea id="description" name="description" rows="4"><%= fruit.getDescription()%></textarea>
    </div>

    <div class="form-group">
        <label for="sourceCountry">Source Country:</label>
        <select id="sourceCountry" name="sourceCountry" required>
            <option value="">Select Country</option>
            <option value="Japan" <%= fruit.getSourceCountry().equals("Japan") ? "selected" : ""%>>Japan</option>
            <option value="USA" <%= fruit.getSourceCountry().equals("USA") ? "selected" : ""%>>USA</option>
            <option value="Hong Kong" <%= fruit.getSourceCountry().equals("Hong Kong") ? "selected" : ""%>>Hong Kong</option>
        </select>
    </div>

    <div style="margin-top: 20px;">
        <button type="submit" class="btn">Update</button>
        <a href="<%=request.getContextPath()%>/fruit?action=list" class="btn" style="background-color: #ccc; color: #333;">Cancel</a>
    </div>
</form>

<%@include file="../footer.jsp"%> 