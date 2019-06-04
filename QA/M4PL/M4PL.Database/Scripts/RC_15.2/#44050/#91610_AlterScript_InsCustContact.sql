/****** Object:  StoredProcedure [dbo].[InsCustContact]    Script Date: 6/4/2019 11:44:18 AM ******/
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
-- Execution:                 EXEC [dbo].[InsCustContact]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- Modified on:				  26th Apr 2019 (Parthiban M)
-- Modified Desc:			  Changes done for related to contact bridge implementation
-- Modified on:				  04th Jun 2019 (Kirty)
-- Modified Desc:			  Changes done for getting exact value for [ConTableTypeId], [ConTypeId] from [SYSTM000Ref_Options] table
-- =============================================
ALTER PROCEDURE  [dbo].[InsCustContact]		  
	@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@orgId BIGINT
	,@custCustomerId  BIGINT = NULL
	,@custItemNumber INT = NULL 
	,@custContactCodeId BIGINT = NULL 
	,@custContactTitle NVARCHAR(50) = NULL 
	,@custContactMSTRId BIGINT = NULL 
	,@statusId INT = NULL 
	,@enteredBy NVARCHAR(50) = NULL 
	,@dateEntered DATETIME2(7) = NULL
AS
BEGIN TRY                
 SET NOCOUNT ON;  
  DECLARE @updatedItemNumber INT      
  EXEC [dbo].[ResetItemNumber] @userId, 0, @custCustomerId, @entity, @custItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT  
  
  DECLARE @conTableTypeId INT  
  SELECT @conTableTypeId = Id FROM [dbo].[SYSTM000Ref_Options] WHERE SysLookupCode = 'ContactType' AND SysOptionName = 'Consultant' AND StatusId = 1

  DECLARE @conTypeId INT
  SELECT @conTypeId = Id FROM [dbo].[SYSTM000Ref_Options] WHERE SysLookupCode = 'ContactType' AND SysOptionName = 'Customer' AND StatusId = 1
  
 DECLARE @currentId BIGINT;
   INSERT INTO [dbo].[CONTC010Bridge]
           ([ConOrgId]
		   ,[ContactMSTRID]
           ,[ConTableName]
           ,[ConPrimaryRecordId]
           ,[ConTableTypeId]
           ,[ConTypeId]
           ,[ConItemNumber]
           ,[ConCodeId]
           ,[ConTitle]
		   ,[StatusId]
           ,[EnteredBy]
           ,[DateEntered])
     VALUES
           (@orgId
		   ,@custContactMSTRId
		   ,@entity
		   ,@custCustomerId
		   ,@conTableTypeId
		   ,@conTypeId
		   ,@updatedItemNumber
		   ,@custContactCodeId
		   ,@custContactTitle
		   ,@statusId
		   ,@enteredBy
		   ,@dateEntered 
		   )	
		 SET @currentId = SCOPE_IDENTITY();
		
		IF EXISTS(SELECT TOP 1 1 FROM [dbo].[fnGetUserStatuses](@userId) WHERE StatusId = @statusId)
		BEGIN
			EXEC [dbo].[UpdateColumnCount] @tableName = 'CUST000Master', @columnName = 'CustContacts',  @rowId = @custCustomerID, @countToChange = 1
		END

		EXEC [dbo].[GetCustContact] @userId, @roleId, @orgId ,@currentId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH