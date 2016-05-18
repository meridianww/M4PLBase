

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetAllOrganizations] 
	@ColUserId INT = 0
AS
BEGIN
	
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

END