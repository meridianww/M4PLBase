SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/22/2018      
-- Description:               Get a system message
-- Execution:                 EXEC [dbo].[GetSystemMessage]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
CREATE PROCEDURE  [dbo].[GetSystemMessage]
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
		,syst.[SysMessageCode]
		,syst.[SysRefId]
		,syst.[SysMessageScreenTitle]
		,syst.[SysMessageTitle]
		,syst.[SysMessageDescription]
		,syst.[SysMessageInstruction]
		,syst.[SysMessageButtonSelection]
		,syst.[DateEntered]
		,syst.[EnteredBy]
		,syst.[DateChanged]
		,syst.[ChangedBy]
  FROM [dbo].[SYSTM000Master] syst
 WHERE [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
