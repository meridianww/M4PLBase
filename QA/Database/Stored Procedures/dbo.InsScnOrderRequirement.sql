SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a ScnOrderRequirement 
-- Execution:                 EXEC [dbo].[InsScnOrderRequirement]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================

CREATE PROCEDURE  [dbo].[InsScnOrderRequirement]
	(@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@requirementID BIGINT = NULL
	,@requirementCode NVARCHAR(20) = NULL
	,@jobID BIGINT = NULL
	,@notes NVARCHAR(MAX) = NULL
	,@complete NVARCHAR(1) = NULL
	,@enteredBy NVARCHAR(50) = NULL
	,@dateEntered DATETIME2(7) = NULL)
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 
 DECLARE @currentId BIGINT;

 INSERT INTO [dbo].[SCN015OrderRequirement]
           ([RequirementID]
			,[RequirementCode]
			,[JobID]
			,[Notes]
			,[Complete])
     VALUES
           (@requirementID
           ,@requirementCode 
           ,@jobID
           ,@notes  
           ,@complete) 
		   --SET @currentId = SCOPE_IDENTITY();
	EXEC [dbo].[GetScnOrderRequirement] @userId, @roleId, 0 ,@requirementID 
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
