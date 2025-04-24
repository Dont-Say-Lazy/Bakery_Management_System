<%-- 
    Document   : updateStockForm
    Created on : Apr 23, 2025, 11:12:27 PM
    Author     : AlexS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="../header.jsp"%>
<%@page import="java.util.ArrayList"%>
<%@page import="ict.bean.FruitBean"%>
<%@page import="ict.bean.StockBean"%>
<%@page import="ict.db.StockDB"%>

<h1>Update Stock</h1>

<%
    String dbUrl = application.getInitParameter("dbUrl");
    String dbUser = application.getInitParameter("dbUser");
    String dbPassword = application.getInitParameter("dbPassword");

    int fruitID = 0;
    if (request.getParameter("fruitID") != null) {
        fruitID = Integer.parseInt(request.getParameter("fruitID"));
    }

    StockDB stockDB = new StockDB(dbUrl, dbUser, dbPassword);
    StockBean currentStock = null;

    if (fruitID > 0) {
        currentStock = stockDB.getStockByLocationAndFruit(user.getLocationID(), fruitID);
    }
%>

<form action="<%=request.getContextPath()%>/stock" method="post">
    <input type="hidden" name="action" value="update">

    <div class="form-group">
        <label for="fruitID">Fruit:</label>
        <select id="fruitID" name="fruitID" required <%= (fruitID > 0) ? "disabled" : ""%>>
            <option value="">Select Fruit</option>
            <%
                ArrayList<FruitBean> fruits = (ArrayList<FruitBean>) request.getAttribute("fruits");
                if (fruits != null) {
                    for (FruitBean fruit : fruits) {
            %>
            <option value="<%= fruit.getFruitID()%>" <%= (fruitID == fruit.getFruitID()) ? "selected" : ""%>><%= fruit.getName()%></option>
            <%
                    }
                }
            %>
        </select>
        <% if (fruitID > 0) {%>
        <input type="hidden" name="fruitID" value="<%= fruitID%>">
        <% }%>
    </div>

    <div class="form-group">
        <label for="quantity">Quantity:</label>
        <input type="number" id="quantity" name="quantity" min="0" value="<%= (currentStock != null) ? currentStock.getQuantity() : 0%>" required>
    </div>

    <div style="margin-top: 20px;">
        <button type="submit" class="btn">Update Stock</button>
        <a href="<%=request.getContextPath()%>/stock?action=view" class="btn" style="background-color: #ccc; color: #333;">Cancel</a>
    </div>
</form>

<%@include file="../footer.jsp"%>
