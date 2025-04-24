/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ict.servlet;

/**
 *
 * @author Rain
 */
import ict.bean.BorrowingBean;
import ict.bean.FruitBean;
import ict.bean.LocationBean;
import ict.bean.UserBean;
import ict.bean.StockBean;
import ict.db.BorrowingDB;
import ict.db.FruitDB;
import ict.db.LocationDB;
import ict.db.StockDB;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.ArrayList;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "BorrowingController", urlPatterns = {"/borrowing"})
public class BorrowingController extends HttpServlet {
    private BorrowingDB borrowingDB;
    private FruitDB fruitDB;
    private LocationDB locationDB;
    private StockDB stockDB;
    
    @Override
    public void init() {
        String dbUrl = getServletContext().getInitParameter("dbUrl");
        String dbUser = getServletContext().getInitParameter("dbUser");
        String dbPassword = getServletContext().getInitParameter("dbPassword");
        borrowingDB = new BorrowingDB(dbUrl, dbUser, dbPassword);
        fruitDB = new FruitDB(dbUrl, dbUser, dbPassword);
        locationDB = new LocationDB(dbUrl, dbUser, dbPassword);
        stockDB = new StockDB(dbUrl, dbUser, dbPassword);
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
        String role = user.getRole();
        
        if (action == null) {
            action = "list";
        }
        
        switch (action) {
            case "list":
                listBorrowings(request, response, user);
                break;
            case "showAddForm":
                showAddForm(request, response, user);
                break;
            case "add":
                addBorrowing(request, response, user);
                break;
            case "view":
                viewBorrowing(request, response);
                break;
            case "approve":
                if (role.equals("shop_staff")) {
                    approveBorrowing(request, response, user);
                } else {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                }
                break;
            case "reject":
                if (role.equals("shop_staff")) {
                    rejectBorrowing(request, response, user);
                } else {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                }
                break;
            case "getShopStock":
                getShopStock(request, response);
                break;
            default:
                listBorrowings(request, response, user);
        }
    }
    
    private void listBorrowings(HttpServletRequest request, HttpServletResponse response, UserBean user)
            throws ServletException, IOException {
        ArrayList<BorrowingBean> borrowings;
        
        if (user.getRole().equals("shop_staff")) {
            // Get borrowings for this shop (both as source and destination)
            ArrayList<BorrowingBean> sourceBorrowings = borrowingDB.getBorrowingsBySourceShop(user.getLocationID());
            ArrayList<BorrowingBean> destBorrowings = borrowingDB.getBorrowingsByDestinationShop(user.getLocationID());
            
            // Combine the two lists
            borrowings = new ArrayList<>();
            borrowings.addAll(sourceBorrowings);
            borrowings.addAll(destBorrowings);
        } else {
            // Admin and warehouse staff can see all borrowings
            borrowings = borrowingDB.queryBorrowings();
        }
        
        request.setAttribute("borrowings", borrowings);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/shop/borrowFruit.jsp");
        dispatcher.forward(request, response);
    }
    
    private void showAddForm(HttpServletRequest request, HttpServletResponse response, UserBean user)
            throws ServletException, IOException {
        ArrayList<FruitBean> fruits = fruitDB.queryFruit();
        request.setAttribute("fruits", fruits);
        
        // Get all shops in the same city as the user's shop
        LocationBean userLocation = locationDB.getLocationByID(user.getLocationID());
        ArrayList<LocationBean> shopsInSameCity = locationDB.queryLocationsByCity(userLocation.getCity());
        
        // Remove the user's own shop from the list
        ArrayList<LocationBean> otherShops = new ArrayList<>();
        for (LocationBean shop : shopsInSameCity) {
            if (shop.getLocationID() != user.getLocationID() && shop.getType().equals("shop")) {
                otherShops.add(shop);
            }
        }
        
        request.setAttribute("otherShops", otherShops);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/shop/addBorrowing.jsp");
        dispatcher.forward(request, response);
    }
    
    private void addBorrowing(HttpServletRequest request, HttpServletResponse response, UserBean user)
            throws ServletException, IOException {
        int sourceShopID = Integer.parseInt(request.getParameter("sourceShopID"));
        int fruitID = Integer.parseInt(request.getParameter("fruitID"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        
        // Check if the source shop has enough stock
        StockBean sourceStock = stockDB.getStockByLocationAndFruit(sourceShopID, fruitID);
        
        if (sourceStock == null || sourceStock.getQuantity() < quantity) {
            request.setAttribute("message", "The source shop does not have enough stock for this borrowing request.");
            showAddForm(request, response, user);
            return;
        }
        
        // Create a new borrowing request
        BorrowingBean borrowing = new BorrowingBean();
        borrowing.setSourceShopID(sourceShopID);
        borrowing.setDestinationShopID(user.getLocationID());
        borrowing.setFruitID(fruitID);
        borrowing.setQuantity(quantity);
        borrowing.setRequestDate(Date.valueOf(LocalDate.now()));
        borrowing.setStatus("pending");
        borrowing.setUserID(user.getUserID());
        
        boolean success = borrowingDB.addBorrowing(borrowing);
        
        if (success) {
            request.setAttribute("message", "Borrowing request submitted successfully.");
        } else {
            request.setAttribute("message", "Failed to submit borrowing request.");
        }
        
        listBorrowings(request, response, user);
    }
    
    private void viewBorrowing(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int borrowingID = Integer.parseInt(request.getParameter("borrowingID"));
        BorrowingBean borrowing = borrowingDB.getBorrowingByID(borrowingID);
        
        if (borrowing != null) {
            request.setAttribute("borrowing", borrowing);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/viewBorrowing.jsp");
            dispatcher.forward(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Borrowing request not found");
        }
    }
    
    private void approveBorrowing(HttpServletRequest request, HttpServletResponse response, UserBean user)
            throws ServletException, IOException {
        int borrowingID = Integer.parseInt(request.getParameter("borrowingID"));
        BorrowingBean borrowing = borrowingDB.getBorrowingByID(borrowingID);
        
        if (borrowing == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Borrowing request not found");
            return;
        }
        
        // Check if this user is from the source shop
        if (borrowing.getSourceShopID() != user.getLocationID()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "You can only approve borrowing requests for your shop");
            return;
        }
        
        // Check if source shop still has enough stock
        StockBean sourceStock = stockDB.getStockByLocationAndFruit(borrowing.getSourceShopID(), borrowing.getFruitID());
        
        if (sourceStock == null || sourceStock.getQuantity() < borrowing.getQuantity()) {
            request.setAttribute("message", "Insufficient stock to approve this borrowing request.");
            listBorrowings(request, response, user);
            return;
        }
        
        // Begin transaction by updating status
        boolean success = borrowingDB.updateBorrowingStatus(borrowingID, "approved");
        
        if (success) {
            // Update stock levels for both shops
            boolean sourceUpdated = false;
            boolean destUpdated = false;
            
            // Reduce source shop stock
            int newSourceQuantity = sourceStock.getQuantity() - borrowing.getQuantity();
            sourceStock.setQuantity(newSourceQuantity);
            sourceUpdated = stockDB.updateStock(sourceStock);
            
            // Increase destination shop stock
            StockBean destStock = stockDB.getStockByLocationAndFruit(borrowing.getDestinationShopID(), borrowing.getFruitID());
            
            if (destStock != null) {
                // Update existing stock
                int newDestQuantity = destStock.getQuantity() + borrowing.getQuantity();
                destStock.setQuantity(newDestQuantity);
                destUpdated = stockDB.updateStock(destStock);
            } else {
                // Create new stock entry
                destStock = new StockBean();
                destStock.setLocationID(borrowing.getDestinationShopID());
                destStock.setFruitID(borrowing.getFruitID());
                destStock.setQuantity(borrowing.getQuantity());
                destUpdated = stockDB.addStock(destStock);
            }
            
            if (sourceUpdated && destUpdated) {
                request.setAttribute("message", "Borrowing request approved and stock updated successfully.");
            } else {
                // If stock update failed, we should log this and possibly rollback the status change
                request.setAttribute("message", "Borrowing request approved but there was an issue updating stock levels.");
            }
        } else {
            request.setAttribute("message", "Failed to approve borrowing request.");
        }
        
        listBorrowings(request, response, user);
    }
    
    private void rejectBorrowing(HttpServletRequest request, HttpServletResponse response, UserBean user)
            throws ServletException, IOException {
        int borrowingID = Integer.parseInt(request.getParameter("borrowingID"));
        BorrowingBean borrowing = borrowingDB.getBorrowingByID(borrowingID);
        
        if (borrowing == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Borrowing request not found");
            return;
        }
        
        // Check if this user is from the source shop
        if (borrowing.getSourceShopID() != user.getLocationID()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "You can only reject borrowing requests for your shop");
            return;
        }
        
        boolean success = borrowingDB.updateBorrowingStatus(borrowingID, "rejected");
        
        if (success) {
            request.setAttribute("message", "Borrowing request rejected successfully.");
        } else {
            request.setAttribute("message", "Failed to reject borrowing request.");
        }
        
        listBorrowings(request, response, user);
    }
    
    private void getShopStock(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String shopIDStr = request.getParameter("shopID");
        
        if (shopIDStr == null || shopIDStr.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("[]");
            return;
        }
        
        int shopID = Integer.parseInt(shopIDStr);
        
        // Get the shop stock
        ArrayList<StockBean> stocks = stockDB.queryStockByLocation(shopID);
        
        // Build JSON response
        StringBuilder jsonBuilder = new StringBuilder();
        jsonBuilder.append("[");
        
        boolean first = true;
        for (StockBean stock : stocks) {
            // Only include items with stock > 0
            if (stock.getQuantity() <= 0) {
                continue;
            }
            
            if (!first) {
                jsonBuilder.append(",");
            }
            
            jsonBuilder.append("{");
            jsonBuilder.append("\"fruitID\":").append(stock.getFruitID()).append(",");
            jsonBuilder.append("\"fruitName\":\"").append(stock.getFruitName()).append("\",");
            jsonBuilder.append("\"quantity\":").append(stock.getQuantity());
            jsonBuilder.append("}");
            
            first = false;
        }
        
        jsonBuilder.append("]");
        
        // Send the response
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(jsonBuilder.toString());
    }
}