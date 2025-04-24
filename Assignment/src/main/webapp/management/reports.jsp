<%-- 
    Document   : reports
    Created on : Apr 23, 2025, 11:07:15 PM
    Author     : AlexS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="../header.jsp"%>
<%@ taglib uri="/WEB-INF/tlds/reports" prefix="report" %>
<%@page import="ict.db.LocationDB"%>
<%@page import="ict.bean.LocationBean"%>
<%@page import="java.util.ArrayList"%>

<%
    String dbUrl = application.getInitParameter("dbUrl");
    String dbUser = application.getInitParameter("dbUser");
    String dbPassword = application.getInitParameter("dbPassword");

    LocationDB locationDB = new LocationDB(dbUrl, dbUser, dbPassword);
    ArrayList<LocationBean> locations = locationDB.queryLocation();

    String reportType = request.getParameter("reportType");
    String location = request.getParameter("location");
    String period = request.getParameter("period");
%>

<h1>Reports</h1>

<form action="reports.jsp" method="get">
    <div class="form-group">
        <label for="reportType">Report Type:</label>
        <select id="reportType" name="reportType" required>
            <option value="">Select Report Type</option>
            <option value="reserveNeeds" <%= "reserveNeeds".equals(reportType) ? "selected" : ""%>>Reservation Needs</option>
            <option value="consumption" <%= "consumption".equals(reportType) ? "selected" : ""%>>Consumption by Season</option>
        </select>
    </div>

    <div class="form-group">
        <label for="location">Location:</label>
        <select id="location" name="location">
            <option value="">All Locations</option>
            <optgroup label="Countries">
                <option value="Japan" <%= "Japan".equals(location) ? "selected" : ""%>>Japan</option>
                <option value="USA" <%= "USA".equals(location) ? "selected" : ""%>>USA</option>
                <option value="Hong Kong" <%= "Hong Kong".equals(location) ? "selected" : ""%>>Hong Kong</option>
            </optgroup>
            <optgroup label="Shops">
                <% for (LocationBean loc : locations) {
                        if (loc.getType().equals("shop")) {
                %>
                <option value="<%= loc.getLocationID()%>" <%= String.valueOf(loc.getLocationID()).equals(location) ? "selected" : ""%>><%= loc.getName()%> (<%= loc.getCity()%>, <%= loc.getCountry()%>)</option>
                <%
                        }
                    }
                %>
            </optgroup>
        </select>
    </div>

    <div class="form-group" id="periodGroup" style="<%= "consumption".equals(reportType) ? "" : "display:none;"%>">
        <label for="period">Season:</label>
        <select id="period" name="period">
            <option value="">All Seasons</option>
            <option value="Spring" <%= "Spring".equals(period) ? "selected" : ""%>>Spring</option>
            <option value="Summer" <%= "Summer".equals(period) ? "selected" : ""%>>Summer</option>
            <option value="Fall" <%= "Fall".equals(period) ? "selected" : ""%>>Fall</option>
            <option value="Winter" <%= "Winter".equals(period) ? "selected" : ""%>>Winter</option>
        </select>
    </div>

    <div style="margin-top: 20px;">
        <button type="submit" class="btn">Generate Report</button>
    </div>
</form>

<% if (reportType != null && !reportType.isEmpty()) {%>
<div style="margin-top: 30px;">
    <report:generateReport type="<%= reportType%>" location="<%= location%>" period="<%= period%>" />
</div>
<% }%>

<script>
    document.getElementById('reportType').addEventListener('change', function () {
        var periodGroup = document.getElementById('periodGroup');
        if (this.value === 'consumption') {
            periodGroup.style.display = 'block';
        } else {
            periodGroup.style.display = 'none';
        }
    });
</script>

<%@include file="../footer.jsp"%>
