SELECT COUNT(*) AS total_rows FROM sales;
SELECT SUM(revenue) AS total_revenue FROM sales;
SELECT SUM(quantity) AS total_quantity_sold FROM sales;
SELECT COUNT(distinct CustomerID) AS unique_customer FROM sales;
SELECT COUNT(distinct Country) AS total_countries FROM sales;
SELECT Country,SUM(Revenue) AS total_revenue FROM sales GROUP BY Country ORDER BY total_revenue DESC;
SELECT Description ,SUM(Revenue) AS total_revenue FROM sales GROUP BY Description ORDER BY total_revenue DESC LIMIT 10;
SELECT Description,SUM(Revenue) AS total_revenue FROM sales WHERE Description NOT IN ('DOTCOM POSTAGE', 'POSTAGE', 'Manual')
GROUP BY Description
ORDER BY total_revenue DESC
LIMIT 10;
SELECT Description,
SUM(Quantity) AS total_unit
FROM sales
GROUP BY Description
ORDER BY total_unit desc
LIMIT 10;
SELECT
    YEAR(InvoiceDate) AS year,
    MONTH(InvoiceDate) AS month,
    SUM(Revenue) AS total_revenue
FROM sales
GROUP BY YEAR(InvoiceDate), MONTH(InvoiceDate)
ORDER BY year, month;
SELECT Country,
round(
SUM(Revenue) / COUNT(distinct InvoiceNo),2) AS avg_order_value
FROM sales
WHERE InvoiceNo NOT LIKE '%C'
GROUP BY Country
ORDER BY avg_order_value DESC;
SELECT Country,
COUNT(distinct InvoiceNo) AS total_order
FROM sales 
WHERE InvoiceNo NOT LIKE '%C'
GROUP BY Country
ORDER BY total_order DESC;
SELECT CustomerID,
SUM(Revenue) AS total_revenue
FROM sales
WHERE CustomerID IS NOT NULL
GROUP BY CustomerID
ORDER BY total_revenue desc
LIMIT 10;
SELECT
    Description,
    SUM(Quantity) AS total_quantity,
    ROUND(SUM(Revenue), 2) AS total_revenue
FROM sales
WHERE Description NOT IN ('DOTCOM POSTAGE', 'POSTAGE', 'Manual')
  AND Description IS NOT NULL
GROUP BY Description
ORDER BY total_revenue DESC
LIMIT 10;
SELECT
    Description,
    SUM(Quantity) AS total_quantity,
    ROUND(SUM(Revenue), 2) AS total_revenue
FROM sales
WHERE Description NOT IN ('DOTCOM POSTAGE', 'POSTAGE', 'Manual')
  AND Description IS NOT NULL
GROUP BY Description
ORDER BY total_revenue DESC
LIMIT 10;
SELECT
    Description,
    SUM(Quantity) AS total_quantity
FROM sales
WHERE Description NOT IN ('DOTCOM POSTAGE', 'POSTAGE', 'Manual')
  AND Description IS NOT NULL
GROUP BY Description
ORDER BY total_quantity DESC
LIMIT 10;
SELECT
    Description,
    ROUND(AVG(UnitPrice), 2) AS average_unit_price
FROM sales
WHERE Description NOT IN ('DOTCOM POSTAGE', 'POSTAGE', 'Manual')
  AND Description IS NOT NULL
GROUP BY Description
ORDER BY average_unit_price DESC
LIMIT 10;
SELECT
    YEAR(InvoiceDate) AS year,
    MONTH(InvoiceDate) AS month,
    ROUND(SUM(Revenue), 2) AS total_revenue
FROM sales
GROUP BY YEAR(InvoiceDate), MONTH(InvoiceDate)
ORDER BY total_revenue DESC
LIMIT 1;
SELECT
    YEAR(InvoiceDate) AS year,
    MONTH(InvoiceDate) AS month,
    ROUND(SUM(Revenue), 2) AS total_revenue
FROM sales
GROUP BY YEAR(InvoiceDate), MONTH(InvoiceDate)
ORDER BY total_revenue ASC
LIMIT 1;
SELECT
    CustomerID,
    COUNT(DISTINCT InvoiceNo) AS total_orders
FROM sales
WHERE CustomerID IS NOT NULL
  AND InvoiceNo NOT LIKE 'C%'
GROUP BY CustomerID
ORDER BY total_orders DESC
LIMIT 10;
SELECT
    Country,
    ROUND(SUM(Revenue), 2) AS total_revenue
FROM sales
GROUP BY Country
ORDER BY total_revenue DESC
LIMIT 10;
WITH country_revenue AS (
    SELECT
        Country,
        SUM(Revenue) AS country_revenue
    FROM sales
    GROUP BY Country
)
SELECT
    Country,
    ROUND(
        country_revenue * 100.0 /
        (SELECT SUM(country_revenue) FROM country_revenue),
        2
    ) AS revenue_percentage
FROM country_revenue
WHERE Country = 'United Kingdom';
WITH Customers_order AS (
    SELECT
        CustomerID,
        COUNT(DISTINCT InvoiceNo) AS total_order
    FROM sales
    WHERE CustomerID IS NOT NULL
      AND InvoiceNo NOT LIKE 'C%'
    GROUP BY CustomerID
)
SELECT
    COUNT(*) AS repeat_customer
FROM Customers_order
WHERE total_order > 1;
WITH customer_orders AS (
    SELECT
        CustomerID,
        COUNT(DISTINCT InvoiceNo) AS total_orders
    FROM sales
    WHERE CustomerID IS NOT NULL
      AND InvoiceNo NOT LIKE 'C%'
    GROUP BY CustomerID
)
SELECT
    ROUND(
        SUM(CASE WHEN total_orders > 1 THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS repeat_customer_percentage
FROM customer_orders;
WITH customer_orders AS (
    SELECT
        CustomerID,
        COUNT(DISTINCT InvoiceNo) AS total_orders
    FROM sales
    WHERE CustomerID IS NOT NULL
      AND InvoiceNo NOT LIKE 'C%'
    GROUP BY CustomerID
)
SELECT
    ROUND(AVG(total_orders), 2) AS avg_orders_per_customer
FROM customer_orders;
WITH customer_orders AS (
    SELECT
        CustomerID,
        InvoiceNo,
        SUM(Revenue) AS order_value
    FROM sales
    WHERE CustomerID IS NOT NULL
      AND InvoiceNo NOT LIKE 'C%'
    GROUP BY CustomerID, InvoiceNo
)
SELECT
    CustomerID,
    ROUND(AVG(order_value), 2) AS avg_order_value
FROM customer_orders
GROUP BY CustomerID
ORDER BY avg_order_value DESC
LIMIT 10;
WITH customer_summary AS (
    SELECT
        CustomerID,
        COUNT(DISTINCT InvoiceNo) AS total_orders,
        SUM(Revenue) AS total_revenue
    FROM sales
    WHERE CustomerID IS NOT NULL
      AND InvoiceNo NOT LIKE 'C%'
    GROUP BY CustomerID
)
SELECT
    CustomerID,
    total_orders,
    ROUND(total_revenue, 2) AS total_revenue
FROM customer_summary
ORDER BY total_revenue DESC
LIMIT 10;
SELECT
    YEAR(InvoiceDate) AS year,
    MONTH(InvoiceDate) AS month,
    COUNT(DISTINCT InvoiceNo) AS total_orders
FROM sales
WHERE InvoiceNo NOT LIKE 'C%'
GROUP BY YEAR(InvoiceDate), MONTH(InvoiceDate)
ORDER BY total_orders DESC
LIMIT 1;
SELECT
    InvoiceNo,
    InvoiceDate
FROM sales
WHERE InvoiceNo NOT LIKE 'C%'
LIMIT 20;
WITH monthly_revenue AS (
    SELECT
        YEAR(InvoiceDate) AS year,
        MONTH(InvoiceDate) AS month,
        SUM(Revenue) AS total_revenue
    FROM sales
    WHERE InvoiceNo NOT LIKE 'C%'
    GROUP BY YEAR(InvoiceDate), MONTH(InvoiceDate)
),

monthly_with_previous AS (
    SELECT
        year,
        month,
        total_revenue,
        LAG(total_revenue) OVER (
            ORDER BY year, month
        ) AS previous_month_revenue
    FROM monthly_revenue
)

SELECT
    year,
    month,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(previous_month_revenue, 2) AS previous_month_revenue,
    ROUND(
        (total_revenue - previous_month_revenue)
        * 100.0 / previous_month_revenue,
        2
    ) AS mom_growth_percentage
FROM monthly_with_previous
ORDER BY year, month;
WITH Q AS (SELECT CustomerID,SUM(Revenue) AS total_revenue
FROM sales
WHERE CustomerID IS NOT NULL 
GROUP BY CustomerID)
SELECT CustomerID,
ROUND(total_revenue,2) AS total_revenue,
ROUND(total_revenue * 100 /SUM(total_revenue) OVER(),2) AS revenue_percenntage
FROM Q
ORDER BY total_revenue DESC
LIMIT 10;
WITH Q AS (SELECT CustomerID,SUM(Revenue) AS total_revenue
FROM sales 
WHERE CustomerID IS NOT NULL
AND InvoiceNo NOT LIKE '%C'
GROUP BY CustomerID
ORDER BY total_revenue DESC)
SELECT CustomerID,ROUND(total_revenue,2 ) AS total_revenue,
ROUND(total_revenue * 100.0 /SUM(total_revenue) OVER() ,2) AS top_10_revenue_percentage
FROM Q
ORDER BY total_revenue DESC
LIMIT 10;
WITH Q AS (
    SELECT
        CustomerID,
        SUM(Revenue) AS total_revenue
    FROM sales
    WHERE CustomerID IS NOT NULL
      AND InvoiceNo NOT LIKE 'C%'
    GROUP BY CustomerID
),
W AS (
    SELECT
        CustomerID,
        total_revenue,
        NTILE(5) OVER (
            ORDER BY total_revenue DESC
        ) AS customer_group
    FROM Q
)
SELECT
    ROUND(
        SUM(
            CASE
                WHEN customer_group = 1 THEN total_revenue
                ELSE 0
            END
        ) * 100.0 / SUM(total_revenue),
        2
    ) AS top_20_revenue_percentage
FROM W;
WITH Q AS(SELECT Description,SUM(Revenue) AS total_revenue,
SUM(Quantity) AS total_quantity
FROM sales
WHERE Description IS NOT NULL
AND Description NOT IN ('DOTCOM POSTAGE', 'POSTAGE', 'Manual')
AND InvoiceNo NOT LIKE 'C%'
GROUP BY Description),
W AS (SELECT Description,total_revenue,total_quantity
,NTILE(5) OVER(ORDER BY total_revenue DESC) AS revenue_group,
NTILE(5) OVER(ORDER BY total_quantity ASC) AS quantity_group 
FROM Q)
SELECT Description,
ROUND(total_revenue,2) AS total_revenue,
total_quantity
FROM W
WHERE revenue_group = 1
AND quantity_group = 1
ORDER BY total_revenue DESC;
WITH Q AS(SELECT Description,SUM(Revenue) AS total_revenue,
SUM(Quantity) AS total_quantity
FROM sales
WHERE Description IS NOT NULL
AND Description NOT IN (
    'DOTCOM POSTAGE',
    'POSTAGE',
    'Manual',
    'AMAZON FEE',
    '?',
    'came coded as 20713',
    'Found'
)
AND InvoiceNo NOT LIKE 'C%'
GROUP BY Description),
W AS (SELECT Description,total_revenue,total_quantity
,NTILE(5) OVER(ORDER BY total_revenue asc) AS revenue_group,
NTILE(5) OVER(ORDER BY total_quantity desc) AS quantity_group 
FROM Q)
SELECT Description,
ROUND(total_revenue,2) AS total_revenue,
total_quantity
FROM W
WHERE revenue_group = 1
AND quantity_group = 1
;



