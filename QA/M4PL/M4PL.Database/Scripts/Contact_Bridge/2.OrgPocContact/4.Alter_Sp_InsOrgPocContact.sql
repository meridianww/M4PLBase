USE [M4PL_Test]
GO
/****** Object:  StoredProcedure [dbo].[InsOrgPocContact]    Script Date: 5/9/2019 5:10:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a org POC contact
-- Execution:                 EXEC [dbo].[InsOrgPocContact]
-- Modified on:               4/10/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- Modified on:				  04/26/2019(Nikhil)   
-- Modified Desc:             Removed Comments and replaced old contact Poc table with new bridge table 
-- ============================================= 
ALTER PROCEDURE  [dbo].[InsOrgPocContact]		  
	@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@orgId BIGINT = NULL
	,@contactId BIGINT = NULL
	,@pocCodeId BIGINT = NULL
	,@pocTitle NVARCHAR(50) = NULL
	,@pocTypeId INT = NULL
	,@pocDefault BIT = NULL
	,@statusId INT = NULL
	,@dateEntered DATETIME2(7) = NULL
	,@enteredBy NVARCHAR(50) = NULL
	,@pocSortOrder INT = NULL
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  DECLARE @updatedItemNumber INT      
EXEC [dbo].[ResetItemNumber] @userId, 0, @orgId, @entity, @pocSortOrder, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT


 DECLARE @id BIGINT;
  INSERT INTO [dbo].[CONTC010Bridge]
			([ContactMSTRID]
			,[ConOrgId]
			,[ConTableName]
			,[ConPrimaryRecordId]
			,[ConItemNumber]
			,[ConCodeId]
			,[ConTitle]
			,[ConTypeId]
			,[StatusId]
			,[ConIsDefault]
			,[ConTableTypeId]       
			,[EnteredBy]
			,[DateEntered]
         )
     VALUES
           (@contactId
		    ,@orgId
           ,@entity
           ,@orgId
           ,@updatedItemNumber
           ,@pocCodeId
		   ,@pocTitle 
		   ,62
		   ,@statusId
		   ,@pocDefault 
           ,@pocTypeId
		   ,@enteredBy 
           ,@dateEntered
			)
		   SET @id = SCOPE_IDENTITY();
		     EXEC [dbo].[GetOrgPocContact] @userId, @roleId, @orgId, @id
	
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
