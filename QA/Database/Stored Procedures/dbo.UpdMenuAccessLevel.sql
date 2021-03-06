SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan   
-- Create date:               08/16/2018      
-- Description:               Upd a sys menu access level
-- Execution:                 EXEC [dbo].[UpdMenuAccessLevel]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE  [dbo].[UpdMenuAccessLevel]		  
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@langCode NVARCHAR(10)
	,@id INT
	,@sysRefId INT
	,@malOrder INT  = NULL
	,@malTitle NVARCHAR(50) = NULL 
	,@dateChanged DATETIME2(7) = NULL 
	,@changedBy NVARCHAR(50) = NULL
	,@isFormView BIT = 0
AS
BEGIN TRY                
 SET NOCOUNT ON;   
   UPDATE  [dbo].[SYSTM010MenuAccessLevel]
    SET     LangCode		=  CASE WHEN (@isFormView = 1) THEN @langCode WHEN ((@isFormView = 0) AND (@langCode='#M4PL#')) THEN LangCode ELSE ISNULL(@langCode, LangCode)  END  
           ,SysRefId 		=  @sysRefId  
           ,MalOrder 		=  CASE WHEN (@isFormView = 1) THEN @malOrder WHEN ((@isFormView = 0) AND (@malOrder=-100)) THEN NULL ELSE ISNULL(@malOrder, MalOrder) END
           ,MalTitle 		=  CASE WHEN (@isFormView = 1) THEN @malTitle WHEN ((@isFormView = 0) AND (@malTitle='#M4PL#')) THEN NULL ELSE ISNULL(@malTitle, MalTitle) END   
           ,DateChanged 	=  @dateChanged  
           ,ChangedBy		=  @changedBy    
      WHERE Id =  @id
	SELECT syst.[Id]
      ,syst.[LangCode]
      ,syst.[SysRefId]
      ,syst.[MalOrder]
      ,syst.[MalTitle]
      ,syst.[DateEntered]
      ,syst.[EnteredBy]
      ,syst.[DateChanged]
      ,syst.[ChangedBy]
  FROM [dbo].[SYSTM010MenuAccessLevel] syst
 WHERE [Id]=@id  
END TRY       
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
