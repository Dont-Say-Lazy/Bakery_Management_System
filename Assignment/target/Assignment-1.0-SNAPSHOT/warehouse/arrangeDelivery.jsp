<%-- 
    Document   : arrangeDelivery
    Created on : 23 Apr 2025, 23:05:05
    Author     : AlexS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="../header.jsp"%>
<%@ taglib uri="/WEB-INF/tlds/locations" prefix="loc" %>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Map"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="ict.bean.ReservationBean"%>
<%@page import="ict.bean.FruitBean"%>
<%@page import="ict.bean.StockBean"%>
<%@page import="ict.db.ReservationDB"%>
<%@page import="ict.db.LocationDB"%>
<%@page import="ict.db.FruitDB"%>
<%@page import="ict.db.StockDB"%>

<% 
    String dbUrl = application.getInitParameter("dbUrl");
    String dbUser = application.getInitParameter("dbUser");
    String dbPassword = application.getInitParameter("dbPassword");
    
    ReservationDB reservationDB = new ReservationDB(dbUrl, dbUser, dbPassword);
    ArrayList<ReservationBean> approvedReservations = reservationDB.getReservationsByStatus("approved");
    
    // Get the user's location ID for pre-selection
    int userLocationID = user.getLocationID();
    boolean isCentralStaff = user.getIsCentralStaff() == 1;
    
    // Get StockDB instance for stock validation
    StockDB stockDB = new StockDB(dbUrl, dbUser, dbPassword);
    
    // Get fruits for selection dropdown (will be filtered by JavaScript)
    FruitDB fruitDB = new FruitDB(dbUrl, dbUser, dbPassword);
    ArrayList<FruitBean> allFruits = fruitDB.queryFruit();
    
    // Get stock at user's location to initialize the fruit dropdown
    ArrayList<StockBean> stockAtLocation = stockDB.queryStockByLocation(userLocationID);
    
    // Check for delivery success and details
    Boolean deliverySuccess = (Boolean) session.getAttribute("deliverySuccess");
    Map<String, Object> deliveryDetails = null;
    if (deliverySuccess != null && deliverySuccess) {
        deliveryDetails = (Map<String, Object>) session.getAttribute("deliveryDetails");
    }
    
    // Get any messages from the session
    String errorMessage = (String) session.getAttribute("errorMessage");
    
    // Clear the messages after reading
    session.removeAttribute("deliverySuccess");
    session.removeAttribute("deliveryDetails");
    session.removeAttribute("errorMessage");
    
    // Format for displaying date
    SimpleDateFormat dateFormat = new SimpleDateFormat("MMMM d, yyyy");
%>

<h1>Arrange Deliveries</h1>

<% if (deliverySuccess != null && deliverySuccess && deliveryDetails != null) { %>
    <div class="alert alert-success" style="background-color: #d4edda; color: #155724; padding: 15px; border-radius: 5px; margin-bottom: 20px;">
        <h3 style="margin-top: 0;">Delivery Arranged Successfully!</h3>
        <table style="width: 100%; border-collapse: collapse; margin-top: 10px;">
            <tr>
                <th style="text-align: left; padding: 8px; border-bottom: 1px solid #c3e6cb; width: 30%;">Delivery ID:</th>
                <td style="padding: 8px; border-bottom: 1px solid #c3e6cb;"><%= deliveryDetails.get("deliveryId") %></td>
            </tr>
            <tr>
                <th style="text-align: left; padding: 8px; border-bottom: 1px solid #c3e6cb;">Source Location:</th>
                <td style="padding: 8px; border-bottom: 1px solid #c3e6cb;"><%= deliveryDetails.get("sourceLocationName") %></td>
            </tr>
            <tr>
                <th style="text-align: left; padding: 8px; border-bottom: 1px solid #c3e6cb;">Destination Location:</th>
                <td style="padding: 8px; border-bottom: 1px solid #c3e6cb;"><%= deliveryDetails.get("destinationLocationName") %></td>
            </tr>
            <tr>
                <th style="text-align: left; padding: 8px; border-bottom: 1px solid #c3e6cb;">Fruit:</th>
                <td style="padding: 8px; border-bottom: 1px solid #c3e6cb;"><%= deliveryDetails.get("fruitName") %></td>
            </tr>
            <tr>
                <th style="text-align: left; padding: 8px; border-bottom: 1px solid #c3e6cb;">Quantity:</th>
                <td style="padding: 8px; border-bottom: 1px solid #c3e6cb;"><%= deliveryDetails.get("quantity") %></td>
            </tr>
            <tr>
                <th style="text-align: left; padding: 8px; border-bottom: 1px solid #c3e6cb;">Delivery Date:</th>
                <td style="padding: 8px; border-bottom: 1px solid #c3e6cb;"><%= dateFormat.format(deliveryDetails.get("deliveryDate")) %></td>
            </tr>
            <tr>
                <th style="text-align: left; padding: 8px; border-bottom: 1px solid #c3e6cb;">Previous Stock:</th>
                <td style="padding: 8px; border-bottom: 1px solid #c3e6cb;"><%= deliveryDetails.get("previousStock") %></td>
            </tr>
            <tr>
                <th style="text-align: left; padding: 8px; border-bottom: 1px solid #c3e6cb;">New Stock:</th>
                <td style="padding: 8px; border-bottom: 1px solid #c3e6cb;"><%= deliveryDetails.get("newStock") %></td>
            </tr>
            <tr>
                <th style="text-align: left; padding: 8px;">Status:</th>
                <td style="padding: 8px;"><span style="background-color: #17a2b8; color: white; padding: 3px 8px; border-radius: 4px;">Pending</span></td>
            </tr>
        </table>
        <p style="margin-top: 15px;">The delivery has been scheduled and will appear in the approved reservations list above.</p>
    </div>
<% } %>

<% if (errorMessage != null && !errorMessage.isEmpty()) { %>
    <div class="alert alert-danger">
        <%= errorMessage %>
    </div>
<% } %>

<% 
    // Get any request-scoped error messages
    String requestErrorMessage = (String) request.getAttribute("errorMessage");
    if (requestErrorMessage != null && !requestErrorMessage.isEmpty()) {
%>
    <div class="alert alert-danger">
        <%= requestErrorMessage %>
    </div>
<% } %>

<h2>Approved Reservations Ready for Delivery</h2>

<table>
    <thead>
        <tr>
            <th>ID</th>
            <th>Shop</th>
            <th>Fruit</th>
            <th>Quantity</th>
            <th>Request Date</th>
            <th>Delivery Date</th>
            <th>Status</th>
            <th>Actions</th>
        </tr>
    </thead>
    <tbody>
        <% 
            if (approvedReservations != null && !approvedReservations.isEmpty()) {
                for (ReservationBean reservation : approvedReservations) {
        %>
        <tr>
            <td><%= reservation.getReservationID() %></td>
            <td><%= reservation.getShopName() %></td>
            <td><%= reservation.getFruitName() %></td>
            <td><%= reservation.getQuantity() %></td>
            <td><%= reservation.getRequestDate() %></td>
            <td><%= reservation.getDeliveryDate() %></td>
            <td><%= reservation.getStatus() %></td>
            <td>
                <a href="<%=request.getContextPath()%>/reservation?action=confirmDeliver&reservationID=<%= reservation.getReservationID() %>" class="btn" style="background-color: blue;">Mark as Delivered</a>
            </td>
        </tr>
        <% 
                }
            } else {
        %>
        <tr>
            <td Colspan="8">No approved reservations pending delivery</td>
        </tr>
        <% } %>
    </tbody>
</table>

<h2>Arrange New Delivery</h2>
<form action="<%=request.getContextPath()%>/delivery" method="post" id="deliveryForm">
    <input type="hidden" name="action" value="add">
    
    <div class="form-group">
        <label for="sourceLocationID">Source Location:</label>
        <loc:selector name="sourceLocationID" id="sourceLocationID" 
                     cssClass="form-control" 
                     required="true" 
                     selectedValue="<%= String.valueOf(userLocationID) %>"
                     selectorType="source"
                     onChange="validateLocations(); updateFruitOptions();" />
    </div>
    
    <div class="form-group">
        <label for="destinationLocationID">Destination Location:</label>
        <loc:selector name="destinationLocationID" id="destinationLocationID" 
                     cssClass="form-control" 
                     required="true"
                     excludeIds="<%= String.valueOf(userLocationID) %>"
                     selectorType="destination"
                     onChange="validateLocations()" />
    </div>
    
    <div class="form-group">
        <label for="fruitID">Fruit:</label>
        <select id="fruitID" name="fruitID" class="form-control" required onChange="updateMaxQuantity()">
            <option value="">-- Select Fruit --</option>
            <% 
                // Only show fruits that are in stock at the source location
                if (stockAtLocation != null && !stockAtLocation.isEmpty()) {
                    for (StockBean stock : stockAtLocation) {
                        if (stock.getQuantity() > 0) {
            %>
            <option value="<%= stock.getFruitID() %>" data-quantity="<%= stock.getQuantity() %>" data-name="<%= stock.getFruitName() %>">
                <%= stock.getFruitName() %> (Available: <%= stock.getQuantity() %>)
            </option>
            <% 
                        }
                    }
                } 
            %>
        </select>
        <div id="noFruitError" style="color: red; display: none; margin-top: 5px;">
            No fruits available at the selected source location.
        </div>
    </div>
    
    <div class="form-group">
        <label for="quantity">Quantity:</label>
        <input type="number" id="quantity" name="quantity" min="1" class="form-control" required>
        <div id="quantityError" style="color: red; display: none; margin-top: 5px;">
            Quantity cannot exceed available stock.
        </div>
    </div>
    
    <div class="form-group">
        <label for="deliveryDate">Delivery Date:</label>
        <input type="date" id="deliveryDate" name="deliveryDate" class="form-control" required>
    </div>
    
    <div id="locationError" style="color: red; display: none; margin-bottom: 10px;">
        Source and destination locations cannot be the same.
    </div>
    
    <div style="margin-top: 20px;">
        <button type="button" class="btn" id="previewBtn" onclick="showConfirmation()">Arrange Delivery</button>
    </div>
</form>

<!-- Confirmation Table (hidden by default) -->
<div id="confirmationSection" style="display: none; margin-top: 30px;">
    <h3>Delivery Confirmation</h3>
    <p>Please review the delivery details before confirming:</p>
    
    <table class="confirmation-table" style="width: 100%; border-collapse: collapse; margin-bottom: 20px;">
        <tr>
            <th style="border: 1px solid #ddd; padding: 8px; text-align: left; background-color: #f2f2f2;">Source Location</th>
            <td id="confirmSourceLocation" style="border: 1px solid #ddd; padding: 8px;"></td>
        </tr>
        <tr>
            <th style="border: 1px solid #ddd; padding: 8px; text-align: left; background-color: #f2f2f2;">Destination Location</th>
            <td id="confirmDestinationLocation" style="border: 1px solid #ddd; padding: 8px;"></td>
        </tr>
        <tr>
            <th style="border: 1px solid #ddd; padding: 8px; text-align: left; background-color: #f2f2f2;">Fruit</th>
            <td id="confirmFruit" style="border: 1px solid #ddd; padding: 8px;"></td>
        </tr>
        <tr>
            <th style="border: 1px solid #ddd; padding: 8px; text-align: left; background-color: #f2f2f2;">Quantity</th>
            <td id="confirmQuantity" style="border: 1px solid #ddd; padding: 8px;"></td>
        </tr>
        <tr>
            <th style="border: 1px solid #ddd; padding: 8px; text-align: left; background-color: #f2f2f2;">Delivery Date</th>
            <td id="confirmDeliveryDate" style="border: 1px solid #ddd; padding: 8px;"></td>
        </tr>
    </table>
    
    <div>
        <button type="button" class="btn" style="background-color: green; margin-right: 10px;" onclick="confirmDelivery()">Confirm Delivery</button>
        <button type="button" class="btn" style="background-color: gray;" onclick="cancelDelivery()">Cancel</button>
    </div>
</div>

<script>
    // Set minimum date to today
    var today = new Date();
    var todayFormatted = today.toISOString().split('T')[0];
    document.getElementById('deliveryDate').setAttribute('min', todayFormatted);
    
    // Store all fruits in JavaScript for filtering
    var allFruits = [];
    <% for (FruitBean fruit : allFruits) { %>
        allFruits.push({ id: <%= fruit.getFruitID() %>, name: "<%= fruit.getName() %>" });
    <% } %>
    
    // Store all stock data in JavaScript
    var stockData = [];
    <% 
    // Get all stock data for dynamic updates
    ArrayList<StockBean> allStock = stockDB.queryStock();
    for (StockBean stock : allStock) { 
        if (stock.getQuantity() > 0) {
    %>
        stockData.push({ 
            locationId: <%= stock.getLocationID() %>, 
            fruitId: <%= stock.getFruitID() %>, 
            fruitName: "<%= stock.getFruitName() %>", 
            quantity: <%= stock.getQuantity() %> 
        });
    <% 
        }
    } 
    %>
    
    // Update fruit options based on selected source location
    function updateFruitOptions() {
        var sourceLocationID = document.getElementById('sourceLocationID').value;
        var fruitSelect = document.getElementById('fruitID');
        var noFruitError = document.getElementById('noFruitError');
        
        // Clear current options
        fruitSelect.innerHTML = '<option value="">-- Select Fruit --</option>';
        
        // Filter stock for selected location
        var availableFruits = stockData.filter(function(stock) {
            return stock.locationId == sourceLocationID;
        });
        
        if (availableFruits.length === 0) {
            noFruitError.style.display = 'block';
            fruitSelect.disabled = true;
        } else {
            noFruitError.style.display = 'none';
            fruitSelect.disabled = false;
            
            // Add available fruits to select
            availableFruits.forEach(function(stock) {
                var option = document.createElement('option');
                option.value = stock.fruitId;
                option.setAttribute('data-quantity', stock.quantity);
                option.setAttribute('data-name', stock.fruitName);
                option.textContent = stock.fruitName + ' (Available: ' + stock.quantity + ')';
                fruitSelect.appendChild(option);
            });
        }
        
        // Reset quantity field
        document.getElementById('quantity').value = '';
        updateMaxQuantity();
    }
    
    // Update max quantity based on selected fruit
    function updateMaxQuantity() {
        var fruitSelect = document.getElementById('fruitID');
        var quantityInput = document.getElementById('quantity');
        var quantityError = document.getElementById('quantityError');
        
        if (fruitSelect.selectedIndex > 0) {
            var selectedOption = fruitSelect.options[fruitSelect.selectedIndex];
            var maxQuantity = parseInt(selectedOption.getAttribute('data-quantity'));
            
            // Set max attribute on quantity input
            quantityInput.setAttribute('max', maxQuantity);
            
            // If current value exceeds max, reset it
            if (parseInt(quantityInput.value) > maxQuantity) {
                quantityInput.value = maxQuantity;
            }
        } else {
            quantityInput.removeAttribute('max');
        }
        
        quantityError.style.display = 'none';
    }
    
    // Validate that source and destination are different
    function validateLocations() {
        var sourceLocationID = document.getElementById('sourceLocationID').value;
        var destinationLocationID = document.getElementById('destinationLocationID').value;
        var errorDiv = document.getElementById('locationError');
        var previewBtn = document.getElementById('previewBtn');
        
        if (sourceLocationID && destinationLocationID && sourceLocationID === destinationLocationID) {
            errorDiv.style.display = 'block';
            previewBtn.disabled = true;
        } else {
            errorDiv.style.display = 'none';
            previewBtn.disabled = false;
        }
    }
    
    // Validate form before showing confirmation
    function showConfirmation() {
        var sourceLocationID = document.getElementById('sourceLocationID').value;
        var destinationLocationID = document.getElementById('destinationLocationID').value;
        var fruitSelect = document.getElementById('fruitID');
        var quantityInput = document.getElementById('quantity');
        var deliveryDateInput = document.getElementById('deliveryDate');
        var quantityError = document.getElementById('quantityError');
        var valid = true;
        
        // Check if all required fields are filled
        if (!sourceLocationID || !destinationLocationID || fruitSelect.selectedIndex <= 0 || 
            !quantityInput.value || !deliveryDateInput.value) {
            alert('Please fill all required fields');
            return;
        }
        
        // Validate locations
        if (sourceLocationID && destinationLocationID && sourceLocationID === destinationLocationID) {
            document.getElementById('locationError').style.display = 'block';
            valid = false;
        }
        
        // Validate quantity against stock
        if (fruitSelect.selectedIndex > 0) {
            var selectedOption = fruitSelect.options[fruitSelect.selectedIndex];
            var maxQuantity = parseInt(selectedOption.getAttribute('data-quantity'));
            var requestedQuantity = parseInt(quantityInput.value);
            
            if (requestedQuantity > maxQuantity) {
                quantityError.style.display = 'block';
                valid = false;
            }
        }
        
        if (!valid) {
            return;
        }
        
        // Fill confirmation table
        var sourceLocationSelect = document.getElementById('sourceLocationID');
        var destinationLocationSelect = document.getElementById('destinationLocationID');
        var fruitOption = fruitSelect.options[fruitSelect.selectedIndex];
        
        document.getElementById('confirmSourceLocation').textContent = sourceLocationSelect.options[sourceLocationSelect.selectedIndex].text;
        document.getElementById('confirmDestinationLocation').textContent = destinationLocationSelect.options[destinationLocationSelect.selectedIndex].text;
        document.getElementById('confirmFruit').textContent = fruitOption.getAttribute('data-name');
        document.getElementById('confirmQuantity').textContent = quantityInput.value;
        
        // Format date for display
        var deliveryDate = new Date(deliveryDateInput.value);
        var formattedDate = deliveryDate.toLocaleDateString('en-US', {
            year: 'numeric',
            month: 'long',
            day: 'numeric'
        });
        document.getElementById('confirmDeliveryDate').textContent = formattedDate;
        
        // Show confirmation section
        document.getElementById('confirmationSection').style.display = 'block';
        
        // Scroll to confirmation section
        document.getElementById('confirmationSection').scrollIntoView({
            behavior: 'smooth'
        });
    }
    
    // Submit the form when confirmed
    function confirmDelivery() {
        document.getElementById('deliveryForm').submit();
    }
    
    // Hide confirmation when canceled
    function cancelDelivery() {
        document.getElementById('confirmationSection').style.display = 'none';
    }
    
    // Initialize
    validateLocations();
    updateMaxQuantity();
    
    // Auto refresh after successful delivery arrangement
    <% if (deliverySuccess != null && deliverySuccess) { %>
    // Reload the approved reservations section after 5 seconds
    setTimeout(function() {
        window.location.reload();
    }, 5000); // Reload after 5 seconds to give user time to read the details
    <% } %>
</script>

<%@include file="../footer.jsp"%>