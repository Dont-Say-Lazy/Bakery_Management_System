<%-- 
    Document   : dashboard
    Created on : Apr 23, 2025, 11:18:35 PM
    Author     : Rain
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="../header.jsp"%>

<div class="dashboard-header">
    <h1><i class="fas fa-chart-line"></i> Senior Management Dashboard</h1>
    <p class="dashboard-welcome">System administration and executive overview</p>
</div>

<div class="dashboard-stats">
    <div class="stat-card">
        <div class="stat-icon">
            <i class="fas fa-users"></i>
        </div>
        <div class="stat-info">
            <h3>User Accounts</h3>
            <p>Manage system users</p>
        </div>
    </div>
    
    <div class="stat-card">
        <div class="stat-icon">
            <i class="fas fa-apple-alt"></i>
        </div>
        <div class="stat-info">
            <h3>Products</h3>
            <p>Inventory and product management</p>
        </div>
    </div>
    
    <div class="stat-card">
        <div class="stat-icon">
            <i class="fas fa-chart-pie"></i>
        </div>
        <div class="stat-info">
            <h3>Analytics</h3>
            <p>Data and performance reports</p>
        </div>
    </div>
</div>

<div class="dashboard-section">
    <h2><i class="fas fa-tachometer-alt"></i> Management Controls</h2>
    
    <div class="management-panels">
        <div class="panel-card">
            <div class="panel-icon">
                <i class="fas fa-user-cog"></i>
            </div>
            <div class="panel-content">
                <h3>User Management</h3>
                <p>Create, update, and delete user accounts</p>
                <div class="panel-actions">
                    <a href="<%=request.getContextPath()%>/user?action=list" class="btn">Manage Users</a>
                </div>
            </div>
        </div>
        
        <div class="panel-card">
            <div class="panel-icon">
                <i class="fas fa-apple-alt"></i>
            </div>
            <div class="panel-content">
                <h3>Fruit Management</h3>
                <p>Manage fruit types in the system</p>
                <div class="panel-actions">
                    <a href="<%=request.getContextPath()%>/fruit?action=list" class="btn">Manage Fruits</a>
                </div>
            </div>
        </div>
        
        <div class="panel-card">
            <div class="panel-icon">
                <i class="fas fa-file-alt"></i>
            </div>
            <div class="panel-content">
                <h3>Reports</h3>
                <p>View reports and analytics</p>
                <div class="panel-actions">
                    <a href="<%=request.getContextPath()%>/management/reports.jsp" class="btn">View Reports</a>
                </div>
            </div>
        </div>
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
    
    .management-panels {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
        gap: 20px;
    }
    
    .panel-card {
        background-color: #ffffff;
        border-radius: 10px;
        box-shadow: 0 3px 10px rgba(0, 0, 0, 0.04);
        overflow: hidden;
        transition: transform 0.3s ease, box-shadow 0.3s ease;
        border: 1px solid rgba(77, 208, 197, 0.1);
    }
    
    .panel-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 5px 15px rgba(77, 208, 197, 0.15);
    }
    
    .panel-icon {
        padding: 30px;
        background-color: rgba(77, 208, 197, 0.1);
        display: flex;
        align-items: center;
        justify-content: center;
    }
    
    .panel-icon i {
        font-size: 40px;
        color: #4DD0C5;
    }
    
    .panel-content {
        padding: 20px;
        text-align: center;
    }
    
    .panel-content h3 {
        margin: 0;
        font-size: 18px;
        font-weight: 600;
        color: #333333;
    }
    
    .panel-content p {
        margin: 10px 0 20px;
        color: #777777;
        font-size: 14px;
    }
    
    .panel-actions {
        margin-top: 15px;
    }
    
    @media (max-width: 768px) {
        .management-panels {
            grid-template-columns: 1fr;
        }
    }
</style>

<%@include file="../footer.jsp"%>
