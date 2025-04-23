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
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #e6f5f5;
            color: #333333;
        }
        
        .container {
            width: 90%;
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .header {
            background-color: #4DD0C5;
            color: white;
            padding: 15px 0;
            text-align: center;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            position: relative;
        }
        
        .header::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 3px;
            background: linear-gradient(to right, #39a59c, #FF9292);
            opacity: 0.7;
        }
        
        .header h1 {
            font-weight: 600;
            font-size: 28px;
            letter-spacing: 0.5px;
            margin: 0;
        }
        
        .nav {
            background-color: #ffffff;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            border-radius: 0 0 8px 8px;
        }
        
        .nav a {
            float: left;
            color: #333333;
            text-align: center;
            padding: 16px 18px;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.2s ease;
            position: relative;
        }
        
        .nav a::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 50%;
            width: 0;
            height: 3px;
            background-color: #4DD0C5;
            transition: all 0.3s ease;
            transform: translateX(-50%);
        }
        
        .nav a:hover {
            color: #4DD0C5;
            background-color: rgba(77, 208, 197, 0.05);
        }
        
        .nav a:hover::after {
            width: 70%;
        }
        
        .nav a.active {
            background-color: rgba(77, 208, 197, 0.1);
            color: #4DD0C5;
            font-weight: 600;
        }
        
        .nav a.active::after {
            width: 70%;
        }
        
        .nav .user-info {
            float: right;
            color: #555555;
            padding: 16px 18px;
            display: flex;
            align-items: center;
        }
        
        .nav .user-info i {
            margin-right: 8px;
            color: #4DD0C5;
        }
        
        .nav .logout {
            float: right;
            background-color: #FF9292;
            color: white;
            font-weight: 500;
            padding: 16px 20px;
            transition: all 0.2s ease;
        }
        
        .nav .logout:hover {
            background-color: #ffb1b1;
            color: white;
            transform: translateY(-2px);
        }
        
        .content {
            padding: 25px;
            background-color: white;
            margin-top: 20px;
            border-radius: 8px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            transition: transform 0.3s ease;
        }
        
        .content:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.08);
        }
        
        h1, h2 {
            color: #4DD0C5;
            margin-bottom: 20px;
            position: relative;
            padding-bottom: 10px;
        }
        
        h1::after, h2::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 40px;
            height: 3px;
            background-color: #4DD0C5;
            border-radius: 2px;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 0 0 1px #e0e0e0;
        }
        
        th, td {
            padding: 14px;
            text-align: left;
            border-bottom: 1px solid #e0e0e0;
        }
        
        th {
            background-color: #f9f9f9;
            font-weight: 600;
            color: #555555;
        }
        
        tr:last-child td {
            border-bottom: none;
        }
        
        tr:hover {
            background-color: rgba(77, 208, 197, 0.05);
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 6px;
            font-weight: 500;
            color: #555555;
        }
        
        .form-group input, .form-group select, .form-group textarea {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #e0e0e0;
            border-radius: 6px;
            background-color: #f9f9f9;
            transition: all 0.3s ease;
        }
        
        .form-group input:focus, .form-group select:focus, .form-group textarea:focus {
            outline: none;
            border-color: #4DD0C5;
            background-color: #ffffff;
            box-shadow: 0 0 0 3px rgba(77, 208, 197, 0.1);
        }
        
        .btn {
            display: inline-block;
            padding: 12px 24px;
            background-color: #4DD0C5;
            color: white;
            border: none;
            border-radius: 30px;
            cursor: pointer;
            text-decoration: none;
            font-weight: 500;
            font-size: 15px;
            transition: all 0.3s ease;
            text-align: center;
            box-shadow: 0 2px 8px rgba(77, 208, 197, 0.3);
        }
        
        .btn:hover {
            background-color: #3ec0b5;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(77, 208, 197, 0.4);
        }
        
        .btn:active {
            transform: translateY(0);
        }
        
        .btn-danger {
            background-color: #FF9292;
            box-shadow: 0 2px 8px rgba(255, 146, 146, 0.3);
        }
        
        .btn-danger:hover {
            background-color: #ffb1b1;
            box-shadow: 0 4px 12px rgba(255, 146, 146, 0.4);
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
            <a href="<%=request.getContextPath()%>/shop/dashboard.jsp" class="<%= request.getRequestURI().endsWith("/shop/dashboard.jsp") ? "active" : "" %>">
                <i class="fas fa-home"></i> Dashboard
            </a>
            <a href="<%=request.getContextPath()%>/shop/reserveFruit.jsp" class="<%= request.getRequestURI().endsWith("/shop/reserveFruit.jsp") ? "active" : "" %>">
                <i class="fas fa-calendar-plus"></i> Reserve Fruit
            </a>
            <a href="<%=request.getContextPath()%>/shop/borrowFruit.jsp" class="<%= request.getRequestURI().endsWith("/shop/borrowFruit.jsp") ? "active" : "" %>">
                <i class="fas fa-exchange-alt"></i> Borrow Fruit
            </a>
            <a href="<%=request.getContextPath()%>/shop/checkReserves.jsp" class="<%= request.getRequestURI().endsWith("/shop/checkReserves.jsp") ? "active" : "" %>">
                <i class="fas fa-clipboard-list"></i> Check Reserves
            </a>
            <a href="<%=request.getContextPath()%>/shop/updateStock.jsp" class="<%= request.getRequestURI().endsWith("/shop/updateStock.jsp") ? "active" : "" %>">
                <i class="fas fa-sync-alt"></i> Update Stock
            </a>
        <% } else if (role.equals("warehouse_staff")) { %>
            <a href="<%=request.getContextPath()%>/warehouse/dashboard.jsp" class="<%= request.getRequestURI().endsWith("/warehouse/dashboard.jsp") ? "active" : "" %>">
                <i class="fas fa-home"></i> Dashboard
            </a>
            <a href="<%=request.getContextPath()%>/stock?action=showUpdateForm" class="<%= request.getQueryString() != null && request.getQueryString().contains("action=showUpdateForm") ? "active" : "" %>">
                <i class="fas fa-sync-alt"></i> Update Stock
            </a>
            <a href="<%=request.getContextPath()%>/reservation?action=list" class="<%= request.getQueryString() != null && request.getQueryString().contains("action=list") && request.getRequestURL().toString().contains("/reservation") ? "active" : "" %>">
                <i class="fas fa-clipboard-check"></i> Approve Requests
            </a>
            <a href="<%=request.getContextPath()%>/warehouse/arrangeDelivery.jsp" class="<%= request.getRequestURI().endsWith("/warehouse/arrangeDelivery.jsp") ? "active" : "" %>">
                <i class="fas fa-truck"></i> Arrange Delivery
            </a>
        <% } else if (role.equals("senior_management")) { %>
            <a href="<%=request.getContextPath()%>/management/dashboard.jsp" class="<%= request.getRequestURI().endsWith("/management/dashboard.jsp") ? "active" : "" %>">
                <i class="fas fa-home"></i> Dashboard
            </a>
            <a href="<%=request.getContextPath()%>/management/reports.jsp" class="<%= request.getRequestURI().endsWith("/management/reports.jsp") ? "active" : "" %>">
                <i class="fas fa-chart-bar"></i> Reports
            </a>
            <a href="<%=request.getContextPath()%>/user?action=list" class="<%= request.getQueryString() != null && request.getQueryString().contains("action=list") && request.getRequestURL().toString().contains("/user") ? "active" : "" %>">
                <i class="fas fa-users"></i> User Management
            </a>
            <a href="<%=request.getContextPath()%>/fruit?action=list" class="<%= request.getQueryString() != null && request.getQueryString().contains("action=list") && request.getRequestURL().toString().contains("/fruit") ? "active" : "" %>">
                <i class="fas fa-apple-alt"></i> Fruit Management
            </a>
        <% } %>
        
        <% if (user != null) { %>
            <a href="<%=request.getContextPath()%>/login?action=logout" class="logout">
                <i class="fas fa-sign-out-alt"></i> Logout
            </a>
            <div class="user-info">
                <i class="fas fa-user-circle"></i> Welcome, <%= user.getName() %>
            </div>
        <% } %>
    </div>
    
    <div class="container">
        <div class="content">