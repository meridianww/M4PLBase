SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana B 
-- Create date:               11/11/2018      
-- Description:               Upd a Attachment  
-- Execution:                 EXEC [dbo].[UpdAttachment]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)
-- Modified Desc:  
-- =============================================   
    
    
CREATE PROCEDURE [dbo].[UpdAttachment]    
     (@userId BIGINT    
     ,@roleId BIGINT  
 	 ,@entity NVARCHAR(100)    
     ,@id bigint    
     ,@attTableName NVARCHAR(100) = NULL    
     ,@attPrimaryRecordID BIGINT = NULL    
     ,@attItemNumber INT = NULL    
     ,@attTitle NVARCHAR(50) = NULL    
     ,@attTypeId INT = NULL    
     ,@attFileName NVARCHAR(50) = NULL    
     ,@attDownLoadedDate DATETIME2(7) = NULL    
     ,@attDownLoadedBy NVARCHAR(50) = NULL 
	 ,@where NVARCHAR(500) = NULL
	 ,@statusId INT = NULL    
     ,@changedBy NVARCHAR(50) = NULL    
     ,@dateChanged DATETIME2(7) = NULL
	,@isFormView BIT = 0)    
AS    
BEGIN TRY                    
 SET NOCOUNT ON;  
  DECLARE @updatedItemNumber INT      
  EXEC [dbo].[ResetItemNumber] @userId, @id, @attPrimaryRecordID, @entity, @attItemNumber, @statusId, NULL, @where, @updatedItemNumber OUTPUT  
      
 UPDATE  [dbo].[SYSTM020Ref_Attachments]  
      SET   [AttTableName]     = CASE WHEN (@isFormView = 1) THEN @attTableName WHEN ((@isFormView = 0) AND (@attTableName='#M4PL#')) THEN NULL ELSE ISNULL(@attTableName, AttTableName) END    
           ,[AttPrimaryRecordID]     = CASE WHEN (@isFormView = 1) THEN @attPrimaryRecordID WHEN ((@isFormView = 0) AND (@attPrimaryRecordID=-100)) THEN NULL ELSE ISNULL(@attPrimaryRecordID, AttPrimaryRecordID) END    
           ,[AttItemNumber]   = CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber  , AttItemNumber) END    
           ,[AttTitle]     = CASE WHEN (@isFormView = 1) THEN @attTitle WHEN ((@isFormView = 0) AND (@attTitle='#M4PL#')) THEN NULL ELSE ISNULL(@attTitle, AttTitle) END    
           ,[AttTypeId]   = CASE WHEN (@isFormView = 1) THEN @attTypeId WHEN ((@isFormView = 0) AND (@attTypeId=-100)) THEN NULL ELSE ISNULL(@attTypeId , AttTypeId) END    
           ,[AttFileName]   = CASE WHEN (@isFormView = 1) THEN @attFileName WHEN ((@isFormView = 0) AND (@attFileName='#M4PL#')) THEN NULL ELSE ISNULL(@attFileName, AttFileName) END    
           ,[AttDownloadedDate]    = ISNULL(@attDownLoadedDate, AttDownloadedDate)
           ,[AttDownloadedBy]     = CASE WHEN (@isFormView = 1) THEN @attDownLoadedBy WHEN ((@isFormView = 0) AND (@attDownLoadedBy='#M4PL#')) THEN NULL ELSE ISNULL(@attDownLoadedBy, AttDownloadedBy) END   
		   ,[StatusId] = CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId,StatusId) END
           ,[ChangedBy]     = @changedBy    
           ,[DateChanged]    = @dateChanged    
 WHERE [Id] = @id    
 SELECT * FROM [dbo].[SYSTM020Ref_Attachments] WHERE Id = @id    
END TRY                  
BEGIN CATCH                    
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                    
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                    
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                    
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                    
END CATCH
GO
