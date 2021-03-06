SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Upd a Job Ref Status
-- Execution:                 EXEC [dbo].[UpdJobRefStatus]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE  [dbo].[UpdJobRefStatus]
	(@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id bigint
	,@jobId bigint = NULL
	,@jbsOutlineCode nvarchar(20) = NULL
	,@jbsStatusCode nvarchar(25) = NULL
	,@jbsTitle nvarchar(50) = NULL
	,@statusId int = NULL
	,@severityId int = NULL
	,@changedBy nvarchar(50) = NULL
	,@dateChanged datetime2(7) = NULL
	,@isFormView BIT = 0) 
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 UPDATE [dbo].[JOBDL050Ref_Status]
		SET  [JobID]          = CASE WHEN (@isFormView = 1) THEN @jobId WHEN ((@isFormView = 0) AND (@jobId=-100)) THEN NULL ELSE ISNULL(@jobId, JobID) END
			,[JbsOutlineCode] = CASE WHEN (@isFormView = 1) THEN @jbsOutlineCode WHEN ((@isFormView = 0) AND (@jbsOutlineCode='#M4PL#')) THEN NULL ELSE ISNULL(@jbsOutlineCode, JbsOutlineCode) END
			,[JbsStatusCode]  = CASE WHEN (@isFormView = 1) THEN @jbsStatusCode WHEN ((@isFormView = 0) AND (@jbsStatusCode='#M4PL#')) THEN NULL ELSE ISNULL(@jbsStatusCode, JbsStatusCode ) END
			,[JbsTitle]       = CASE WHEN (@isFormView = 1) THEN @jbsTitle WHEN ((@isFormView = 0) AND (@jbsTitle='#M4PL#')) THEN NULL ELSE ISNULL(@jbsTitle, JbsTitle) END
			,[StatusId]		  = CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId)  END
			,[SeverityId]	  = CASE WHEN (@isFormView = 1) THEN @severityId WHEN ((@isFormView = 0) AND (@severityId=-100)) THEN NULL ELSE ISNULL(@severityId, SeverityId) END
			,[ChangedBy]      = @changedBy
			,[DateChanged]    = @dateChanged
	 WHERE   [Id] = @id
	SELECT job.[Id]
		,job.[JobID]
		,job.[JbsOutlineCode]
		,job.[JbsStatusCode]
		,job.[JbsTitle]
		,job.[StatusId]
		,job.[SeverityId]
		,job.[EnteredBy]
		,job.[DateEntered]
		,job.[ChangedBy]
		,job.[DateChanged]
  FROM   [dbo].[JOBDL050Ref_Status] job WHERE   [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
