<%-- 
    Document   : arrangeDelivery
    Created on : 23 Apr 2025, 23:05:05
    Author     : User
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="../header.jsp"%>
<%@ taglib uri="/WEB-INF/tlds/locations" prefix="loc" %>
<%@page import="java.util.ArrayList"%>
<%@page import="ict.bean.ReservationBean"%>
<%@page import="ict.db.ReservationDB"%>
<%@page import="ict.db.LocationDB"%>

<% 
    String dbUrl = application.getInitParameter("dbUrl");
    String dbUser = application.getInitParameter("dbUser");
    String dbPassword = application.getInitParameter("dbPassword");
    
    ReservationDB reservationDB = new ReservationDB(dbUrl, dbUser, dbPassword);
    ArrayList<ReservationBean> approvedReservations = reservationDB.getReservationsByStatus("approved");
    
    // Get the user's location ID for pre-selection
    int userLocationID = user.getLocationID();
    boolean isCentralStaff = user.getIsCentralStaff() == 1;
%>

<h1>Arrange Deliveries</h1>

<h2>Approved Reservations Ready for Delivery</h2>

<table>
    <thead>
        <tr>
            <th>ID</th>
            <th>Shop</th>
            <th>Fruit</th>
            <th>Quantity</th>
            <th>Request Date</th>
            <th>Delivery Date</th>
            <th>Status</th>
            <th>Actions</th>
        </tr>
    </thead>
    <tbody>
        <% 
            if (approvedReservations != null && !approvedReservations.isEmpty()) {
                for (ReservationBean reservation : approvedReservations) {
        %>
        <tr>
            <td><%= reservation.getReservationID() %></td>
            <td><%= reservation.getShopName() %></td>
            <td><%= reservation.getFruitName() %></td>
            <td><%= reservation.getQuantity() %></td>
            <td><%= reservation.getRequestDate() %></td>
            <td><%= reservation.getDeliveryDate() %></td>
            <td><%= reservation.getStatus() %></td>
            <td>
                <a href="<%=request.getContextPath()%>/reservation?action=confirmDeliver&reservationID=<%= reservation.getReservationID() %>" class="btn" style="background-color: blue;">Mark as Delivered</a>
            </td>
        </tr>
        <% 
                }
            } else {
        %>
        <tr>
            <td colspan="8">No approved reservations pending delivery</td>
        </tr>
        <% } %>
    </tbody>
</table>

<h2>Arrange New Delivery</h2>
<form action="<%=request.getContextPath()%>/delivery" method="post" id="deliveryForm">
    <input type="hidden" name="action" value="add">
    
    <div class="form-group">
        <label for="sourceLocationID">Source Location:</label>
        <loc:selector name="sourceLocationID" id="sourceLocationID" 
                     cssClass="form-control" 
                     required="true" 
                     selectedValue="<%= String.valueOf(userLocationID) %>"
                     selectorType="source"
                     onChange="validateLocations()" />
    </div>
    
    <div class="form-group">
        <label for="destinationLocationID">Destination Location:</label>
        <loc:selector name="destinationLocationID" id="destinationLocationID" 
                     cssClass="form-control" 
                     required="true"
                     excludeIds="<%= String.valueOf(userLocationID) %>"
                     selectorType="destination"
                     onChange="validateLocations()" />
    </div>
    
    <div class="form-group">
        <label for="deliveryDate">Delivery Date:</label>
        <input type="date" id="deliveryDate" name="deliveryDate" class="form-control" required>
    </div>
    
    <div class="form-group">
        <label for="notes">Notes:</label>
        <textarea id="notes" name="notes" rows="4" class="form-control"></textarea>
    </div>
    
    <div id="locationError" style="color: red; display: none; margin-bottom: 10px;">
        Source and destination locations cannot be the same.
    </div>
    
    <div style="margin-top: 20px;">
        <button type="submit" class="btn" id="submitBtn">Arrange Delivery</button>
    </div>
</form>

<script>
    // Set minimum date to today
    var today = new Date();
    var todayFormatted = today.toISOString().split('T')[0];
    document.getElementById('deliveryDate').setAttribute('min', todayFormatted);
    
    // Validate that source and destination are different
    function validateLocations() {
        var sourceLocationID = document.getElementById('sourceLocationID').value;
        var destinationLocationID = document.getElementById('destinationLocationID').value;
        var errorDiv = document.getElementById('locationError');
        var submitBtn = document.getElementById('submitBtn');
        
        if (sourceLocationID && destinationLocationID && sourceLocationID === destinationLocationID) {
            errorDiv.style.display = 'block';
            submitBtn.disabled = true;
        } else {
            errorDiv.style.display = 'none';
            submitBtn.disabled = false;
        }
    }
    
    // Validate form on submit
    document.getElementById('deliveryForm').addEventListener('submit', function(e) {
        var sourceLocationID = document.getElementById('sourceLocationID').value;
        var destinationLocationID = document.getElementById('destinationLocationID').value;
        
        if (sourceLocationID && destinationLocationID && sourceLocationID === destinationLocationID) {
            e.preventDefault();
            document.getElementById('locationError').style.display = 'block';
            return false;
        }
        return true;
    });
    
    // Initialize validation
    validateLocations();
</script>

<%@include file="../footer.jsp"%>