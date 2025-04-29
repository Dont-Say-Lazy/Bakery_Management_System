package ict.bean;

import java.io.Serializable;
import java.sql.Date;

public class DeliveryBean implements Serializable {
    private int deliveryID;
    private int sourceLocationID;
    private int destinationLocationID;
    private Date deliveryDate;
    private String status;
    private String type;
    private int requestID;
    private String sourceLocationName;
    private String destinationLocationName;
    private int fruitID;
    private String fruitName;
    private int quantity;

    public DeliveryBean() {
    }
    
    // Constructor for creating a new delivery
    public DeliveryBean(int sourceLocationID, int destinationLocationID, Date deliveryDate, 
                        String type, int requestID) {
        this.sourceLocationID = sourceLocationID;
        this.destinationLocationID = destinationLocationID;
        this.deliveryDate = deliveryDate;
        this.status = "pending";
        this.type = type;
        this.requestID = requestID;
    }
    
    // Full constructor
    public DeliveryBean(int deliveryID, int sourceLocationID, int destinationLocationID, 
                        Date deliveryDate, String status, String type, int requestID) {
        this.deliveryID = deliveryID;
        this.sourceLocationID = sourceLocationID;
        this.destinationLocationID = destinationLocationID;
        this.deliveryDate = deliveryDate;
        this.status = status;
        this.type = type;
        this.requestID = requestID;
    }

    public int getDeliveryID() {
        return deliveryID;
    }

    public void setDeliveryID(int deliveryID) {
        this.deliveryID = deliveryID;
    }

    public int getSourceLocationID() {
        return sourceLocationID;
    }

    public void setSourceLocationID(int sourceLocationID) {
        this.sourceLocationID = sourceLocationID;
    }

    public int getDestinationLocationID() {
        return destinationLocationID;
    }

    public void setDestinationLocationID(int destinationLocationID) {
        this.destinationLocationID = destinationLocationID;
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

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public int getRequestID() {
        return requestID;
    }

    public void setRequestID(int requestID) {
        this.requestID = requestID;
    }

    public String getSourceLocationName() {
        return sourceLocationName;
    }

    public void setSourceLocationName(String sourceLocationName) {
        this.sourceLocationName = sourceLocationName;
    }

    public String getDestinationLocationName() {
        return destinationLocationName;
    }

    public void setDestinationLocationName(String destinationLocationName) {
        this.destinationLocationName = destinationLocationName;
    }

    public int getFruitID() {
        return fruitID;
    }

    public void setFruitID(int fruitID) {
        this.fruitID = fruitID;
    }

    public String getFruitName() {
        return fruitName;
    }

    public void setFruitName(String fruitName) {
        this.fruitName = fruitName;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
} 