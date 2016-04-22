CREATE PROCEDURE [dbo].[GetAllSecurityRoles]
AS
BEGIN
	SET NOCOUNT ON;

	;WITH RefOptions AS
	(
		SELECT 
			SysOptionID
			,SysOptionName
			,SysTableName
			,SysColumnName
		FROM
			dbo.SYSTM010Ref_Options (NOLOCK)
	)
	,SecurityRoles AS
	(
		SELECT 
			R.SecurityLevelID
			,R.OrgRoleID
			,RO.OrgRoleCode
			,RO.OrgRoleTitle
			,R.SecLineOrder
			,R.SecModule
			,ISNULL(O2.SysOptionName, 'NA') AS SecModuleTitle
			,R.SecSecurityMenu
			,ISNULL(M.MnuTitle, 'NA')		AS SecSecurityMenuTitle
			,R.SecSecurityData
			,ISNULL(O1.SysOptionName, 'NA') AS SecSecurityDataTitle
		FROM
			dbo.SYSTM000SecurityByRole R (NOLOCK)
		INNER JOIN dbo.ORGAN010Ref_Roles RO (NOLOCK) ON RO.OrgRoleID = R.OrgRoleID
		INNER JOIN RefOptions O1 WITH (NOLOCK) ON O1.SysOptionID = R.SecSecurityData AND O1.SysTableName = 'SYSTM000SecurityByRole' AND O1.SysColumnName = 'SecSecurityData'
		LEFT JOIN RefOptions O2 WITH (NOLOCK) ON O2.SysOptionID = R.SecModule AND O2.SysTableName = 'SYSTM000MenuDriver' AND O2.SysColumnName = 'MnuModule'
		LEFT JOIN dbo.SYSTM000MenuDriver M WITH (NOLOCK) ON M.MenuID = R.SecSecurityMenu
	)

	SELECT * FROM SecurityRoles WITH (NOLOCK)
	

END

