
CREATE PROCEDURE [dbo].[GetOrgSortOrder]
	@OrgID INT = 0
AS
BEGIN TRY
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

END TRY
BEGIN CATCH

	DECLARE @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE()),
			@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY()),
			@RelatedTo VARCHAR(100)  = (SELECT OBJECT_NAME(@@PROCID))
	EXEC [ErrorLog_InsertErrorDetails] @RelatedTo, NULL, @ErrorMessage , NULL, NULL, @ErrorSeverity

END CATCH