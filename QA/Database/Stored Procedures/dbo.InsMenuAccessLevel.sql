SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a Sys menu access level
-- Execution:                 EXEC [dbo].[InsMenuAccessLevel]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- ============================================= 
CREATE PROCEDURE  [dbo].[InsMenuAccessLevel]		  
	@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@langCode NVARCHAR(10) = NULL
	,@sysRefId INT = NULL
	,@malOrder INT  = NULL
	,@malTitle NVARCHAR(50) = NULL 
	,@dateEntered DATETIME2(7)  = NULL
	,@enteredBy NVARCHAR(50)  = NULL
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 DECLARE @currentId BIGINT;
   INSERT INTO [dbo].[SYSTM010MenuAccessLevel]
           ([LangCode]
           ,[SysRefId]
           ,[MalOrder]
           ,[MalTitle]
           ,[DateEntered]
           ,[EnteredBy] )  
      VALUES
		   (@langCode  
           ,@sysRefId  
           ,@malOrder  
           ,@malTitle  
           ,@dateEntered  
           ,@enteredBy  ) 
		   SET @currentId = SCOPE_IDENTITY();
	SELECT * FROM [dbo].[SYSTM010MenuAccessLevel] WHERE Id = @currentId;   
END TRY    
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH



/***** Object:  StoredProcedure [dbo].[UpdSysMenuAccessLevel]    Script Date: 8/16/2017 1:30:20 PM *****/
SET ANSI_NULLS ON
GO
