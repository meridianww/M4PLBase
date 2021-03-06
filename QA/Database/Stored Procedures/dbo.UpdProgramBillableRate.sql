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
	,@pbrElectronicBilling BIT = 0
	)
AS
BEGIN TRY
	SET NOCOUNT ON;

	UPDATE [dbo].[PRGRM040ProgramBillableRate]
	SET [ProgramLocationId] = ISNULL(@programLocationId, ProgramLocationId)
		,[PbrCode] = ISNULL(@pbrCode, PbrCode)
		,[PbrCustomerCode] = ISNULL(@pbrCustomerCode, PbrCustomerCode)
		,[PbrEffectiveDate] = @pbrEffectiveDate
		,[PbrTitle] = @pbrTitle
		,[RateCategoryTypeId] = ISNULL(@rateCategoryTypeId, RateCategoryTypeId)
		,[RateTypeId] = ISNULL(@rateTypeId, RateTypeId)
		,[PbrBillablePrice] = ISNULL(@pbrBillablePrice, PbrBillablePrice)
		,[RateUnitTypeId] = ISNULL(@rateUnitTypeId, RateUnitTypeId)
		,[PbrFormat] = @pbrFormat
		,[PbrExpression01] = @pbrExpression01
		,[PbrLogic01] = @pbrLogic01
		,[PbrExpression02] = @pbrExpression02
		,[PbrLogic02] = @pbrLogic02
		,[PbrExpression03] = @pbrExpression03
		,[PbrLogic03] = @pbrLogic03
		,[PbrExpression04] = @pbrExpression04
		,[PbrLogic04] = @pbrLogic04
		,[PbrExpression05] = @pbrExpression05
		,[PbrLogic05] = @pbrLogic05
		,[StatusId] = ISNULL(@statusId, StatusId)
		,[PbrVendLocationID] = ISNULL(@pbrVendLocationID, PbrVendLocationID)
		,[PbrElectronicBilling] = @pbrElectronicBilling
		,[ChangedBy] = @changedBy
		,[DateChanged] = @dateChanged
	WHERE [Id] = @id

	UPDATE Billable
	SET Billable.PrcChargeCode = ISNULL(@pbrCode, PrgBillable.PbrCode)
		,Billable.PrcTitle = ISNULL(@pbrTitle, PrgBillable.PbrTitle)
		,Billable.ChargeTypeId = ISNULL(@rateTypeId, PrgBillable.RateTypeId)
		,Billable.PrcUnitId = ISNULL(@rateUnitTypeId, PrgBillable.RateUnitTypeId)
		,Billable.PrcRate = ISNULL(@pbrBillablePrice, PrgBillable.PbrBillablePrice)
		,Billable.PrcElectronicBilling = pbrElectronicBilling
	FROM dbo.JOBDL061BillableSheet Billable
	INNER JOIN [dbo].[PRGRM040ProgramBillableRate] PrgBillable ON PrgBillable.Id = Billable.PrcChargeID
	WHERE PrcChargeID = @id

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
		,prg.[PbrElectronicBilling]
		,CL.PblProgramID ProgramId
		,prg.[EnteredBy]
		,prg.[DateEntered]
		,prg.[ChangedBy]
		,prg.[DateChanged]
	FROM [dbo].[PRGRM040ProgramBillableRate] prg
	INNER JOIN dbo.PRGRM042ProgramBillableLocations CL ON CL.Id = prg.[ProgramLocationId]
	WHERE prg.[Id] = @id
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
