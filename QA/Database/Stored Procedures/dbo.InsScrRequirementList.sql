SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/29/2018      
-- Description:               Ins a Scr Requirement List
-- Execution:                 EXEC [dbo].[InsScrRequirementList]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE  [dbo].[InsScrRequirementList]		  
	@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@programID bigint = NULL
	,@requirementLineItem int = NULL
	,@requirementCode nvarchar(20) = NULL
	,@requirementTitle nvarchar(50) = NULL
	,@statusId int = NULL
	,@dateEntered datetime2(7)
	,@enteredBy nvarchar(50)
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  DECLARE @updatedItemNumber INT      
 EXEC [dbo].[ResetItemNumber] @userId, 0, @programID, @entity, @requirementLineItem, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT
 DECLARE @currentId BIGINT;
   INSERT INTO [dbo].[SCR012RequirementList]
           ([ProgramID]
			,[RequirementLineItem]
			,[RequirementCode]
			,[RequirementTitle]
			,[StatusId]
			,[DateEntered]
			,[EnteredBy]) 
     VALUES
		   (@programID
			,@updatedItemNumber
			,@requirementCode
			,@requirementTitle
			,@statusId
			,@dateEntered
			,@enteredBy)  		
	SET @currentId = SCOPE_IDENTITY();
	EXEC GetScrRequirementList @userId, @roleId, 0, @currentId;
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
