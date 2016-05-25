
CREATE PROCEDURE [dbo].[GetAllColumns] --'Contact', 1
	@PageName NVARCHAR(50) = '',
	@IsRestoreDefault BIT = 0
AS
BEGIN TRY
	SET NOCOUNT ON;

	DECLARE @TableName NVARCHAR(50) = '';
	SELECT @TableName = [dbo].fnGetTableNameFromPageName(@PageName);

	IF @IsRestoreDefault = 0
	BEGIN

		SELECT 
			C.name AS ColColumnName
			,CAST(ROW_NUMBER() OVER (ORDER BY C.name) AS TINYINT) AS ColSortOrder
			,ISNULL(CA.[ColAliasName], C.name) AS ColAliasName
			,ISNULL(CA.ColIsDefault, 0) AS ColIsDefault
		FROM 
			sys.columns C
			INNER JOIN [dbo].[SYSTM000ColumnsAlias] CA (NOLOCK)
		ON
			CA.ColColumnName = C.name 
			AND CA.[ColTableName] = @TableName 
			AND CA.ColIsVisible = 1
		WHERE 
			OBJECT_ID = OBJECT_ID(@TableName)
			AND C.name NOT IN 
			(
				SELECT 
					COLUMN_NAME 
				FROM 
					M4PL.INFORMATION_SCHEMA.KEY_COLUMN_USAGE
				WHERE 
					TABLE_NAME = @TableName 
					AND CONSTRAINT_NAME LIKE 'PK%'

				UNION

				SELECT 
					ColColumnName
				FROM
					dbo.SYSTM000ColumnOrdering (NOLOCK)
				WHERE 
					ColTableName = @TableName
			)
		ORDER BY C.name

		SELECT 
			CO.ColColumnName
			,CO.ColSortOrder
			,ISNULL(CA.[ColAliasName], CO.ColColumnName) AS ColAliasName
			,ISNULL(CA.ColIsDefault, 0) AS ColIsDefault
		FROM
			dbo.SYSTM000ColumnOrdering CO (NOLOCK)
			INNER JOIN [dbo].[SYSTM000ColumnsAlias] CA (NOLOCK)
		ON
			CA.ColColumnName = CO.ColColumnName 
			AND CA.[ColTableName] = @TableName 
			AND CA.ColIsVisible = 1
		WHERE 
			CO.ColTableName = @TableName
		ORDER BY CO.ColSortOrder	

	END
	ELSE
	BEGIN
	
		SELECT 
			C.name AS ColColumnName
			,CAST(ROW_NUMBER() OVER (ORDER BY C.name) AS TINYINT) AS ColSortOrder
			,ISNULL(CA.[ColAliasName], C.name) AS ColAliasName
			,ISNULL(CA.ColIsDefault, 0) AS ColIsDefault
		FROM 
			sys.columns C
			INNER JOIN [dbo].[SYSTM000ColumnsAlias] CA (NOLOCK)
		ON
			CA.ColColumnName = C.name 
			AND CA.[ColTableName] = @TableName 
			AND CA.ColIsVisible = 1 
			AND CA.ColIsDefault = 0
		WHERE 
			OBJECT_ID = OBJECT_ID(@TableName)
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

		SELECT 
			CA.ColColumnName
			,CAST(ROW_NUMBER() OVER(ORDER BY CA.ColColumnName ASC) AS TINYINT) AS ColSortOrder
			,ISNULL(CA.[ColAliasName], CA.ColColumnName) AS ColAliasName
			,ISNULL(CA.ColIsDefault, 0) AS ColIsDefault
		FROM
			[dbo].[SYSTM000ColumnsAlias] CA (NOLOCK)
		WHERE 
			CA.ColTableName = @TableName
			AND CA.ColIsVisible = 1
			AND CA.ColIsDefault = 1
		ORDER BY CA.ColColumnName

	END

END TRY
BEGIN CATCH

	DECLARE @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE()),
			@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY()),
			@RelatedTo VARCHAR(100)  = (SELECT OBJECT_NAME(@@PROCID))
	EXEC [ErrorLog_InsertErrorDetails] @RelatedTo, NULL, @ErrorMessage , NULL, NULL, @ErrorSeverity

END CATCH