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
                <button type="submit" class="btn" style="background-color: #4CAF50; color: white; margin-right: 10px; padding: 8px 16px; border-radius: 4px;">Apply Filter</button>
                <a href="<%=request.getContextPath()%>/reservation?action=list" class="btn" style="background-color: #f44336; color: white; padding: 8px 16px; border-radius: 4px;">Clear Filter</a>
            </div>
        </div>
    </form>
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
