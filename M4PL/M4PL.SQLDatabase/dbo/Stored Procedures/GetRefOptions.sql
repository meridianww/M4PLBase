CREATE PROCEDURE [dbo].[GetRefOptions]  --'SYSTM000SecurityByRole', 'SecSecurityData'
	@TableName NVARCHAR(50) = NULL,
	@ColumnName NVARCHAR(50) = NULL
AS
BEGIN TRY
	SET NOCOUNT ON;

	DECLARE @SQL NVARCHAR(MAX) = '';

	SET @SQL = '
		SELECT 
			SysOptionID
			,SysOptionName
			,SysTableName
			,SysColumnName
		FROM
			dbo.SYSTM010Ref_Options (NOLOCK)
		WHERE
			1 = 1'
	IF ISNULL(@TableName, '') <> ''
	BEGIN
		SET @SQL = @SQL + '
			AND LOWER(SysTableName) = ''' + LOWER(@TableName) + ''''
	END

	IF ISNULL(@ColumnName, '') <> ''
	BEGIN
		SET @SQL = @SQL + '
			AND LOWER(SysColumnName) = ''' + LOWER(@ColumnName) + ''''
	END

	IF ISNULL(@TableName, '') <> '' AND ISNULL(@ColumnName, '') <> ''
	BEGIN
		SET @SQL = @SQL + '
		ORDER BY SysSortOrder '
	END

	PRINT (@SQL);
	EXEC (@SQL);

END TRY
BEGIN CATCH

	DECLARE @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE()),
			@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY()),
			@RelatedTo VARCHAR(100)  = (SELECT OBJECT_NAME(@@PROCID))
	EXEC [ErrorLog_InsertErrorDetails] @RelatedTo, NULL, @ErrorMessage , NULL, NULL, @ErrorSeverity

END CATCH