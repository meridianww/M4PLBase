SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Upd a Program Billable Rate
-- Execution:                 EXEC [dbo].[UpdProgramBillableRate]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified By:               Prashant Aggarwal     
-- Modified on:				  08/02/2019
-- Modified Desc:             Update the Stored Procedure to make changes for Program Location Id
-- =============================================
CREATE PROCEDURE [dbo].[UpdProgramBillableRate] (
	@userId BIGINT
	,@roleId BIGINT
	,@entity NVARCHAR(100)
	,@Id BIGINT
	,@programLocationId BIGINT = NULL
	,@pbrCode NVARCHAR(20) = NULL
	,@pbrCustomerCode NVARCHAR(20) = NULL
	,@pbrEffectiveDate DATETIME2(7) = NULL
	,@pbrTitle NVARCHAR(50) = NULL
	,@rateCategoryTypeId INT = NULL
	,@rateTypeId INT = NULL
	,@pbrBillablePrice DECIMAL(18, 2) = NULL
	,@rateUnitTypeId INT = NULL
	,@pbrFormat NVARCHAR(20) = NULL
	,@pbrExpression01 NVARCHAR(255) = NULL
	,@pbrLogic01 NVARCHAR(255) = NULL
	,@pbrExpression02 NVARCHAR(255) = NULL
	,@pbrLogic02 NVARCHAR(255) = NULL
	,@pbrExpression03 NVARCHAR(255) = NULL
	,@pbrLogic03 NVARCHAR(255) = NULL
	,@pbrExpression04 NVARCHAR(255) = NULL
	,@pbrLogic04 NVARCHAR(255) = NULL
	,@pbrExpression05 NVARCHAR(255) = NULL
	,@pbrLogic05 NVARCHAR(255) = NULL
	,@statusId INT = NULL
	,@pbrVendLocationId BIGINT = NULL
	,@changedBy NVARCHAR(50) = NULL
	,@dateChanged DATETIME2(7) = NULL
	,@isFormView BIT = 0
	)
AS
BEGIN TRY
	SET NOCOUNT ON;

	UPDATE [dbo].[PRGRM040ProgramBillableRate]
	SET [ProgramLocationId] = ISNULL(@programLocationId, ProgramLocationId)
		,[PbrCode] = ISNULL(@pbrCode, PbrCode)
		,[PbrCustomerCode] = ISNULL(@pbrCustomerCode, PbrCustomerCode)
		,[PbrEffectiveDate] = ISNULL(@pbrEffectiveDate, PbrEffectiveDate)
		,[PbrTitle] = ISNULL(@pbrTitle, PbrTitle)
		,[RateCategoryTypeId] = ISNULL(@rateCategoryTypeId, RateCategoryTypeId)
		,[RateTypeId] = ISNULL(@rateTypeId, RateTypeId)
		,[PbrBillablePrice] = ISNULL(@pbrBillablePrice, PbrBillablePrice)
		,[RateUnitTypeId] = ISNULL(@rateUnitTypeId, RateUnitTypeId)
		,[PbrFormat] = ISNULL(@pbrFormat, PbrFormat)
		,[PbrExpression01] = ISNULL(@pbrExpression01, PbrExpression01)
		,[PbrLogic01] = ISNULL(@pbrLogic01, PbrLogic01)
		,[PbrExpression02] = ISNULL(@pbrExpression02, PbrExpression02)
		,[PbrLogic02] = ISNULL(@pbrLogic02, PbrLogic02)
		,[PbrExpression03] = ISNULL(@pbrExpression03, PbrExpression03)
		,[PbrLogic03] = ISNULL(@pbrLogic03, PbrLogic03)
		,[PbrExpression04] = ISNULL(@pbrExpression04, PbrExpression04)
		,[PbrLogic04] = ISNULL(@pbrLogic04, PbrLogic04)
		,[PbrExpression05] = ISNULL(@pbrExpression05, PbrExpression05)
		,[PbrLogic05] = ISNULL(@pbrLogic05, PbrLogic05)
		,[StatusId] = ISNULL(@statusId, StatusId)
		,[PbrVendLocationID] = ISNULL(@pbrVendLocationID, PbrVendLocationID)
		,[ChangedBy] = @changedBy
		,[DateChanged] = @dateChanged
	WHERE [Id] = @id

	UPDATE Billable
	SET Billable.PrcChargeCode = ISNULL(@pbrCode, PrgBillable.PbrCode)
		,Billable.PrcTitle = ISNULL(@pbrTitle, PrgBillable.PbrTitle)
		,Billable.ChargeTypeId = ISNULL(@rateTypeId, PrgBillable.RateTypeId)
		,Billable.PrcUnitId = ISNULL(@rateUnitTypeId, PrgBillable.RateUnitTypeId)
		,Billable.PrcRate = ISNULL(@pbrBillablePrice, PrgBillable.PbrBillablePrice)
	FROM dbo.JOBDL061BillableSheet Billable
	INNER JOIN [dbo].[PRGRM040ProgramBillableRate] PrgBillable ON PrgBillable.Id = Billable.PrcChargeID
	WHERE Billable.PrcChargeID = @id

	SELECT prg.[Id]
		,prg.[ProgramLocationId]
		,prg.[PbrCode]
		,prg.[PbrCustomerCode]
		,prg.[PbrEffectiveDate]
		,prg.[PbrTitle]
		,prg.[RateCategoryTypeId]
		,prg.[RateTypeId]
		,prg.[PbrBillablePrice]
		,prg.[RateUnitTypeId]
		,prg.[PbrFormat]
		,prg.[PbrExpression01]
		,prg.[PbrLogic01]
		,prg.[PbrExpression02]
		,prg.[PbrLogic02]
		,prg.[PbrExpression03]
		,prg.[PbrLogic03]
		,prg.[PbrExpression04]
		,prg.[PbrLogic04]
		,prg.[PbrExpression05]
		,prg.[PbrLogic05]
		,prg.[StatusId]
		,prg.[PbrVendLocationID]
		,prg.[EnteredBy]
		,prg.[DateEntered]
		,prg.[ChangedBy]
		,prg.[DateChanged]
	FROM [dbo].[PRGRM040ProgramBillableRate] prg
	WHERE [Id] = @id
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

