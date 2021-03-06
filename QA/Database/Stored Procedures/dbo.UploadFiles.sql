SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana Behara         
-- Create date:               11/08/2018      
-- Description:               UploadFiles
-- Execution:                 EXEC [dbo].[UploadFiles]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- ============================================= 
CREATE PROCEDURE  [dbo].[UploadFiles]      
      @userId BIGINT  
     ,@roleId BIGINT  
 	 ,@entity NVARCHAR(100)  
     ,@langCode NVARCHAR(10)  
     ,@recordId BIGINT  
     ,@refTableName NVARCHAR(50) = NULL  
     ,@fieldName NVARCHAR(100) = NULL  
     ,@fieldValue IMAGE = NULL  
      
AS  
BEGIN TRY                  
 SET NOCOUNT ON;
 DECLARE @tableName NVARCHAR(100)  
 SELECT @tableName = TblTableName FROM SYSTM000Ref_Table WHERE SysRefName = @refTableName;  
 DECLARE @sqlQuery NVARCHAR(MAX)  

 SET @sqlQuery='UPDATE  '+@tableName+'   SET  '+ @fieldName + '= @fieldValue  WHERE Id = @recordId';    
 EXEC sp_executesql @sqlQuery, N'@fieldValue IMAGE, @id BIGINT' , 
     @fieldValue= @fieldValue,  
     @recordId = @recordId;  
   SELECT  @@ROWCOUNT;
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
