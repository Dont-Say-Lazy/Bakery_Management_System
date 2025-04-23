<%-- 
    Document   : reserveFruit
    Created on : Apr 23, 2025, 11:09:14 PM
    Author     : Rain
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="../header.jsp"%>
<%@page import="java.util.ArrayList"%>
<%@page import="ict.bean.FruitBean"%>
<%@page import="ict.bean.LocationBean"%>

<h1>Reserve Fruit from Source Warehouse</h1>

<%-- Display any messages --%>
<% if (request.getAttribute("message") != null) { %>
    <div style="background-color: #d4edda; color: #155724; padding: 10px; margin-bottom: 15px; border-radius: 5px;">
        <%= request.getAttribute("message") %>
    </div>
<% } %>

<form action="<%=request.getContextPath()%>/reservation" method="post">
    <input type="hidden" name="action" value="add">
    
    <div class="form-group">
        <label for="fruitID">Fruit:</label>
        <select id="fruitID" name="fruitID" required>
            <option value="">Select Fruit</option>
            <% 
                ArrayList<FruitBean> fruits = (ArrayList<FruitBean>) request.getAttribute("fruits");
                if (fruits != null) {
                    for (FruitBean fruit : fruits) {
            %>
                <option value="<%= fruit.getFruitID() %>"><%= fruit.getName() %> (Source: <%= fruit.getSourceCountry() %>)</option>
            <% 
                    }
                }
            %>
        </select>
    </div>
    
    <div class="form-group">
        <label for="quantity">Quantity:</label>
        <input type="number" id="quantity" name="quantity" min="1" required>
    </div>
    
    <div class="form-group">
        <label for="deliveryDate">Delivery Date:</label>
        <input type="date" id="deliveryDate" name="deliveryDate" required>
    </div>
    
    <div style="margin-top: 20px;">
        <button type="submit" class="btn">Submit Reservation</button>
        <a href="<%=request.getContextPath()%>/shop/dashboard.jsp" class="btn" style="background-color: #ccc; color: #333;">Cancel</a>
    </div>
</form>

<script>
    // Set minimum date to today
    var today = new Date();
    var maxDate = new Date();
    maxDate.setDate(today.getDate() + 14); // Max 14 days in the future
    
    var todayFormatted = today.toISOString().split('T')[0];
    var maxDateFormatted = maxDate.toISOString().split('T')[0];
    
    document.getElementById('deliveryDate').setAttribute('min', todayFormatted);
    document.getElementById('deliveryDate').setAttribute('max', maxDateFormatted);
</script>

<%@include file="../footer.jsp"%>
