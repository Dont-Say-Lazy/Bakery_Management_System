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
import ict.bean.UserBean;
import ict.db.FruitDB;
import java.io.IOException;
import java.util.ArrayList;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "FruitController", urlPatterns = {"/fruit"})
public class FruitController extends HttpServlet {
    private FruitDB fruitDB;
    
    @Override
    public void init() {
        String dbUrl = getServletContext().getInitParameter("dbUrl");
        String dbUser = getServletContext().getInitParameter("dbUser");
        String dbPassword = getServletContext().getInitParameter("dbPassword");
        fruitDB = new FruitDB(dbUrl, dbUser, dbPassword);
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

        // Only senior management can manage fruits
        if (!user.getRole().equals("senior_management")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }

        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list";
        }
        
        switch (action) {
            case "list":
                listFruits(request, response);
                break;
            case "filter":
                filterFruits(request, response);
                break;
            case "add":
                addFruit(request, response);
                break;
            case "edit":
                editFruit(request, response);
                break;
            case "delete":
                deleteFruit(request, response);
                break;
            case "showAddForm":
                showAddForm(request, response);
                break;
            case "showEditForm":
                showEditForm(request, response);
                break;
            default:
                listFruits(request, response);
        }
    }
    
    private void listFruits(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ArrayList<FruitBean> fruits = fruitDB.queryFruit();
        request.setAttribute("fruits", fruits);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/management/fruitManagement.jsp");
        dispatcher.forward(request, response);
    }
    
    private void filterFruits(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String sourceCountry = request.getParameter("sourceCountry");
        
        ArrayList<FruitBean> filteredFruits = fruitDB.queryFruit();
        
        // Apply filters if parameters are provided
        if (name != null && !name.isEmpty()) {
            ArrayList<FruitBean> tempList = new ArrayList<>();
            for (FruitBean fruit : filteredFruits) {
                if (fruit.getName().toLowerCase().contains(name.toLowerCase())) {
                    tempList.add(fruit);
                }
            }
            filteredFruits = tempList;
        }
        
        if (sourceCountry != null && !sourceCountry.isEmpty()) {
            ArrayList<FruitBean> tempList = new ArrayList<>();
            for (FruitBean fruit : filteredFruits) {
                if (fruit.getSourceCountry().toLowerCase().contains(sourceCountry.toLowerCase())) {
                    tempList.add(fruit);
                }
            }
            filteredFruits = tempList;
        }
        
        request.setAttribute("fruits", filteredFruits);
        
        // Keep the filter values for the form
        request.setAttribute("filterName", name);
        request.setAttribute("filterSourceCountry", sourceCountry);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/management/fruitManagement.jsp");
        dispatcher.forward(request, response);
    }
    
    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("/management/addFruit.jsp");
        dispatcher.forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int fruitID = Integer.parseInt(request.getParameter("fruitID"));
        FruitBean fruit = fruitDB.getFruitByID(fruitID);
        request.setAttribute("fruit", fruit);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/management/editFruit.jsp");
        dispatcher.forward(request, response);
    }
    
    private void addFruit(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String sourceCountry = request.getParameter("sourceCountry");
        
        FruitBean fruit = new FruitBean();
        fruit.setName(name);
        fruit.setDescription(description);
        fruit.setSourceCountry(sourceCountry);
        
        boolean success = fruitDB.addFruit(fruit);
        
        if (success) {
            request.setAttribute("message", "Fruit added successfully.");
        } else {
            request.setAttribute("message", "Failed to add fruit.");
        }
        
        listFruits(request, response);
    }
    
    private void editFruit(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int fruitID = Integer.parseInt(request.getParameter("fruitID"));
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String sourceCountry = request.getParameter("sourceCountry");
        
        FruitBean fruit = new FruitBean();
        fruit.setFruitID(fruitID);
        fruit.setName(name);
        fruit.setDescription(description);
        fruit.setSourceCountry(sourceCountry);
        
        boolean success = fruitDB.updateFruit(fruit);
        
        if (success) {
            request.setAttribute("message", "Fruit updated successfully.");
        } else {
            request.setAttribute("message", "Failed to update fruit.");
        }
        
        listFruits(request, response);
    }
    
    private void deleteFruit(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int fruitID = Integer.parseInt(request.getParameter("fruitID"));
        
        boolean success = fruitDB.deleteFruit(fruitID);
        
        if (success) {
            request.setAttribute("message", "Fruit deleted successfully.");
        } else {
            request.setAttribute("message", "Failed to delete fruit.");
        }
        
        listFruits(request, response);
    }
}