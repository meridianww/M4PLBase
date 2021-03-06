SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
CREATE PROCEDURE  [dbo].[UpdContactCard]
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
GO
