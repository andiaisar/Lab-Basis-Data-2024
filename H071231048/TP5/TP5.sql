USE classicmodels
-- nomor 1
SELECT DISTINCT c.customerName `namaKustomer`,
p.productName `namaProduk`,
p.productDescription `textDescription`
FROM customers AS c
JOIN orders AS o
USING (customerNumber)
JOIN orderdetails AS od
USING (orderNumber)
JOIN products AS p
USING (productCode)
WHERE p.productName LIKE "%Titanic%"
ORDER BY namaKustomer;

-- nomor 2
SELECT c.customerName,
p.productName,
o.status,
o.shippedDate
FROM customers AS c
JOIN orders AS o
USING (customerNumber)
JOIN orderdetails AS od
USING (orderNumber)
JOIN products AS p
USING (productCode)
WHERE (p.productName LIKE "%Ferrari%") AND (o.status = "Shipped") 
AND (o.shippedDate >= '2003-10-01' AND o.shippedDate <= '2004-10-01')
ORDER BY o.shippedDate DESC;

-- nomor 3
SELECT e.firstName AS "Supervisor",
e1.firstName AS "Karyawan"
FROM employees AS e
JOIN employees AS e1
ON e.employeeNumber = e1.reportsTo
WHERE e.firstName LIKE "Gerard"
ORDER BY e1.firstName;

-- nomor 4a
SELECT c.customerName, p.paymentDate, e.firstName, p.amount
FROM customers AS c
JOIN payments AS p
USING (customerNumber)
JOIN employees AS e
ON c.salesRepEmployeeNumber = e.employeeNumber
WHERE p.paymentDate LIKE "%-11-%";

-- nomor 4b
SELECT c.customerName, p.paymentDate, e.firstName, p.amount
FROM customers AS c
JOIN payments AS p
USING (customerNumber)
JOIN employees AS e
ON c.salesRepEmployeeNumber = e.employeeNumber
WHERE p.paymentDate LIKE "%-11-%"
ORDER BY p.amount DESC
LIMIT 1;

-- nomor 4c
SELECT c.customerName, p.productName
FROM customers AS c
JOIN orders AS o
JOIN payments AS pa
USING (customerNumber)
USING (customerNumber)
JOIN orderdetails AS od 
USING (orderNumber)
JOIN products AS p
USING (productCode)
WHERE (c.customerName = "Corporate Gift Ideas Co.") AND (pa.paymentDate LIKE "%-11-%");



SELECT c.customerName, o.country
FROM customers AS c
JOIN employees AS e
ON c.salesRepEmployeeNumber = e.employeeNumber
JOIN offices AS o	
ON e.officeCode = o.officeCode
