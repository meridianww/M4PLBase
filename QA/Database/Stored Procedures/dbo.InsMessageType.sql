SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/22/2018      
-- Description:               Ins a message type 
-- Execution:                 EXEC [dbo].[InsMessageType]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================

CREATE PROCEDURE  [dbo].[InsMessageType]
	(@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@langCode NVARCHAR(10)
	,@sysRefId int
	,@sysMsgtypeTitle nvarchar(50)
	,@statusId int = null
	,@dateEntered datetime2(7)
	,@enteredBy nvarchar(50))
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 DECLARE @currentId BIGINT;
 INSERT INTO [dbo].[SYSMS010Ref_MessageTypes]
           ([LangCode]
			,[SysRefId]
			,[SysMsgtypeTitle]
			,[StatusId]
			,[DateEntered]
			,[EnteredBy])
     VALUES
           (@langCode
		   	,@sysRefId
		   	,@sysMsgtypeTitle
			,@statusId
		   	,@dateEntered
		   	,@enteredBy) 
			SET @currentId = SCOPE_IDENTITY();
	SELECT * FROM [dbo].[SYSMS010Ref_MessageTypes] WHERE Id = @currentId;
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
