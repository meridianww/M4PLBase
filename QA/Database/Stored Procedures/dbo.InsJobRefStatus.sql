SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Ins a Job Ref Status
-- Execution:                 EXEC [dbo].[InsJobRefStatus]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================

CREATE PROCEDURE  [dbo].[InsJobRefStatus]
	(@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@jobId bigint
	,@jbsOutlineCode nvarchar(20)
	,@jbsStatusCode nvarchar(25)
	,@jbsTitle nvarchar(50)
	,@statusId int
	,@severityId int
	,@enteredBy nvarchar(50)
	,@dateEntered datetime2(7))
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 DECLARE @currentId BIGINT;
 INSERT INTO [dbo].[JOBDL050Ref_Status]
           ([JobID]
			,[JbsOutlineCode]
			,[JbsStatusCode]
			,[JbsTitle]
			,[StatusId]
			,[SeverityId]
			,[EnteredBy]
			,[DateEntered])
     VALUES
           (@jobId
		   	,@jbsOutlineCode
		   	,@jbsStatusCode
		   	,@jbsTitle
		   	,@statusId
		   	,@severityId
		   	,@enteredBy
		   	,@dateEntered)
			SET @currentId = SCOPE_IDENTITY();
	SELECT * FROM [dbo].[JOBDL050Ref_Status] WHERE Id = @currentId; 
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
