SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/29/2018      
-- Description:               Ins a Scr Osd Reason List
-- Execution:                 EXEC [dbo].[InsScrOsdReasonList]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- ============================================= 
CREATE PROCEDURE  [dbo].[InsScrOsdReasonList]		  
	@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@programID bigint = NULL
	,@reasonItemNumber int = NULL
	,@reasonIDCode nvarchar(20) = NULL
	,@reasonTitle nvarchar(50) = NULL
	,@statusId int = NULL
	,@dateEntered datetime2(7)
	,@enteredBy nvarchar(50)
AS
BEGIN TRY                
 SET NOCOUNT ON;  
  DECLARE @updatedItemNumber INT      
 EXEC [dbo].[ResetItemNumber] @userId, 0, @programID, @entity, @reasonItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT 
 DECLARE @currentId BIGINT;
   INSERT INTO [dbo].[SCR011OSDReasonList]
           ( [ProgramID]
			,[ReasonItemNumber]
			,[ReasonIDCode]
			,[ReasonTitle]
			,[StatusId]
			,[DateEntered]
			,[EnteredBy]) 
     VALUES
		   ( @programID
			,@updatedItemNumber
			,@reasonIDCode
			,@reasonTitle
			,@statusId
			,@dateEntered
			,@enteredBy)  		
	SET @currentId = SCOPE_IDENTITY();
	
	EXEC GetScrOsdReasonList @userId,@roleId,0,@currentId;

END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
