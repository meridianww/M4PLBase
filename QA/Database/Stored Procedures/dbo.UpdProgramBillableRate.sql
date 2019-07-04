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
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE  [dbo].[UpdProgramBillableRate]
	(@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@Id bigint
	,@pbrPrgrmId bigint = NULL
	,@pbrCode nvarchar(20) = NULL
	,@pbrCustomerCode nvarchar(20) = NULL
	,@pbrEffectiveDate datetime2(7) = NULL
	,@pbrTitle nvarchar(50) = NULL
	,@rateCategoryTypeId INT = NULL
	,@rateTypeId INT = NULL
	,@pbrBillablePrice decimal(18, 2) = NULL
	,@rateUnitTypeId INT = NULL
	,@pbrFormat nvarchar(20) = NULL
	,@pbrExpression01 nvarchar(255) = NULL
	,@pbrLogic01 nvarchar(255) = NULL
	,@pbrExpression02 nvarchar(255) = NULL
	,@pbrLogic02 nvarchar(255) = NULL
	,@pbrExpression03 nvarchar(255) = NULL
	,@pbrLogic03 nvarchar(255) = NULL
	,@pbrExpression04 nvarchar(255) = NULL
	,@pbrLogic04 nvarchar(255) = NULL
	,@pbrExpression05 nvarchar(255) = NULL
	,@pbrLogic05 nvarchar(255) = NULL
	,@statusId INT = NULL
	,@pbrVendLocationId bigint = NULL
	,@changedBy nvarchar(50) = NULL
	,@dateChanged datetime2(7) = NULL
	,@isFormView BIT = 0) 
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 UPDATE [dbo].[PRGRM040ProgramBillableRate]
		SET  [PbrPrgrmID]			= CASE WHEN (@isFormView = 1) THEN @pbrPrgrmID WHEN ((@isFormView = 0) AND (@pbrPrgrmID=-100)) THEN NULL ELSE ISNULL(@pbrPrgrmID, PbrPrgrmID) END
			,[PbrCode]				= CASE WHEN (@isFormView = 1) THEN @pbrCode WHEN ((@isFormView = 0) AND (@pbrCode='#M4PL#')) THEN NULL ELSE ISNULL(@pbrCode, PbrCode) END
			,[PbrCustomerCode]		= CASE WHEN (@isFormView = 1) THEN @pbrCustomerCode WHEN ((@isFormView = 0) AND (@pbrCustomerCode='#M4PL#')) THEN NULL ELSE ISNULL(@pbrCustomerCode, PbrCustomerCode) END
			,[PbrEffectiveDate]		= CASE WHEN (@isFormView = 1) THEN @pbrEffectiveDate WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @pbrEffectiveDate, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@pbrEffectiveDate, PbrEffectiveDate) END
			,[PbrTitle]				= CASE WHEN (@isFormView = 1) THEN @pbrTitle WHEN ((@isFormView = 0) AND (@pbrTitle='#M4PL#')) THEN NULL ELSE ISNULL(@pbrTitle, PbrTitle) END
			,[RateCategoryTypeId]   = CASE WHEN (@isFormView = 1) THEN @rateCategoryTypeId WHEN ((@isFormView = 0) AND (@rateCategoryTypeId=-100)) THEN NULL ELSE ISNULL(@rateCategoryTypeId, RateCategoryTypeId) END
			,[RateTypeId]           = CASE WHEN (@isFormView = 1) THEN @rateTypeId WHEN ((@isFormView = 0) AND (@rateTypeId=-100)) THEN NULL ELSE ISNULL(@rateTypeId, RateTypeId) END
			,[PbrBillablePrice]		= CASE WHEN (@isFormView = 1) THEN @pbrBillablePrice WHEN ((@isFormView = 0) AND (@pbrBillablePrice=-100.00)) THEN NULL ELSE ISNULL(@pbrBillablePrice, PbrBillablePrice) END
			,[RateUnitTypeId]		= CASE WHEN (@isFormView = 1) THEN @rateUnitTypeId WHEN ((@isFormView = 0) AND (@rateUnitTypeId=-100)) THEN NULL ELSE ISNULL(@rateUnitTypeId, RateUnitTypeId) END
			,[PbrFormat]			= CASE WHEN (@isFormView = 1) THEN @pbrFormat WHEN ((@isFormView = 0) AND (@pbrFormat='#M4PL#')) THEN NULL ELSE ISNULL(@pbrFormat, PbrFormat) END
			,[PbrExpression01]		= CASE WHEN (@isFormView = 1) THEN @pbrExpression01 WHEN ((@isFormView = 0) AND (@pbrExpression01='#M4PL#')) THEN NULL ELSE ISNULL(@pbrExpression01, PbrExpression01) END
			,[PbrLogic01]			= CASE WHEN (@isFormView = 1) THEN @pbrLogic01 WHEN ((@isFormView = 0) AND (@pbrLogic01='#M4PL#')) THEN NULL ELSE ISNULL(@pbrLogic01, PbrLogic01) END
			,[PbrExpression02]		= CASE WHEN (@isFormView = 1) THEN @pbrExpression02 WHEN ((@isFormView = 0) AND (@pbrExpression02='#M4PL#')) THEN NULL ELSE ISNULL(@pbrExpression02, PbrExpression02) END
			,[PbrLogic02]			= CASE WHEN (@isFormView = 1) THEN @pbrLogic02 WHEN ((@isFormView = 0) AND (@pbrLogic02='#M4PL#')) THEN NULL ELSE ISNULL(@pbrLogic02, PbrLogic02) END
			,[PbrExpression03]		= CASE WHEN (@isFormView = 1) THEN @pbrExpression03 WHEN ((@isFormView = 0) AND (@pbrExpression03='#M4PL#')) THEN NULL ELSE ISNULL(@pbrExpression03, PbrExpression03) END
			,[PbrLogic03]			= CASE WHEN (@isFormView = 1) THEN @pbrLogic03 WHEN ((@isFormView = 0) AND (@pbrLogic03='#M4PL#')) THEN NULL ELSE ISNULL(@pbrLogic03, PbrLogic03) END
			,[PbrExpression04]		= CASE WHEN (@isFormView = 1) THEN @pbrExpression04 WHEN ((@isFormView = 0) AND (@pbrExpression04='#M4PL#')) THEN NULL ELSE ISNULL(@pbrExpression04, PbrExpression04) END
			,[PbrLogic04]			= CASE WHEN (@isFormView = 1) THEN @pbrLogic04 WHEN ((@isFormView = 0) AND (@pbrLogic04='#M4PL#')) THEN NULL ELSE ISNULL(@pbrLogic04, PbrLogic04) END
			,[PbrExpression05]		= CASE WHEN (@isFormView = 1) THEN @pbrExpression05 WHEN ((@isFormView = 0) AND (@pbrExpression05='#M4PL#')) THEN NULL ELSE ISNULL(@pbrExpression05, PbrExpression05) END
			,[PbrLogic05]			= CASE WHEN (@isFormView = 1) THEN @pbrLogic05 WHEN ((@isFormView = 0) AND (@pbrLogic05='#M4PL#')) THEN NULL ELSE ISNULL(@pbrLogic05, PbrLogic05) END
			,[StatusId]				= CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
			,[PbrVendLocationID]	= CASE WHEN (@isFormView = 1) THEN @pbrVendLocationID WHEN ((@isFormView = 0) AND (@pbrVendLocationID=-100)) THEN NULL ELSE ISNULL(@pbrVendLocationID, PbrVendLocationID) END
			,[ChangedBy]			= @changedBy
			,[DateChanged]			= @dateChanged
	 WHERE   [Id] = @id
	SELECT prg.[Id]
		,prg.[PbrPrgrmID]
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
  FROM   [dbo].[PRGRM040ProgramBillableRate] prg
 WHERE   [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
