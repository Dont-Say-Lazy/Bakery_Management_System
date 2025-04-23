<%-- 
    Document   : header
    Created on : Apr 23, 2025, 11:02:01 PM
    Author     : Rain
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Acer International Bakery</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
        }
        .container {
            width: 80%;
            margin: 0 auto;
            padding: 20px;
        }
        .header {
            background-color: #4CAF50;
            color: white;
            padding: 10px 0;
            text-align: center;
        }
        .nav {
            background-color: #333;
            overflow: hidden;
        }
        .nav a {
            float: left;
            color: white;
            text-align: center;
            padding: 14px 16px;
            text-decoration: none;
        }
        .nav a:hover {
            background-color: #ddd;
            color: black;
        }
        .nav a.active {
            background-color: #4CAF50;
            color: white;
        }
        .nav .user-info {
            float: right;
            color: white;
            padding: 14px 16px;
        }
        .nav .logout {
            float: right;
        }
        .content {
            padding: 20px;
            background-color: white;
            margin-top: 20px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        h1, h2 {
            color: #4CAF50;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        table, th, td {
            border: 1px solid #ddd;
        }
        th, td {
            padding: 12px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
        }
        .form-group input, .form-group select, .form-group textarea {
            width: 100%;
            padding: 8px;
            box-sizing: border-box;
            border: 1px solid #ddd;
            border-radius: 3px;
        }
        .btn {
            display: inline-block;
            padding: 10px 20px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 3px;
            cursor: pointer;
            text-decoration: none;
        }
        .btn:hover {
            background-color: #45a049;
        }
        .btn-danger {
            background-color: #f44336;
        }
        .btn-danger:hover {
            background-color: #d32f2f;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>Acer International Bakery</h1>
    </div>
    
    <div class="nav">
        <% 
            ict.bean.UserBean user = (ict.bean.UserBean) session.getAttribute("userInfo");
            String role = user != null ? user.getRole() : "";
            
            if (role.equals("shop_staff")) {
        %>
            <a href="<%=request.getContextPath()%>/shop/dashboard.jsp">Dashboard</a>
            <a href="<%=request.getContextPath()%>/shop/reserveFruit.jsp">Reserve Fruit</a>
            <a href="<%=request.getContextPath()%>/shop/borrowFruit.jsp">Borrow Fruit</a>
            <a href="<%=request.getContextPath()%>/shop/checkReserves.jsp">Check Reserves</a>
            <a href="<%=request.getContextPath()%>/shop/updateStock.jsp">Update Stock</a>
        <% } else if (role.equals("warehouse_staff")) { %>
            <a href="<%=request.getContextPath()%>/warehouse/dashboard.jsp">Dashboard</a>
            <a href="<%=request.getContextPath()%>/stock?action=showUpdateForm">Update Stock</a>
            <a href="<%=request.getContextPath()%>/reservation?action=list">Approve Requests</a>
            <a href="<%=request.getContextPath()%>/warehouse/arrangeDelivery.jsp">Arrange Delivery</a>
        <% } else if (role.equals("senior_management")) { %>
            <a href="<%=request.getContextPath()%>/management/dashboard.jsp">Dashboard</a>
            <a href="<%=request.getContextPath()%>/management/reports.jsp">Reports</a>
            <a href="<%=request.getContextPath()%>/user?action=list">User Management</a>
            <a href="<%=request.getContextPath()%>/fruit?action=list">Fruit Management</a>
        <% } %>
        
        <% if (user != null) { %>
            <a href="<%=request.getContextPath()%>/login?action=logout" class="logout">Logout</a>
            <div class="user-info">
                Welcome, <%= user.getName() %>
            </div>
        <% } %>
    </div>
    
    <div class="container">
        <div class="content">