# Bakery Management System

This project is a comprehensive Bakery Management System built as a Java web application. It is designed to manage inventory, logistics, and user roles across a network of bakeries, warehouses, and central warehouses. The system provides role-based access for senior management, warehouse staff, and shop staff, each with a dedicated dashboard and functionalities.

## Key Features

*   **Role-Based Access Control**: Secure access with three distinct user roles:
    *   **Senior Management**: Full oversight, user and product management, and access to system-wide reports.
    *   **Warehouse Staff**: Manages warehouse inventory, approves reservation requests, and arranges deliveries.
    *   **Shop Staff**: Manages local shop inventory, makes stock reservation requests, and initiates inter-shop borrowing.
*   **Inventory Management**: Track fruit stock levels across all locations (shops, regional warehouses, and central warehouses). Staff can perform check-in, check-out, and direct quantity updates.
*   **Fruit Reservation System**: Allows shop staff to reserve fruits from warehouses. Warehouse staff can then review, approve, or reject these requests.
*   **Inter-Shop Borrowing**: Enables shops to request and borrow fruits from other shops located within the same city, facilitating agile stock balancing.
*   **Delivery Logistics**: Warehouse staff can arrange direct deliveries and manage the fulfillment of approved reservations and borrowing requests.
*   **Reporting & Analytics**: Senior management can generate and view reports on fruit consumption patterns by season and location, as well as analyze reservation needs to forecast demand.

## Technology Stack

*   **Backend**: Java Servlets, JSP (JavaServer Pages)
*   **Frontend**: HTML, CSS, JavaScript, JSP
*   **Database**: MySQL / MariaDB
*   **Build Tool**: Apache Maven
*   **Server**: GlassFish

## Database Schema

The system relies on a relational database to manage its data. The core tables include:

| Table         | Description                                                                 |
|---------------|-----------------------------------------------------------------------------|
| `users`       | Stores user accounts, credentials, and role information.                    |
| `locations`   | Defines all physical locations, including shops, warehouses, and central warehouses. |
| `fruits`      | Contains details about the different types of fruits used in the bakery.     |
| `stock`       | Tracks the quantity of each fruit at every location.                        |
| `reservations`| Manages fruit reservation requests from shops to warehouses.                 |
| `borrowings`  | Manages fruit borrowing requests between shops.                             |
| `deliveries`  | Records and tracks all deliveries for reservations and borrowings.          |
| `consumption` | Stores historical data on fruit consumption for reporting purposes.         |

## Roles and Permissions

### Senior Management
*   Manages user accounts (add, edit, delete).
*   Manages fruit catalog (add, edit, delete).
*   Views stock levels across all locations.
*   Generates and views system-wide reports on consumption and reservations.

### Warehouse Staff
*   Manages stock levels for their assigned warehouse.
*   Approves or rejects reservation requests from shops.
*   Arranges and marks deliveries as complete.
*   Can initiate direct deliveries between locations.

### Shop Staff
*   Manages stock levels for their assigned shop.
*   Creates reservation requests for fruits from warehouses.
*   Initiates borrowing requests from other shops in the same city.
*   Approves incoming borrowing requests from other shops.
*   Marks received borrowed items.

## Setup and Installation

To set up and run the project locally, follow these steps:

1.  **Clone the Repository**
    ```sh
    git clone https://github.com/Dont-Say-Lazy/Bakery_Management_System.git
    cd Bakery_Management_System/Assignment
    ```

2.  **Database Setup**
    *   Ensure you have a MySQL or MariaDB server running.
    *   Create a new database named `4511_assignment`.
    *   Import the database schema and data using the provided SQL file: `4511_assignment.sql`.

3.  **Configure Database Connection**
    *   Open the `src/main/webapp/WEB-INF/web.xml` file.
    *   Update the `context-param` values for `dbUrl`, `dbUser`, and `dbPassword` to match your database configuration.
    ```xml
    <context-param>
        <param-name>dbUrl</param-name>
        <param-value>jdbc:mysql://localhost:3306/4511_assignment</param-value>
    </context-param>
    <context-param>
        <param-name>dbUser</param-name>
        <param-value>root</param-value>
    </context-param>
    <context-param>
        <param-name>dbPassword</param-name>
        <param-value>your_password</param-value>
    </context-param>
    ```

4.  **Build the Project**
    *   Use Apache Maven to build the project. This will generate a `.war` file in the `target/` directory.
    ```sh
    mvn clean install
    ```

5.  **Deploy the Application**
    *   Deploy the `target/Assignment-1.0-SNAPSHOT.war` file to a Java EE application server such as GlassFish or Apache Tomcat.

6.  **Access the Application**
    *   Open your web browser and navigate to the deployed application URL (e.g., `http://localhost:8080/Assignment-1.0-SNAPSHOT/`).
    *   Log in using one of the predefined user accounts from the SQL file (e.g., `admin`/`admin`, `manager`/`manager`, `jpshop1`/`pass123`).
