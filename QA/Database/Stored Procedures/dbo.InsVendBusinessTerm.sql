SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a Vend Business Term
-- Execution:                 EXEC [dbo].[InsVendBusinessTerm]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- ============================================= 
CREATE PROCEDURE  [dbo].[InsVendBusinessTerm]
	@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@langCode NVARCHAR(10)
	,@vbtOrgId BIGINT = NULL
	,@vbtVendorId BIGINT = NULL 
	,@vbtItemNumber INT  = NULL
	,@vbtCode NVARCHAR(20)  = NULL
	,@vbtTitle NVARCHAR(50)  = NULL
	,@businessTermTypeId INT  = NULL
	,@vbtActiveDate DATETIME2(7)  = NULL
	,@vbtValue DECIMAL(18,2)  = NULL
	,@vbtHiThreshold DECIMAL(18,2)  = NULL
	,@vbtLoThreshold DECIMAL(18,2)  = NULL
	,@vbtAttachment INT  = NULL
	,@statusId INT  = NULL
	,@enteredBy NVARCHAR(50)  = NULL
	,@dateEntered DATETIME2(7)    = NULL
AS
BEGIN TRY                
 SET NOCOUNT ON; 
  DECLARE @updatedItemNumber INT      
  EXEC [dbo].[ResetItemNumber] @userId, 0, @vbtVendorId, @entity, @vbtItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT
   
 DECLARE @currentId BIGINT;
   INSERT INTO [dbo].[VEND020BusinessTerms]
           ([LangCode]
           ,[VbtOrgID]
           ,[VbtVendorID]
           ,[VbtItemNumber]
           ,[VbtCode]
           ,[VbtTitle]
           ,[BusinessTermTypeId]
           ,[VbtActiveDate]
           ,[VbtValue]
           ,[VbtHiThreshold]
           ,[VbtLoThreshold]
           ,[VbtAttachment]
           ,[StatusId]
           ,[EnteredBy]
           ,[DateEntered] )  
      VALUES
		   (@langCode 
           ,@vbtOrgID   
           ,@vbtVendorID  
           ,@updatedItemNumber  
           ,@vbtCode  
           ,@vbtTitle  
           ,@businessTermTypeId  
           ,@vbtActiveDate  
           ,@vbtValue  
           ,@vbtHiThreshold  
           ,@vbtLoThreshold  
           ,@vbtAttachment  
           ,@statusId  
           ,@enteredBy  
           ,@dateEntered ) 
		   SET @currentId = SCOPE_IDENTITY();
		EXEC [dbo].[GetVendBusinessTerm] @userId, @roleId, @vbtOrgId, @langCode, @currentId 
END TRY    
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
