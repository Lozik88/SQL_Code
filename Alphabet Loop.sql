DECLARE @I AS INT = 0;
DECLARE @ALPH AS VARCHAR(5)
DECLARE @C AS INT = 0;
DECLARE @CAP AS INT= 0;
DECLARE @CODE AS NVARCHAR(MAX);

IF object_id('tempdb..#table_a', 'U') IS NOT NULL
	DROP TABLE #table_a
IF object_id('tempdb..#table_b', 'U') IS NOT NULL
	DROP TABLE #table_b
CREATE TABLE #TABLE_A(id varchar(5), seq_no int)
CREATE TABLE #TABLE_B(id varchar(5), seq_no int)

WHILE @I<26
	BEGIN
	SET @ALPH = CHAR(ASCII('a') + @I)
	SET @I=@I+1
	SET @CAP = floor(rand()*101)
	SET @C = 1
	--SELECT @C
	WHILE @C <= @CAP
		BEGIN
		SET @CODE = N'INSERT INTO #TABLE_A VALUES('''+@ALPH+''','+CAST(@C AS VARCHAR(10))+');'
		EXEC sp_executesql @CODE
		SET @C = @C+1
		END
	END

--SET @CODE = 'INSERT INTO #table_a VALUES'+substring(@code,0,len(@CODE)-1)
SELECT * FROM #TABLE_A
