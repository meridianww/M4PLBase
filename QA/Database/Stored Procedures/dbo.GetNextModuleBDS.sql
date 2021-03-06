SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana         
-- Create date:               04/06/2018      
-- Description:               Get Next Module Breakdown Strusture 
-- Execution:                 EXEC [dbo].[GetNextModuleBDS]
-- Modified on:  
-- Modified Desc:  
-- =============================================    
CREATE PROCEDURE [dbo].[GetNextModuleBDS] 
 @langCode NVARCHAR(10),
 @mnuRibbon BIT  
AS      
BEGIN TRY        
 SET NOCOUNT ON;       
  SELECT TOP 1 CAST(PARSENAME(MnuBreakDownStructure,2) AS VARCHAR) +'.' + FORMAT((PARSENAME(MnuBreakDownStructure,1) +1) ,'00') from SYSTM000MenuDriver
  WHERE MnuRibbon = @mnuRibbon 
    AND Len(MnuBreakDownStructure) = 5
	AND LangCode = @langCode
  Order By MnuBreakDownStructure DESC     
END TRY                      
BEGIN CATCH                      
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                      
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                      
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                      
       
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                      
END CATCH
GO
