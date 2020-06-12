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
-- Execution:                 EXEC [dbo].[GetCustomEntityIdByEntityName] 10121, 10166,1,'Program'
-- =============================================   
ALTER PROCEDURE [dbo].[GetCustomEntityIdByEntityName]   (
	@userId BIGINT
	,@roleId BIGINT
	,@orgId BIGINT
	,@entity NVARCHAR(100)
	,@parentId BIGINT =0
	,@isProgramEntity BIT = 0
	)
AS
BEGIN TRY  
	SET NOCOUNT ON;
	
	DECLARE @IsSystemAdmin BIT = 0
		,@IsOrganizationEmplyee BIT = 0
		,@CompanyId BIGINT
		,@RoleType VARCHAR(100)
		,@UserContactId BIGINT
    IF OBJECT_ID('tempdb..#PROGRAMCUSTTREE') IS NOT NULL
	BEGIN
		DROP TABLE #PROGRAMCUSTTREE
	END
	 IF OBJECT_ID('tempdb..#PROGRAMENTITY') IS NOT NULL
	BEGIN
		DROP TABLE #PROGRAMENTITY
	END
	 IF OBJECT_ID('tempdb..#PROGRAMCUSTTREE') IS NOT NULL
	BEGIN
		DROP TABLE #PROGRAMCUSTTREE
	END
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
	WHERE SM.Id = @userId
		AND COMP.CompOrgId = @orgId

	IF (
			ISNULL(@IsSystemAdmin, 0) = 1
			OR ISNULL(@IsOrganizationEmplyee, 0) = 1
			)
	BEGIN
		Select -1 as EntityId
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
				IF(@isProgramEntity = 0)
				BEGIN		
					--SELECT Prg.ID EntityId
					--FROM PRGRM000Master Prg
					--INNER JOIN dbo.CUST000Master CUST ON CUST.Id = Prg.PrgCustID
					--INNER JOIN dbo.COMP000Master COMP ON COMP.CompPrimaryRecordId = CUST.Id
					--	AND COMP.CompTableName = 'Customer'
					--WHERE COMP.Id = @CompanyId
					CREATE TABLE #PROGRAMCUSTTREE (Id BIGINT, PrgCustId varchar(MAX), PrgProgramCode varchar(MAX), PrgProjectCode varchar(MAX), PrgPhaseCode varchar(MAX))
					INSERT INTO #PROGRAMCUSTTREE
					SELECT P.Id, P.PrgCustId, P.PrgProgramCode, P.PrgProjectCode, P.PrgPhaseCode FROM PRGRM000Master P 				
					INNER JOIN dbo.CUST000Master CUST ON CUST.Id = P.PrgCustID
					INNER JOIN dbo.COMP000Master COMP ON COMP.CompPrimaryRecordId = CUST.Id
						AND COMP.CompTableName = 'Customer'
					LEFT JOIN dbo.CUST040DCLocations CL ON CUST.Id = CL.CdcCustomerID AND CL.StatusId = 1
					WHERE (COMP.CompPrimaryRecordId IN (SELECT  CB.ConPrimaryRecordId FROM CONTC010Bridge CB 
					      WHERE CB.ContactMSTRID = @UserContactId
						   AND (CB.ConTableName = 'CustContact' OR CB.ConTableName = 'CustDcLocationContact') AND CB.StatusId = 1))
						  OR CL.Id in (SELECT  CB.ConPrimaryRecordId FROM CONTC010Bridge CB 
					      WHERE CB.ContactMSTRID = @UserContactId AND CB.ConTableName = 'CustDcLocation' AND CB.StatusId = 1)
					UNION
					SELECT P.Id, P.PrgCustId, P.PrgProgramCode, P.PrgProjectCode, P.PrgPhaseCode FROM PRGRM000Master P
					INNER JOIN JOBDL000Master J ON J.ProgramID = P.ID
					WHERE (J.JobDeliveryAnalystContactID = @UserContactId 
					OR J.JobDeliveryResponsibleContactID = @UserContactId) AND J.StatusId = 1
					
					SELECT Id EntityId FROM #PROGRAMCUSTTREE
					UNION
					SELECT P3.Id FROM PRGRM000Master P3
					INNER JOIN #PROGRAMCUSTTREE P ON P.PrgCustId=P3.PrgCustId AND P.PrgProgramCode = P3.PrgProgramCode AND P.PrgProjectCode = P3.PrgProjectCode AND P3.PrgPhaseCode IS NULL
					WHERE P.PrgProgramCode IS NOT NULL AND P.PrgProjectCode IS NOT NULL AND P.PrgPhaseCode IS NOT NULL
					UNION
					SELECT P2.Id FROM PRGRM000Master P2
					INNER JOIN #PROGRAMCUSTTREE P ON P.PrgCustId=P2.PrgCustId AND P.PrgProgramCode = P2.PrgProgramCode AND P2.PrgProjectCode IS NULL AND P2.PrgPhaseCode IS NULL
					WHERE P.PrgProgramCode IS NOT NULL AND P.PrgProjectCode IS NOT NULL AND P.PrgPhaseCode IS NULL
					UNION
					SELECT JG.ProgramID EntityId FROM JOBDL020Gateways JG
					WHERE (JG.GwyGatewayAnalyst = @UserContactId
					OR JG.GwyGatewayResponsible = @UserContactId)
				END
				ELSE
				BEGIN
					CREATE TABLE #PROGRAMCUSTENTITY (Id BIGINT, PrgCustId varchar(MAX), PrgProgramCode varchar(MAX), PrgProjectCode varchar(MAX), PrgPhaseCode varchar(MAX))
					INSERT INTO #PROGRAMCUSTENTITY
					SELECT P.Id, P.PrgCustId, P.PrgProgramCode, P.PrgProjectCode, P.PrgPhaseCode FROM PRGRM000Master P 				
					INNER JOIN dbo.CUST000Master CUST ON CUST.Id = P.PrgCustID
					INNER JOIN dbo.COMP000Master COMP ON COMP.CompPrimaryRecordId = CUST.Id
						AND COMP.CompTableName = 'Customer'
					LEFT JOIN dbo.CUST040DCLocations CL ON CUST.Id = CL.CdcCustomerID AND CL.StatusId = 1
					WHERE (COMP.CompPrimaryRecordId IN (SELECT  CB.ConPrimaryRecordId FROM CONTC010Bridge CB 
					      WHERE CB.ContactMSTRID = @UserContactId
						   AND (CB.ConTableName = 'CustContact' OR CB.ConTableName = 'CustDcLocationContact') AND CB.StatusId = 1))
						  OR CL.Id in (SELECT  CB.ConPrimaryRecordId FROM CONTC010Bridge CB 
					      WHERE CB.ContactMSTRID = @UserContactId AND CB.ConTableName = 'CustDcLocation' AND CB.StatusId = 1)
					UNION
					SELECT P.Id, P.PrgCustId, P.PrgProgramCode, P.PrgProjectCode, P.PrgPhaseCode FROM PRGRM000Master P
					INNER JOIN JOBDL000Master J ON J.ProgramID = P.ID
					WHERE (J.JobDeliveryAnalystContactID = @UserContactId 
					OR J.JobDeliveryResponsibleContactID = @UserContactId) AND J.StatusId = 1
					
					SELECT Id EntityId FROM #PROGRAMCUSTENTITY
					--UNION
					--SELECT P3.Id FROM PRGRM000Master P3
					--INNER JOIN #PROGRAMCUSTTREE P ON P.PrgCustId=P3.PrgCustId AND P.PrgProgramCode = P3.PrgProgramCode AND P.PrgProjectCode = P3.PrgProjectCode AND P3.PrgPhaseCode IS NULL
					--WHERE P.PrgProgramCode IS NOT NULL AND P.PrgProjectCode IS NOT NULL AND P.PrgPhaseCode IS NOT NULL
					--UNION
					--SELECT P2.Id FROM PRGRM000Master P2
					--INNER JOIN #PROGRAMCUSTTREE P ON P.PrgCustId=P2.PrgCustId AND P.PrgProgramCode = P2.PrgProgramCode AND P2.PrgProjectCode IS NULL AND P2.PrgPhaseCode IS NULL
					--WHERE P.PrgProgramCode IS NOT NULL AND P.PrgProjectCode IS NOT NULL AND P.PrgPhaseCode IS NULL
					UNION
					SELECT JG.ProgramID EntityId FROM JOBDL020Gateways JG
					WHERE (JG.GwyGatewayAnalyst = @UserContactId
					OR JG.GwyGatewayResponsible = @UserContactId) 	
				END
			END

			IF (@RoleType = 'Vendor' OR @RoleType = 'Driver')
			BEGIN
			IF(@isProgramEntity = 0)
			BEGIN
			CREATE TABLE #PROGRAMTREE (Id BIGINT, PrgCustId varchar(MAX), PrgProgramCode varchar(MAX), PrgProjectCode varchar(MAX), PrgPhaseCode varchar(MAX))

				INSERT INTO #PROGRAMTREE
				SELECT P.Id, P.PrgCustId, P.PrgProgramCode, P.PrgProjectCode, P.PrgPhaseCode FROM PRGRM000Master P 
				INNER JOIN PRGRM051VendorLocations PVL on p.id=pvl.pvlprogramid
				INNER JOIN dbo.VEND000Master VEND ON VEND.Id = PVL.PvlVendorID
				INNER JOIN dbo.COMP000Master COMP ON COMP.CompPrimaryRecordId = VEND.Id AND COMP.CompTableName = 'Vendor' --and prgcustid=	 --and pvl.StatusId = 1
				WHERE PVL.StatusId = 1 AND COMP.Id = @CompanyId
				UNION
				SELECT P.Id, P.PrgCustId, P.PrgProgramCode, P.PrgProjectCode, P.PrgPhaseCode FROM PRGRM000Master P
				INNER JOIN JOBDL000Master J ON J.ProgramID = P.ID
		        WHERE (J.JobDeliveryAnalystContactID = @UserContactId 
				OR J.JobDeliveryResponsibleContactID = @UserContactId) AND J.StatusId = 1

				SELECT Id EntityId FROM #PROGRAMTREE
				UNION
				SELECT P4.Id FROM PRGRM000Master P4
				INNER JOIN #PROGRAMTREE P ON P.PrgCustId=P4.PrgCustId AND P.PrgProgramCode = P4.PrgProgramCode AND P4.PrgProjectCode IS NULL AND P4.PrgPhaseCode IS NULL
				WHERE P.PrgProgramCode IS NOT NULL AND P.PrgProjectCode IS NOT NULL AND P.PrgPhaseCode IS NOT NULL
				UNION
				SELECT P3.Id FROM PRGRM000Master P3
				INNER JOIN #PROGRAMTREE P ON P.PrgCustId=P3.PrgCustId AND P.PrgProgramCode = P3.PrgProgramCode AND P.PrgProjectCode = P3.PrgProjectCode AND P3.PrgPhaseCode IS NULL
				WHERE P.PrgProgramCode IS NOT NULL AND P.PrgProjectCode IS NOT NULL AND P.PrgPhaseCode IS NOT NULL
				UNION
				SELECT P2.Id FROM PRGRM000Master P2
				INNER JOIN #PROGRAMTREE P ON P.PrgCustId=P2.PrgCustId AND P.PrgProgramCode = P2.PrgProgramCode AND P2.PrgProjectCode IS NULL AND P2.PrgPhaseCode IS NULL
				WHERE P.PrgProgramCode IS NOT NULL AND P.PrgProjectCode IS NOT NULL AND P.PrgPhaseCode IS NULL
				UNION 
				Select PgdProgramID EntityId From [dbo].[PRGRM010Ref_GatewayDefaults]
				Where (PgdGatewayResponsible = @UserContactId OR PgdGatewayAnalyst = @UserContactId)
			END
			ELSE
			BEGIN
				CREATE TABLE #PROGRAMENTITY (Id BIGINT, PrgCustId varchar(MAX), PrgProgramCode varchar(MAX), PrgProjectCode varchar(MAX), PrgPhaseCode varchar(MAX))

				INSERT INTO #PROGRAMENTITY
				SELECT P.Id, P.PrgCustId, P.PrgProgramCode, P.PrgProjectCode, P.PrgPhaseCode FROM PRGRM000Master P 
				INNER JOIN PRGRM051VendorLocations PVL on p.id=pvl.pvlprogramid
				INNER JOIN dbo.VEND000Master VEND ON VEND.Id = PVL.PvlVendorID
				INNER JOIN dbo.COMP000Master COMP ON COMP.CompPrimaryRecordId = VEND.Id AND COMP.CompTableName = 'Vendor' --and prgcustid=	 --and pvl.StatusId = 1
				WHERE PVL.StatusId = 1 AND COMP.Id = @CompanyId
				UNION
				SELECT P.Id, P.PrgCustId, P.PrgProgramCode, P.PrgProjectCode, P.PrgPhaseCode FROM PRGRM000Master P
				INNER JOIN JOBDL000Master J ON J.ProgramID = P.ID
		        WHERE (J.JobDeliveryAnalystContactID = @UserContactId 
				OR J.JobDeliveryResponsibleContactID = @UserContactId) AND J.StatusId = 1

				SELECT Id EntityId FROM #PROGRAMENTITY
				--UNION
				--SELECT P4.Id FROM PRGRM000Master P4
				--INNER JOIN #PROGRAMENTITY P ON P.PrgCustId=P4.PrgCustId AND P.PrgProgramCode = P4.PrgProgramCode AND P4.PrgProjectCode IS NULL AND P4.PrgPhaseCode IS NULL
				--WHERE P.PrgProgramCode IS NOT NULL AND P.PrgProjectCode IS NOT NULL AND P.PrgPhaseCode IS NOT NULL
				--UNION
				--SELECT P3.Id FROM PRGRM000Master P3
				--INNER JOIN #PROGRAMENTITY P ON P.PrgCustId=P3.PrgCustId AND P.PrgProgramCode = P3.PrgProgramCode AND P.PrgProjectCode = P3.PrgProjectCode AND P3.PrgPhaseCode IS NULL
				--WHERE P.PrgProgramCode IS NOT NULL AND P.PrgProjectCode IS NOT NULL AND P.PrgPhaseCode IS NOT NULL
				--UNION
				--SELECT P2.Id FROM PRGRM000Master P2
				--INNER JOIN #PROGRAMENTITY P ON P.PrgCustId=P2.PrgCustId AND P.PrgProgramCode = P2.PrgProgramCode AND P2.PrgProjectCode IS NULL AND P2.PrgPhaseCode IS NULL
				--WHERE P.PrgProgramCode IS NOT NULL AND P.PrgProjectCode IS NOT NULL AND P.PrgPhaseCode IS NULL
				UNION 
				Select PgdProgramID EntityId From [dbo].[PRGRM010Ref_GatewayDefaults]
				Where (PgdGatewayResponsible = @UserContactId OR PgdGatewayAnalyst = @UserContactId)
			END

			END
		END
		ELSE IF (@entity = 'Job')
		BEGIN
			IF (@RoleType = 'Customer')
			BEGIN
			IF(@parentId =0) 
			BEGIN
				SELECT Job.ID EntityId
				FROM dbo.JOBDL000Master Job
				INNER JOIN dbo.PRGRM000Master Prg ON Prg.id = Job.ProgramID
				INNER JOIN dbo.CUST000Master CUST ON CUST.Id = Prg.PrgCustID
				INNER JOIN dbo.COMP000Master COMP ON COMP.CompPrimaryRecordId = CUST.Id
					AND COMP.CompTableName = 'Customer'
				WHERE (COMP.CompPrimaryRecordId IN (SELECT  CB.ConPrimaryRecordId FROM CONTC010Bridge CB 
				      WHERE CB.ContactMSTRID = @UserContactId AND CB.ConTableName = 'CustContact' AND CB.StatusId = 1 ))
				
				UNION
				SELECT J.Id EntityId FROM JOBDL000Master J 
				WHERE (J.JobDeliveryAnalystContactID = @UserContactId 
				   OR J.JobDeliveryResponsibleContactID = @UserContactId) AND J.StatusId = 1 
				UNION
				SELECT J.Id EntityId FROM JOBDL000Master J
				INNER JOIN JOBDL020Gateways JG ON J.Id = JG.JobID
				WHERE (JG.GwyGatewayAnalyst = @UserContactId
				OR JG.GwyGatewayResponsible = @UserContactId) 
			END
			ELSE
			BEGIN
				SELECT Job.ID EntityId
				FROM dbo.JOBDL000Master Job
				INNER JOIN dbo.PRGRM000Master Prg ON Prg.id = Job.ProgramID
				INNER JOIN dbo.CUST000Master CUST ON CUST.Id = Prg.PrgCustID
				INNER JOIN dbo.COMP000Master COMP ON COMP.CompPrimaryRecordId = CUST.Id
					AND COMP.CompTableName = 'Customer'
				WHERE (COMP.CompPrimaryRecordId IN (SELECT  CB.ConPrimaryRecordId FROM CONTC010Bridge CB 
				      WHERE CB.ContactMSTRID = @UserContactId AND CB.ConTableName = 'CustContact' AND CB.StatusId = 1 ))				
				UNION
				SELECT J.Id EntityId FROM JOBDL000Master J 
				WHERE (J.JobDeliveryAnalystContactID = @UserContactId  
				OR J.JobDeliveryResponsibleContactID = @UserContactId) AND J.StatusId = 1
				UNION
				SELECT J.Id EntityId FROM JOBDL000Master J
				INNER JOIN JOBDL020Gateways JG ON J.Id = JG.JobID
				WHERE (JG.GwyGatewayAnalyst = @UserContactId
				OR JG.GwyGatewayResponsible = @UserContactId) 
			END
			END
			IF (@RoleType = 'Vendor' OR @RoleType = 'Driver')
			BEGIN
				--SELECT Job.ID EntityId
				--FROM dbo.JOBDL000Master Job
				--INNER JOIN PRGRM051VendorLocations PVL ON PVL.PvlProgramID = Job.ProgramId
				--INNER JOIN dbo.VEND000Master VEND ON VEND.Id = PVL.PvlVendorID
				--INNER JOIN dbo.COMP000Master COMP ON COMP.CompPrimaryRecordId = VEND.Id
				--	AND COMP.CompTableName = 'Vendor'
				--WHERE COMP.Id = @CompanyId
				
				--UNION
				IF(@parentId =0) 
				BEGIN
					--SELECT JOB.ID EntityId FROM JOBDL000Master JOB 
					--INNER JOIN PRGRM051VendorLocations PVL ON PVL.PvlProgramID = JOB.ProgramID AND PVL.PvlLocationCode = JOB.JobSiteCode
					--INNER JOIN VEND000Master VEND ON VEND.ID = PVL.PvlVendorID
					--WHERE (VEND.VendWorkAddressId = @UserContactId 
					--OR VEND.VendBusinessAddressId = @UserContactId 
					--OR VEND.VendCorporateAddressId = @UserContactId) 
					--AND VEND.StatusId IN (1, 2) AND JOB.StatusId IN (1, 2) AND PVL.StatusId IN (1, 2)
					--UNION
				    SELECT JOB.ID EntityId FROM JOBDL000Master JOB 
					INNER JOIN PRGRM051VendorLocations PVL ON PVL.PvlProgramID = JOB.ProgramID AND PVL.PvlLocationCode = JOB.JobSiteCode
					INNER JOIN CONTC010Bridge CB ON CB.ConPrimaryRecordId = PVL.PvlVendorID
					WHERE CB.ContactMSTRID = @UserContactId  AND (JOB.JobSiteCode IS NOT NULL OR JOB.JobSiteCode != '')
					AND CB.StatusId IN (1, 2) AND JOB.StatusId IN (1, 2) AND PVL.StatusId IN (1, 2)
					AND CB.ConTableName = 'VendContact'		
					UNION
					SELECT JOB.ID EntityId FROM JOBDL000Master JOB
					INNER JOIN PRGRM051VendorLocations PVL ON PVL.PvlProgramID = JOB.ProgramID AND PVL.PvlLocationCode = JOB.JobSiteCode
					INNER JOIN CONTC010Bridge CB ON CB.ConPrimaryRecordId = PVL.VendDCLocationId
					WHERE CB.ContactMSTRID = @UserContactId  AND (JOB.JobSiteCode IS NOT NULL OR JOB.JobSiteCode != '')
					AND JOB.StatusId IN (1, 2) AND PVL.StatusId IN (1, 2)
					AND CB.ConTableName IN ('VendDcLocationContact','VendDcLocation')
					UNION
					SELECT Id EntityId
					FROM JOBDL000Master
					WHERE (JobSiteCode IS NOT NULL OR JobSiteCode != '') AND (JobDeliveryResponsibleContactID = @UserContactId
						OR JobDeliveryAnalystContactID = @UserContactId
						OR JobDriverId = @UserContactId)
						UNION
					SELECT J.Id EntityId FROM JOBDL000Master J
					INNER JOIN JOBDL020Gateways JG ON J.Id = JG.JobID AND (J.JobSiteCode IS NOT NULL AND J.JobSiteCode != '')
					WHERE JG.GwyGatewayAnalyst = @UserContactId
					OR JG.GwyGatewayResponsible = @UserContactId
				  
				END
			  ELSE
			  	BEGIN	
					 --   SELECT JOB.ID EntityId FROM JOBDL000Master JOB 
						--INNER JOIN PRGRM051VendorLocations PVL ON PVL.PvlProgramID = JOB.ProgramID AND PVL.PvlLocationCode = JOB.JobSiteCode
						--INNER JOIN VEND000Master VEND ON VEND.ID = PVL.PvlVendorID
						--INNER JOIN PRGRM000Master PM ON PM.ID = PVL.PvlProgramID  
						--WHERE (VEND.VendWorkAddressId = @UserContactId 
						--OR VEND.VendBusinessAddressId = @UserContactId 
						--OR VEND.VendCorporateAddressId = @UserContactId) 
						--AND VEND.StatusId IN (1, 2) AND JOB.StatusId IN (1, 2) AND PVL.StatusId IN (1, 2)
						--AND PM.PRGCUSTID = @parentId 
						--UNION
						SELECT JOB.ID EntityId FROM JOBDL000Master JOB 
						INNER JOIN PRGRM051VendorLocations PVL ON PVL.PvlProgramID = JOB.ProgramID AND PVL.PvlLocationCode = JOB.JobSiteCode
						INNER JOIN CONTC010Bridge CB ON CB.ConPrimaryRecordId = PVL.PvlVendorID
						INNER JOIN PRGRM000Master PM ON PM.ID = PVL.PvlProgramID  
						WHERE CB.ContactMSTRID = @UserContactId  AND (JOB.JobSiteCode IS NOT NULL OR JOB.JobSiteCode != '')
						AND CB.StatusId IN (1, 2) AND JOB.StatusId IN (1, 2) AND PVL.StatusId IN (1, 2)
						AND CB.ConTableName = 'VendContact' 
						AND PM.PRGCUSTID = @parentId 
						UNION
						SELECT JOB.ID EntityId FROM JOBDL000Master JOB
						INNER JOIN PRGRM051VendorLocations PVL ON PVL.PvlProgramID = JOB.ProgramID AND PVL.PvlLocationCode = JOB.JobSiteCode
						INNER JOIN CONTC010Bridge CB ON CB.ConPrimaryRecordId = PVL.VendDCLocationId
						INNER JOIN PRGRM000Master PM ON PM.ID = PVL.PvlProgramID  
						WHERE CB.ContactMSTRID = @UserContactId  AND (JOB.JobSiteCode IS NOT NULL OR JOB.JobSiteCode != '')
						AND JOB.StatusId IN (1, 2) AND PVL.StatusId IN (1, 2)
						AND CB.ConTableName IN ('VendDcLocationContact','VendDcLocation')
						AND PM.PRGCUSTID = @parentId
					UNION
					SELECT JOB.Id EntityId
					FROM JOBDL000Master JOB
						INNER JOIN PRGRM000Master PM ON PM.ID = JOB.ProgramID  
						WHERE PM.PRGCUSTID = @parentId AND (JOB.JobSiteCode IS NOT NULL OR JOB.JobSiteCode != '')  AND (JOB.JobDeliveryResponsibleContactID = @UserContactId
						OR JOB.JobDeliveryAnalystContactID = @UserContactId
						OR JOB.JobDriverId = @UserContactId)
				  UNION
				  SELECT JOB.Id EntityId
					FROM JOBDL000Master JOB
					INNER JOIN JOBDL020Gateways JOBGATE ON JOB.Id = JOBGATE.JobID
					INNER JOIN PRGRM000Master PM ON PM.ID = JOBGATE.ProgramID  
					WHERE PM.PRGCUSTID = @parentId AND (JOB.JobSiteCode IS NOT NULL AND JOB.JobSiteCode != '') AND ( JOBGATE.GwyGatewayAnalyst = @UserContactId
						OR JOBGATE.GwyGatewayResponsible = @UserContactId)
				END
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
