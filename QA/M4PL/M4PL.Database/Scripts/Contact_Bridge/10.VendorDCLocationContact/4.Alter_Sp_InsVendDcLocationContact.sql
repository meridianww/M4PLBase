USE [M4PL_Test]
GO
/****** Object:  StoredProcedure [dbo].[InsVendDcLocationContact]    Script Date: 5/9/2019 5:04:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/25/2018     
-- Description:               Ins a vend dc location Contact
-- Execution:                 EXEC [dbo].[InsVendDcLocationContact]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId   and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- Modified on:				  04/26/2019(Nikhil)   
-- Modified Desc:			  Removed comments and Updated old vendorDClocationcontact table references with new contact bridge table
-- =============================================  
ALTER PROCEDURE  [dbo].[InsVendDcLocationContact]		  
	 @userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@conVendDcLocationId BIGINT  = NULL
	,@conItemNumber INT = NULL
	,@conContactMSTRID BIGINT = NULL
	,@statusId INT  = NULL
	,@conTitleId INT = NULL
	,@conLastName NVARCHAR(25) = NULL
	,@conFirstName NVARCHAR(25) = NULL
	,@conMiddleName NVARCHAR(25) = NULL
	,@conJobTitle NVARCHAR(50) = NULL
	,@conOrgId BIGINT = NULL
	,@conTypeId INT = NULL
	,@conTableTypeId INT = NULL
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
	,@enteredBy NVARCHAR(50)  = NULL
	,@dateEntered DATETIME2(7) 	 = NULL	  
AS
BEGIN TRY                
 SET NOCOUNT ON;   
   DECLARE @updatedItemNumber INT      
  EXEC [dbo].[ResetItemNumber] @userId, 0, @conVendDcLocationId	, @entity, @conItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT
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
		,@conTableTypeId
		,@statusId
		,@conTypeId
		,@dateEntered
		,@enteredBy)
	
	SET @currentId = SCOPE_IDENTITY();

IF(ISNULL(@currentId,0) <>0)
BEGIN

 --  -- Then Insert into [CONTC010Bridge]
   INSERT INTO [dbo].[CONTC010Bridge]
          (  [ContactMSTRID]
			,[ConOrgId]
			,[ConTableName]
			,[ConPrimaryRecordId]
			,[ConItemNumber]
			,[ConCodeId]
			,[ConTitle]
			,[ConTypeId]
			,[StatusId]
			,[ConTableTypeId]       
			,[EnteredBy]
			,[DateEntered]
			)
     VALUES
				(@currentId
				,@conOrgId
				,@entity
				,@conVendDcLocationId
				,@updatedItemNumber 
				,NULL
				,@conJobTitle
				,@conTypeId
				,@statusId  
				,@conTableTypeId 
				,@enteredBy 
				,@dateEntered)
 END 	
	SET @currentId = SCOPE_IDENTITY();
	EXEC [dbo].[GetVendDcLocationContact] @userId, @roleId, @conOrgId ,@currentId 
	
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
