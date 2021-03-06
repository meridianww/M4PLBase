SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/25/2018      
-- Description:               Get regular expression and message for table
-- Execution:                 EXEC [dbo].[GetValidationRegExpsByTblName]
-- Modified on:  
-- Modified Desc:  
-- =============================================  
CREATE PROCEDURE [dbo].[GetValidationRegExpsByTblName]  
  @langCode NVARCHAR(10),  
  @tableName NVARCHAR(100)  
AS                  
BEGIN TRY                  
 SET NOCOUNT ON;  
 SELECT val.[ValTableName],val.[ValFieldName]  
      ,val.[ValRegExLogic0]  
      ,val.[ValRegEx1]  
      ,val.[ValRegExMessage1]  
      ,val.[ValRegExLogic1]  
      ,val.[ValRegEx2]  
      ,val.[ValRegExMessage2]  
      ,val.[ValRegExLogic2]  
      ,val.[ValRegEx3]  
      ,val.[ValRegExMessage3]  
      ,val.[ValRegExLogic3]  
      ,val.[ValRegEx4]  
      ,val.[ValRegExMessage4]  
      ,val.[ValRegExLogic4]  
      ,val.[ValRegEx5]  
      ,val.[ValRegExMessage5]  
  FROM [dbo].[SYSTM000Validation]  (NOLOCK) val WHERE val.[LangCode] =@langCode AND val.[ValTableName] = @tableName AND ISNULL(val.[StatusId],1) =1  
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
   
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
