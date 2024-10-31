USE classicmodels
-- nomor 1
(
SELECT p.productName, SUM(od.priceEach * od.quantityOrdered) TotalRevenue, 'Pendapatan Tertinggi' pendapatan
FROM products p
JOIN orderdetails od
USING(productCode)
JOIN orders o
USING(orderNumber)
WHERE MONTH(o.orderDate) = 9
GROUP BY p.productCode
ORDER BY TotalRevenue DESC
LIMIT 5
)

UNION 

(
SELECT p.productName, SUM(od.priceEach * od.quantityOrdered) TotalRevenue, 'Pendapatan Terrendah (kayak kmu)' pendapatan
FROM products p
JOIN orderdetails od
USING(productCode)
JOIN orders o
USING(orderNumber)
WHERE MONTH(o.orderDate) = 9
GROUP BY p.productCode
ORDER BY TotalRevenue 
LIMIT 5
)
ORDER BY TotalRevenue desc
;

-- nomor 2    
SELECT productName FROM products

EXCEPT 

(SELECT productName FROM products
JOIN orderdetails USING (productCode)
JOIN orders USING (orderNumber)
JOIN customers c USING (customerNumber)
WHERE c.customerNumber IN (
	SELECT customerNumber FROM customers
	JOIN orders USING (customerNumber)
	JOIN orderdetails USING (orderNumber)
	JOIN products USING (productCode)
	WHERE buyPrice > (SELECT AVG(buyPrice) FROM products)
	GROUP BY customerNumber
	having COUNT(distinct orderNumber) > 10));


-- nomor 3
SELECT customerName FROM customers AS c
JOIN payments AS py
USING (customerNumber)
GROUP BY customerNumber
HAVING SUM(py.amount) > (
   SELECT AVG(amount) * 2 FROM (
      SELECT SUM(amount) AS `amount` FROM payments
      GROUP BY customerNumber
   ) AS tabel
)
INTERSECT

SELECT customerName FROM customers AS c
JOIN orders AS o
USING (customerNumber)
JOIN orderdetails AS od
USING (orderNumber)
JOIN products AS p
USING (productCode)
WHERE p.productLine IN ("Planes", "Trains")
GROUP BY customerNumber
HAVING SUM(od.priceEach * od.quantityOrdered) > 20000;


-- nomor 4
SELECT Tanggal, customerNumber , GROUP_CONCAT( DISTINCT Riwayat SEPARATOR " Dan ") Riwayat
FROM ( SELECT o.orderDate Tanggal, c.customerNumber, "Memesan Barang" Riwayat
		FROM orders o
		JOIN customers c
		USING(customerNumber)
		WHERE o.orderDate LIKE ("2003-09-%")
        UNION
		SELECT p.paymentDate Tanggal, c.customerNumber, "Membayar Pesanan" Riwayat
		FROM payments p
		JOIN customers c
		USING(customerNumber)
		WHERE p.paymentDate LIKE ("2003-09-%")
        ORDER BY customerNumber) s
GROUP BY Tanggal;

-- nomor 5
select p.productCode
	from products p
	join orderdetails od
	using(productCode)
	join orders o
	using(orderNumber)
	join customers c
	using(customerNumber)
where od.quantityOrdered > 48
and left(productVendor, 1) in ("A", "I", "U", "E", "O")
and od.priceEach > (select avg(od.priceEach) 
						from products p
						join orderdetails od
						using(productCode)
						join orders o
						using(orderNumber)
						where orderDate between "2001-01-01" and "2004-03-31")
group by p.productCode
except
select p.productCode
	from products p
	join orderdetails od
	using(productCode)
	join orders o
	using(orderNumber)
	join customers c
	using(customerNumber)
where c.country in ("Italy", "Japan", "Germany");





