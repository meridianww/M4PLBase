SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */  
-- =============================================          
-- Author:                    Janardana Behara          
-- Create date:               11/08/2018        
-- Description:               SaveBytes  
-- Execution:                 EXEC [dbo].[SaveBytes]  
-- Modified on:    
-- Modified Desc:    
-- =============================================        
CREATE PROCEDURE  [dbo].[SaveBytes]            
      @userId BIGINT        
     ,@roleCode NVARCHAR(25)        
     ,@langCode NVARCHAR(10)        
     ,@recordId BIGINT        
     ,@refTableName NVARCHAR(50) = NULL       
     ,@type NVARCHAR(50) = NULL       
     ,@fieldName NVARCHAR(100) = NULL        
     ,@fieldValue varbinary(max) = NULL        
     ,@documentText NVARCHAR(Max) = NULL 
	 ,@gatewayIds NVARCHAR(200) = NULL
AS        
BEGIN TRY                        
 SET NOCOUNT ON;      
 DECLARE @tableName NVARCHAR(100)        
 SELECT @tableName = TblTableName FROM SYSTM000Ref_Table WHERE SysRefName = @refTableName;        
 DECLARE @sqlQuery NVARCHAR(MAX) 
       
 IF(@refTableName = 'PrgMvocRefQuestion' AND @type = 'varbinary')
 BEGIN
 SET @sqlQuery='UPDATE '+ @tableName + ' SET QueDescriptionText ='+ ISNULL(''''+@documentText+'''','''''') + ', '+ @fieldName;   
 END
 ELSE
 BEGIN
 SET @sqlQuery='UPDATE '+ @tableName + ' SET '+ @fieldName ; 
 END

 DECLARE @primaryKeyName NVARCHAR(50);                                          
	SET  @primaryKeyName = CASE @refTableName 
	WHEN 'ScrOsdList' THEN 'OSDID' 
	WHEN 'ScrOsdReasonList' THEN 'ReasonID' 
	WHEN 'ScrRequirementList' THEN 'RequirementID'
	WHEN 'ScrReturnReasonList' THEN 'ReturnReasonID'
	WHEN 'ScrServiceList' THEN 'ServiceID'
	ELSE 'Id' END;

DECLARE @params NVARCHAR(MAX)  
IF(@gatewayIds IS NOT NULL)
BEGIN
    SET @params = N'@fieldValue '+ @type+ '(MAX), @recordId BIGINT';     
    SET @sqlQuery= @sqlQuery + ' = CONVERT(VARBINARY(max), @fieldValue) WHERE ID IN (' + @gatewayIds + ')'; 
	PRINT @sqlQuery
END
ELSE IF(@type ='image')  
 BEGIN  
  SET @sqlQuery= @sqlQuery + ' = CONVERT(IMAGE, @fieldValue) WHERE '+@primaryKeyName+' = @recordId';  
  SET  @params = N'@fieldValue '+ @type+ ', @recordId BIGINT';     
 END
 ELSE IF(@type = 'nvarchar')  
 BEGIN  
  SET @params = N'@fieldValue '+ @type+ '(MAX), @recordId BIGINT';   
  SET @sqlQuery= @sqlQuery + ' = CONVERT(NVARCHAR(max), @fieldValue) WHERE '+@primaryKeyName+' = @recordId';  
 END
ELSE  
 BEGIN  
  SET @params = N'@fieldValue '+ @type+ '(MAX), @recordId BIGINT';   
  SET @sqlQuery= @sqlQuery + ' = CONVERT(VARBINARY(max), @fieldValue) WHERE '+@primaryKeyName+' = @recordId';  
 END  

 EXEC sp_executesql @sqlQuery, @params ,       
     @fieldValue= @fieldValue,  
  @recordId= @recordId;  
           
   SELECT  @@ROWCOUNT;      
END TRY                        
BEGIN CATCH                        
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                        
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                        
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                        
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                        
END CATCH

GO
