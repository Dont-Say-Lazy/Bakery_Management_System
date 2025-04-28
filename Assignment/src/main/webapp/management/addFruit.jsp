<%-- 
    Document   : addFruit
    Created on : Apr 23, 2025, 11:05:27 PM
    Author     : AlexS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="../header.jsp"%>

<h1>Add New Fruit</h1>

<form action="<%=request.getContextPath()%>/fruit" method="post">
    <input type="hidden" name="action" value="confirmAdd">

    <div class="form-group">
        <label for="name">Name:</label>
        <input type="text" id="name" name="name" required>
    </div>

    <div class="form-group">
        <label for="description">Description:</label>
        <textarea id="description" name="description" rows="4"></textarea>
    </div>

    <div class="form-group">
        <label for="sourceCountry">Source Country:</label>
        <select id="sourceCountry" name="sourceCountry" required>
            <option value="">Select Country</option>
            <option value="Japan">Japan</option>
            <option value="USA">USA</option>
            <option value="Hong Kong">Hong Kong</option>
        </select>
    </div>

    <div style="margin-top: 20px;">
        <button type="submit" class="btn">Continue</button>
        <a href="<%=request.getContextPath()%>/fruit?action=list" class="btn" style="background-color: #ccc; color: #333;">Cancel</a>
    </div>
</form>

<%@include file="../footer.jsp"%>
