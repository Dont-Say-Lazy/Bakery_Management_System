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

public class ReservationBean implements Serializable {
    private int reservationID;
    private int shopLocationID;
    private int fruitID;
    private int quantity;
    private Date requestDate;
    private Date deliveryDate;
    private String status;
    private int userID;
    
    // Extra properties for display
    private String fruitName;
    private String shopName;
    private String userName;
    
    // Default constructor
    public ReservationBean() {
    }
    
    // Getters and setters
    public int getReservationID() {
        return reservationID;
    }
    
    public void setReservationID(int reservationID) {
        this.reservationID = reservationID;
    }
    
    public int getShopLocationID() {
        return shopLocationID;
    }
    
    public void setShopLocationID(int shopLocationID) {
        this.shopLocationID = shopLocationID;
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
    
    public Date getDeliveryDate() {
        return deliveryDate;
    }
    
    public void setDeliveryDate(Date deliveryDate) {
        this.deliveryDate = deliveryDate;
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
    
    public String getShopName() {
        return shopName;
    }
    
    public void setShopName(String shopName) {
        this.shopName = shopName;
    }
    
    public String getUserName() {
        return userName;
    }
    
    public void setUserName(String userName) {
        this.userName = userName;
    }
}
