/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ict.db;

/**
 *
 * @author Rain
 */
import ict.bean.BorrowingBean;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class BorrowingDB {
    private DBConnection dbConnection;
    
    public BorrowingDB(String url, String username, String password) {
        dbConnection = new DBConnection(url, username, password);
    }
    
    public ArrayList<BorrowingBean> queryBorrowings() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        ArrayList<BorrowingBean> borrowings = new ArrayList<>();
        
        try {
            conn = dbConnection.getConnection();
            String sql = "SELECT b.*, f.Name as FruitName, " +
                       "s1.Name as SourceShopName, s2.Name as DestinationShopName, " +
                       "u.Name as UserName " +
                       "FROM Borrowings b " +
                       "JOIN Fruits f ON b.FruitID = f.FruitID " +
                       "JOIN Locations s1 ON b.SourceShopID = s1.LocationID " +
                       "JOIN Locations s2 ON b.DestinationShopID = s2.LocationID " +
                       "JOIN Users u ON b.UserID = u.UserID " +
                       "ORDER BY b.RequestDate DESC";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                BorrowingBean borrowing = new BorrowingBean();
                borrowing.setBorrowingID(rs.getInt("BorrowingID"));
                borrowing.setSourceShopID(rs.getInt("SourceShopID"));
                borrowing.setDestinationShopID(rs.getInt("DestinationShopID"));
                borrowing.setFruitID(rs.getInt("FruitID"));
                borrowing.setQuantity(rs.getInt("Quantity"));
                borrowing.setRequestDate(rs.getDate("RequestDate"));
                borrowing.setStatus(rs.getString("Status"));
                borrowing.setUserID(rs.getInt("UserID"));
                borrowing.setFruitName(rs.getString("FruitName"));
                borrowing.setSourceShopName(rs.getString("SourceShopName"));
                borrowing.setDestinationShopName(rs.getString("DestinationShopName"));
                borrowing.setUserName(rs.getString("UserName"));
                
                borrowings.add(borrowing);
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
        
        return borrowings;
    }
    
    public ArrayList<BorrowingBean> getBorrowingsBySourceShop(int sourceShopID) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        ArrayList<BorrowingBean> borrowings = new ArrayList<>();
        
        try {
            conn = dbConnection.getConnection();
            String sql = "SELECT b.*, f.Name as FruitName, " +
                       "s1.Name as SourceShopName, s2.Name as DestinationShopName, " +
                       "u.Name as UserName " +
                       "FROM Borrowings b " +
                       "JOIN Fruits f ON b.FruitID = f.FruitID " +
                       "JOIN Locations s1 ON b.SourceShopID = s1.LocationID " +
                       "JOIN Locations s2 ON b.DestinationShopID = s2.LocationID " +
                       "JOIN Users u ON b.UserID = u.UserID " +
                       "WHERE b.SourceShopID = ? " +
                       "ORDER BY b.RequestDate DESC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, sourceShopID);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                BorrowingBean borrowing = new BorrowingBean();
                borrowing.setBorrowingID(rs.getInt("BorrowingID"));
                borrowing.setSourceShopID(rs.getInt("SourceShopID"));
                borrowing.setDestinationShopID(rs.getInt("DestinationShopID"));
                borrowing.setFruitID(rs.getInt("FruitID"));
                borrowing.setQuantity(rs.getInt("Quantity"));
                borrowing.setRequestDate(rs.getDate("RequestDate"));
                borrowing.setStatus(rs.getString("Status"));
                borrowing.setUserID(rs.getInt("UserID"));
                borrowing.setFruitName(rs.getString("FruitName"));
                borrowing.setSourceShopName(rs.getString("SourceShopName"));
                borrowing.setDestinationShopName(rs.getString("DestinationShopName"));
                borrowing.setUserName(rs.getString("UserName"));
                
                borrowings.add(borrowing);
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
        
        return borrowings;
    }
    
    public ArrayList<BorrowingBean> getBorrowingsByDestinationShop(int destinationShopID) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        ArrayList<BorrowingBean> borrowings = new ArrayList<>();
        
        try {
            conn = dbConnection.getConnection();
            String sql = "SELECT b.*, f.Name as FruitName, " +
                       "s1.Name as SourceShopName, s2.Name as DestinationShopName, " +
                       "u.Name as UserName " +
                       "FROM Borrowings b " +
                       "JOIN Fruits f ON b.FruitID = f.FruitID " +
                       "JOIN Locations s1 ON b.SourceShopID = s1.LocationID " +
                       "JOIN Locations s2 ON b.DestinationShopID = s2.LocationID " +
                       "JOIN Users u ON b.UserID = u.UserID " +
                       "WHERE b.DestinationShopID = ? " +
                       "ORDER BY b.RequestDate DESC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, destinationShopID);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                BorrowingBean borrowing = new BorrowingBean();
                borrowing.setBorrowingID(rs.getInt("BorrowingID"));
                borrowing.setSourceShopID(rs.getInt("SourceShopID"));
                borrowing.setDestinationShopID(rs.getInt("DestinationShopID"));
                borrowing.setFruitID(rs.getInt("FruitID"));
                borrowing.setQuantity(rs.getInt("Quantity"));
                borrowing.setRequestDate(rs.getDate("RequestDate"));
                borrowing.setStatus(rs.getString("Status"));
                borrowing.setUserID(rs.getInt("UserID"));
                borrowing.setFruitName(rs.getString("FruitName"));
                borrowing.setSourceShopName(rs.getString("SourceShopName"));
                borrowing.setDestinationShopName(rs.getString("DestinationShopName"));
                borrowing.setUserName(rs.getString("UserName"));
                
                borrowings.add(borrowing);
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
        
        return borrowings;
    }
    
    public BorrowingBean getBorrowingByID(int borrowingID) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        BorrowingBean borrowing = null;
        
        try {
            conn = dbConnection.getConnection();
            String sql = "SELECT b.*, f.Name as FruitName, " +
                       "s1.Name as SourceShopName, s2.Name as DestinationShopName, " +
                       "u.Name as UserName " +
                       "FROM Borrowings b " +
                       "JOIN Fruits f ON b.FruitID = f.FruitID " +
                       "JOIN Locations s1 ON b.SourceShopID = s1.LocationID " +
                       "JOIN Locations s2 ON b.DestinationShopID = s2.LocationID " +
                       "JOIN Users u ON b.UserID = u.UserID " +
                       "WHERE b.BorrowingID = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, borrowingID);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                borrowing = new BorrowingBean();
                borrowing.setBorrowingID(rs.getInt("BorrowingID"));
                borrowing.setSourceShopID(rs.getInt("SourceShopID"));
                borrowing.setDestinationShopID(rs.getInt("DestinationShopID"));
                borrowing.setFruitID(rs.getInt("FruitID"));
                borrowing.setQuantity(rs.getInt("Quantity"));
                borrowing.setRequestDate(rs.getDate("RequestDate"));
                borrowing.setStatus(rs.getString("Status"));
                borrowing.setUserID(rs.getInt("UserID"));
                borrowing.setFruitName(rs.getString("FruitName"));
                borrowing.setSourceShopName(rs.getString("SourceShopName"));
                borrowing.setDestinationShopName(rs.getString("DestinationShopName"));
                borrowing.setUserName(rs.getString("UserName"));
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
        
        return borrowing;
    }
    
    public boolean addBorrowing(BorrowingBean borrowing) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean isSuccess = false;
        
        try {
            conn = dbConnection.getConnection();
            String sql = "INSERT INTO Borrowings (SourceShopID, DestinationShopID, FruitID, Quantity, RequestDate, Status, UserID) " +
                       "VALUES (?, ?, ?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, borrowing.getSourceShopID());
            pstmt.setInt(2, borrowing.getDestinationShopID());
            pstmt.setInt(3, borrowing.getFruitID());
            pstmt.setInt(4, borrowing.getQuantity());
            pstmt.setDate(5, borrowing.getRequestDate());
            pstmt.setString(6, borrowing.getStatus());
            pstmt.setInt(7, borrowing.getUserID());
            
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
    
    public boolean updateBorrowingStatus(int borrowingID, String status) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean isSuccess = false;
        
        try {
            conn = dbConnection.getConnection();
            String sql = "UPDATE Borrowings SET Status = ? WHERE BorrowingID = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, status);
            pstmt.setInt(2, borrowingID);
            
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
    
    public boolean deleteBorrowing(int borrowingID) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean isSuccess = false;
        
        try {
            conn = dbConnection.getConnection();
            String sql = "DELETE FROM Borrowings WHERE BorrowingID = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, borrowingID);
            
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
}