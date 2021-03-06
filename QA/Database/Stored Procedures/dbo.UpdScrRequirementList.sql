SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/29/2018      
-- Description:               Upd a Scr Requirement List
-- Execution:                 EXEC [dbo].[UpdScrRequirementList]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- ============================================= 
CREATE PROCEDURE  [dbo].[UpdScrRequirementList]		  
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id  BIGINT
	,@programID bigint = NULL
	,@requirementLineItem int = NULL
	,@requirementCode nvarchar(20) = NULL
	,@requirementTitle nvarchar(50) = NULL
	,@statusId int = NULL
	,@changedBy  NVARCHAR(50)
	,@dateChanged  DATETIME2(7)
	,@isFormView BIT = 0
AS
BEGIN TRY                
 SET NOCOUNT ON;  
  DECLARE @updatedItemNumber INT      
 EXEC [dbo].[ResetItemNumber] @userId, @id, @programID, @entity, @requirementLineItem, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT
   UPDATE  [dbo].[SCR012RequirementList] 
      SET    ProgramID    =	CASE WHEN (@isFormView = 1) THEN @programID WHEN ((@isFormView = 0) AND (@programID=-100)) THEN NULL ELSE ISNULL(@programID, ProgramID) END
			,RequirementLineItem     =	CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, RequirementLineItem) END
			,RequirementCode         =	CASE WHEN (@isFormView = 1) THEN @requirementCode WHEN ((@isFormView = 0) AND (@requirementCode='#M4PL#')) THEN NULL ELSE ISNULL(@requirementCode, RequirementCode) END
			,RequirementTitle        =	CASE WHEN (@isFormView = 1) THEN @requirementTitle WHEN ((@isFormView = 0) AND (@requirementTitle='#M4PL#')) THEN NULL ELSE ISNULL(@requirementTitle, RequirementTitle) END
			,StatusId                =	CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
			,DateChanged             =	ISNULL(@dateChanged, DateChanged)
			,ChangedBy               =	ISNULL(@changedBy, ChangedBy)
       WHERE RequirementID = @id		   

	EXEC GetScrRequirementList @userId, @roleId, 0, @id;

END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
