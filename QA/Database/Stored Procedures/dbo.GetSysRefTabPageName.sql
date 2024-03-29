SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/22/2018      
-- Description:               Get a Sys Ref ref tab page name
-- Execution:                 EXEC [dbo].[GetSysRefTabPageName]  
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================  
CREATE PROCEDURE  [dbo].[GetSysRefTabPageName]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @langCode NVARCHAR(10),
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
	SELECT refTpn.[Id]
		,refTpn.[LangCode]
		,refTpn.[RefTableName]
		,refTpn.[TabSortOrder]
		,refTpn.[TabTableName]
		,refTpn.[TabPageTitle]
		,refTpn.[TabExecuteProgram]
		,refTpn.[TabPageIcon]
		,refTpn.[StatusId]
		,refTpn.[DateEntered]
		,refTpn.[EnteredBy]
		,refTpn.[DateChanged]
		,refTpn.[ChangedBy]
 FROM [dbo].[SYSTM030Ref_TabPageName] refTpn
 WHERE [Id]=@id AND refTpn.LangCode= @langCode
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
