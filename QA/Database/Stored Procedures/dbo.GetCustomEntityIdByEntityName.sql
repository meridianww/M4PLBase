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
-- Execution:                 EXEC [dbo].[GetCustomEntityIdByEntityName_Bak] 20046, 20035,1,'job',0,1
-- =============================================   
ALTER PROCEDURE [dbo].[GetCustomEntityIdByEntityName] (@userId BIGINT, @roleId BIGINT, @orgId BIGINT, @entity NVARCHAR(100), @parentId BIGINT = 0, @isProgramEntity BIT = 0)
AS
BEGIN TRY
	SET NOCOUNT ON;

	DECLARE @PROGRAMCUSTTREE AS TABLE (Id BIGINT, PrgCustId VARCHAR(MAX), PrgProgramCode VARCHAR(MAX), PrgProjectCode VARCHAR(MAX), PrgPhaseCode VARCHAR(MAX), PrgHierarchyLevel SMALLINT)
	DECLARE @PROGRAMENTITY AS TABLE (Id BIGINT, PrgCustId VARCHAR(MAX), PrgProgramCode VARCHAR(MAX), PrgProjectCode VARCHAR(MAX), PrgPhaseCode VARCHAR(MAX))
	DECLARE @PROGRAMTREE AS TABLE (Id BIGINT, PrgCustId VARCHAR(MAX), PrgProgramCode VARCHAR(MAX), PrgProjectCode VARCHAR(MAX), PrgPhaseCode VARCHAR(MAX))
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
		SELECT - 1 AS EntityId
	END
	ELSE
	BEGIN
		IF (@entity = 'Customer')
		BEGIN
			IF (ISNULL(@isProgramEntity, 0) = 1)
			BEGIN
				IF EXISTS (
						SELECT 1
						FROM CONTC010Bridge CB
						WHERE CB.StatusId = 1
							AND CB.ContactMSTRID = @UserContactId
							AND CB.ConTableName = 'CustContact'
						)
				BEGIN
					SELECT CompPrimaryRecordId EntityId
					FROM dbo.COMP000Master COMP
					INNER JOIN dbo.CUST000Master CUST ON COMP.CompPrimaryRecordId = CUST.Id
						AND COMP.StatusId = 1
						AND CUST.StatusId = 1
						AND COMP.CompTableName = 'Customer'
					INNER JOIN CONTC010Bridge CB ON CB.ConPrimaryRecordId = CUST.Id
						AND CB.StatusId = 1
						AND CB.ConTableName = 'CustContact'
						AND CB.ContactMSTRID = @UserContactId
				END
				ELSE IF EXISTS (
						SELECT 1
						FROM PRGRM020Program_Role PPR
						WHERE PPR.StatusId = 1
							AND PPR.PrgRoleContactID = @UserContactId
						)
				BEGIN
					SELECT CompPrimaryRecordId EntityId
					FROM dbo.COMP000Master COMP
					INNER JOIN dbo.CUST000Master CUST ON COMP.CompPrimaryRecordId = CUST.Id
						AND COMP.StatusId = 1
						AND CUST.StatusId = 1
						AND COMP.CompTableName = 'Customer'
					INNER JOIN PRGRM000Master P ON CUST.Id = P.PrgCustID
						AND P.StatusId = 1
					INNER JOIN PRGRM020Program_Role PPR ON PPR.ProgramID = P.Id
						AND PPR.StatusId = 1
						AND PPR.PrgRoleContactID = @UserContactId
				END
			END
			ELSE
			BEGIN
				SELECT CompPrimaryRecordId EntityId
				FROM dbo.COMP000Master
				WHERE CompTableName = 'Customer'
					AND Id = @CompanyId
			END
		END
		ELSE IF (@entity = 'Vendor')
		BEGIN
			IF (@RoleType = 'Customer')
			BEGIN
				SELECT DISTINCT PVL.PvlVendorID EntityId
				FROM PRGRM000Master PRG
				INNER JOIN PRGRM051VendorLocations PVL ON PRG.Id = PVL.PvlProgramID
					AND PVL.StatusId IN (1, 2)
					AND PRG.StatusId IN (1, 2)
				INNER JOIN CONTC010Bridge CB ON CB.ConPrimaryRecordId = PRG.PrgCustID
					AND CB.ContactMSTRID = @UserContactId
			END
			ELSE
			BEGIN
				SELECT CompPrimaryRecordId EntityId
				FROM dbo.COMP000Master
				WHERE CompTableName = 'Vendor'
					AND Id = @CompanyId
			END
		END
		ELSE IF (@entity = 'Program')
		BEGIN
			IF (@RoleType = 'Customer')
			BEGIN
				IF EXISTS (
						SELECT 1
						FROM CONTC010Bridge CB
						WHERE CB.StatusId = 1
							AND CB.ContactMSTRID = @UserContactId
							AND CB.ConTableName = 'CustContact'
						)
				BEGIN
					INSERT INTO @PROGRAMCUSTTREE
					SELECT P.Id, P.PrgCustId, P.PrgProgramCode, P.PrgProjectCode, P.PrgPhaseCode, P.PrgHierarchyLevel
					FROM dbo.COMP000Master COMP
					INNER JOIN dbo.CUST000Master CUST ON COMP.CompPrimaryRecordId = CUST.Id
						AND COMP.StatusId = 1
						AND CUST.StatusId = 1
						AND COMP.CompTableName = 'Customer'
					INNER JOIN PRGRM000Master P ON CUST.Id = P.PrgCustID
						AND P.StatusId = 1
					INNER JOIN CONTC010Bridge CB ON CB.ConPrimaryRecordId = CUST.Id
						AND CB.StatusId = 1
						AND CB.ConTableName = 'CustContact'
						AND CB.ContactMSTRID = @UserContactId
				END
				ELSE IF EXISTS (
						SELECT 1
						FROM PRGRM020Program_Role PPR
						WHERE PPR.StatusId = 1
							AND PPR.PrgRoleContactID = @UserContactId
						)
				BEGIN
					INSERT INTO @PROGRAMCUSTTREE
					SELECT P.Id, P.PrgCustId, P.PrgProgramCode, P.PrgProjectCode, P.PrgPhaseCode, P.PrgHierarchyLevel
					FROM PRGRM000Master P
					INNER JOIN PRGRM020Program_Role PPR ON PPR.ProgramID = P.Id
						AND PPR.StatusId = 1
						AND PPR.PrgRoleContactID = @UserContactId
				END

				IF EXISTS (
						SELECT 1
						FROM @PROGRAMCUSTTREE
						)
				BEGIN
					IF (@isProgramEntity = 0)
					BEGIN
						INSERT INTO @PROGRAMCUSTTREE
						SELECT P.Id EntityId, p.PrgCustId, p.PrgProgramCode, p.PrgProjectCode, p.PrgPhaseCode, p.PrgHierarchyLevel
						FROM PRGRM000Master P
						INNER JOIN @PROGRAMCUSTTREE PM ON P.PrgCustID = PM.PrgCustID
							AND (
								P.PrgProgramCode = CASE 
									WHEN PM.PrgHierarchyLevel = 3
										THEN PM.PrgProgramCode
									END
								AND P.PrgProjectCode = CASE 
									WHEN PM.PrgHierarchyLevel = 3
										THEN PM.PrgProjectCode
									END
								AND (
									ISNULL(P.PrgPhaseCode, '') = CASE 
										WHEN PM.PrgHierarchyLevel = 3
											THEN ''
										END
									OR ISNULL(P.PrgProjectCode, '') = CASE 
										WHEN PM.PrgHierarchyLevel = 3
											THEN ''
										END
									)
								)
						WHERE P.StatusId = 1

						INSERT INTO @PROGRAMCUSTTREE
						SELECT P.Id EntityId, p.PrgCustId, p.PrgProgramCode, p.PrgProjectCode, p.PrgPhaseCode, p.PrgHierarchyLevel
						FROM PRGRM000Master P
						INNER JOIN @PROGRAMCUSTTREE PM ON P.PrgCustID = PM.PrgCustID
							AND (
								ISNULL(P.PrgPhaseCode, '') = CASE 
									WHEN PM.PrgHierarchyLevel = 2
										THEN ''
									END
								AND ISNULL(P.PrgProjectCode, '') = CASE 
									WHEN PM.PrgHierarchyLevel = 2
										THEN ''
									END
								)
						WHERE P.StatusId = 1
					END

					SELECT DISTINCT Id EntityId
					FROM @PROGRAMCUSTTREE
					ORDER BY Id
				END
			END

			IF (
					@RoleType = 'Vendor'
					OR @RoleType = 'Driver'
					)
			BEGIN
				IF (@isProgramEntity = 0)
				BEGIN
					INSERT INTO @PROGRAMTREE
					SELECT P.Id, P.PrgCustId, P.PrgProgramCode, P.PrgProjectCode, P.PrgPhaseCode
					FROM dbo.COMP000Master COMP
					INNER JOIN dbo.VEND000Master VEND ON VEND.Id = COMP.CompPrimaryRecordId
						AND COMP.CompTableName = 'Vendor'
						AND COMP.Id = @CompanyId
					INNER JOIN PRGRM051VendorLocations PVL ON PVL.PvlVendorID = VEND.Id
						AND PVL.StatusId = 1
					INNER JOIN PRGRM000Master P ON p.id = pvl.pvlprogramid
					
					--UNION
					
					--SELECT P.Id, P.PrgCustId, P.PrgProgramCode, P.PrgProjectCode, P.PrgPhaseCode
					--FROM PRGRM000Master P
					--INNER JOIN JOBDL000Master Job ON Job.ProgramID = P.ID
					--WHERE ISNULL(job.JobSiteCode, '') <> ''
					--	OR (
					--		Job.JobDeliveryAnalystContactID = @UserContactId
					--		OR Job.JobDeliveryResponsibleContactID = @UserContactId
					--		OR JOB.JobDriverId = @UserContactId
					--		)

					SELECT Id EntityId
					FROM @PROGRAMTREE
					
					UNION
					
					SELECT P4.Id
					FROM PRGRM000Master P4
					INNER JOIN @PROGRAMTREE P ON P.PrgCustId = P4.PrgCustId
						AND P.PrgProgramCode = P4.PrgProgramCode
						AND P4.PrgProjectCode IS NULL
						AND P4.PrgPhaseCode IS NULL
					WHERE P.PrgProgramCode IS NOT NULL
						AND P.PrgProjectCode IS NOT NULL
						AND P.PrgPhaseCode IS NOT NULL
					
					UNION
					
					SELECT P3.Id
					FROM PRGRM000Master P3
					INNER JOIN @PROGRAMTREE P ON P.PrgCustId = P3.PrgCustId
						AND P.PrgProgramCode = P3.PrgProgramCode
						AND P.PrgProjectCode = P3.PrgProjectCode
						AND P3.PrgPhaseCode IS NULL
					WHERE P.PrgProgramCode IS NOT NULL
						AND P.PrgProjectCode IS NOT NULL
						AND P.PrgPhaseCode IS NOT NULL
					
					UNION
					
					SELECT P2.Id
					FROM PRGRM000Master P2
					INNER JOIN @PROGRAMTREE P ON P.PrgCustId = P2.PrgCustId
						AND P.PrgProgramCode = P2.PrgProgramCode
						AND P2.PrgProjectCode IS NULL
						AND P2.PrgPhaseCode IS NULL
					WHERE P.PrgProgramCode IS NOT NULL
						AND P.PrgProjectCode IS NOT NULL
						AND P.PrgPhaseCode IS NULL
					
					UNION
					
					SELECT PgdProgramID EntityId
					FROM [dbo].[PRGRM010Ref_GatewayDefaults]
					WHERE (
							PgdGatewayResponsible = @UserContactId
							OR PgdGatewayAnalyst = @UserContactId
							)
				END
				ELSE
				BEGIN
					INSERT INTO @PROGRAMENTITY
					SELECT P.Id, P.PrgCustId, P.PrgProgramCode, P.PrgProjectCode, P.PrgPhaseCode
					FROM dbo.COMP000Master COMP
					INNER JOIN dbo.VEND000Master VEND ON VEND.Id = COMP.CompPrimaryRecordId
						AND COMP.CompTableName = 'Vendor'
						AND COMP.Id = @CompanyId
					INNER JOIN PRGRM051VendorLocations PVL ON PVL.PvlVendorID = VEND.Id
						AND PVL.StatusId = 1
					INNER JOIN PRGRM000Master P ON p.id = pvl.pvlprogramid
					
					--UNION
					
					--SELECT P.Id, P.PrgCustId, P.PrgProgramCode, P.PrgProjectCode, P.PrgPhaseCode
					--FROM PRGRM000Master P
					--INNER JOIN JOBDL000Master Job ON Job.ProgramID = P.ID
					--WHERE ISNULL(job.JobSiteCode, '') <> ''
					--	OR (
					--		Job.JobDeliveryAnalystContactID = @UserContactId
					--		OR Job.JobDeliveryResponsibleContactID = @UserContactId
					--		)
					--	AND Job.StatusId = 1

					SELECT Id EntityId
					FROM @PROGRAMENTITY
					
					UNION
					
					SELECT PgdProgramID EntityId
					FROM [dbo].[PRGRM010Ref_GatewayDefaults]
					WHERE (
							PgdGatewayResponsible = @UserContactId
							OR PgdGatewayAnalyst = @UserContactId
							)
				END
			END
		END
		ELSE IF (@entity = 'Job')
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
						FROM dbo.vwCustomerJobSecurity Job(NOEXPAND)
						INNER JOIN dbo.CONTC010Bridge CB ON Job.PrgCustId = CB.ConPrimaryRecordId
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
						FROM dbo.vwCustomerJobSecurity Job(NOEXPAND)
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
						FROM dbo.vwCustomerJobSecurity Job(NOEXPAND)
						INNER JOIN dbo.CONTC010Bridge CB ON Job.PrgCustId = CB.ConPrimaryRecordId
							AND CB.ConTableName = 'CustContact'
							AND CB.StatusId = 1
							AND CB.ContactMSTRID = @UserContactId
							AND Job.PrgCustID = @parentId
					END
					ELSE IF EXISTS (
							SELECT 1
							FROM PRGRM020Program_Role
							WHERE PrgRoleContactID = @UserContactId
								AND StatusId = 1
							)
					BEGIN
						SELECT DISTINCT Job.ID EntityId
						FROM dbo.vwCustomerJobSecurity Job(NOEXPAND)
						INNER JOIN PRGRM020Program_Role PPR ON PPR.ProgramID = Job.ProgramId
							AND PPR.StatusId = 1
							AND Job.PrgCustID = @parentId
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
					SELECT DISTINCT PM.ID EntityId
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
					SELECT DISTINCT PM.ID EntityId
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