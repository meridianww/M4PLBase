
CREATE PROCEDURE dbo.[GetAllColumnAliases] --'Contact'
	@PageName NVARCHAR(50) = ''
AS
BEGIN TRY

	SET NOCOUNT ON;

	DECLARE @TableName NVARCHAR(50) = '';
	SELECT @TableName = [dbo].fnGetTableNameFromPageName(@PageName);

	SELECT
		ISNULL(CA.[ColTableName], @TableName)	AS [ColTableName]
		,ISNULL(C.name, CA.[ColColumnName])		AS [ColColumnName]
		,ISNULL(CA.[ColAliasName]  , '')		AS [ColAliasName]  
		,ISNULL(CA.[ColCaption]    , '')		AS [ColCaption]    
		,ISNULL(CA.[ColDescription], '')		AS [ColDescription]
		,ISNULL(CA.[ColCulture]    , '')		AS [ColCulture]    
		,ISNULL(CA.[ColIsVisible]  , 0)			AS [ColIsVisible]  
		,ISNULL(CA.[ColIsDefault]  , 0)			AS [ColIsDefault]  
	FROM
		[dbo].[SYSTM000ColumnsAlias] CA (NOLOCK)
		RIGHT JOIN sys.columns C
	ON
		C.name = CA.ColColumnName
		AND CA.[ColTableName] = @TableName
	WHERE
		C.OBJECT_ID = OBJECT_ID(@TableName)
		AND C.name NOT IN 
		(
			SELECT 
				COLUMN_NAME 
			FROM 
				M4PL.INFORMATION_SCHEMA.KEY_COLUMN_USAGE
			WHERE 
				TABLE_NAME = @TableName 
				AND CONSTRAINT_NAME LIKE 'PK%'
		)
	ORDER BY C.name	

END TRY
BEGIN CATCH

	DECLARE @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE()),
			@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY()),
			@RelatedTo VARCHAR(100)  = (SELECT OBJECT_NAME(@@PROCID))
	EXEC [ErrorLog_InsertErrorDetails] @RelatedTo, NULL, @ErrorMessage , NULL, NULL, @ErrorSeverity

END CATCH