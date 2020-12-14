SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group 
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Kamal         
-- Create date:               12/30/2019      
-- Description:               Get all program code by customer ID
-- Execution:                 EXEC [dbo].[GetRecordsByCustomerEnity1] 1,,1
-- Modified on:  
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[GetRecordsByCustomerEnity] 
	 @orgId BIGINT = 1
	,@userId BIGINT = 0
	,@roleId BIGINT = 0
	,@entity NVARCHAR(40)
AS
BEGIN TRY
	DECLARE @JobCount BIGINT,@IsJobAdmin BIT = 0

IF(@userId <> 0 AND @roleId <> 0)
BEGIN
----------------------------------Security entity ids for job------------------------------------------------
	IF OBJECT_ID('tempdb..#EntityIdJobTemp') IS NOT NULL
	BEGIN
	DROP TABLE #EntityIdJobTemp
	END
	
	 CREATE TABLE #EntityIdJobTemp
	(
		EntityId BIGINT PRIMARY KEY
	)
	
	INSERT INTO #EntityIdJobTemp
	EXEC [dbo].[GetCustomEntityIdByEntityName] @userId, @roleId,@orgId,'Job'

	SELECT @JobCount = Count(ISNULL(EntityId, 0))
	FROM #EntityIdJobTemp
	WHERE ISNULL(EntityId, 0) = -1
	IF (@JobCount = 1)
	BEGIN
		SET @IsJobAdmin = 1
	END 
-----------------------------------------------End-----------------------------------------------------------
----------------------------------Security entity ids for program--------------------------------------------
	IF OBJECT_ID('tempdb..#EntityIdProgamTemp') IS NOT NULL
	BEGIN
	DROP TABLE #EntityIdProgamTemp
	END
	
	 CREATE TABLE #EntityIdProgamTemp
	(
		EntityId BIGINT PRIMARY KEY
	)
	
	INSERT INTO #EntityIdProgamTemp
	EXEC [dbo].[GetCustomEntityIdByEntityName] @userId, @roleId,@orgId,'Program',0,1
-----------------------------------------------End--------------------------------------------------------
END
	
	     IF(ISNULL(@IsJobAdmin, 0) = 0 AND @userId <> 0 AND @roleId <> 0)
			BEGIN
			     --- program---
				 IF (@entity = 'Program')
				 BEGIN
					 SELECT DISTINCT  prg.Id, prg.PrgProgramCode AS ProgramCode,
					 prg.PrgProgramTitle as ProgramTitle FROM PRGRM000Master  prg
					 INNER JOIN #EntityIdProgamTemp tmp ON prg.[Id] = tmp.[EntityId]
					 AND prg.PrgOrgID = 1 AND  prg.StatusId =1	
				 END
			     --- origin ---
				 ELSE IF (@entity = 'Origin')
				 BEGIN
					 SELECT DISTINCT job.PlantIDCode AS Origin FROM PRGRM000Master PRG 
		   			 INNER JOIN  JOBDL000Master job ON job.ProgramID =PRG.Id AND PRG.PrgOrgID = 1 AND PRG.StatusId =1 
		   			 INNER JOIN #EntityIdJobTemp tmp ON job.[Id] = tmp.[EntityId] 
					 AND job.StatusId IN (1,2) AND ISNULL(job.PlantIDCode,'') <> ''		   	     		   	     
				 END
				 --- destination ---
				 ELSE IF (@entity = 'Destination')
				 BEGIN
					 SELECT DISTINCT job.JobSiteCode AS Destination FROM PRGRM000Master prg 
					 INNER JOIN JOBDL000Master job ON job.ProgramID = prg.Id AND prg.PrgOrgID = 1 AND prg.StatusId =1
					 INNER JOIN #EntityIdJobTemp tmp ON job.[Id] = tmp.[EntityId] AND ISNULL(job.JobSiteCode,'') <> ''
					 AND job.StatusId IN (1,2) 
				 END
				 --- Brand ---
				  ELSE IF (@entity = 'Brand')
				  BEGIN
					 SELECT DISTINCT JobCarrierContract AS Brand FROM PRGRM000Master prg
					 INNER JOIN JOBDL000Master job ON  job.ProgramID = prg.Id AND prg.PrgOrgID = 1 AND prg.StatusId =1
					 INNER JOIN #EntityIdJobTemp tmp ON job.[Id] = tmp.[EntityId] 
					 AND job.StatusId IN (1,2) AND ISNULL(job.JobCarrierContract,'') <> ''
				  END
				  --- Gateway Status ---
				  ELSE IF (@entity = 'GatewayStatus')
				 BEGIN
					 SELECT DISTINCT CASE WHEN GatewayTypeId = 85 THEN PgdGatewayCode ELSE PgdGatewayTitle END AS 
					 GatewayStatus FROM PRGRM000Master prg
					 INNER JOIN #EntityIdProgamTemp tmp ON prg.[Id] = tmp.[EntityId] AND prg.PrgOrgID = 1 AND prg.StatusId =1
					 INNER JOIN PRGRM010Ref_GatewayDefaults gateway ON gateway.PgdProgramID = prg.Id 
					 INNER JOIN SYSTM000Ref_Options sysref ON sysref.Id = gateway.GatewayTypeId AND gateway.StatusId=1 AND sysref.SysLookupCode = 'GatewayType'
					 AND (sysref.SysOptionName = 'Gateway' OR  sysref.SysOptionName = 'Action')
				END
				 --- Service Mode ---
				 ELSE IF (@entity = 'ServiceMode')
		         BEGIN
					 SELECT DISTINCT JobServiceMode AS ServiceMode FROM PRGRM000Master prg
					 INNER JOIN JOBDL000Master job ON job.ProgramID = prg.Id AND prg.PrgOrgID = 1 AND prg.StatusId = 1	
					 INNER JOIN #EntityIdJobTemp tmp ON job.[Id] = tmp.[EntityId] 
					 AND job.StatusId IN (1,2) AND ISNULL(JobServiceMode,'') <> ''
				END
				 --- Product Type ---
				 ELSE IF (@entity = 'ProductType')
				 BEGIN
					SELECT DISTINCT JobProductType AS ProductType FROM PRGRM000Master prg
					INNER JOIN JOBDL000Master job ON job.ProgramID = prg.Id AND prg.PrgOrgID = 1 AND prg.StatusId = 1
					INNER JOIN #EntityIdJobTemp tmp ON job.[Id] = tmp.[EntityId] 
					AND job.StatusId IN (1,2) AND ISNULL(JobProductType,'') <> ''
				 END
				--- Job Channel ---
				ELSE IF (@entity = 'JobChannel')
				BEGIN
					SELECT DISTINCT JobChannel AS JobChannel FROM PRGRM000Master prg
					INNER JOIN JOBDL000Master job ON job.ProgramID = prg.Id AND prg.PrgOrgID = 1 AND prg.StatusId = 1	
					INNER JOIN #EntityIdJobTemp tmp ON job.[Id] = tmp.[EntityId] 
					AND job.StatusId IN (1,2) AND ISNULL(JobChannel,'') <> ''
				END
				--- Cargo Title ---
				ELSE IF (@entity = 'CargoTitle')
				BEGIN
					select distinct top 500 CgoTitle AS CargoTitle from JOBDL000Master job
					INNER JOIN #EntityIdJobTemp tmp ON job.[Id] = tmp.[EntityId] AND job.StatusId = 1 AND job.JobCompleted = 0
					INNER JOIN JOBDL010Cargo cargo ON cargo.JobID = job.Id AND cargo.StatusId=1
				END
				--- Location ---
				ELSE IF (@entity = 'Location')
				BEGIN
					SELECT DISTINCT JobSiteCode AS [Location] FROM PRGRM000Master prg
					INNER JOIN JOBDL000Master job ON job.ProgramID = prg.Id AND prg.PrgOrgID = 1 AND prg.StatusId = 1	
					INNER JOIN #EntityIdJobTemp tmp ON job.[Id] = tmp.[EntityId] 
					AND job.StatusId IN (1,2) AND ISNULL(JobSiteCode,'') <> ''
				END
			END  
			ELSE
			BEGIN
				--- program---			    
				IF (@entity = 'Program')
				BEGIN
					 SELECT DISTINCT  prg.Id, prg.PrgProgramCode AS ProgramCode,
					 prg.PrgProgramTitle as ProgramTitle FROM PRGRM000Master  prg
					 WHERE  prg.PrgOrgID = 1 AND  prg.StatusId IN (1,2) 
				END				
				 -- origin --
				 ELSE IF (@entity = 'Origin')---security check required---
				BEGIN
					 SELECT DISTINCT job.PlantIDCode AS Origin FROM PRGRM000Master PRG 
		   			 INNER JOIN  JOBDL000Master job ON job.ProgramID =PRG.Id
		   			 AND PRG.PrgOrgID = 1 AND PRG.StatusId =1 
		   			 AND job.StatusId IN (1,2) AND ISNULL(job.PlantIDCode,'') <> ''
				 END
				  --- destination ---
				  ELSE IF (@entity = 'Destination')
				 BEGIN
					 SELECT DISTINCT job.JobSiteCode AS Destination FROM PRGRM000Master prg 
					 INNER JOIN JOBDL000Master job ON job.ProgramID = prg.Id AND prg.PrgOrgID = 1 AND prg.StatusId =1
					 AND ISNULL(job.JobSiteCode,'') <> '' AND job.StatusId IN (1,2) 
				END
				 --- Brand ---
				  ELSE IF (@entity = 'Brand')
				  BEGIN
					 SELECT DISTINCT JobCarrierContract AS Brand FROM PRGRM000Master prg
					 INNER JOIN JOBDL000Master job ON  job.ProgramID = prg.Id AND prg.PrgOrgID = 1 AND prg.StatusId =1
					 AND JOB.StatusId IN (1,2) AND ISNULL(job.JobCarrierContract,'') <> ''
				 END
				 --- Gateway Status ---
				 ELSE IF (@entity = 'GatewayStatus')
				 BEGIN
					 SELECT DISTINCT CASE WHEN GatewayTypeId = 85 THEN PgdGatewayCode ELSE PgdGatewayTitle END AS 
					 GatewayStatus FROM PRGRM000Master prg
					 INNER JOIN PRGRM010Ref_GatewayDefaults gateway ON gateway.PgdProgramID = prg.Id AND prg.PrgOrgID = 1 AND prg.StatusId =1
					 INNER JOIN SYSTM000Ref_Options sysref ON sysref.Id = gateway.GatewayTypeId AND gateway.StatusId=1 AND sysref.SysLookupCode = 'GatewayType'
					 AND (sysref.SysOptionName = 'Gateway' OR  sysref.SysOptionName = 'Action')
				 END
				 --- Service Mode ---				  
				  ELSE IF (@entity = 'ServiceMode')
		          BEGIN
					 SELECT DISTINCT JobServiceMode AS ServiceMode FROM PRGRM000Master prg
					 INNER JOIN JOBDL000Master job ON job.ProgramID = prg.Id AND prg.PrgOrgID = 1 AND prg.StatusId = 1			 
					 AND job.StatusId IN (1,2) AND ISNULL(JobServiceMode,'') <> ''
				  END
			   --- Product Type ---
			    ELSE IF (@entity = 'ProductType')
				BEGIN
					SELECT DISTINCT JobProductType AS ProductType FROM PRGRM000Master prg
					INNER JOIN JOBDL000Master job ON job.ProgramID = prg.Id AND prg.PrgOrgID = 1 AND prg.StatusId = 1			 
					AND job.StatusId IN (1,2) AND ISNULL(JobProductType,'') <> ''
				END
			    --- Job Channel ---
				ELSE IF (@entity = 'JobChannel')
				BEGIN
					SELECT DISTINCT JobChannel AS JobChannel FROM PRGRM000Master prg
					INNER JOIN JOBDL000Master job ON job.ProgramID = prg.Id AND prg.PrgOrgID = 1 AND prg.StatusId = 1			 
					AND job.StatusId IN (1,2) AND ISNULL(JobChannel,'') <> ''
				END
				--- Cargo Title ---
				ELSE IF (@entity = 'CargoTitle')
				BEGIN
					select distinct top 500 CgoTitle AS CargoTitle from JOBDL000Master job
					INNER JOIN JOBDL010Cargo cargo ON cargo.JobID = job.Id AND job.StatusId = 1 
					AND job.JobCompleted = 0 AND cargo.StatusId=1
				END
				--- Location ---
				ELSE IF (@entity = 'Location')
				BEGIN
					SELECT DISTINCT JobSiteCode AS [Location] FROM PRGRM000Master prg
					INNER JOIN JOBDL000Master job ON job.ProgramID = prg.Id AND prg.PrgOrgID = 1 AND prg.StatusId = 1			 
					AND job.StatusId IN (1,2) AND ISNULL(JobSiteCode,'') <> ''
				END
			END			
		    --- Status --
			   IF (@entity = 'JobStatus')
			   BEGIN
				   Select SysOptionName as JobStatusIdName from SYSTM000Ref_Options where SysLookupCode='Status' 
				   and ISNULL(Id,0) > 0 AND StatusId IN (1,2) AND SysOptionName <> 'All' ORDER BY SysOptionName		
			   END
			    --- Packaging Code --
			   ELSE IF (@entity = 'PackagingCode')
			   BEGIN		   
				   Select SysOptionName as PackagingCode from SYSTM000Ref_Options where SysLookupCode='PackagingCode' 
				   and ISNULL(Id,0) > 0  AND StatusId IN (1,2) AND SysOptionName <> 'All' ORDER BY SysOptionName
			   END
			--- Weight Unit ---
			   ELSE IF (@entity = 'WeightUnit')
			   BEGIN
				   Select SysOptionName as WeightUnit from SYSTM000Ref_Options where SysLookupCode='WeightUnittype' 
				   and ISNULL(Id,0) > 0  AND StatusId IN (1,2) AND SysOptionName <> 'All' ORDER BY SysOptionName
			   END
END TRY

BEGIN CATCH
	DECLARE @ErrorMessage VARCHAR(MAX) = (
			SELECT ERROR_MESSAGE()
			)
		,@ErrorSeverity VARCHAR(MAX) = (
			SELECT ERROR_SEVERITY()
			)
		,@RelatedTo VARCHAR(100) = (
			SELECT OBJECT_NAME(@@PROCID)
			)

	EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo
		,NULL
		,@ErrorMessage
		,NULL
		,NULL
		,@ErrorSeverity
END CATCH

GO
