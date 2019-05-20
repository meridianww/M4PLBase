/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a contact 
-- Execution:                 EXEC [dbo].[InsContact]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[InsContact]
	 @userId BIGINT
	,@roleId BIGINT 
	,@conOrgId BIGINT
	,@conCompanyName  NVARCHAR(100)
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
		,[ConOrgId]
		,[ConCompanyName]
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
		,[ConUDF01])
     VALUES
		(@conERPId 
		,@conTitleId
		,@conOrgId
		,@conCompanyName
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
		,@conUDF01)

		SET @currentId = SCOPE_IDENTITY();
	 EXEC [dbo].[GetContact] @userId, @roleId, @conOrgId, @currentId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO

