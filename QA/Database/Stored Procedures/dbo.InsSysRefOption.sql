SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan             
-- Create date:               08/16/2018      
-- Description:               Ins a Sys Ref Option
-- Execution:                 EXEC [dbo].[InsSysRefOption]
-- Modified on:               Janardana
-- Modified Desc:			  Added lookupname and Inserting into refTable 
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)
-- =============================================    
CREATE PROCEDURE  [dbo].[InsSysRefOption]        
	@userId BIGINT    
	,@roleId BIGINT 
	,@entity NVARCHAR(100)    
	,@langCode NVARCHAR(10)    
	,@lookupId int 
	,@lookupName NVARCHAR(100)     
	,@sysOptionName nvarchar(100)    
	,@sysSortOrder int    
	,@sysDefault bit
	,@isSysAdmin bit        
	,@where NVARCHAR(500) = NULL
	,@statusId int = null  
	,@dateEntered datetime2(7)    
	,@enteredBy nvarchar(50)  
AS    
BEGIN TRY                    
 SET NOCOUNT ON;    
   
  DECLARE @updatedItemNumber INT        
  EXEC [dbo].[ResetItemNumber] @userId, 0, NULL, @entity, @sysSortOrder, @statusId, NULL, @where,  @updatedItemNumber OUTPUT   
      
 DECLARE @currentId INT;    
       
   --INSERT INTO REF TABLE If @lookupName NOt EXISTS   
     
           
 IF NOT EXISTS( SELECT Id FROM SYSTM000Ref_Lookup WHERE LkupCode=@lookupName)    
 BEGIN    
        INSERT INTO [dbo].[SYSTM000Ref_Lookup](LkupCode,LkupTableName) VALUES(@lookupId,'Global');   
		SET @lookupId = SCOPE_IDENTITY(); 
 END    
    
       
    
   INSERT INTO [dbo].[SYSTM000Ref_Options]    
           ([SysLookupId]  
		   ,[SysLookupCode]  
   ,[SysOptionName]    
   ,[SysSortOrder]    
   ,[SysDefault]   
   ,[IsSysAdmin]
   ,[StatusId]   
   ,[DateEntered]    
   ,[EnteredBy] )      
      VALUES    
     (@lookupId  
	 , @lookupName
      ,@sysOptionName    
      ,@updatedItemNumber    
      ,@sysDefault   
	  ,@isSysAdmin 
   ,@statusId  
      ,@dateEntered    
      ,@enteredBy)     
   SET @currentId = SCOPE_IDENTITY();    
    
 --  --UPDATE Column Alias    
    
 --  IF @entity IS NOT NULL AND @entityColumn IS NOT NULL    
 --  BEGIN    
 --   UPDATE SYSTM000ColumnsAlias     
 --SET ColLookupId = @lookupId  
 --WHERE  ColTableName  = @entity      
 --         AND ColColumnName  = @entityColumn;      
 --   END    
    
 SELECT * FROM [dbo].[SYSTM000Ref_Options] WHERE Id = @currentId;    
END TRY        
BEGIN CATCH                    
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                    
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                    
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                    
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                    
END CATCH    
    
    
    
/***** Object:  StoredProcedure [dbo].[UpdSysRefOption]    Script Date: 8/16/2017 1:30:20 PM *****/    
SET ANSI_NULLS ON
GO
