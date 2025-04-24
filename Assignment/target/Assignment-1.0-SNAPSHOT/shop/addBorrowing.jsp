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
<%@page import="ict.db.StockDB"%>

<h1>Request to Borrow Fruit</h1>

<% if (request.getAttribute("message") != null) { %>
    <div style="background-color: #f8d7da; color: #721c24; padding: 10px; margin-bottom: 15px; border-radius: 5px;">
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
                <option value="<%= shop.getLocationID() %>"><%= shop.getName() %></option>
            <% 
                    }
                }
            %>
        </select>
    </div>
    
    <div id="shopStockInfo" style="margin: 10px 0; padding: 10px; background-color: #f8f9fa; border-radius: 5px; display: none;">
        <p id="shopStockMessage"></p>
    </div>
    
    <div class="form-group">
        <label for="fruitID">Fruit:</label>
        <select id="fruitID" name="fruitID" class="form-control" required onchange="updateStockInfo()">
            <option value="">Select Shop First</option>
        </select>
    </div>
    
    <div id="stockInfo" style="margin: 10px 0; padding: 10px; background-color: #f8f9fa; border-radius: 5px; display: none;">
        <p id="stockMessage"></p>
    </div>
    
    <div class="form-group">
        <label for="quantity">Quantity:</label>
        <input type="number" id="quantity" name="quantity" min="1" class="form-control" required onchange="validateQuantity()">
        <small id="quantityHelp" class="form-text text-muted">Enter the quantity needed.</small>
    </div>
    
    <div style="margin-top: 20px;">
        <button type="submit" id="submitBtn" class="btn">Submit Request</button>
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
        var shopStockInfo = document.getElementById('shopStockInfo');
        var shopStockMessage = document.getElementById('shopStockMessage');
        
        if (!shopID) {
            // Reset fruit dropdown if no shop selected
            fruitSelect.innerHTML = '<option value="">Select Shop First</option>';
            shopStockInfo.style.display = 'none';
            return;
        }
        
        // Show loading indicator
        fruitSelect.innerHTML = '<option value="">Loading fruits...</option>';
        
        // Get stock data from server for this shop
        fetch('<%=request.getContextPath()%>/borrowing?action=getShopStock&shopID=' + shopID)
            .then(response => response.json())
            .then(data => {
                stockData = data;
                
                // Reset options
                fruitSelect.innerHTML = '<option value="">Select Fruit</option>';
                
                // Add options for fruits with stock
                if (data && data.length > 0) {
                    shopStockMessage.textContent = 'This shop has ' + data.length + ' types of fruit available.';
                    shopStockInfo.style.display = 'block';
                    shopStockInfo.style.backgroundColor = '#d4edda';
                    
                    data.forEach(item => {
                        var option = document.createElement('option');
                        option.value = item.fruitID;
                        option.setAttribute('data-stock', item.quantity);
                        option.textContent = item.fruitName + ' (Available: ' + item.quantity + ')';
                        fruitSelect.appendChild(option);
                    });
                } else {
                    shopStockMessage.textContent = 'This shop has no fruits available for borrowing.';
                    shopStockInfo.style.display = 'block';
                    shopStockInfo.style.backgroundColor = '#f8d7da';
                    fruitSelect.innerHTML = '<option value="">No fruits available</option>';
                }
                
                // Update stock info
                updateStockInfo();
            })
            .catch(error => {
                console.error('Error fetching shop stock:', error);
                fruitSelect.innerHTML = '<option value="">Error loading fruits</option>';
            });
    }
    
    // Function to update stock info based on selected fruit
    function updateStockInfo() {
        var fruitSelect = document.getElementById('fruitID');
        var stockInfo = document.getElementById('stockInfo');
        var stockMessage = document.getElementById('stockMessage');
        
        if (fruitSelect.selectedIndex <= 0) {
            stockInfo.style.display = 'none';
            return;
        }
        
        var selectedOption = fruitSelect.options[fruitSelect.selectedIndex];
        var stock = selectedOption.getAttribute('data-stock');
        
        if (stock && stock > 0) {
            stockMessage.textContent = 'Available stock: ' + stock + ' units';
            stockInfo.style.display = 'block';
            stockInfo.style.backgroundColor = '#d4edda';
            document.getElementById('quantity').max = stock;
            document.getElementById('quantity').value = Math.min(document.getElementById('quantity').value || 1, stock);
        } else {
            stockInfo.style.display = 'none';
        }
        
        validateQuantity();
    }
    
    // Function to validate quantity
    function validateQuantity() {
        var fruitSelect = document.getElementById('fruitID');
        var quantityInput = document.getElementById('quantity');
        var submitBtn = document.getElementById('submitBtn');
        
        if (fruitSelect.selectedIndex <= 0) {
            return;
        }
        
        var selectedOption = fruitSelect.options[fruitSelect.selectedIndex];
        var stock = parseInt(selectedOption.getAttribute('data-stock'));
        var quantity = parseInt(quantityInput.value);
        
        if (quantity > stock) {
            quantityInput.setCustomValidity('Requested quantity exceeds available stock');
            submitBtn.disabled = true;
        } else if (quantity <= 0) {
            quantityInput.setCustomValidity('Quantity must be at least 1');
            submitBtn.disabled = true;
        } else {
            quantityInput.setCustomValidity('');
            submitBtn.disabled = false;
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