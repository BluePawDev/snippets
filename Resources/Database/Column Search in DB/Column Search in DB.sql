DECLARE @ColumnName VARCHAR(50)

SET @ColumnName = 'TerritoryID'

-- Search in All Objects(strored procs, triggers, functions, and views)
SELECT OBJECT_NAME(OBJECT_ID),
definition
FROM sys.sql_modules
WHERE definition LIKE '%' + @ColumnName + '%'

-- Search tables
SELECT      c.name  AS 'ColumnName'
            ,t.name AS 'TableName'
FROM        sys.columns c
JOIN        sys.tables  t   ON c.object_id = t.object_id
WHERE       c.name LIKE '%' + @ColumnName + '%'
ORDER BY    TableName
            ,ColumnName;

-- Search in Stored Procedure Only
SELECT DISTINCT OBJECT_NAME(OBJECT_ID),
object_definition(OBJECT_ID)
FROM sys.Procedures
WHERE object_definition(OBJECT_ID) LIKE '%' + @ColumnName + '%'
GO