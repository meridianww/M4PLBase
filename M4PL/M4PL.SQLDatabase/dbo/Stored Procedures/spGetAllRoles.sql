CREATE PROCEDURE [dbo].[spGetAllRoles]
AS
BEGIN
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
END