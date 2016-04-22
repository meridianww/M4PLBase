CREATE PROCEDURE [dbo].[spGetRefOptions]  --'SYSTM000SecurityByRole', 'SecSecurityData'
	@TableName NVARCHAR(50) = NULL,
	@ColumnName NVARCHAR(50) = NULL
AS
BEGIN
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

END