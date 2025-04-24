/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ict.db;

/**
 *
 * @author Rain
 */
import ict.bean.ReservationBean;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class ReservationDB {
    private DBConnection dbConnection;
    
    public ReservationDB(String url, String username, String password) {
        dbConnection = new DBConnection(url, username, password);
    }
    
    public ArrayList<ReservationBean> queryReservations() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        ArrayList<ReservationBean> reservations = new ArrayList<>();
        
        try {
            conn = dbConnection.getConnection();
            String sql = "SELECT r.*, f.Name as FruitName, l.Name as ShopName, u.Name as UserName " +
                         "FROM Reservations r " +
                         "JOIN Fruits f ON r.FruitID = f.FruitID " +
                         "JOIN Locations l ON r.ShopLocationID = l.LocationID " +
                         "JOIN Users u ON r.UserID = u.UserID " +
                         "ORDER BY r.RequestDate DESC";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                ReservationBean reservation = new ReservationBean();
                reservation.setReservationID(rs.getInt("ReservationID"));
                reservation.setShopLocationID(rs.getInt("ShopLocationID"));
                reservation.setFruitID(rs.getInt("FruitID"));
                reservation.setQuantity(rs.getInt("Quantity"));
                reservation.setRequestDate(rs.getDate("RequestDate"));
                reservation.setDeliveryDate(rs.getDate("DeliveryDate"));
                reservation.setStatus(rs.getString("Status"));
                reservation.setUserID(rs.getInt("UserID"));
                reservation.setFruitName(rs.getString("FruitName"));
                reservation.setShopName(rs.getString("ShopName"));
                reservation.setUserName(rs.getString("UserName"));
                
                reservations.add(reservation);
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
        
        return reservations;
    }
    
    public ArrayList<ReservationBean> getReservationsByShop(int shopLocationID) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        ArrayList<ReservationBean> reservations = new ArrayList<>();
        
        try {
            conn = dbConnection.getConnection();
            String sql = "SELECT r.*, f.Name as FruitName, l.Name as ShopName, u.Name as UserName " +
                         "FROM Reservations r " +
                         "JOIN Fruits f ON r.FruitID = f.FruitID " +
                         "JOIN Locations l ON r.ShopLocationID = l.LocationID " +
                         "JOIN Users u ON r.UserID = u.UserID " +
                         "WHERE r.ShopLocationID = ? " +
                         "ORDER BY r.RequestDate DESC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, shopLocationID);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                ReservationBean reservation = new ReservationBean();
                reservation.setReservationID(rs.getInt("ReservationID"));
                reservation.setShopLocationID(rs.getInt("ShopLocationID"));
                reservation.setFruitID(rs.getInt("FruitID"));
                reservation.setQuantity(rs.getInt("Quantity"));
                reservation.setRequestDate(rs.getDate("RequestDate"));
                reservation.setDeliveryDate(rs.getDate("DeliveryDate"));
                reservation.setStatus(rs.getString("Status"));
                reservation.setUserID(rs.getInt("UserID"));
                reservation.setFruitName(rs.getString("FruitName"));
                reservation.setShopName(rs.getString("ShopName"));
                reservation.setUserName(rs.getString("UserName"));
                
                reservations.add(reservation);
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
        
        return reservations;
    }
    
    public ReservationBean getReservationByID(int reservationID) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        ReservationBean reservation = null;
        
        try {
            conn = dbConnection.getConnection();
            String sql = "SELECT r.*, f.Name as FruitName, l.Name as ShopName, u.Name as UserName " +
                         "FROM Reservations r " +
                         "JOIN Fruits f ON r.FruitID = f.FruitID " +
                         "JOIN Locations l ON r.ShopLocationID = l.LocationID " +
                         "JOIN Users u ON r.UserID = u.UserID " +
                         "WHERE r.ReservationID = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, reservationID);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                reservation = new ReservationBean();
                reservation.setReservationID(rs.getInt("ReservationID"));
                reservation.setShopLocationID(rs.getInt("ShopLocationID"));
                reservation.setFruitID(rs.getInt("FruitID"));
                reservation.setQuantity(rs.getInt("Quantity"));
                reservation.setRequestDate(rs.getDate("RequestDate"));
                reservation.setDeliveryDate(rs.getDate("DeliveryDate"));
                reservation.setStatus(rs.getString("Status"));
                reservation.setUserID(rs.getInt("UserID"));
                reservation.setFruitName(rs.getString("FruitName"));
                reservation.setShopName(rs.getString("ShopName"));
                reservation.setUserName(rs.getString("UserName"));
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
        
        return reservation;
    }
    
    public boolean addReservation(ReservationBean reservation) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean isSuccess = false;
        
        try {
            conn = dbConnection.getConnection();
            String sql = "INSERT INTO Reservations (ShopLocationID, FruitID, Quantity, RequestDate, DeliveryDate, Status, UserID) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, reservation.getShopLocationID());
            pstmt.setInt(2, reservation.getFruitID());
            pstmt.setInt(3, reservation.getQuantity());
            pstmt.setDate(4, reservation.getRequestDate());
            pstmt.setDate(5, reservation.getDeliveryDate());
            pstmt.setString(6, reservation.getStatus());
            pstmt.setInt(7, reservation.getUserID());
            
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
    
    public boolean updateReservationStatus(int reservationID, String status) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean isSuccess = false;
        
        try {
            conn = dbConnection.getConnection();
            String sql = "UPDATE Reservations SET Status = ? WHERE ReservationID = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, status);
            pstmt.setInt(2, reservationID);
            
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
    
    public boolean deleteReservation(int reservationID) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean isSuccess = false;
        
        try {
            conn = dbConnection.getConnection();
            String sql = "DELETE FROM Reservations WHERE ReservationID = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, reservationID);
            
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
    
    public ArrayList<ReservationBean> getReservationsByStatus(String status) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        ArrayList<ReservationBean> reservations = new ArrayList<>();
        
        try {
            conn = dbConnection.getConnection();
            String sql = "SELECT r.*, f.Name as FruitName, l.Name as ShopName, u.Name as UserName " +
                         "FROM Reservations r " +
                         "JOIN Fruits f ON r.FruitID = f.FruitID " +
                         "JOIN Locations l ON r.ShopLocationID = l.LocationID " +
                         "JOIN Users u ON r.UserID = u.UserID " +
                         "WHERE r.Status = ? " +
                         "ORDER BY r.RequestDate DESC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, status);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                ReservationBean reservation = new ReservationBean();
                reservation.setReservationID(rs.getInt("ReservationID"));
                reservation.setShopLocationID(rs.getInt("ShopLocationID"));
                reservation.setFruitID(rs.getInt("FruitID"));
                reservation.setQuantity(rs.getInt("Quantity"));
                reservation.setRequestDate(rs.getDate("RequestDate"));
                reservation.setDeliveryDate(rs.getDate("DeliveryDate"));
                reservation.setStatus(rs.getString("Status"));
                reservation.setUserID(rs.getInt("UserID"));
                reservation.setFruitName(rs.getString("FruitName"));
                reservation.setShopName(rs.getString("ShopName"));
                reservation.setUserName(rs.getString("UserName"));
                
                reservations.add(reservation);
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
        
        return reservations;
    }
}
