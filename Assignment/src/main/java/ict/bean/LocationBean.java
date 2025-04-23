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

public class LocationBean implements Serializable {
    private int locationID;
    private String name;
    private String city;
    private String country;
    private String type;
    private boolean isSource;
    
    // Default constructor
    public LocationBean() {
    }
    
    // Getters and setters
    public int getLocationID() {
        return locationID;
    }
    
    public void setLocationID(int locationID) {
        this.locationID = locationID;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getCity() {
        return city;
    }
    
    public void setCity(String city) {
        this.city = city;
    }
    
    public String getCountry() {
        return country;
    }
    
    public void setCountry(String country) {
        this.country = country;
    }
    
    public String getType() {
        return type;
    }
    
    public void setType(String type) {
        this.type = type;
    }
    
    public boolean isIsSource() {
        return isSource;
    }
    
    public void setIsSource(boolean isSource) {
        this.isSource = isSource;
    }
}
