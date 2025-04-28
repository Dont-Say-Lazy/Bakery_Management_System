/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ict.servlet;

/**
 *
 * @author Rain
 */
import ict.bean.FruitBean;
import ict.bean.LocationBean;
import ict.bean.StockBean;
import ict.bean.UserBean;
import ict.db.FruitDB;
import ict.db.LocationDB;
import ict.db.StockDB;
import java.io.IOException;
import java.util.ArrayList;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "StockController", urlPatterns = {"/stock"})
public class StockController extends HttpServlet {
    private StockDB stockDB;
    private FruitDB fruitDB;
    private LocationDB locationDB;
    
    @Override
    public void init() {
        String dbUrl = getServletContext().getInitParameter("dbUrl");
        String dbUser = getServletContext().getInitParameter("dbUser");
        String dbPassword = getServletContext().getInitParameter("dbPassword");
        stockDB = new StockDB(dbUrl, dbUser, dbPassword);
        fruitDB = new FruitDB(dbUrl, dbUser, dbPassword);
        locationDB = new LocationDB(dbUrl, dbUser, dbPassword);
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        UserBean user = (UserBean) session.getAttribute("userInfo");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "view";
        }
        
        switch (action) {
            case "view":
                viewStock(request, response, user);
                break;
            case "filter":
                filterStock(request, response, user);
                break;
            case "update":
                updateStock(request, response, user);
                break;
            case "showUpdateForm":
                showUpdateForm(request, response, user);
                break;
            case "checkIn":
                checkInStock(request, response, user);
                break;
            case "checkOut":
                checkOutStock(request, response, user);
                break;
            default:
                viewStock(request, response, user);
        }
    }
    
    private void viewStock(HttpServletRequest request, HttpServletResponse response, UserBean user)
            throws ServletException, IOException {
        ArrayList<StockBean> stocks;
        
        if (user.getRole().equals("shop_staff")) {
            // Shop staff can only see their shop's stock
            stocks = stockDB.queryStockByLocation(user.getLocationID());
        } else if (user.getRole().equals("warehouse_staff")) {
            // Warehouse staff can see their warehouse stock
            stocks = stockDB.queryStockByLocation(user.getLocationID());
        } else {
            // Senior management can see all stock
            stocks = stockDB.queryStock();
        }
        
        request.setAttribute("stocks", stocks);
        
        String userRole = user.getRole();
        String destination;
        
        if (userRole.equals("shop_staff")) {
            destination = "/shop/updateStock.jsp";
        } else if (userRole.equals("warehouse_staff")) {
            destination = "/warehouse/updateStock.jsp";
        } else {
            destination = "/management/viewStock.jsp";
        }
        
        RequestDispatcher dispatcher = request.getRequestDispatcher(destination);
        dispatcher.forward(request, response);
    }
    
    private void showUpdateForm(HttpServletRequest request, HttpServletResponse response, UserBean user)
            throws ServletException, IOException {
        ArrayList<FruitBean> fruits = fruitDB.queryFruit();
        request.setAttribute("fruits", fruits);
        
        // For management role, also handle location selection
        if (user.getRole().equals("senior_management") && request.getParameter("locationID") != null) {
            request.setAttribute("selectedLocationID", request.getParameter("locationID"));
        }
        
        String userRole = user.getRole();
        String destination;
        
        if (userRole.equals("shop_staff")) {
            destination = "/shop/updateStockForm.jsp";
        } else if (userRole.equals("warehouse_staff")) {
            destination = "/warehouse/updateStockForm.jsp";
        } else {
            destination = "/management/updateStockForm.jsp";
        }
        
        RequestDispatcher dispatcher = request.getRequestDispatcher(destination);
        dispatcher.forward(request, response);
    }
    
    private void updateStock(HttpServletRequest request, HttpServletResponse response, UserBean user)
            throws ServletException, IOException {
        int fruitID = Integer.parseInt(request.getParameter("fruitID"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        int locationID;
        
        // For management, they might specify a location
        if (user.getRole().equals("senior_management") && request.getParameter("locationID") != null) {
            locationID = Integer.parseInt(request.getParameter("locationID"));
        } else {
            locationID = user.getLocationID();
        }
        
        // Check if user confirmed the action
        String confirmed = request.getParameter("confirmed");
        
        // Get fruit name for the message
        FruitBean fruit = fruitDB.getFruitByID(fruitID);
        String fruitName = (fruit != null) ? fruit.getName() : "Unknown fruit";
        
        // Get location name
        LocationBean location = locationDB.getLocationByID(locationID);
        String locationName = (location != null) ? location.getName() : "Unknown location";
        
        // Check if the stock entry already exists
        StockBean stock = stockDB.getStockByLocationAndFruit(locationID, fruitID);
        
        if (confirmed == null || !confirmed.equals("true")) {
            // If not confirmed, store data in request and forward to confirmation page
            request.setAttribute("fruitID", fruitID);
            request.setAttribute("quantity", quantity);
            request.setAttribute("fruitName", fruitName);
            request.setAttribute("currentQuantity", stock != null ? stock.getQuantity() : 0);
            
            if (user.getRole().equals("senior_management")) {
                request.setAttribute("locationID", locationID);
                request.setAttribute("locationName", locationName);
                RequestDispatcher dispatcher = request.getRequestDispatcher("/management/confirmStockUpdate.jsp");
                dispatcher.forward(request, response);
            } else if (user.getRole().equals("warehouse_staff")) {
                RequestDispatcher dispatcher = request.getRequestDispatcher("/warehouse/confirmStockUpdate.jsp");
                dispatcher.forward(request, response);
            } else {
                RequestDispatcher dispatcher = request.getRequestDispatcher("/shop/confirmStockUpdate.jsp");
                dispatcher.forward(request, response);
            }
            return;
        }
        
        boolean success;
        
        if (stock != null) {
            // Update existing stock
            int oldQuantity = stock.getQuantity();
            stock.setQuantity(quantity);
            success = stockDB.updateStock(stock);
            
            if (success) {
                request.setAttribute("message", quantity + " stocks/ " + fruitName + " has been updated from " + oldQuantity + ".");
            } else {
                request.setAttribute("message", "Failed to update stock.");
            }
        } else {
            // Create new stock entry
            stock = new StockBean();
            stock.setLocationID(locationID);
            stock.setFruitID(fruitID);
            stock.setQuantity(quantity);
            success = stockDB.addStock(stock);
            
            if (success) {
                request.setAttribute("message", quantity + " stocks/ " + fruitName + " has been added to inventory.");
            } else {
                request.setAttribute("message", "Failed to add stock.");
            }
        }
        
        viewStock(request, response, user);
    }
    
    private void checkInStock(HttpServletRequest request, HttpServletResponse response, UserBean user)
            throws ServletException, IOException {
        int fruitID = Integer.parseInt(request.getParameter("fruitID"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        int locationID;
        
        // For management, they might specify a location
        if (user.getRole().equals("senior_management") && request.getParameter("locationID") != null) {
            locationID = Integer.parseInt(request.getParameter("locationID"));
        } else {
            locationID = user.getLocationID();
        }
        
        // Check if user confirmed the action
        String confirmed = request.getParameter("confirmed");
        
        // Get fruit name for the message
        FruitBean fruit = fruitDB.getFruitByID(fruitID);
        String fruitName = (fruit != null) ? fruit.getName() : "Unknown fruit";
        
        // Get the current stock
        StockBean stock = stockDB.getStockByLocationAndFruit(locationID, fruitID);
        
        // Get location details
        LocationBean location = locationDB.getLocationByID(locationID);
        String locationName = (location != null) ? location.getName() : "Unknown location";
        
        if (confirmed == null || !confirmed.equals("true")) {
            // If not confirmed, store data in request and forward to confirmation page
            request.setAttribute("fruitID", fruitID);
            request.setAttribute("quantity", quantity);
            request.setAttribute("fruitName", fruitName);
            request.setAttribute("locationName", locationName);
            request.setAttribute("currentQuantity", stock != null ? stock.getQuantity() : 0);
            request.setAttribute("actionType", "checkIn");
            
            if (user.getRole().equals("senior_management")) {
                request.setAttribute("locationID", locationID);
                RequestDispatcher dispatcher = request.getRequestDispatcher("/management/confirmStockAction.jsp");
                dispatcher.forward(request, response);
            } else if (user.getRole().equals("warehouse_staff")) {
                RequestDispatcher dispatcher = request.getRequestDispatcher("/warehouse/confirmStockAction.jsp");
                dispatcher.forward(request, response);
            } else {
                RequestDispatcher dispatcher = request.getRequestDispatcher("/shop/confirmStockAction.jsp");
                dispatcher.forward(request, response);
            }
            return;
        }
        
        boolean success;
        
        if (stock != null) {
            // Update existing stock by adding the quantity
            int oldQuantity = stock.getQuantity();
            int newQuantity = oldQuantity + quantity;
            stock.setQuantity(newQuantity);
            success = stockDB.updateStock(stock);
            
            if (success) {
                request.setAttribute("message", quantity + " stocks/ " + fruitName + " has been checked in. Total inventory updated from " + oldQuantity + " to " + newQuantity + ".");
            } else {
                request.setAttribute("message", "Failed to check in stock.");
            }
        } else {
            // Create new stock entry
            stock = new StockBean();
            stock.setLocationID(locationID);
            stock.setFruitID(fruitID);
            stock.setQuantity(quantity);
            success = stockDB.addStock(stock);
            
            if (success) {
                request.setAttribute("message", quantity + " stocks/ " + fruitName + " has been checked in to " + locationName + ".");
            } else {
                request.setAttribute("message", "Failed to check in stock.");
            }
        }
        
        viewStock(request, response, user);
    }
    
    private void checkOutStock(HttpServletRequest request, HttpServletResponse response, UserBean user)
            throws ServletException, IOException {
        int fruitID = Integer.parseInt(request.getParameter("fruitID"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        int locationID;
        
        // For management, they might specify a location
        if (user.getRole().equals("senior_management") && request.getParameter("locationID") != null) {
            locationID = Integer.parseInt(request.getParameter("locationID"));
        } else {
            locationID = user.getLocationID();
        }
        
        // Check if user confirmed the action
        String confirmed = request.getParameter("confirmed");
        
        // Get fruit name for the message
        FruitBean fruit = fruitDB.getFruitByID(fruitID);
        String fruitName = (fruit != null) ? fruit.getName() : "Unknown fruit";
        
        // Get the current stock
        StockBean stock = stockDB.getStockByLocationAndFruit(locationID, fruitID);
        
        // Get location details
        LocationBean location = locationDB.getLocationByID(locationID);
        String locationName = (location != null) ? location.getName() : "Unknown location";
        
        if (stock == null || stock.getQuantity() < quantity) {
            request.setAttribute("message", "Insufficient stock of " + fruitName + " for checkout. Available: " + (stock != null ? stock.getQuantity() : 0) + ".");
            viewStock(request, response, user);
            return;
        }
        
        if (confirmed == null || !confirmed.equals("true")) {
            // If not confirmed, store data in request and forward to confirmation page
            request.setAttribute("fruitID", fruitID);
            request.setAttribute("quantity", quantity);
            request.setAttribute("fruitName", fruitName);
            request.setAttribute("locationName", locationName);
            request.setAttribute("currentQuantity", stock.getQuantity());
            request.setAttribute("actionType", "checkOut");
            
            if (user.getRole().equals("senior_management")) {
                request.setAttribute("locationID", locationID);
                RequestDispatcher dispatcher = request.getRequestDispatcher("/management/confirmStockAction.jsp");
                dispatcher.forward(request, response);
            } else if (user.getRole().equals("warehouse_staff")) {
                RequestDispatcher dispatcher = request.getRequestDispatcher("/warehouse/confirmStockAction.jsp");
                dispatcher.forward(request, response);
            } else {
                RequestDispatcher dispatcher = request.getRequestDispatcher("/shop/confirmStockAction.jsp");
                dispatcher.forward(request, response);
            }
            return;
        }
        
        // Update existing stock by subtracting the quantity
        int oldQuantity = stock.getQuantity();
        int newQuantity = oldQuantity - quantity;
        stock.setQuantity(newQuantity);
        boolean success = stockDB.updateStock(stock);
        
        if (success) {
            request.setAttribute("message", quantity + " stocks/ " + fruitName + " has been checked out. Inventory updated from " + oldQuantity + " to " + newQuantity + ".");
        } else {
            request.setAttribute("message", "Failed to check out stock.");
        }
        
        viewStock(request, response, user);
    }
    
    private void filterStock(HttpServletRequest request, HttpServletResponse response, UserBean user)
            throws ServletException, IOException {
        String fruitName = request.getParameter("fruitName");
        String quantityMin = request.getParameter("quantityMin");
        String quantityMax = request.getParameter("quantityMax");
        String locationName = request.getParameter("locationName");
        
        ArrayList<StockBean> stocks;
        
        // Get initial stock list based on user role
        if (user.getRole().equals("shop_staff") || user.getRole().equals("warehouse_staff")) {
            // Staff can only see their location's stock
            stocks = stockDB.queryStockByLocation(user.getLocationID());
        } else {
            // Senior management can see all stock
            stocks = stockDB.queryStock();
        }
        
        // Apply filters
        ArrayList<StockBean> filteredStocks = new ArrayList<>();
        
        for (StockBean stock : stocks) {
            boolean includeStock = true;
            
            // Filter by fruit name
            if (fruitName != null && !fruitName.isEmpty()) {
                if (!stock.getFruitName().toLowerCase().contains(fruitName.toLowerCase())) {
                    includeStock = false;
                }
            }
            
            // Filter by location name (for management only)
            if (user.getRole().equals("senior_management") && locationName != null && !locationName.isEmpty()) {
                if (!stock.getLocationName().toLowerCase().contains(locationName.toLowerCase())) {
                    includeStock = false;
                }
            }
            
            // Filter by minimum quantity
            if (quantityMin != null && !quantityMin.isEmpty()) {
                try {
                    int minQty = Integer.parseInt(quantityMin);
                    if (stock.getQuantity() < minQty) {
                        includeStock = false;
                    }
                } catch (NumberFormatException e) {
                    // Invalid input, ignore this filter
                }
            }
            
            // Filter by maximum quantity
            if (quantityMax != null && !quantityMax.isEmpty()) {
                try {
                    int maxQty = Integer.parseInt(quantityMax);
                    if (stock.getQuantity() > maxQty) {
                        includeStock = false;
                    }
                } catch (NumberFormatException e) {
                    // Invalid input, ignore this filter
                }
            }
            
            if (includeStock) {
                filteredStocks.add(stock);
            }
        }
        
        request.setAttribute("stocks", filteredStocks);
        
        // Keep filter values for the form
        request.setAttribute("filterFruitName", fruitName);
        request.setAttribute("filterQuantityMin", quantityMin);
        request.setAttribute("filterQuantityMax", quantityMax);
        if (user.getRole().equals("senior_management")) {
            request.setAttribute("filterLocationName", locationName);
        }
        
        String userRole = user.getRole();
        String destination;
        
        if (userRole.equals("shop_staff")) {
            destination = "/shop/updateStock.jsp";
        } else if (userRole.equals("warehouse_staff")) {
            destination = "/warehouse/updateStock.jsp";
        } else {
            destination = "/management/viewStock.jsp";
        }
        
        RequestDispatcher dispatcher = request.getRequestDispatcher(destination);
        dispatcher.forward(request, response);
    }
}
