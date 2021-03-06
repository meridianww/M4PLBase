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
-- Execution:                 EXEC [dbo].[GetCustomEntityIdByEntityName] 20046, 20035,1,'job',0,1
-- =============================================   
CREATE PROCEDURE [dbo].[GetCustomEntityIdByJob] (@userId BIGINT, @roleId BIGINT, @orgId BIGINT, @entity NVARCHAR(100), @parentId BIGINT = 0, @isProgramEntity BIT = 0)
AS
BEGIN TRY
	SET NOCOUNT ON;

	DECLARE @IsSystemAdmin BIT = 0, @IsOrganizationEmplyee BIT = 0, @CompanyId BIGINT, @RoleType VARCHAR(100), @UserContactId BIGINT

	SELECT DISTINCT @IsSystemAdmin = CASE 
			WHEN ISNULL(SM.IsSysAdmin, 0) = 0
				THEN 0
			ELSE 1
			END, @IsOrganizationEmplyee = CASE 
			WHEN ISNULL(COMP.CompTableName, '') = 'Organization'
				THEN 1
			ELSE 0
			END, @CompanyId = COMP.Id, @RoleType = RO.SysOptionName, @UserContactId = SM.SysUserContactId
	FROM [dbo].[SYSTM000OpnSezMe] SM WITH (NOLOCK)
	INNER JOIN dbo.CONTC000Master CM WITH (NOLOCK) ON CM.Id = SM.SysUserContactID
	INNER JOIN dbo.COMP000Master COMP WITH (NOLOCK) ON COMP.Id = CM.ConCompanyId
	INNER JOIN dbo.ORGAN010Ref_Roles RR WITH (NOLOCK) ON RR.Id = SM.SysOrgRefRoleId
	LEFT JOIN CONTC010Bridge CB WITH (NOLOCK) ON SM.SysUserContactId = CB.ContactMSTRID
	LEFT JOIN dbo.SYSTM000Ref_Options RO WITH (NOLOCK) ON RO.Id = RR.RoleTypeId
	LEFT JOIN dbo.PRGRM020Program_Role PPR WITH (NOLOCK) ON PPR.PrgRoleId = RR.RoleTypeId
		AND PPR.PrgRoleContactID = @UserContactId
		AND PPR.StatusId = 1
	WHERE SM.Id = @userId
		AND COMP.CompOrgId = @orgId

	IF (
			ISNULL(@IsSystemAdmin, 0) = 1
			OR ISNULL(@IsOrganizationEmplyee, 0) = 1
			)
	BEGIN
		SELECT -1 EntityId, '' JobSiteCode, 0 ProgramID
	END
	ELSE
	BEGIN
		IF (@RoleType = 'Customer')
			BEGIN
				IF (@parentId = 0)
				BEGIN
					IF EXISTS (
							SELECT 1
							FROM CONTC010Bridge
							WHERE ConTableName = 'CustContact'
								AND StatusId = 1
								AND ContactMSTRID = @UserContactId
							)
					BEGIN
						SELECT DISTINCT Job.ID EntityId
						FROM dbo.vwJobMasterData Job(NOEXPAND)
						INNER JOIN dbo.CONTC010Bridge CB ON Job.CustomerId = CB.ConPrimaryRecordId
							AND CB.ConTableName = 'CustContact'
							AND CB.StatusId = 1
							AND CB.ContactMSTRID = @UserContactId
					END
					ELSE IF EXISTS (
							SELECT 1
							FROM PRGRM020Program_Role
							WHERE PrgRoleContactID = @UserContactId
								AND StatusId = 1
							)
					BEGIN
						SELECT DISTINCT Job.ID EntityId
						FROM dbo.vwJobMasterData Job(NOEXPAND)
						INNER JOIN PRGRM020Program_Role PPR ON PPR.ProgramID = Job.ProgramId
							AND PPR.StatusId = 1
							AND PPR.PrgRoleContactID = @UserContactId
					END
				END
				ELSE
				BEGIN
					IF EXISTS (
							SELECT 1
							FROM CONTC010Bridge
							WHERE ConTableName = 'CustContact'
								AND StatusId = 1
								AND ContactMSTRID = @UserContactId
							)
					BEGIN
						SELECT DISTINCT Job.ID EntityId
						FROM dbo.vwJobMasterData Job(NOEXPAND)
						INNER JOIN dbo.CONTC010Bridge CB ON Job.CustomerId = CB.ConPrimaryRecordId
							AND CB.ConTableName = 'CustContact'
							AND CB.StatusId = 1
							AND CB.ContactMSTRID = @UserContactId
							AND Job.CustomerId = @parentId
					END
					ELSE IF EXISTS (
							SELECT 1
							FROM PRGRM020Program_Role
							WHERE PrgRoleContactID = @UserContactId
								AND StatusId = 1
							)
					BEGIN
						SELECT DISTINCT Job.ID EntityId
						FROM dbo.vwJobMasterData Job(NOEXPAND)
						INNER JOIN PRGRM020Program_Role PPR ON PPR.ProgramID = Job.ProgramId
							AND PPR.StatusId = 1
							AND Job.CustomerId = @parentId
							AND PPR.PrgRoleContactID = @UserContactId
					END
				END
			END

			IF (
					@RoleType = 'Vendor'
					OR @RoleType = 'Driver'
					)
			BEGIN
				IF (@parentId = 0)
				BEGIN
					SELECT  PM.ID EntityId
					FROM [dbo].[vwVendorJobSecurity] PM(NOEXPAND)
					INNER JOIN CONTC010Bridge CBR ON (
							CBR.ConPrimaryRecordId = PM.VendDCLocationId
							OR CBR.ConPrimaryRecordId = PM.PvlVendorID
							)
						AND CBR.ConTableName IN ('VendContact', 'VendDcLocationContact', 'VendDcLocation')
						AND CBR.StatusId IN (1, 2)
						AND CBR.ContactMSTRID = @UserContactId
						--WHERE ISNULL(job.JobSiteCode, '') <> ''
						--OR (
						--	Job.JobDeliveryAnalystContactID = @UserContactId
						--	OR Job.JobDeliveryResponsibleContactID = @UserContactId
						--	OR JOB.JobDriverId = @UserContactId
						--	)
				END
				ELSE
				BEGIN
					SELECT PM.ID EntityId
					FROM [dbo].[vwVendorJobSecurity](NOEXPAND) PM
					INNER JOIN CONTC010Bridge CBR ON (
							CBR.ConPrimaryRecordId = PM.VendDCLocationId
							OR CBR.ConPrimaryRecordId = PM.PvlVendorID
							)
						AND CBR.ConTableName IN ('VendContact', 'VendDcLocationContact', 'VendDcLocation')
						AND CBR.StatusId IN (1, 2)
						AND CBR.ContactMSTRID = @UserContactId
						AND PM.PrgCustID = @parentId
						--WHERE ISNULL(job.JobSiteCode, '') <> ''
						--OR (
						--	Job.JobDeliveryAnalystContactID = @UserContactId
						--	OR Job.JobDeliveryResponsibleContactID = @UserContactId
						--	OR JOB.JobDriverId = @UserContactId
						--	)
				END
			END
	END
END TRY

BEGIN CATCH
	DECLARE @ErrorMessage VARCHAR(MAX) = (
			SELECT ERROR_MESSAGE()
			), @ErrorSeverity VARCHAR(MAX) = (
			SELECT ERROR_SEVERITY()
			), @RelatedTo VARCHAR(100) = (
			SELECT OBJECT_NAME(@@PROCID)
			)

	EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity
END CATCH
GO
