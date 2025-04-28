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

<!-- Filter Form -->
<div class="filter-section" style="margin-bottom: 20px; padding: 15px; background-color: #f8f9fa; border-radius: 5px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
    <h3 style="margin-top: 0; margin-bottom: 15px; color: #333;">Filter Reservations</h3>
    <form action="<%=request.getContextPath()%>/reservation" method="get">
        <input type="hidden" name="action" value="filter">
        <div style="display: flex; flex-wrap: wrap; gap: 15px;">
            <div style="flex: 1; min-width: 200px;">
                <label for="fruitName" style="display: block; margin-bottom: 5px; font-weight: bold;">Fruit:</label>
                <input type="text" id="fruitName" name="fruitName" value="${filterFruitName}" placeholder="Filter by fruit name" style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;">
            </div>
            <div style="flex: 1; min-width: 200px;">
                <label for="status" style="display: block; margin-bottom: 5px; font-weight: bold;">Status:</label>
                <select id="status" name="status" style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; background-color: white;">
                    <option value="">All Statuses</option>
                    <option value="pending" ${filterStatus == 'pending' ? 'selected' : ''}>Pending</option>
                    <option value="approved" ${filterStatus == 'approved' ? 'selected' : ''}>Approved</option>
                    <option value="rejected" ${filterStatus == 'rejected' ? 'selected' : ''}>Rejected</option>
                    <option value="delivered" ${filterStatus == 'delivered' ? 'selected' : ''}>Delivered</option>
                </select>
            </div>
            <div style="flex: 1; min-width: 200px;">
                <label for="startDate" style="display: block; margin-bottom: 5px; font-weight: bold;">From Date:</label>
                <input type="date" id="startDate" name="startDate" value="${filterStartDate}" style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;">
            </div>
            <div style="flex: 1; min-width: 200px;">
                <label for="endDate" style="display: block; margin-bottom: 5px; font-weight: bold;">To Date:</label>
                <input type="date" id="endDate" name="endDate" value="${filterEndDate}" style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;">
            </div>
            <div style="flex: 2; min-width: 200px; display: flex; gap: 15px;">
                <div style="flex: 1;">
                    <label for="minQuantity" style="display: block; margin-bottom: 5px; font-weight: bold;">Min Quantity:</label>
                    <input type="number" id="minQuantity" name="minQuantity" value="${filterMinQuantity}" placeholder="Minimum" min="0" style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;">
                </div>
                <div style="flex: 1;">
                    <label for="maxQuantity" style="display: block; margin-bottom: 5px; font-weight: bold;">Max Quantity:</label>
                    <input type="number" id="maxQuantity" name="maxQuantity" value="${filterMaxQuantity}" placeholder="Maximum" min="0" style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;">
                </div>
            </div>
            <div style="flex-basis: 100%; display: flex; justify-content: flex-end; margin-top: 10px;">
                <button type="submit" class="btn" style="background-color: #4CAF50; color: white; margin-right: 10px;">Apply Filter</button>
                <a href="<%=request.getContextPath()%>/reservation?action=list" class="btn" style="background-color: #f44336; color: white;">Clear Filter</a>
            </div>
        </div>
    </form>
</div>

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