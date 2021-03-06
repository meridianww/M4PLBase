SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/12/2018      
-- Description:               Ins menu driver
-- Execution:                 EXEC [dbo].[InsMenuDriver]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================    
CREATE PROCEDURE  [dbo].[InsMenuDriver]      
	@userId BIGINT  
	,@roleId BIGINT 
	,@entity NVARCHAR(100)  
	,@langCode NVARCHAR(10)  
	,@mnuModuleId BIGINT = NULL  
	,@mnuBreakDownStructure NVARCHAR(20) = NULL  
	,@mnuTableName NVARCHAR(100) = NULL  
	,@mnuTitle NVARCHAR(50) = NULL  
	,@mnuTabOver NVARCHAR(25) = NULL  
	,@mnuRibbon BIT = NULL  
	,@mnuMenuItem BIT = NULL  
	,@mnuExecuteProgram NVARCHAR(255) = NULL  
	,@mnuClassificationId BIGINT = NULL  
	,@mnuProgramTypeId BIGINT = NULL  
	,@mnuOptionLevelId BIGINT = NULL  
	,@mnuAccessLevelId BIGINT = NULL  
	,@statusId int = null  
	,@dateEntered DATETIME2(7) = NULL  
	,@enteredBy NVARCHAR(50) = NULL  
	,@moduleName NVARCHAR(50) = null  
AS  
BEGIN TRY                  
 SET NOCOUNT ON;     
 DECLARE @currentId BIGINT;  

   IF(ISNULL(@mnuModuleId,0) = 0 AND  LEN(@moduleName) > 0 AND NOT EXISTS(SELECT Id FROM  [SYSTM000Ref_Options] WHERE SysLookupId= 22 AND SysOptionName=@moduleName))
   BEGIN         
		DECLARE @order INT
		SELECT @order = MAX(SysSortOrder) FROM [SYSTM000Ref_Options] WHERE SysLookupId= 22;
			INSERT INTO [dbo].[SYSTM000Ref_Options]([SysLookupId],[SysLookupCode],[SysOptionName],[SysSortOrder],[SysDefault],[IsSysAdmin],[StatusId],[DateEntered],[EnteredBy])
				 VALUES(22,'MainModule',@moduleName,ISNULL(@order,0) +1,0,0,1,@dateEntered,@enteredBy)
           SET @mnuModuleId = SCOPE_IDENTITY();
   END


   INSERT INTO [dbo].[SYSTM000MenuDriver]  
           ([LangCode]  
   ,[MnuModuleId]  
   ,[MnuBreakDownStructure]  
   ,[MnuTableName]  
   ,[MnuTitle]  
   ,[MnuTabOver]  
   ,[MnuRibbon]  
   ,[MnuMenuItem]  
   ,[MnuExecuteProgram]  
   ,[MnuClassificationId]  
   ,[MnuProgramTypeId]  
   ,[MnuOptionLevelId]  
   ,[MnuAccessLevelId]  
   ,[StatusId]  
   ,[DateEntered]  
   ,[EnteredBy])  
     VALUES  
      (@langCode  
     ,@mnuModuleId  
     ,@mnuBreakDownStructure  
     ,@mnuTableName  
     ,@mnuTitle  
     ,@mnuTabOver  
     ,@mnuRibbon  
     ,@mnuMenuItem  
     ,@mnuExecuteProgram  
     ,@mnuClassificationId  
     ,@mnuProgramTypeId  
     ,@mnuOptionLevelId  
     ,@mnuAccessLevelId  
     ,@statusId  
     ,@dateEntered  
     ,@enteredBy)    
     SET @currentId = SCOPE_IDENTITY();  
 SELECT * FROM [dbo].[SYSTM000MenuDriver] WHERE Id = @currentId;   
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
