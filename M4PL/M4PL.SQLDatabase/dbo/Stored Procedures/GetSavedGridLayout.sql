CREATE PROCEDURE [dbo].GetSavedGridLayout
	@Pagename VARCHAR(25)
	,@UserID INT = 0
AS
BEGIN TRY
	SET NOCOUNT ON;

	SELECT 
		ISNULL(ColGridLayout, '') AS GridLayout
	FROM 
		dbo.[SYSTM000ColumnsSorting&Ordering] (NOLOCK)
	WHERE
		ColPageName = @Pagename
		AND ColUserId = @UserID
END TRY
BEGIN CATCH

	DECLARE @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE()),
			@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY()),
			@RelatedTo VARCHAR(100)  = (SELECT OBJECT_NAME(@@PROCID))
	EXEC [ErrorLog_InsertErrorDetails] @RelatedTo, NULL, @ErrorMessage , NULL, NULL, @ErrorSeverity

END CATCH