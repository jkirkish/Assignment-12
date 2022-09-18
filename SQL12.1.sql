create database online_pizza_orders;

-- Create the database schema for a new pizza restaurant
CREATE TABLE `online_pizza_orders`.`menu`(
	`MenuID` INT NOT NULL,
    `Pizza` VARCHAR(100) NULL,
    `Price` DECIMAL(6,2) NULL,
    PRIMARY KEY (`MenuID`));
  
CREATE TABLE `online_pizza_orders`.`customers`(
	`CustomerID` INT NOT NULL,
    `FirstName` VARCHAR(45) NULL,
    `LastName`  VARCHAR(45) NULL,
    `Phone` VARCHAR(45) NULL,
    PRIMARY KEY (`CustomerID`));

CREATE TABLE `online_pizza_orders`.`transactions`(
	`TransactionID` INT NOT NULL,
    `Date` DATE NULL,
    `Time` time NULL,
    `Pizza` VARCHAR(45) NULL,
    `Total` DECIMAL(6,2) NULL,
    Primary Key (`TransactionID`)
);
select * From menu;
select * FROM customers;
select * FROM transactions;
    -- Relationships exist between tables ( 3 types ) 
     -- One-to-Many (relationship)
     -- Many-to--Many (relationship)
     -- One-to-One (relationship)
     
  -- a JOIN TABLE BETWEEN TRANSACTIONS AND MENU ITEMS --
  --  many menu items can belong in one or more transactions --
  -- many transactions can have one or many different menu items --

 CREATE TABLE `menu_transactions`(
        `MenuID` INT NOT NULL,
        `TransactionID` INT NOT NULL,
        FOREIGN KEY (MenuID) REFERENCES menu (MenuID),
        FOREIGN KEY (TransactionID) REFERENCES transactions (TransactionID)
  );
select * From `menu_transactions`;
-- Populate database with the three orders 
insert into menu (MenuID, Pizza, Price)
values (1,'Pepperoni & Cheese',7.99),
(2, 'Vegetarian',9.99 ),
(3, 'Meat Lovers', 14.99),
(4, 'Hawaiian', 12.99);

insert into customers(CustomerID, FirstName, LastName, Phone)
values (1, 'Trevor', 'Page', '226-555-4982'),
	   (2, 'John','Doe','555-555-9498');
       
insert into transactions (TransactionID, Date, Time, Pizza, Total)
values(1,'2014-09-10', '09:47:00','Pepperoni & Cheese, Meat Lovers,',22.98),-- pepperoni & cheese + Meat Lovers ($14.99 + $7.99) = $22.98
      (2, '2014-09-14', '13:20:00','Vegetarian and Meat Lovers(2)',34.97), -- (Vegetarian + Meat Lovers(2) ($14.99 + ($9.99(2))) = $34.97
      (3, '2014-09-10', '09:47:00','Meat Lovers and Hawaiian',27.98); -- (Vegetarian + Hawaiian($14.99 +$12.99 ) = $27.98

select * From menu;
select * From customers;
select * From transactions;

  -- the restaurant would like to know which customers are spending the most money at their establishment --
  -- One-to-Many relationship   --
  --  Customer                                Transaction --
  --  1Trevor Page       <->                  1 Order      --
  --  2John  Doe          <->                 2 Order, 3 ordertransactions --
alter table transactions
add column CustomerID int;

alter table transactions
add foreign key (CustomerID) references customers (CustomerID);

UPDATE `online_pizza_orders`.`transactions` SET `CustomerID` = '1' WHERE (`TransactionID` = '1');
UPDATE `online_pizza_orders`.`transactions` SET `CustomerID` = '2' WHERE (`TransactionID` = '2');
UPDATE `online_pizza_orders`.`transactions` SET `CustomerID` = '1' WHERE (`TransactionID` = '3');
select * From transactions;
-- Write a SQL query which will tell them how much money each individual customer has spent at their restaurant --
select CustomerID,sum(Total) FROM `transactions` 
group by CustomerID;

-- Modify the query from Q4 to separate the orders not just by customer, --
-- but also by date so they can see how much each customer is ordering on which date.--
-- For q5, you need to do a few adjustments. 1. 'DateTime' column includes time, however, 
-- the requirements say "separate the orders not just by customer, but also by date so they 
-- can see how much each customer is ordering on which date" therefor time should not be shown
-- here. For example, customer 1 orders June 1, 2022 1pm, and then on June 5 he ordered twice, 
-- at 9am and 4pm. Since Q5 asks for how much each customer is ordering on which date, the 
-- result here should be 2 rows for dates June 1 and June 2 which are for Customer 1. If you
-- have Customer 2 with orders on June 1, 2022 as well, it should appear as another row in your result.
select CustomerID,COUNT(transactionID),`Date`,sum(Total) as total FROM transactions 
group by CustomerID, `Date`; 
