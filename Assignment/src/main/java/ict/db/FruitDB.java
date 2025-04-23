/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ict.db;

/**
 *
 * @author Rain
 */
import ict.bean.FruitBean;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class FruitDB {
    private DBConnection dbConnection;
    
    public FruitDB(String url, String username, String password) {
        dbConnection = new DBConnection(url, username, password);
    }
    
    public ArrayList<FruitBean> queryFruit() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        ArrayList<FruitBean> fruits = new ArrayList<>();
        
        try {
            conn = dbConnection.getConnection();
            String preQueryStatement = "SELECT * FROM Fruits";
            pstmt = conn.prepareStatement(preQueryStatement);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                FruitBean fruit = new FruitBean();
                fruit.setFruitID(rs.getInt("FruitID"));
                fruit.setName(rs.getString("Name"));
                fruit.setDescription(rs.getString("Description"));
                fruit.setSourceCountry(rs.getString("SourceCountry"));
                fruits.add(fruit);
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
        
        return fruits;
    }
    
    public FruitBean getFruitByID(int fruitID) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        FruitBean fruit = null;
        
        try {
            conn = dbConnection.getConnection();
            String preQueryStatement = "SELECT * FROM Fruits WHERE FruitID=?";
            pstmt = conn.prepareStatement(preQueryStatement);
            pstmt.setInt(1, fruitID);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                fruit = new FruitBean();
                fruit.setFruitID(rs.getInt("FruitID"));
                fruit.setName(rs.getString("Name"));
                fruit.setDescription(rs.getString("Description"));
                fruit.setSourceCountry(rs.getString("SourceCountry"));
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
        
        return fruit;
    }
    
    public boolean addFruit(FruitBean fruit) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean isSuccess = false;
        
        try {
            conn = dbConnection.getConnection();
            String preQueryStatement = "INSERT INTO Fruits (Name, Description, SourceCountry) VALUES (?,?,?)";
            pstmt = conn.prepareStatement(preQueryStatement);
            pstmt.setString(1, fruit.getName());
            pstmt.setString(2, fruit.getDescription());
            pstmt.setString(3, fruit.getSourceCountry());
            
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
    
    public boolean updateFruit(FruitBean fruit) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean isSuccess = false;
        
        try {
            conn = dbConnection.getConnection();
            String preQueryStatement = "UPDATE Fruits SET Name=?, Description=?, SourceCountry=? WHERE FruitID=?";
            pstmt = conn.prepareStatement(preQueryStatement);
            pstmt.setString(1, fruit.getName());
            pstmt.setString(2, fruit.getDescription());
            pstmt.setString(3, fruit.getSourceCountry());
            pstmt.setInt(4, fruit.getFruitID());
            
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
    
    public boolean deleteFruit(int fruitID) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean isSuccess = false;
        
        try {
            conn = dbConnection.getConnection();
            String preQueryStatement = "DELETE FROM Fruits WHERE FruitID=?";
            pstmt = conn.prepareStatement(preQueryStatement);
            pstmt.setInt(1, fruitID);
            
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
