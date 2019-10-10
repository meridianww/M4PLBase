SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:                    Prashant Aggarwal         
-- Create date:               10/04/2019      
-- Description:               Get Column List For Order
-- Execution                  EXEC [dbo].[GetColumnListForOrder] 'SalesOrder'
-- =============================================
CREATE PROCEDURE [dbo].[GetColumnListForOrder] (@EntityName NVARCHAR(150))
AS
BEGIN
	SET NOCOUNT ON;
DECLARE @SelectQuery NVARCHAR(Max)

	IF OBJECT_ID('tempdb..#QueryTemp') IS NOT NULL
	BEGIN
		DROP TABLE #QueryTemp
	END

	CREATE TABLE #QueryTemp (ColumnName NVARCHAR(150))

	SET @SelectQuery = 'INSERT INTO #QueryTemp (ColumnName) Select CONCAT(TableName,''.'',M4PLColumn, '' ''  ,NavColumn) From dbo.NAV000OrderMapping Where ISNULL(M4PLColumn,'''') <> '''' AND ISNULL(SpecialHandling, 0) = 0 AND EntityName= ' + '''' + @EntityName + ''''
	SET @SelectQuery = @SelectQuery + ' INSERT INTO #QueryTemp (ColumnName) Select CONCAT(DefaultValue, '' ''  ,NavColumn) From dbo.NAV000OrderMapping Where ISNULL(DefaultValue,'''') <> '''' AND EntityName= ' + '''' + @EntityName + ''''
	SET @SelectQuery = @SelectQuery + ' INSERT INTO #QueryTemp (ColumnName) Select CONCAT(M4PLColumn, '' ''  ,NavColumn) From dbo.NAV000OrderMapping Where ISNULL(M4PLColumn,'''') <> '''' AND ISNULL(SpecialHandling, 0) = 1 AND EntityName= ' + '''' + @EntityName + ''''
	SET @SelectQuery = @SelectQuery + ' SELECT DISTINCT  
    STUFF((
        SELECT '','' + u.ColumnName
        FROM #QueryTemp u
        WHERE u.ColumnName = ColumnName
        ORDER BY u.ColumnName
        FOR XML path('''')
    ),1,1,'''') as Query
from #QueryTemp
group by ColumnName'

	EXEC (@SelectQuery)

	DROP TABLE #QueryTemp
END
GO

