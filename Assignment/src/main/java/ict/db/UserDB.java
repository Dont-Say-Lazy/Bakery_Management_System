/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ict.db;

/**
 *
 * @author AlexS
 */
import ict.bean.UserBean;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class UserDB {

    private DBConnection dbConnection;

    public UserDB(String url, String username, String password) {
        dbConnection = new DBConnection(url, username, password);
    }

    public boolean isValidUser(String username, String password) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        boolean isValid = false;

        try {
            conn = dbConnection.getConnection();
            String preQueryStatement = "SELECT * FROM Users WHERE Username=? AND Password=?";
            pstmt = conn.prepareStatement(preQueryStatement);
            pstmt.setString(1, username);
            pstmt.setString(2, password);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                isValid = true;
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (pstmt != null) {
                    pstmt.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }

        return isValid;
    }

    public UserBean getUserByUsername(String username) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        UserBean user = null;

        try {
            conn = dbConnection.getConnection();
            String preQueryStatement = "SELECT * FROM Users WHERE Username=?";
            pstmt = conn.prepareStatement(preQueryStatement);
            pstmt.setString(1, username);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                user = new UserBean();
                user.setUserID(rs.getInt("UserID"));
                user.setUsername(rs.getString("Username"));
                user.setPassword(rs.getString("Password"));
                user.setRole(rs.getString("Role"));
                user.setName(rs.getString("Name"));
                user.setLocationID(rs.getInt("LocationID"));
                user.setIsCentralStaff(rs.getInt("IsCentralStaff"));
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (pstmt != null) {
                    pstmt.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }

        return user;
    }

    public ArrayList<UserBean> queryUser() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        ArrayList<UserBean> users = new ArrayList<>();

        try {
            conn = dbConnection.getConnection();
            String preQueryStatement = "SELECT * FROM Users";
            pstmt = conn.prepareStatement(preQueryStatement);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                UserBean user = new UserBean();
                user.setUserID(rs.getInt("UserID"));
                user.setUsername(rs.getString("Username"));
                user.setPassword(rs.getString("Password"));
                user.setRole(rs.getString("Role"));
                user.setName(rs.getString("Name"));
                user.setLocationID(rs.getInt("LocationID"));
                user.setIsCentralStaff(rs.getInt("IsCentralStaff"));
                users.add(user);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (pstmt != null) {
                    pstmt.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }

        return users;
    }

    public boolean addUser(UserBean user) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean isSuccess = false;

        try {
            conn = dbConnection.getConnection();
            String preQueryStatement = "INSERT INTO Users (Username, Password, Role, Name, LocationID, IsCentralStaff) VALUES (?,?,?,?,?,?)";
            pstmt = conn.prepareStatement(preQueryStatement);
            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getPassword());
            pstmt.setString(3, user.getRole());
            pstmt.setString(4, user.getName());
            pstmt.setInt(5, user.getLocationID());
            pstmt.setInt(6, user.getIsCentralStaff());

            int rowCount = pstmt.executeUpdate();
            if (rowCount >= 1) {
                isSuccess = true;
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        } finally {
            try {
                if (pstmt != null) {
                    pstmt.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }

        return isSuccess;
    }

    public boolean updateUser(UserBean user) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean isSuccess = false;

        try {
            conn = dbConnection.getConnection();
            String preQueryStatement = "UPDATE Users SET Username=?, Password=?, Role=?, Name=?, LocationID=?, IsCentralStaff=? WHERE UserID=?";
            pstmt = conn.prepareStatement(preQueryStatement);
            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getPassword());
            pstmt.setString(3, user.getRole());
            pstmt.setString(4, user.getName());
            pstmt.setInt(5, user.getLocationID());
            pstmt.setInt(6, user.getIsCentralStaff());
            pstmt.setInt(7, user.getUserID());

            int rowCount = pstmt.executeUpdate();
            if (rowCount >= 1) {
                isSuccess = true;
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        } finally {
            try {
                if (pstmt != null) {
                    pstmt.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }

        return isSuccess;
    }

    public boolean deleteUser(int userID) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean isSuccess = false;

        try {
            conn = dbConnection.getConnection();
            String preQueryStatement = "DELETE FROM Users WHERE UserID=?";
            pstmt = conn.prepareStatement(preQueryStatement);
            pstmt.setInt(1, userID);

            int rowCount = pstmt.executeUpdate();
            if (rowCount >= 1) {
                isSuccess = true;
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        } finally {
            try {
                if (pstmt != null) {
                    pstmt.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }

        return isSuccess;
    }

    public UserBean getUserByID(int userID) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        UserBean user = null;

        try {
            conn = dbConnection.getConnection();
            String preQueryStatement = "SELECT * FROM Users WHERE UserID=?";
            pstmt = conn.prepareStatement(preQueryStatement);
            pstmt.setInt(1, userID);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                user = new UserBean();
                user.setUserID(rs.getInt("UserID"));
                user.setUsername(rs.getString("Username"));
                user.setPassword(rs.getString("Password"));
                user.setRole(rs.getString("Role"));
                user.setName(rs.getString("Name"));
                user.setLocationID(rs.getInt("LocationID"));
                user.setIsCentralStaff(rs.getInt("IsCentralStaff"));
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (pstmt != null) {
                    pstmt.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }

        return user;
    }
}
