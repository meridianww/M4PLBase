SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana Behara     
-- Create date:               12/05/2018      
-- Description:               Upd a sys lookup table and columnalias  
-- Execution:                 EXEC [dbo].[UpdLookup]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================  
CREATE PROCEDURE  [dbo].[UpdLookup]
	@userId BIGINT    
	,@roleId BIGINT  
	,@langCode NVARCHAR(10)    
	,@entity NVARCHAR(100) = NULL -- table    
	,@entityColumn NVARCHAR(100) = NULL -- column field    
	,@lookupId INT = NULL -- lookupname    
	,@isGlobal BIT    
AS    
BEGIN TRY    
        
  BEGIN TRANSACTION      
    
 SET NOCOUNT ON;    
 DECLARE @success BIT  = 0      
 -- set lookup as global     
 IF @isGlobal = 1    
 BEGIN    
  IF NOT EXISTS (SELECT Id FROM [SYSTM000Ref_Lookup] WHERE Id = @lookupId)    
  BEGIN   
    INSERT INTO [SYSTM000Ref_Lookup] (Id,LkupTableName)VALUES (@lookupId,'Global')    
  END    
  ELSE    
  BEGIN    
      UPDATE [SYSTM000Ref_Lookup] SET LkupTableName = 'Global' WHERE  Id=@lookupId;    
  END    
        UPDATE [SYSTM000ColumnsAlias]    
      SET [ColLookupId] = @lookupId    
   WHERE [ColTableName] = @entity    
    AND [ColColumnName] = @entityColumn;    
      
  SET @success = 1    
 END    
 ELSE    
 BEGIN    
  UPDATE [SYSTM000ColumnsAlias]    
  SET [ColLookupId] = @lookupId    
  WHERE [ColTableName] = @entity    
   AND [ColColumnName] = @entityColumn;    
   SET @success = 1    
 END    
    
  COMMIT TRANSACTION      
    
 SELECT  @success     
END TRY    
    
BEGIN CATCH    
 DECLARE @ErrorMessage VARCHAR(MAX) = (    
   SELECT ERROR_MESSAGE()    
   )    
  ,@ErrorSeverity VARCHAR(MAX) = (    
   SELECT ERROR_SEVERITY()    
   )    
  ,@RelatedTo VARCHAR(100) = (    
   SELECT OBJECT_NAME(@@PROCID)    
   )    
    
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo    
  ,NULL    
  ,@ErrorMessage    
  ,NULL    
  ,NULL    
  ,@ErrorSeverity    
END CATCH
GO
