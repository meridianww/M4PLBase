SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/25/2018      
-- Description:               Upd a vend DCLocation Contact
-- Execution:                 EXEC [dbo].[UpdVendDcLocationContact]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:
-- Modified on:				  04/26/2019(Nikhil)   
-- Modified Desc:			  Removed comments and Updated old VendorDCLocattion  table references with new contact bridge table   
-- =============================================
ALTER PROCEDURE  [dbo].[UpdVendDcLocationContact]		  
	 @userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@conOrgId BIGINT
	,@id BIGINT
	,@conVendDcLocationId BIGINT = NULL
	,@conItemNumber INT = NULL
	,@conContactMSTRID BIGINT   = NULL
	,@statusId INT = NULL
	,@conTitleId INT = NULL
	,@conLastName NVARCHAR(25) = NULL
	,@conFirstName NVARCHAR(25) = NULL
	,@conMiddleName NVARCHAR(25) = NULL
	,@conJobTitle NVARCHAR(50) = NULL
	,@conCompany NVARCHAR(100) = NULL
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
	,@changedBy NVARCHAR(50)  = NULL
	,@dateChanged DATETIME2(7)  = NULL		  
	,@isFormView BIT = 0
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  DECLARE @updatedItemNumber INT      
 EXEC [dbo].[ResetItemNumber] @userId, @id, @conVendDcLocationId, @entity, @conItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT
  --First Update Contact
  IF((ISNULL(@conContactMSTRID, 0) <> 0) AND (@isFormView = 1))
  BEGIN
	UPDATE  [dbo].[CONTC000Master]
	  SET  
			 ConTitleId					= ISNULL(@conTitleId,ConTitleId)
			,ConLastName				= CASE WHEN (@isFormView = 1) THEN @conLastName WHEN ((@isFormView = 0) AND (@conLastName='#M4PL#')) THEN NULL ELSE ISNULL(@conLastName,ConLastName) END
			,ConFirstName				= CASE WHEN (@isFormView = 1) THEN @conFirstName WHEN ((@isFormView = 0) AND (@conFirstName='#M4PL#')) THEN NULL ELSE ISNULL(@conFirstName,ConFirstName) END
			,ConMiddleName				= CASE WHEN (@isFormView = 1) THEN @conMiddleName WHEN ((@isFormView = 0) AND (@conMiddleName='#M4PL#')) THEN NULL ELSE ISNULL(@conMiddleName,ConMiddleName) END
			,ConEmailAddress			= CASE WHEN (@isFormView = 1) THEN @conEmailAddress WHEN ((@isFormView = 0) AND (@conEmailAddress='#M4PL#')) THEN NULL ELSE ISNULL(@conEmailAddress,ConEmailAddress) END
			,ConEmailAddress2			= CASE WHEN (@isFormView = 1) THEN @conEmailAddress2 WHEN ((@isFormView = 0) AND (@conEmailAddress2='#M4PL#')) THEN NULL ELSE ISNULL(@conEmailAddress2,ConEmailAddress2) END
			,ConBusinessPhone			= CASE WHEN (@isFormView = 1) THEN @conBusinessPhone WHEN ((@isFormView = 0) AND (@conBusinessPhone='#M4PL#')) THEN NULL ELSE ISNULL(@conBusinessPhone,ConBusinessPhone) END
			,ConBusinessPhoneExt		= CASE WHEN (@isFormView = 1) THEN @conBusinessPhoneExt WHEN ((@isFormView = 0) AND (@conBusinessPhoneExt='#M4PL#')) THEN NULL ELSE ISNULL(@conBusinessPhoneExt,ConBusinessPhoneExt) END
			,ConMobilePhone				= CASE WHEN (@isFormView = 1) THEN @conMobilePhone WHEN ((@isFormView = 0) AND (@conMobilePhone='#M4PL#')) THEN NULL ELSE ISNULL(@conMobilePhone,ConMobilePhone) END
			,ConBusinessAddress1		= CASE WHEN (@isFormView = 1) THEN @conBusinessAddress1 WHEN ((@isFormView = 0) AND (@conBusinessAddress1='#M4PL#')) THEN NULL ELSE ISNULL(@conBusinessAddress1,ConBusinessAddress1) END
			,ConBusinessAddress2		= CASE WHEN (@isFormView = 1) THEN @conBusinessAddress2 WHEN ((@isFormView = 0) AND (@conBusinessAddress2='#M4PL#')) THEN NULL ELSE ISNULL(@conBusinessAddress2,ConBusinessAddress2) END
			,ConBusinessCity			= CASE WHEN (@isFormView = 1) THEN @conBusinessCity WHEN ((@isFormView = 0) AND (@conBusinessCity='#M4PL#')) THEN NULL ELSE ISNULL(@conBusinessCity,ConBusinessCity) END
			,ConBusinessStateId			= ISNULL(@conBusinessStateId,ConBusinessStateId)
			,ConBusinessZipPostal		= CASE WHEN (@isFormView = 1) THEN @conBusinessZipPostal WHEN ((@isFormView = 0) AND (@conBusinessZipPostal='#M4PL#')) THEN NULL ELSE ISNULL(@conBusinessZipPostal,ConBusinessZipPostal) END
			,ConBusinessCountryId		= ISNULL(@conBusinessCountryId,ConBusinessCountryId)
			WHERE  Id = @conContactMSTRID
  END

  --Then Update Vend Dc Location
    UPDATE  [dbo].[CONTC010Bridge]
       SET  [ConPrimaryRecordId]		= CASE WHEN (@isFormView = 1) THEN @conVendDcLocationId WHEN ((@isFormView = 0) AND (@conVendDcLocationId=-100)) THEN NULL ELSE ISNULL(@conVendDcLocationId, ConPrimaryRecordId) END
			,[ConItemNumber]			= @updatedItemNumber
			,[ConTitle]			        = CASE WHEN (@isFormView = 1) THEN @conJobTitle WHEN ((@isFormView = 0) AND (@conJobTitle='#M4PL#')) THEN NULL ELSE ISNULL(@conJobTitle, ConTitle) END  
			,[ConTableTypeId]			= CASE WHEN (@isFormView = 1) THEN @conTableTypeId WHEN ((@isFormView = 0) AND (@conTableTypeId=-100)) THEN NULL ELSE ISNULL(@conTableTypeId, ConTableTypeId) END 
			,[StatusId]					= CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
            ,[ChangedBy]				= @changedBy   
            ,[DateChanged]				= @dateChanged 
	  WHERE  [Id] = @id 
                  
	EXEC [dbo].[GetVendDcLocationContact] @userId, @roleId, @conOrgId ,@id 
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
