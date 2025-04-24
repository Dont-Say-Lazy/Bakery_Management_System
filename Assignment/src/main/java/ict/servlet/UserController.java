/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ict.servlet;

/**
 *
 * @author Rain
 */
import ict.bean.LocationBean;
import ict.bean.UserBean;
import ict.db.LocationDB;
import ict.db.UserDB;
import java.io.IOException;
import java.util.ArrayList;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "UserController", urlPatterns = {"/user"})
public class UserController extends HttpServlet {

    private UserDB userDB;
    private LocationDB locationDB;

    @Override
    public void init() {
        String dbUrl = getServletContext().getInitParameter("dbUrl");
        String dbUser = getServletContext().getInitParameter("dbUser");
        String dbPassword = getServletContext().getInitParameter("dbPassword");
        userDB = new UserDB(dbUrl, dbUser, dbPassword);
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

        // Only senior management can manage users
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
                listUsers(request, response);
                break;
            case "showAddForm":
                showAddForm(request, response);
                break;
            case "add":
                addUser(request, response);
                break;
            case "showEditForm":
                showEditForm(request, response);
                break;
            case "edit":
                editUser(request, response);
                break;
            case "delete":
                deleteUser(request, response);
                break;
            default:
                listUsers(request, response);
        }
    }

    private void listUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ArrayList<UserBean> users = userDB.queryUser();
        request.setAttribute("users", users);

        // Get locations for display
        ArrayList<LocationBean> locations = locationDB.queryLocation();
        request.setAttribute("locations", locations);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/management/userManagement.jsp");
        dispatcher.forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ArrayList<LocationBean> locations = locationDB.queryLocation();
        request.setAttribute("locations", locations);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/management/addUser.jsp");
        dispatcher.forward(request, response);
    }

    private void addUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        String name = request.getParameter("name");
        String locationIDStr = request.getParameter("locationID");

        int locationID = 0;
        if (locationIDStr != null && !locationIDStr.isEmpty()) {
            locationID = Integer.parseInt(locationIDStr);
        }

        UserBean newUser = new UserBean();
        newUser.setUsername(username);
        newUser.setPassword(password);
        newUser.setRole(role);
        newUser.setName(name);
        newUser.setLocationID(locationID);

        boolean success = userDB.addUser(newUser);

        if (success) {
            request.setAttribute("message", "User added successfully.");
        } else {
            request.setAttribute("message", "Failed to add user.");
        }

        listUsers(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String userIDStr = request.getParameter("userID");
        
        if (userIDStr != null && !userIDStr.isEmpty()) {
            int userID = Integer.parseInt(userIDStr);
            UserBean user = userDB.getUserByID(userID);

            if (user != null) {
                request.setAttribute("user", user);

                ArrayList<LocationBean> locations = locationDB.queryLocation();
                request.setAttribute("locations", locations);

                RequestDispatcher dispatcher = request.getRequestDispatcher("/management/editUser.jsp");
                dispatcher.forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "User not found");
            }
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "User ID is required");
        }
    }

    private void editUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int userID = Integer.parseInt(request.getParameter("userID"));
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        String name = request.getParameter("name");
        String locationIDStr = request.getParameter("locationID");

        int locationID = 0;
        if (locationIDStr != null && !locationIDStr.isEmpty()) {
            locationID = Integer.parseInt(locationIDStr);
        }

        UserBean user = new UserBean();
        user.setUserID(userID);
        user.setUsername(username);
        user.setPassword(password);
        user.setRole(role);
        user.setName(name);
        user.setLocationID(locationID);

        boolean success = userDB.updateUser(user);

        if (success) {
            request.setAttribute("message", "User updated successfully.");
        } else {
            request.setAttribute("message", "Failed to update user.");
        }

        listUsers(request, response);
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int userID = Integer.parseInt(request.getParameter("userID"));

        boolean success = userDB.deleteUser(userID);

        if (success) {
            request.setAttribute("message", "User deleted successfully.");
        } else {
            request.setAttribute("message", "Failed to delete user.");
        }

        listUsers(request, response);
    }
}
