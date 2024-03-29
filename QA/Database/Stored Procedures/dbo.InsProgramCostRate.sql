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
-- Modified By:               Prashant Aggarwal     
-- Modified on:				  08/02/2019
-- Modified Desc:             Update the Stored Procedure to make changes for Program Location Id
-- =============================================

CREATE PROCEDURE  [dbo].[InsProgramCostRate]
	(@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@programLocationId bigint
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
	,@dateEntered datetime2(7)
	,@pcrElectronicBilling BIT = 0)
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 DECLARE @currentId BIGINT;
 DECLARE @CustomerID BIGINT
 SELECT @CustomerID = PrgCustID
 from dbo.PRGRM043ProgramCostLocations PCL
 INNER JOIN dbo.PRGRM000Master PM ON PM.Id = PCL.PclProgramID 
 WHERE PCL.Id = @programLocationId


 INSERT INTO [dbo].[PRGRM041ProgramCostRate]
           ([ProgramLocationId]
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
			,[PcrElectronicBilling]
			,[EnteredBy]
			,[DateEntered])
     VALUES
           (@programLocationId
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
			,@pcrElectronicBilling
		   	,@enteredBy
		   	,@dateEntered)
			SET @currentId = SCOPE_IDENTITY();
		
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
	WHERE prg.[Id] = @currentId
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH

GO
