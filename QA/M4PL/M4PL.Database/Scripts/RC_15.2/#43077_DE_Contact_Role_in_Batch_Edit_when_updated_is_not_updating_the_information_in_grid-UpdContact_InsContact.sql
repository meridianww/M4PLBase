/****** Object:  StoredProcedure [dbo].[UpdContact]    Script Date: 5/3/2019 11:51:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
	  ,con.[ConUDF01]
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
/****** Object:  StoredProcedure [dbo].[InsContact]    Script Date: 5/3/2019 11:50:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a contact 
-- Execution:                 EXEC [dbo].[InsContact]
-- Modified on:               105/03/2019( Kirty - Introduced @conUDF01.)  
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[InsContact]
	 @userId BIGINT
	,@roleId BIGINT 
	,@conOrgId BIGINT
	,@entity NVARCHAR(100)
	,@conERPId NVARCHAR(50) = NULL
	,@conTitleId INT = NULL
	,@conLastName NVARCHAR(25) = NULL
	,@conFirstName NVARCHAR(25) = NULL
	,@conMiddleName NVARCHAR(25) = NULL
	,@conEmailAddress NVARCHAR(100) = NULL
	,@conEmailAddress2 NVARCHAR(100) = NULL
	,@conJobTitle NVARCHAR(50) = NULL
	,@conBusinessPhone NVARCHAR(25) = NULL
	,@conBusinessPhoneExt NVARCHAR(15) = NULL
	,@conHomePhone NVARCHAR(25) = NULL
	,@conMobilePhone NVARCHAR(25) = NULL
	,@conFaxNumber NVARCHAR(25) = NULL
	,@conBusinessAddress1 NVARCHAR(255) = NULL
	,@conBusinessAddress2 NVARCHAR(150) = NULL
	,@conBusinessCity NVARCHAR(25) = NULL
	,@conBusinessStateId INT = NULL
	,@conBusinessZipPostal NVARCHAR(20) = NULL
	,@conBusinessCountryId INT = NULL
	,@conHomeAddress1 NVARCHAR(150) = NULL
	,@conHomeAddress2 NVARCHAR(150) = NULL
	,@conHomeCity NVARCHAR(25) = NULL
	,@conHomeStateId INT = NULL
	,@conHomeZipPostal NVARCHAR(20) = NULL
	,@conHomeCountryId INT = NULL
	,@conAttachments INT = NULL
	,@conWebPage NTEXT = NULL
	,@conNotes NTEXT = NULL
	,@statusId INT = NULL
	,@conTypeId INT = NULL
	,@conOutlookId NVARCHAR(50) = NULL
	,@dateEntered DATETIME2(7)
	,@enteredBy NVARCHAR(50) = NULL
	,@conUDF01 INT = NULL
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 DECLARE @currentId BIGINT;
 --DECLARE @OrgID BIGINT;
 --select @OrgID =OrgID from [dbo].[ORGAN020Act_Roles]  where id= @roleId and OrgRoleContactID = @userId
 INSERT INTO [dbo].[CONTC000Master]
        ([ConERPId]
        ,[ConTitleId]
        ,[ConLastName]
        ,[ConFirstName]
        ,[ConMiddleName]
        ,[ConEmailAddress]
        ,[ConEmailAddress2]
        ,[ConJobTitle]
        ,[ConBusinessPhone]
        ,[ConBusinessPhoneExt]
        ,[ConHomePhone]
        ,[ConMobilePhone]
        ,[ConFaxNumber]
        ,[ConBusinessAddress1]
        ,[ConBusinessAddress2]
        ,[ConBusinessCity]
        ,[ConBusinessStateId]
        ,[ConBusinessZipPostal]
        ,[ConBusinessCountryId]
        ,[ConHomeAddress1]
        ,[ConHomeAddress2]
        ,[ConHomeCity]
        ,[ConHomeStateId]
        ,[ConHomeZipPostal]
        ,[ConHomeCountryId]
        ,[ConAttachments]
        ,[ConWebPage]
        ,[ConNotes]
        ,[StatusId]
        ,[ConTypeId]
        ,[ConOutlookId]
        ,[DateEntered]
        ,[EnteredBy]
	    ,[ConOrgId]
		,[ConUDF01])
     VALUES
		(@conERPId 
		,@conTitleId
		,@conLastName
		,@conFirstName
		,@conMiddleName
		,@conEmailAddress
		,@conEmailAddress2
		,@conJobTitle
		,@conBusinessPhone
		,@conBusinessPhoneExt
		,@conHomePhone
		,@conMobilePhone
		,@conFaxNumber
		,@conBusinessAddress1
		,@conBusinessAddress2
		,@conBusinessCity
		,@conBusinessStateId
		,@conBusinessZipPostal
		,@conBusinessCountryId
		,@conHomeAddress1
		,@conHomeAddress2
		,@conHomeCity
		,@conHomeStateId
		,@conHomeZipPostal
		,@conHomeCountryId
		,@conAttachments
		,@conWebPage
		,@conNotes
		,@statusId
		,@conTypeId
		,@conOutlookId
		,@dateEntered
		,@enteredBy
		,@conOrgId
		,@conUDF01)

		SET @currentId = SCOPE_IDENTITY();
	 SELECT * FROM [dbo].[CONTC000Master] WHERE Id = @currentId;
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
