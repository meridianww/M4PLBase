GO
PRINT N'Altering [dbo].[UpdContact]...';


GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan
-- Create date:               10/10/2018      
-- Description:               Update a contact 
-- Execution:                 EXEC [dbo].[UpdContact]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[UpdContact]
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id BIGINT
	,@conERPId  NVARCHAR(50) = NULL
	,@conOrgId  BIGINT
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
AS
BEGIN TRY                
 SET NOCOUNT ON;  
 UPDATE  [dbo].[CONTC000Master]
    SET  ConERPId					= CASE WHEN (@isFormView = 1) THEN @conERPId WHEN ((@isFormView = 0) AND (@conERPId='#M4PL#')) THEN NULL ELSE ISNULL(@conERPId,ConERPId) END
		--,ConCompany					= CASE WHEN (@isFormView = 1) THEN @conCompany WHEN ((@isFormView = 0) AND (@conCompany='#M4PL#')) THEN NULL ELSE ISNULL(@conCompany,ConCompany) END
		,ConTitleId					= ISNULL(@conTitleId,ConTitleId)
		,ConLastName				= CASE WHEN (@isFormView = 1) THEN @conLastName WHEN ((@isFormView = 0) AND (@conLastName='#M4PL#')) THEN NULL ELSE ISNULL(@conLastName,ConLastName) END
		,ConFirstName				= CASE WHEN (@isFormView = 1) THEN @conFirstName WHEN ((@isFormView = 0) AND (@conFirstName='#M4PL#')) THEN NULL ELSE ISNULL(@conFirstName,ConFirstName) END
		,ConMiddleName				= CASE WHEN (@isFormView = 1) THEN @conMiddleName WHEN ((@isFormView = 0) AND (@conMiddleName='#M4PL#')) THEN NULL ELSE ISNULL(@conMiddleName,ConMiddleName) END
		,ConEmailAddress			= CASE WHEN (@isFormView = 1) THEN @conEmailAddress WHEN ((@isFormView = 0) AND (@conEmailAddress='#M4PL#')) THEN NULL ELSE ISNULL(@conEmailAddress,ConEmailAddress) END
		,ConEmailAddress2			= CASE WHEN (@isFormView = 1) THEN @conEmailAddress2 WHEN ((@isFormView = 0) AND (@conEmailAddress2='#M4PL#')) THEN NULL ELSE ISNULL(@conEmailAddress2,ConEmailAddress2) END
		,ConJobTitle				= CASE WHEN (@isFormView = 1) THEN @conJobTitle WHEN ((@isFormView = 0) AND (@conJobTitle='#M4PL#')) THEN NULL ELSE ISNULL(@conJobTitle,ConJobTitle) END
		,ConBusinessPhone			= CASE WHEN (@isFormView = 1) THEN @conBusinessPhone WHEN ((@isFormView = 0) AND (@conBusinessPhone='#M4PL#')) THEN NULL ELSE ISNULL(@conBusinessPhone,ConBusinessPhone) END
		,ConBusinessPhoneExt		= CASE WHEN (@isFormView = 1) THEN @conBusinessPhoneExt WHEN ((@isFormView = 0) AND (@conBusinessPhoneExt='#M4PL#')) THEN NULL ELSE ISNULL(@conBusinessPhoneExt,ConBusinessPhoneExt) END
		,ConHomePhone				= CASE WHEN (@isFormView = 1) THEN @conHomePhone WHEN ((@isFormView = 0) AND (@conHomePhone='#M4PL#')) THEN NULL ELSE ISNULL(@conHomePhone ,ConHomePhone) END
		,ConMobilePhone				= CASE WHEN (@isFormView = 1) THEN @conMobilePhone WHEN ((@isFormView = 0) AND (@conMobilePhone='#M4PL#')) THEN NULL ELSE ISNULL(@conMobilePhone,ConMobilePhone) END
		,ConFaxNumber				= CASE WHEN (@isFormView = 1) THEN @conFaxNumber WHEN ((@isFormView = 0) AND (@conFaxNumber='#M4PL#')) THEN NULL ELSE ISNULL(@conFaxNumber,ConFaxNumber) END
		,ConBusinessAddress1		= CASE WHEN (@isFormView = 1) THEN @conBusinessAddress1 WHEN ((@isFormView = 0) AND (@conBusinessAddress1='#M4PL#')) THEN NULL ELSE ISNULL(@conBusinessAddress1,ConBusinessAddress1) END
		,ConBusinessAddress2		= CASE WHEN (@isFormView = 1) THEN @conBusinessAddress2 WHEN ((@isFormView = 0) AND (@conBusinessAddress2='#M4PL#')) THEN NULL ELSE ISNULL(@conBusinessAddress2,ConBusinessAddress2) END
		,ConBusinessCity			= CASE WHEN (@isFormView = 1) THEN @conBusinessCity WHEN ((@isFormView = 0) AND (@conBusinessCity='#M4PL#')) THEN NULL ELSE ISNULL(@conBusinessCity,ConBusinessCity) END
		,ConBusinessStateId			= ISNULL(@conBusinessStateId,ConBusinessStateId)
		,ConBusinessZipPostal		= CASE WHEN (@isFormView = 1) THEN @conBusinessZipPostal WHEN ((@isFormView = 0) AND (@conBusinessZipPostal='#M4PL#')) THEN NULL ELSE ISNULL(@conBusinessZipPostal,ConBusinessZipPostal) END
		,ConBusinessCountryId		= ISNULL(@conBusinessCountryId,ConBusinessCountryId)
		,ConHomeAddress1			= CASE WHEN (@isFormView = 1) THEN @conHomeAddress1 WHEN ((@isFormView = 0) AND (@conHomeAddress1='#M4PL#')) THEN NULL ELSE ISNULL(@conHomeAddress1,ConHomeAddress1) END
		,ConHomeAddress2			= CASE WHEN (@isFormView = 1) THEN @conHomeAddress2 WHEN ((@isFormView = 0) AND (@conHomeAddress2='#M4PL#')) THEN NULL ELSE ISNULL(@conHomeAddress2,ConHomeAddress2) END
		,ConHomeCity				= CASE WHEN (@isFormView = 1) THEN @conHomeCity WHEN ((@isFormView = 0) AND (@conHomeCity='#M4PL#')) THEN NULL ELSE ISNULL(@conHomeCity,ConHomeCity) END
		,ConHomeStateId				= ISNULL(@conHomeStateId,ConHomeStateId)
		,ConHomeZipPostal			= CASE WHEN (@isFormView = 1) THEN @conHomeZipPostal WHEN ((@isFormView = 0) AND (@conHomeZipPostal='#M4PL#')) THEN NULL ELSE ISNULL(@conHomeZipPostal,ConHomeZipPostal) END
		,ConHomeCountryId			= ISNULL(@conHomeCountryId,ConHomeCountryId)
		--,ConAttachments				= CASE WHEN (@isFormView = 1) THEN @conAttachments WHEN ((@isFormView = 0) AND (@conAttachments=-100)) THEN NULL ELSE ISNULL(@conAttachments ,ConAttachments) END
		,ConWebPage					= CASE WHEN (@isFormView = 1) THEN @conWebPage WHEN ((@isFormView = 0) AND (convert(nvarchar(max),@conWebPage)='#M4PL#')) THEN NULL ELSE ISNULL(@conWebPage,ConWebPage) END
		,ConNotes					= CASE WHEN (@isFormView = 1) THEN @conNotes WHEN ((@isFormView = 0) AND (convert(nvarchar(max),@conNotes)='#M4PL#')) THEN NULL ELSE ISNULL(@conNotes,ConNotes) END
		,StatusId					= ISNULL(@statusId ,StatusId)
		,ConTypeId					= ISNULL(@conTypeId,ConTypeId)
		,ConOutlookId				= CASE WHEN (@isFormView = 1) THEN @conOutlookId WHEN ((@isFormView = 0) AND (@conOutlookId='#M4PL#')) THEN NULL ELSE ISNULL(@conOutlookId,ConOutlookId) END
		,DateChanged				= @dateChanged 
		,ChangedBy					= @changedBy  
  WHERE  Id = @id
	SELECT con.[Id]
      ,con.[ConERPId]
      ,con.[ConOrgId]
      ,con.[ConTitleId]
      ,con.[ConLastName]
      ,con.[ConFirstName]
      ,con.[ConMiddleName]
      ,con.[ConEmailAddress]
      ,con.[ConEmailAddress2]
      ,con.[ConJobTitle]
      ,con.[ConBusinessPhone]
      ,con.[ConBusinessPhoneExt]
      ,con.[ConHomePhone]
      ,con.[ConMobilePhone]
      ,con.[ConFaxNumber]
      ,con.[ConBusinessAddress1]
      ,con.[ConBusinessAddress2]
      ,con.[ConBusinessCity]
      ,con.[ConBusinessStateId]
      ,con.[ConBusinessZipPostal]
      ,con.[ConBusinessCountryId]
      ,con.[ConHomeAddress1]
      ,con.[ConHomeAddress2]
      ,con.[ConHomeCity]
      ,con.[ConHomeStateId]
      ,con.[ConHomeZipPostal]
      ,con.[ConHomeCountryId]
      ,con.[ConAttachments]
      ,con.[ConWebPage]
      ,con.[ConNotes]
      ,con.[StatusId]
      ,con.[ConTypeId]
      ,con.[ConFullName]
      ,con.[ConFileAs]
      ,con.[ConOutlookId]
      ,con.[DateEntered]
      ,con.[EnteredBy]
      ,con.[DateChanged]
      ,con.[ChangedBy]
   FROM [dbo].[CONTC000Master] con
   WHERE [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
PRINT N'Altering [dbo].[UpdContactCard]...';


GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               02/28/2018      
-- Description:               Update a contact card 
-- Execution:                 EXEC [dbo].[UpdContactCard]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[UpdContactCard]
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id BIGINT
	,@conTitleId  INT = NULL
	,@conFirstName  NVARCHAR(25) = NULL
	,@conMiddleName  NVARCHAR(25) = NULL
	,@conLastName  NVARCHAR(25) = NULL
	,@conJobTitle  NVARCHAR(50) = NULL
	,@conOrgId  BIGINT
	,@conTypeId INT = NULL
	,@conBusinessPhone  NVARCHAR(25) = NULL
	,@conBusinessPhoneExt  NVARCHAR(15) = NULL
	,@conMobilePhone  NVARCHAR(25) = NULL
	,@conEmailAddress  NVARCHAR(100) = NULL
	,@conEmailAddress2  NVARCHAR(100) = NULL
	,@conBusinessAddress1  NVARCHAR(255) = NULL
	,@conBusinessAddress2  VARCHAR(150) = NULL
	,@conBusinessCity  NVARCHAR(25) = NULL
	,@conBusinessZipPostal  NVARCHAR(20) = NULL
	,@conBusinessStateId  INT = NULL
	,@conBusinessCountryId  INT = NULL
	,@dateChanged  DATETIME2(7) = NULL
	,@changedBy  NVARCHAR(50) = NULL
	,@isFormView BIT = 0
AS
BEGIN TRY                
 SET NOCOUNT ON;  
 UPDATE  [dbo].[CONTC000Master]
    SET  ConOrgId					= @conOrgId
		,ConTitleId					= @conTitleId
		,ConLastName				= @conLastName
		,ConFirstName				= @conFirstName
		,ConMiddleName				= @conMiddleName
		,ConEmailAddress			= @conEmailAddress
		,ConEmailAddress2			= @conEmailAddress2
		,ConJobTitle				= @conJobTitle
		,ConTypeId					= @conTypeId
		,ConBusinessPhone			= @conBusinessPhone
		,ConBusinessPhoneExt		= @conBusinessPhoneExt
		,ConMobilePhone				= @conMobilePhone
		,ConBusinessAddress1		= @conBusinessAddress1
		,ConBusinessAddress2		= @conBusinessAddress2
		,ConBusinessCity			= @conBusinessCity
		,ConBusinessStateId			= @conBusinessStateId
		,ConBusinessZipPostal		= @conBusinessZipPostal
		,ConBusinessCountryId		= @conBusinessCountryId
		,DateChanged				= @dateChanged 
		,ChangedBy					= @changedBy  
  WHERE  Id = @id
	SELECT con.[Id]
      ,con.[ConOrgId]
      ,con.[ConTitleId]
      ,con.[ConLastName]
      ,con.[ConFirstName]
      ,con.[ConMiddleName]
      ,con.[ConEmailAddress]
      ,con.[ConEmailAddress2]
      ,con.[ConJobTitle]
      ,con.[ConBusinessPhone]
      ,con.[ConBusinessPhoneExt]
      ,con.[ConMobilePhone]
      ,con.[ConBusinessAddress1]
      ,con.[ConBusinessAddress2]
      ,con.[ConBusinessCity]
      ,con.[ConBusinessStateId]
      ,con.[ConBusinessZipPostal]
      ,con.[ConBusinessCountryId]
      ,con.[ConFullName]
      ,con.[ConFileAs]
      ,con.[DateEntered]
      ,con.[EnteredBy]
      ,con.[DateChanged]
      ,con.[ChangedBy]
   FROM [dbo].[CONTC000Master] con
   WHERE [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH