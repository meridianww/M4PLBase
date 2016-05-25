



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetAllUserAccounts] 
	@ColUserId INT = 0
AS
BEGIN TRY
	
	SET NOCOUNT ON;

	IF @ColUserId > 0
	BEGIN
		DECLARE @Query NVARCHAR(MAX) = '';
		SELECT @Query = ColOrderingQuery FROM [dbo].[SYSTM000ColumnsSorting&Ordering] (NOLOCK) WHERE ColPageName = 'User' AND ColUserId = @ColUserId;
		PRINT(@Query);
		EXEC(@Query);
	END
	ELSE
	BEGIN
		SELECT 
			OSM.SysUserID
			,OSM.SysUserContactID
			,OSM.SysScreenName
			,OSM.SysPassword
			,OSM.[SysComments]
			,OSM.SysStatusAccount
			,OSM.SysDateEntered
			,OSM.SysDateChanged
			,RO.[SysOptionName] AS [Status]
			,ISNULL(CM.[ConFullName], (CM.[ConFirstName] + ' ' + CM.[ConLastName])) AS [ConFullName]
		FROM 
			dbo.SYSTM000OpnSezMe OSM (NOLOCK) 
		INNER JOIN dbo.SYSTM010Ref_Options RO (NOLOCK)
		ON
			RO.SysOptionID = OSM.SysStatusAccount
		INNER JOIN dbo.CONTC000Master CM (NOLOCK)
		ON
			CM.ContactID = OSM.SysUserContactID
	END

END TRY
BEGIN CATCH

	DECLARE @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE()),
			@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY()),
			@RelatedTo VARCHAR(100)  = (SELECT OBJECT_NAME(@@PROCID))
	EXEC [ErrorLog_InsertErrorDetails] @RelatedTo, NULL, @ErrorMessage , NULL, NULL, @ErrorSeverity

END CATCH