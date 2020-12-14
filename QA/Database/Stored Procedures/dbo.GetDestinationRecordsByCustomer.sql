
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group 
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Kamal         
-- Create date:               12/14/2020      
-- Description:               Get all program code by customer ID
-- Execution:                 EXEC [dbo].[GetDestinationRecordsByCustomer] 0,1,2,14
-- Modified on:  
-- Modified Desc:  
-- ============================================= 
CREATE PROCEDURE [dbo].[GetDestinationRecordsByCustomer] 
     @CustomerId BIGINT =0
	,@orgId BIGINT = 1
	,@userId BIGINT = 0
	,@roleId BIGINT = 0
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
	   IF(@CustomerId > 0)
	   BEGIN
		   SELECT DISTINCT job.JobSiteCode AS Destination FROM PRGRM000Master prg 
		   INNER JOIN JOBDL000Master job ON job.ProgramID = prg.Id AND prg.PrgOrgID = 1 AND prg.StatusId =1 AND PRG.PRGCUSTID=@CustomerId
		   INNER JOIN #EntityIdJobTemp tmp ON job.[Id] = tmp.[EntityId] AND ISNULL(job.JobSiteCode,'') <> ''
		   AND job.StatusId IN (1,2)
	   END
	   ELSE
	   BEGIN
		   SELECT DISTINCT job.JobSiteCode AS Destination FROM PRGRM000Master prg 
		   INNER JOIN JOBDL000Master job ON job.ProgramID = prg.Id AND prg.PrgOrgID = 1 AND prg.StatusId =1 
		   INNER JOIN #EntityIdJobTemp tmp ON job.[Id] = tmp.[EntityId] AND ISNULL(job.JobSiteCode,'') <> ''
		   AND job.StatusId IN (1,2)
	   END
	END
ELSE
BEGIN
       IF(@CustomerId > 0)
	   BEGIN
		   SELECT DISTINCT job.JobSiteCode AS Destination FROM PRGRM000Master prg 
		   INNER JOIN JOBDL000Master job ON job.ProgramID = prg.Id AND prg.PrgOrgID = 1 AND prg.StatusId =1 AND PRG.PRGCUSTID=@CustomerId
		   AND ISNULL(job.JobSiteCode,'') <> '' AND job.StatusId IN (1,2)
	   END
	   ELSE
	   BEGIN
		   SELECT DISTINCT job.JobSiteCode AS Destination FROM PRGRM000Master prg 
		   INNER JOIN JOBDL000Master job ON job.ProgramID = prg.Id AND prg.PrgOrgID = 1 AND prg.StatusId =1
		   AND ISNULL(job.JobSiteCode,'') <> '' AND job.StatusId IN (1,2)
	   END
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
	