SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan             
-- Create date:               12/23/2018      
-- Description:               Get default Ribbon
-- Execution:                 EXEC [dbo].[GetRibbonMenus]
-- Modified on:  
-- Modified Desc:  
-- ============================================= 
CREATE PROCEDURE [dbo].[GetRibbonMenus]
    @langCode NVARCHAR(10) 
AS  
BEGIN TRY    
 SET NOCOUNT ON;     
 SELECT mnu.Id  
		,mnu.[MnuModuleId] 
		,mnu.[MnuTableName] 
		,mnu.[MnuTitle]
		,mnu.[MnuBreakDownStructure]
		,mnu.[MnuTabOver]
		,mnu.[MnuIconVerySmall] 
		,mnu.[MnuIconMedium]
		,mnu.[MnuExecuteProgram] 
		,mnu.[MnuAccessLevelId]
		,mnu.[StatusId]
 FROM [dbo].[SYSTM000MenuDriver] (NOLOCK) mnu  
 WHERE mnu.[LangCode] = @langCode AND (mnu.MnuModuleId IS NULL OR  mnu.MnuModuleId < 1) AND (ISNULL(mnu.StatusId, 1) < 3)  
 ORDER BY mnu.[MnuBreakDownStructure]  
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
   
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
