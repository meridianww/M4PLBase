/****** Object:  StoredProcedure [dbo].[UpdSysRefOption]    Script Date: 03-21-2019 17:37:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan  
-- Create date:               09/22/2018      
-- Description:               Upd a sys ref option  
-- Execution:                 EXEC [dbo].[UpdSysRefOption]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================   
ALTER PROCEDURE  [dbo].[UpdSysRefOption]      
	@userId BIGINT  
	,@roleId BIGINT  
	,@entity NVARCHAR(100)  
	,@langCode NVARCHAR(10)  
	,@id int  
	,@lookupId INT = NULL  
	,@lookupName NVARCHAR(100) =NULL
	,@sysOptionName nvarchar(100) = NULL  
	,@sysSortOrder int = NULL  
	,@sysDefault bit = NULL  
	,@isSysAdmin bit = NULL
	,@statusId INT = NULL 
	,@where NVARCHAR(500) = NULL
	,@dateChanged datetime2(7) = NULL  
	,@changedBy nvarchar(50) = NULL  	   
	,@isFormView BIT = 0
AS  
BEGIN TRY                  
 SET NOCOUNT ON;     
   DECLARE @updatedItemNumber INT        
  EXEC [dbo].[ResetItemNumber] @userId, @id, NULL, @entity, @sysSortOrder, @statusId, NULL, @where,  @updatedItemNumber OUTPUT  
    --INSERT INTO REF TABLE If @lookupName NOt EXISTS  
 IF NOT EXISTS( SELECT Id FROM SYSTM000Ref_Lookup WHERE LkupCode=@lookupName)    
 BEGIN    
        INSERT INTO [dbo].[SYSTM000Ref_Lookup](LkupCode,LkupTableName) VALUES(@lookupId,'Global');   
		SET @lookupId = SCOPE_IDENTITY(); 
 END
 ELSE IF(ISNULL(@lookupId, 0) = 0)
 BEGIN
	SELECT @lookupId= Id FROM SYSTM000Ref_Lookup WHERE LkupCode=@lookupName;
 END    


   UPDATE [dbo].[SYSTM000Ref_Options]  
    SET      [SysLookupId]  = CASE WHEN (@isFormView = 1) THEN @lookupId WHEN ((@isFormView = 0) AND (@lookupId=-100)) THEN NULL ELSE ISNULL(@lookupId, [SysLookupId]) END 
   ,[SysLookupCode]			= CASE WHEN (@isFormView = 1) THEN @lookupName WHEN ((@isFormView = 0) AND (@lookupName='#M4PL#')) THEN NULL ELSE ISNULL(@lookupName, [SysLookupCode])  END 
   ,[SysOptionName]			= CASE WHEN (@isFormView = 1) THEN @sysOptionName WHEN ((@isFormView = 0) AND (@sysOptionName='#M4PL#')) THEN NULL ELSE ISNULL(@sysOptionName, SysOptionName)   END
   ,[SysSortOrder]			= CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, SysSortOrder)   END
   ,[SysDefault]			= ISNULL(@sysDefault, SysDefault)
   ,[StatusId]				= CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId)   END
   ,[IsSysAdmin]			= ISNULL(@isSysAdmin, IsSysAdmin)
   ,[DateChanged]			= @dateChanged  
   ,[ChangedBy]				= @changedBy    
      WHERE Id   = @id     
      
   EXEC  [dbo].[GetSysRefOption] @userId, @roleId, 1, @langCode, @id  
   
 END TRY       
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH