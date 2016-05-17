



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].spGetAllUserAccounts 
	@ColUserId INT = 0
AS
BEGIN
	
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

END