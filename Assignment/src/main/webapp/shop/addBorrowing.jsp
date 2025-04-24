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
<%@page import="ict.bean.StockBean"%>
<%@page import="ict.db.StockDB"%>

<% 
    String dbUrl = application.getInitParameter("dbUrl");
    String dbUser = application.getInitParameter("dbUser");
    String dbPassword = application.getInitParameter("dbPassword");
    
    StockDB stockDB = new StockDB(dbUrl, dbUser, dbPassword);
%>

<h1>Request to Borrow Fruit</h1>

<%-- Display any messages --%>
<% if (request.getAttribute("message") != null) { %>
    <div style="background-color: #d4edda; color: #155724; padding: 10px; margin-bottom: 15px; border-radius: 5px;">
        <%= request.getAttribute("message") %>
    </div>
<% } %>

<form action="<%=request.getContextPath()%>/borrowing" method="post" id="borrowingForm">
    <input type="hidden" name="action" value="add">
    
    <div class="form-group">
        <label for="sourceShopID">Source Shop:</label>
        <select id="sourceShopID" name="sourceShopID" class="form-control" required onchange="updateFruitOptions()">
            <option value="">Select Shop</option>
            <% 
                ArrayList<LocationBean> otherShops = (ArrayList<LocationBean>) request.getAttribute("otherShops");
                if (otherShops != null) {
                    for (LocationBean shop : otherShops) {
            %>
                <option value="<%= shop.getLocationID() %>"><%= shop.getName() %> (<%= shop.getCity() %>)</option>
            <% 
                    }
                }
            %>
        </select>
        <small class="form-text text-muted">Select a shop in your city to borrow from.</small>
    </div>
    
    <div id="stockInfo" style="margin: 10px 0; padding: 10px; background-color: #f8f9fa; border-radius: 5px; display: none;">
        <p id="stockMessage"></p>
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
                <option value="<%= fruit.getFruitID() %>" data-id="<%= fruit.getFruitID() %>"><%= fruit.getName() %></option>
            <% 
                    }
                }
            %>
        </select>
    </div>
    
    <div class="form-group">
        <label for="quantity">Quantity:</label>
        <input type="number" id="quantity" name="quantity" min="1" class="form-control" required>
        <small id="quantityHelp" class="form-text text-muted">Enter the quantity you wish to borrow.</small>
    </div>
    
    <div style="margin-top: 20px;">
        <button type="submit" class="btn" id="submitBtn">Submit Request</button>
        <a href="<%=request.getContextPath()%>/borrowing?action=list" class="btn" style="background-color: #ccc; color: #333;">Cancel</a>
    </div>
</form>

<script>
    // Global variable to store stock data
    var stockData = {};
    
    // Function to update fruit options based on selected shop
    function updateFruitOptions() {
        var shopID = document.getElementById('sourceShopID').value;
        var fruitSelect = document.getElementById('fruitID');
        
        if (!shopID) {
            // Reset fruit dropdown if no shop selected
            fruitSelect.innerHTML = '<option value="">Select Fruit</option>';
            document.getElementById('stockInfo').style.display = 'none';
            return;
        }
        
        // Show loading indicator
        fruitSelect.innerHTML = '<option value="">Loading fruits...</option>';
        document.getElementById('stockMessage').textContent = 'Loading available fruits...';
        document.getElementById('stockInfo').style.display = 'block';
        document.getElementById('stockInfo').style.backgroundColor = '#f8f9fa';
        
        // Get stock data from server for this shop
        fetch('<%=request.getContextPath()%>/borrowing?action=getShopStock&shopID=' + shopID)
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
                    document.getElementById('stockMessage').textContent = 'Select a fruit to see available stock';
                } else {
                    fruitSelect.innerHTML = '<option value="">No fruits available in this shop</option>';
                    document.getElementById('stockMessage').textContent = 'This shop has no fruit stock available for borrowing';
                    document.getElementById('stockInfo').style.backgroundColor = '#f8d7da';
                }
                
                // Update max quantity
                updateMaxQuantity();
            })
            .catch(error => {
                console.error('Error fetching shop stock:', error);
                fruitSelect.innerHTML = '<option value="">Error loading fruits</option>';
                document.getElementById('stockMessage').textContent = 'Error loading fruit data. Please try again.';
                document.getElementById('stockInfo').style.backgroundColor = '#f8d7da';
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
            stockMessage.textContent = 'No stock available for this fruit in the selected shop.';
            stockInfo.style.display = 'block';
            stockInfo.style.backgroundColor = '#f8d7da';
            submitBtn.disabled = true;
        }
    }
    
    // Form validation
    document.getElementById('borrowingForm').addEventListener('submit', function(e) {
        var shopID = document.getElementById('sourceShopID').value;
        var fruitID = document.getElementById('fruitID').value;
        var quantity = document.getElementById('quantity').value;
        
        if (!shopID || !fruitID) {
            e.preventDefault();
            alert('Please select both a shop and a fruit');
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