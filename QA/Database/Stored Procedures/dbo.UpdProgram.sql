SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Upd a Program  
-- Execution:                 EXEC [dbo].[UpdProgram]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE  [dbo].[UpdProgram]  
	(@userId BIGINT  
	,@roleId BIGINT  
	,@entity NVARCHAR(100)  
	,@id bigint
	,@parentId bigint  
	,@prgOrgId bigint  
	,@prgCustId bigint  
	,@prgItemNumber nvarchar(20)  
	,@prgProgramCode nvarchar(20)  
	,@prgProjectCode nvarchar(20)  
	,@prgPhaseCode nvarchar(20)  
	,@prgProgramTitle nvarchar(50)  
	,@prgAccountCode nvarchar(50)  
	,@delEarliest decimal(18,2) = NULL
	,@delLatest decimal(18,2) = NULL
	,@delDay BIT
	,@pckEarliest decimal(18,2)  = NULL
	,@pckLatest decimal(18,2) = NULL
	,@pckDay BIT
	,@statusId INT  
	,@prgDateStart datetime2(7)  
	,@prgDateEnd datetime2(7)  
	,@prgDeliveryTimeDefault datetime2(7)  
	,@prgPickUpTimeDefault datetime2(7)  
	,@dateChanged datetime2(7)  
	,@changedBy nvarchar(50)
	,@isFormView BIT = 0
	,@prgRollUpBilling BIT 
	,@prgRollUpBillingJobFieldId BIGINT
	,@prgElectronicInvoice BIT )   
AS  
BEGIN TRY                  
 SET NOCOUNT ON;     
 UPDATE PRGRM000Master
        SET PrgOrgID				=  ISNULL(@prgOrgId,PrgOrgID) 
		   ,PrgCustId				=  ISNULL(@prgCustId,PrgCustID) 
		   ,PrgItemNumber			=  ISNULL(@prgItemNumber,PrgItemNumber) 
		   ,PrgProgramCode			=  ISNULL(@prgProgramCode,PrgProgramCode) 
		   ,PrgProjectCode			=  ISNULL(@prgProjectCode,PrgProjectCode) 
		   ,PrgPhaseCode			=  ISNULL(@prgPhaseCode,PrgPhaseCode) 
		   ,PrgProgramTitle			=  ISNULL(@prgProgramTitle,PrgProgramTitle) 
		   ,PrgAccountCode			=  ISNULL(@prgAccountCode,PrgAccountCode)
		   ,DelEarliest				=  @delEarliest--ISNULL(@delEarliest, DelEarliest) 
		   ,DelLatest				=  @delLatest--ISNULL(@delLatest, DelLatest) 
		   ,DelDay					=  ISNULL(@delDay, DelDay)
		   ,PckEarliest				=  ISNULL(@pckEarliest, PckEarliest) 
		   ,PckLatest				=  ISNULL(@pckLatest, PckLatest) 
		   ,PckDay					=  ISNULL(@pckDay, PckDay)
		   ,StatusId				=  ISNULL(@statusId,StatusId) 
		   ,PrgRollUpBilling		=  CASE WHEN @isFormView = 1 THEN @prgRollUpBilling ELSE ISNULL(@prgRollUpBilling, PrgRollUpBilling) END
		   ,PrgRollUpBillingJobFieldId	=  CASE WHEN @isFormView = 1 THEN @prgRollUpBillingJobFieldId ELSE ISNULL(@prgRollUpBillingJobFieldId, PrgRollUpBillingJobFieldId) END
		   ,PrgElectronicInvoice					=  ISNULL(@prgElectronicInvoice, PrgElectronicInvoice)
		   ,PrgDateStart			=  CASE WHEN (CONVERT(CHAR(10), @prgDateStart, 103)='01/01/1753') THEN NULL ELSE ISNULL(@prgDateStart,PrgDateStart) END
		   ,PrgDateEnd				=  CASE WHEN (CONVERT(CHAR(10), @prgDateEnd, 103)='01/01/1753') THEN NULL ELSE ISNULL(@prgDateEnd,PrgDateEnd) END
		   ,PrgDeliveryTimeDefault  =  CASE WHEN (CONVERT(CHAR(10), @prgDeliveryTimeDefault, 103)='01/01/1753') THEN NULL ELSE ISNULL(@prgDeliveryTimeDefault,PrgDeliveryTimeDefault) END
		   ,PrgPickUpTimeDefault	=  CASE WHEN (CONVERT(CHAR(10), @prgPickUpTimeDefault, 103)='01/01/1753') THEN NULL ELSE ISNULL(@prgPickUpTimeDefault,PrgPickUpTimeDefault) END
		   ,DateChanged				=  ISNULL(@dateChanged,DateChanged)
		   ,ChangedBy				=  ISNULL(@changedBy,ChangedBy)
		   WHERE Id = @id

  SELECT prg.[Id]        
  ,prg.[PrgOrgID]        
  ,prg.[PrgCustID]        
  ,prg.[PrgItemNumber]        
  ,prg.[PrgProgramCode]        
  ,prg.[PrgProjectCode]        
  ,prg.[PrgPhaseCode]        
  ,prg.[PrgProgramTitle]        
  ,prg.[PrgAccountCode] 
  ,prg.[DelEarliest] 
  ,prg.[DelLatest] 
  ,prg.[DelDay] 
  ,prg.[PckEarliest] 
  ,prg.[PckLatest] 
  ,prg.[PckDay]        
  ,prg.[StatusId]        
  ,prg.[PrgDateStart]        
  ,prg.[PrgDateEnd]        
  ,prg.[PrgDeliveryTimeDefault]        
  ,prg.[PrgPickUpTimeDefault]        
  ,prg.[PrgHierarchyID].ToString() As PrgHierarchyID         
  ,prg.[PrgHierarchyLevel]
  ,prg.[PrgRollUpBilling]
  ,prg.[PrgRollUpBillingJobFieldId]    
  ,Col.[ColTableName] PrgRollUpBillingJobFieldIdName   
  ,prg.[DateEntered]        
  ,prg.[EnteredBy]        
  ,prg.[DateChanged]        
  ,prg.[ChangedBy]  
  ,prg.[PrgRollUpBilling]
  ,prg.[PrgRollUpBillingJobFieldId]
  ,prg.[PrgElectronicInvoice]   
  FROM   [dbo].[PRGRM000Master] prg   
  LEFT JOIN SYSTM000ColumnsAlias Col ON Col.Id = prg.PrgRollUpBillingJobFieldId
  WHERE prg.Id = @id  
  
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
