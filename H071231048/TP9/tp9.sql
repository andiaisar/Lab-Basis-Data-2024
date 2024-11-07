create database sepakbola;

use sepakbola;

create table klub (
    id int PRIMARY KEY AUTO_INCREMENT,
    nama_klub VARCHAR(50) not null,
    kota_asal VARCHAR(50) not null
);

create table pemain (
    id_pemain int PRIMARY KEY AUTO_INCREMENT,
    nama_pemain VARCHAR(50) not null,
    posisi VARCHAR(50) not null,
    id_klub int,
    FOREIGN KEY (id_klub) REFERENCES klub (id)
);

create table pertandingan (
    id_pertandingan int PRIMARY KEY AUTO_INCREMENT,
    id_klub_tuan_rumah int,
    id_klub_tamu int,
    tanggal_pertandingan DATE not null,
    skor_tuan_rumah int DEFAULT 0,
    skor_tamu int DEFAULT 0,
    FOREIGN KEY (id_klub_tuan_rumah) REFERENCES klub (id),
    FOREIGN KEY (id_klub_tamu) REFERENCES klub (id)
);

CREATE INDEX idx_posisi ON pemain (posisi);

CREATE INDEX idx_kota_asal ON klub (kota_asal);

select * from klub;

-- nomor 2
use classicmodels;

SELECT
    c.customerName,
    c.country,
    ROUND(SUM(p.amount), 2) AS totalPayment,
    COUNT(o.orderNumber) AS orderCount,
    MAX(o.orderDate) AS lastPaymentDate,
    CASE
        when SUM(p.amount) > 100000 THEN 'VIP'
        when SUM(p.amount) BETWEEN 5000 AND 10000  THEN 'LOYAL'
        ELSE 'NEW'
    END AS status
FROM
    customers c
    LEFT JOIN orders o ON c.customerNumber = o.customerNumber
    LEFT JOIN payments p ON c.customerNumber = p.customerNumber
GROUP BY
    c.customerNumber,
    c.customerName,
    c.country
ORDER BY customerName;

-- nomor 3
SELECT
    c.customerNumber,
    c.customerName,
    SUM(od.quantityOrdered) AS total_quantity,
    CASE
        WHEN SUM(od.quantityOrdered) > (
            SELECT AVG(total_quantity)
            FROM (
                    SELECT SUM(quantityOrdered) AS total_quantity
                    FROM orderdetails
                        join orders using (orderNumber)
                    GROUP BY
                        customerNumber
                ) AS subquery
        ) THEN 'di atas rata-rata'
        ELSE 'di bawah rata-rata'
    END AS kategori_pembelian
FROM
    customers AS c
    JOIN orders AS o USING (customerNumber)
    JOIN orderdetails AS od USING (orderNumber)
GROUP BY
    c.customerNumber
ORDER BY total_quantity DESC;

START TRANSACTION;

INSERT INTO
    klub (nama_klub, kota_asal)
VALUES ('persib', 'bandung'),
    ('psm', 'makassar')
SET
    autocommit = 1
SELECT @@autocommit

COMMIT;

ROLLBACK;

SELECT * FROM klub

SELECT * FROM customer