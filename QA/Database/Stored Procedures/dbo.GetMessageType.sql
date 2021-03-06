SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/22/2018      
-- Description:               Get a message type 
-- Execution:                 EXEC [dbo].[GetMessageType]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE  [dbo].[GetMessageType]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
	@langCode NVARCHAR(10),
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  SELECT syst.[Id]
		,syst.[LangCode]
		,syst.[SysRefId]
		,syst.[SysMsgtypeTitle]
		,syst.[SysMsgTypeHeaderIcon]
		,syst.[SysMsgTypeIcon]
		,syst.[DateEntered]
		,syst.[EnteredBy]
		,syst.[DateChanged]
		,syst.[ChangedBy]
  FROM [dbo].[SYSMS010Ref_MessageTypes] syst
 WHERE [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
