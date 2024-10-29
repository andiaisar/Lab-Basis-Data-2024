USE classicmodels

-- nomor 1
SELECT p.productCode, p.productName, p.buyPrice
FROM products p
WHERE buyprice > (
	SELECT AVG(buyprice) FROM products
);

-- nonor 2 
SELECT o.orderNumber, o.orderDate
FROM orders o 
JOIN customers c
USING (customerNumber)
WHERE c.salesRepEmployeeNumber IN (
	SELECT e.employeeNumber
	FROM employees e
	INNER JOIN offices OF
	USING (officeCode)
	WHERE OF.city LIKE 'Tokyo'
)

-- nomor 3
SELECT customerName,
   orderNumber,
   shippedDate,
   requiredDate,
   products,
   total_quantity_ordered,
   employeeName
FROM (
   SELECT c.customerName AS customerName,
   o.orderNumber AS orderNumber,
   o.shippedDate AS shippedDate,
   o.requiredDate AS requiredDate,
   GROUP_CONCAT(p.productName SEPARATOR ', ') AS products,
   SUM(od.quantityOrdered) AS total_quantity_ordered,
   CONCAT(e.firstName, ' ', e.lastName) AS employeeName
   FROM customers AS c
   JOIN orders AS o USING (customerNumber)
   JOIN orderdetails AS od USING (orderNumber)
   JOIN products AS p USING (productCode)
   JOIN employees AS e ON c.salesRepEmployeeNumber = e.employeeNumber
   GROUP BY c.customerName, o.orderNumber, o.shippedDate, o.requiredDate, e.firstName, e.lastName
) AS result
WHERE shippedDate > requiredDate;

-- nomor 4
SELECT p.productName, 
p.productLine, 
SUM(od.quantityOrdered) AS total_quantity_ordered
FROM products AS p
JOIN orderdetails AS od USING (productCode)
where p.productLine IN (SELECT productLine FROM (select productLine
   FROM products
   JOIN orderdetails od
   USING(productCode)
   GROUP BY productLine
   ORDER BY SUM(od.quantityOrdered) DESC
   LIMIT 3
) top3
)
GROUP BY p.productCode, p.productLine
ORDER BY p.productLine,total_quantity_ordered DESC;