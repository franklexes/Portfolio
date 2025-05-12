---Delet this part
select DATE_PART('day', '2014-01-01'::timestamp -  '2014-02-01'::timestamp) AS DATEPART
SELECT * FROM CustomerDim

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
where table_name = 'product_sales'
 
----1a.	Sketch a representative Star schema for the data warehouse
----	(specifying the relations, the attributes, the primary keys, and the foreign keys). 
create table ProdDim as select * from product;
create table CustomerDim as select * from customer;
create table TimelineDim as select t.timeid, t.date, t.monthtext as month_text, t.quartertext as quarter_text, t.year
from timeline t;
create table SalesFact as select * from product_sales;

----b.	Suppose that we want to examine the data of HSD_DW,
----	write SQL queries to answer the following questions: (20 points)
---1b_i.	Which customer(s) made an order in the past 90 days from May 31, 2018?
--------	Provide the CustomerName and CustomerID, Quantity and Total amounts of the orders. 
SELECT
	c.CustomerName,
	c.CustomerID,
	s.Quantity,
	s.Total
FROM 
	SalesFact s
JOIN
	CustomerDim c ON s.CustomerID = c.CustomerID
JOIN
	TimelineDim t ON s.TimeID = t.TimeID
WHERE
	t.Date BETWEEN '2018-03-02' AND '2018-05-31';

---1b_ii.	Which customer had an average order greater than the average order of all customers?
WITH CustAverageOrder(customerID, customerName, CustAvgOrder) AS (
    SELECT
		c.customerID, c.customerName, AVG(s.Total)
    FROM
		SalesFact s
	JOIN
    	CustomerDim c ON s.CustomerID = c.CustomerID
    GROUP BY
		c.customerName, c.customerID
),
    AllAverageOrder (avgOrder) AS (
    SELECT avg(Total)
    FROM SalesFact 
)
    SELECT 
		customerID, CustomerName, CustAvgOrder
    FROM
		CustAverageOrder, AllAverageOrder
    WHERE
		CustAverageOrder.CustAvgOrder > AllAverageOrder.avgOrder;


----1b_iii.	For each customer, determine the time between the sale of products as Days_between_Product_Sales.
----	Display the Customer ID, Customer Name, Product Number, Product Name, Date, End Date, Days_between_Product_Sales.
----	Consider using the lag function and order the result by the CustomerID
WITH ProductSales AS (
    SELECT
        s.CustomerID,
        c.CustomerName,
        s.ProductNumber,
        p.ProductName,
        t.Date,
        LAG(t.Date) OVER (PARTITION BY s.CustomerID ORDER BY t.Date) AS EndDate
    FROM
        SalesFact s
    JOIN
        CustomerDim c ON s.CustomerID = c.CustomerID
    JOIN
        ProductDim p ON s.ProductNumber = p.ProductNumber
    JOIN
        TimelineDim t ON s.TimeID = t.TimeID
)
SELECT
    CustomerID,
    CustomerName,
    ProductNumber,
    ProductName,
    Date,
    EndDate,
    Date-EndDate AS Days_between_Product_Sales ---DATEDIFF(Date, EndDate) AS Days_between_Product_Sales
FROM
    ProductSales
ORDER BY
    CustomerID, Date;


----1b_iv.	Write SQL query for the” Roll-Up” operation to summarise the total sales per quarter.
SELECT
    t.Year, t.quarter_text, SUM(s.Total) AS TotalSales
FROM
    SalesFact s
JOIN
    TimelineDim t ON s.TimeID = t.TimeID
GROUP BY
    t.Year, t.quarter_text
ORDER BY
    t.Year, t.quarter_text;