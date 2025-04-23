<%-- 
    Document   : checkReserves
    Created on : Apr 23, 2025, 11:09:30 PM
    Author     : Rain
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="../header.jsp"%>
<%@page import="java.util.ArrayList"%>
<%@page import="ict.bean.ReservationBean"%>

<h1>My Fruit Reservations</h1>

<%-- Display any messages --%>
<% if (request.getAttribute("message") != null) { %>
    <div style="background-color: #d4edda; color: #155724; padding: 10px; margin-bottom: 15px; border-radius: 5px;">
        <%= request.getAttribute("message") %>
    </div>
<% } %>

<div style="margin-bottom: 20px;">
    <a href="<%=request.getContextPath()%>/reservation?action=showAddForm" class="btn">Reserve New Fruit</a>
</div>

<table>
    <thead>
        <tr>
            <th>ID</th>
            <th>Fruit</th>
            <th>Quantity</th>
            <th>Request Date</th>
            <th>Delivery Date</th>
            <th>Status</th>
        </tr>
    </thead>
    <tbody>
        <% 
            ArrayList<ReservationBean> reservations = (ArrayList<ReservationBean>) request.getAttribute("reservations");
            if (reservations != null && !reservations.isEmpty()) {
                for (ReservationBean reservation : reservations) {
        %>
        <tr>
            <td><%= reservation.getReservationID() %></td>
            <td><%= reservation.getFruitName() %></td>
            <td><%= reservation.getQuantity() %></td>
            <td><%= reservation.getRequestDate() %></td>
            <td><%= reservation.getDeliveryDate() %></td>
            <td>
                <% 
                    String status = reservation.getStatus();
                    String statusClass = "";
                    
                    if (status.equals("approved")) {
                        statusClass = "color: green;";
                    } else if (status.equals("rejected")) {
                        statusClass = "color: red;";
                    } else if (status.equals("delivered")) {
                        statusClass = "color: blue;";
                    }
                %>
                <span style="<%= statusClass %>"><%= status %></span>
            </td>
        </tr>
        <% 
                }
            } else {
        %>
        <tr>
            <td colspan="6">No reservations found</td>
        </tr>
        <% } %>
    </tbody>
</table>

<%@include file="../footer.jsp"%>
