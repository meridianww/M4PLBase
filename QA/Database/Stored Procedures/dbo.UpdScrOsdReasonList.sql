SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/29/2018      
-- Description:               Upd a Scr Osd Reason List
-- Execution:                 EXEC [dbo].[UpdScrOsdReasonList]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE  [dbo].[UpdScrOsdReasonList]		  
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id  BIGINT
	,@programID bigint = NULL
	,@reasonItemNumber int = NULL
	,@reasonIDCode nvarchar(20) = NULL
	,@reasonTitle nvarchar(50) = NULL
	,@statusId int = NULL
	,@changedBy  NVARCHAR(50)
	,@dateChanged  DATETIME2(7)
	,@isFormView BIT = 0
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  DECLARE @updatedItemNumber INT      
EXEC [dbo].[ResetItemNumber] @userId, @id, @programID, @entity, @reasonItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT 
   UPDATE  [dbo].[SCR011OSDReasonList] 
      SET    ProgramID     =	CASE WHEN (@isFormView = 1) THEN @programID WHEN ((@isFormView = 0) AND (@programID=-100)) THEN NULL ELSE ISNULL(@programID, ProgramID) END
			,ReasonItemNumber    =	CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, ReasonItemNumber) END
			,ReasonIDCode          =	CASE WHEN (@isFormView = 1) THEN @reasonIDCode WHEN ((@isFormView = 0) AND (@reasonIDCode='#M4PL#')) THEN NULL ELSE ISNULL(@reasonIDCode, ReasonIDCode) END
			,ReasonTitle         =	CASE WHEN (@isFormView = 1) THEN @reasonTitle WHEN ((@isFormView = 0) AND (@reasonTitle='#M4PL#')) THEN NULL ELSE ISNULL(@reasonTitle, ReasonTitle) END
			,StatusId            =	CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
			,DateChanged         =	ISNULL(@dateChanged, DateChanged)
			,ChangedBy           =	ISNULL(@changedBy, ChangedBy)
       WHERE ReasonID = @id		   

	EXEC GetScrOsdReasonList @userId,@roleId,0,@id;

END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
