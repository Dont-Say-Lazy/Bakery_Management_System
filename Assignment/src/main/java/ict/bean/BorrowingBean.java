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
import java.sql.Date;

public class BorrowingBean implements Serializable {
    private int borrowingID;
    private int sourceShopID;
    private int destinationShopID;
    private int fruitID;
    private int quantity;
    private Date requestDate;
    private String status;
    private int userID;
    
    // Extra properties for display
    private String fruitName;
    private String sourceShopName;
    private String destinationShopName;
    private String userName;
    
    // Default constructor
    public BorrowingBean() {
    }
    
    // Getters and setters
    public int getBorrowingID() {
        return borrowingID;
    }
    
    public void setBorrowingID(int borrowingID) {
        this.borrowingID = borrowingID;
    }
    
    public int getSourceShopID() {
        return sourceShopID;
    }
    
    public void setSourceShopID(int sourceShopID) {
        this.sourceShopID = sourceShopID;
    }
    
    public int getDestinationShopID() {
        return destinationShopID;
    }
    
    public void setDestinationShopID(int destinationShopID) {
        this.destinationShopID = destinationShopID;
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
    
    public Date getRequestDate() {
        return requestDate;
    }
    
    public void setRequestDate(Date requestDate) {
        this.requestDate = requestDate;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public int getUserID() {
        return userID;
    }
    
    public void setUserID(int userID) {
        this.userID = userID;
    }
    
    public String getFruitName() {
        return fruitName;
    }
    
    public void setFruitName(String fruitName) {
        this.fruitName = fruitName;
    }
    
    public String getSourceShopName() {
        return sourceShopName;
    }
    
    public void setSourceShopName(String sourceShopName) {
        this.sourceShopName = sourceShopName;
    }
    
    public String getDestinationShopName() {
        return destinationShopName;
    }
    
    public void setDestinationShopName(String destinationShopName) {
        this.destinationShopName = destinationShopName;
    }
    
    public String getUserName() {
        return userName;
    }
    
    public void setUserName(String userName) {
        this.userName = userName;
    }
}
