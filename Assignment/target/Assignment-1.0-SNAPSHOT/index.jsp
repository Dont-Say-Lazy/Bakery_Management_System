<%-- 
    Document   : index
    Created on : Apr 23, 2025, 11:14:26 PM
    Author     : AlexS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Check if user is logged in
    ict.bean.UserBean user = (ict.bean.UserBean) session.getAttribute("userInfo");
    
    if (user == null) {
        // Not logged in, redirect to login page
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Redirect based on user role
    String role = user.getRole();
    String redirectURL = "";
    
    if (role.equals("shop_staff")) {
        redirectURL = "shop/dashboard.jsp";
    } else if (role.equals("warehouse_staff")) {
        redirectURL = "warehouse/dashboard.jsp";
    } else if (role.equals("senior_management")) {
        redirectURL = "management/dashboard.jsp";
    } else {
        // Unknown role, redirect to login
        session.invalidate();
        response.sendRedirect("login.jsp");
        return;
    }
    
    response.sendRedirect(redirectURL);
%>
