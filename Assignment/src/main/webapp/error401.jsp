<%-- 
    Document   : error401
    Created on : Apr 24, 2025, 11:02:01 PM
    Author     : AlexS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8" isErrorPage="true"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>401 - Unauthorized | Acer International Bakery</title>
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
                min-height: 100vh;
                display: flex;
                flex-direction: column;
            }

            .container {
                width: 90%;
                max-width: 1200px;
                margin: 0 auto;
                padding: 20px;
                flex: 1;
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

            .error-content {
                padding: 50px 25px;
                background-color: white;
                margin: 40px auto;
                border-radius: 8px;
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
                text-align: center;
                max-width: 600px;
            }

            .error-icon {
                font-size: 80px;
                color: #FF9292;
                margin-bottom: 20px;
            }

            .error-title {
                font-size: 32px;
                color: #4DD0C5;
                margin-bottom: 15px;
            }

            .error-message {
                font-size: 18px;
                color: #666;
                margin-bottom: 30px;
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
                margin: 0 10px;
            }

            .btn:hover {
                background-color: #3ec0b5;
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(77, 208, 197, 0.4);
            }

            .btn-secondary {
                background-color: #FF9292;
            }

            .btn-secondary:hover {
                background-color: #ff7e7e;
                box-shadow: 0 4px 12px rgba(255, 146, 146, 0.4);
            }

            .footer {
                background-color: #ffffff;
                padding: 20px 0;
                margin-top: auto;
                border-top: 1px solid rgba(77, 208, 197, 0.2);
            }

            .footer-content {
                display: flex;
                justify-content: space-between;
                align-items: center;
                flex-wrap: wrap;
            }

            .footer-logo h3 {
                color: #4DD0C5;
                margin: 0;
                font-size: 18px;
            }

            .footer-logo p {
                color: #888888;
                margin: 5px 0 0;
                font-size: 14px;
            }

            .footer-links {
                color: #888888;
                font-size: 14px;
            }

            @media (max-width: 768px) {
                .footer-content {
                    flex-direction: column;
                    text-align: center;
                    gap: 10px;
                }

                .btn {
                    display: block;
                    margin: 10px auto;
                    max-width: 200px;
                }
            }
        </style>
    </head>
    <body>
        <div class="header">
            <h1>Acer International Bakery</h1>
        </div>

        <div class="container">
            <div class="error-content">
                <div class="error-icon">
                    <i class="fas fa-lock"></i>
                </div>
                <h1 class="error-title">401 - Unauthorized</h1>
                <p class="error-message">You don't have permission to access this page. Please log in or contact an administrator if you believe this is an error.</p>
                <div>
                    <a href="${pageContext.request.contextPath}/login.jsp" class="btn">
                        <i class="fas fa-sign-in-alt"></i> Log In
                    </a>
                    <%
                        String userRole = (String) session.getAttribute("role");
                        String homeUrl = request.getContextPath() + "/login.jsp";

                        if (userRole != null) {
                            if (userRole.equals("shop")) {
                                homeUrl = request.getContextPath() + "/shop/home.jsp";
                            } else if (userRole.equals("warehouse")) {
                                homeUrl = request.getContextPath() + "/warehouse/home.jsp";
                            } else if (userRole.equals("management")) {
                                homeUrl = request.getContextPath() + "/management/home.jsp";
                            }
                        }
                    %>
                    <a href="<%= homeUrl%>" class="btn btn-secondary">
                        <i class="fas fa-home"></i> Go to Homepage
                    </a>
                </div>
            </div>
        </div>

        <footer class="footer">
            <div class="container">
                <div class="footer-content">
                    <div class="footer-logo">
                        <h3>Acer International Bakery</h3>
                        <p>Fresh ingredients, great taste</p>
                    </div>
                    <div class="footer-links">
                        <p>&copy; <%= new SimpleDateFormat("yyyy").format(new Date())%> Acer International Bakery. All rights reserved.</p>
                    </div>
                </div>
            </div>
        </footer>
    </body>
</html> 