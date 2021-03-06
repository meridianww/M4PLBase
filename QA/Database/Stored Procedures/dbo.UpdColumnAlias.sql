SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */  
-- =============================================          
-- Author:                    Akhil Chauhan  
-- Create date:               10/10/2018        
-- Description:               Upd a Sys column alias  
-- Execution:                 EXEC [dbo].[UpdColumnAlias]  
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)    
-- Modified Desc:    
-- =============================================  
CREATE PROCEDURE  [dbo].[UpdColumnAlias]      
 @userId BIGINT  
,@roleId BIGINT  
,@entity NVARCHAR(100)  
,@langCode NVARCHAR(10)  
,@id BIGINT   
,@colTableName NVARCHAR(100)   
,@colColumnName NVARCHAR(50)    
,@colAliasName NVARCHAR(50) = NULL  
,@lookupId INT = NULL  
,@colCaption NVARCHAR(50) = NULL  
,@colDescription NVARCHAR(255) =  NULL  
,@colSortOrder INT = NULL  
,@colIsReadOnly BIT = NULL  
,@colIsVisible BIT   
,@colIsDefault BIT    
,@where NVARCHAR(500) = NULL
,@statusId INT = NULL  
,@isFormView BIT = 0  
,@isGridColumn BIT=0
,@colGridAliasName NVARCHAR(50) = NULL
AS  
BEGIN TRY                  
 SET NOCOUNT ON;     
  
  DECLARE @updatedItemNumber INT        
  EXEC [dbo].[ResetItemNumber] @userId, 0, NULL, @entity, @colSortOrder, @statusId, NULL, @where,  @updatedItemNumber OUTPUT  
      
  
    UPDATE  [dbo].[SYSTM000ColumnsAlias]  
    SET     --LangCode   = @langCode  
	    LangCode  = CASE WHEN (@isFormView = 1) THEN @langCode WHEN ((@isFormView = 0) AND (@langCode='#M4PL#')) THEN NULL ELSE ISNULL(@langCode, LangCode) END     
           ,ColTableName  = @colTableName    
           ,ColColumnName  = @colColumnName    
           ,ColAliasName  = CASE WHEN (@isFormView = 1) THEN @colAliasName WHEN ((@isFormView = 0) AND (@colAliasName='#M4PL#')) THEN NULL ELSE ISNULL(@colAliasName, ColAliasName) END   
     ,ColLookupId  = CASE WHEN (@isFormView = 1) THEN @lookupId WHEN ((@isFormView = 0) AND (@lookupId=-100)) THEN NULL ELSE ISNULL(@lookupId, ColLookupId) END   
           ,ColCaption   = CASE WHEN (@isFormView = 1) THEN @colCaption WHEN ((@isFormView = 0) AND (@colCaption='#M4PL#')) THEN NULL ELSE ISNULL(@colCaption, ColCaption) END   
           ,ColDescription  = CASE WHEN (@isFormView = 1) THEN @colDescription WHEN ((@isFormView = 0) AND (@colDescription='#M4PL#')) THEN NULL ELSE ISNULL(@colDescription, ColDescription) END  
           ,ColSortOrder  = CASE WHEN (@isFormView = 1) THEN @colSortOrder WHEN ((@isFormView = 0) AND (@colSortOrder=-100)) THEN NULL ELSE ISNULL(@colSortOrder, ColSortOrder) END    
     --,ColSortOrder = CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber  , ColSortOrder) END  
           ,ColIsReadOnly  = ISNULL(@colIsReadOnly,  ColIsReadOnly)  
     ,StatusId  = CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId,  StatusId) END  
           ,ColIsVisible  = @colIsVisible     
           ,ColIsDefault    = @colIsDefault   
		   ,IsGridColumn =@isGridColumn
		   ,ColGridAliasName = ISNULL(@colGridAliasName,ColGridAliasName)
    WHERE Id = @id  
  
   IF(@lookupId > 0)  
  BEGIN  
   UPDATE cal  
      SET cal.[ColLookupCode] = lk.LkupCode  
   FROM  [SYSTM000ColumnsAlias] cal  
   INNER JOIN [dbo].[SYSTM000Ref_Lookup] lk  ON lk.Id= cal.[ColLookupCode] AND cal.Id = @id  
 END  
  
 EXEC [dbo].[GetColumnAlias] @userId, @roleId, 1, @langCode, @id   
  
END TRY                   
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
