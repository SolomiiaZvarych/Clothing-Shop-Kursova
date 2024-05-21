CREATE DATABASE clothing_shop;

USE clothing_shop;

CREATE TABLE IF NOT EXISTS `Customer` (
	`customer_id` int AUTO_INCREMENT NOT NULL UNIQUE,
	`first_name` varchar(30) NOT NULL,
	`last_name` varchar(30) NOT NULL,
	`birth_date` date NOT NULL,
	`gender` varchar(1) NOT NULL,
	`city` varchar(30) NOT NULL,
	`street` varchar(40) NOT NULL,
	`building` varchar(5),
	`phone_number` varchar(15) NOT NULL,
	`email` varchar(70) NOT NULL,
	`discount` int,
	PRIMARY KEY (`customer_id`)
);

CREATE TABLE IF NOT EXISTS `Customer_Order` (
	`customer_order_id` int AUTO_INCREMENT NOT NULL UNIQUE,
	`customer_transaction_report_id` int NOT NULL,
	`employee_id` int NOT NULL,
	`customer_id` int NOT NULL,
	`new_delivery_address` varchar(100),
	`product_id` int NOT NULL,
	`product_amount` int NOT NULL,
	`discount` int,
	`customer_order_datetime` datetime NOT NULL,
	`status` varchar(30) NOT NULL,
	PRIMARY KEY (`customer_order_id`)
);

CREATE TABLE IF NOT EXISTS `Customer_Transaction_Report` (
	`customer_transaction_report_id` int AUTO_INCREMENT NOT NULL UNIQUE,
	`payment_method` varchar(255) NOT NULL,
	`transaction_moment` datetime NOT NULL,
	`status` varchar(25) NOT NULL,
	PRIMARY KEY (`customer_transaction_report_id`)
);

CREATE TABLE IF NOT EXISTS `Product` (
	`product_id` int AUTO_INCREMENT NOT NULL UNIQUE,
	`product_name` varchar(70) NOT NULL,
	`product_description` varchar(255) NOT NULL,
	`category` varchar(30) NOT NULL,
	`manufacture` varchar(30) NOT NULL,
	`purchase_price` float NOT NULL,
	`sale_price` float NOT NULL,
	`supplier_id` int NOT NULL,
	`warehouse_id` int NOT NULL,
	`store_id` int NOT NULL,
	`storage_location_warehouse` varchar(255),
	`size` varchar(5) NOT NULL,
	`color` varchar(30) NOT NULL,
	PRIMARY KEY (`product_id`)
);

CREATE TABLE IF NOT EXISTS `Store` (
	`store_id` int AUTO_INCREMENT NOT NULL UNIQUE,
	`store_name` varchar(50) NOT NULL,
	`city` varchar(30) NOT NULL,
	`street` varchar(40),
	`buiding` varchar(5),
	PRIMARY KEY (`store_id`)
);

CREATE TABLE IF NOT EXISTS `Warehouse` (
	`warehouse_id` int AUTO_INCREMENT NOT NULL UNIQUE,
	`city` varchar(30) NOT NULL,
	`street` varchar(40),
	`building` varchar(5),
	`inventory_date` date NOT NULL,
	PRIMARY KEY (`warehouse_id`)
);

CREATE TABLE IF NOT EXISTS `Employee` (
	`employee_id` int AUTO_INCREMENT NOT NULL UNIQUE,
	`first_name` varchar(30) NOT NULL,
	`last_name` varchar(30) NOT NULL,
	`birth_date` date NOT NULL,
	`phone_number` varchar(15) NOT NULL,
	`email` varchar(70) NOT NULL,
	`position` varchar(255) NOT NULL,
	`manager_id` int,
	`employment_date` date NOT NULL,
	`store_id` int,
	`warehouse_id` int,
	`rate` float NOT NULL,
	`bonus` float,
	PRIMARY KEY (`employee_id`)
);

CREATE TABLE IF NOT EXISTS `Supplier` (
	`supplier_id` int AUTO_INCREMENT NOT NULL UNIQUE,
	`company_name` varchar(255) NOT NULL,
	`phone_number` varchar(15) NOT NULL,
	`email` varchar(70) NOT NULL,
	`physical_address` varchar(255),
	`contract_id` int NOT NULL,
	`contract_start_date` date NOT NULL,
	`contract_end_date` date NOT NULL,
	PRIMARY KEY (`supplier_id`)
);

CREATE TABLE IF NOT EXISTS `Supplier_Order` (
	`supplier_order_id` int AUTO_INCREMENT NOT NULL UNIQUE,
	`supplier_transaction_report_id` int NOT NULL,
	`supplier_id` int NOT NULL,
	`employee_id` int NOT NULL,
	`product_id` int,
	`size` varchar(255) NOT NULL,
	`color` varchar(255) NOT NULL,
	`product_amount` int NOT NULL,
	`purchase_price` float NOT NULL,
	`supplier_order_datetime` datetime NOT NULL,
	`status` int NOT NULL,
	PRIMARY KEY (`supplier_order_id`)
);

CREATE TABLE IF NOT EXISTS `Supplier_Transaction_Report` (
	`supplier_transaction_report_id` int AUTO_INCREMENT NOT NULL UNIQUE,
	`payment_method` varchar(255) NOT NULL,
	`transaction_moment` datetime NOT NULL,
	`status` varchar(25) NOT NULL,
	PRIMARY KEY (`supplier_transaction_report_id`)
);


ALTER TABLE `Customer_Order` ADD CONSTRAINT `Customer_Order_fk1` FOREIGN KEY (`customer_transaction_report_id`) REFERENCES `Customer_Transaction_Report`(`customer_transaction_report_id`);

ALTER TABLE `Customer_Order` ADD CONSTRAINT `Customer_Order_fk2` FOREIGN KEY (`employee_id`) REFERENCES `Employee`(`employee_id`);

ALTER TABLE `Customer_Order` ADD CONSTRAINT `Customer_Order_fk3` FOREIGN KEY (`customer_id`) REFERENCES `Customer`(`customer_id`);

ALTER TABLE `Customer_Order` ADD CONSTRAINT `Customer_Order_fk5` FOREIGN KEY (`product_id`) REFERENCES `Product`(`product_id`);

ALTER TABLE `Product` ADD CONSTRAINT `Product_fk7` FOREIGN KEY (`supplier_id`) REFERENCES `Supplier`(`supplier_id`);

ALTER TABLE `Product` ADD CONSTRAINT `Product_fk8` FOREIGN KEY (`warehouse_id`) REFERENCES `Warehouse`(`warehouse_id`);

ALTER TABLE `Product` ADD CONSTRAINT `Product_fk9` FOREIGN KEY (`store_id`) REFERENCES `Store`(`store_id`);


ALTER TABLE `Employee` ADD CONSTRAINT `Employee_fk7` FOREIGN KEY (`manager_id`) REFERENCES `Employee`(`employee_id`);

ALTER TABLE `Employee` ADD CONSTRAINT `Employee_fk9` FOREIGN KEY (`store_id`) REFERENCES `Store`(`store_id`);

ALTER TABLE `Employee` ADD CONSTRAINT `Employee_fk10` FOREIGN KEY (`warehouse_id`) REFERENCES `Warehouse`(`warehouse_id`);

ALTER TABLE `Supplier_Order` ADD CONSTRAINT `Supplier_Order_fk1` FOREIGN KEY (`supplier_transaction_report_id`) REFERENCES `Supplier_Transaction_Report`(`supplier_transaction_report_id`);

ALTER TABLE `Supplier_Order` ADD CONSTRAINT `Supplier_Order_fk2` FOREIGN KEY (`supplier_id`) REFERENCES `Supplier`(`supplier_id`);

ALTER TABLE `Supplier_Order` ADD CONSTRAINT `Supplier_Order_fk3` FOREIGN KEY (`employee_id`) REFERENCES `Employee`(`employee_id`);

ALTER TABLE `Supplier_Order` ADD CONSTRAINT `Supplier_Order_fk4` FOREIGN KEY (`product_id`) REFERENCES `Product`(`product_id`);
