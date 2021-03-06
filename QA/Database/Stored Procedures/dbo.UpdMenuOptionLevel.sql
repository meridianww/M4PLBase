SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan   
-- Create date:               08/16/2018      
-- Description:               Upd a Sys menu Option level
-- Execution:                 EXEC [dbo].[UpdMenuOptionLevel]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE  [dbo].[UpdMenuOptionLevel]		  
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@langCode NVARCHAR(10)
	,@id INT
	,@sysRefId INt
	,@molOrder int = NULL 
	,@molMenuLevelTitle nvarchar(50) = NULL 
	,@molMenuAccessDefault int = NULL 
	,@molMenuAccessOnly bit = NULL  
	,@dateChanged datetime2(7) = NULL 
	,@changedBy nvarchar(50) = NULL
	,@isFormView BIT = 0
AS
BEGIN TRY                
 SET NOCOUNT ON;   
   UPDATE [dbo].[SYSTM010MenuOptionLevel]
     SET    LangCode 			 = CASE WHEN (@isFormView = 1) THEN @langCode WHEN ((@isFormView = 0) AND (@langCode='#M4PL#')) THEN LangCode ELSE ISNULL(@langCode, LangCode)  END  
           ,SysRefId 			 = @sysRefId   
           ,MolOrder 			 = CASE WHEN (@isFormView = 1) THEN @molOrder WHEN ((@isFormView = 0) AND (@molOrder=-100)) THEN NULL ELSE ISNULL(@molOrder, MolOrder) END
           ,MolMenuLevelTitle 	 = CASE WHEN (@isFormView = 1) THEN @molMenuLevelTitle WHEN ((@isFormView = 0) AND (@molMenuLevelTitle='#M4PL#')) THEN NULL ELSE ISNULL(@molMenuLevelTitle, MolMenuLevelTitle) END
           ,MolMenuAccessDefault = CASE WHEN (@isFormView = 1) THEN @molMenuAccessDefault WHEN ((@isFormView = 0) AND (@molMenuAccessDefault=-100)) THEN NULL ELSE ISNULL(@molMenuAccessDefault, MolMenuAccessDefault) END 
           ,MolMenuAccessOnly  	 = ISNULL(@molMenuAccessOnly, MolMenuAccessOnly)
           ,DateChanged 		 = @dateChanged  
           ,ChangedBy			 = @changedBy    
      WHERE Id = @id
	SELECT syst.[Id]
      ,syst.[LangCode]
      ,syst.[SysRefId]
      ,syst.[MolOrder]
      ,syst.[MolMenuLevelTitle]
      ,syst.[MolMenuAccessDefault]
      ,syst.[MolMenuAccessOnly]
      ,syst.[DateEntered]
      ,syst.[EnteredBy]
      ,syst.[DateChanged]
      ,syst.[ChangedBy]
  FROM [dbo].[SYSTM010MenuOptionLevel] syst
 WHERE [Id]=@id 
END TRY   
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
