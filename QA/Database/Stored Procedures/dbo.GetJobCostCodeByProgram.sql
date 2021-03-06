SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Prashant Aggarwal        
-- Create date:               10/25/2018      
-- Description:              Get Job Cost Code By Program
-- Execution:                [dbo].[GetJobCostCodeByProgram] 10032,36618
-- =============================================
CREATE PROCEDURE [dbo].[GetJobCostCodeByProgram] (
	@id BIGINT
	,@jobId BIGINT
	)
AS
BEGIN TRY
	SET NOCOUNT ON;

	DECLARE @currentId BIGINT
		,@CstChargeCode NVARCHAR(20)

	SELECT @CstChargeCode = pcr.[PcrCode]
	FROM [dbo].[PRGRM041ProgramCostRate] pcr
	WHERE pcr.Id = @id

	SELECT @currentId = ID
	FROM [dbo].[JOBDL062CostSheet]
	WHERE ISNULL(CstChargeID, 0) = 0
		AND JobId = @JobID
		AND CstChargeCode = @CstChargeCode
		AND StatusId = 1

	SELECT @jobId JobID
		,pcr.[Id] CstChargeID
		,pcr.[PcrCode] CstChargeCode
		,pcr.[PcrTitle] CstTitle
		,pcr.[RateUnitTypeId] CstUnitId
		,pcr.[PcrCostRate] CstRate
		,pcr.[RateTypeId] ChargeTypeId
		,pcr.[StatusId]
		,pcr.[PcrElectronicBilling] CstElectronicBilling
		,CASE 
			WHEN ISNULL(@currentId, 0) > 0
				THEN CAST(1 AS BIT)
			ELSE CAST(0 AS BIT)
			END IsProblem
	FROM [dbo].[PRGRM041ProgramCostRate] pcr
	WHERE pcr.Id = @id
	ORDER BY pcr.Id
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
