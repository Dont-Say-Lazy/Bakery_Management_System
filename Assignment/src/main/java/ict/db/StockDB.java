/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ict.db;

/**
 *
 * @author Rain
 */
import ict.bean.StockBean;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class StockDB {
    private DBConnection dbConnection;
    
    public StockDB(String url, String username, String password) {
        dbConnection = new DBConnection(url, username, password);
    }
    
    public ArrayList<StockBean> queryStock() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        ArrayList<StockBean> stocks = new ArrayList<>();
        
        try {
            conn = dbConnection.getConnection();
            String preQueryStatement = "SELECT s.*, f.Name as FruitName, l.Name as LocationName FROM Stock s " +
                                      "JOIN Fruits f ON s.FruitID = f.FruitID " +
                                      "JOIN Locations l ON s.LocationID = l.LocationID";
            pstmt = conn.prepareStatement(preQueryStatement);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                StockBean stock = new StockBean();
                stock.setStockID(rs.getInt("StockID"));
                stock.setLocationID(rs.getInt("LocationID"));
                stock.setFruitID(rs.getInt("FruitID"));
                stock.setQuantity(rs.getInt("Quantity"));
                stock.setLastUpdated(rs.getTimestamp("LastUpdated"));
                stock.setFruitName(rs.getString("FruitName"));
                stock.setLocationName(rs.getString("LocationName"));
                stocks.add(stock);
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
        
        return stocks;
    }
    
    public ArrayList<StockBean> queryStockByLocation(int locationID) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        ArrayList<StockBean> stocks = new ArrayList<>();
        
        try {
            conn = dbConnection.getConnection();
            String preQueryStatement = "SELECT s.*, f.Name as FruitName, l.Name as LocationName FROM Stock s " +
                                      "JOIN Fruits f ON s.FruitID = f.FruitID " +
                                      "JOIN Locations l ON s.LocationID = l.LocationID " +
                                      "WHERE s.LocationID = ?";
            pstmt = conn.prepareStatement(preQueryStatement);
            pstmt.setInt(1, locationID);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                StockBean stock = new StockBean();
                stock.setStockID(rs.getInt("StockID"));
                stock.setLocationID(rs.getInt("LocationID"));
                stock.setFruitID(rs.getInt("FruitID"));
                stock.setQuantity(rs.getInt("Quantity"));
                stock.setLastUpdated(rs.getTimestamp("LastUpdated"));
                stock.setFruitName(rs.getString("FruitName"));
                stock.setLocationName(rs.getString("LocationName"));
                stocks.add(stock);
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
        
        return stocks;
    }
    
    public StockBean getStockByLocationAndFruit(int locationID, int fruitID) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        StockBean stock = null;
        
        try {
            conn = dbConnection.getConnection();
            String preQueryStatement = "SELECT s.*, f.Name as FruitName, l.Name as LocationName FROM Stock s " +
                                      "JOIN Fruits f ON s.FruitID = f.FruitID " +
                                      "JOIN Locations l ON s.LocationID = l.LocationID " +
                                      "WHERE s.LocationID = ? AND s.FruitID = ?";
            pstmt = conn.prepareStatement(preQueryStatement);
            pstmt.setInt(1, locationID);
            pstmt.setInt(2, fruitID);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                stock = new StockBean();
                stock.setStockID(rs.getInt("StockID"));
                stock.setLocationID(rs.getInt("LocationID"));
                stock.setFruitID(rs.getInt("FruitID"));
                stock.setQuantity(rs.getInt("Quantity"));
                stock.setLastUpdated(rs.getTimestamp("LastUpdated"));
                stock.setFruitName(rs.getString("FruitName"));
                stock.setLocationName(rs.getString("LocationName"));
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
        
        return stock;
    }
    
    public boolean addStock(StockBean stock) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean isSuccess = false;
        
        try {
            conn = dbConnection.getConnection();
            String preQueryStatement = "INSERT INTO Stock (LocationID, FruitID, Quantity) VALUES (?,?,?)";
            pstmt = conn.prepareStatement(preQueryStatement);
            pstmt.setInt(1, stock.getLocationID());
            pstmt.setInt(2, stock.getFruitID());
            pstmt.setInt(3, stock.getQuantity());
            
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
    
    public boolean updateStock(StockBean stock) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean isSuccess = false;
        
        try {
            conn = dbConnection.getConnection();
            String preQueryStatement = "UPDATE Stock SET Quantity=? WHERE StockID=?";
            pstmt = conn.prepareStatement(preQueryStatement);
            pstmt.setInt(1, stock.getQuantity());
            pstmt.setInt(2, stock.getStockID());
            
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
    
    public boolean updateStockQuantity(int locationID, int fruitID, int quantity) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean isSuccess = false;
        
        try {
            conn = dbConnection.getConnection();
            
            // Check if stock entry already exists
            String checkQuery = "SELECT * FROM Stock WHERE LocationID=? AND FruitID=?";
            pstmt = conn.prepareStatement(checkQuery);
            pstmt.setInt(1, locationID);
            pstmt.setInt(2, fruitID);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                // Update existing stock
                String updateQuery = "UPDATE Stock SET Quantity=? WHERE LocationID=? AND FruitID=?";
                pstmt = conn.prepareStatement(updateQuery);
                pstmt.setInt(1, quantity);
                pstmt.setInt(2, locationID);
                pstmt.setInt(3, fruitID);
            } else {
                // Insert new stock
                String insertQuery = "INSERT INTO Stock (LocationID, FruitID, Quantity) VALUES (?,?,?)";
                pstmt = conn.prepareStatement(insertQuery);
                pstmt.setInt(1, locationID);
                pstmt.setInt(2, fruitID);
                pstmt.setInt(3, quantity);
            }
            
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
    
    public boolean deleteStock(int stockID) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean isSuccess = false;
        
        try {
            conn = dbConnection.getConnection();
            String preQueryStatement = "DELETE FROM Stock WHERE StockID=?";
            pstmt = conn.prepareStatement(preQueryStatement);
            pstmt.setInt(1, stockID);
            
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
