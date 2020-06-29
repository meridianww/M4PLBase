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
			IF (@RoleType = 'Customer')
			BEGIN
				Select -1 as EntityId
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
			 IF(@isProgramEntity = 0)
				   BEGIN		
						CREATE TABLE #PROGRAMCUSTTREE (Id BIGINT, PrgCustId varchar(MAX), PrgProgramCode varchar(MAX),
						PrgProjectCode varchar(MAX), PrgPhaseCode varchar(MAX))
						INSERT INTO #PROGRAMCUSTTREE
						SELECT P.Id, P.PrgCustId, P.PrgProgramCode, P.PrgProjectCode, P.PrgPhaseCode FROM dbo.COMP000Master COMP
						INNER JOIN dbo.CUST000Master CUST ON COMP.CompPrimaryRecordId = CUST.Id 
						AND COMP.StatusId = 1 AND CUST.StatusId = 1 AND COMP.CompTableName = 'Customer'
						INNER JOIN  PRGRM000Master P ON CUST.Id = P.PrgCustID AND P.StatusId = 1
						INNER JOIN CONTC010Bridge CB ON CB.ConPrimaryRecordId = CUST.Id 
						AND CB.StatusId = 1 AND CB.ContactMSTRID = @UserContactId
						AND (CB.ConTableName = 'CustContact' OR CB.ConTableName = 'CustDcLocationContact') 
						LEFT JOIN CUST040DCLocations CL ON CB.ConPrimaryRecordId = CL.Id AND CB.StatusId = 1 
						AND CB.ContactMSTRID = @UserContactId AND CB.ConTableName = 'CustDcLocation'
					
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
									
					SELECT Id EntityId FROM #PROGRAMCUSTENTITY
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

				--DROP TABLE #PROGRAMTREE
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
				SELECT distinct Job.ID EntityId
				FROM dbo.COMP000Master COMP 
				INNER JOIN  dbo.CUST000Master CUST ON CUST.Id = COMP.CompPrimaryRecordId AND COMP.CompTableName = 'Customer'
				INNER JOIN dbo.PRGRM000Master Prg ON CUST.Id = Prg.PrgCustID
				INNER JOIN dbo.JOBDL000Master Job ON Prg.Id = Job.ProgramID AND Job.StatusId IN (1, 2) AND (JOB.JobSiteCode IS NOT NULL OR JOB.JobSiteCode != '')
				INNER JOIN dbo.CONTC010Bridge CB ON CUST.Id = CB.ConPrimaryRecordId AND CB.ConTableName = 'CustContact' 
				AND CB.StatusId = 1
				INNER JOIN dbo.CONTC000Master CON ON  CON.Id = CB.ContactMSTRID AND CON.Id=@UserContactId
			END
			ELSE
			BEGIN
				SELECT distinct Job.ID EntityId
				FROM dbo.COMP000Master COMP 
				INNER JOIN  dbo.CUST000Master CUST ON CUST.Id = COMP.CompPrimaryRecordId AND COMP.CompTableName = 'Customer'
				INNER JOIN dbo.PRGRM000Master Prg ON CUST.Id = Prg.PrgCustID
				INNER JOIN dbo.JOBDL000Master Job ON Prg.Id = Job.ProgramID AND Job.StatusId IN (1, 2) AND (JOB.JobSiteCode IS NOT NULL OR JOB.JobSiteCode != '')
				INNER JOIN dbo.CONTC010Bridge CB ON CUST.Id = CB.ConPrimaryRecordId AND CB.ConTableName = 'CustContact' 
				AND CB.StatusId = 1
				INNER JOIN dbo.CONTC000Master CON ON  CON.Id = CB.ContactMSTRID AND CON.Id=@UserContactId	
			END
			END
			IF (@RoleType = 'Vendor' OR @RoleType = 'Driver')
			BEGIN
				IF(@parentId =0) 
				BEGIN
				     SELECT DISTINCT JOB.ID EntityId FROM JOBDL000Master JOB
					 INNER JOIN PRGRM051VendorLocations PVL ON PVL.PvlProgramID = JOB.ProgramID
					 AND PVL.PvlLocationCode = JOB.JobSiteCode AND PVL.StatusId IN (1, 2)
					 AND PVL.PvlLocationCode = JOB.JobSiteCode
					 AND (JOB.JobSiteCode IS NOT NULL OR JOB.JobSiteCode != '')
					 AND JOB.StatusId IN (1, 2)  
					 INNER JOIN CONTC010Bridge CBR ON (CBR.ConPrimaryRecordId = PVL.VendDCLocationId
					 OR CBR.ConPrimaryRecordId = PVL.PvlVendorID)
					 AND CBR.ConTableName IN ('VendContact','VendDcLocationContact','VendDcLocation')
					 AND CBR.StatusId IN (1, 2) AND (CBR.ContactMSTRID =@UserContactId OR JOB.JobDriverId = @UserContactId)
					 LEFT JOIN JOBDL020Gateways JG  ON Job.Id = JG.JobID AND JG.StatusId IN (194,195) -- will chnage later
					 AND (JG.GwyGatewayAnalyst = @UserContactId OR JG.GwyGatewayResponsible = @UserContactId OR Job.JobDeliveryAnalystContactID = @UserContactId
					 OR Job.JobDeliveryResponsibleContactID = @UserContactId )
				END
			  ELSE
			  	BEGIN
					 SELECT DISTINCT JOB.ID EntityId FROM  PRGRM000Master PM
					 INNER JOIN PRGRM051VendorLocations PVL ON PM.Id =PVL.PvlProgramID AND PM.PrgCustID = @parentId
					 INNER JOIN JOBDL000Master JOB ON JOB.ProgramID = PVL.PvlProgramID
					 AND PVL.PvlLocationCode = JOB.JobSiteCode AND PVL.StatusId IN (1, 2)
					 AND PVL.PvlLocationCode = JOB.JobSiteCode    
					 AND (JOB.JobSiteCode IS NOT NULL OR JOB.JobSiteCode != '')
					 AND JOB.StatusId IN (1, 2)    
					 INNER JOIN CONTC010Bridge CBR ON (CBR.ConPrimaryRecordId = PVL.VendDCLocationId
					 OR CBR.ConPrimaryRecordId = PVL.PvlVendorID)
					 AND CBR.ConTableName IN ('VendContact','VendDcLocationContact','VendDcLocation')
					 AND CBR.StatusId IN (1, 2) AND (CBR.ContactMSTRID =@UserContactId OR JOB.JobDriverId = @UserContactId)
					 LEFT JOIN JOBDL020Gateways JG  ON Job.Id = JG.JobID AND JG.StatusId IN (194,195) -- will chnage later
					 AND (JG.GwyGatewayAnalyst = @UserContactId OR JG.GwyGatewayResponsible = @UserContactId OR Job.JobDeliveryAnalystContactID = @UserContactId
					 OR Job.JobDeliveryResponsibleContactID = @UserContactId )
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


