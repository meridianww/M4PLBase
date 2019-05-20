-- =============================================
ALTER PROCEDURE[dbo].[GetOrganizationRoleDetails]
(
@userId BIGINT,
@contactId BIGINT
)
AS
BEGIN
SELECT		refRole.OrgId as OrganizationId
		  ,org.OrgImage as OrganizationImage
		  ,OrgCode as OrganizationCode
		    ,org.StatusId as OrgStatusId
	FROM [dbo].[ORGAN010Ref_Roles] refRole
	INNER JOIN [dbo].[ORGAN000Master] org ON org.Id = refRole.OrgId
	INNER JOIN [dbo].[CONTC010Bridge] cb ON cb.ConCodeId = refRole.Id AND cb.ConTableName = [dbo].fnGetEntityName(1)
	WHERE  cb.ContactMSTRID = @contactId
END;
GO

