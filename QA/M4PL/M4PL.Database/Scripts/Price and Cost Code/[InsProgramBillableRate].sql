USE [M4PL_DEV]
GO
/****** Object:  StoredProcedure [dbo].[InsProgramBillableRate]    Script Date: 8/5/2019 5:58:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Ins a  Program Billable Rate
-- Execution:                 EXEC [dbo].[InsProgramBillableRate]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified By:               Prashant Aggarwal     
-- Modified on:				  08/02/2019
-- Modified Desc:             Update the Stored Procedure to make changes for Program Location Id
-- =============================================

ALTER PROCEDURE  [dbo].[InsProgramBillableRate]
	(@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@programLocationId bigint
	,@pbrCode nvarchar(20)
	,@pbrCustomerCode nvarchar(20)
	,@pbrEffectiveDate datetime2(7)
	,@pbrTitle nvarchar(50)
	,@rateCategoryTypeId INT
	,@rateTypeId INT
	,@pbrBillablePrice decimal(18, 2)
	,@rateUnitTypeId INT
	,@pbrFormat nvarchar(20)
	,@pbrExpression01 nvarchar(255)
	,@pbrLogic01 nvarchar(255)
	,@pbrExpression02 nvarchar(255)
	,@pbrLogic02 nvarchar(255)
	,@pbrExpression03 nvarchar(255)
	,@pbrLogic03 nvarchar(255)
	,@pbrExpression04 nvarchar(255)
	,@pbrLogic04 nvarchar(255)
	,@pbrExpression05 nvarchar(255)
	,@pbrLogic05 nvarchar(255)
	,@statusId INT
	,@pbrVendLocationId bigint
	,@enteredBy nvarchar(50)
	,@dateEntered datetime2(7))
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 DECLARE @currentId BIGINT;
 --DECLARE @CustomerID BIGINT
 --SELECT @CustomerID = PrgCustID
 --from dbo.PRGRM042ProgramBillableLocations PbL
 --INNER JOIN dbo.PRGRM000Master PM ON PM.Id = PbL.PblProgramID 
 --WHERE PbL.Id = @programLocationId  

 INSERT INTO [dbo].[PRGRM040ProgramBillableRate]
           ([ProgramLocationId]
			,[PbrCode]
			,[PbrCustomerCode]
			,[PbrEffectiveDate]
			,[PbrTitle]
			,[RateCategoryTypeId]
			,[RateTypeId]
			,[PbrBillablePrice]
			,[RateUnitTypeId]
			,[PbrFormat]
			,[PbrExpression01]
			,[PbrLogic01]
			,[PbrExpression02]
			,[PbrLogic02]
			,[PbrExpression03]
			,[PbrLogic03]
			,[PbrExpression04]
			,[PbrLogic04]
			,[PbrExpression05]
			,[PbrLogic05]
			,[StatusId]
			,[PbrVendLocationID]
			,[EnteredBy]
			,[DateEntered])
     VALUES
           (@programLocationId
		   	,@pbrCode
		   	,@pbrCustomerCode
		   	,@pbrEffectiveDate
		   	,@pbrTitle
		   	,@rateCategoryTypeId
		   	,@rateTypeId
		   	,@pbrBillablePrice
		   	,@rateUnitTypeId
		   	,@pbrFormat
		   	,@pbrExpression01
		   	,@pbrLogic01
		   	,@pbrExpression02
		   	,@pbrLogic02
		   	,@pbrExpression03
		   	,@pbrLogic03
		   	,@pbrExpression04
		   	,@pbrLogic04
		   	,@pbrExpression05
		   	,@pbrLogic05
		   	,@statusId
		   	,@pbrVendLocationID
		   	,@enteredBy
		   	,@dateEntered)
			SET @currentId = SCOPE_IDENTITY();
	

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
	    ,pbl.PblProgramID ProgramId
  FROM   [dbo].[PRGRM040ProgramBillableRate] prg
  INNER JOIN [dbo].[PRGRM042ProgramBillableLocations] pbl ON pbl.Id = prg.[ProgramLocationId]
 WHERE   prg.[Id] = @currentId

END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
