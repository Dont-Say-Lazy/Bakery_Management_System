/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ict.tag;

/**
 *
 * @author User
 */

import ict.bean.LocationBean;
import ict.db.DBConnection;
import ict.db.LocationDB;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.tagext.SimpleTagSupport;

public class LocationSelectorTag extends SimpleTagSupport {
    private String type;
    private String name;
    private String id;
    private String selectedValue;
    private boolean required;
    
    public void setType(String type) {
        this.type = type;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public void setId(String id) {
        this.id = id;
    }
    
    public void setSelectedValue(String selectedValue) {
        this.selectedValue = selectedValue;
    }
    
    public void setRequired(boolean required) {
        this.required = required;
    }
    
    @Override
    public void doTag() throws JspException, IOException {
        PageContext pageContext = (PageContext) getJspContext();
        JspWriter out = pageContext.getOut();
        
        String dbUrl = pageContext.getServletContext().getInitParameter("dbUrl");
        String dbUser = pageContext.getServletContext().getInitParameter("dbUser");
        String dbPassword = pageContext.getServletContext().getInitParameter("dbPassword");
        
        try {
            LocationDB locationDB = new LocationDB(dbUrl, dbUser, dbPassword);
            ArrayList<LocationBean> locations;
            
            if (type != null && !type.isEmpty()) {
                locations = locationDB.queryLocationsByType(type);
            } else {
                locations = locationDB.queryLocation();
            }
            
            // Start select element
            out.println("<select name=\"" + name + "\" id=\"" + (id != null ? id : name) + "\"" + (required ? " required" : "") + ">");
            out.println("<option value=\"\">Select Location</option>");
            
            // Add options from locations
            for (LocationBean location : locations) {
                String selected = "";
                if (selectedValue != null && selectedValue.equals(String.valueOf(location.getLocationID()))) {
                    selected = " selected";
                }
                
                out.println("<option value=\"" + location.getLocationID() + "\"" + selected + ">" + 
                            location.getName() + " (" + location.getCity() + ", " + location.getCountry() + ")</option>");
            }
            
            // End select element
            out.println("</select>");
            
        } catch (Exception ex) {
            out.println("Error generating location selector: " + ex.getMessage());
        }
    }
}