SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/29/2018      
-- Description:               Upd a Scr Osd List
-- Execution:                 EXEC [dbo].[UpdScrOsdList]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE  [dbo].[UpdScrOsdList]		  
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id  BIGINT
	,@programID bigint = NULL
	,@osdItemNumber int = NULL
	,@osdCode nvarchar(20) = NULL
	,@osdTitle nvarchar(50) = NULL
	,@oSDType nvarchar(20) = NULL
	,@statusId int = NULL
	,@changedBy  NVARCHAR(50)
	,@dateChanged  DATETIME2(7)
	,@isFormView BIT = 0
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  DECLARE @updatedItemNumber INT      
 EXEC [dbo].[ResetItemNumber] @userId, @id, @programID, @entity, @osdItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT  

   UPDATE  [dbo].[SCR011OSDList] 
      SET    ProgramID        =	CASE WHEN (@isFormView = 1) THEN @programID WHEN ((@isFormView = 0) AND (@programID=-100)) THEN NULL ELSE ISNULL(@programID, ProgramID) END
			,OSDItemNumber       =	CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, OSDItemNumber) END
			,OSDCode             =	CASE WHEN (@isFormView = 1) THEN @osdCode WHEN ((@isFormView = 0) AND (@osdCode='#M4PL#')) THEN NULL ELSE ISNULL(@osdCode, OSDCode) END
			,OSDTitle            =	CASE WHEN (@isFormView = 1) THEN @osdTitle WHEN ((@isFormView = 0) AND (@osdTitle='#M4PL#')) THEN NULL ELSE ISNULL(@osdTitle, OSDTitle) END
			,OSDType           =	CASE WHEN (@isFormView = 1) THEN @oSDType WHEN ((@isFormView = 0) AND (@oSDType='#M4PL#')) THEN NULL ELSE ISNULL(@oSDType, OSDType) END
			,StatusId            =	CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
			,DateChanged         =	ISNULL(@dateChanged, DateChanged)
			,ChangedBy           =	ISNULL(@changedBy, ChangedBy)
       WHERE OSDID = @id		   


EXEC GetScrOsdList @userId,@roleId,0,@id;

	

END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
