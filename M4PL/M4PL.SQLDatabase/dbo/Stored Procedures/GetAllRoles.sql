CREATE PROCEDURE [dbo].[GetAllRoles]
AS
BEGIN TRY
	SET NOCOUNT ON;
	SELECT 
		OrgRoleID
		,OrgID
		,OrgID
		,PrgID
		,PrjID
		,JobID
		,OrgRoleSortOrder
		,OrgRoleCode
		,OrgRoleTitle
		,OrgRoleDesc
		,OrgRoleContactID
		,OrgRoleType
		,OrgComments
		,OrgDateEntered
		,OrgEnteredBy
		,OrgDateChanged
		,OrgDateChangedBy
	FROM
		dbo.ORGAN010Ref_Roles (NOLOCK)
	ORDER BY OrgRoleSortOrder
END TRY
BEGIN CATCH

	DECLARE @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE()),
			@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY()),
			@RelatedTo VARCHAR(100)  = (SELECT OBJECT_NAME(@@PROCID))
	EXEC [ErrorLog_InsertErrorDetails] @RelatedTo, NULL, @ErrorMessage , NULL, NULL, @ErrorSeverity

END CATCH