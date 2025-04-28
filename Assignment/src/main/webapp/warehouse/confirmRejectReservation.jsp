<%-- 
    Document   : confirmRejectReservation
    Created on : May 21, 2025
    Author     : User
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="../header.jsp"%>
<%@page import="ict.bean.ReservationBean"%>

<%
    ReservationBean reservation = (ReservationBean) request.getAttribute("reservation");
    if (reservation == null) {
        response.sendRedirect(request.getContextPath() + "/reservation?action=list");
        return;
    }
%>

<h1>Confirm Reject Reservation</h1>

<div style="background-color: #d4edda; color: #155724; padding: 10px; margin-bottom: 15px; border-radius: 5px;">
    Please confirm that you want to reject the following reservation:
</div>

<div style="margin-bottom: 20px; padding: 15px; background-color: #f8f9fa; border-radius: 5px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
    <p><strong>Reservation ID:</strong> <%= reservation.getReservationID() %></p>
    <p><strong>Shop:</strong> <%= request.getAttribute("shopName") %></p>
    <p><strong>Fruit:</strong> <%= request.getAttribute("fruitName") %></p>
    <p><strong>Quantity:</strong> <%= reservation.getQuantity() %></p>
    <p><strong>Request Date:</strong> <%= reservation.getRequestDate() %></p>
    <p><strong>Delivery Date:</strong> <%= reservation.getDeliveryDate() %></p>
</div>

<form action="<%= request.getContextPath() %>/reservation" method="post">
    <input type="hidden" name="action" value="reject">
    <input type="hidden" name="reservationID" value="<%= reservation.getReservationID() %>">
    
    <div style="display: flex; gap: 10px;">
        <button type="submit" class="btn" style="background-color: #4CAF50; color: white;">Confirm</button>
        <a href="<%= request.getContextPath() %>/reservation?action=list" class="btn" style="background-color: #f44336; color: white;">Cancel</a>
    </div>
</form>

<%@include file="../footer.jsp"%> 