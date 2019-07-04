SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Ins a  Program Cost Rate
-- Execution:                 EXEC [dbo].[InsProgramCostRate]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================

CREATE PROCEDURE  [dbo].[InsProgramCostRate]
	(@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@pcrPrgrmId bigint
	,@pcrCode nvarchar(20)
	,@pcrVendorCode nvarchar(20)
	,@pcrEffectiveDate datetime2(7)
	,@pcrTitle nvarchar(50)
	,@rateCategoryTypeId INT
	,@rateTypeId INT
	,@pcrCostRate decimal(18, 2)
	,@rateUnitTypeId INT
	,@pcrFormat nvarchar(20)
	,@pcrExpression01 nvarchar(255)
	,@pcrLogic01 nvarchar(255)
	,@pcrExpression02 nvarchar(255)
	,@pcrLogic02 nvarchar(255)
	,@pcrExpression03 nvarchar(255)
	,@pcrLogic03 nvarchar(255)
	,@pcrExpression04 nvarchar(255)
	,@pcrLogic04 nvarchar(255)
	,@pcrExpression05 nvarchar(255)
	,@pcrLogic05 nvarchar(255)
	,@statusId INT
	,@pcrCustomerId bigint
	,@enteredBy nvarchar(50)
	,@dateEntered datetime2(7))
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 DECLARE @currentId BIGINT;
 DECLARE @CustomerID BIGINT
 SELECT @CustomerID = PrgCustID from PRGRM000Master WHERE Id = @pcrPrgrmId


 INSERT INTO [dbo].[PRGRM041ProgramCostRate]
           ([PcrPrgrmID]
			,[PcrCode]
			,[PcrVendorCode]
			,[PcrEffectiveDate]
			,[PcrTitle]
			,[RateCategoryTypeId]
			,[RateTypeId]
			,[PcrCostRate]
			,[RateUnitTypeId]
			,[PcrFormat]
			,[PcrExpression01]
			,[PcrLogic01]
			,[PcrExpression02]
			,[PcrLogic02]
			,[PcrExpression03]
			,[PcrLogic03]
			,[PcrExpression04]
			,[PcrLogic04]
			,[PcrExpression05]
			,[PcrLogic05]
			,[StatusId]
			,[PcrCustomerID]
			,[EnteredBy]
			,[DateEntered])
     VALUES
           (@pcrPrgrmID
		   	,@pcrCode
		   	,@pcrVendorCode
		   	,@pcrEffectiveDate
		   	,@pcrTitle
		   	,@rateCategoryTypeId
		   	,@rateTypeId
		   	,@pcrCostRate
		   	,@rateUnitTypeId
		   	,@pcrFormat
		   	,@pcrExpression01
		   	,@pcrLogic01
		   	,@pcrExpression02
		   	,@pcrLogic02
		   	,@pcrExpression03
		   	,@pcrLogic03
		   	,@pcrExpression04
		   	,@pcrLogic04
		   	,@pcrExpression05
		   	,@pcrLogic05
		   	,@statusId
		   	,@CustomerID --@pcrCustomerID
		   	,@enteredBy
		   	,@dateEntered)
			SET @currentId = SCOPE_IDENTITY();
	SELECT * FROM [dbo].[PRGRM041ProgramCostRate] WHERE Id = @currentId;
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
