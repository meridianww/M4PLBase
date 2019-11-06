SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Prashant Aggarwal        
-- Create date:               10/25/2018      
-- Description:              Get Job Cost Code Action
-- Execution:                [dbo].[GetJobCostCodeAction] 36618
-- =============================================
CREATE PROCEDURE [dbo].[GetJobCostCodeAction] 
	@jobId BIGINT
AS
BEGIN TRY
SET NOCOUNT ON;
		DECLARE @ProgramId BIGINT
		,@SiteCode VARCHAR(50)

	SELECT @ProgramId = ProgramId
		,@SiteCode = JobSiteCode
	FROM JOBDL000Master
	WHERE Id = @jobId

	Select Id, CstChargeID, JobId INTO #JOBDL062CostSheet From JOBDL062CostSheet Where JobId = @jobId AND StatusId IN (1,2)
	SELECT DISTINCT PCR.Id CostCodeId
		,PCr.PcrCode CostCode
		,CASE 
			WHEN ISNULL(Pcr.PcrTitle, '') <> ''
				THEN Pcr.PcrTitle
			ELSE PCr.PcrCode 
			END CostTitle
		,CASE 
			WHEN PPC.PclLocationCode = 'Default'
				THEN 'Default'
			ELSE 'Location'
			END CostActionCode
	FROM PRGRM043ProgramCostLocations PPC
	INNER JOIN PRGRM041ProgramCostRate PCR ON PCR.ProgramLocationId = PPC.Id
	LEFT JOIN #JOBDL062CostSheet JCS ON JCS.CstChargeID = PCR.Id AND JCS.JobId = @jobId
	WHERE PPC.PclProgramID = @ProgramId AND PCR.StatusId IN (1,2) AND JCS.Id IS  NULL 
		AND PPC.PclLocationCode IN (
			@SiteCode
			,'Default'
			)

DROP TABLE #JOBDL062CostSheet
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

