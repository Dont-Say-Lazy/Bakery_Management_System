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