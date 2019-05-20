/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               12/23/2018      
-- Description:               Get left and ribbon main module menus 
-- Execution:                 EXEC [dbo].[GetModuleMenus]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================        
ALTER PROCEDURE [dbo].[GetModuleMenus]     
 @orgId BIGINT,    
 @roleId BIGINT,    
 @langCode NVARCHAR(10)     
AS      
BEGIN TRY        
 SET NOCOUNT ON;       
  SELECT mnu.Id      
  ,mnu.[MnuModuleId]     
  ,mnu.[MnuTableName]     
  ,mnu.[MnuTitle]    
  ,mnu.MnuBreakDownStructure    
  ,mnu.[MnuTabOver]    
  ,mnu.[MnuIconVerySmall]     
  ,mnu.[MnuIconSmall]    
  ,mnu.[MnuIconMedium]    
  ,mnu.[MnuExecuteProgram]     
  ,mnu.[MnuOptionLevelId]    
  ,mnu.[MnuAccessLevelId]    
  ,mnu.[MnuProgramTypeId]    
  ,mnu.[MnuHelpBookMark]    
  ,mnu.[MnuHelpPageNumber]    
  ,mnu.[StatusId]    
 FROM [dbo].[SYSTM000MenuDriver] (NOLOCK) mnu      
  WHERE mnu.[LangCode] = @langCode AND (ISNULL(mnu.StatusId, 1) < 3)
 ORDER BY mnu.[MnuBreakDownStructure]       
END TRY                      
BEGIN CATCH                      
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                      
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                      
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                      
       
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                      
END CATCH
GO

