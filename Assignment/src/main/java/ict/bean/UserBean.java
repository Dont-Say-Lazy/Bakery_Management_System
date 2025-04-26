/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ict.bean;

/**
 *
 * @author AlexS
 */
import java.io.Serializable;

public class UserBean implements Serializable {

    private int userID;
    private String username;
    private String password;
    private String role;
    private String name;
    private int locationID;
    private int isCentralStaff;

    // Default constructor
    public UserBean() {
    }

    // Getters and setters
    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getLocationID() {
        return locationID;
    }

    public void setLocationID(int locationID) {
        this.locationID = locationID;
    }
    
    public int getIsCentralStaff() {
        return isCentralStaff;
    }
    
    public void setIsCentralStaff(int isCentralStaff) {
        this.isCentralStaff = isCentralStaff;
    }
}
