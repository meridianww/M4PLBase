SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal	
-- Create date: 10/09/2020
-- Description:	Is User have permission to view the job 
-- Sample Call EXEC [dbo].[IsUserHasVendorPermission] 20075,'V-80000'
-- =============================================
CREATE PROCEDURE [dbo].[IsUserHasVendorPermission] @userId BIGINT
	,@VendorErpId VARCHAR(150)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @IsSystemAdmin BIT = 0
		,@IsOrganizationEmplyee BIT = 0
		,@CompanyId BIGINT
		,@RoleType VARCHAR(100)
		,@UserContactId BIGINT
		,@IsPermissionPresent BIT

	SELECT DISTINCT @IsSystemAdmin = CASE 
			WHEN ISNULL(SM.IsSysAdmin, 0) = 0
				THEN 0
			ELSE 1
			END
		,@IsOrganizationEmplyee = CASE 
			WHEN ISNULL(COMP.CompTableName, '') = 'Organization'
				THEN 1
			ELSE 0
			END
		,@CompanyId = COMP.Id
		,@RoleType = RO.SysOptionName
		,@UserContactId = SM.SysUserContactId
	FROM [dbo].[SYSTM000OpnSezMe] SM WITH (NOLOCK)
	LEFT JOIN CONTC010Bridge CB WITH (NOLOCK) ON SM.SysUserContactId = CB.ContactMSTRID
	INNER JOIN dbo.CONTC000Master CM WITH (NOLOCK) ON CM.Id = SM.SysUserContactID
	INNER JOIN dbo.COMP000Master COMP WITH (NOLOCK) ON COMP.Id = CM.ConCompanyId
	INNER JOIN dbo.ORGAN010Ref_Roles RR WITH (NOLOCK) ON RR.Id = SM.SysOrgRefRoleId
	LEFT JOIN dbo.SYSTM000Ref_Options RO WITH (NOLOCK) ON RO.Id = RR.RoleTypeId
	LEFT JOIN dbo.PRGRM020Program_Role PPR WITH (NOLOCK) ON PPR.PrgRoleId = RR.RoleTypeId
		AND PPR.PrgRoleContactID = @UserContactId
		AND PPR.StatusId = 1
	WHERE SM.Id = @userId
		AND COMP.CompOrgId = 1

	IF (
			ISNULL(@IsSystemAdmin, 0) = 1
			OR ISNULL(@IsOrganizationEmplyee, 0) = 1
			)
	BEGIN
		SET @IsPermissionPresent = 1
	END
	ELSE
	BEGIN
		IF (@RoleType = 'Customer')
		BEGIN
			SELECT @IsPermissionPresent = CASE 
					WHEN ISNULL(Vendor.VendERPId, '') <> ''
						THEN 1
					ELSE 0
					END
			FROM PRGRM000Master PRG
			INNER JOIN PRGRM051VendorLocations PVL ON PRG.Id = PVL.PvlProgramID
				AND PVL.StatusId IN (1, 2)
				AND PRG.StatusId IN (1, 2)
			INNER JOIN dbo.Vend000Master Vendor ON Vendor.Id = PVL.PvlVendorID
			INNER JOIN CONTC010Bridge CB ON CB.ConPrimaryRecordId = PRG.PrgCustID
				AND CB.ContactMSTRID = @UserContactId
			WHERE Vendor.VendERPId = @VendorErpId
		END
		ELSE
		BEGIN
			SELECT @IsPermissionPresent = CASE 
					WHEN ISNULL(Vendor.VendERPId, '') <> ''
						THEN 1
					ELSE 0
					END
			FROM dbo.COMP000Master COMP
			INNER JOIN dbo.Vend000Master Vendor ON Vendor.Id = COMP.CompPrimaryRecordId
			WHERE COMP.CompTableName = 'Vendor'
				AND COMP.Id = @CompanyId
				AND Vendor.VendERPId = @VendorErpId
		END
	END

	SELECT CASE 
			WHEN ISNULL(@IsPermissionPresent, 0) = 0
				THEN CAST(0 AS BIT)
			ELSE CAST(1 AS BIT)
			END
END
GO

