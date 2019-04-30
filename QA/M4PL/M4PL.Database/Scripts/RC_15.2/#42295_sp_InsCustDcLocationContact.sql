USE [M4PL_DEV]
GO
/****** Object:  StoredProcedure [dbo].[InsCustDcLocationContact]    Script Date: 4/25/2019 7:18:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/25/2018      
-- Description:               Ins a cust dc locations Contact
-- Execution:                 EXEC [dbo].[InsCustDcLocationContact]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- Modified on:				  26th Apr 2019 (Parthiban M)
-- Modified Desc:			  Changes done for related to contact bridge implementation
-- =============================================  
ALTER PROCEDURE  [dbo].[InsCustDcLocationContact]		  
	@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@clcCustDcLocationId BIGINT = NULL
	,@clcItemNumber INT = NULL
	,@clcContactCode NVARCHAR(20) = NULL
	,@clcContactTitle  NVARCHAR(50) = NULL
	,@clcContactMSTRID BIGINT = NULL
	,@clcAssignment NVARCHAR(20) = NULL
	,@clcGateway NVARCHAR(20) = NULL
	,@statusId INT  = NULL
	,@conTitleId INT = NULL
	,@conLastName NVARCHAR(25) = NULL
	,@conFirstName NVARCHAR(25) = NULL
	,@conMiddleName NVARCHAR(25) = NULL
	,@conJobTitle NVARCHAR(50) = NULL
	,@conOrgId BIGINT = NULL
	,@conTypeId INT = NULL
	,@conUDF01 INT = NULL
	,@conBusinessPhone NVARCHAR(25) = NULL
	,@conBusinessPhoneExt NVARCHAR(15) = NULL
	,@conMobilePhone NVARCHAR(25) = NULL
	,@conEmailAddress NVARCHAR(100) = NULL
	,@conEmailAddress2 NVARCHAR(100) = NULL
	,@conBusinessAddress1 NVARCHAR(255) = NULL
	,@conBusinessAddress2 NVARCHAR(150) = NULL
	,@conBusinessCity NVARCHAR(25) = NULL
	,@conBusinessStateId INT = NULL
	,@conBusinessZipPostal NVARCHAR(20) = NULL
	,@conBusinessCountryId INT = NULL
	,@enteredBy NVARCHAR(50) = NULL 
	,@dateEntered DATETIME2(7) = NULL  
AS
BEGIN TRY                
 SET NOCOUNT ON;   
   DECLARE @updatedItemNumber INT      
  EXEC [dbo].[ResetItemNumber] @userId, 0, @clcCustDcLocationId, @entity, @clcItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT  
 DECLARE @currentId BIGINT;
 
 -- First insert into ContactMaster table
 INSERT INTO [dbo].[CONTC000Master]
        ([ConOrgId]
        ,[ConTitleId]
        ,[ConLastName]
        ,[ConFirstName]
        ,[ConMiddleName]
        ,[ConEmailAddress]
        ,[ConEmailAddress2]
        ,[ConJobTitle]
        ,[ConBusinessPhone]
        ,[ConBusinessPhoneExt]
        ,[ConMobilePhone]
        ,[ConBusinessAddress1]
        ,[ConBusinessAddress2]
        ,[ConBusinessCity]
        ,[ConBusinessStateId]
        ,[ConBusinessZipPostal]
        ,[ConBusinessCountryId]
		,[ConUDF01]
        ,[StatusId]
        ,[ConTypeId]
        ,[DateEntered]
        ,[EnteredBy] )
     VALUES
		(@conOrgId
		,@conTitleId
		,@conLastName
		,@conFirstName
		,@conMiddleName
		,@conEmailAddress
		,@conEmailAddress2
		,@conJobTitle
		,@conBusinessPhone
		,@conBusinessPhoneExt
		,@conMobilePhone
		,@conBusinessAddress1
		,@conBusinessAddress2
		,@conBusinessCity
		,@conBusinessStateId
		,@conBusinessZipPostal
		,@conBusinessCountryId
		,@conUDF01
		,@statusId
		,@conTypeId
		,@dateEntered
		,@enteredBy)
	
	SET @currentId = SCOPE_IDENTITY();
	
	INSERT INTO [dbo].[CONTC010Bridge]
           ([ConOrgId]
		   ,[ContactMSTRID]
           ,[ConTableName]
           ,[ConPrimaryRecordId]
           ,[ConTableTypeId]
           ,[ConTypeId]
           ,[ConItemNumber]
           ,[ConCode]
           ,[ConTitle]
		   ,[StatusId]
		   ,[ConAssignment]
		   ,[ConGateway]
           ,[EnteredBy]
           ,[DateEntered])
     VALUES
           (@conOrgId
		   ,@currentId
		   ,@entity
		   ,@clcCustDcLocationId
		   ,@conUDF01	
		   ,@conTypeId
		   ,@updatedItemNumber
		   ,@clcContactCode
		   ,@clcContactTitle
		   ,@statusId
		   ,@clcAssignment
		   ,@clcGateway
		   ,@enteredBy
		   ,@dateEntered 
		   )
	
	SET @currentId = SCOPE_IDENTITY();

	EXEC [dbo].[GetCustDcLocationContact] @userId, @roleId, @conOrgId ,@currentId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
