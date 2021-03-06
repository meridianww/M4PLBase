SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan        
-- Create date:               11/13/2018      
-- Description:               Get Entity Sub View
-- Execution:                 EXEC [dbo].[GetEntitySubViewById]
-- Modified on:  
-- Modified Desc:  
-- =============================================   
CREATE PROCEDURE [dbo].[GetEntitySubViewById]     
 @userId BIGINT,    
 @entity NVARCHAR(100),    
 @id BIGINT    
AS    
BEGIN TRY                    
 SET NOCOUNT ON;     
 DECLARE @sqlCommand NVARCHAR(MAX);    
    
IF(@entity = 'Contact')      
 BEGIN    
  SET @sqlCommand = 'SELECT '+@entity+'.Id, '+@entity+'.ConFullName, '+@entity+'.ConJobTitle  FROM [dbo].[CONTC000Master] (NOLOCK) '+ @entity    
 END    
ELSE IF(@entity = 'Organization')    
 BEGIN    
  SET @sqlCommand = 'SELECT '+@entity+'.Id, '+@entity+'.OrgCode, '+@entity+'.OrgTitle  FROM [dbo].[ORGAN000Master] (NOLOCK) '+ @entity    
 END    
ELSE IF(@entity = 'Customer')    
 BEGIN    
  SET @sqlCommand = 'SELECT '+@entity+'.Id, '+@entity+'.CustCode, '+@entity+'.CustTitle  FROM [dbo].[CUST000Master] (NOLOCK) '+ @entity    
 END    
ELSE IF(@entity = 'SecurityByRole')    
 BEGIN    
  SET @sqlCommand = 'SELECT '+@entity+'.Id, '+@entity+'.RoleCode, '+@entity+'.SecLineOrder  FROM [dbo].[SYSTM000SecurityByRole] (NOLOCK) '+ @entity    
 END    
ELSE IF(@entity = 'Program')    
 BEGIN    
  SET @sqlCommand = 'SELECT '+@entity+'.Id, '+@entity+'.PrgItemNumber, '+@entity+'.PrgProgramCode  FROM [dbo].[PRGRM000Master] (NOLOCK) '+ @entity    
 END    
ELSE IF(@entity = 'Job')    
 BEGIN    
  SET @sqlCommand = 'SELECT '+@entity+'.Id, '+@entity+'.JobSiteCode, '+@entity+'.JobConsigneeCode  FROM [dbo].[JOBDL000Master] (NOLOCK) '+ @entity    
 END    
ELSE IF(@entity = 'VendDcLocation')    
 BEGIN    
  SET @sqlCommand = 'SELECT '+@entity+'.Id, '+@entity+'.VdcItemNumber, '+@entity+'.VdcLocationCode  FROM [dbo].[VEND040DCLocations] (NOLOCK) '+ @entity    
 END    
ELSE IF(@entity = 'Vendor')    
 BEGIN    
  SET @sqlCommand = 'SELECT '+@entity+'.Id, '+@entity+'.VendItemNumber, '+@entity+'.VendCode  FROM [dbo].[VEND000Master] (NOLOCK) '+ @entity    
 END    
    
ELSE IF(@entity = 'TableReference')    
 BEGIN    
  SET @sqlCommand = 'SELECT TOP 1 ['+@entity+'].SysRefName As RefName  FROM [dbo].[SYSTM000Ref_Table] (NOLOCK) ['+ @entity +']'   
 END    
--Filtering Condition    
IF(@entity != 'TableReference')    
     
 BEGIN    
SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.Id=@id'    
END    
    
EXEC sp_executesql @sqlCommand, N'@id BIGINT' ,    
     @id= @id    
END TRY                    
BEGIN CATCH                    
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                    
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                    
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                    
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                    
END CATCH
GO
