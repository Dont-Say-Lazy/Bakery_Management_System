<%-- 
    Document   : approveRequests
    Created on : Apr 23, 2025, 11:09:53 PM
    Author     : Rain
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="../header.jsp"%>
<%@page import="java.util.ArrayList"%>
<%@page import="ict.bean.ReservationBean"%>

<h1>Approve Reservation Requests</h1>

<%-- Display any messages --%>
<% if (request.getAttribute("message") != null) { %>
    <div style="background-color: #d4edda; color: #155724; padding: 10px; margin-bottom: 15px; border-radius: 5px;">
        <%= request.getAttribute("message") %>
    </div>
<% } %>

<h2>Pending Reservations</h2>

<table>
    <thead>
        <tr>
            <th>ID</th>
            <th>Shop</th>
            <th>Fruit</th>
            <th>Quantity</th>
            <th>Request Date</th>
            <th>Delivery Date</th>
            <th>Requested By</th>
            <th>Actions</th>
        </tr>
    </thead>
    <tbody>
        <% 
            ArrayList<ReservationBean> reservations = (ArrayList<ReservationBean>) request.getAttribute("reservations");
            boolean hasPending = false;
            
            if (reservations != null && !reservations.isEmpty()) {
                for (ReservationBean reservation : reservations) {
                    if (reservation.getStatus().equals("pending")) {
                        hasPending = true;
        %>
        <tr>
            <td><%= reservation.getReservationID() %></td>
            <td><%= reservation.getShopName() %></td>
            <td><%= reservation.getFruitName() %></td>
            <td><%= reservation.getQuantity() %></td>
            <td><%= reservation.getRequestDate() %></td>
            <td><%= reservation.getDeliveryDate() %></td>
            <td><%= reservation.getUserName() %></td>
            <td>
                <a href="<%=request.getContextPath()%>/reservation?action=approve&reservationID=<%= reservation.getReservationID() %>" class="btn" style="background-color: green;">Approve</a>
                <a href="<%=request.getContextPath()%>/reservation?action=reject&reservationID=<%= reservation.getReservationID() %>" class="btn btn-danger">Reject</a>
            </td>
        </tr>
        <% 
                    }
                }
            }
            
            if (!hasPending) {
        %>
        <tr>
            <td colspan="8">No pending reservations found</td>
        </tr>
        <% } %>
    </tbody>
</table>

<h2>Processed Reservations</h2>

<table>
    <thead>
        <tr>
            <th>ID</th>
            <th>Shop</th>
            <th>Fruit</th>
            <th>Quantity</th>
            <th>Request Date</th>
            <th>Delivery Date</th>
            <th>Requested By</th>
            <th>Status</th>
        </tr>
    </thead>
    <tbody>
        <% 
            boolean hasProcessed = false;
            
            if (reservations != null && !reservations.isEmpty()) {
                for (ReservationBean reservation : reservations) {
                    if (!reservation.getStatus().equals("pending")) {
                        hasProcessed = true;
                        String statusClass = "";
                        
                        if (reservation.getStatus().equals("approved")) {
                            statusClass = "color: green;";
                        } else if (reservation.getStatus().equals("rejected")) {
                            statusClass = "color: red;";
                        } else if (reservation.getStatus().equals("delivered")) {
                            statusClass = "color: blue;";
                        }
        %>
        <tr>
            <td><%= reservation.getReservationID() %></td>
            <td><%= reservation.getShopName() %></td>
            <td><%= reservation.getFruitName() %></td>
            <td><%= reservation.getQuantity() %></td>
            <td><%= reservation.getRequestDate() %></td>
            <td><%= reservation.getDeliveryDate() %></td>
            <td><%= reservation.getUserName() %></td>
            <td style="<%= statusClass %>"><%= reservation.getStatus() %></td>
        </tr>
        <% 
                    }
                }
            }
            
            if (!hasProcessed) {
        %>
        <tr>
            <td colspan="8">No processed reservations found</td>
        </tr>
        <% } %>
    </tbody>
</table>

<%@include file="../footer.jsp"%>