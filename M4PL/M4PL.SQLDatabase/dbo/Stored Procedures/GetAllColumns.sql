




CREATE PROCEDURE [dbo].[GetAllColumns] --'Contact'
	@PageName NVARCHAR(50) = ''
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @TableName NVARCHAR(50) = '';
	SELECT @TableName = [dbo].fnGetTableNameFromPageName(@PageName);
	
	SELECT 
		C.name AS ColColumnName
		,CAST(ROW_NUMBER() OVER (ORDER BY C.name) AS TINYINT) AS ColSortOrder
		,ISNULL(CA.[ColAliasName], C.name) AS ColAliasName
	FROM 
		sys.columns C
		LEFT JOIN [dbo].[SYSTM000ColumnsAlias] CA (NOLOCK)
	ON
		CA.ColColumnName = C.name AND CA.[ColTableName] = @TableName
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
	FROM
		dbo.SYSTM000ColumnOrdering CO (NOLOCK)
		LEFT JOIN [dbo].[SYSTM000ColumnsAlias] CA (NOLOCK)
	ON
		CA.ColColumnName = CO.ColColumnName AND CA.[ColTableName] = @TableName
	WHERE 
		CO.ColTableName = @TableName
	ORDER BY CO.ColSortOrder	

END