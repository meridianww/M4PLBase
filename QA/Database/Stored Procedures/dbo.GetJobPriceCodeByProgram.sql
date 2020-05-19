SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Prashant Aggarwal        
-- Create date:               10/25/2018      
-- Description:              Get Job Price Code By Program
-- Execution:                [dbo].[GetJobPriceCodeByProgram] 10032,36618
-- =============================================
CREATE PROCEDURE [dbo].[GetJobPriceCodeByProgram]
(
@id BIGINT,
@jobId BIGINT
)
AS
BEGIN TRY
SET NOCOUNT ON;

		SELECT @jobId JobID, pcr.[Id] PrcChargeID
			,pcr.[PbrCode] PrcChargeCode
			,pcr.[PbrTitle] PrcTitle
			,pcr.[RateUnitTypeId] PrcUnitId
			,pcr.[PbrBillablePrice] PrcRate
			,pcr.[RateTypeId] ChargeTypeId
			,pcr.[StatusId]
			,pcr.[PbrElectronicBilling] PrcElectronicBilling
		FROM [dbo].[PRGRM040ProgramBillableRate] pcr
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
