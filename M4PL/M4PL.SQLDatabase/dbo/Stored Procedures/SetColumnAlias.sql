
CREATE PROCEDURE [dbo].[SetColumnAlias] --'Contact'
	@PageName NVARCHAR(50) = ''
AS
BEGIN
	SET NOCOUNT ON;

DECLARE @TableName NVARCHAR(50) = '';
SELECT @TableName = [dbo].fnGetTableNameFromPageName(@PageName);

;WITH Cols AS
(
	SELECT 
		name, SUBSTRING(name, 4, LEN(name)) AS Alias
	FROM 
		sys.columns
	WHERE 
		OBJECT_ID = OBJECT_ID(@TableName)
		AND name NOT IN 
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
					dbo.SYSTM000ColumnsAlias (NOLOCK)
				WHERE 
					ColTableName = @TableName
			)
)
,Final AS
(
	SELECT name, (SELECT dbo.fnSpaceBeforeCap(SUBSTRING(name, 4, LEN(name)))) AS Alias
	FROM Cols
)

INSERT INTO SYSTM000ColumnsAlias
(
	ColTableName
	,ColColumnName
	,ColAliasName
)
SELECT 
	@TableName
	,name
	,Alias 
FROM Final

SELECT * FROM [dbo].[SYSTM000ColumnsAlias] (NOLOCK)
WHERE ColTableName = @TableName
END