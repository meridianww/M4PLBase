SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan   
-- Create date:               08/16/2018      
-- Description:               Upd a Org Ref Role  
-- Execution:                 EXEC [dbo].[UpdMenuDriver]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- ============================================= 
CREATE PROCEDURE  [dbo].[UpdMenuDriver]      
	@userId BIGINT  
	,@roleId BIGINT  
	,@entity NVARCHAR(100)  
	,@langCode NVARCHAR(10)  
	,@id BIGINT   
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
	,@statusId int = NULL  
	,@dateChanged DATETIME2(7) = NULL  
	,@changedBy NVARCHAR(50) = NULL  
	,@isFormView BIT = 0  
	,@moduleName NVARCHAR(50) = null  
AS  
BEGIN TRY                  
 SET NOCOUNT ON;     
 IF(ISNULL(@mnuModuleId,0) = 0 AND  LEN(@moduleName) > 0 AND NOT EXISTS(SELECT Id FROM  [SYSTM000Ref_Options] WHERE SysLookupId= 22 AND SysOptionName=@moduleName))
   BEGIN         
		DECLARE @order INT
		SELECT @order = MAX(SysSortOrder) FROM [SYSTM000Ref_Options] WHERE SysLookupId= 22;
			INSERT INTO [dbo].[SYSTM000Ref_Options]([SysLookupId],[SysLookupCode],[SysOptionName],[SysSortOrder],[SysDefault],[IsSysAdmin],[StatusId],[DateEntered],[EnteredBy])
				 VALUES(22,'MainModule',@moduleName,ISNULL(@order,0) +1,0,0,1,@dateChanged,@changedBy)
           SET @mnuModuleId = SCOPE_IDENTITY();
   END


  UPDATE [dbo].[SYSTM000MenuDriver]  
       SET   [LangCode]      =  CASE WHEN (@isFormView = 1) THEN @langCode WHEN ((@isFormView = 0) AND (@langCode='#M4PL#')) THEN LangCode ELSE ISNULL(@langCode, LangCode)  END  
   ,[MnuBreakDownStructure]  =  CASE WHEN (@isFormView = 1) THEN @mnuBreakDownStructure WHEN ((@isFormView = 0) AND (@mnuBreakDownStructure='#M4PL#')) THEN NULL ELSE ISNULL(@mnuBreakDownStructure, MnuBreakDownStructure) END  
   ,[MnuModuleId]     =  CASE WHEN (@isFormView = 1) THEN @mnuModuleId WHEN ((@isFormView = 0) AND (@mnuModuleId=-100)) THEN NULL ELSE ISNULL(@mnuModuleId, MnuModuleId) END  
   ,[MnuTableName]     =  CASE WHEN (@isFormView = 1) THEN @mnuTableName WHEN ((@isFormView = 0) AND (@mnuTableName='#M4PL#')) THEN NULL ELSE ISNULL(@mnuTableName, MnuTableName) END  
   ,[MnuTitle]               =  CASE WHEN (@isFormView = 1) THEN @mnuTitle WHEN ((@isFormView = 0) AND (@mnuTitle='#M4PL#')) THEN NULL ELSE ISNULL(@mnuTitle, MnuTitle) END  
   ,[MnuTabOver]             =  CASE WHEN (@isFormView = 1) THEN @mnuTabOver WHEN ((@isFormView = 0) AND (@mnuTabOver='#M4PL#')) THEN NULL ELSE ISNULL(@mnuTabOver, MnuTabOver) END  
   ,[MnuRibbon]              =  ISNULL(@mnuRibbon, MnuRibbon)  
   ,[MnuMenuItem]            =  ISNULL(@mnuMenuItem, MnuMenuItem)  
   ,[MnuExecuteProgram]      =  CASE WHEN (@isFormView = 1) THEN @mnuExecuteProgram WHEN ((@isFormView = 0) AND (@mnuExecuteProgram='#M4PL#')) THEN NULL ELSE ISNULL(@mnuExecuteProgram, MnuExecuteProgram) END  
   ,[MnuClassificationId]    =  CASE WHEN (@isFormView = 1) THEN @mnuClassificationId WHEN ((@isFormView = 0) AND (@mnuClassificationId=-100)) THEN NULL ELSE ISNULL(@mnuClassificationId, MnuClassificationId) END  
   ,[MnuProgramTypeId]       =  CASE WHEN (@isFormView = 1) THEN @mnuProgramTypeId WHEN ((@isFormView = 0) AND (@mnuProgramTypeId=-100)) THEN NULL ELSE ISNULL(@mnuProgramTypeId, MnuProgramTypeId) END  
   ,[MnuOptionLevelId]       =  CASE WHEN (@isFormView = 1) THEN @mnuOptionLevelId WHEN ((@isFormView = 0) AND (@mnuOptionLevelId=-100)) THEN NULL ELSE ISNULL(@mnuOptionLevelId, MnuOptionLevelId) END  
   ,[MnuAccessLevelId]       =  CASE WHEN (@isFormView = 1) THEN @mnuAccessLevelId WHEN ((@isFormView = 0) AND (@mnuAccessLevelId=-100)) THEN NULL ELSE ISNULL(@mnuAccessLevelId, MnuAccessLevelId) END  
   ,[StatusId]         =  CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END  
   ,[DateChanged]            =  @dateChanged  
   ,[ChangedBy]              =  @changedBy      
     WHERE   [Id] = @id     
 SELECT mnu.[Id]  
  ,mnu.[LangCode]   
  ,mnu.[MnuModuleId]  
  ,mnu.[MnuTableName]  
  ,mnu.[MnuBreakDownStructure]  
  ,mnu.[MnuTitle]  
  ,mnu.[MnuTabOver]  
  ,mnu.[MnuMenuItem]  
  ,mnu.[MnuRibbon]  
  ,mnu.[MnuRibbonTabName]  
  ,mnu.[MnuIconVerySmall]  
  ,mnu.[MnuIconSmall]  
  ,mnu.[MnuIconMedium]  
  ,mnu.[MnuIconLarge]  
  ,mnu.[MnuExecuteProgram]  
  ,mnu.[MnuClassificationId]  
  ,mnu.[MnuProgramTypeId]  
  ,mnu.[MnuOptionLevelId]  
  ,mnu.[MnuAccessLevelId]  
  ,mnu.[MnuHelpFile]  
  ,mnu.[MnuHelpBookMark]  
  ,mnu.[MnuHelpPageNumber]    ,mnu.[StatusId]  
  ,mnu.[DateEntered]  
  ,mnu.[DateChanged]  
  ,mnu.[EnteredBy]  
  ,mnu.[ChangedBy]  
 FROM [dbo].[SYSTM000MenuDriver] (NOLOCK) mnu  
 WHERE mnu.[LangCode] = @langCode   
 AND mnu.Id=@id  
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
