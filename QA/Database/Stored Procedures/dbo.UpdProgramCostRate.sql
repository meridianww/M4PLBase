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
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE  [dbo].[UpdProgramCostRate]
	(@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id bigint
	,@pcrPrgrmId bigint = NULL
	,@pcrCode nvarchar(20) = NULL
	,@pcrVendorCode nvarchar(20) = NULL
	,@pcrEffectiveDate datetime2(7) = NULL
	,@pcrTitle nvarchar(50) = NULL
	,@rateCategoryTypeId INT = NULL
	,@rateTypeId INT = NULL
	,@pcrCostRate decimal(18, 2) = NULL
	,@rateUnitTypeId INT = NULL
	,@pcrFormat nvarchar(20) = NULL
	,@pcrExpression01 nvarchar(255) = NULL
	,@pcrLogic01 nvarchar(255) = NULL
	,@pcrExpression02 nvarchar(255) = NULL
	,@pcrLogic02 nvarchar(255) = NULL
	,@pcrExpression03 nvarchar(255) = NULL
	,@pcrLogic03 nvarchar(255) = NULL
	,@pcrExpression04 nvarchar(255) = NULL
	,@pcrLogic04 nvarchar(255) = NULL
	,@pcrExpression05 nvarchar(255) = NULL
	,@pcrLogic05 nvarchar(255) = NULL
	,@statusId INT = NULL
	,@pcrCustomerId bigint = NULL
	,@changedBy nvarchar(50) = NULL
	,@dateChanged datetime2(7) = NULL
	,@isFormView BIT = 0) 
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 UPDATE [dbo].[PRGRM041ProgramCostRate]
		SET  [PcrPrgrmID]            = CASE WHEN (@isFormView = 1) THEN @pcrPrgrmID WHEN ((@isFormView = 0) AND (@pcrPrgrmID=-100)) THEN NULL ELSE ISNULL(@pcrPrgrmID, PcrPrgrmID) END
			,[PcrCode]               = CASE WHEN (@isFormView = 1) THEN @pcrCode WHEN ((@isFormView = 0) AND (@pcrCode='#M4PL#')) THEN NULL ELSE ISNULL(@pcrCode, PcrCode) END
			,[PcrVendorCode]         = CASE WHEN (@isFormView = 1) THEN @pcrVendorCode WHEN ((@isFormView = 0) AND (@pcrVendorCode='#M4PL#')) THEN NULL ELSE ISNULL(@pcrVendorCode, PcrVendorCode) END
			,[PcrEffectiveDate]      = CASE WHEN (@isFormView = 1) THEN @pcrEffectiveDate WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @pcrEffectiveDate, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@pcrEffectiveDate, PcrEffectiveDate) END
			,[PcrTitle]              = CASE WHEN (@isFormView = 1) THEN @pcrTitle WHEN ((@isFormView = 0) AND (@pcrTitle='#M4PL#')) THEN NULL ELSE ISNULL(@pcrTitle, PcrTitle) END
			,[RateCategoryTypeId]    = CASE WHEN (@isFormView = 1) THEN @rateCategoryTypeId WHEN ((@isFormView = 0) AND (@rateCategoryTypeId=-100)) THEN NULL ELSE ISNULL(@rateCategoryTypeId, RateCategoryTypeId) END
			,[RateTypeId]            = CASE WHEN (@isFormView = 1) THEN @rateTypeId WHEN ((@isFormView = 0) AND (@rateTypeId=-100)) THEN NULL ELSE ISNULL(@rateTypeId, RateTypeId) END
			,[PcrCostRate]           = CASE WHEN (@isFormView = 1) THEN @pcrCostRate WHEN ((@isFormView = 0) AND (@pcrCostRate=-100.00)) THEN NULL ELSE ISNULL(@pcrCostRate, PcrCostRate) END
			,[RateUnitTypeId]		 = CASE WHEN (@isFormView = 1) THEN @rateUnitTypeId WHEN ((@isFormView = 0) AND (@rateUnitTypeId=-100)) THEN NULL ELSE ISNULL(@rateUnitTypeId, RateUnitTypeId) END
			,[PcrFormat]             = CASE WHEN (@isFormView = 1) THEN @pcrFormat WHEN ((@isFormView = 0) AND (@pcrFormat='#M4PL#')) THEN NULL ELSE ISNULL(@pcrFormat, PcrFormat) END
			,[PcrExpression01]       = CASE WHEN (@isFormView = 1) THEN @pcrExpression01 WHEN ((@isFormView = 0) AND (@pcrExpression01='#M4PL#')) THEN NULL ELSE ISNULL(@pcrExpression01, PcrExpression01) END
			,[PcrLogic01]            = CASE WHEN (@isFormView = 1) THEN @pcrLogic01 WHEN ((@isFormView = 0) AND (@pcrLogic01='#M4PL#')) THEN NULL ELSE ISNULL(@pcrLogic01, PcrLogic01) END
			,[PcrExpression02]       = CASE WHEN (@isFormView = 1) THEN @pcrExpression02 WHEN ((@isFormView = 0) AND (@pcrExpression02='#M4PL#')) THEN NULL ELSE ISNULL(@pcrExpression02, PcrExpression02) END
			,[PcrLogic02]            = CASE WHEN (@isFormView = 1) THEN @pcrLogic02 WHEN ((@isFormView = 0) AND (@pcrLogic02='#M4PL#')) THEN NULL ELSE ISNULL(@pcrLogic02, PcrLogic02) END
			,[PcrExpression03]       = CASE WHEN (@isFormView = 1) THEN @pcrExpression03 WHEN ((@isFormView = 0) AND (@pcrExpression03='#M4PL#')) THEN NULL ELSE ISNULL(@pcrExpression03, PcrExpression03) END
			,[PcrLogic03]            = CASE WHEN (@isFormView = 1) THEN @pcrLogic03 WHEN ((@isFormView = 0) AND (@pcrLogic03='#M4PL#')) THEN NULL ELSE ISNULL(@pcrLogic03, PcrLogic03) END
			,[PcrExpression04]       = CASE WHEN (@isFormView = 1) THEN @pcrExpression04 WHEN ((@isFormView = 0) AND (@pcrExpression04='#M4PL#')) THEN NULL ELSE ISNULL(@pcrExpression04, PcrExpression04) END
			,[PcrLogic04]            = CASE WHEN (@isFormView = 1) THEN @pcrLogic04 WHEN ((@isFormView = 0) AND (@pcrLogic04='#M4PL#')) THEN NULL ELSE ISNULL(@pcrLogic04, PcrLogic04) END
			,[PcrExpression05]       = CASE WHEN (@isFormView = 1) THEN @pcrExpression05 WHEN ((@isFormView = 0) AND (@pcrExpression05='#M4PL#')) THEN NULL ELSE ISNULL(@pcrExpression05, PcrExpression05) END
			,[PcrLogic05]            = CASE WHEN (@isFormView = 1) THEN @pcrLogic05 WHEN ((@isFormView = 0) AND (@pcrLogic05='#M4PL#')) THEN NULL ELSE ISNULL(@pcrLogic05, PcrLogic05) END
			,[StatusId]              = CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
			,[PcrCustomerID]         = CASE WHEN (@isFormView = 1) THEN @pcrCustomerID WHEN ((@isFormView = 0) AND (@pcrCustomerID=-100)) THEN NULL ELSE ISNULL(@pcrCustomerID, PcrCustomerID) END
			,[ChangedBy]             = @changedBy
			,[DateChanged]           = @dateChanged
	 WHERE   [Id] = @id
	SELECT prg.[Id]
		,prg.[PcrPrgrmID]
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
		,prg.[EnteredBy]
		,prg.[DateEntered]
		,prg.[ChangedBy]
		,prg.[DateChanged]
  FROM   [dbo].[PRGRM041ProgramCostRate] prg
 WHERE   [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
