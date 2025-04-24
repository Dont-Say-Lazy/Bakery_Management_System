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
import ict.bean.ReservationBean;
import ict.bean.UserBean;
import ict.db.FruitDB;
import ict.db.LocationDB;
import ict.db.ReservationDB;
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

@WebServlet(name = "ReservationController", urlPatterns = {"/reservation"})
public class ReservationController extends HttpServlet {
    private ReservationDB reservationDB;
    private FruitDB fruitDB;
    private LocationDB locationDB;
    
    @Override
    public void init() {
        String dbUrl = getServletContext().getInitParameter("dbUrl");
        String dbUser = getServletContext().getInitParameter("dbUser");
        String dbPassword = getServletContext().getInitParameter("dbPassword");
        reservationDB = new ReservationDB(dbUrl, dbUser, dbPassword);
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
        String role = user.getRole();
        
        if (action == null) {
            action = "list";
        }
        
        switch (action) {
            case "list":
                listReservations(request, response, user);
                break;
            case "showAddForm":
                showAddForm(request, response);
                break;
            case "add":
                addReservation(request, response, user);
                break;
            case "view":
                viewReservation(request, response);
                break;
            case "approve":
                if (role.equals("warehouse_staff")) {
                    approveReservation(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                }
                break;
            case "reject":
                if (role.equals("warehouse_staff")) {
                    rejectReservation(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                }
                break;
            case "deliver":
                if (role.equals("warehouse_staff")) {
                    deliverReservation(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                }
                break;
            case "getWarehouseStock":
                getWarehouseStock(request, response);
                break;
            default:
                listReservations(request, response, user);
        }
    }
    
    private void listReservations(HttpServletRequest request, HttpServletResponse response, UserBean user)
            throws ServletException, IOException {
        ArrayList<ReservationBean> reservations;
        
        if (user.getRole().equals("shop_staff")) {
            // Shop staff can only see their shop's reservations
            reservations = reservationDB.getReservationsByShop(user.getLocationID());
        } else if (user.getRole().equals("warehouse_staff")) {
            // Warehouse staff can see all reservations
            reservations = reservationDB.queryReservations();
        } else {
            // Senior management can see all reservations
            reservations = reservationDB.queryReservations();
        }
        
        request.setAttribute("reservations", reservations);
        
        String userRole = user.getRole();
        String destination;
        
        if (userRole.equals("shop_staff")) {
            destination = "/shop/checkReserves.jsp";
        } else if (userRole.equals("warehouse_staff")) {
            destination = "/warehouse/approveRequests.jsp";
        } else {
            destination = "/management/viewReservations.jsp";
        }
        
        RequestDispatcher dispatcher = request.getRequestDispatcher(destination);
        dispatcher.forward(request, response);
    }
    
    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ArrayList<FruitBean> fruits = fruitDB.queryFruit();
        request.setAttribute("fruits", fruits);
        
        ArrayList<LocationBean> sourceWarehouses = locationDB.queryLocationsByType("warehouse");
        request.setAttribute("sourceWarehouses", sourceWarehouses);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/shop/reserveFruit.jsp");
        dispatcher.forward(request, response);
    }
    
    private void addReservation(HttpServletRequest request, HttpServletResponse response, UserBean user)
            throws ServletException, IOException {
        int fruitID = Integer.parseInt(request.getParameter("fruitID"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        String deliveryDateStr = request.getParameter("deliveryDate");
        int warehouseID = Integer.parseInt(request.getParameter("warehouseID"));
        
        // Parse the delivery date
        Date deliveryDate = Date.valueOf(deliveryDateStr);
        
        // Validate warehouse has enough stock
        String dbUrl = getServletContext().getInitParameter("dbUrl");
        String dbUser = getServletContext().getInitParameter("dbUser");
        String dbPassword = getServletContext().getInitParameter("dbPassword");
        
        ict.db.StockDB stockDB = new ict.db.StockDB(dbUrl, dbUser, dbPassword);
        ict.bean.StockBean stock = stockDB.getStockByLocationAndFruit(warehouseID, fruitID);
        
        if (stock == null || stock.getQuantity() < quantity) {
            request.setAttribute("message", "Insufficient stock available for this reservation.");
            showAddForm(request, response);
            return;
        }
        
        // Create a new reservation
        ReservationBean reservation = new ReservationBean();
        reservation.setShopLocationID(user.getLocationID());
        reservation.setFruitID(fruitID);
        reservation.setQuantity(quantity);
        reservation.setRequestDate(Date.valueOf(LocalDate.now()));
        reservation.setDeliveryDate(deliveryDate);
        reservation.setStatus("pending");
        reservation.setUserID(user.getUserID());
        
        boolean success = reservationDB.addReservation(reservation);
        
        if (success) {
            request.setAttribute("message", "Reservation submitted successfully.");
        } else {
            request.setAttribute("message", "Failed to submit reservation.");
        }
        
        listReservations(request, response, user);
    }
    
    private void viewReservation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int reservationID = Integer.parseInt(request.getParameter("reservationID"));
        ReservationBean reservation = reservationDB.getReservationByID(reservationID);
        
        if (reservation != null) {
            request.setAttribute("reservation", reservation);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/viewReservation.jsp");
            dispatcher.forward(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Reservation not found");
        }
    }
    
    private void approveReservation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int reservationID = Integer.parseInt(request.getParameter("reservationID"));
        HttpSession session = request.getSession();
        UserBean user = (UserBean) session.getAttribute("userInfo");
        
        boolean success = reservationDB.updateReservationStatus(reservationID, "approved");
        
        if (success) {
            request.setAttribute("message", "Reservation approved successfully.");
        } else {
            request.setAttribute("message", "Failed to approve reservation.");
        }
        
        listReservations(request, response, user);
    }
    
    private void rejectReservation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int reservationID = Integer.parseInt(request.getParameter("reservationID"));
        HttpSession session = request.getSession();
        UserBean user = (UserBean) session.getAttribute("userInfo");
        
        boolean success = reservationDB.updateReservationStatus(reservationID, "rejected");
        
        if (success) {
            request.setAttribute("message", "Reservation rejected successfully.");
        } else {
            request.setAttribute("message", "Failed to reject reservation.");
        }
        
        listReservations(request, response, user);
    }
    
    private void deliverReservation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int reservationID = Integer.parseInt(request.getParameter("reservationID"));
        HttpSession session = request.getSession();
        UserBean user = (UserBean) session.getAttribute("userInfo");
        
        boolean success = reservationDB.updateReservationStatus(reservationID, "delivered");
        
        if (success) {
            request.setAttribute("message", "Reservation marked as delivered successfully.");
        } else {
            request.setAttribute("message", "Failed to mark reservation as delivered.");
        }
        
        // Redirect back to arrange delivery page
        RequestDispatcher dispatcher = request.getRequestDispatcher("/warehouse/arrangeDelivery.jsp");
        dispatcher.forward(request, response);
    }
    
    private void getWarehouseStock(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String warehouseIDStr = request.getParameter("warehouseID");
        
        if (warehouseIDStr == null || warehouseIDStr.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("[]");
            return;
        }
        
        int warehouseID = Integer.parseInt(warehouseIDStr);
        
        // Get the warehouse stock
        String dbUrl = getServletContext().getInitParameter("dbUrl");
        String dbUser = getServletContext().getInitParameter("dbUser");
        String dbPassword = getServletContext().getInitParameter("dbPassword");
        
        ict.db.StockDB stockDB = new ict.db.StockDB(dbUrl, dbUser, dbPassword);
        ArrayList<ict.bean.StockBean> stocks = stockDB.queryStockByLocation(warehouseID);
        
        // Build JSON response
        StringBuilder jsonBuilder = new StringBuilder();
        jsonBuilder.append("[");
        
        boolean first = true;
        for (ict.bean.StockBean stock : stocks) {
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