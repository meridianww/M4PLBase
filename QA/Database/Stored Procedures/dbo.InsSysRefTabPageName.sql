SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/22/2018      
-- Description:               Ins a Sys ref tab page name
-- Execution:                 EXEC [dbo].[InsSysRefTabPageName]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE  [dbo].[InsSysRefTabPageName]
	@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@langCode NVARCHAR(10)
	,@refTableName nvarchar(100)
	,@tabSortOrder int
	,@tabTableName nvarchar(100)
	,@tabPageTitle nvarchar(50)
	,@tabExecuteProgram nvarchar(50)
	,@where NVARCHAR(500) = NULL
	,@statusId int = null
	,@dateEntered datetime2(7)
	,@enteredBy nvarchar(50)
AS
BEGIN TRY                
 SET NOCOUNT ON; 

 

  DECLARE @updatedItemNumber INT      
  EXEC [dbo].[ResetItemNumber] @userId, 0, NULL, @entity, @tabSortOrder, @statusId, NULL, @where,  @updatedItemNumber OUTPUT
   
 DECLARE @currentId BIGINT;
   INSERT INTO [dbo].[SYSTM030Ref_TabPageName]
           ( [RefTableName]
			,[LangCode]
			,[TabSortOrder]
			,[TabTableName]
			,[TabPageTitle]
			,[TabExecuteProgram]
			,[StatusId]
			,[DateEntered]
			,[EnteredBy] )  
      VALUES
		   (@refTableName
		   	,@langCode
		   	,@updatedItemNumber
		   	,@tabTableName
			,@tabPageTitle
		   	,@tabExecuteProgram
			,@statusId
		   	,@dateEntered
		   	,@enteredBy) 
			SET @currentId = SCOPE_IDENTITY();
	SELECT * FROM [dbo].[SYSTM030Ref_TabPageName] WHERE Id = @currentId;
END TRY    
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH



/***** Object:  StoredProcedure [dbo].[UpdSysRefTabPageName]    Script Date: 8/16/2017 1:30:20 PM *****/
SET ANSI_NULLS ON
GO
