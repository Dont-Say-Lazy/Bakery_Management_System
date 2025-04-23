<%-- 
    Document   : addBorrowing
    Created on : Apr 23, 2025, 11:11:26 PM
    Author     : Rain
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="../header.jsp"%>
<%@page import="java.util.ArrayList"%>
<%@page import="ict.bean.FruitBean"%>
<%@page import="ict.bean.LocationBean"%>

<h1>Request to Borrow Fruit</h1>

<form action="<%=request.getContextPath()%>/borrowing" method="post">
    <input type="hidden" name="action" value="add">
    
    <div class="form-group">
        <label for="sourceShopID">Source Shop:</label>
        <select id="sourceShopID" name="sourceShopID" required>
            <option value="">Select Shop</option>
            <% 
                ArrayList<LocationBean> otherShops = (ArrayList<LocationBean>) request.getAttribute("otherShops");
                if (otherShops != null) {
                    for (LocationBean shop : otherShops) {
            %>
                <option value="<%= shop.getLocationID() %>"><%= shop.getName() %></option>
            <% 
                    }
                }
            %>
        </select>
    </div>
    
    <div class="form-group">
        <label for="fruitID">Fruit:</label>
        <select id="fruitID" name="fruitID" required>
            <option value="">Select Fruit</option>
            <% 
                ArrayList<FruitBean> fruits = (ArrayList<FruitBean>) request.getAttribute("fruits");
                if (fruits != null) {
                    for (FruitBean fruit : fruits) {
            %>
                <option value="<%= fruit.getFruitID() %>"><%= fruit.getName() %></option>
            <% 
                    }
                }
            %>
        </select>
    </div>
    
    <div class="form-group">
        <label for="quantity">Quantity:</label>
        <input type="number" id="quantity" name="quantity" min="1" required>
    </div>
    
    <div style="margin-top: 20px;">
        <button type="submit" class="btn">Submit Request</button>
        <a href="<%=request.getContextPath()%>/borrowing?action=list" class="btn" style="background-color: #ccc; color: #333;">Cancel</a>
    </div>
</form>

<%@include file="../footer.jsp"%>