<%-- 
    Document   : confirmApproveBorrowing
    Created on : May 21, 2025
    Author     : User
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="../header.jsp"%>
<%@page import="ict.bean.BorrowingBean"%>

<%
    BorrowingBean borrowing = (BorrowingBean) request.getAttribute("borrowing");
    if (borrowing == null) {
        response.sendRedirect(request.getContextPath() + "/borrowing?action=list");
        return;
    }
%>

<h1>Confirm Approve Borrowing</h1>

<div style="background-color: #d4edda; color: #155724; padding: 10px; margin-bottom: 15px; border-radius: 5px;">
    Please confirm that you want to approve the following borrowing request:
</div>

<div style="margin-bottom: 20px; padding: 15px; background-color: #f8f9fa; border-radius: 5px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
    <p><strong>Borrowing ID:</strong> <%= borrowing.getBorrowingID() %></p>
    <p><strong>Fruit:</strong> <%= request.getAttribute("fruitName") %></p>
    <p><strong>Quantity:</strong> <%= borrowing.getQuantity() %></p>
    <p><strong>Source Shop:</strong> <%= request.getAttribute("sourceShopName") %></p>
    <p><strong>Destination Shop:</strong> <%= request.getAttribute("destShopName") %></p>
    <p><strong>Request Date:</strong> <%= borrowing.getRequestDate() %></p>
    <p><strong>Current Status:</strong> <%= borrowing.getStatus() %></p>
</div>

<form action="<%= request.getContextPath() %>/borrowing" method="post">
    <input type="hidden" name="action" value="approve">
    <input type="hidden" name="borrowingID" value="<%= borrowing.getBorrowingID() %>">
    
    <div style="display: flex; gap: 10px;">
        <button type="submit" class="btn" style="background-color: #4CAF50; color: white;">Confirm</button>
        <a href="<%= request.getContextPath() %>/borrowing?action=list" class="btn" style="background-color: #f44336; color: white;">Cancel</a>
    </div>
</form>

<%@include file="../footer.jsp"%> 