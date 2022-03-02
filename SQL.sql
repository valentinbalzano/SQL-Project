--OBJECTIFS
--Sales: The number of products sold by category and by month, with comparison and rate of change compared to the same month of the previous year.
--Finances: 1.The turnover of the orders of the last two months by country. 2.Orders that have not yet been paid.
--Logistics: The stock of the 5 most ordered products.
--Human Resources: Each month, the 2 sellers with the highest turnover.



-- Logistic - Affiche le stock des 5 répliques les plus vendues
-- FINAL VERSION / WORKING AS INTENDED

SELECT productname, sum(quantityOrdered) total_ordered, quantityInStock
FROM orderdetails
INNER JOIN products
ON products.productcode = orderdetails.productcode
GROUP BY productname
ORDER BY total_ordered desc
LIMIT 5;

-- HUMAN RESSOURCES - Top two sellers with the highest turnover from last month
-- FINAL VERSION / WORKING AS INTENDED

SELECT CONCAT(lastname,' ', firstname) seller, SUM(quantityordered * priceeach) total_amount, MONTHNAME(STR_TO_DATE(MONTH(orderdate),'%m')) month
FROM customers
inner JOIN orders
ON customers.customerNumber = orders.customerNumber
inner JOIN employees
ON customers.salesRepEmployeeNumber = employees.employeeNumber
inner join orderdetails
on orderdetails.ordernumber = orders.ordernumber
WHERE MONTH(OrderDate) = MONTH(CURRENT_DATE)-2 AND YEAR(OrderDate) = YEAR(CURRENT_DATE)
GROUP BY seller	
ORDER BY total_amount DESC;


-- FINANCES -- Turnover 
-- FINAL VERSION / WORKING AS INTENDED
-- Change INTERVAL to -3 for testing purposes

SELECT SUM(quantityordered * priceeach) total_price, orderdate, customers.country
from orders
INNER JOIN orderdetails
ON orders.orderNumber = orderdetails.orderNumber
INNER JOIN customers
ON orders.customernumber = customers.customernumber
WHERE MONTH(OrderDate) = MONTH(CURRENT_DATE)
GROUP BY customers.country
ORDER BY orderdate DESC
UNION
SELECT SUM(quantityordered * priceeach) total_price, orderdate, customers.country
from orders
INNER JOIN orderdetails
ON orders.orderNumber = orderdetails.orderNumber
INNER JOIN customers
ON orders.customernumber = customers.customernumber
WHERE MONTH(OrderDate) = MONTH(CURRENT_DATE)-1
GROUP BY customers.country
ORDER BY orderdate DESC;

-- PREVIOUS FOR FINANCES

SELECT SUM(quantityordered * priceeach) total_price, orderdate, customers.country
from orders
INNER JOIN orderdetails
ON orders.orderNumber = orderdetails.orderNumber
INNER JOIN customers
ON orders.customernumber = customers.customernumber
WHERE MONTH(OrderDate) = MONTH(CURRENT_DATE)-2 AND YEAR(OrderDate) = YEAR(CURRENT_DATE)
GROUP BY customers.country
ORDER BY orderdate DESC;

-- Ventes -- Le nombre de produits vendus par catégorie et par mois, avec comparaison et taux de variation par rapport au même mois de l'année précédente.
-- FINAL VERSION / WORKING AS INTENDED

SELECT productLine, quantityOrdered, orderDate
FROM orderdetails
INNER JOIN products
ON products.productcode = orderdetails.productcode
INNER JOIN orders
ON orders.orderNumber = orderdetails.orderNumber
WHERE YEAR(OrderDate) = YEAR(CURRENT_DATE)
UNION
SELECT productLine, quantityOrdered, orderDate
FROM orderdetails
INNER JOIN products
ON products.productcode = orderdetails.productcode
INNER JOIN orders
ON orders.orderNumber = orderdetails.orderNumber
WHERE YEAR(OrderDate) = YEAR(CURRENT_DATE)-1;



-- AVERAGE SALES FOR TOP BEST SALERS FOR THE LAST MONTH

SELECT ROUND(AVG(amount), 2) avg_amount, MONTHNAME(STR_TO_DATE(MONTH(OrderDate),'%m')) `month`
FROM customers
inner JOIN orders
ON customers.customerNumber = orders.customerNumber
inner JOIN payments
ON customers.customerNumber = payments.customerNumber
WHERE MONTH(OrderDate) = MONTH(CURRENT_DATE)-1 AND YEAR(OrderDate) = YEAR(CURRENT_DATE);


-- ================ WIP ================


-- NUMBER OF SALERS IN AUGUST
-- bugued

SELECT DISTINCT COUNT(CONCAT(`lastname`,' ', `firstname`)) `total_seller`, SUM(amount) avg_amount, MONTHNAME(STR_TO_DATE(MONTH(OrderDate),'%m')) `month`
FROM customers
inner JOIN payments
ON customers.customerNumber = payments.customerNumber
inner JOIN employees
ON customers.salesRepEmployeeNumber = employees.employeeNumber
WHERE MONTH(OrderDate) = MONTH(CURRENT_DATE)-1 AND YEAR(OrderDate) = YEAR(CURRENT_DATE)
