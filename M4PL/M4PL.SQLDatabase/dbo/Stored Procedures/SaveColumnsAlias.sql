

-- =============================================
-- Author:		Ishan Malik
-- Create date: 19-May-2016
-- Description:	Procedure for saving columns aliases
-- =============================================
CREATE PROCEDURE [dbo].[SaveColumnsAlias]
	 @PageName		NVARCHAR (50) 
	 ,@ColumnsList	dbo.udtColumnAliases READONLY      
AS
BEGIN TRY
	
	BEGIN TRANSACTION

	DECLARE @ColTableName NVARCHAR(50) = '';
	SELECT @ColTableName = [dbo].fnGetTableNameFromPageName(@PageName);

	UPDATE
		CA
	SET
		 CA.ColAliasName   = CL.ColAliasName  
		,CA.ColCaption     = CL.ColCaption    
		,CA.ColDescription = CL.ColDescription
		--,CA.ColCulture     = CL.ColCulture    
		,CA.ColIsVisible   = CL.ColIsVisible  
		,CA.ColIsDefault   = CL.ColIsDefault 
	FROM
		dbo.[SYSTM000ColumnsAlias] AS CA
		INNER JOIN @ColumnsList AS CL
	ON 
		CA.[ColColumnName]	= CL.[ColColumnName]
		AND CA.ColTableName	= @ColTableName

	INSERT INTO [dbo].[SYSTM000ColumnsAlias]
	(   
		 [ColTableName]   
		 ,[ColColumnName]  
		 ,[ColAliasName]   
		 ,[ColCaption]     
		 ,[ColDescription] 
		 --,[ColCulture]     
		 ,[ColIsVisible]   
		 ,[ColIsDefault]   
	)
	SELECT
	
		  @ColTableName   
		  ,ColColumnName 
		  ,ColAliasName  
		  ,ColCaption    
		  ,ColDescription
		  --,ColCulture    
		  ,ColIsVisible  
		  ,ColIsDefault  
	FROM
		@ColumnsList
	WHERE
		[ColColumnName]
	NOT IN
	(
		SELECT 
			[ColColumnName]
		FROM 
			dbo.[SYSTM000ColumnsAlias]
		WHERE 
			ColTableName = @ColTableName
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