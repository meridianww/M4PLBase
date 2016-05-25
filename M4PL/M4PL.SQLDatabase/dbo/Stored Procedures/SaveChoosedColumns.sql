



CREATE PROCEDURE [dbo].[SaveChoosedColumns]
	@ColumnsList		dbo.udtColumnOrdering READONLY
    ,@ColPageName		NVARCHAR (50)
    ,@ColUserId			INT          
	,@ColEnteredBy		NVARCHAR (50) = ''
	,@ColDateChangedBy	NVARCHAR (50) = ''
AS
BEGIN TRY
	
	BEGIN TRANSACTION

	DECLARE @ColTableName NVARCHAR(50) = '';
	SELECT @ColTableName = [dbo].fnGetTableNameFromPageName(@ColPageName);
	
	DECLARE @ColOrderingQuery NVARCHAR(MAX) = '';
	DECLARE @ColSortColumn NVARCHAR(50) = '';
		
	DECLARE @RowCnt TINYINT = 0
	SELECT @RowCnt = COUNT(*) FROM @ColumnsList

	IF (@RowCnt > 0)
	BEGIN
		
		SET @ColSortColumn = (SELECT COLUMN_NAME FROM M4PL.INFORMATION_SCHEMA.KEY_COLUMN_USAGE WHERE TABLE_NAME = @ColTableName AND CONSTRAINT_NAME LIKE 'PK%');
		SELECT @ColOrderingQuery = COALESCE(@ColOrderingQuery + ',', '') + CL.ColColumnName FROM @ColumnsList CL WHERE ISNULL(CL.ColColumnName, '') <> ''
		--SELECT @ColOrderingQuery = COALESCE(@ColOrderingQuery + ',', '') + (CL.ColColumnName + ' AS ''' + CA.ColAliasName + '''') FROM @ColumnsList CL LEFT JOIN SYSTM000ColumnsAlias CA (NOLOCK) ON CA.ColColumnName = CL.ColColumnName AND CA.ColTableName = @ColTableName WHERE ISNULL(CL.ColColumnName, '') <> ''
		SET @ColOrderingQuery = ('SELECT ' + @ColSortColumn + ',' + SUBSTRING(@ColOrderingQuery, 2, LEN(@ColOrderingQuery)) + ' FROM ' + @ColTableName + ' (NOLOCK) ORDER BY ' + @ColSortColumn);

		IF EXISTS (SELECT 1 FROM [dbo].[SYSTM000ColumnsSorting&Ordering] (NOLOCK) WHERE ColPageName = @ColPageName)
			GOTO EditUpdate;
		ELSE
			GOTO AddInsert;
	END

	AddInsert:
	BEGIN
		INSERT INTO [dbo].[SYSTM000ColumnsSorting&Ordering]
		(   
			 [ColTableName]    
			 ,[ColPageName]     
			 ,[ColSortColumn]   
			 ,[ColUserId]       
			 ,[ColOrderingQuery]
			 ,[ColDateEntered]
			 ,[ColEnteredBy]  
		)
		VALUES
		(
			 @ColTableName    
			 ,@ColPageName     
			 ,@ColSortColumn   
			 ,@ColUserId       
			 ,@ColOrderingQuery
			 ,GETDATE()
			 ,@ColEnteredBy  
		)
	END

	EditUpdate:
	BEGIN
		UPDATE 
			[dbo].[SYSTM000ColumnsSorting&Ordering]
		SET
			[ColTableName]		= @ColTableName
			,[ColPageName]     	= @ColPageName     
			,[ColSortColumn]   	= @ColSortColumn   
			,[ColUserId]       	= @ColUserId       
			,[ColOrderingQuery] = @ColOrderingQuery      
			,[ColDateChanged]   = GETDATE()
			,[ColDateChangedBy] = @ColDateChangedBy   
		WHERE					   
			ColPageName			= @ColPageName
	END

	DELETE FROM 
		dbo.SYSTM000ColumnOrdering
	WHERE
		ColPageName = @ColPageName
		AND ColTableName = @ColTableName
		AND ColColumnName NOT IN
	(
		SELECT ColColumnName FROM @ColumnsList
	)

	UPDATE
		CO
	SET
		CO.ColUserId			= @ColUserId
		,CO.ColSortOrder		= CL.[ColSortOrder]
		,CO.ColDateChanged		= GETDATE()
		,CO.ColDateChangedBy	= @ColDateChangedBy    
	FROM
		dbo.SYSTM000ColumnOrdering AS CO
		INNER JOIN @ColumnsList AS CL
	ON 
		CO.[ColColumnName]	= CL.[ColColumnName]
		AND CO.ColTableName	= @ColTableName
		AND CO.ColPageName	= @ColPageName
		
	INSERT INTO dbo.SYSTM000ColumnOrdering
	(
		ColTableName   
		,ColPageName 
		,ColUserId  
		,ColColumnName
		,ColSortOrder
		,ColDateEntered 
		,ColEnteredBy 
	)
	SELECT
		@ColTableName
		,@ColPageName
		,@ColUserId
		,[ColColumnName] 
		,[ColSortOrder]  
		,GETDATE()
		,@ColEnteredBy
	FROM
		@ColumnsList
	WHERE
		[ColColumnName]
	NOT IN
	(
		SELECT 
			[ColColumnName]
		FROM 
			dbo.SYSTM000ColumnOrdering
		WHERE 
			ColTableName = @ColTableName
			AND ColPageName = @ColPageName
	)
		
	--ROLLBACK TRANSACTION
	COMMIT TRANSACTION

END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION
	DECLARE @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE()),
			@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY()),
			@RelatedTo VARCHAR(100)  = (SELECT OBJECT_NAME(@@PROCID))
	EXEC [ErrorLog_InsertErrorDetails] @RelatedTo, NULL, @ErrorMessage , NULL, NULL, @ErrorSeverity
END CATCH