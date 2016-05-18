
CREATE PROCEDURE [dbo].[GetOrgSortOrder]
	@OrgID INT = 0
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @CNT BIGINT = 0
	SELECT @CNT = COUNT(1) FROM dbo.ORGAN000Master (NOLOCK)
	
	DECLARE @SQL NVARCHAR(500) = '

	;WITH CTE_OrgSortOrders AS 
	(
		SELECT OrgSortOrder = 1
		UNION ALL
		SELECT OrgSortOrder + 1 FROM CTE_OrgSortOrders WHERE OrgSortOrder '
		IF @OrgID > 0 SET @SQL = @SQL + '< ' ELSE SET @SQL = @SQL + '<= '
		SET @SQL = @SQL + CAST(@CNT AS NVARCHAR) + '
	)
	SELECT * FROM CTE_OrgSortOrders WITH (NOLOCK)
	'

	PRINT(@SQL)
	EXEC(@SQL)

END