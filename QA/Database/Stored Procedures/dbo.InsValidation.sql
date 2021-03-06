SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a Sys Validation 
-- Execution:                 EXEC [dbo].[InsValidation]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE  [dbo].[InsValidation]		  
	@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@langCode NVARCHAR(10)
	,@valTableName NVARCHAR(100) 
	,@refTabPageId BIGINT 
	,@valFieldName NVARCHAR(50) = NULL
	,@valRequired BIT  = NULL
	,@valRequiredMessage NVARCHAR(255)  = NULL
	,@valUnique BIT  = NULL
	,@valUniqueMessage NVARCHAR(255)  = NULL
	,@valRegExLogic0 NVARCHAR(255) = NULL 
	,@valRegEx1 NVARCHAR(255) = NULL 
	,@valRegExMessage1 NVARCHAR(255)  = NULL
	,@valRegExLogic1 NVARCHAR(255)  = NULL
	,@valRegEx2 NVARCHAR(255)  = NULL
	,@valRegExMessage2 NVARCHAR(255) = NULL 
	,@valRegExLogic2 NVARCHAR(255) = NULL 
	,@valRegEx3 NVARCHAR(255) = NULL 
	,@valRegExMessage3 NVARCHAR(255)  = NULL
	,@valRegExLogic3 NVARCHAR(255) = NULL 
	,@valRegEx4 NVARCHAR(255)  = NULL
	,@valRegExMessage4 NVARCHAR(255) = NULL 
	,@valRegExLogic4 NVARCHAR(255) = NULL 
	,@valRegEx5 NVARCHAR(255)  = NULL
	,@valRegExMessage5 NVARCHAR(255)  = NULL
	,@statusId INT = NULL      
	,@dateEntered DATETIME2(7) = NULL 
	,@enteredBy NVARCHAR(50)  = NULL 
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 DECLARE @currentId BIGINT;
   INSERT INTO [dbo].[SYSTM000Validation]
           ([LangCode]
           ,[ValTableName]
           ,[RefTabPageId]
           ,[ValFieldName]
           ,[ValRequired]
           ,[ValRequiredMessage]
           ,[ValUnique]
           ,[ValUniqueMessage]
           ,[ValRegExLogic0]
           ,[ValRegEx1]
           ,[ValRegExMessage1]
           ,[ValRegExLogic1]
           ,[ValRegEx2]
           ,[ValRegExMessage2]
           ,[ValRegExLogic2]
           ,[ValRegEx3]
           ,[ValRegExMessage3]
           ,[ValRegExLogic3]
           ,[ValRegEx4]
           ,[ValRegExMessage4]
           ,[ValRegExLogic4]
           ,[ValRegEx5]
           ,[ValRegExMessage5]
		   ,[StatusId]
           ,[DateEntered]
           ,[EnteredBy] )
     VALUES
		   (@langCode 
           ,@valTableName  
           ,ISNULL(@refTabPageId,0)  
           ,@valFieldName  
           ,@valRequired  
           ,@valRequiredMessage  
           ,@valUnique 
           ,@valUniqueMessage 
           ,@valRegExLogic0  
           ,@valRegEx1 
           ,@valRegExMessage1 
           ,@valRegExLogic1  
           ,@valRegEx2  
           ,@valRegExMessage2  
           ,@valRegExLogic2  
           ,@valRegEx3  
           ,@valRegExMessage3   
           ,@valRegExLogic3   
           ,@valRegEx4  
           ,@valRegExMessage4  
           ,@valRegExLogic4  
           ,@valRegEx5 
           ,@valRegExMessage5  
		   ,@statusId
           ,@dateEntered  
           ,@enteredBy )  
		   SET @currentId = SCOPE_IDENTITY();
	SELECT * FROM [dbo].[SYSTM000Validation] WHERE Id = @currentId;
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH



/***** Object:  StoredProcedure [dbo].[UpdSysValidation]    Script Date: 8/16/2017 1:30:20 PM *****/
SET ANSI_NULLS ON
GO
