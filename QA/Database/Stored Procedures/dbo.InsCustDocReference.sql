SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a cust document reference
-- Execution:                 EXEC [dbo].[InsCustDocReference]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================  
CREATE PROCEDURE  [dbo].[InsCustDocReference]		  
	@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@cdrOrgId BIGINT = NULL
	,@cdrCustomerId BIGINT = NULL
	,@cdrItemNumber INT = NULL
	,@cdrCode NVARCHAR(20) = NULL
	,@cdrTitle NVARCHAR(50) = NULL
	,@docRefTypeId INT = NULL
	,@docCategoryTypeId INT = NULL
	,@cdrAttachment INT = NULL
	,@cdrDateStart DATETIME2(7) = NULL
	,@cdrDateEnd DATETIME2(7) = NULL
	,@cdrRenewal BIT = NULL
	,@statusId INT = NULL 
	,@enteredBy NVARCHAR(50) = NULL
	,@dateEntered DATETIME2(7) = NULL
AS
BEGIN TRY                
 SET NOCOUNT ON; 
  
  DECLARE @updatedItemNumber INT      
EXEC [dbo].[ResetItemNumber] @userId, 0, @cdrCustomerId, @entity, @cdrItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT
   
 DECLARE @currentId BIGINT;
   INSERT INTO [dbo].[CUST030DocumentReference]
           ([CdrOrgId]
           ,[CdrCustomerId]
           ,[CdrItemNumber]
           ,[CdrCode]
           ,[CdrTitle]
           ,[DocRefTypeId]
           ,[DocCategoryTypeId]
           ,[CdrAttachment]
           ,[CdrDateStart]
           ,[CdrDateEnd]
           ,[CdrRenewal]
           ,[StatusId]
           ,[EnteredBy]
           ,[DateEntered])
     VALUES
		   (@cdrOrgId  
           ,@cdrCustomerId  
           ,@updatedItemNumber 
           ,@cdrCode  
           ,@cdrTitle 
           ,@docRefTypeId  
           ,@docCategoryTypeId 
           ,@cdrAttachment  
           ,@cdrDateStart   
           ,@cdrDateEnd  
           ,@cdrRenewal  
		   ,@statusId
           ,@enteredBy   
           ,@dateEntered)	
		   SET @currentId = SCOPE_IDENTITY();
	EXEC [dbo].[GetCustDocReference] @userId, @roleId, @cdrOrgId ,@currentId  
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
