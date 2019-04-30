-- =============================================
CREATE PROCEDURE[dbo].[GetOrganizationRoleDetails]
(
@userId BIGINT,
@contactId BIGINT
)
AS
BEGIN
SELECT act.OrgId as OrganizationId
		  ,org.OrgImage as OrganizationImage
		  ,OrgCode as OrganizationCode
		    ,org.StatusId as OrgStatusId
	FROM [dbo].[ORGAN020Act_Roles] act
	INNER JOIN [dbo].[ORGAN000Master] org ON org.Id = act.OrgId
	INNER JOIN [dbo].[ORGAN010Ref_Roles] rol ON act.[OrgRefRoleId] = rol.Id
	INNER JOIN [dbo].[SYSTM000OpnSezMe] AS sez ON sez.SysUserContactID = (CASE WHEN (sez.IsSysAdmin = 1) THEN sez.SysUserContactID ELSE act.OrgRoleContactID END)
	WHERE  act.OrgRoleContactID = @contactId
END;
GO