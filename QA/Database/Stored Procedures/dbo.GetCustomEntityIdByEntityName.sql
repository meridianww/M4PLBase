SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Prashant Aggarwal       
-- Create date:               09/17/2019      
-- Description:               Get user securities 
-- Execution:                 EXEC [dbo].[GetCustomEntityIdByEntityName] 10013, 10036,1,'Customer'
-- =============================================   
CREATE PROCEDURE [dbo].[GetCustomEntityIdByEntityName] (
	@userId BIGINT
	,@roleId BIGINT
	,@orgId BIGINT
	,@entity NVARCHAR(100)
	)
AS
BEGIN TRY  
	SET NOCOUNT ON;

	DECLARE @IsSystemAdmin BIT = 0
		,@IsOrganizationEmplyee BIT = 0
		,@CompanyId BIGINT
		,@RoleType VARCHAR(100)
		,@UserContactId BIGINT

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
	FROM CONTC010Bridge CB WITH (NOLOCK)
	INNER JOIN dbo.CONTC000Master CM WITH (NOLOCK) ON CM.Id = CB.ContactMSTRID
	INNER JOIN dbo.COMP000Master COMP WITH (NOLOCK) ON COMP.Id = CM.ConCompanyId
	INNER JOIN [dbo].[SYSTM000OpnSezMe] SM WITH (NOLOCK) ON SM.SysUserContactId = CB.ContactMSTRID
	INNER JOIN dbo.ORGAN010Ref_Roles RR WITH (NOLOCK) ON RR.Id = SM.SysOrgRefRoleId
	LEFT JOIN dbo.SYSTM000Ref_Options RO WITH (NOLOCK) ON RO.Id = RR.RoleTypeId
	WHERE SM.Id = @userId
		AND COMP.CompOrgId = @orgId

	IF (
			ISNULL(@IsSystemAdmin, 0) = 1
			OR ISNULL(@IsOrganizationEmplyee, 0) = 1
			)
	BEGIN
		RETURN
	END
	ELSE
	BEGIN
		IF (@entity = 'Customer')
		BEGIN
			SELECT CompPrimaryRecordId EntityId
			FROM dbo.COMP000Master
			WHERE CompTableName = 'Customer'
				AND Id = @CompanyId
		END
		ELSE IF (@entity = 'Vendor')
		BEGIN
			SELECT CompPrimaryRecordId EntityId
			FROM dbo.COMP000Master
			WHERE CompTableName = 'Vendor'
				AND Id = @CompanyId
		END
		ELSE IF (@entity = 'Program')
		BEGIN
			IF (@RoleType = 'Customer')
			BEGIN
				SELECT Prg.ID EntityId
				FROM PRGRM000Master Prg
				INNER JOIN dbo.CUST000Master CUST ON CUST.Id = Prg.PrgCustID
				INNER JOIN dbo.COMP000Master COMP ON COMP.CompPrimaryRecordId = CUST.Id
					AND COMP.CompTableName = 'Customer'
				WHERE COMP.Id = @CompanyId
			END

			IF (@RoleType = 'Vendor')
			BEGIN
				SELECT PVL.PvlProgramID EntityId
				FROM PRGRM051VendorLocations PVL
				INNER JOIN dbo.VEND000Master VEND ON VEND.Id = PVL.PvlVendorID
				INNER JOIN dbo.COMP000Master COMP ON COMP.CompPrimaryRecordId = VEND.Id
					AND COMP.CompTableName = 'Vendor'
				WHERE COMP.Id = @CompanyId
			END
		END
		ELSE IF (@entity = 'Job')
		BEGIN
			IF (@RoleType = 'Customer')
			BEGIN
				SELECT Job.ID EntityId
				FROM dbo.JOBDL000Master Job
				INNER JOIN dbo.PRGRM000Master Prg ON Prg.id = Job.ProgramID
				INNER JOIN dbo.CUST000Master CUST ON CUST.Id = Prg.PrgCustID
				INNER JOIN dbo.COMP000Master COMP ON COMP.CompPrimaryRecordId = CUST.Id
					AND COMP.CompTableName = 'Customer'
				WHERE COMP.Id = @CompanyId
			END

			IF (@RoleType = 'Vendor')
			BEGIN
				SELECT Job.ID EntityId
				FROM dbo.JOBDL000Master Job
				INNER JOIN PRGRM051VendorLocations PVL ON PVL.PvlProgramID = Job.ProgramId
				INNER JOIN dbo.VEND000Master VEND ON VEND.Id = PVL.PvlVendorID
				INNER JOIN dbo.COMP000Master COMP ON COMP.CompPrimaryRecordId = VEND.Id
					AND COMP.CompTableName = 'Vendor'
				WHERE COMP.Id = @CompanyId
				
				UNION
				
				SELECT Id EntityId
				FROM JOBDL000Master
				WHERE JobDeliveryResponsibleContactID = @UserContactId
					OR JobDeliveryAnalystContactID = @UserContactId
					OR JobDriverId = @UserContactId
			END
		END
	END
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO

