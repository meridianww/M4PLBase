USE [M4PL_FreshCopy]
GO
/****** Object:  StoredProcedure [dbo].[UpdPrgShipApptmtReasonCode]    Script Date: 5/22/2019 8:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Upd a Program Ship Apptmt Reason Code
-- Execution:                 EXEC [dbo].[UpdPrgShipApptmtReasonCode]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[UpdPrgShipApptmtReasonCode]
	(@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id bigint
	,@pacOrgId bigint = NULL
	,@pacProgramId bigint = NULL
	,@pacApptItem int = NULL
	,@pacApptReasonCode nvarchar(20) = NULL
	,@pacApptLength int = NULL
	,@pacApptInternalCode nvarchar(20) = NULL
	,@pacApptPriorityCode nvarchar(20) = NULL
	,@pacApptTitle nvarchar(50) = NULL
	,@pacApptCategoryCodeId int = NULL
	,@pacApptUser01Code nvarchar(20) = NULL
	,@pacApptUser02Code nvarchar(20) = NULL
	,@pacApptUser03Code nvarchar(20) = NULL
	,@pacApptUser04Code nvarchar(20) = NULL
	,@pacApptUser05Code nvarchar(20) = NULL
	,@statusId int = NULL
	,@dateChanged datetime2(7) = NULL
	,@changedBy nvarchar(50) = NULL
	,@isFormView BIT = 0) 
AS
BEGIN TRY                
 SET NOCOUNT ON;   
   DECLARE @updatedItemNumber INT      
 EXEC [dbo].[ResetItemNumber] @userId, @id, @pacProgramId, @entity, @pacApptItem, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT 

  DECLARE @TransactionName varchar(20) = 'Transaction1';

 BEGIN TRAN @TransactionName     
 DECLARE @oldReasonCode varchar(20)
 select @oldReasonCode  = [PacApptReasonCode] from [PRGRM031ShipApptmtReasonCodes] where id  = @id

 UPDATE [PRGRM010Ref_GatewayDefaults] SET PgdShipApptmtReasonCode  =  @pacApptReasonCode  where PgdShipApptmtReasonCode  = @oldReasonCode

 UPDATE [dbo].[PRGRM031ShipApptmtReasonCodes]
		SET  [PacOrgID]              = CASE WHEN (@isFormView = 1) THEN @pacOrgID WHEN ((@isFormView = 0) AND (@pacOrgID=-100)) THEN NULL ELSE ISNULL(@pacOrgID, PacOrgID) END
			,[PacProgramID]          = CASE WHEN (@isFormView = 1) THEN @pacProgramID WHEN ((@isFormView = 0) AND (@pacProgramID=-100)) THEN NULL ELSE ISNULL(@pacProgramID, PacProgramID) END
			,[PacApptItem]           = CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, PacApptItem) END
			,[PacApptReasonCode]     = CASE WHEN (@isFormView = 1) THEN @pacApptReasonCode WHEN ((@isFormView = 0) AND (@pacApptReasonCode='#M4PL#')) THEN NULL ELSE ISNULL(@pacApptReasonCode, PacApptReasonCode) END
			,[PacApptLength]         = CASE WHEN (@isFormView = 1) THEN @pacApptLength WHEN ((@isFormView = 0) AND (@pacApptLength=-100)) THEN NULL ELSE ISNULL(@pacApptLength, PacApptLength) END
			,[PacApptInternalCode]   = CASE WHEN (@isFormView = 1) THEN @pacApptInternalCode WHEN ((@isFormView = 0) AND (@pacApptInternalCode='#M4PL#')) THEN NULL ELSE ISNULL(@pacApptInternalCode, PacApptInternalCode) END
			,[PacApptPriorityCode]   = CASE WHEN (@isFormView = 1) THEN @pacApptPriorityCode WHEN ((@isFormView = 0) AND (@pacApptPriorityCode='#M4PL#')) THEN NULL ELSE ISNULL(@pacApptPriorityCode, PacApptPriorityCode) END
			,[PacApptTitle]          = CASE WHEN (@isFormView = 1) THEN @pacApptTitle WHEN ((@isFormView = 0) AND (@pacApptTitle='#M4PL#')) THEN NULL ELSE ISNULL(@pacApptTitle, PacApptTitle) END
			,[PacApptCategoryCodeId] = CASE WHEN (@isFormView = 1) THEN @pacApptCategoryCodeId WHEN ((@isFormView = 0) AND (@pacApptCategoryCodeId=-100)) THEN NULL ELSE ISNULL(@pacApptCategoryCodeId, PacApptCategoryCodeId) END
			,[PacApptUser01Code]     = CASE WHEN (@isFormView = 1) THEN @pacApptUser01Code WHEN ((@isFormView = 0) AND (@pacApptUser01Code='#M4PL#')) THEN NULL ELSE ISNULL(@pacApptUser01Code, PacApptUser01Code) END
			,[PacApptUser02Code]     = CASE WHEN (@isFormView = 1) THEN @pacApptUser02Code WHEN ((@isFormView = 0) AND (@pacApptUser02Code='#M4PL#')) THEN NULL ELSE ISNULL(@pacApptUser02Code, PacApptUser02Code) END
			,[PacApptUser03Code]     = CASE WHEN (@isFormView = 1) THEN @pacApptUser03Code WHEN ((@isFormView = 0) AND (@pacApptUser03Code='#M4PL#')) THEN NULL ELSE ISNULL(@pacApptUser03Code, PacApptUser03Code) END
			,[PacApptUser04Code]     = CASE WHEN (@isFormView = 1) THEN @pacApptUser04Code WHEN ((@isFormView = 0) AND (@pacApptUser04Code='#M4PL#')) THEN NULL ELSE ISNULL(@pacApptUser04Code, PacApptUser04Code) END
			,[PacApptUser05Code]     = CASE WHEN (@isFormView = 1) THEN @pacApptUser05Code WHEN ((@isFormView = 0) AND (@pacApptUser05Code='#M4PL#')) THEN NULL ELSE ISNULL(@pacApptUser05Code, PacApptUser05Code) END
			,[StatusId]				 = CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId)	 END
			,[DateChanged]           = @dateChanged
			,[ChangedBy]             = @changedBy
	 WHERE   [Id] = @id
	SELECT prg.[Id]
		,prg.[PacOrgID]
		,prg.[PacProgramID]
		,prg.[PacApptItem]
		,prg.[PacApptReasonCode]
		,prg.[PacApptLength]
		,prg.[PacApptInternalCode]
		,prg.[PacApptPriorityCode]
		,prg.[PacApptTitle]
		,prg.[PacApptCategoryCodeId]
		,prg.[PacApptUser01Code]
		,prg.[PacApptUser02Code]
		,prg.[PacApptUser03Code]
		,prg.[PacApptUser04Code]
		,prg.[PacApptUser05Code]
		,prg.[StatusId]
		,prg.[DateEntered]
		,prg.[EnteredBy]
		,prg.[DateChanged]
		,prg.[ChangedBy]
  FROM   [dbo].[PRGRM031ShipApptmtReasonCodes] prg
 WHERE   [Id] = @id
COMMIT TRANSACTION @TransactionName
END TRY                
BEGIN CATCH  
ROLLBACK TRANSACTION @TransactionName;            
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH