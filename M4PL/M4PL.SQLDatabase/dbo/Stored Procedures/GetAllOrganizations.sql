

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetAllOrganizations] 
	@ColUserId INT = 0
AS
BEGIN TRY
	
	SET NOCOUNT ON;

	IF @ColUserId > 0
	BEGIN
		DECLARE @Query NVARCHAR(MAX) = '';
		SELECT @Query = ColOrderingQuery FROM [dbo].[SYSTM000ColumnsSorting&Ordering] (NOLOCK) WHERE ColPageName = 'Organization' AND ColUserId = @ColUserId;
		PRINT(@Query);
		EXEC(@Query);
	END
	ELSE
	BEGIN
		SELECT * FROM dbo.[ORGAN000Master] (NOLOCK) ORDER BY OrgSortOrder
	END

END TRY
BEGIN CATCH

	DECLARE @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE()),
			@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY()),
			@RelatedTo VARCHAR(100)  = (SELECT OBJECT_NAME(@@PROCID))
	EXEC [ErrorLog_InsertErrorDetails] @RelatedTo, NULL, @ErrorMessage , NULL, NULL, @ErrorSeverity

END CATCH