<%-- 
    Document   : borrowFruit
    Created on : Apr 23, 2025, 11:11:03 PM
    Author     : Rain
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="../header.jsp"%>
<%@page import="java.util.ArrayList"%>
<%@page import="ict.bean.BorrowingBean"%>

<h1>Borrow Fruit from Other Shops</h1>

<%-- Display any messages --%>
<% if (request.getAttribute("message") != null) { %>
    <div style="background-color: #d4edda; color: #155724; padding: 10px; margin-bottom: 15px; border-radius: 5px;">
        <%= request.getAttribute("message") %>
    </div>
<% } %>

<div style="margin-bottom: 20px;">
    <a href="<%=request.getContextPath()%>/borrowing?action=showAddForm" class="btn">Request to Borrow Fruit</a>
</div>

<!-- Filter Form -->
<div class="filter-section" style="margin-bottom: 20px; padding: 15px; background-color: #f8f9fa; border-radius: 5px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
    <h3 style="margin-top: 0; margin-bottom: 15px; color: #333;">Filter Borrowings</h3>
    <form action="<%=request.getContextPath()%>/borrowing" method="get">
        <input type="hidden" name="action" value="filter">
        <div style="display: flex; flex-wrap: wrap; gap: 15px;">
            <div style="flex: 1; min-width: 200px;">
                <label for="fruitName" style="display: block; margin-bottom: 5px; font-weight: bold;">Fruit:</label>
                <input type="text" id="fruitName" name="fruitName" value="${filterFruitName}" placeholder="Filter by fruit name" style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;">
            </div>
            <div style="flex: 1; min-width: 200px;">
                <label for="shopName" style="display: block; margin-bottom: 5px; font-weight: bold;">Shop:</label>
                <input type="text" id="shopName" name="shopName" value="${filterShopName}" placeholder="Filter by shop name" style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;">
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
            <div style="flex-basis: 100%; display: flex; justify-content: flex-end; margin-top: 10px;">
                <button type="submit" class="btn" style="background-color: #4CAF50; color: white; margin-right: 10px;">Apply Filter</button>
                <a href="<%=request.getContextPath()%>/borrowing?action=list" class="btn" style="background-color: #f44336; color: white;">Clear Filter</a>
            </div>
        </div>
    </form>
</div>

<h2>My Borrowing Requests</h2>

<table>
    <thead>
        <tr>
            <th>ID</th>
            <th>From Shop</th>
            <th>Fruit</th>
            <th>Quantity</th>
            <th>Request Date</th>
            <th>Status</th>
            <th>Actions</th>
        </tr>
    </thead>
    <tbody>
        <% 
            ArrayList<BorrowingBean> borrowings = (ArrayList<BorrowingBean>) request.getAttribute("borrowings");
            boolean hasRequests = false;
            
            if (borrowings != null && !borrowings.isEmpty()) {
                for (BorrowingBean borrowing : borrowings) {
                    if (borrowing.getDestinationShopID() == user.getLocationID()) {
                        hasRequests = true;
                        
                        String status = borrowing.getStatus();
                        String statusClass = "";
                        
                        if (status.equals("approved")) {
                            statusClass = "color: green;";
                        } else if (status.equals("rejected")) {
                            statusClass = "color: red;";
                        } else if (status.equals("delivered")) {
                            statusClass = "color: blue;";
                        } else if (status.equals("pending")) {
                            statusClass = "color: orange;";
                        }
        %>
        <tr>
            <td><%= borrowing.getBorrowingID() %></td>
            <td><%= borrowing.getSourceShopName() %></td>
            <td><%= borrowing.getFruitName() %></td>
            <td><%= borrowing.getQuantity() %></td>
            <td><%= borrowing.getRequestDate() %></td>
            <td><span style="<%= statusClass %>"><%= status %></span></td>
            <td>
                <% if (status.equals("approved")) { %>
                    <a href="<%=request.getContextPath()%>/borrowing?action=markReceived&borrowingID=<%= borrowing.getBorrowingID() %>" class="btn" style="background-color: blue;">Mark as Received</a>
                <% } else { %>
                    -
                <% } %>
            </td>
        </tr>
        <% 
                    }
                }
            }
            
            if (!hasRequests) {
        %>
        <tr>
            <td colspan="7">No borrowing requests found</td>
        </tr>
        <% } %>
    </tbody>
</table>

<h2>Incoming Borrowing Requests</h2>

<table>
    <thead>
        <tr>
            <th>ID</th>
            <th>To Shop</th>
            <th>Fruit</th>
            <th>Quantity</th>
            <th>Request Date</th>
            <th>Status</th>
            <th>Actions</th>
        </tr>
    </thead>
    <tbody>
        <% 
            boolean hasIncoming = false;
            
            if (borrowings != null && !borrowings.isEmpty()) {
                for (BorrowingBean borrowing : borrowings) {
                    if (borrowing.getSourceShopID() == user.getLocationID()) {
                        hasIncoming = true;
                        
                        String status = borrowing.getStatus();
                        String statusClass = "";
                        
                        if (status.equals("approved")) {
                            statusClass = "color: green;";
                        } else if (status.equals("rejected")) {
                            statusClass = "color: red;";
                        } else if (status.equals("delivered")) {
                            statusClass = "color: blue;";
                        } else if (status.equals("pending")) {
                            statusClass = "color: orange;";
                        }
        %>
        <tr>
            <td><%= borrowing.getBorrowingID() %></td>
            <td><%= borrowing.getDestinationShopName() %></td>
            <td><%= borrowing.getFruitName() %></td>
            <td><%= borrowing.getQuantity() %></td>
            <td><%= borrowing.getRequestDate() %></td>
            <td><span style="<%= statusClass %>"><%= status %></span></td>
            <td>
                <% if (status.equals("pending")) { %>
                    <a href="<%=request.getContextPath()%>/borrowing?action=approve&borrowingID=<%= borrowing.getBorrowingID() %>" class="btn" style="background-color: green;">Approve</a>
                    <a href="<%=request.getContextPath()%>/borrowing?action=reject&borrowingID=<%= borrowing.getBorrowingID() %>" class="btn btn-danger">Reject</a>
                <% } else { %>
                    <span>Processed</span>
                <% } %>
            </td>
        </tr>
        <% 
                    }
                }
            }
            
            if (!hasIncoming) {
        %>
        <tr>
            <td colspan="7">No incoming borrowing requests found</td>
        </tr>
        <% } %>
    </tbody>
</table>

<%@include file="../footer.jsp"%>