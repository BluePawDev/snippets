/* INSERT INTO Syntax */
INSERT INTO table_name (column1, column2, column3, ...)
VALUES (value1, value2, value3, ...);

/* UPDATE Syntax */
UPDATE table_name
SET column1 = value1, column2 = value2, ...
WHERE condition;


/* DELETE Syntax */
DELETE FROM table_name
WHERE condition;


/* ORDER BY Syntax */
SELECT column1, column2, ...
FROM table_name
ORDER BY column1, column2, ... ASC|DESC;


/* IN Syntax */
SELECT column_name(s)
FROM table_name
WHERE column_name IN (value1, value2, ...);


/* BETWEEN  Syntax */
SELECT column_name(s)
FROM table_name
WHRE column_name BETWEEN value1 AND value2;


/* SELECT DISTINCT Syntax */
SELECT DISTINCT column1, column2, ...
FROM table_name;


/* SELECT TOP Clause */
SELECT TOP number|percent column_name(s)
FROM table_name
WHERE condition;


/* MIN() and MAX() Functions */
SELECT MIN|MAX(column_name)
FROM table_name
WHERE condition;


/* COUNT(), AVG(), and SUM() Functions */
SELECT COUNT|AVG|SUM(column_name)
FROM table_name
WHERE condition;
