SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/25/2018      
-- Description:               Get unique message if exist
-- Execution:                 EXEC [dbo].[GetIsFieldUnique]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================       
ALTER PROCEDURE [dbo].[GetIsFieldUnique]      
@userId BIGINT,      
@roleId BIGINT,      
@orgId BIGINT,      
@langCode NVARCHAR(10),      
@tableName NVARCHAR(100),      
@recordId BIGINT,      
@fieldName NVARCHAR(50),      
@fieldValue NVARCHAR(MAX),
@parentFilter NVARCHAR(MAX),
@parentId BIGINT = null
AS                      
BEGIN TRY                      
SET NOCOUNT ON;      

 DECLARE @exist BIT; 
        DECLARE @actualTableName NVARCHAR(100)
   SELECT @actualTableName = tbl.TblTableName FROM  [dbo].[SYSTM000Ref_Table] (NOLOCK) tbl where tbl.SysRefName= @tableName  

   DECLARE @primaryKeyName NVARCHAR(50), @statusQuery NVARCHAR(200);                                          
	SET  @primaryKeyName = CASE @tableName 
	WHEN 'ScrOsdList' THEN 'OSDID' 
	WHEN 'ScrOsdReasonList' THEN 'ReasonID' 
	WHEN 'ScrRequirementList' THEN 'RequirementID'
	WHEN 'ScrReturnReasonList' THEN 'ReturnReasonID'
	WHEN 'ScrServiceList' THEN 'ServiceID'
	ELSE 'Id' END;
   


   SET @statusQuery = CASE @tableName WHEN 'SystemAccount' THEN '' 
									  WHEN 'OrgActSubSecurityByRole' THEN ' AND ISNULL(StatusId, 1) < 3 AND OrgSecurityByRoleId='+CAST(@parentId AS VARCHAR(10))
									ELSE ' AND ISNULL(StatusId, 1) < 3' END;

   DECLARE @fieldCondition VARCHAR(100) 
   
   SET @fieldCondition =  @fieldName + ' = @fieldValue '

   IF(@tableName = 'Contact' AND @fieldName in('ConEmailAddress', 'ConEmailAddress2'))
		SET @fieldCondition = '(ConEmailAddress=@fieldValue OR ConEmailAddress2=@fieldValue) ';
    
   DECLARE @sqlCommand NVARCHAR(MAX)
 
	    
   SET @sqlCommand =  'IF NOT EXISTS (SELECT 1 FROM ' + @actualTableName +' WHERE '+@primaryKeyName+' <> @recordId ' + @statusQuery + ' AND '+ @fieldCondition + ISNULL(@parentFilter, '') +') BEGIN SET @exist = 1 END ELSE BEGIN SET @exist = 0 END'; 
   
   EXEC sp_executesql @sqlCommand, N'@recordId BIGINT, @fieldCondition VARCHAR(100), @fieldValue NVARCHAR(MAX), @exist BIT OUTPUT',       
				  @recordId= @recordId,     
				  @fieldValue=@fieldValue, 
				  @fieldCondition = @fieldCondition,  
				  @exist= @exist OUTPUT
--SELECT @sqlCommand    
Select @exist      
END TRY                      
BEGIN CATCH                      
DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                      
,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                      
,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                      
      
EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                      
END CATCH