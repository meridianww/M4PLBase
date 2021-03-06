SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */  
-- =============================================          
-- Author:                    Akhil           
-- Create date:               12/16/2018        
-- Description:               Get selected records by table  
-- Execution:                 EXEC [dbo].[GetByteArrayByIdAndEntity]     
-- Modified on:    
-- Modified Desc:    
-- =============================================                          
CREATE PROCEDURE [dbo].[GetByteArrayByIdAndEntity]  
 @recordId BIGINT,  
 @entity NVARCHAR(100),  
 @fields NVARCHAR(2000)  
AS                  
BEGIN TRY                  
SET NOCOUNT ON;    
 DECLARE @sqlCommand NVARCHAR(MAX);  
DECLARE @tableName NVARCHAR(100)  
SELECT @tableName = [TblTableName] FROM [dbo].[SYSTM000Ref_Table] Where SysRefName = @entity  

DECLARE @primaryKeyName NVARCHAR(50);                                          
	SET  @primaryKeyName = CASE @entity 
	WHEN 'ScrOsdList' THEN 'OSDID' 
	WHEN 'ScrOsdReasonList' THEN 'ReasonID' 
	WHEN 'ScrRequirementList' THEN 'RequirementID'
	WHEN 'ScrReturnReasonList' THEN 'ReturnReasonID'
	WHEN 'ScrServiceList' THEN 'ServiceID'
	ELSE 'Id' END;

SET @sqlCommand = 'SELECT '+ @fields +' FROM '+ @tableName + ' (NOLOCK) '+  @entity + ' WHERE '+ @entity +'.'+@primaryKeyName+' = @recordId'  

EXEC sp_executesql @sqlCommand, N'@recordId BIGINT',  
  @recordId = @recordId  
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
