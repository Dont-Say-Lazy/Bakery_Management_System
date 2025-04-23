/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ict.db;

/**
 *
 * @author Rain
 */
import ict.bean.LocationBean;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class LocationDB {
    private DBConnection dbConnection;
    
    public LocationDB(String url, String username, String password) {
        dbConnection = new DBConnection(url, username, password);
    }
    
    public ArrayList<LocationBean> queryLocation() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        ArrayList<LocationBean> locations = new ArrayList<>();
        
        try {
            conn = dbConnection.getConnection();
            String preQueryStatement = "SELECT * FROM Locations";
            pstmt = conn.prepareStatement(preQueryStatement);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                LocationBean location = new LocationBean();
                location.setLocationID(rs.getInt("LocationID"));
                location.setName(rs.getString("Name"));
                location.setCity(rs.getString("City"));
                location.setCountry(rs.getString("Country"));
                location.setType(rs.getString("Type"));
                location.setIsSource(rs.getBoolean("IsSource"));
                locations.add(location);
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
        
        return locations;
    }
    
    public ArrayList<LocationBean> queryLocationsByType(String type) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        ArrayList<LocationBean> locations = new ArrayList<>();
        
        try {
            conn = dbConnection.getConnection();
            String preQueryStatement = "SELECT * FROM Locations WHERE Type=?";
            pstmt = conn.prepareStatement(preQueryStatement);
            pstmt.setString(1, type);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                LocationBean location = new LocationBean();
                location.setLocationID(rs.getInt("LocationID"));
                location.setName(rs.getString("Name"));
                location.setCity(rs.getString("City"));
                location.setCountry(rs.getString("Country"));
                location.setType(rs.getString("Type"));
                location.setIsSource(rs.getBoolean("IsSource"));
                locations.add(location);
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
        
        return locations;
    }
    
    public ArrayList<LocationBean> queryLocationsByCity(String city) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        ArrayList<LocationBean> locations = new ArrayList<>();
        
        try {
            conn = dbConnection.getConnection();
            String preQueryStatement = "SELECT * FROM Locations WHERE City=?";
            pstmt = conn.prepareStatement(preQueryStatement);
            pstmt.setString(1, city);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                LocationBean location = new LocationBean();
                location.setLocationID(rs.getInt("LocationID"));
                location.setName(rs.getString("Name"));
                location.setCity(rs.getString("City"));
                location.setCountry(rs.getString("Country"));
                location.setType(rs.getString("Type"));
                location.setIsSource(rs.getBoolean("IsSource"));
                locations.add(location);
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
        
        return locations;
    }
    
    public LocationBean getLocationByID(int locationID) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        LocationBean location = null;
        
        try {
            conn = dbConnection.getConnection();
            String preQueryStatement = "SELECT * FROM Locations WHERE LocationID=?";
            pstmt = conn.prepareStatement(preQueryStatement);
            pstmt.setInt(1, locationID);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                location = new LocationBean();
                location.setLocationID(rs.getInt("LocationID"));
                location.setName(rs.getString("Name"));
                location.setCity(rs.getString("City"));
                location.setCountry(rs.getString("Country"));
                location.setType(rs.getString("Type"));
                location.setIsSource(rs.getBoolean("IsSource"));
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
        
        return location;
    }
    
    public boolean addLocation(LocationBean location) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean isSuccess = false;
        
        try {
            conn = dbConnection.getConnection();
            String preQueryStatement = "INSERT INTO Locations (Name, City, Country, Type, IsSource) VALUES (?,?,?,?,?)";
            pstmt = conn.prepareStatement(preQueryStatement);
            pstmt.setString(1, location.getName());
            pstmt.setString(2, location.getCity());
            pstmt.setString(3, location.getCountry());
            pstmt.setString(4, location.getType());
            pstmt.setBoolean(5, location.isIsSource());
            
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
    
    public boolean updateLocation(LocationBean location) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean isSuccess = false;
        
        try {
            conn = dbConnection.getConnection();
            String preQueryStatement = "UPDATE Locations SET Name=?, City=?, Country=?, Type=?, IsSource=? WHERE LocationID=?";
            pstmt = conn.prepareStatement(preQueryStatement);
            pstmt.setString(1, location.getName());
            pstmt.setString(2, location.getCity());
            pstmt.setString(3, location.getCountry());
            pstmt.setString(4, location.getType());
            pstmt.setBoolean(5, location.isIsSource());
            pstmt.setInt(6, location.getLocationID());
            
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
    
    public boolean deleteLocation(int locationID) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean isSuccess = false;
        
        try {
            conn = dbConnection.getConnection();
            String preQueryStatement = "DELETE FROM Locations WHERE LocationID=?";
            pstmt = conn.prepareStatement(preQueryStatement);
            pstmt.setInt(1, locationID);
            
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
