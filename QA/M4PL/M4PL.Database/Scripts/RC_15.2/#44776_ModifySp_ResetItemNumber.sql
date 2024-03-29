USE [M4PL_DEV]
GO
/****** Object:  StoredProcedure [dbo].[ResetItemNumber]    Script Date: 7/9/2019 11:23:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                                  
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
	@newItemNumber INT = NULL OUTPUT,
	@deletedKeys VARCHAR(200)=NULL
                                  
)                                       
AS        
BEGIN TRY                        
	SET NOCOUNT ON;  

	DECLARE @sqlCommand NVARCHAR(MAX), @tableName NVARCHAR(100), @pKFieldName NVARCHAR(100), @itemFieldName NVARCHAR(100),@parentKeyName NVARCHAR(100) ,@settingsWhere NVARCHAR(MAX) ;
	       
	SELECT @tableName = sysRef.TblTableName,
	@pKFieldName = sysRef.TblPrimaryKeyName,
	@itemFieldName = sysRef.TblItemNumberFieldName,
	@parentKeyName = sysRef.TblParentIdFieldName
	FROM [dbo].[SYSTM000Ref_Table] (NOLOCK) sysRef WHERE sysRef. SysRefName = @entity;
	IF(ISNULL(@statusId, 1) = 1)
		BEGIN 
		SET @statusId = 1;
		END
	IF(ISNULL(@where, '') = '')
		BEGIN 
		SET @where = '';
		END
	IF(ISNULL(@joins, '') = '')
			BEGIN 
			SET @joins = '';
			END
   IF(ISNULL(@parentId, 0) > 0 )
		BEGIN
		SET @where = @where + ' AND ' +  @entity + '.'+ @parentKeyName + ' = CAST('+ CAST( @parentId AS  VARCHAR ) +' AS BIGINT)';
		END
   IF(@tableName  = 'CONTC010Bridge')
   BEGIN
   SET @where = @where + ' AND ' +  @entity + '.ConTableName =' + ''''+ @entity + '''';
   END
    IF ((ISNULL(@id,0)<>0) AND (@entity  ='JobGateway' OR @entity  ='PrgRefGatewayDefault' OR @entity  ='JobDocReference')) 
		BEGIN
		IF(ISNULL(@statusId, 1) = 1 OR @entity  ='JobGateway' )
		BEGIN 
		SET @statusId = 194;
		END
			EXEC GetEntitySettingWhereClause @entity,@id,@joins,@userid,'ItemNumber',@deletedKeys, @settingsWhere OUTPUT  
			IF(CHARINDEX(@settingsWhere,@where) = 0)
			BEGIN
			IF(ISNULL(@parentId, 0) > 0 )
				BEGIN
					SET @settingsWhere +=  ' AND ' +  @entity + '.'+ @parentKeyName + ' = CAST('+ CAST( @parentId AS  VARCHAR ) +' AS BIGINT)';
	
				END
		
				Declare @jobDocReferenceCommand NVARCHAR(MAX) 
					select @jobDocReferenceCommand =  dbo.ResetJobsItemNumberSQL(@id,@tableName,@pKFieldName,@itemFieldName ,@parentKeyName ,@entity,@userId,@settingsWhere,@joins);
					EXEC sp_executesql @jobDocReferenceCommand
					SET @id = 0;
				
				

			 END
		END
	
	IF(@statusId =1 OR @statusId =2 OR @statusId =194 OR @statusId =195 )   -- 194 and 195  are for Job gateways  and 1,2 are active and Inactive 
	BEGIN
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
		FROM '+ @tableName + ' '+ @entity  
		IF(@entity <>'JobGateway')
		BEGIN
		SET @sqlCommand +=	' INNER JOIN  [dbo].[fnGetUserStatuses]( CAST('+ CAST( @userId AS  VARCHAR ) +' AS BIGINT)) fgus ON ISNULL('+  @entity + '.StatusId,1)  = fgus.StatusId'
		END
		
		SET @sqlCommand+= ' '+ @joins + ' WHERE 1=1 ' + @where + ') SELECT @maxItemNumber = COUNT(CURRENT_ID) FROM CTE'
		EXEC sp_executesql @sqlCommand, N'@maxItemNumber INT OUTPUT',@maxItemNumber =  @maxItemNumber OUTPUT --first get maxItemNumber present in db
			IF(ISNULL(@maxItemNumber,0)=0)
				BEGIN
					SET @newItemNumber=1;					
				END
			ELSE IF(ISNULL(@itemNumber,0)=0 )
				BEGIN
					If(ISNULL(@id,0)>0)
					BEGIN
						SET @sqlCommand = 'SELECT @existingItemNumber = '  + @entity + '.' + @itemFieldName + ' FROM '+ @tableName + ' '+ @entity + ' WHERE '  +  @entity + '.'+ @pKFieldName + ' =  CAST('+ CAST( @id AS  VARCHAR ) +' AS BIGINT)'
						EXEC sp_executesql @sqlCommand, N' @existingItemNumber int output', @existingItemNumber output
						SET @newItemNumber = @existingItemNumber;					
					END
					ELSE
					BEGIN
					   SET @newItemNumber = ISNULL(@maxItemNumber,0)+1;
					END
				END
			ELSE
				BEGIN
					--Finding If this Item Number already exists
					SET @sqlCommand = 'SELECT @newItemId = '+ @entity + '.'+ @pKFieldName +
					' FROM '+ @tableName + ' '+ @entity 
					if(@entity <>'JobGateway')
					BEGIN
					SET @sqlCommand +=	' INNER JOIN  [dbo].[fnGetUserStatuses]( CAST('+ CAST( @userId AS  VARCHAR ) +' AS BIGINT)) fgus ON ISNULL('+  @entity + '.StatusId,1)  = fgus.StatusId'
					END
					
						SET @sqlCommand+= ' '+ @joins + ' WHERE '  +  @entity + '.'+ @pKFieldName + ' <>  CAST('+ CAST( @id AS  VARCHAR ) +' AS BIGINT) AND '
					+  @entity + '.'+ @itemFieldName + ' = CAST('+ CAST( @itemNumber AS  VARCHAR ) +' AS INT)'
					+  @where
					EXEC sp_executesql @sqlCommand, N' @newItemId int output', @newItemId output
						IF(ISNULL(@newItemId,0)=0  AND @itemNumber < @maxItemNumber ) --same item number does not exists and less is than maximum
						BEGIN
						 SET @newItemNumber = @itemNumber;
						END
						ELSE IF(ISNULL(@newItemId,0)=0  AND @itemNumber >= @maxItemNumber )--SAME ITEM NUMBER DOES NOT EXISTS AND USER TRYING TO ADD ITEM NUMBER LARGER OR EQUAL TO MAXIMUM
						BEGIN
								IF(ISNULL(@id,0)>0) --User Is Updating .
								BEGIN  --Begin swaping with maximum number 
								--GET item Number of Current Record Id
									SET @sqlCommand = 'SELECT @existingItemNumber = '  + @entity + '.' + @itemFieldName + ' FROM '+ @tableName + ' '+ @entity + ' WHERE '  +  @entity + '.'+ @pKFieldName + ' =  CAST('+ CAST( @id AS  VARCHAR ) +' AS BIGINT)'
									EXEC sp_executesql @sqlCommand, N' @existingItemNumber int output', @existingItemNumber output

									SET @sqlCommand = 'SELECT @maxiItemNumId = '+ @entity + '.'+ @pKFieldName +
									' FROM '+ @tableName + ' '+ @entity 
									if(@entity <>'JobGateway')
									BEGIN
									SET @sqlCommand +=	' INNER JOIN  [dbo].[fnGetUserStatuses]( CAST('+ CAST( @userId AS  VARCHAR ) +' AS BIGINT)) fgus ON ISNULL('+  @entity + '.StatusId,1)  = fgus.StatusId'
									END
								
									SET @sqlCommand+= ' '+ @joins + ' WHERE '  +  @entity + '.'+ @itemFieldName + ' = CAST('+ CAST( @maxItemNumber AS  VARCHAR ) +' AS INT)'+  @where
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
											If(ISNULL(@maxItemNumId,0)<>0) AND (@existingItemNumber=@itemNumber)
											BEGIN
											SET @newItemNumber=@existingItemNumber
											END 
									END
								ELSE-----USER  IS INSERTING JUST INSERT  MAXIMUM +1
								SET @newItemNumber = @maxItemNumber+1
						END
						ELSE ------ SAME ITEM NUMBER EXISTS FOR OTHER RECORD
						BEGIN
						IF(ISNULL(@id,0) = 0) --USER IS INSERTING --INSERT AND SHIFT
								BEGIN
								SET @sqlCommand = ';WITH CTE AS
								(
								SELECT '+  @entity + '.'+ @pKFieldName +',
								ROW_NUMBER() OVER (ORDER BY '+ @entity + '.'+ @itemFieldName +' ASC) AS RN
								FROM '+ @tableName + ' '+ @entity 
								if(@entity <>'JobGateway')
								BEGIN
								SET @sqlCommand +=	' INNER JOIN  [dbo].[fnGetUserStatuses]( CAST('+ CAST( @userId AS  VARCHAR ) +' AS BIGINT)) fgus ON ISNULL('+  @entity + '.StatusId,1)  = fgus.StatusId'
								END
								
								SET @sqlCommand+= ' '+ @joins + ' WHERE 1=1 ' + @where + ' AND ' + @entity + '.' + @itemFieldName +' > (CAST('+ CAST( @itemNumber AS  VARCHAR ) +' AS INT)) - 1)
								UPDATE '+ @entity + '
								SET ' + @entity + '.' + @itemFieldName +' = (ct.RN + (CAST('+ CAST( @itemNumber AS  VARCHAR ) +' AS INT)))
								FROM '+ @tableName + ' '+ @entity 

								if(@entity <>'JobGateway')
								BEGIN
								SET @sqlCommand +=	' INNER JOIN  [dbo].[fnGetUserStatuses]( CAST('+ CAST( @userId AS  VARCHAR ) +' AS BIGINT)) fgus ON ISNULL('+  @entity + '.StatusId,1)  = fgus.StatusId'
								END
								

								SET @sqlCommand+= ' INNER JOIN cte ct ON ' + @entity + '.'+ @pKFieldName + ' = ct.'+ @pKFieldName +  ' ' + @joins + '
								WHERE 1=1 ' + @where
								EXEC sp_executesql @sqlCommand
								SET @newItemNumber = @itemNumber;
							END 
						ELSE --- DO SWAPPING
								BEGIN
								SET @sqlCommand = 'SELECT @existingItemNumber = '  + @entity + '.' + @itemFieldName + ' FROM '+ @tableName + ' '+ @entity + ' WHERE '  +  @entity + '.'+ @pKFieldName + ' =  CAST('+ CAST( @id AS  VARCHAR ) +' AS BIGINT)'
								EXEC sp_executesql @sqlCommand, N' @existingItemNumber int output', @existingItemNumber output
									BEGIN
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
               END
		END		   			
	END
ELSE --Reordering from begining since we are making record inactive 
BEGIN
      IF ((ISNULL(@id,0)=0) AND (@entity  ='JobGateway' OR @entity  ='PrgRefGatewayDefault' OR @entity  ='JobDocReference') ) 
	  BEGIN
	  EXEC GetEntitySettingWhereClause @entity,@id,@joins,@userid,'ItemNumber', @deletedKeys, @settingsWhere OUTPUT  
	  SET @where += @settingsWhere
	  END
    SET @sqlCommand = dbo.ResetJobsItemNumberSQL(@id,@tableName,@pKFieldName,@itemFieldName ,@parentKeyName ,@entity,@userId,@where,@joins);
  
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