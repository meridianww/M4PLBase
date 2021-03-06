SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Get page and tab names 
-- Execution:                 EXEC [dbo].[GetPageAndTabNames] 'Job', 'EN'
-- Modified on:  
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[GetPageAndTabNames]
    @tableName NVARCHAR(100),
    @langCode NVARCHAR(10)
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
  FROM [dbo].[SYSTM030Ref_TabPageName] refTpn
  WHERE refTpn.LangCode=@langCode AND refTpn.RefTableName = @tableName AND (ISNULL(refTpn.StatusId, 1) = 1)
  ORDER BY [TabSortOrder] ASC
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
