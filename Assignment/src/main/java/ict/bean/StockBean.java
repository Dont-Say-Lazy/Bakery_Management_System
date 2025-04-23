/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ict.bean;

/**
 *
 * @author Rain
 */
import java.io.Serializable;
import java.sql.Timestamp;

public class StockBean implements Serializable {
    private int stockID;
    private int locationID;
    private int fruitID;
    private int quantity;
    private Timestamp lastUpdated;
    
    // Extra properties for display
    private String fruitName;
    private String locationName;
    
    // Default constructor
    public StockBean() {
    }
    
    // Getters and setters
    public int getStockID() {
        return stockID;
    }
    
    public void setStockID(int stockID) {
        this.stockID = stockID;
    }
    
    public int getLocationID() {
        return locationID;
    }
    
    public void setLocationID(int locationID) {
        this.locationID = locationID;
    }
    
    public int getFruitID() {
        return fruitID;
    }
    
    public void setFruitID(int fruitID) {
        this.fruitID = fruitID;
    }
    
    public int getQuantity() {
        return quantity;
    }
    
    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
    
    public Timestamp getLastUpdated() {
        return lastUpdated;
    }
    
    public void setLastUpdated(Timestamp lastUpdated) {
        this.lastUpdated = lastUpdated;
    }
    
    public String getFruitName() {
        return fruitName;
    }
    
    public void setFruitName(String fruitName) {
        this.fruitName = fruitName;
    }
    
    public String getLocationName() {
        return locationName;
    }
    
    public void setLocationName(String locationName) {
        this.locationName = locationName;
    }
}
