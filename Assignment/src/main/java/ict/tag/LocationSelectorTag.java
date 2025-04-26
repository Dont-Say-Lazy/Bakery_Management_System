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
import ict.bean.UserBean;
import ict.db.DBConnection;
import ict.db.LocationDB;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import javax.servlet.http.HttpSession;
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
    private String cssClass;
    private String excludeIds;
    private String onChange;
    private String selectorType; // "source" or "destination"
    
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
    
    public void setCssClass(String cssClass) {
        this.cssClass = cssClass;
    }
    
    public void setExcludeIds(String excludeIds) {
        this.excludeIds = excludeIds;
    }
    
    public void setOnChange(String onChange) {
        this.onChange = onChange;
    }
    
    public void setSelectorType(String selectorType) {
        this.selectorType = selectorType;
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
            
            // Get user from session
            HttpSession session = pageContext.getSession();
            UserBean user = (UserBean) session.getAttribute("userInfo");
            
            if (user != null) {
                int userLocationID = user.getLocationID();
                boolean isCentralStaff = user.getIsCentralStaff() == 1;
                
                // Get locations based on user role and selector type
                if ("source".equals(selectorType)) {
                    locations = locationDB.querySourceLocationsForUser(userLocationID, isCentralStaff);
                } else if ("destination".equals(selectorType)) {
                    locations = locationDB.queryDestinationLocationsForUser(userLocationID, isCentralStaff);
                } else if (type != null && !type.isEmpty()) {
                    locations = locationDB.queryLocationsByType(type);
                } else {
                    locations = locationDB.queryLocation();
                }
            } else {
                // Fallback to regular behavior if user not in session
                if (type != null && !type.isEmpty()) {
                    locations = locationDB.queryLocationsByType(type);
                } else {
                    locations = locationDB.queryLocation();
                }
            }
            
            // Process exclude IDs if provided
            List<String> excludeIdList = new ArrayList<>();
            if (excludeIds != null && !excludeIds.isEmpty()) {
                excludeIdList = Arrays.asList(excludeIds.split(","));
            }
            
            // Start select element with CSS classes and onChange handler
            StringBuilder sb = new StringBuilder();
            sb.append("<select name=\"").append(name).append("\" id=\"").append(id != null ? id : name).append("\"");
            
            if (required) {
                sb.append(" required");
            }
            
            if (cssClass != null && !cssClass.isEmpty()) {
                sb.append(" class=\"").append(cssClass).append("\"");
            }
            
            if (onChange != null && !onChange.isEmpty()) {
                sb.append(" onchange=\"").append(onChange).append("\"");
            }
            
            sb.append(">");
            sb.append("<option value=\"\">Select Location</option>");
            
            // Add options from locations
            for (LocationBean location : locations) {
                // Skip if this location ID is in the exclude list
                if (excludeIdList.contains(String.valueOf(location.getLocationID()))) {
                    continue;
                }
                
                String selected = "";
                if (selectedValue != null && selectedValue.equals(String.valueOf(location.getLocationID()))) {
                    selected = " selected";
                }
                
                sb.append("<option value=\"").append(location.getLocationID()).append("\"")
                  .append(selected)
                  .append(" data-type=\"").append(location.getType()).append("\"")
                  .append(" data-city=\"").append(location.getCity()).append("\"")
                  .append(" data-country=\"").append(location.getCountry()).append("\"")
                  .append(" data-source=\"").append(location.isIsSource()).append("\"")
                  .append(">")
                  .append(location.getName()).append(" (").append(location.getCity()).append(", ").append(location.getCountry()).append(")")
                  .append("</option>");
            }
            
            // End select element
            sb.append("</select>");
            
            out.println(sb.toString());
        } catch (Exception ex) {
            out.println("Error generating location selector: " + ex.getMessage());
        }
    }
}