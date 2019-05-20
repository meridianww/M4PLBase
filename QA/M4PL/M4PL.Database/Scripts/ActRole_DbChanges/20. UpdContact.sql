/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan
-- Create date:               10/10/2018      
-- Description:               Update a contact 
-- Execution:                 EXEC [dbo].[UpdContact]
-- Modified on:               05/03/2019( Kirty - Introduced @conUDF01 and remove #M4PL# check for NULL for values.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[UpdContact]
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id BIGINT
	,@conERPId  NVARCHAR(50) = NULL
	,@conOrgId  BIGINT
	,@conCompanyName NVARCHAR(100)
	,@conTitleId  INT = NULL
	,@conLastName  NVARCHAR(25) = NULL
	,@conFirstName  NVARCHAR(25) = NULL
	,@conMiddleName  NVARCHAR(25) = NULL
	,@conEmailAddress  NVARCHAR(100) = NULL
	,@conEmailAddress2  NVARCHAR(100) = NULL
	,@conJobTitle  NVARCHAR(50) = NULL
	,@conBusinessPhone  NVARCHAR(25) = NULL
	,@conBusinessPhoneExt  NVARCHAR(15) = NULL
	,@conHomePhone  NVARCHAR(25) = NULL
	,@conMobilePhone  NVARCHAR(25) = NULL
	,@conFaxNumber  NVARCHAR(25) = NULL
	,@conBusinessAddress1  NVARCHAR(255) = NULL
	,@conBusinessAddress2  VARCHAR(150) = NULL
	,@conBusinessCity  NVARCHAR(25) = NULL
	,@conBusinessStateId  INT = NULL
	,@conBusinessZipPostal  NVARCHAR(20) = NULL
	,@conBusinessCountryId  INT = NULL
	,@conHomeAddress1  NVARCHAR(150) = NULL
	,@conHomeAddress2  NVARCHAR(150) = NULL
	,@conHomeCity  NVARCHAR(25) = NULL
	,@conHomeStateId  INT = NULL
	,@conHomeZipPostal  NVARCHAR(20) = NULL
	,@conHomeCountryId  INT = NULL
	,@conAttachments  INT  = NULL
	,@conWebPage  NTEXT  = NULL
	,@conNotes  NTEXT  = NULL
	,@statusId  INT  = NULL
	,@conTypeId  INT  = NULL
	,@conOutlookId  NVARCHAR(50) = NULL
	,@dateChanged  DATETIME2(7) = NULL
	,@changedBy  NVARCHAR(50) = NULL
	,@isFormView BIT = 0
	,@conUDF01 INT = NULL
AS
BEGIN TRY                
 SET NOCOUNT ON;  
 UPDATE  [dbo].[CONTC000Master]
    SET  ConERPId					= @conERPId
		--,ConCompany					= CASE WHEN (@isFormView = 1) THEN @conCompany WHEN ((@isFormView = 0) AND (@conCompany='#M4PL#')) THEN NULL ELSE ISNULL(@conCompany,ConCompany) END
		,ConTitleId					= ISNULL(@conTitleId,ConTitleId)
		,ConOrgId					= ISNULL(@conOrgId,ConOrgId)
		,ConCompanyName				= ISNULL(@conCompanyName,ConCompanyName)
		,ConLastName				= @conLastName
		,ConFirstName				= @conFirstName
		,ConMiddleName				= @conMiddleName
		,ConEmailAddress			= @conEmailAddress
		,ConEmailAddress2			= @conEmailAddress2
		,ConJobTitle				= @conJobTitle
		,ConBusinessPhone			= @conBusinessPhone
		,ConBusinessPhoneExt		= @conBusinessPhoneExt
		,ConHomePhone				= @conHomePhone
		,ConMobilePhone				= @conMobilePhone
		,ConFaxNumber				= @conFaxNumber
		,ConBusinessAddress1		= @conBusinessAddress1
		,ConBusinessAddress2		= @conBusinessAddress2
		,ConBusinessCity			= @conBusinessCity
		,ConBusinessStateId			= ISNULL(@conBusinessStateId,ConBusinessStateId)
		,ConBusinessZipPostal		= @conBusinessZipPostal
		,ConBusinessCountryId		= ISNULL(@conBusinessCountryId,ConBusinessCountryId)
		,ConHomeAddress1			= @conHomeAddress1
		,ConHomeAddress2			= @conHomeAddress2
		,ConHomeCity				= @conHomeCity
		,ConHomeStateId				= ISNULL(@conHomeStateId,ConHomeStateId)
		,ConHomeZipPostal			= @conHomeZipPostal
		,ConHomeCountryId			= ISNULL(@conHomeCountryId,ConHomeCountryId)
		--,ConAttachments				= CASE WHEN (@isFormView = 1) THEN @conAttachments WHEN ((@isFormView = 0) AND (@conAttachments=-100)) THEN NULL ELSE ISNULL(@conAttachments ,ConAttachments) END
		,ConWebPage					= @conWebPage
		,ConNotes					= @conNotes
		,StatusId					= ISNULL(@statusId ,StatusId)
		,ConTypeId					= ISNULL(@conTypeId,ConTypeId)
		,ConOutlookId				= @conOutlookId
		,DateChanged				= @dateChanged 
		,ChangedBy					= @changedBy
		,ConUDF01					= @conUDF01  
  WHERE  Id = @id
	
   EXEC [dbo].[GetContact] @userId, @roleId, @conOrgId, @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO

