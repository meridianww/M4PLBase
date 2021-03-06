SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Upd a Program Cost Rate
-- Execution:                 EXEC [dbo].[UpdProgramCostRate]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified By:               Prashant Aggarwal     
-- Modified on:				  08/02/2019
-- Modified Desc:             Update the Stored Procedure to make changes for Program Location Id
-- =============================================
CREATE PROCEDURE [dbo].[UpdProgramCostRate] (
	@userId BIGINT
	,@roleId BIGINT
	,@entity NVARCHAR(100)
	,@id BIGINT
	,@programLocationId BIGINT = NULL
	,@pcrCode NVARCHAR(20) = NULL
	,@pcrVendorCode NVARCHAR(20) = NULL
	,@pcrEffectiveDate DATETIME2(7) = NULL
	,@pcrTitle NVARCHAR(50) = NULL
	,@rateCategoryTypeId INT = NULL
	,@rateTypeId INT = NULL
	,@pcrCostRate DECIMAL(18, 2) = NULL
	,@rateUnitTypeId INT = NULL
	,@pcrFormat NVARCHAR(20) = NULL
	,@pcrExpression01 NVARCHAR(255) = NULL
	,@pcrLogic01 NVARCHAR(255) = NULL
	,@pcrExpression02 NVARCHAR(255) = NULL
	,@pcrLogic02 NVARCHAR(255) = NULL
	,@pcrExpression03 NVARCHAR(255) = NULL
	,@pcrLogic03 NVARCHAR(255) = NULL
	,@pcrExpression04 NVARCHAR(255) = NULL
	,@pcrLogic04 NVARCHAR(255) = NULL
	,@pcrExpression05 NVARCHAR(255) = NULL
	,@pcrLogic05 NVARCHAR(255) = NULL
	,@statusId INT = NULL
	,@pcrCustomerId BIGINT = NULL
	,@changedBy NVARCHAR(50) = NULL
	,@dateChanged DATETIME2(7) = NULL
	,@isFormView BIT = 0
	,@pcrElectronicBilling BIT = 0
	)
AS
BEGIN TRY
	SET NOCOUNT ON;

	UPDATE [dbo].[PRGRM041ProgramCostRate]
	SET [ProgramLocationId] = ISNULL(@programLocationId, ProgramLocationId)
		,[PcrCode] = ISNULL(@pcrCode, PcrCode)
		,[PcrVendorCode] = ISNULL(@pcrVendorCode, PcrVendorCode)
		,[PcrEffectiveDate] = @pcrEffectiveDate
		,[PcrTitle] = @pcrTitle
		,[RateCategoryTypeId] = ISNULL(@rateCategoryTypeId, RateCategoryTypeId)
		,[RateTypeId] = ISNULL(@rateTypeId, RateTypeId)
		,[PcrCostRate] = ISNULL(@pcrCostRate, PcrCostRate)
		,[RateUnitTypeId] = ISNULL(@rateUnitTypeId, RateUnitTypeId)
		,[PcrFormat] = @pcrFormat
		,[PcrExpression01] = @pcrExpression01
		,[PcrLogic01] = @pcrLogic01
		,[PcrExpression02] = @pcrExpression02
		,[PcrLogic02] = @pcrLogic02
		,[PcrExpression03] = @pcrExpression03
		,[PcrLogic03] = @pcrLogic03
		,[PcrExpression04] = @pcrExpression04
		,[PcrLogic04] = @pcrLogic04
		,[PcrExpression05] = @pcrExpression05
		,[PcrLogic05] = @pcrLogic05
		,[StatusId] = ISNULL(@statusId, StatusId)
		,[PcrCustomerID] = ISNULL(@pcrCustomerID, PcrCustomerID)
		,[PcrElectronicBilling] = @pcrElectronicBilling
		,[ChangedBy] = @changedBy
		,[DateChanged] = @dateChanged
	WHERE [Id] = @id

	UPDATE Location
	SET Location.CstChargeCode = ISNULL(@pcrCode, PrgLocation.PcrCode)
		,Location.CstTitle = ISNULL(@pcrTitle, PrgLocation.PcrTitle)
		,Location.ChargeTypeId = ISNULL(@rateTypeId, PrgLocation.RateTypeId)
		,Location.CstUnitId = ISNULL(@rateUnitTypeId, PrgLocation.RateUnitTypeId)
		,Location.CstRate = ISNULL(@pcrCostRate, PrgLocation.PcrCostRate)
		,Location.CstElectronicBilling = @pcrElectronicBilling
	FROM dbo.JOBDL062CostSheet Location
	INNER JOIN [dbo].[PRGRM041ProgramCostRate] PrgLocation ON PrgLocation.Id = Location.CstChargeID
	WHERE Location.CstChargeID = @id

	SELECT prg.[Id]
		,prg.[ProgramLocationId]
		,prg.[PcrCode]
		,prg.[PcrVendorCode]
		,prg.[PcrEffectiveDate]
		,prg.[PcrTitle]
		,prg.[RateCategoryTypeId]
		,prg.[RateTypeId]
		,prg.[PcrCostRate]
		,prg.[RateUnitTypeId]
		,prg.[PcrFormat]
		,prg.[PcrExpression01]
		,prg.[PcrLogic01]
		,prg.[PcrExpression02]
		,prg.[PcrLogic02]
		,prg.[PcrExpression03]
		,prg.[PcrLogic03]
		,prg.[PcrExpression04]
		,prg.[PcrLogic04]
		,prg.[PcrExpression05]
		,prg.[PcrLogic05]
		,prg.[StatusId]
		,prg.[PcrCustomerID]
		,prg.[PcrElectronicBilling]
		,prg.[EnteredBy]
		,prg.[DateEntered]
		,prg.[ChangedBy]
		,prg.[DateChanged]
		,CL.PclProgramID ProgramId
	FROM [dbo].[PRGRM041ProgramCostRate] prg
	INNER JOIN dbo.PRGRM043ProgramCostLocations CL ON CL.Id = prg.[ProgramLocationId]
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
