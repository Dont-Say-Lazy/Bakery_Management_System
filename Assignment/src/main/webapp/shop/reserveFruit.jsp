<%-- 
    Document   : reserveFruit
    Created on : Apr 23, 2025, 11:09:14 PM
    Author     : Rain
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="../header.jsp"%>
<%@ taglib uri="/WEB-INF/tlds/locations" prefix="loc" %>
<%@page import="java.util.ArrayList"%>
<%@page import="ict.bean.FruitBean"%>
<%@page import="ict.bean.LocationBean"%>
<%@page import="ict.bean.StockBean"%>
<%@page import="ict.db.StockDB"%>

<% 
    String dbUrl = application.getInitParameter("dbUrl");
    String dbUser = application.getInitParameter("dbUser");
    String dbPassword = application.getInitParameter("dbPassword");
    
    StockDB stockDB = new StockDB(dbUrl, dbUser, dbPassword);
%>

<h1>Reserve Fruit from Warehouse</h1>

<%-- Display any messages --%>
<% if (request.getAttribute("message") != null) { %>
    <div style="background-color: #d4edda; color: #155724; padding: 10px; margin-bottom: 15px; border-radius: 5px;">
        <%= request.getAttribute("message") %>
    </div>
<% } %>

<form action="<%=request.getContextPath()%>/reservation" method="post" id="reservationForm">
    <input type="hidden" name="action" value="add">
    
    <div class="form-group">
        <label for="warehouseID">Source Warehouse:</label>
        <loc:selector name="warehouseID" id="warehouseID" type="warehouse" 
                     cssClass="form-control" 
                     required="true"
                     onChange="updateFruitOptions()" />
    </div>
    
    <div class="form-group">
        <label for="fruitID">Fruit:</label>
        <select id="fruitID" name="fruitID" class="form-control" required onchange="updateMaxQuantity()">
            <option value="">Select Fruit</option>
            <% 
                ArrayList<FruitBean> fruits = (ArrayList<FruitBean>) request.getAttribute("fruits");
                if (fruits != null) {
                    for (FruitBean fruit : fruits) {
            %>
                <option value="<%= fruit.getFruitID() %>" data-id="<%= fruit.getFruitID() %>">
                    <%= fruit.getName() %> (Source: <%= fruit.getSourceCountry() %>)
                </option>
            <% 
                    }
                }
            %>
        </select>
    </div>
    
    <div id="stockInfo" style="margin: 10px 0; padding: 10px; background-color: #f8f9fa; border-radius: 5px; display: none;">
        <p id="stockMessage"></p>
    </div>
    
    <div class="form-group">
        <label for="quantity">Quantity:</label>
        <input type="number" id="quantity" name="quantity" min="1" class="form-control" required>
        <small id="quantityHelp" class="form-text text-muted">Enter the quantity needed.</small>
    </div>
    
    <div class="form-group">
        <label for="deliveryDate">Delivery Date:</label>
        <input type="date" id="deliveryDate" name="deliveryDate" class="form-control" required>
        <small class="form-text text-muted">Select a date within the next 14 days.</small>
    </div>
    
    <div style="margin-top: 20px;">
        <button type="submit" class="btn" id="submitBtn">Submit Reservation</button>
        <a href="<%=request.getContextPath()%>/shop/dashboard.jsp" class="btn" style="background-color: #ccc; color: #333;">Cancel</a>
    </div>
</form>

<script>
    // Set minimum date to today
    var today = new Date();
    var maxDate = new Date();
    maxDate.setDate(today.getDate() + 14); // Max 14 days in the future
    
    var todayFormatted = today.toISOString().split('T')[0];
    var maxDateFormatted = maxDate.toISOString().split('T')[0];
    
    document.getElementById('deliveryDate').setAttribute('min', todayFormatted);
    document.getElementById('deliveryDate').setAttribute('max', maxDateFormatted);
    
    // Global variable to store stock data
    var stockData = {};
    
    // Function to update fruit options based on selected warehouse
    function updateFruitOptions() {
        var warehouseID = document.getElementById('warehouseID').value;
        var fruitSelect = document.getElementById('fruitID');
        
        if (!warehouseID) {
            // Reset fruit dropdown if no warehouse selected
            fruitSelect.innerHTML = '<option value="">Select Fruit</option>';
            return;
        }
        
        // Show loading indicator
        fruitSelect.innerHTML = '<option value="">Loading fruits...</option>';
        
        // Get stock data from server for this warehouse
        fetch('<%=request.getContextPath()%>/reservation?action=getWarehouseStock&warehouseID=' + warehouseID)
            .then(response => response.json())
            .then(data => {
                stockData = data;
                
                // Reset options
                fruitSelect.innerHTML = '<option value="">Select Fruit</option>';
                
                // Add options for fruits with stock
                if (data && data.length > 0) {
                    data.forEach(item => {
                        var option = document.createElement('option');
                        option.value = item.fruitID;
                        option.setAttribute('data-stock', item.quantity);
                        option.textContent = item.fruitName + ' (Available: ' + item.quantity + ')';
                        fruitSelect.appendChild(option);
                    });
                } else {
                    fruitSelect.innerHTML = '<option value="">No fruits available in this warehouse</option>';
                }
                
                // Update max quantity
                updateMaxQuantity();
            })
            .catch(error => {
                console.error('Error fetching warehouse stock:', error);
                fruitSelect.innerHTML = '<option value="">Error loading fruits</option>';
            });
    }
    
    // Function to update max quantity based on selected fruit
    function updateMaxQuantity() {
        var fruitSelect = document.getElementById('fruitID');
        var quantityInput = document.getElementById('quantity');
        var stockInfo = document.getElementById('stockInfo');
        var stockMessage = document.getElementById('stockMessage');
        var submitBtn = document.getElementById('submitBtn');
        
        if (fruitSelect.selectedIndex <= 0) {
            quantityInput.max = '';
            stockInfo.style.display = 'none';
            return;
        }
        
        var selectedOption = fruitSelect.options[fruitSelect.selectedIndex];
        var stock = selectedOption.getAttribute('data-stock');
        
        if (stock && stock > 0) {
            quantityInput.max = stock;
            quantityInput.value = Math.min(quantityInput.value || 1, stock);
            stockMessage.textContent = 'Available stock: ' + stock + ' units';
            stockInfo.style.display = 'block';
            stockInfo.style.backgroundColor = '#d4edda';
            submitBtn.disabled = false;
        } else {
            quantityInput.max = '0';
            quantityInput.value = '';
            stockMessage.textContent = 'No stock available for this fruit in the selected warehouse.';
            stockInfo.style.display = 'block';
            stockInfo.style.backgroundColor = '#f8d7da';
            submitBtn.disabled = true;
        }
    }
    
    // Form validation
    document.getElementById('reservationForm').addEventListener('submit', function(e) {
        var warehouseID = document.getElementById('warehouseID').value;
        var fruitID = document.getElementById('fruitID').value;
        var quantity = document.getElementById('quantity').value;
        
        if (!warehouseID || !fruitID) {
            e.preventDefault();
            alert('Please select both a warehouse and a fruit');
            return false;
        }
        
        var selectedOption = document.getElementById('fruitID').options[document.getElementById('fruitID').selectedIndex];
        var stock = selectedOption.getAttribute('data-stock');
        
        if (parseInt(quantity) > parseInt(stock)) {
            e.preventDefault();
            alert('Requested quantity exceeds available stock');
            return false;
        }
        
        return true;
    });
</script>

<%@include file="../footer.jsp"%>
