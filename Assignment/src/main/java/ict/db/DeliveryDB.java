package ict.db;

import ict.bean.DeliveryBean;
import java.sql.*;
import java.util.ArrayList;

public class DeliveryDB {

    private String dbUrl = "";
    private String dbUser = "";
    private String dbPassword = "";

    public DeliveryDB() {
    }

    public DeliveryDB(String dbUrl, String dbUser, String dbPassword) {
        this.dbUrl = dbUrl;
        this.dbUser = dbUser;
        this.dbPassword = dbPassword;
    }

    public Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        return DriverManager.getConnection(dbUrl, dbUser, dbPassword);
    }

    public int addDelivery(DeliveryBean delivery) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int generatedId = -1;

        try {
            conn = getConnection();
            String sql = "INSERT INTO deliveries (SourceLocationID, DestinationLocationID, " +
                    "DeliveryDate, Status, Type, RequestID) VALUES (?, ?, ?, ?, ?, ?)";
            
            pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            pstmt.setInt(1, delivery.getSourceLocationID());
            pstmt.setInt(2, delivery.getDestinationLocationID());
            pstmt.setDate(3, delivery.getDeliveryDate());
            pstmt.setString(4, delivery.getStatus());
            pstmt.setString(5, delivery.getType());
            pstmt.setInt(6, delivery.getRequestID());
            
            int rowsAffected = pstmt.executeUpdate();
            
            if (rowsAffected > 0) {
                // Get the generated ID
                ResultSet rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    generatedId = rs.getInt(1);
                }
                rs.close();
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
        
        return generatedId;
    }
    
    public ArrayList<DeliveryBean> getDeliveriesByStatus(String status) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        ArrayList<DeliveryBean> deliveries = new ArrayList<>();

        try {
            conn = getConnection();
            String sql = "SELECT d.*, sl.Name as SourceName, dl.Name as DestName " +
                    "FROM deliveries d " +
                    "JOIN locations sl ON d.SourceLocationID = sl.LocationID " +
                    "JOIN locations dl ON d.DestinationLocationID = dl.LocationID " +
                    "WHERE d.Status = ? ORDER BY d.DeliveryDate";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, status);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                DeliveryBean delivery = new DeliveryBean();
                delivery.setDeliveryID(rs.getInt("DeliveryID"));
                delivery.setSourceLocationID(rs.getInt("SourceLocationID"));
                delivery.setDestinationLocationID(rs.getInt("DestinationLocationID"));
                delivery.setDeliveryDate(rs.getDate("DeliveryDate"));
                delivery.setStatus(rs.getString("Status"));
                delivery.setType(rs.getString("Type"));
                delivery.setRequestID(rs.getInt("RequestID"));
                delivery.setSourceLocationName(rs.getString("SourceName"));
                delivery.setDestinationLocationName(rs.getString("DestName"));
                
                deliveries.add(delivery);
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
        
        return deliveries;
    }
    
    public DeliveryBean getDeliveryById(int deliveryId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        DeliveryBean delivery = null;

        try {
            conn = getConnection();
            String sql = "SELECT d.*, sl.Name as SourceName, dl.Name as DestName " +
                    "FROM deliveries d " +
                    "JOIN locations sl ON d.SourceLocationID = sl.LocationID " +
                    "JOIN locations dl ON d.DestinationLocationID = dl.LocationID " +
                    "WHERE d.DeliveryID = ?";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, deliveryId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                delivery = new DeliveryBean();
                delivery.setDeliveryID(rs.getInt("DeliveryID"));
                delivery.setSourceLocationID(rs.getInt("SourceLocationID"));
                delivery.setDestinationLocationID(rs.getInt("DestinationLocationID"));
                delivery.setDeliveryDate(rs.getDate("DeliveryDate"));
                delivery.setStatus(rs.getString("Status"));
                delivery.setType(rs.getString("Type"));
                delivery.setRequestID(rs.getInt("RequestID"));
                delivery.setSourceLocationName(rs.getString("SourceName"));
                delivery.setDestinationLocationName(rs.getString("DestName"));
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
        
        return delivery;
    }
    
    public boolean updateDeliveryStatus(int deliveryId, String status) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;

        try {
            conn = getConnection();
            String sql = "UPDATE deliveries SET Status = ? WHERE DeliveryID = ?";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, status);
            pstmt.setInt(2, deliveryId);
            
            int rowsAffected = pstmt.executeUpdate();
            success = rowsAffected > 0;
            
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
        
        return success;
    }
    
    public ArrayList<DeliveryBean> getDeliveriesByType(String type) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        ArrayList<DeliveryBean> deliveries = new ArrayList<>();

        try {
            conn = getConnection();
            String sql = "SELECT d.*, sl.Name as SourceName, dl.Name as DestName " +
                    "FROM deliveries d " +
                    "JOIN locations sl ON d.SourceLocationID = sl.LocationID " +
                    "JOIN locations dl ON d.DestinationLocationID = dl.LocationID " +
                    "WHERE d.Type = ? ORDER BY d.DeliveryDate";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, type);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                DeliveryBean delivery = new DeliveryBean();
                delivery.setDeliveryID(rs.getInt("DeliveryID"));
                delivery.setSourceLocationID(rs.getInt("SourceLocationID"));
                delivery.setDestinationLocationID(rs.getInt("DestinationLocationID"));
                delivery.setDeliveryDate(rs.getDate("DeliveryDate"));
                delivery.setStatus(rs.getString("Status"));
                delivery.setType(rs.getString("Type"));
                delivery.setRequestID(rs.getInt("RequestID"));
                delivery.setSourceLocationName(rs.getString("SourceName"));
                delivery.setDestinationLocationName(rs.getString("DestName"));
                
                deliveries.add(delivery);
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
        
        return deliveries;
    }
    
    // Method to create a direct delivery (without an existing reservation)
    public int createDirectDelivery(int sourceLocationID, int destinationLocationID, int fruitID, 
                                   int quantity, Date deliveryDate, int userID) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int deliveryId = -1;

        try {
            conn = getConnection();
            conn.setAutoCommit(false);
            
            // 1. Create a new reservation with 'approved' status
            String insertReservation = "INSERT INTO reservations (ShopLocationID, FruitID, Quantity, " +
                    "RequestDate, DeliveryDate, Status, UserID) VALUES (?, ?, ?, CURDATE(), ?, 'approved', ?)";
            
            pstmt = conn.prepareStatement(insertReservation, Statement.RETURN_GENERATED_KEYS);
            pstmt.setInt(1, destinationLocationID);
            pstmt.setInt(2, fruitID);
            pstmt.setInt(3, quantity);
            pstmt.setDate(4, deliveryDate);
            pstmt.setInt(5, userID);
            pstmt.executeUpdate();
            
            int reservationId = -1;
            rs = pstmt.getGeneratedKeys();
            if (rs.next()) {
                reservationId = rs.getInt(1);
            }
            rs.close();
            pstmt.close();
            
            if (reservationId != -1) {
                // 2. Create a delivery record linked to the reservation
                String insertDelivery = "INSERT INTO deliveries (SourceLocationID, DestinationLocationID, " +
                        "DeliveryDate, Status, Type, RequestID) VALUES (?, ?, ?, 'pending', 'reservation', ?)";
                
                pstmt = conn.prepareStatement(insertDelivery, Statement.RETURN_GENERATED_KEYS);
                pstmt.setInt(1, sourceLocationID);
                pstmt.setInt(2, destinationLocationID);
                pstmt.setDate(3, deliveryDate);
                pstmt.setInt(4, reservationId);
                pstmt.executeUpdate();
                
                rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    deliveryId = rs.getInt(1);
                }
                
                // 3. Update stock at source location (subtract quantity)
                String updateSourceStock = "UPDATE stock SET Quantity = Quantity - ? " +
                        "WHERE LocationID = ? AND FruitID = ?";
                pstmt.close();
                
                pstmt = conn.prepareStatement(updateSourceStock);
                pstmt.setInt(1, quantity);
                pstmt.setInt(2, sourceLocationID);
                pstmt.setInt(3, fruitID);
                pstmt.executeUpdate();
            }
            
            conn.commit();
            
        } catch (SQLException ex) {
            ex.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (pstmt != null) {
                    pstmt.close();
                }
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
        
        return deliveryId;
    }
} 