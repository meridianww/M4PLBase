SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Upd a Job Attribute
-- Execution:                 EXEC [dbo].[UpdJobAttribute]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE  [dbo].[UpdJobAttribute]
(@userId BIGINT
,@roleId BIGINT  
,@entity NVARCHAR(100)
,@id bigint
,@jobId bigint = NULL
,@ajbLineOrder int = NULL
,@ajbAttributeCode nvarchar(20) = NULL
,@ajbAttributeTitle nvarchar(50) = NULL
,@ajbAttributeQty decimal(18, 2) = NULL
,@ajbUnitTypeId int = NULL
,@ajbDefault bit = NULL
,@statusId int = NULL
,@dateChanged datetime2(7) = NULL
,@changedBy nvarchar(50) = NULL
,@isFormView BIT = 0) 
AS
BEGIN TRY                
 SET NOCOUNT ON; 
 DECLARE @updatedItemNumber INT      
   EXEC [dbo].[ResetItemNumber] @userId, @id, @jobId, @entity, @ajbLineOrder, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT 
   
 UPDATE [dbo].[JOBDL030Attributes]
		SET  [JobID]                     = CASE WHEN (@isFormView = 1) THEN @jobId WHEN ((@isFormView = 0) AND (@jobId=-100)) THEN NULL ELSE ISNULL(@jobId, JobID) END
			,[AjbLineOrder]              = CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, AjbLineOrder) END
			,[AjbAttributeCode]          = CASE WHEN (@isFormView = 1) THEN @ajbAttributeCode WHEN ((@isFormView = 0) AND (@ajbAttributeCode='#M4PL#')) THEN NULL ELSE ISNULL(@ajbAttributeCode, AjbAttributeCode) END
			,[AjbAttributeTitle]         = CASE WHEN (@isFormView = 1) THEN @ajbAttributeTitle WHEN ((@isFormView = 0) AND (@ajbAttributeTitle='#M4PL#')) THEN NULL ELSE ISNULL(@ajbAttributeTitle, AjbAttributeTitle) END
			,[AjbAttributeQty]           = CASE WHEN (@isFormView = 1) THEN @ajbAttributeQty WHEN ((@isFormView = 0) AND (@ajbAttributeQty=-100.00)) THEN NULL ELSE ISNULL(@ajbAttributeQty, AjbAttributeQty) END
			,[AjbUnitTypeId]			 = CASE WHEN (@isFormView = 1) THEN @ajbUnitTypeId WHEN ((@isFormView = 0) AND (@ajbUnitTypeId=-100)) THEN NULL ELSE ISNULL(@ajbUnitTypeId, AjbUnitTypeId) END
			,[AjbDefault]                = ISNULL(@ajbDefault, AjbDefault)
			,[StatusId]		             = CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
			,[DateChanged]               = @dateChanged
			,[ChangedBy]                 = @changedBy
	 WHERE   [Id] = @id
	SELECT job.[Id]
		,job.[JobID]
		,job.[AjbLineOrder]
		,job.[AjbAttributeCode]
		,job.[AjbAttributeTitle]
		,job.[AjbAttributeQty]
		,job.[AjbUnitTypeId]
		,job.[AjbDefault]
		,job.[StatusId]
		,job.[DateEntered]
		,job.[EnteredBy]
		,job.[DateChanged]
		,job.[ChangedBy]
  FROM   [dbo].[JOBDL030Attributes] job
 WHERE   [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
