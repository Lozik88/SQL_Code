USE AdventureWorks2012

SET NOCOUNT ON 
GO

CREATE TABLE dbo.RandomData ( 
    RowId INT IDENTITY(1,1) NOT NULL, 
    SomeInt INT,
    SomeBit BIT, 
    SomeVarchar VARCHAR(10), 
    SomeDateTime DATETIME, 
    SomeNumeric NUMERIC(16,2) ) 
GO

DECLARE @count INT 
SET @count = 1

WHILE @count <= 100000
BEGIN
INSERT INTO dbo.RandomData 
    SELECT    @count, 
            CASE WHEN DATEPART(MILLISECOND, GETDATE()) >= 500 THEN 0 ELSE 1 END [SomeBit], 
            CHAR((ABS(CHECKSUM(NEWID())) % 26) + 97) + CHAR((ABS(CHECKSUM(NEWID())) % 26) + 97) + 
            CHAR((ABS(CHECKSUM(NEWID())) % 26) + 97) + CHAR((ABS(CHECKSUM(NEWID())) % 26) + 97) + 
            CHAR((ABS(CHECKSUM(NEWID())) % 26) + 97) + CHAR((ABS(CHECKSUM(NEWID())) % 26) + 97) + 
            CHAR((ABS(CHECKSUM(NEWID())) % 26) + 97) + CHAR((ABS(CHECKSUM(NEWID())) % 26) + 97) + 
            CHAR((ABS(CHECKSUM(NEWID())) % 26) + 97) + CHAR((ABS(CHECKSUM(NEWID())) % 26) + 97) [SomeVarchar], 
            DATEADD(MILLISECOND, (ABS(CHECKSUM(NEWID())) % 6000) * -1, 
                DATEADD(MINUTE, (ABS(CHECKSUM(NEWID())) % 1000000) * -1, GETDATE())) [SomeDateTime], 
            (ABS(CHECKSUM(NEWID())) % 100001) + ((ABS(CHECKSUM(NEWID())) % 100001) * 0.00001) [SomeNumeric]
    SET @count += 1
END

SELECT COUNT(SomeDateTime),dateadd(minute,(datediff(minute,0,SomeDateTime)/15)*15,0) [15min] 
FROM RandomData 

GROUP BY dateadd(minute,(datediff(minute,0,SomeDateTime)/15)*15,0)
ORDER BY 2

select 
*
,dateadd(minute,(datediff(minute,0,SomeDateTime)/15)*15,0) [15min]
,dateadd(minute,(datediff(minute,0,SomeDateTime)/30)*30,0) [30min]
,dateadd(minute,(datediff(minute,0,SomeDateTime)/45)*45,0) [45min]
,dateadd(minute,(datediff(minute,0,SomeDateTime)/60)*60,0) [60min]

from RandomData order by SomeDateTime