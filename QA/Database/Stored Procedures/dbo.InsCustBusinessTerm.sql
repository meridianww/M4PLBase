SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a cust contact
-- Execution:                 EXEC [dbo].[InsCustBusinessTerm]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE  [dbo].[InsCustBusinessTerm]		  
	@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@langCode NVARCHAR(10)
	,@cbtOrgId BIGINT = NULL
	,@cbtCustomerId BIGINT  = NULL
	,@cbtItemNumber INT  = NULL
	,@cbtCode NVARCHAR(20)  = NULL
	,@cbtTitle NVARCHAR(50)  = NULL
	,@businessTermTypeId  INT  = NULL
	,@cbtActiveDate DATETIME2(7) = NULL 
	,@cbtValue DECIMAL(18,2)  = NULL
	,@cbtHiThreshold DECIMAL(18,2)  = NULL
	,@cbtLoThreshold DECIMAL(18,2)  = NULL
	,@cbtAttachment INT  = NULL
	,@statusId BIGINT = NULL 
	,@enteredBy NVARCHAR(50) = NULL 
	,@dateEntered DATETIME2(7)  = NULL
AS
BEGIN TRY                
 SET NOCOUNT ON; 
  DECLARE @updatedItemNumber INT      
 EXEC [dbo].[ResetItemNumber] @userId, 0, @cbtCustomerId, @entity, @cbtItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT  
   
 DECLARE @currentId BIGINT;
   INSERT INTO [dbo].[CUST020BusinessTerms]
           ([LangCode]
           ,[CbtOrgID]
           ,[CbtCustomerId]
           ,[CbtItemNumber]
           ,[CbtCode]
           ,[CbtTitle]
           ,[BusinessTermTypeId]
           ,[CbtActiveDate]
           ,[CbtValue]
           ,[CbtHiThreshold]
           ,[CbtLoThreshold]
           ,[CbtAttachment]
           ,[StatusId]
           ,[EnteredBy]
           ,[DateEntered]) 
     VALUES
		   (@langCode  
           ,@cbtOrgId  
           ,@cbtCustomerId  
           ,@updatedItemNumber 
           ,@cbtCode   
           ,@cbtTitle   
           ,@businessTermTypeId
           ,@cbtActiveDate   
           ,@cbtValue  
           ,@cbtHiThreshold 
           ,@cbtLoThreshold  
           ,@cbtAttachment  
           ,@statusId  
           ,@enteredBy 
           ,@dateEntered)  		
	SET @currentId = SCOPE_IDENTITY();
	 EXEC [dbo].[GetCustBusinessTerm] @userId, @roleId, @cbtOrgId, @langCode ,@currentId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
