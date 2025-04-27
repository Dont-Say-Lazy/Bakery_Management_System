-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- 主機： 127.0.0.1
-- 產生時間： 2025-04-26 17:36:52
-- 伺服器版本： 10.4.32-MariaDB
-- PHP 版本： 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- 資料庫： `4511_assignment`
--

-- --------------------------------------------------------

--
-- 資料表結構 `borrowings`
--

CREATE TABLE `borrowings` (
  `BorrowingID` int(11) NOT NULL,
  `SourceShopID` int(11) NOT NULL,
  `DestinationShopID` int(11) NOT NULL,
  `FruitID` int(11) NOT NULL,
  `Quantity` int(11) NOT NULL,
  `RequestDate` date NOT NULL,
  `Status` enum('pending','approved','delivered','rejected') NOT NULL DEFAULT 'pending',
  `UserID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- 傾印資料表的資料 `borrowings`
--

INSERT INTO `borrowings` (`BorrowingID`, `SourceShopID`, `DestinationShopID`, `FruitID`, `Quantity`, `RequestDate`, `Status`, `UserID`) VALUES
(1, 7, 8, 1, 10, '2025-04-21', 'pending', 9),
(2, 9, 10, 2, 12, '2025-04-20', 'approved', 11),
(3, 11, 12, 3, 15, '2025-04-19', 'rejected', 13),
(4, 8, 7, 4, 8, '2025-04-18', 'approved', 8),
(5, 10, 9, 5, 9, '2025-04-17', 'pending', 10),
(6, 12, 11, 6, 5, '2025-04-16', 'approved', 12);

-- --------------------------------------------------------

--
-- 資料表結構 `consumption`
--

CREATE TABLE `consumption` (
  `ConsumptionID` int(11) NOT NULL,
  `LocationID` int(11) NOT NULL,
  `FruitID` int(11) NOT NULL,
  `Quantity` int(11) NOT NULL,
  `Date` date NOT NULL,
  `Season` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- 傾印資料表的資料 `consumption`
--

INSERT INTO `consumption` (`ConsumptionID`, `LocationID`, `FruitID`, `Quantity`, `Date`, `Season`) VALUES
(1, 7, 1, 30, '2025-03-15', 'Spring'),
(2, 8, 4, 25, '2025-03-16', 'Spring'),
(3, 9, 2, 35, '2025-03-17', 'Spring'),
(4, 10, 5, 20, '2025-03-18', 'Spring'),
(5, 11, 3, 40, '2025-03-19', 'Spring'),
(6, 12, 6, 15, '2025-03-20', 'Spring'),
(7, 7, 1, 45, '2025-06-15', 'Summer'),
(8, 8, 4, 40, '2025-06-16', 'Summer'),
(9, 9, 2, 50, '2025-06-17', 'Summer'),
(10, 10, 5, 35, '2025-06-18', 'Summer'),
(11, 11, 3, 55, '2025-06-19', 'Summer'),
(12, 12, 6, 25, '2025-06-20', 'Summer'),
(13, 7, 1, 35, '2025-09-15', 'Fall'),
(14, 8, 4, 30, '2025-09-16', 'Fall'),
(15, 9, 2, 40, '2025-09-17', 'Fall'),
(16, 10, 5, 25, '2025-09-18', 'Fall'),
(17, 11, 3, 45, '2025-09-19', 'Fall'),
(18, 12, 6, 20, '2025-09-20', 'Fall'),
(19, 7, 1, 25, '2025-12-15', 'Winter'),
(20, 8, 4, 20, '2025-12-16', 'Winter'),
(21, 9, 2, 30, '2025-12-17', 'Winter'),
(22, 10, 5, 15, '2025-12-18', 'Winter'),
(23, 11, 3, 35, '2025-12-19', 'Winter'),
(24, 12, 6, 10, '2025-12-20', 'Winter');

-- --------------------------------------------------------

--
-- 資料表結構 `deliveries`
--

CREATE TABLE `deliveries` (
  `DeliveryID` int(11) NOT NULL,
  `SourceLocationID` int(11) NOT NULL,
  `DestinationLocationID` int(11) NOT NULL,
  `DeliveryDate` date NOT NULL,
  `Status` enum('pending','in_transit','delivered') NOT NULL DEFAULT 'pending',
  `Type` enum('reservation','borrowing') NOT NULL,
  `RequestID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- 傾印資料表的資料 `deliveries`
--

INSERT INTO `deliveries` (`DeliveryID`, `SourceLocationID`, `DestinationLocationID`, `DeliveryDate`, `Status`, `Type`, `RequestID`) VALUES
(1, 1, 4, '2025-04-25', 'pending', 'reservation', 1),
(2, 2, 5, '2025-04-26', 'in_transit', 'reservation', 2),
(3, 3, 6, '2025-04-27', 'delivered', 'reservation', 3),
(4, 7, 8, '2025-04-28', 'pending', 'borrowing', 1),
(5, 9, 10, '2025-04-29', 'in_transit', 'borrowing', 2),
(6, 11, 12, '2025-04-30', 'delivered', 'borrowing', 3);

-- --------------------------------------------------------

--
-- 資料表結構 `fruits`
--

CREATE TABLE `fruits` (
  `FruitID` int(11) NOT NULL,
  `Name` varchar(50) NOT NULL,
  `Description` text DEFAULT NULL,
  `SourceCountry` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- 傾印資料表的資料 `fruits`
--

INSERT INTO `fruits` (`FruitID`, `Name`, `Description`, `SourceCountry`) VALUES
(1, 'Apple', 'Red delicious apple', 'Japan'),
(2, 'Orange', 'Sweet orange', 'USA'),
(3, 'Mango', 'Yellow mango', 'Hong Kong'),
(4, 'Strawberry', 'Fresh strawberry', 'Japan'),
(5, 'Blueberry', 'Organic blueberry', 'USA'),
(6, 'Durian', 'King of fruits', 'Hong Kong'),
(7, 'Peach', 'Juicy peach', 'Japan'),
(8, 'Grape', 'Sweet green grape', 'USA'),
(9, 'Lychee', 'Tropical lychee', 'Hong Kong');

-- --------------------------------------------------------

--
-- 資料表結構 `locations`
--

CREATE TABLE `locations` (
  `LocationID` int(11) NOT NULL,
  `Name` varchar(100) NOT NULL,
  `City` varchar(50) NOT NULL,
  `Country` varchar(50) NOT NULL,
  `Type` enum('shop','warehouse','central_warehouse') NOT NULL,
  `IsSource` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- 傾印資料表的資料 `locations`
--

INSERT INTO `locations` (`LocationID`, `Name`, `City`, `Country`, `Type`, `IsSource`) VALUES
(1, 'Japan Warehouse', 'Tokyo', 'Japan', 'warehouse', 1),
(2, 'USA Warehouse', 'New York', 'USA', 'warehouse', 1),
(3, 'Hong Kong Warehouse', 'Hong Kong', 'Hong Kong', 'warehouse', 1),
(4, 'Tokyo Central', 'Tokyo', 'Japan', 'central_warehouse', 0),
(5, 'New York Central', 'New York', 'USA', 'central_warehouse', 0),
(6, 'Hong Kong Central', 'Hong Kong', 'Hong Kong', 'central_warehouse', 0),
(7, 'Tokyo Bakery 1', 'Tokyo', 'Japan', 'shop', 0),
(8, 'Tokyo Bakery 2', 'Tokyo', 'Japan', 'shop', 0),
(9, 'New York Bakery 1', 'New York', 'USA', 'shop', 0),
(10, 'New York Bakery 2', 'New York', 'USA', 'shop', 0),
(11, 'Hong Kong Bakery 1', 'Hong Kong', 'Hong Kong', 'shop', 0),
(12, 'Hong Kong Bakery 2', 'Hong Kong', 'Hong Kong', 'shop', 0);

-- --------------------------------------------------------

--
-- 資料表結構 `reservations`
--

CREATE TABLE `reservations` (
  `ReservationID` int(11) NOT NULL,
  `ShopLocationID` int(11) NOT NULL,
  `FruitID` int(11) NOT NULL,
  `Quantity` int(11) NOT NULL,
  `RequestDate` date NOT NULL,
  `DeliveryDate` date NOT NULL,
  `Status` enum('pending','approved','delivered','rejected') NOT NULL DEFAULT 'pending',
  `UserID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- 傾印資料表的資料 `reservations`
--

INSERT INTO `reservations` (`ReservationID`, `ShopLocationID`, `FruitID`, `Quantity`, `RequestDate`, `DeliveryDate`, `Status`, `UserID`) VALUES
(1, 7, 1, 20, '2025-04-20', '2025-04-25', 'pending', 8),
(2, 8, 4, 15, '2025-04-19', '2025-04-26', 'approved', 9),
(3, 9, 2, 25, '2025-04-18', '2025-04-27', 'delivered', 10),
(4, 10, 5, 18, '2025-04-17', '2025-04-28', 'pending', 11),
(5, 11, 3, 22, '2025-04-16', '2025-04-29', 'approved', 12),
(6, 12, 6, 10, '2025-04-15', '2025-04-30', 'rejected', 13);

-- --------------------------------------------------------

--
-- 資料表結構 `stock`
--

CREATE TABLE `stock` (
  `StockID` int(11) NOT NULL,
  `LocationID` int(11) NOT NULL,
  `FruitID` int(11) NOT NULL,
  `Quantity` int(11) NOT NULL DEFAULT 0,
  `LastUpdated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- 傾印資料表的資料 `stock`
--

INSERT INTO `stock` (`StockID`, `LocationID`, `FruitID`, `Quantity`, `LastUpdated`) VALUES
(1, 1, 1, 500, '2025-04-23 17:41:04'),
(2, 1, 4, 400, '2025-04-23 17:41:04'),
(3, 1, 7, 350, '2025-04-23 17:41:04'),
(4, 2, 2, 450, '2025-04-23 17:41:04'),
(5, 2, 5, 350, '2025-04-23 17:41:04'),
(6, 2, 8, 300, '2025-04-23 17:41:04'),
(7, 3, 3, 400, '2025-04-23 17:41:04'),
(8, 3, 6, 200, '2025-04-23 17:41:04'),
(9, 3, 9, 250, '2025-04-23 17:41:04'),
(10, 4, 1, 200, '2025-04-23 17:41:04'),
(11, 4, 4, 150, '2025-04-23 17:41:04'),
(12, 4, 7, 120, '2025-04-23 17:41:04'),
(13, 5, 2, 180, '2025-04-23 17:41:04'),
(14, 5, 5, 130, '2025-04-23 17:41:04'),
(15, 5, 8, 110, '2025-04-23 17:41:04'),
(16, 6, 3, 160, '2025-04-23 17:41:04'),
(17, 6, 6, 80, '2025-04-23 17:41:04'),
(18, 6, 9, 100, '2025-04-23 17:41:04'),
(19, 7, 1, 50, '2025-04-23 17:41:04'),
(20, 7, 4, 40, '2025-04-23 17:41:04'),
(21, 7, 7, 30, '2025-04-23 17:41:04'),
(22, 8, 1, 45, '2025-04-23 17:41:04'),
(23, 8, 4, 35, '2025-04-23 17:41:04'),
(24, 8, 7, 25, '2025-04-23 17:41:04'),
(25, 9, 2, 55, '2025-04-23 17:41:04'),
(26, 9, 5, 45, '2025-04-23 17:41:04'),
(27, 9, 8, 35, '2025-04-23 17:41:04'),
(28, 10, 2, 50, '2025-04-23 17:41:04'),
(29, 10, 5, 40, '2025-04-23 17:41:04'),
(30, 10, 8, 30, '2025-04-23 17:41:04'),
(31, 11, 3, 60, '2025-04-23 17:41:04'),
(32, 11, 6, 30, '2025-04-23 17:41:04'),
(33, 11, 9, 40, '2025-04-23 17:41:04'),
(34, 12, 3, 55, '2025-04-23 17:41:04'),
(35, 12, 6, 25, '2025-04-23 17:41:04'),
(36, 12, 9, 35, '2025-04-23 17:41:04');

-- --------------------------------------------------------

--
-- 資料表結構 `users`
--

CREATE TABLE `users` (
  `UserID` int(11) NOT NULL,
  `Username` varchar(50) NOT NULL,
  `Password` varchar(255) NOT NULL,
  `Role` enum('shop_staff','warehouse_staff','senior_management') NOT NULL,
  `Name` varchar(100) NOT NULL,
  `LocationID` int(11) DEFAULT NULL,
  `IsCentralStaff` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- 傾印資料表的資料 `users`
--

INSERT INTO `users` (`UserID`, `Username`, `Password`, `Role`, `Name`, `LocationID`, `IsCentralStaff`) VALUES
(1, 'admin', 'admin', 'senior_management', 'System Administrator', NULL, 0),
(2, 'jpwarehouse', 'pass123', 'warehouse_staff', 'Japan Warehouse Staff', 1, 0),
(3, 'uswarehouse', 'pass123', 'warehouse_staff', 'USA Warehouse Staff', 2, 0),
(4, 'hkwarehouse', 'pass123', 'warehouse_staff', 'Hong Kong Warehouse Staff', 3, 0),
(5, 'jpcentral', 'pass123', 'warehouse_staff', 'Tokyo Central Staff', 4, 1),
(6, 'uscentral', 'pass123', 'warehouse_staff', 'New York Central Staff', 5, 1),
(7, 'hkcentral', 'pass123', 'warehouse_staff', 'Hong Kong Central Staff', 6, 1),
(8, 'jpshop1', 'pass123', 'shop_staff', 'Tokyo Shop 1 Staff', 7, 0),
(9, 'jpshop2', 'pass123', 'shop_staff', 'Tokyo Shop 2 Staff', 8, 0),
(10, 'usshop1', 'pass123', 'shop_staff', 'New York Shop 1 Staff', 9, 0),
(11, 'usshop2', 'pass123', 'shop_staff', 'New York Shop 2 Staff', 10, 0),
(12, 'hkshop1', 'pass123', 'shop_staff', 'Hong Kong Shop 1 Staff', 11, 0),
(13, 'hkshop2', 'pass123', 'shop_staff', 'Hong Kong Shop 2 Staff', 12, 0),
(14, 'manager', 'manager', 'senior_management', 'Senior Manager', NULL, 0);

--
-- 已傾印資料表的索引
--

--
-- 資料表索引 `borrowings`
--
ALTER TABLE `borrowings`
  ADD PRIMARY KEY (`BorrowingID`),
  ADD KEY `SourceShopID` (`SourceShopID`),
  ADD KEY `DestinationShopID` (`DestinationShopID`),
  ADD KEY `FruitID` (`FruitID`),
  ADD KEY `UserID` (`UserID`);

--
-- 資料表索引 `consumption`
--
ALTER TABLE `consumption`
  ADD PRIMARY KEY (`ConsumptionID`),
  ADD KEY `LocationID` (`LocationID`),
  ADD KEY `FruitID` (`FruitID`);

--
-- 資料表索引 `deliveries`
--
ALTER TABLE `deliveries`
  ADD PRIMARY KEY (`DeliveryID`),
  ADD KEY `SourceLocationID` (`SourceLocationID`),
  ADD KEY `DestinationLocationID` (`DestinationLocationID`);

--
-- 資料表索引 `fruits`
--
ALTER TABLE `fruits`
  ADD PRIMARY KEY (`FruitID`);

--
-- 資料表索引 `locations`
--
ALTER TABLE `locations`
  ADD PRIMARY KEY (`LocationID`);

--
-- 資料表索引 `reservations`
--
ALTER TABLE `reservations`
  ADD PRIMARY KEY (`ReservationID`),
  ADD KEY `ShopLocationID` (`ShopLocationID`),
  ADD KEY `FruitID` (`FruitID`),
  ADD KEY `UserID` (`UserID`);

--
-- 資料表索引 `stock`
--
ALTER TABLE `stock`
  ADD PRIMARY KEY (`StockID`),
  ADD UNIQUE KEY `LocationID` (`LocationID`,`FruitID`),
  ADD KEY `FruitID` (`FruitID`);

--
-- 資料表索引 `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`UserID`),
  ADD UNIQUE KEY `Username` (`Username`),
  ADD KEY `FK_Users_Locations` (`LocationID`);

--
-- 在傾印的資料表使用自動遞增(AUTO_INCREMENT)
--

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `borrowings`
--
ALTER TABLE `borrowings`
  MODIFY `BorrowingID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `consumption`
--
ALTER TABLE `consumption`
  MODIFY `ConsumptionID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `deliveries`
--
ALTER TABLE `deliveries`
  MODIFY `DeliveryID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `fruits`
--
ALTER TABLE `fruits`
  MODIFY `FruitID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `locations`
--
ALTER TABLE `locations`
  MODIFY `LocationID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `reservations`
--
ALTER TABLE `reservations`
  MODIFY `ReservationID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `stock`
--
ALTER TABLE `stock`
  MODIFY `StockID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `users`
--
ALTER TABLE `users`
  MODIFY `UserID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- 已傾印資料表的限制式
--

--
-- 資料表的限制式 `borrowings`
--
ALTER TABLE `borrowings`
  ADD CONSTRAINT `borrowings_ibfk_1` FOREIGN KEY (`SourceShopID`) REFERENCES `locations` (`LocationID`),
  ADD CONSTRAINT `borrowings_ibfk_2` FOREIGN KEY (`DestinationShopID`) REFERENCES `locations` (`LocationID`),
  ADD CONSTRAINT `borrowings_ibfk_3` FOREIGN KEY (`FruitID`) REFERENCES `fruits` (`FruitID`),
  ADD CONSTRAINT `borrowings_ibfk_4` FOREIGN KEY (`UserID`) REFERENCES `users` (`UserID`);

--
-- 資料表的限制式 `consumption`
--
ALTER TABLE `consumption`
  ADD CONSTRAINT `consumption_ibfk_1` FOREIGN KEY (`LocationID`) REFERENCES `locations` (`LocationID`),
  ADD CONSTRAINT `consumption_ibfk_2` FOREIGN KEY (`FruitID`) REFERENCES `fruits` (`FruitID`);

--
-- 資料表的限制式 `deliveries`
--
ALTER TABLE `deliveries`
  ADD CONSTRAINT `deliveries_ibfk_1` FOREIGN KEY (`SourceLocationID`) REFERENCES `locations` (`LocationID`),
  ADD CONSTRAINT `deliveries_ibfk_2` FOREIGN KEY (`DestinationLocationID`) REFERENCES `locations` (`LocationID`);

--
-- 資料表的限制式 `reservations`
--
ALTER TABLE `reservations`
  ADD CONSTRAINT `reservations_ibfk_1` FOREIGN KEY (`ShopLocationID`) REFERENCES `locations` (`LocationID`),
  ADD CONSTRAINT `reservations_ibfk_2` FOREIGN KEY (`FruitID`) REFERENCES `fruits` (`FruitID`),
  ADD CONSTRAINT `reservations_ibfk_3` FOREIGN KEY (`UserID`) REFERENCES `users` (`UserID`);

--
-- 資料表的限制式 `stock`
--
ALTER TABLE `stock`
  ADD CONSTRAINT `stock_ibfk_1` FOREIGN KEY (`LocationID`) REFERENCES `locations` (`LocationID`),
  ADD CONSTRAINT `stock_ibfk_2` FOREIGN KEY (`FruitID`) REFERENCES `fruits` (`FruitID`);

--
-- 資料表的限制式 `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `FK_Users_Locations` FOREIGN KEY (`LocationID`) REFERENCES `locations` (`LocationID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
