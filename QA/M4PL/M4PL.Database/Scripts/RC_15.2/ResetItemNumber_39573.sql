
/* Copyright (2018) Meridian Worldwide Transportation Group    
   All Rights Reserved Worldwide */    
-- =============================================            
-- Author:                    Nikhil             
-- Create date:               11/22/2018          
-- Description:               To Reset item number as consecutive numbers    
-- Execution:                 EXEC [dbo].[ResetItemNumber]    
-- Modified on:      
-- Modified Desc:     
-- Execution:      EXEC [dbo].[ResetItemNumber]   
-- =============================================                                          
                                       
ALTER PROCEDURE [dbo].[ResetItemNumber]                                        
( 
 
 @userId BIGINT,
 @id BIGINT,  
 @parentId BIGINT,
 @entity NVARCHAR(100), 
 @itemNumber INT,
 @statusId INT,  
 @joins NVARCHAR(MAX),                             
 @where NVARCHAR(MAX),                   
 @newItemNumber INT = NULL OUTPUT                                      
)                                        
AS        
BEGIN TRY                        
	SET NOCOUNT ON;  
	DECLARE @sqlCommand NVARCHAR(MAX), @tableName NVARCHAR(100), @pKFieldName NVARCHAR(100), @itemFieldName NVARCHAR(100),@parentKeyName NVARCHAR(100);
	       
	SELECT @tableName = sysRef.TblTableName,
	@pKFieldName = sysRef.TblPrimaryKeyName,
	@itemFieldName = sysRef.TblItemNumberFieldName,
	@parentKeyName = sysRef.TblParentIdFieldName
	FROM [dbo].[SYSTM000Ref_Table] (NOLOCK) sysRef WHERE sysRef. SysRefName = @entity;
	IF(ISNULL(@where, '') = '')
		BEGIN 
		SET @where = '';
		END

	IF(ISNULL(@parentId, 0) > 0 )
		BEGIN
		SET @where = @where + ' AND ' +  @entity + '.'+ @parentKeyName + ' = CAST('+ CAST( @parentId AS  VARCHAR ) +' AS BIGINT)';
		END

	IF(ISNULL(@joins, '') = '')
		BEGIN 
		SET @joins = '';
		END
	IF(ISNULL(@statusId,1) < 3) -- insert or update for valid active and inactive records
			BEGIN
					DECLARE @maxItemNumber INT = 0;
					DECLARE @newItemId INT = 0 ;
					DECLARE @existingItemNumber INT = 0 ;
					DECLARE @existingItemId INT = 0 ;
					Declare @maxItemNumId  INT =0;
					SET @sqlCommand = ';WITH CTE AS
					(
					SELECT '+  @entity + '.'+ @pKFieldName +' AS CURRENT_ID,
					ROW_NUMBER() OVER (ORDER BY '+ @entity + '.'+ @itemFieldName +' ASC) AS RN
					FROM '+ @tableName + ' '+ @entity + '
					INNER JOIN  [dbo].[fnGetUserStatuses]( CAST('+ CAST( @userId AS  VARCHAR ) +' AS BIGINT)) fgus ON ISNULL('+  @entity + '.StatusId,1)  = fgus.StatusId   
					' + @joins + ' WHERE 1=1 ' + @where + ') SELECT @maxItemNumber = COUNT(CURRENT_ID) FROM CTE'
					EXEC sp_executesql @sqlCommand, N'@maxItemNumber INT OUTPUT',@maxItemNumber =  @maxItemNumber OUTPUT --first get maxItemNumber present in db
					IF(ISNULL(@maxItemNumber,0)=0)
					    SET @newItemNumber=1;
					--Finding If this Item Number already exists
						SET @sqlCommand = 'SELECT @newItemId = '+ @entity + '.'+ @pKFieldName +
						' FROM '+ @tableName + ' '+ @entity + '
						INNER JOIN  [dbo].[fnGetUserStatuses](CAST('+ CAST( @userId AS  VARCHAR ) +' AS BIGINT)) fgus ON ISNULL('+  @entity + '.StatusId,1)  = fgus.StatusId   
						' + @joins + ' WHERE '  +  @entity + '.'+ @pKFieldName + ' <>  CAST('+ CAST( @id AS  VARCHAR ) +' AS BIGINT) AND '
						+  @entity + '.'+ @itemFieldName + ' = CAST('+ CAST( @itemNumber AS  VARCHAR ) +' AS INT)'
						+  @where
						EXEC sp_executesql @sqlCommand, N' @newItemId int output', @newItemId output

						IF(ISNULL(@newItemId,0)=0 )--User trying to ADD item Number larger than maximum
						BEGIN
								IF(ISNULL(@id,0)>0) --User Is Updating .
								BEGIN
								--GET item Number of Current Record Id
									SET @sqlCommand = 'SELECT @existingItemNumber = '  + @entity + '.' + @itemFieldName + ' FROM '+ @tableName + ' '+ @entity + ' WHERE '  +  @entity + '.'+ @pKFieldName + ' =  CAST('+ CAST( @id AS  VARCHAR ) +' AS BIGINT)'
									EXEC sp_executesql @sqlCommand, N' @existingItemNumber int output', @existingItemNumber output

									SET @sqlCommand = 'SELECT @maxiItemNumId = '+ @entity + '.'+ @pKFieldName +
									' FROM '+ @tableName + ' '+ @entity + '
									INNER JOIN  [dbo].[fnGetUserStatuses](CAST('+ CAST( @userId AS  VARCHAR ) +' AS BIGINT)) fgus ON ISNULL('+  @entity + '.StatusId,1)  = fgus.StatusId   
									' + @joins + ' WHERE '  
									+  @entity + '.'+ @itemFieldName + ' = CAST('+ CAST( @maxItemNumber AS  VARCHAR ) +' AS INT)'
									+  @where
									EXEC sp_executesql @sqlCommand, N' @maxiItemNumId int output', @maxItemNumId output
										If(ISNULL(@maxItemNumId,0)<>0)
											BEGIN
												SET @sqlCommand = 'UPDATE '+ @entity + '
												SET ' + @entity + '.' + @itemFieldName + ' = CAST('+ CAST( @existingItemNumber AS  VARCHAR ) +' AS INT)
												FROM '+ @tableName + ' '+ @entity + '
												WHERE '  +  @entity + '.'+ @pKFieldName + ' =  CAST('+ CAST( @maxItemNumId AS  VARCHAR ) +' AS BIGINT)'
												EXEC sp_executesql @sqlCommand
												SET @sqlCommand = 'UPDATE '+ @entity + '
												SET ' + @entity + '.' + @itemFieldName + ' = CAST('+ CAST( @maxItemNumber AS  VARCHAR ) +' AS INT)
												FROM '+ @tableName + ' '+ @entity + '
												WHERE '  +  @entity + '.'+ @pKFieldName + ' =  CAST('+ CAST( @id AS  VARCHAR ) +' AS BIGINT)'
												EXEC sp_executesql @sqlCommand
												SET @newItemNumber = @maxItemNumber;
											END
									END
								 ELSE
								 SET @newItemNumber = @maxItemNumber+1
							END
						ELSE
						BEGIN
						IF(ISNULL(@id,0) = 0) --User Is Inserting New Record
								BEGIN
								SET @sqlCommand = ';WITH CTE AS
								(
								SELECT '+  @entity + '.'+ @pKFieldName +',
								ROW_NUMBER() OVER (ORDER BY '+ @entity + '.'+ @itemFieldName +' ASC) AS RN
								FROM '+ @tableName + ' '+ @entity + '
								INNER JOIN  [dbo].[fnGetUserStatuses]( CAST('+ CAST( @userId AS  VARCHAR ) +' AS BIGINT)) fgus ON ISNULL('+  @entity + '.StatusId,1)  = fgus.StatusId   
								' + @joins + ' WHERE 1=1 ' + @where + ' AND ' + @entity + '.' + @itemFieldName +' > (CAST('+ CAST( @itemNumber AS  VARCHAR ) +' AS INT)) - 1)
								UPDATE '+ @entity + '
								SET ' + @entity + '.' + @itemFieldName +' = (ct.RN + (CAST('+ CAST( @itemNumber AS  VARCHAR ) +' AS INT)))
								FROM '+ @tableName + ' '+ @entity + '
								INNER JOIN  [dbo].[fnGetUserStatuses](CAST('+ CAST( @userId AS  VARCHAR ) +' AS BIGINT)) fgus ON ISNULL('+  @entity + '.StatusId,1)  = fgus.StatusId   
								INNER JOIN cte ct ON ' + @entity + '.'+ @pKFieldName + ' = ct.'+ @pKFieldName +  ' ' + @joins + '
								WHERE 1=1 ' + @where
								EXEC sp_executesql @sqlCommand
								SET @newItemNumber = @itemNumber;
							END 
							ELSE
								BEGIN
								SET @sqlCommand = 'SELECT @existingItemNumber = '  + @entity + '.' + @itemFieldName + ' FROM '+ @tableName + ' '+ @entity + ' WHERE '  +  @entity + '.'+ @pKFieldName + ' =  CAST('+ CAST( @id AS  VARCHAR ) +' AS BIGINT)'
								EXEC sp_executesql @sqlCommand, N' @existingItemNumber int output', @existingItemNumber output
								SET @sqlCommand = 'UPDATE '+ @entity + '
									SET ' + @entity + '.' + @itemFieldName + ' = CAST('+ CAST( @existingItemNumber AS  VARCHAR ) +' AS INT)
									FROM '+ @tableName + ' '+ @entity + '
									WHERE '  +  @entity + '.'+ @pKFieldName + ' =  CAST('+ CAST( @newItemId AS  VARCHAR ) +' AS BIGINT)'
									EXEC sp_executesql @sqlCommand
									SET @sqlCommand = 'UPDATE '+ @entity + '
									SET ' + @entity + '.' + @itemFieldName + ' = CAST('+ CAST( @itemNumber AS  VARCHAR ) +' AS INT)
									FROM '+ @tableName + ' '+ @entity + '
									WHERE '  +  @entity + '.'+ @pKFieldName + ' =  CAST('+ CAST( @id AS  VARCHAR ) +' AS BIGINT)'
									EXEC sp_executesql @sqlCommand
									SET @newItemNumber = @itemNumber;
								END
						   END
			END
	ELSE --Reordering from begining since we are making record inactive 
			BEGIN
				SET @sqlCommand = ';WITH CTE AS
				(
				SELECT '+  @entity + '.'+ @pKFieldName +',
				ROW_NUMBER() OVER (ORDER BY '+ @entity + '.'+ @itemFieldName +' ASC) AS RN
				FROM '+ @tableName + ' '+ @entity + '
				INNER JOIN  [dbo].[fnGetUserStatuses]( CAST('+ CAST( @userId AS  VARCHAR ) +' AS BIGINT)) fgus ON ISNULL('+  @entity + '.StatusId,1)  = fgus.StatusId   
				' + @joins + ' WHERE 1=1 ' + @where + ' AND ' + @entity + '.'+ @pKFieldName + ' <> CAST('+ CAST( @id AS  VARCHAR ) +' AS BIGINT))
				UPDATE '+ @entity + '
				SET ' + @entity + '.' + @itemFieldName +' = ct.RN 
				FROM '+ @tableName + ' '+ @entity + '
				INNER JOIN  [dbo].[fnGetUserStatuses](CAST('+ CAST( @userId AS  VARCHAR ) +' AS BIGINT)) fgus ON ISNULL('+  @entity + '.StatusId,1)  = fgus.StatusId   
				INNER JOIN CTE ct ON ' + @entity + '.'+ @pKFieldName + ' = ct.'+ @pKFieldName +  ' ' + @joins + '
				WHERE 1=1 ' + @where
				EXEC sp_executesql @sqlCommand
				SET @newItemNumber = @@ROWCOUNT
			END
END TRY                        
BEGIN CATCH                        
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                        
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                        
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                        
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                        
END CATCH