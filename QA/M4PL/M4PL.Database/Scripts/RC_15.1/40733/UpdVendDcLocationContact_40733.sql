/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/25/2018      
-- Description:               Upd a vend DCLocation Contact
-- Execution:                 EXEC [dbo].[UpdVendDcLocationContact]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[UpdVendDcLocationContact]		  
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id BIGINT
	,@vlcVendDcLocationId BIGINT = NULL
	,@vlcItemNumber INT = NULL
	,@vlcContactCode NVARCHAR(50)  = NULL
	,@vlcContactTitle NVARCHAR(50)  = NULL
	,@vlcContactMSTRID BIGINT   = NULL
	,@vlcAssignment NVARCHAR(50)  = NULL
	,@vlcGateway NVARCHAR(50)  = NULL
	,@statusId INT = NULL
	,@conTitleId INT = NULL
	,@conLastName NVARCHAR(25) = NULL
	,@conFirstName NVARCHAR(25) = NULL
	,@conMiddleName NVARCHAR(25) = NULL
	,@conJobTitle NVARCHAR(50) = NULL
	,@conCompany NVARCHAR(100) = NULL
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
	,@changedBy NVARCHAR(50)  = NULL
	,@dateChanged DATETIME2(7)  = NULL		  
	,@isFormView BIT = 0
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  DECLARE @updatedItemNumber INT      
 EXEC [dbo].[ResetItemNumber] @userId, @id, @vlcVendDcLocationId, @entity, @vlcItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT
  --First Update Contact
  IF((ISNULL(@vlcContactMSTRID, 0) <> 0) AND (@isFormView = 1))
  BEGIN
	UPDATE  [dbo].[CONTC000Master]
	  SET  --ConCompany					= CASE WHEN (@isFormView = 1) THEN @conCompany WHEN ((@isFormView = 0) AND (@conCompany='#M4PL#')) THEN NULL ELSE ISNULL(@conCompany,ConCompany) END
			 ConTitleId					= ISNULL(@conTitleId,ConTitleId)
			,ConLastName				= CASE WHEN (@isFormView = 1) THEN @conLastName WHEN ((@isFormView = 0) AND (@conLastName='#M4PL#')) THEN NULL ELSE ISNULL(@conLastName,ConLastName) END
			,ConFirstName				= CASE WHEN (@isFormView = 1) THEN @conFirstName WHEN ((@isFormView = 0) AND (@conFirstName='#M4PL#')) THEN NULL ELSE ISNULL(@conFirstName,ConFirstName) END
			,ConMiddleName				= CASE WHEN (@isFormView = 1) THEN @conMiddleName WHEN ((@isFormView = 0) AND (@conMiddleName='#M4PL#')) THEN NULL ELSE ISNULL(@conMiddleName,ConMiddleName) END
			,ConEmailAddress			= CASE WHEN (@isFormView = 1) THEN @conEmailAddress WHEN ((@isFormView = 0) AND (@conEmailAddress='#M4PL#')) THEN NULL ELSE ISNULL(@conEmailAddress,ConEmailAddress) END
			,ConEmailAddress2			= CASE WHEN (@isFormView = 1) THEN @conEmailAddress2 WHEN ((@isFormView = 0) AND (@conEmailAddress2='#M4PL#')) THEN NULL ELSE ISNULL(@conEmailAddress2,ConEmailAddress2) END
			,ConJobTitle				= CASE WHEN (@isFormView = 1) THEN @conJobTitle WHEN ((@isFormView = 0) AND (@conJobTitle='#M4PL#')) THEN NULL ELSE ISNULL(@conJobTitle,ConJobTitle) END
			,ConBusinessPhone			= CASE WHEN (@isFormView = 1) THEN @conBusinessPhone WHEN ((@isFormView = 0) AND (@conBusinessPhone='#M4PL#')) THEN NULL ELSE ISNULL(@conBusinessPhone,ConBusinessPhone) END
			,ConBusinessPhoneExt		= CASE WHEN (@isFormView = 1) THEN @conBusinessPhoneExt WHEN ((@isFormView = 0) AND (@conBusinessPhoneExt='#M4PL#')) THEN NULL ELSE ISNULL(@conBusinessPhoneExt,ConBusinessPhoneExt) END
			,ConMobilePhone				= CASE WHEN (@isFormView = 1) THEN @conMobilePhone WHEN ((@isFormView = 0) AND (@conMobilePhone='#M4PL#')) THEN NULL ELSE ISNULL(@conMobilePhone,ConMobilePhone) END
			,ConBusinessAddress1		= CASE WHEN (@isFormView = 1) THEN @conBusinessAddress1 WHEN ((@isFormView = 0) AND (@conBusinessAddress1='#M4PL#')) THEN NULL ELSE ISNULL(@conBusinessAddress1,ConBusinessAddress1) END
			,ConBusinessAddress2		= CASE WHEN (@isFormView = 1) THEN @conBusinessAddress2 WHEN ((@isFormView = 0) AND (@conBusinessAddress2='#M4PL#')) THEN NULL ELSE ISNULL(@conBusinessAddress2,ConBusinessAddress2) END
			,ConBusinessCity			= CASE WHEN (@isFormView = 1) THEN @conBusinessCity WHEN ((@isFormView = 0) AND (@conBusinessCity='#M4PL#')) THEN NULL ELSE ISNULL(@conBusinessCity,ConBusinessCity) END
			,ConBusinessStateId			= ISNULL(@conBusinessStateId,ConBusinessStateId)
			,ConBusinessZipPostal		= CASE WHEN (@isFormView = 1) THEN @conBusinessZipPostal WHEN ((@isFormView = 0) AND (@conBusinessZipPostal='#M4PL#')) THEN NULL ELSE ISNULL(@conBusinessZipPostal,ConBusinessZipPostal) END
			,ConBusinessCountryId		= ISNULL(@conBusinessCountryId,ConBusinessCountryId)
			,ConUDF01					= ISNULL(@conUDF01,ConUDF01)
			,StatusId					= ISNULL(@statusId ,StatusId)
			,ConTypeId					= ISNULL(@conTypeId,ConTypeId)
			,DateChanged				= @dateChanged 
			,ChangedBy					= @changedBy  
	WHERE  Id = @vlcContactMSTRID
  END

  --Then Update Vend Dc Location
    UPDATE  [dbo].[VEND041DCLocationContacts]
       SET  [VlcVendDcLocationId]		= CASE WHEN (@isFormView = 1) THEN @vlcVendDcLocationId WHEN ((@isFormView = 0) AND (@vlcVendDcLocationId=-100)) THEN NULL ELSE ISNULL(@vlcVendDcLocationId, VlcVendDcLocationId) END
			,[VlcItemNumber]			= @updatedItemNumber
			,[VlcContactCode]			= CASE WHEN (@isFormView = 1) THEN @vlcContactCode WHEN ((@isFormView = 0) AND (@vlcContactCode='#M4PL#')) THEN NULL ELSE ISNULL(@vlcContactCode, VlcContactCode) END 
			,[VlcContactTitle]			= CASE WHEN (@isFormView = 1) THEN @vlcContactTitle WHEN ((@isFormView = 0) AND (@vlcContactTitle='#M4PL#')) THEN NULL ELSE ISNULL(@vlcContactTitle, VlcContactTitle) END  
			,[VlcContactMSTRID]			= CASE WHEN (@isFormView = 1) THEN @vlcContactMSTRID WHEN ((@isFormView = 0) AND (@vlcContactMSTRID=-100)) THEN NULL ELSE ISNULL(@vlcContactMSTRID, VlcContactMSTRID) END
			,[VlcAssignment]			= CASE WHEN (@isFormView = 1) THEN @vlcAssignment WHEN ((@isFormView = 0) AND (@vlcAssignment='#M4PL#')) THEN NULL ELSE ISNULL(@vlcAssignment, VlcAssignment) END 
			,[VlcGateway]				= CASE WHEN (@isFormView = 1) THEN @vlcGateway WHEN ((@isFormView = 0) AND (@vlcGateway='#M4PL#')) THEN NULL ELSE ISNULL(@vlcGateway, VlcGateway) END 
			,[StatusId]					= CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
            ,[ChangedBy]				= @changedBy   
            ,[DateChanged]				= @dateChanged 
	  WHERE  [Id] = @id 
                  
	EXEC [dbo].[GetVendDcLocationContact] @userId, @roleId, 1 ,@id 
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH