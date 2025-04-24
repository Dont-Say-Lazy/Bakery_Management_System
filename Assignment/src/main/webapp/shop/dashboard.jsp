<%-- 
    Document   : dashboard
    Created on : Apr 23, 2025, 11:03:50 PM
    Author     : Rain
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="../header.jsp"%>
<%@ taglib uri="/WEB-INF/tlds/stocklevels" prefix="stock" %>

<div class="dashboard-header">
    <h1><i class="fas fa-store"></i> Shop Dashboard</h1>
    <p class="dashboard-welcome">Welcome to your shop management portal</p>
</div>

<div class="dashboard-stats">
    <div class="stat-card">
        <div class="stat-icon">
            <i class="fas fa-apple-alt"></i>
        </div>
        <div class="stat-info">
            <h3>Current Stock</h3>
            <p>Check your inventory levels</p>
        </div>
    </div>
    
    <div class="stat-card">
        <div class="stat-icon">
            <i class="fas fa-calendar-check"></i>
        </div>
        <div class="stat-info">
            <h3>Reservations</h3>
            <p>Manage fruit reservations</p>
        </div>
    </div>
    
    <div class="stat-card">
        <div class="stat-icon">
            <i class="fas fa-exchange-alt"></i>
        </div>
        <div class="stat-info">
            <h3>Borrowing</h3>
            <p>Track borrowed inventory</p>
        </div>
    </div>
</div>

<div class="dashboard-section">
    <h2><i class="fas fa-cubes"></i> Current Stock Levels</h2>
    <div class="stock-container">
        <stock:displayStock locationID="<%= user.getLocationID() %>"/>
    </div>
</div>

<div class="dashboard-section">
    <h2><i class="fas fa-bolt"></i> Quick Actions</h2>
    <div class="quick-actions">
        <a href="reserveFruit.jsp" class="action-card">
            <div class="action-icon">
                <i class="fas fa-calendar-plus"></i>
            </div>
            <div class="action-info">
                <h3>Reserve Fruits</h3>
                <p>Place new fruit reservations</p>
            </div>
        </a>
        
        <a href="<%=request.getContextPath()%>/borrowing?action=list" class="action-card">
            <div class="action-icon">
                <i class="fas fa-exchange-alt"></i>
            </div>
            <div class="action-info">
                <h3>Borrow Fruits</h3>
                <p>Request fruit borrowing</p>
            </div>
        </a>
        
        <a href="<%=request.getContextPath()%>/reservation?action=list" class="action-card">
            <div class="action-icon">
                <i class="fas fa-clipboard-list"></i>
            </div>
            <div class="action-info">
                <h3>Check Reservations</h3>
                <p>View reservation status</p>
            </div>
        </a>
        
        <a href="<%=request.getContextPath()%>/stock?action=view" class="action-card">
            <div class="action-icon">
                <i class="fas fa-sync-alt"></i>
            </div>
            <div class="action-info">
                <h3>Update Stock</h3>
                <p>Modify inventory levels</p>
            </div>
        </a>
    </div>
</div>

<style>
    .dashboard-header {
        margin-bottom: 30px;
        border-bottom: 1px solid rgba(77, 208, 197, 0.2);
        padding-bottom: 15px;
    }
    
    .dashboard-welcome {
        color: #777777;
        font-size: 16px;
        margin-top: 5px;
    }
    
    .dashboard-stats {
        display: flex;
        flex-wrap: wrap;
        gap: 20px;
        margin-bottom: 30px;
    }
    
    .stat-card {
        flex: 1;
        min-width: 200px;
        background-color: #ffffff;
        border-radius: 10px;
        box-shadow: 0 3px 10px rgba(0, 0, 0, 0.04);
        padding: 20px;
        display: flex;
        align-items: center;
        transition: transform 0.3s ease, box-shadow 0.3s ease;
        border: 1px solid rgba(77, 208, 197, 0.1);
    }
    
    .stat-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 5px 15px rgba(77, 208, 197, 0.15);
    }
    
    .stat-icon {
        width: 50px;
        height: 50px;
        border-radius: 12px;
        background-color: rgba(77, 208, 197, 0.1);
        display: flex;
        align-items: center;
        justify-content: center;
        margin-right: 15px;
    }
    
    .stat-icon i {
        font-size: 24px;
        color: #4DD0C5;
    }
    
    .stat-info h3 {
        margin: 0;
        font-size: 16px;
        font-weight: 600;
        color: #333333;
    }
    
    .stat-info p {
        margin: 5px 0 0;
        color: #777777;
        font-size: 14px;
    }
    
    .dashboard-section {
        margin-bottom: 40px;
    }
    
    .dashboard-section h2 {
        display: flex;
        align-items: center;
        font-size: 20px;
        margin-bottom: 20px;
    }
    
    .dashboard-section h2 i {
        margin-right: 10px;
        color: #4DD0C5;
    }
    
    .stock-container {
        background-color: #ffffff;
        border-radius: 10px;
        box-shadow: 0 3px 10px rgba(0, 0, 0, 0.04);
        padding: 20px;
        border: 1px solid rgba(77, 208, 197, 0.1);
    }
    
    .quick-actions {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
        gap: 20px;
    }
    
    .action-card {
        background-color: #ffffff;
        border-radius: 10px;
        box-shadow: 0 3px 10px rgba(0, 0, 0, 0.04);
        padding: 20px;
        display: flex;
        align-items: center;
        text-decoration: none;
        color: inherit;
        transition: transform 0.3s ease, box-shadow 0.3s ease;
        border: 1px solid rgba(77, 208, 197, 0.1);
    }
    
    .action-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 5px 15px rgba(77, 208, 197, 0.15);
    }
    
    .action-icon {
        width: 50px;
        height: 50px;
        border-radius: 12px;
        background-color: rgba(77, 208, 197, 0.1);
        display: flex;
        align-items: center;
        justify-content: center;
        margin-right: 15px;
    }
    
    .action-icon i {
        font-size: 20px;
        color: #4DD0C5;
    }
    
    .action-info h3 {
        margin: 0;
        font-size: 16px;
        font-weight: 600;
        color: #333333;
    }
    
    .action-info p {
        margin: 5px 0 0;
        color: #777777;
        font-size: 13px;
    }
    
    @media (max-width: 768px) {
        .quick-actions {
            grid-template-columns: 1fr;
        }
    }
</style>

<%@include file="../footer.jsp"%>
