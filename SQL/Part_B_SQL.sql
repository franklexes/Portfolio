---1b_i
SELECT
	c.CustomerName,
	c.CustomerID,
	s.Quantity,
	s.Total
FROM 
	product_sales s
JOIN
	customer c ON s.CustomerID = c.CustomerID
JOIN
	timeline t ON s.TimeID = t.TimeID
WHERE
	t.Date BETWEEN '2018-03-02' AND '2018-05-31';

---1b_ii
WITH CustAverageOrder(customerID, customerName, CustAvgOrd) AS (
    SELECT
		c.customerID, c.customerName, AVG(s.Total)
    FROM
		product_sales s
	JOIN
    	customer c ON s.CustomerID = c.CustomerID
    GROUP BY
		c.CustomerID
),
    AllAverageOrder (avgOrder) AS (
    SELECT avg(Total)
    FROM product_sales 
)
    SELECT 
		CustomerID, CustomerName, CustAvgOrd
    FROM
		CustAverageOrder, AllAverageOrder
    WHERE
		CustAverageOrder.CustAvgOrd > AllAverageOrder.avgOrder;


----1b_iii

----1b_iv
SELECT
    t.Year,
    t.Quartertext,
    SUM(s.Total) AS TotalSales
FROM
    product_sales s
JOIN
    Timeline t ON s.TimeID = t.TimeID
GROUP BY
    t.Year, t.Quartertext
ORDER BY
    t.Year, t.Quartertext;