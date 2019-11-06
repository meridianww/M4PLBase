SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Prashant Aggarwal        
-- Create date:               10/25/2018      
-- Description:              Get Job Price Code Action
-- Execution:                [dbo].[GetJobPriceCodeAction] 36618
-- =============================================
CREATE PROCEDURE [dbo].[GetJobPriceCodeAction] 
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

	Select Id, PrcChargeID, JobId INTO #JOBDL061BillableSheet From JOBDL061BillableSheet Where JobId = @jobId AND StatusId IN (1,2)
	SELECT DISTINCT PCR.Id PriceCodeId
		,PCr.PbrCode PriceCode
		,CASE 
			WHEN ISNULL(Pcr.PbrTitle, '') <> ''
				THEN Pcr.PbrTitle
			ELSE PCr.PbrCode
			END PriceTitle
		,CASE 
			WHEN PPC.PblLocationCode = 'Default'
				THEN 'Default'
			ELSE 'Location'
			END PriceActionCode
	FROM PRGRM042ProgramBillableLocations PPC
	INNER JOIN PRGRM040ProgramBillableRate PCR ON PCR.ProgramLocationId = PPC.Id
	LEFT JOIN #JOBDL061BillableSheet JCS ON JCS.PrcChargeID = PCR.Id AND JCS.JobId = @jobId
	WHERE PPC.PblProgramID = @ProgramId AND PCR.StatusId IN (1,2) AND JCS.Id IS  NULL 
		AND PPC.PblLocationCode IN (
			@SiteCode
			,'Default'
			)

			DROP TABLE #JOBDL061BillableSheet
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

