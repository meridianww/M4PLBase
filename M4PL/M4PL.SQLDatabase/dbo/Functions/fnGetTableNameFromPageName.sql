CREATE FUNCTION [dbo].fnGetTableNameFromPageName
(
	@PageName NVARCHAR(50)
)
RETURNS NVARCHAR(50)
AS
BEGIN
	DECLARE @TableName NVARCHAR(50) = ''

	IF LOWER(@PageName) = 'contact'
		SET @TableName = 'CONTC000Master'
	ELSE IF LOWER(@PageName) = 'organization'
		SET @TableName = 'ORGAN000Master'
	ELSE IF LOWER(@PageName) = 'user'
		SET @TableName = 'SYSTM000OpnSezMe'
	ELSE IF LOWER(@PageName) = 'menudriver'
		SET @TableName = 'SYSTM000MenuDriver'
	ELSE IF LOWER(@PageName) = 'savealiascolumn'
		SET @TableName = 'SYSTM000ColumnsAlias'
		
	RETURN @TableName
END

--SELECT [dbo].fnGetTableNameFromPageName ('Contact')