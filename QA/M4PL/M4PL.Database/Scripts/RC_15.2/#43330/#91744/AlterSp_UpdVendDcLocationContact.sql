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
-- Modified on:				  6th Jun 2019 (Kirty)
-- Modified Desc:			  Removed unused parameters
-- Modified on:				  10th Jun 2019 (Parthiban) 
-- Modified Desc:			  Remove '#M4PL' while updating
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
	,@conTypeId INT = NULL
	,@conTableTypeId INT = NULL
	,@conBusinessPhone NVARCHAR(25) = NULL
	,@conBusinessPhoneExt NVARCHAR(15) = NULL
	,@conMobilePhone NVARCHAR(25) = NULL
	,@conEmailAddress NVARCHAR(100) = NULL
	,@conEmailAddress2 NVARCHAR(100) = NULL
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
			,ConLastName				= @conLastName
			,ConFirstName				= @conFirstName
			,ConMiddleName				= @conMiddleName
			,ConEmailAddress			= @conEmailAddress
			,ConEmailAddress2			= @conEmailAddress2
			,ConBusinessPhone			= @conBusinessPhone
			,ConBusinessPhoneExt		= @conBusinessPhoneExt
			,ConMobilePhone				= @conMobilePhone
			WHERE  Id = @conContactMSTRID
  END

  --Then Update Vend Dc Location
    UPDATE  [dbo].[CONTC010Bridge]
       SET  [ConPrimaryRecordId]		= ISNULL(@conVendDcLocationId, ConPrimaryRecordId)
			,[ConItemNumber]			= @updatedItemNumber
			,[ConTitle]			        = @conJobTitle
			,[ConTableTypeId]			= ISNULL(@conTableTypeId, ConTableTypeId) 
			,[StatusId]					= ISNULL(@statusId, StatusId)
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