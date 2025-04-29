package ict.servlet;

import ict.bean.DeliveryBean;
import ict.bean.StockBean;
import ict.db.DeliveryDB;
import ict.db.StockDB;
import ict.db.LocationDB;
import ict.db.FruitDB;
import java.io.IOException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "DeliveryController", urlPatterns = {"/delivery"})
public class DeliveryController extends HttpServlet {

    private DeliveryDB deliveryDB;
    private StockDB stockDB;
    private LocationDB locationDB;
    private FruitDB fruitDB;

    @Override
    public void init() {
        String dbUrl = this.getServletContext().getInitParameter("dbUrl");
        String dbUser = this.getServletContext().getInitParameter("dbUser");
        String dbPassword = this.getServletContext().getInitParameter("dbPassword");
        
        deliveryDB = new DeliveryDB(dbUrl, dbUser, dbPassword);
        stockDB = new StockDB(dbUrl, dbUser, dbPassword);
        locationDB = new LocationDB(dbUrl, dbUser, dbPassword);
        fruitDB = new FruitDB(dbUrl, dbUser, dbPassword);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list";
        }
        
        switch (action) {
            case "list":
                listDeliveries(request, response);
                break;
            case "update":
                updateDeliveryStatus(request, response);
                break;
            default:
                listDeliveries(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list";
        }
        
        switch (action) {
            case "add":
                addDelivery(request, response);
                break;
            default:
                listDeliveries(request, response);
                break;
        }
    }
    
    private void listDeliveries(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String status = request.getParameter("status");
        ArrayList<DeliveryBean> deliveries;
        
        if (status != null && !status.isEmpty()) {
            deliveries = deliveryDB.getDeliveriesByStatus(status);
            request.setAttribute("currentStatus", status);
        } else {
            // Default to pending deliveries
            deliveries = deliveryDB.getDeliveriesByStatus("pending");
            request.setAttribute("currentStatus", "pending");
        }
        
        request.setAttribute("deliveries", deliveries);
        RequestDispatcher rd = request.getRequestDispatcher("/warehouse/viewDeliveries.jsp");
        rd.forward(request, response);
    }
    
    private void updateDeliveryStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int deliveryId = Integer.parseInt(request.getParameter("deliveryID"));
        String newStatus = request.getParameter("status");
        
        boolean success = deliveryDB.updateDeliveryStatus(deliveryId, newStatus);
        
        // Set appropriate message
        if (success) {
            request.setAttribute("message", "Delivery status updated successfully!");
        } else {
            request.setAttribute("errorMessage", "Failed to update delivery status. Please try again.");
        }
        
        // Redirect back to the list
        listDeliveries(request, response);
    }
    
    private void addDelivery(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        try {
            // Get user ID from session
            Object userObj = session.getAttribute("userInfo");
            if (userObj == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }
            
            ict.bean.UserBean user = (ict.bean.UserBean) userObj;
            int userId = user.getUserID();
            
            // Get form parameters
            int sourceLocationId = Integer.parseInt(request.getParameter("sourceLocationID"));
            int destinationLocationId = Integer.parseInt(request.getParameter("destinationLocationID"));
            int fruitId = Integer.parseInt(request.getParameter("fruitID"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            Date deliveryDate = Date.valueOf(request.getParameter("deliveryDate"));
            
            // Validate stock availability
            StockBean stock = stockDB.getStockByLocationAndFruit(sourceLocationId, fruitId);
            
            if (stock == null || stock.getQuantity() < quantity) {
                // Insufficient stock, set error message
                request.setAttribute("errorMessage", "Insufficient stock available for this delivery.");
                response.sendRedirect(request.getContextPath() + "/warehouse/arrangeDelivery.jsp");
                return;
            }
            
            // Create the delivery
            int deliveryId = deliveryDB.createDirectDelivery(sourceLocationId, destinationLocationId, 
                                                          fruitId, quantity, deliveryDate, userId);
            
            if (deliveryId != -1) {
                // Store detailed delivery information in session
                Map<String, Object> deliveryDetails = new HashMap<>();
                deliveryDetails.put("deliveryId", deliveryId);
                deliveryDetails.put("sourceLocationId", sourceLocationId);
                deliveryDetails.put("destinationLocationId", destinationLocationId);
                deliveryDetails.put("fruitId", fruitId);
                deliveryDetails.put("quantity", quantity);
                deliveryDetails.put("deliveryDate", deliveryDate);
                
                // Add names for better display
                String sourceLocationName = locationDB.getLocationByID(sourceLocationId).getName();
                String destinationLocationName = locationDB.getLocationByID(destinationLocationId).getName();
                String fruitName = fruitDB.getFruitByID(fruitId).getName();
                
                deliveryDetails.put("sourceLocationName", sourceLocationName);
                deliveryDetails.put("destinationLocationName", destinationLocationName);
                deliveryDetails.put("fruitName", fruitName);
                deliveryDetails.put("previousStock", stock.getQuantity());
                deliveryDetails.put("newStock", stock.getQuantity() - quantity);
                
                // Store delivery details in session instead of simple message
                session.setAttribute("deliverySuccess", true);
                session.setAttribute("deliveryDetails", deliveryDetails);
            } else {
                // Failed - set error message
                session.setAttribute("errorMessage", "Failed to arrange delivery. Please try again.");
            }
            
            // Always redirect back to the arrangeDelivery.jsp page
            response.sendRedirect(request.getContextPath() + "/warehouse/arrangeDelivery.jsp");
            
        } catch (IllegalArgumentException e) {
            // Handle invalid input format
            session.setAttribute("errorMessage", "Invalid input. Please check your form entries.");
            response.sendRedirect(request.getContextPath() + "/warehouse/arrangeDelivery.jsp");
        } catch (Exception e) {
            // Handle any other unexpected errors
            e.printStackTrace();
            session.setAttribute("errorMessage", "An unexpected error occurred: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/warehouse/arrangeDelivery.jsp");
        }
    }
} 