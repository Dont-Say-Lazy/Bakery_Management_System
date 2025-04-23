<%-- 
    Document   : login
    Created on : Apr 23, 2025, 10:55:37 PM
    Author     : AlexS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Login - Acer International Bakery</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol";
            background-color: #e6f5f5;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            background-image: 
                radial-gradient(circle at 20% 20%, rgba(77, 208, 197, 0.15) 0%, transparent 20%),
                radial-gradient(circle at 80% 80%, rgba(77, 208, 197, 0.1) 0%, transparent 20%);
        }
        
        .main-container {
            width: 400px;
            min-height: 500px;
            background-color: #4DD0C5;
            border-radius: 16px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            position: relative;
            transition: transform 0.3s ease;
            padding: 50px 40px;
            color: #ffffff;
            background-image: 
                radial-gradient(circle at 90% 10%, rgba(255, 255, 255, 0.1) 0%, transparent 20%),
                radial-gradient(circle at 10% 90%, rgba(0, 0, 0, 0.03) 0%, transparent 30%);
            z-index: 1;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        
        .main-container:hover {
            transform: translateY(-5px);
        }
        
        .main-container::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255, 255, 255, 0.1) 0%, transparent 70%);
            opacity: 0;
            z-index: -1;
            transition: opacity 0.5s;
            pointer-events: none;
        }
        
        .main-container:hover::before {
            opacity: 1;
        }
        
        .main-container::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 5px;
            background: linear-gradient(to right, #39a59c, #FF9292);
            opacity: 0.7;
        }
        
        h1 {
            text-align: center;
            color: #ffffff;
            margin-bottom: 40px;
            font-size: 36px;
            position: relative;
            font-weight: 600;
        }
        
        h1::after {
            content: '';
            display: block;
            width: 60px;
            height: 4px;
            background-color: #ffffff;
            margin: 15px auto 0;
            border-radius: 2px;
            transition: width 0.3s ease;
        }
        
        .main-container:hover h1::after {
            width: 100px;
        }
        
        .form-group {
            margin-bottom: 24px;
            position: relative;
            transition: transform 0.2s ease;
        }
        
        .form-group:focus-within {
            transform: translateY(-4px);
        }
        
        .form-group input {
            width: 100%;
            padding: 15px 20px;
            box-sizing: border-box;
            border: none;
            border-radius: 30px;
            background-color: rgba(255, 255, 255, 0.2);
            color: #ffffff;
            font-size: 16px;
            font-family: inherit;
            transition: all 0.3s ease;
            padding-left: 45px;
            padding-right: 45px;
            letter-spacing: 0.5px;
        }
        
        .form-group input:focus {
            outline: none;
            background-color: rgba(255, 255, 255, 0.3);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
        
        .form-group input::placeholder {
            color: rgba(255, 255, 255, 0.8);
            font-weight: 300;
        }
        
        .form-group .input-icon {
            position: absolute;
            left: 18px;
            top: 50%;
            transform: translateY(-50%);
            color: #ffffff;
            font-size: 18px;
            transition: all 0.2s ease;
        }
        
        .form-group:focus-within .input-icon {
            transform: translateY(-50%) scale(1.1);
        }
        
        .toggle-password {
            position: absolute;
            right: 18px;
            top: 50%;
            transform: translateY(-50%);
            color: #ffffff;
            font-size: 16px;
            cursor: pointer;
            opacity: 0.8;
            transition: all 0.2s ease;
            background: none;
            border: none;
            outline: none;
        }
        
        .toggle-password:hover {
            opacity: 1;
            transform: translateY(-50%) scale(1.1);
        }
        
        .password-strength {
            display: flex;
            margin-top: 10px;
            gap: 5px;
            margin-bottom: 30px;
        }
        
        .strength-bar {
            height: 4px;
            flex: 1;
            background-color: rgba(255, 255, 255, 0.25);
            border-radius: 2px;
            transition: all 0.3s ease;
        }
        
        .btn-signin {
            width: 100%;
            padding: 14px 20px;
            border: none;
            border-radius: 30px;
            cursor: pointer;
            font-weight: 500;
            font-size: 16px;
            font-family: inherit;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            z-index: 1;
            background-color: #ffffff;
            color: #4DD0C5;
            box-shadow: 0 5px 15px rgba(77, 208, 197, 0.2);
        }
        
        .btn-signin::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: rgba(255, 255, 255, 0.1);
            transition: all 0.4s;
            z-index: -1;
        }
        
        .btn-signin:hover::before {
            left: 0;
        }
        
        .btn-signin:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(77, 208, 197, 0.3);
        }
        
        .btn-signin:active {
            transform: translateY(-1px);
            box-shadow: 0 3px 10px rgba(77, 208, 197, 0.2);
        }
        
        .error-message {
            color: #fff;
            margin-bottom: 20px;
            background-color: rgba(255, 100, 100, 0.3);
            padding: 15px;
            border-radius: 8px;
            border-left: 4px solid #FF6464;
            font-size: 14px;
            backdrop-filter: blur(5px);
            animation: shake 0.5s ease-in-out;
        }
        
        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            10%, 30%, 50%, 70%, 90% { transform: translateX(-5px); }
            20%, 40%, 60%, 80% { transform: translateX(5px); }
        }
        
        @media (max-width: 500px) {
            .main-container {
                width: 90%;
                padding: 40px 30px;
            }
        }
    </style>
</head>
<body>
    <div class="main-container">
        <h1>Welcome!</h1>
        
        <% if (request.getAttribute("errorMsg") != null) { %>
            <div class="error-message">
                <i class="fas fa-exclamation-circle"></i> <%= request.getAttribute("errorMsg") %>
            </div>
        <% } 
        %>
        
        <form action="login" method="post">
            <input type="hidden" name="action" value="login">
            
            <div class="form-group">
                <i class="fas fa-user input-icon"></i>
                <input type="text" id="username" name="username" placeholder="Your username" required autocomplete="off">
            </div>
            
            <div class="form-group">
                <i class="fas fa-lock input-icon"></i>
                <input type="password" id="password" name="password" placeholder="Your password" required>
                <button type="button" class="toggle-password" onclick="togglePassword()">
                    <i class="fas fa-eye"></i>
                </button>
            </div>
            
            <div class="password-strength">
                <div class="strength-bar"></div>
                <div class="strength-bar"></div>
                <div class="strength-bar"></div>
            </div>
            
            <button type="submit" class="btn-signin"><i class="fas fa-sign-in-alt"></i> Sign in</button>
        </form>
    </div>

    <script>
        function togglePassword() {
            const passwordField = document.getElementById('password');
            const toggleButton = document.querySelector('.toggle-password i');
            
            if (passwordField.type === 'password') {
                passwordField.type = 'text';
                toggleButton.classList.remove('fa-eye');
                toggleButton.classList.add('fa-eye-slash');
            } else {
                passwordField.type = 'password';
                toggleButton.classList.remove('fa-eye-slash');
                toggleButton.classList.add('fa-eye');
            }
        }
    </script>
</body>
</html>