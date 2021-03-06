SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ResetJobsItemNumberSQL] (@Id BIGINT,@tableName NVARCHAR(100),@pKFieldName NVARCHAR(100),@itemFieldName NVARCHAR(100),@parentKeyName NVARCHAR(100),@entity NVARCHAR(100),@userId BIGINT,@Where NVARCHAR(MAX),@joins NVARCHAR(MAX))
RETURNS VARCHAR(MAX)
AS BEGIN
  DECLARE @sqlCommand NVARCHAR(MAX)

 
  SET @sqlCommand = ';WITH CTE AS
				(
				SELECT '+  @entity + '.'+ @pKFieldName +',
				ROW_NUMBER() OVER (ORDER BY '+ @entity + '.'+ @itemFieldName +' ASC) AS RN
				FROM '+ @tableName + ' '+ @entity 
				if(@entity <>'JobGateway')
				BEGIN
				SET @sqlCommand +=	' INNER JOIN  [dbo].[fnGetUserStatuses]( CAST('+ CAST( @userId AS  VARCHAR ) +' AS BIGINT)) fgus ON ISNULL('+  @entity + '.StatusId,1)  = fgus.StatusId'
				 END
			    SET @sqlCommand+=  ' '+ @joins + ' WHERE 1=1  AND '+@entity+'.StatusId IN (1,2) ' + @where + ' AND ' + @entity + '.'+ @pKFieldName + ' <> CAST('+ CAST( @id AS  VARCHAR ) +' AS BIGINT))
				UPDATE '+ @entity + '
				SET ' + @entity + '.' + @itemFieldName +' = ct.RN 
				FROM '+ @tableName + ' '+ @entity 
			    IF(@entity <>'JobGateway')
				BEGIN
				SET @sqlCommand +=	' INNER JOIN  [dbo].[fnGetUserStatuses]( CAST('+ CAST( @userId AS  VARCHAR ) +' AS BIGINT)) fgus ON ISNULL('+  @entity + '.StatusId,1)  = fgus.StatusId'
				 END
				 SET @sqlCommand+= ' INNER JOIN CTE ct ON ' + @entity + '.'+ @pKFieldName + ' = ct.'+ @pKFieldName +  ' ' + @joins + '
				WHERE 1=1 AND '+@entity+'.StatusId IN (1,2) '+ @Where

    RETURN @sqlCommand
END
GO
