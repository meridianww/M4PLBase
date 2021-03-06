SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a cust dc locations
-- Execution:                 EXEC [dbo].[InsCustDcLocation]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================  
CREATE PROCEDURE  [dbo].[InsCustDcLocation]		  
	@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@cdcCustomerId BIGINT 
	,@conOrgId INT
	,@cdcItemNumber INT 
	,@cdcLocationCode NVARCHAR(20)
	,@cdcCustomerCode NVARCHAR(20)
	,@cdcLocationTitle NVARCHAR(50) 
	,@cdcContactMSTRId BIGINT 
	,@statusId INT 
	,@enteredBy NVARCHAR(50) 
	,@dateEntered DATETIME2(7) 		  
AS
BEGIN TRY                
 SET NOCOUNT ON;   
   DECLARE @updatedItemNumber INT      
  EXEC [dbo].[ResetItemNumber] @userId, 0, @cdcCustomerId, @entity, @cdcItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT  
   BEGIN TRANSACTION
 DECLARE @currentId BIGINT;
   INSERT INTO [dbo].[CUST040DCLocations]
           ([CdcCustomerId]
           ,[CdcItemNumber]
           ,[CdcLocationCode]
		   ,[CdcCustomerCode]
           ,[CdcLocationTitle]
           ,[StatusId]
           ,[EnteredBy]
           ,[DateEntered])
     VALUES
		   (@cdcCustomerId 
           ,@updatedItemNumber  
           ,@cdcLocationCode   
		   --,ISNULL(@cdcCustomerCode,@cdcLocationCode)
		   ,@cdcCustomerCode
           ,@cdcLocationTitle   
           ,@statusId 
           ,@enteredBy 
           ,@dateEntered) 	
		   SET @currentId = SCOPE_IDENTITY();

		   
   INSERT INTO [dbo].[CONTC010Bridge] (
		[ConOrgId]
		,[ContactMSTRID]
		,[ConTableName]
		,[ConPrimaryRecordId]
		,[ConTypeId] 
		,[ConItemNumber]
		,[ConTitle]
		,[StatusId]
		,[EnteredBy]
		,[DateEntered]
		)
	VALUES (
		@conOrgId
		,@cdcContactMSTRId  
		,@entity
		,@currentId
		,(select ConTypeId  from CONTC000Master where id = @cdcContactMSTRId)
		,@updatedItemNumber
		 ,(select ConJobTitle  from CONTC000Master where id = @cdcContactMSTRId)
		,@statusId
		,@enteredBy
		,@dateEntered
		)
			COMMIT
	EXEC [dbo].[GetCustDcLocation] @userId, @roleId, 1 ,@currentId
END TRY                
BEGIN CATCH 
 ROLLBACK              
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH

GO
