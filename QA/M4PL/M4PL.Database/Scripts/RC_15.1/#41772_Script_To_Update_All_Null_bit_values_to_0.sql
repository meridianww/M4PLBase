 DECLARE @count INT = 1;

 select TABLE_NAME, COLUMN_NAME, ROW_Number() over(order by COLUMN_NAME) AS MyNumber INTO #DhaTemp1 from INFORMATION_SCHEMA.COLUMNS where DATA_TYPE='bit' and TABLE_SCHEMA = 'dbo' and IS_NULLABLE='YES';
 
 WHILE(@count <= (select count(1) from #DhaTemp1))
 BEGIN
	Declare @myTest NVARCHAR(150) = '', @tableName NVARCHAR(100) = '', @columnName NVARCHAR(100) = '';
	SELECT @tableName=TABLE_NAME, @columnName=COLUMN_NAME FROM #DhaTemp1 WHERE MyNumber=@count;
	SET @myTest = 'Update '+ @tableName + ' SET '+@columnName+ '=0 WHERE '+@columnName+' IS NULL';
	EXEC sp_executesql @myTest;
	SET @count = @count + 1;
 END
 
 drop table #DhaTemp1;



