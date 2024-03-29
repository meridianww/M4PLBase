SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Upd a Program Ship Status Reason Code
-- Execution:                 EXEC [dbo].[UpdPrgShipStatusReasonCode]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE  [dbo].[UpdPrgShipStatusReasonCode]
	(@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id bigint
	,@pscOrgId bigint = NULL
	,@pscProgramId bigint = NULL
	,@pscShipItem int = NULL
	,@pscShipReasonCode nvarchar(20) = NULL
	,@pscShipLength int = NULL
	,@pscShipInternalCode nvarchar(20) = NULL
	,@pscShipPriorityCode nvarchar(20) = NULL
	,@pscShipTitle nvarchar(50) = NULL
	,@pscShipCategoryCode nvarchar(20) = NULL
	,@pscShipUser01Code nvarchar(20) = NULL
	,@pscShipUser02Code nvarchar(20) = NULL
	,@pscShipUser03Code nvarchar(20) = NULL
	,@pscShipUser04Code nvarchar(20) = NULL
	,@pscShipUser05Code nvarchar(20) = NULL
	,@statusId int = NULL
	,@dateChanged datetime2(7) = NULL
	,@changedBy nvarchar(50) = NULL
	,@isFormView BIT = 0) 
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 DECLARE @updatedItemNumber INT      
 EXEC [dbo].[ResetItemNumber] @userId, @id, @pscProgramId, @entity, @pscShipItem, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT

 DECLARE @TransactionName varchar(20) = 'Transaction1';

 BEGIN TRAN @TransactionName     
 DECLARE @oldReasonCode varchar(20)
 select @oldReasonCode  = [PscShipReasonCode] from [PRGRM030ShipStatusReasonCodes] where id  = @id
     
UPDATE [PRGRM010Ref_GatewayDefaults] SET PgdShipStatusReasonCode  =  @pscShipReasonCode  where PgdShipStatusReasonCode  = @oldReasonCode

 UPDATE [dbo].[PRGRM030ShipStatusReasonCodes]
		SET  [PscOrgID]              = CASE WHEN (@isFormView = 1) THEN @pscOrgID WHEN ((@isFormView = 0) AND (@pscOrgID=-100)) THEN NULL ELSE ISNULL(@pscOrgID, PscOrgID) END
			,[PscProgramID]          = CASE WHEN (@isFormView = 1) THEN @pscProgramID WHEN ((@isFormView = 0) AND (@pscProgramID=-100)) THEN NULL ELSE ISNULL(@pscProgramID, PscProgramID) END
			,[PscShipItem]           = CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, PscShipItem) END
			,[PscShipReasonCode]     = CASE WHEN (@isFormView = 1) THEN @pscShipReasonCode WHEN ((@isFormView = 0) AND (@pscShipReasonCode='#M4PL#')) THEN NULL ELSE ISNULL(@pscShipReasonCode, PscShipReasonCode) END
			,[PscShipLength]         = CASE WHEN (@isFormView = 1) THEN @pscShipLength WHEN ((@isFormView = 0) AND (@pscShipLength=-100)) THEN NULL ELSE ISNULL(@pscShipLength, PscShipLength) END
			,[PscShipInternalCode]   = CASE WHEN (@isFormView = 1) THEN @pscShipInternalCode WHEN ((@isFormView = 0) AND (@pscShipInternalCode='#M4PL#')) THEN NULL ELSE ISNULL(@pscShipInternalCode, PscShipInternalCode) END
			,[PscShipPriorityCode]   = CASE WHEN (@isFormView = 1) THEN @pscShipPriorityCode WHEN ((@isFormView = 0) AND (@pscShipPriorityCode='#M4PL#')) THEN NULL ELSE ISNULL(@pscShipPriorityCode, PscShipPriorityCode) END
			,[PscShipTitle]          = CASE WHEN (@isFormView = 1) THEN @pscShipTitle WHEN ((@isFormView = 0) AND (@pscShipTitle='#M4PL#')) THEN NULL ELSE ISNULL(@pscShipTitle, PscShipTitle) END
			,[PscShipCategoryCode]   = CASE WHEN (@isFormView = 1) THEN @pscShipCategoryCode WHEN ((@isFormView = 0) AND (@pscShipCategoryCode='#M4PL#')) THEN NULL ELSE ISNULL(@pscShipCategoryCode, PscShipCategoryCode) END
			,[PscShipUser01Code]     = CASE WHEN (@isFormView = 1) THEN @pscShipUser01Code WHEN ((@isFormView = 0) AND (@pscShipUser01Code='#M4PL#')) THEN NULL ELSE ISNULL(@pscShipUser01Code, PscShipUser01Code) END
			,[PscShipUser02Code]     = CASE WHEN (@isFormView = 1) THEN @pscShipUser02Code WHEN ((@isFormView = 0) AND (@pscShipUser02Code='#M4PL#')) THEN NULL ELSE ISNULL(@pscShipUser02Code, PscShipUser02Code) END
			,[PscShipUser03Code]     = CASE WHEN (@isFormView = 1) THEN @pscShipUser03Code WHEN ((@isFormView = 0) AND (@pscShipUser03Code='#M4PL#')) THEN NULL ELSE ISNULL(@pscShipUser03Code, PscShipUser03Code) END
			,[PscShipUser04Code]     = CASE WHEN (@isFormView = 1) THEN @pscShipUser04Code WHEN ((@isFormView = 0) AND (@pscShipUser04Code='#M4PL#')) THEN NULL ELSE ISNULL(@pscShipUser04Code, PscShipUser04Code) END
			,[PscShipUser05Code]     = CASE WHEN (@isFormView = 1) THEN @pscShipUser05Code WHEN ((@isFormView = 0) AND (@pscShipUser05Code='#M4PL#')) THEN NULL ELSE ISNULL(@pscShipUser05Code, PscShipUser05Code) END
			,[StatusId]				 = CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END	
			,[DateChanged]           = @dateChanged
			,[ChangedBy]             = @changedBy
	 WHERE   [Id] = @id
	SELECT prg.[Id]
		,prg.[PscOrgID]
		,prg.[PscProgramID]
		,prg.[PscShipItem]
		,prg.[PscShipReasonCode]
		,prg.[PscShipLength]
		,prg.[PscShipInternalCode]
		,prg.[PscShipPriorityCode]
		,prg.[PscShipTitle]
		,prg.[PscShipCategoryCode]
		,prg.[PscShipUser01Code]
		,prg.[PscShipUser02Code]
		,prg.[PscShipUser03Code]
		,prg.[PscShipUser04Code]
		,prg.[PscShipUser05Code]
		,prg.[StatusId]
		,prg.[DateEntered]
		,prg.[EnteredBy]
		,prg.[DateChanged]
		,prg.[ChangedBy]
  FROM   [dbo].[PRGRM030ShipStatusReasonCodes] prg
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
GO
