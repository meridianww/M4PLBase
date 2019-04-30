USE [M4PL_3030_Azure]
GO
/****** Object:  StoredProcedure [dbo].[UpdAttachment]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana B 
-- Create date:               11/11/2018      
-- Description:               Upd a Attachment  
-- Execution:                 EXEC [dbo].[UpdAttachment]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)
-- Modified Desc:  
-- =============================================   
    
    
ALTER PROCEDURE [dbo].[UpdAttachment]    
     (@userId BIGINT    
     ,@roleId BIGINT  
 	 ,@entity NVARCHAR(100)    
     ,@id bigint    
     ,@attTableName NVARCHAR(100) = NULL    
     ,@attPrimaryRecordID BIGINT = NULL    
     ,@attItemNumber INT = NULL    
     ,@attTitle NVARCHAR(50) = NULL    
     ,@attTypeId INT = NULL    
     ,@attFileName NVARCHAR(50) = NULL    
     ,@attDownLoadedDate DATETIME2(7) = NULL    
     ,@attDownLoadedBy NVARCHAR(50) = NULL 
	 ,@statusId INT = NULL    
     ,@changedBy NVARCHAR(50) = NULL    
     ,@dateChanged DATETIME2(7) = NULL
	,@isFormView BIT = 0)    
AS    
BEGIN TRY                    
 SET NOCOUNT ON;  
  DECLARE @updatedItemNumber INT      
    DECLARE @where NVARCHAR(MAX) = ' AND AttTableName ='''  +  @attTableName+'''';
  EXEC [dbo].[ResetItemNumber] @userId, @id, @attPrimaryRecordID, @entity, @attItemNumber, @statusId, NULL, @where, @updatedItemNumber OUTPUT  
      
 UPDATE  [dbo].[SYSTM020Ref_Attachments]  
      SET   [AttTableName]     = CASE WHEN (@isFormView = 1) THEN @attTableName WHEN ((@isFormView = 0) AND (@attTableName='#M4PL#')) THEN NULL ELSE ISNULL(@attTableName, AttTableName) END    
           ,[AttPrimaryRecordID]     = CASE WHEN (@isFormView = 1) THEN @attPrimaryRecordID WHEN ((@isFormView = 0) AND (@attPrimaryRecordID=-100)) THEN NULL ELSE ISNULL(@attPrimaryRecordID, AttPrimaryRecordID) END    
           ,[AttItemNumber]   = CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber  , AttItemNumber) END    
           ,[AttTitle]     = CASE WHEN (@isFormView = 1) THEN @attTitle WHEN ((@isFormView = 0) AND (@attTitle='#M4PL#')) THEN NULL ELSE ISNULL(@attTitle, AttTitle) END    
           ,[AttTypeId]   = CASE WHEN (@isFormView = 1) THEN @attTypeId WHEN ((@isFormView = 0) AND (@attTypeId=-100)) THEN NULL ELSE ISNULL(@attTypeId , AttTypeId) END    
           ,[AttFileName]   = CASE WHEN (@isFormView = 1) THEN @attFileName WHEN ((@isFormView = 0) AND (@attFileName='#M4PL#')) THEN NULL ELSE ISNULL(@attFileName, AttFileName) END    
           ,[AttDownloadedDate]    = ISNULL(@attDownLoadedDate, AttDownloadedDate)
           ,[AttDownloadedBy]     = CASE WHEN (@isFormView = 1) THEN @attDownLoadedBy WHEN ((@isFormView = 0) AND (@attDownLoadedBy='#M4PL#')) THEN NULL ELSE ISNULL(@attDownLoadedBy, AttDownloadedBy) END   
		   ,[StatusId] = CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId,StatusId) END
           ,[ChangedBy]     = @changedBy    
           ,[DateChanged]    = @dateChanged    
 WHERE [Id] = @id    
 SELECT * FROM [dbo].[SYSTM020Ref_Attachments] WHERE Id = @id    
END TRY                  
BEGIN CATCH                    
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                    
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                    
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                    
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                    
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdColumnAlias]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */  
-- =============================================          
-- Author:                    Akhil Chauhan  
-- Create date:               10/10/2018        
-- Description:               Upd a Sys column alias  
-- Execution:                 EXEC [dbo].[UpdColumnAlias]  
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)    
-- Modified Desc:    
-- =============================================  
ALTER PROCEDURE  [dbo].[UpdColumnAlias]      
 @userId BIGINT  
,@roleId BIGINT  
,@entity NVARCHAR(100)  
,@langCode NVARCHAR(10)  
,@id BIGINT   
,@colTableName NVARCHAR(100)   
,@colColumnName NVARCHAR(50)    
,@colAliasName NVARCHAR(50) = NULL  
,@lookupId INT = NULL  
,@colCaption NVARCHAR(50) = NULL  
,@colDescription NVARCHAR(255) =  NULL  
,@colSortOrder INT = NULL  
,@colIsReadOnly BIT = NULL  
,@colIsVisible BIT   
,@colIsDefault BIT    
,@statusId INT = NULL  
,@isFormView BIT = 0  
AS  
BEGIN TRY                  
 SET NOCOUNT ON;     
  
  DECLARE @updatedItemNumber INT        
  DECLARE @where NVARCHAR(MAX) =    ' AND ColTableName ='''  +  CAST(@colTableName AS VARCHAR)+'';      
  EXEC [dbo].[ResetItemNumber] @userId, 0, NULL, @entity, @colSortOrder, @statusId, NULL, @where,  @updatedItemNumber OUTPUT  
      
  
    UPDATE  [dbo].[SYSTM000ColumnsAlias]  
    SET     --LangCode   = @langCode  
	    LangCode  = CASE WHEN (@isFormView = 1) THEN @langCode WHEN ((@isFormView = 0) AND (@langCode='#M4PL#')) THEN NULL ELSE ISNULL(@langCode, LangCode) END     
           ,ColTableName  = @colTableName    
           ,ColColumnName  = @colColumnName    
           ,ColAliasName  = CASE WHEN (@isFormView = 1) THEN @colAliasName WHEN ((@isFormView = 0) AND (@colAliasName='#M4PL#')) THEN NULL ELSE ISNULL(@colAliasName, ColAliasName) END   
     ,ColLookupId  = CASE WHEN (@isFormView = 1) THEN @lookupId WHEN ((@isFormView = 0) AND (@lookupId=-100)) THEN NULL ELSE ISNULL(@lookupId, ColLookupId) END   
           ,ColCaption   = CASE WHEN (@isFormView = 1) THEN @colCaption WHEN ((@isFormView = 0) AND (@colCaption='#M4PL#')) THEN NULL ELSE ISNULL(@colCaption, ColCaption) END   
           ,ColDescription  = CASE WHEN (@isFormView = 1) THEN @colDescription WHEN ((@isFormView = 0) AND (@colDescription='#M4PL#')) THEN NULL ELSE ISNULL(@colDescription, ColDescription) END  
           ,ColSortOrder  = CASE WHEN (@isFormView = 1) THEN @colSortOrder WHEN ((@isFormView = 0) AND (@colSortOrder=-100)) THEN NULL ELSE ISNULL(@colSortOrder, ColSortOrder) END    
     --,ColSortOrder = CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber  , ColSortOrder) END  
           ,ColIsReadOnly  = ISNULL(@colIsReadOnly,  ColIsReadOnly)  
     ,StatusId  = CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId,  StatusId) END  
           ,ColIsVisible  = @colIsVisible     
           ,ColIsDefault    = @colIsDefault   
    WHERE Id = @id  
  
   IF(@lookupId > 0)  
  BEGIN  
   UPDATE cal  
      SET cal.[ColLookupCode] = lk.LkupCode  
   FROM  [SYSTM000ColumnsAlias] cal  
   INNER JOIN [dbo].[SYSTM000Ref_Lookup] lk  ON lk.Id= cal.[ColLookupCode] AND cal.Id = @id  
 END  
  
 EXEC [dbo].[GetColumnAlias] @userId, @roleId, 1, @langCode, @id   
  
END TRY                   
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdContact]    Script Date: 11/27/2018 12:43:09 PM ******/
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
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[UpdContact]
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id BIGINT
	,@conERPId  NVARCHAR(50) = NULL
	,@conCompany  NVARCHAR(100) = NULL
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
		,ConCompany					= CASE WHEN (@isFormView = 1) THEN @conCompany WHEN ((@isFormView = 0) AND (@conCompany='#M4PL#')) THEN NULL ELSE ISNULL(@conCompany,ConCompany) END
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
      ,con.[ConCompany]
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
/****** Object:  StoredProcedure [dbo].[UpdContactCard]    Script Date: 11/27/2018 12:43:09 PM ******/
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
	,@conCompany  NVARCHAR(100) = NULL
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
    SET  ConCompany					= @conCompany
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
      ,con.[ConCompany]
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
/****** Object:  StoredProcedure [dbo].[UpdCustBusinessTerm]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Upd a cust contact
-- Execution:                 EXEC [dbo].[UpdCustBusinessTerm]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[UpdCustBusinessTerm]		  
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@langCode NVARCHAR(10)
	,@id  BIGINT
	,@cbtOrgId  BIGINT  = NULL
	,@cbtCustomerId  BIGINT  = NULL
	,@cbtItemNumber  INT  = NULL
	,@cbtCode  NVARCHAR(20)  = NULL
	,@cbtTitle  NVARCHAR(50)  = NULL
	,@businessTermTypeId  INT  = NULL
	,@cbtActiveDate  DATETIME2(7)  = NULL
	,@cbtValue  DECIMAL(18, 2)  = NULL
	,@cbtHiThreshold  DECIMAL(18, 2)  = NULL
	,@cbtLoThreshold  DECIMAL(18, 2)  = NULL
	,@cbtAttachment  INT  = NULL
	,@statusId  INT  = NULL
	,@changedBy  NVARCHAR(50)  = NULL
	,@dateChanged  DATETIME2(7)  = NULL
	,@isFormView BIT = 0
AS
BEGIN TRY                
 SET NOCOUNT ON; 
   DECLARE @updatedItemNumber INT      
  EXEC [dbo].[ResetItemNumber] @userId, @id, @cbtCustomerId, @entity, @cbtItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT  
   
   UPDATE  [dbo].[CUST020BusinessTerms] 
      SET    LangCode				= 	 CASE WHEN (@isFormView = 1) THEN @langCode WHEN ((@isFormView = 0) AND (@langCode='#M4PL#')) THEN LangCode ELSE ISNULL(@langCode, LangCode)  END
			,CbtOrgId				= 	 CASE WHEN (@isFormView = 1) THEN @cbtOrgId WHEN ((@isFormView = 0) AND (@cbtOrgId=-100)) THEN NULL ELSE ISNULL(@cbtOrgId, CbtOrgId) END
			,CbtCustomerId			= 	 CASE WHEN (@isFormView = 1) THEN @cbtCustomerId WHEN ((@isFormView = 0) AND (@cbtCustomerId=-100)) THEN NULL ELSE ISNULL(@cbtCustomerId, CbtCustomerId)  END
			,CbtItemNumber			= 	 CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, CbtItemNumber)  END
			,CbtCode				= 	 CASE WHEN (@isFormView = 1) THEN @cbtCode WHEN ((@isFormView = 0) AND (@cbtCode='#M4PL#')) THEN NULL ELSE ISNULL(@cbtCode, CbtCode)  END
			,CbtTitle				= 	 CASE WHEN (@isFormView = 1) THEN @cbtTitle WHEN ((@isFormView = 0) AND (@cbtTitle='#M4PL#')) THEN NULL ELSE ISNULL(@cbtTitle, CbtTitle)  END
			,BusinessTermTypeId     = 	 CASE WHEN (@isFormView = 1) THEN @businessTermTypeId WHEN ((@isFormView = 0) AND (@businessTermTypeId=-100)) THEN NULL ELSE ISNULL(@businessTermTypeId, BusinessTermTypeId)  END
			,CbtActiveDate			= 	 CASE WHEN (@isFormView = 1) THEN @cbtActiveDate WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @cbtActiveDate, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@cbtActiveDate, CbtActiveDate) END
			,CbtValue				= 	 CASE WHEN (@isFormView = 1) THEN @cbtValue WHEN ((@isFormView = 0) AND (@cbtValue=-100.00)) THEN NULL ELSE ISNULL(@cbtValue, CbtValue)  END
			,CbtHiThreshold			= 	 CASE WHEN (@isFormView = 1) THEN @cbtHiThreshold WHEN ((@isFormView = 0) AND (@cbtHiThreshold=-100.00)) THEN NULL ELSE ISNULL(@cbtHiThreshold, CbtHiThreshold)  END
			,CbtLoThreshold			= 	 CASE WHEN (@isFormView = 1) THEN @cbtLoThreshold WHEN ((@isFormView = 0) AND (@cbtLoThreshold=-100.00)) THEN NULL ELSE ISNULL(@cbtLoThreshold, CbtLoThreshold)  END
			--,CbtAttachment			= 	 CASE WHEN (@isFormView = 1) THEN @cbtAttachment WHEN ((@isFormView = 0) AND (@cbtAttachment=-100)) THEN NULL ELSE ISNULL(@cbtAttachment, CbtAttachment)  END
			,StatusId				= 	 CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId)  END
			,ChangedBy				= 	 @changedBy  
			,DateChanged			= 	 @dateChanged 	
       WHERE Id = @id		   

	EXEC [dbo].[GetCustBusinessTerm] @userId, @roleId, @cbtOrgId,@langCode ,@id 
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdCustContact]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/08/2018      
-- Description:               Upd a cust contact
-- Execution:                 EXEC [dbo].[UpdCustContact]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[UpdCustContact]
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id BIGINT
	,@custCustomerId BIGINT   = NULL
	,@custItemNumber INT   = NULL
	,@custContactCode NVARCHAR(20)  = NULL
	,@custContactTitle NVARCHAR(50)  = NULL
	,@custContactMSTRId BIGINT  = NULL 
	,@statusId INT  = NULL 
	,@changedBy NVARCHAR(50)  = NULL
	,@dateChanged DATETIME2(7)  = NULL
	,@isFormView BIT = 0

AS
BEGIN TRY                
 SET NOCOUNT ON;  

  DECLARE @updatedItemNumber INT     
  EXEC [dbo].[ResetItemNumber] @userId, @id, @custCustomerId, @entity, @custItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT 

 DECLARE @recordId BIGINT

 SELECT 
 @recordId=Id,
 @custItemNumber=ISNULL(@custItemNumber, CustItemNumber) 
 FROM [dbo].[CUST010Contacts] WHERE Id = @id

 IF(@recordId=@id)
 BEGIN
   UPDATE [dbo].[CUST010Contacts]
	    SET CustCustomerId    = CASE WHEN (@isFormView = 1) THEN @custCustomerId WHEN ((@isFormView = 0) AND (@custCustomerId=-100)) THEN NULL ELSE ISNULL(@custCustomerId, CustCustomerId) END
           ,CustItemNumber	  = CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, CustItemNumber) END
           ,CustContactCode	  = CASE WHEN (@isFormView = 1) THEN @custContactCode WHEN ((@isFormView = 0) AND (@custContactCode='#M4PL#')) THEN NULL ELSE ISNULL(@custContactCode, CustContactCode) END
           ,CustContactTitle  = CASE WHEN (@isFormView = 1) THEN @custContactTitle WHEN ((@isFormView = 0) AND (@custContactTitle='#M4PL#')) THEN NULL ELSE ISNULL(@custContactTitle, CustContactTitle) END
           ,CustContactMSTRId = CASE WHEN (@isFormView = 1) THEN @custContactMSTRId WHEN ((@isFormView = 0) AND (@custContactMSTRId=-100)) THEN NULL ELSE ISNULL(@custContactMSTRId, CustContactMSTRId) END
           ,StatusId		  = CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
           ,ChangedBy		  = @changedBy 
           ,DateChanged		  = @dateChanged 	
      WHERE Id = @id		  
 END

IF(ISNULL(@statusId, 1) <> -100)
BEGIN
	IF(ISNULL(@statusId, 1) > 2)
	BEGIN
		EXEC [dbo].[UpdateColumnCount] @tableName = 'CUST000Master', @columnName = 'CustContacts',  @rowId = @custCustomerId, @countToChange = -1
	END
END

SELECT cust.[Id]
      ,cust.[CustCustomerID]
      ,cust.[CustItemNumber]
      ,cust.[CustContactCode]
      ,cust.[CustContactTitle]
      ,cust.[CustContactMSTRID]
      ,cust.[StatusId]
      ,cust.[EnteredBy]
      ,cust.[DateEntered]
      ,cust.[ChangedBy]
      ,cust.[DateChanged]
	   FROM [dbo].[CUST010Contacts] cust WHERE [Id]=@id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdCustDcLocation]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Upd a cust DCLocations
-- Execution:                 EXEC [dbo].[UpdCustDcLocation]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[UpdCustDcLocation]		  
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id BIGINT
	,@cdcCustomerId BIGINT = NULL
	,@cdcItemNumber INT  = NULL
	,@cdcLocationCode NVARCHAR(20)  = NULL
	,@cdcCustomerCode NVARCHAR(20) =NULL
	,@cdcLocationTitle NVARCHAR(50)  = NULL
	,@cdcContactMSTRId BIGINT  = NULL
	,@statusId INT   = NULL
	,@changedBy NVARCHAR(50)  = NULL
	,@dateChanged DATETIME2(7)  = NULL		  
	,@isFormView BIT = 0
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  DECLARE @updatedItemNumber INT      
 EXEC [dbo].[ResetItemNumber] @userId, @id, @cdcCustomerId, @entity, @cdcItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT 

    UPDATE  [dbo].[CUST040DCLocations]
       SET   CdcCustomerId	  = CASE WHEN (@isFormView = 1) THEN @cdcCustomerId WHEN ((@isFormView = 0) AND (@cdcCustomerId=-100)) THEN NULL ELSE ISNULL(@cdcCustomerId, CdcCustomerId) END
            ,CdcItemNumber	  = CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, CdcItemNumber) END
            ,CdcLocationCode  = CASE WHEN (@isFormView = 1) THEN @cdcLocationCode WHEN ((@isFormView = 0) AND (@cdcLocationCode='#M4PL#')) THEN NULL ELSE ISNULL(@cdcLocationCode, CdcLocationCode) END 
			,CdcCustomerCode  = CASE WHEN (@isFormView = 1) THEN ISNULL(@cdcCustomerCode,@cdcLocationCode) WHEN ((@isFormView = 0) AND (@cdcCustomerCode='#M4PL#')) THEN @cdcLocationCode ELSE ISNULL(@cdcCustomerCode,CdcCustomerCode)  END
            ,CdcLocationTitle = CASE WHEN (@isFormView = 1) THEN @cdcLocationTitle WHEN ((@isFormView = 0) AND (@cdcLocationTitle='#M4PL#')) THEN NULL ELSE ISNULL(@cdcLocationTitle, CdcLocationTitle) END  
            ,CdcContactMSTRId = CASE WHEN (@isFormView = 1) THEN @cdcContactMSTRId WHEN ((@isFormView = 0) AND (@cdcContactMSTRId=-100)) THEN NULL ELSE ISNULL(@cdcContactMSTRId, CdcContactMSTRId) END
            ,StatusId		  = CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
            ,ChangedBy		  = @changedBy   
            ,DateChanged	  = @dateChanged 
	  WHERE  Id = @id 
     
	 /*Below to update DcLocationContact Code*/
	 UPDATE cdcContact SET cdcContact.ClcContactCode = cdc.CdcLocationCode 
	 FROM [dbo].[CUST041DCLocationContacts] cdcContact
	 INNER JOIN [dbo].[CUST040DCLocations] cdc ON cdcContact.ClcCustDcLocationId = cdc.Id
	              
	EXEC [dbo].[GetCustDcLocation] @userId, @roleId, 1 ,@id 
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdCustDcLocationContact]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/25/2018      
-- Description:               Upd a cust DCLocation Contact
-- Execution:                 EXEC [dbo].[UpdCustDcLocationContact]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[UpdCustDcLocationContact]		  
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id BIGINT
	,@clcCustDcLocationId BIGINT = NULL
	,@clcItemNumber INT = NULL
	,@clcContactCode NVARCHAR(50)  = NULL
	,@clcContactTitle NVARCHAR(50)  = NULL
	,@clcContactMSTRID BIGINT   = NULL
	,@clcAssignment NVARCHAR(50)  = NULL
	,@clcGateway NVARCHAR(50)  = NULL
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
  EXEC [dbo].[ResetItemNumber] @userId, @id, @clcCustDcLocationId, @entity, @clcItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT  
  --First Update Contact
  IF((ISNULL(@clcContactMSTRID, 0) <> 0) AND (@isFormView = 1))
  BEGIN
	UPDATE  [dbo].[CONTC000Master]
	  SET  ConCompany					= CASE WHEN (@isFormView = 1) THEN @conCompany WHEN ((@isFormView = 0) AND (@conCompany='#M4PL#')) THEN NULL ELSE ISNULL(@conCompany,ConCompany) END
			,ConTitleId					= ISNULL(@conTitleId,ConTitleId)
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
	WHERE  Id = @clcContactMSTRID
  END

  --Then Update Cust Dc Location
    UPDATE  [dbo].[CUST041DCLocationContacts]
       SET  [ClcCustDcLocationId]		= CASE WHEN (@isFormView = 1) THEN @clcCustDcLocationId WHEN ((@isFormView = 0) AND (@clcCustDcLocationId=-100)) THEN NULL ELSE ISNULL(@clcCustDcLocationId, ClcCustDcLocationId) END
			,[ClcItemNumber]			= @updatedItemNumber
			,[ClcContactCode]			= CASE WHEN (@isFormView = 1) THEN @clcContactCode WHEN ((@isFormView = 0) AND (@clcContactCode='#M4PL#')) THEN NULL ELSE ISNULL(@clcContactCode, ClcContactCode) END 
			,[ClcContactTitle]			= CASE WHEN (@isFormView = 1) THEN @clcContactTitle WHEN ((@isFormView = 0) AND (@clcContactTitle='#M4PL#')) THEN NULL ELSE ISNULL(@clcContactTitle, ClcContactTitle) END  
			,[ClcContactMSTRID]			= CASE WHEN (@isFormView = 1) THEN @clcContactMSTRID WHEN ((@isFormView = 0) AND (@clcContactMSTRID=-100)) THEN NULL ELSE ISNULL(@clcContactMSTRID, ClcContactMSTRID) END
			,[ClcAssignment]			= CASE WHEN (@isFormView = 1) THEN @clcAssignment WHEN ((@isFormView = 0) AND (@clcAssignment='#M4PL#')) THEN NULL ELSE ISNULL(@clcAssignment, ClcAssignment) END 
			,[ClcGateway]				= CASE WHEN (@isFormView = 1) THEN @clcGateway WHEN ((@isFormView = 0) AND (@clcGateway='#M4PL#')) THEN NULL ELSE ISNULL(@clcGateway, ClcGateway) END 
			,[StatusId]					= CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
            ,[ChangedBy]				= @changedBy   
            ,[DateChanged]				= @dateChanged 
	  WHERE  [Id] = @id 
                  
	EXEC [dbo].[GetCustDcLocationContact] @userId, @roleId, 1 ,@id 
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdCustDocReference]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Upd a cust document reference
-- Execution:                 EXEC [dbo].[UpdCustDocReference]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[UpdCustDocReference]		  
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id BIGINT
	,@cdrOrgId BIGINT  = NULL
	,@cdrCustomerId BIGINT  = NULL
	,@cdrItemNumber INT = NULL 
	,@cdrCode NVARCHAR(20) = NULL 
	,@cdrTitle NVARCHAR(50)  = NULL
	,@docRefTypeId INT  = NULL
	,@docCategoryTypeId INT = NULL 
	,@cdrAttachment INT  = NULL
	,@cdrDateStart DATETIME2(7)  = NULL
	,@cdrDateEnd DATETIME2(7)  = NULL
	,@cdrRenewal BIT   = NULL
	,@statusId INT = NULL 
	,@changedBy NVARCHAR(50)  = NULL
	,@dateChanged DATETIME2(7)  = NULL
	,@isFormView BIT = 0
AS
BEGIN TRY                
 SET NOCOUNT ON;   

  DECLARE @updatedItemNumber INT      
 EXEC [dbo].[ResetItemNumber] @userId, @id, @cdrCustomerId, @entity, @cdrItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT
     UPDATE [dbo].[CUST030DocumentReference]
        SET  CdrOrgId				= CASE WHEN (@isFormView = 1) THEN @cdrOrgId WHEN ((@isFormView = 0) AND (@cdrOrgId=-100)) THEN NULL ELSE ISNULL(@cdrOrgId, CdrOrgId) END
            ,CdrCustomerId			= CASE WHEN (@isFormView = 1) THEN @cdrCustomerId WHEN ((@isFormView = 0) AND (@cdrCustomerId=-100)) THEN NULL ELSE ISNULL(@cdrCustomerId, CdrCustomerId) END
            ,CdrItemNumber			= CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, CdrItemNumber) END
            ,CdrCode				= CASE WHEN (@isFormView = 1) THEN @cdrCode WHEN ((@isFormView = 0) AND (@cdrCode='#M4PL#')) THEN NULL ELSE ISNULL(@cdrCode, CdrCode) END
            ,CdrTitle				= CASE WHEN (@isFormView = 1) THEN @cdrTitle WHEN ((@isFormView = 0) AND (@cdrTitle='#M4PL#')) THEN NULL ELSE ISNULL(@cdrTitle, CdrTitle) END
            ,DocRefTypeId			= CASE WHEN (@isFormView = 1) THEN @docRefTypeId WHEN ((@isFormView = 0) AND (@docRefTypeId=-100)) THEN NULL ELSE ISNULL(@docRefTypeId, DocRefTypeId) END
            ,DocCategoryTypeId		= CASE WHEN (@isFormView = 1) THEN @docCategoryTypeId WHEN ((@isFormView = 0) AND (@docCategoryTypeId=-100)) THEN NULL ELSE ISNULL(@docCategoryTypeId, DocCategoryTypeId) END 
            --,CdrAttachment			= CASE WHEN (@isFormView = 1) THEN @cdrAttachment WHEN ((@isFormView = 0) AND (@cdrAttachment=-100)) THEN NULL ELSE ISNULL(@cdrAttachment, CdrAttachment) END
            ,CdrDateStart			= CASE WHEN (@isFormView = 1) THEN @cdrDateStart WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @cdrDateStart, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@cdrDateStart, CdrDateStart) END
            ,CdrDateEnd				= CASE WHEN (@isFormView = 1) THEN @cdrDateEnd WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @cdrDateEnd, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@cdrDateEnd, CdrDateEnd) END
            ,CdrRenewal				= ISNULL(@cdrRenewal, CdrRenewal)	  
            ,StatusId				= CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END	  
            ,ChangedBy				= @changedBy  
            ,DateChanged			= @dateChanged		
       WHERE Id= @id
	EXEC [dbo].[GetCustDocReference] @userId, @roleId, @cdrOrgId ,@id 
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdCustFinacialCalender]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Upd a cust finacial cal
-- Execution:                 EXEC [dbo].[UpdCustFinacialCalender]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[UpdCustFinacialCalender]		  
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id BIGINT 
	,@orgId BIGINT = NULL 
	,@custId BIGINT = NULL 
	,@fclPeriod INT  = NULL
	,@fclPeriodCode NVARCHAR(20)  = NULL
	,@fclPeriodStart DATETIME2(7)  = NULL
	,@fclPeriodEnd DATETIME2(7)  = NULL
	,@fclPeriodTitle NVARCHAR(50)  = NULL
	,@fclAutoShortCode NVARCHAR(15)  = NULL
	,@fclWorkDays INT  = NULL
	,@finCalendarTypeId INT  = NULL
	,@statusId INT = NULL 
	,@dateChanged DATETIME2(7)  = NULL
	,@changedBy NVARCHAR(50)  = NULL
	,@isFormView BIT = 0
AS
BEGIN TRY                
 SET NOCOUNT ON;   
    DECLARE @updatedItemNumber INT      
  EXEC [dbo].[ResetItemNumber] @userId, @id, @custId, @entity, @fclPeriod, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT  


    UPDATE  [dbo].[CUST050Finacial_Cal]
      SET  OrgId				= CASE WHEN (@isFormView = 1) THEN @orgId WHEN ((@isFormView = 0) AND (@orgId=-100)) THEN NULL ELSE ISNULL(@orgId, OrgId) END
          ,CustId				= CASE WHEN (@isFormView = 1) THEN @custId WHEN ((@isFormView = 0) AND (@custId=-100)) THEN NULL ELSE ISNULL(@custId, CustId) END
          ,FclPeriod			= CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, FclPeriod) END
          ,FclPeriodCode		= CASE WHEN (@isFormView = 1) THEN @fclPeriodCode WHEN ((@isFormView = 0) AND (@fclPeriodCode='#M4PL#')) THEN NULL ELSE ISNULL(@fclPeriodCode, FclPeriodCode) END
          ,FclPeriodStart		= CASE WHEN (@isFormView = 1) THEN @fclPeriodStart WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @fclPeriodStart, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@fclPeriodStart, FclPeriodStart) END
          ,FclPeriodEnd			= CASE WHEN (@isFormView = 1) THEN @fclPeriodEnd WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @fclPeriodEnd, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@fclPeriodEnd, FclPeriodEnd) END
          ,FclPeriodTitle		= CASE WHEN (@isFormView = 1) THEN @fclPeriodTitle WHEN ((@isFormView = 0) AND (@fclPeriodTitle='#M4PL#')) THEN NULL ELSE ISNULL(@fclPeriodTitle, FclPeriodTitle) END
          ,FclAutoShortCode		= CASE WHEN (@isFormView = 1) THEN @fclAutoShortCode WHEN ((@isFormView = 0) AND (@fclAutoShortCode='#M4PL#')) THEN NULL ELSE ISNULL(@fclAutoShortCode, FclAutoShortCode) END
          ,FclWorkDays			= CASE WHEN (@isFormView = 1) THEN @fclWorkDays WHEN ((@isFormView = 0) AND (@fclWorkDays=-100)) THEN NULL ELSE ISNULL(@fclWorkDays, FclWorkDays) END
          ,FinCalendarTypeId	= CASE WHEN (@isFormView = 1) THEN @finCalendarTypeId WHEN ((@isFormView = 0) AND (@finCalendarTypeId=-100)) THEN NULL ELSE ISNULL(@finCalendarTypeId, FinCalendarTypeId) END  
          ,StatusId				= CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
          ,DateChanged			= @dateChanged 
          ,ChangedBy 			= @changedBy 	
	  WHERE Id = @id
	EXEC [dbo].[GetCustFinacialCalender] @userId, @roleId, @orgId ,@id 
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdCustomer]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/09/2018      
-- Description:               Update a customer
-- Execution:                 EXEC [dbo].[UpdCustomer]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================

ALTER PROCEDURE  [dbo].[UpdCustomer]
	(@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id bigint
	,@custERPId NVARCHAR(10) = NULL
	,@custOrgId BIGINT = NULL
	,@custItemNumber INT = NULL
	,@custCode NVARCHAR(20) = NULL
	,@custTitle NVARCHAR(50) = NULL
	,@custWorkAddressId BIGINT = NULL
	,@custBusinessAddressId BIGINT = NULL
	,@custCorporateAddressId BIGINT = NULL
	,@custContacts INT = NULL
	,@custTypeId INT = NULL
	,@custTypeCode NVARCHAR(100) = NULL
	,@custWebPage NVARCHAR(100) = NULL
	,@statusId INT = NULL
	,@changedBy NVARCHAR(50) = NULL
	,@dateChanged DATETIME2(7) = NULL
	,@isFormView BIT = 0)
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  DECLARE @updatedItemNumber INT      
  EXEC [dbo].[ResetItemNumber] @userId, @id, @custOrgId, @entity, @custItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT 

  IF NOT EXISTS(SELECT Id  FROM [dbo].[SYSTM000Ref_Options] WHERE SysOptionName = @custTypeCode) AND ISNULL(@custTypeId,0) = 0
  BEGIN
     DECLARE @highestTypeCodeSortOrder INT;
	 SELECT @highestTypeCodeSortOrder = MAX(SysSortOrder) FROM [dbo].[SYSTM000Ref_Options] WHERE SysLookupId=8; 
	 SET @highestTypeCodeSortOrder = ISNULL(@highestTypeCodeSortOrder, 0) + 1;
     INSERT INTO [dbo].[SYSTM000Ref_Options](SysLookupId, SysLookupCode, SysOptionName, SysSortOrder, StatusId, DateEntered, EnteredBy)
	 VALUES(8, 'CustomerType', @custTypeCode, @highestTypeCodeSortOrder , ISNULL(@statusId,1), @dateChanged, @changedBy)
	 SET @custTypeId = SCOPE_IDENTITY();
  END
  ELSE IF ((@custTypeId > 0) AND (ISNULL(@custTypeCode, '') <> ''))
  BEGIN
    UPDATE [dbo].[SYSTM000Ref_Options] SET SysOptionName =@custTypeCode WHERE Id =@custTypeId
  END

 UPDATE [dbo].[CUST000Master]
      SET   [CustERPId]					= CASE WHEN (@isFormView = 1) THEN @custERPId WHEN ((@isFormView = 0) AND (@custERPId='#M4PL#')) THEN NULL ELSE ISNULL(@custERPId, CustERPId) END
           ,[CustOrgId]					= CASE WHEN (@isFormView = 1) THEN @custOrgId WHEN ((@isFormView = 0) AND (@custOrgId=-100)) THEN NULL ELSE ISNULL(@custOrgId, CustOrgId) END
           ,[CustItemNumber]			= CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber  , CustItemNumber) END
           ,[CustCode]					= CASE WHEN (@isFormView = 1) THEN @custCode WHEN ((@isFormView = 0) AND (@custCode='#M4PL#')) THEN NULL ELSE ISNULL(@custCode, CustCode) END
           ,[CustTitle]					= CASE WHEN (@isFormView = 1) THEN @custTitle WHEN ((@isFormView = 0) AND (@custTitle='#M4PL#')) THEN NULL ELSE ISNULL(@custTitle, CustTitle) END
           ,[CustWorkAddressId]			= CASE WHEN(@custWorkAddressId = 0) THEN NULL ELSE ISNULL(@custWorkAddressId, CustWorkAddressId) END
           ,[CustBusinessAddressId]		= CASE WHEN(@custBusinessAddressId = 0) THEN NULL ELSE ISNULL(@custBusinessAddressId, CustBusinessAddressId) END
           ,[CustCorporateAddressId]	= CASE WHEN(@custCorporateAddressId = 0) THEN NULL ELSE ISNULL(@custCorporateAddressId, CustCorporateAddressId) END
           --,[CustContacts]				= CASE WHEN (@isFormView = 1) THEN @custContacts WHEN ((@isFormView = 0) AND (@custContacts=-100)) THEN NULL ELSE ISNULL(@custContacts, CustContacts) END
           ,[CustTypeId]				= CASE WHEN (@isFormView = 1) THEN @custTypeId WHEN ((@isFormView = 0) AND (@custTypeId=-100)) THEN NULL ELSE ISNULL(@custTypeId  , CustTypeId) END
           ,[CustWebPage]				= CASE WHEN (@isFormView = 1) THEN @custWebPage WHEN ((@isFormView = 0) AND (@custWebPage='#M4PL#')) THEN NULL ELSE ISNULL(@custWebPage , CustWebPage) END
           ,[StatusId]					= CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
           ,[ChangedBy]					= @changedBy
           ,[DateChanged]				= @dateChanged
	WHERE	[Id] = @id

		EXEC [dbo].[GetCustomer] @userId, @roleId, @custOrgId ,@id 
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdDashboard]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               01/10/2018      
-- Description:               Upd a Dashboard
-- Execution:                 EXEC [dbo].[UpdDashboard]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[UpdDashboard]		  
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id BIGINT 
	,@orgId BIGINT = NULL
	,@mainModuleId INT = NULL
	,@dashboardName NVARCHAR(100) = NULL
	,@dashboardDesc NVARCHAR(255) = NULL
	,@isDefault BIT = NULL
	,@statusId INT = NULL
	,@dateChanged DATETIME2(7) = NULL
	,@changedBy NVARCHAR(50) = NULL
	,@isFormView BIT = 0
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  UPDATE [dbo].[SYSTM000Ref_Dashboard]
			SET   [OrganizationId]	 =	 ISNULL(@orgId, OrganizationId)
			,[DshMainModuleId]			 =  ISNULL(@mainModuleId, DshMainModuleId)
			,DshName         =	 ISNULL(@dashboardName, DshName)
			,DshDescription  =	 ISNULL(@dashboardDesc, DshDescription)
			,[DshIsDefault]             =	 ISNULL(@isDefault, DshIsDefault)
			,[StatusId]				 =	 ISNULL(@statusId, StatusId)
			,[DateChanged]           =	 @dateChanged
			,[ChangedBy]             =	 @changedBy		  
     WHERE   [Id] =	@id		 
	EXEC [dbo].[GetDashboard] @userId, @roleId,  @orgId,  'EN', @id  
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdDeliveryStatus]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan   
-- Create date:               06/06/2018      
-- Description:               Upd a DeliveryStatus
-- Execution:                 EXEC [dbo].[UpdDeliveryStatus]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[UpdDeliveryStatus]		  
	(@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id BIGINT 
	,@orgId BIGINT
	,@delStatusCode NVARCHAR(25) = NULL
	,@delStatusTitle NVARCHAR(50) = NULL 
	,@severityId INT = NULL 
	,@itemNumber INT  = NULL
	,@statusId INT  = NULL
	,@dateChanged DATETIME2(7)  = NULL
	,@changedBy NVARCHAR(50)  = NULL
	,@isFormView BIT = 0)
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  DECLARE @updatedItemNumber INT      
  DECLARE @where NVARCHAR(MAX) = null

  DECLARE @isSysAdmin BIT
  SELECT @isSysAdmin = IsSysAdmin FROM SYSTM000OpnSezMe WHERE id=@userId;
  IF @isSysAdmin = 1 
  BEGIN
    EXEC [dbo].[ResetItemNumber] @userId, @id, NULL, @entity, @itemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT   
  END  

   UPDATE   [dbo].[SYSTM000Delivery_Status]
    SET     DeliveryStatusCode 		=  CASE WHEN (@isFormView = 1) THEN @delStatusCode WHEN ((@isFormView = 0) AND (@delStatusCode='#M4PL#')) THEN NULL ELSE ISNULL(@delStatusCode, DeliveryStatusCode) END
           ,DeliveryStatusTitle 		=  CASE WHEN (@isFormView = 1) THEN @delStatusTitle WHEN ((@isFormView = 0) AND (@delStatusTitle='#M4PL#')) THEN NULL ELSE ISNULL(@delStatusTitle, DeliveryStatusTitle) END
           ,SeverityId 		=  CASE WHEN (@isFormView = 1) THEN @severityId WHEN ((@isFormView = 0) AND (@severityId=-100)) THEN NULL ELSE ISNULL(@severityId, SeverityId) END	
           ,ItemNumber 	=  CASE WHEN @isSysAdmin = 1 THEN  
		                                                  CASE WHEN (@isFormView = 1) THEN @updatedItemNumber 
														       WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL 
															   ELSE ISNULL(@updatedItemNumber, ItemNumber) END 
		                            ELSE ItemNumber  END
           ,StatusId 		=  CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
           ,OrganizationId 	=  CASE WHEN (@isFormView = 1) THEN @orgId WHEN ((@isFormView = 0) AND (@orgId=-100)) THEN NULL ELSE ISNULL(@orgId, OrganizationId) END
           ,DateChanged 	=  @dateChanged  
           ,ChangedBy		=  @changedBy 
   WHERE	Id   =  @id
	 EXEC [dbo].[GetDeliveryStatus] @userId , @roleId, @orgId, @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdJob]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */  
-- =============================================          
-- Author:                    Akhil Chauhan           
-- Create date:               08/16/2018        
-- Description:               Upd a Job     
-- Execution:                 EXEC [dbo].[UpdJob]    
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)    
-- Modified Desc:    
-- =============================================       
ALTER PROCEDURE  [dbo].[UpdJob]      
	(@userId BIGINT      
	,@roleId BIGINT  
	,@entity NVARCHAR(100)      
	,@id bigint      
	,@jobMITJobId bigint = NULL      
	,@programId bigint = NULL      
	,@jobSiteCode nvarchar(30) = NULL      
	,@jobConsigneeCode nvarchar(30) = NULL      
	,@jobCustomerSalesOrder nvarchar(30) = NULL   
	,@jobBOL nvarchar(30) = NULL     
	,@jobBOLMaster nvarchar(30) = NULL      
	,@jobBOLChild nvarchar(30) = NULL      
	,@jobCustomerPurchaseOrder nvarchar(30) = NULL      
	,@jobCarrierContract nvarchar(30) = NULL      
	,@jobManifestNo  varchar(30) = NULL  
	,@jobGatewayStatus NVARCHAR(50) = NULL      
	,@statusId int = NULL      
	,@jobStatusedDate datetime2(7) = NULL      
	,@jobCompleted bit = NULL      
	,@jobType nvarchar(20) = NULL    
	,@shipmentType nvarchar(20) = NULL  
	,@jobDeliveryAnalystContactID BIGINT =NULL
	,@jobDeliveryResponsibleContactId bigint = NULL      
	,@jobDeliverySitePOC nvarchar(75) = NULL      
	,@jobDeliverySitePOCPhone nvarchar(50) = NULL      
	,@jobDeliverySitePOCEmail nvarchar(50) = NULL      
	,@jobDeliverySiteName nvarchar(50) = NULL      
	,@jobDeliveryStreetAddress nvarchar(100) = NULL      
	,@jobDeliveryStreetAddress2 nvarchar(100) = NULL      
	,@jobDeliveryCity nvarchar(50) = NULL      
	,@jobDeliveryState nvarchar(50) = NULL      
	,@jobDeliveryPostalCode nvarchar(50) = NULL      
	,@jobDeliveryCountry nvarchar(50) = NULL      
	,@jobDeliveryTimeZone nvarchar(15) = NULL      
	,@jobDeliveryDateTimePlanned datetime2(7) = NULL      
	,@jobDeliveryDateTimeActual datetime2(7) = NULL      
	,@jobDeliveryDateTimeBaseline datetime2(7) = NULL      
	,@jobDeliveryRecipientPhone nvarchar(50) = NULL      
	,@jobDeliveryRecipientEmail nvarchar(50) = NULL      
	,@jobLatitude nvarchar(50) = NULL      
	,@jobLongitude nvarchar(50) = NULL      
	,@jobOriginResponsibleContactId bigint = NULL      
	,@jobOriginSitePOC nvarchar(75) = NULL      
	,@jobOriginSitePOCPhone nvarchar(50) = NULL      
	,@jobOriginSitePOCEmail nvarchar(50) = NULL      
	,@jobOriginSiteName nvarchar(50) = NULL      
	,@jobOriginStreetAddress nvarchar(100) = NULL      
	,@jobOriginStreetAddress2 nvarchar(100) = NULL      
	,@jobOriginCity nvarchar(50) = NULL      
	,@jobOriginState nvarchar(50) = NULL      
	,@jobOriginPostalCode nvarchar(50) = NULL      
	,@jobOriginCountry nvarchar(50) = NULL        
	,@jobOriginTimeZone nvarchar(15) = NULL      
	,@jobOriginDateTimePlanned datetime2(7) = NULL      
	,@jobOriginDateTimeActual datetime2(7) = NULL      
	,@jobOriginDateTimeBaseline datetime2(7) = NULL      
	,@jobProcessingFlags nvarchar(20) = NULL      
	,@jobDeliverySitePOC2 nvarchar(75) = NULL      
	,@jobDeliverySitePOCPhone2 nvarchar(50) = NULL      
	,@jobDeliverySitePOCEmail2 nvarchar(50) = NULL      
	,@jobOriginSitePOC2 nvarchar(75) = NULL      
	,@jobOriginSitePOCPhone2 nvarchar(50) = NULL      
	,@jobOriginSitePOCEmail2 nvarchar(50) = NULL      
	,@jobSellerCode NVARCHAR(20) =NULL      
	,@jobSellerSitePOC NVARCHAR(75) =NULL      
	,@jobSellerSitePOCPhone NVARCHAR(50) =NULL      
	,@jobSellerSitePOCEmail NVARCHAR(50) =NULL      
	,@jobSellerSitePOC2 NVARCHAR(75) =NULL      
	,@jobSellerSitePOCPhone2 NVARCHAR(50) =NULL      
	,@jobSellerSitePOCEmail2 NVARCHAR(50) =NULL      
	,@jobSellerSiteName NVARCHAR(50) =NULL      
	,@jobSellerStreetAddress NVARCHAR(100) =NULL      
	,@jobSellerStreetAddress2 NVARCHAR(100) =NULL      
	,@jobSellerCity NVARCHAR(50) =NULL      
	,@jobSellerState nvarchar(50) = NULL      
	,@jobSellerPostalCode NVARCHAR(50) =NULL      
	,@jobSellerCountry nvarchar(50) = NULL      
	,@jobUser01 NVARCHAR(20) =NULL      
	,@jobUser02 NVARCHAR(20) =NULL      
	,@jobUser03 NVARCHAR(20) =NULL      
	,@jobUser04 NVARCHAR(20) =NULL      
	,@jobUser05 NVARCHAR(20) =NULL      
	,@jobStatusFlags NVARCHAR(20) =NULL      
	,@jobScannerFlags NVARCHAR(20) =NULL 
	,@plantIDCode NVARCHAR(30) =NULL
	,@carrierID NVARCHAR(30) =NULL
	,@jobDriverId BIGINT =NULL
	,@windowDelStartTime DATETIME2(7) =NULL
	,@windowDelEndTime DATETIME2(7) =NULL
	,@windowPckStartTime DATETIME2(7) =NULL
	,@windowPckEndTime DATETIME2(7) =NULL
	,@jobRouteId INT =NULL
	,@jobStop NVARCHAR(20) =NULL
	,@jobSignText NVARCHAR(75) =NULL
	,@jobSignLatitude NVARCHAR(50) =NULL
	,@jobSignLongitude NVARCHAR(50) =NULL     
	,@changedBy nvarchar(50) = NULL      
	,@dateChanged datetime2(7) = NULL    
	,@isFormView BIT = 0 )       
AS      
BEGIN TRY                      
 SET NOCOUNT ON;         
 UPDATE [dbo].[JOBDL000Master]      
  SET  [JobMITJobID]                    =  CASE WHEN (@isFormView = 1) THEN @jobMITJobID WHEN ((@isFormView = 0) AND (@jobMITJobID=-100)) THEN NULL ELSE ISNULL(@jobMITJobID, JobMITJobID) END      
   ,[ProgramID]                         =  CASE WHEN (@isFormView = 1) THEN @programID WHEN ((@isFormView = 0) AND (@programID=-100)) THEN NULL ELSE ISNULL(@programID, ProgramID)   END    
   ,[JobSiteCode]                       =  CASE WHEN (@isFormView = 1) THEN @jobSiteCode WHEN ((@isFormView = 0) AND (@jobSiteCode='#M4PL#')) THEN NULL ELSE ISNULL(@jobSiteCode, JobSiteCode)   END    
   ,[JobConsigneeCode]                  =  CASE WHEN (@isFormView = 1) THEN @jobConsigneeCode WHEN ((@isFormView = 0) AND (@jobConsigneeCode='#M4PL#')) THEN NULL ELSE ISNULL(@jobConsigneeCode, JobConsigneeCode)   END    
   ,[JobCustomerSalesOrder]             =  CASE WHEN (@isFormView = 1) THEN @jobCustomerSalesOrder WHEN ((@isFormView = 0) AND (@jobCustomerSalesOrder='#M4PL#')) THEN NULL ELSE ISNULL(@jobCustomerSalesOrder, JobCustomerSalesOrder) END      
   ,[JobBOL]	                        =  CASE WHEN (@isFormView = 1) THEN @jobBOL WHEN ((@isFormView = 0) AND (@jobBOL='#M4PL#')) THEN NULL ELSE ISNULL(@jobBOL, JobBOL)   END    
   ,[JobBOLMaster]                      =  CASE WHEN (@isFormView = 1) THEN @jobBOLMaster WHEN ((@isFormView = 0) AND (@jobBOLMaster='#M4PL#')) THEN NULL ELSE ISNULL(@jobBOLMaster, JobBOLMaster)   END    
   ,[JobBOLChild]                       =  CASE WHEN (@isFormView = 1) THEN @jobBOLChild WHEN ((@isFormView = 0) AND (@jobBOLChild='#M4PL#')) THEN NULL ELSE ISNULL(@jobBOLChild, JobBOLChild)   END    
   ,[JobCustomerPurchaseOrder]          =  CASE WHEN (@isFormView = 1) THEN @jobCustomerPurchaseOrder WHEN ((@isFormView = 0) AND (@jobCustomerPurchaseOrder='#M4PL#')) THEN NULL ELSE ISNULL(@jobCustomerPurchaseOrder, JobCustomerPurchaseOrder)   END    
   ,[JobCarrierContract]                =  CASE WHEN (@isFormView = 1) THEN @jobCarrierContract WHEN ((@isFormView = 0) AND (@jobCarrierContract='#M4PL#')) THEN NULL ELSE ISNULL(@jobCarrierContract, JobCarrierContract)   END    
   ,[JobManifestNo]                     =  CASE WHEN (@isFormView = 1) THEN @jobManifestNo WHEN ((@isFormView = 0) AND (@jobManifestNo='#M4PL#')) THEN NULL ELSE ISNULL(@jobManifestNo, JobManifestNo)   END   
   
   ,[JobGatewayStatus]                  =  CASE WHEN (@isFormView = 1) THEN @jobGatewayStatus WHEN ((@isFormView = 0) AND (@jobGatewayStatus='#M4PL#')) THEN NULL ELSE ISNULL(@jobGatewayStatus, JobGatewayStatus)   END     
  
   
   ,[StatusId]                          =  CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId)   END    
   ,[JobStatusedDate]                   =  CASE WHEN (@isFormView = 1) THEN @jobStatusedDate WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @jobStatusedDate, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@jobStatusedDate, JobStatusedDate)   END    
   ,[JobCompleted]                      =  ISNULL(@jobCompleted, JobCompleted)     
   ,[JobType]                           =  CASE WHEN (@isFormView = 1) THEN @jobType WHEN ((@isFormView = 0) AND (@jobType='#M4PL#')) THEN NULL ELSE ISNULL(@jobType, JobType)   END    
   ,[ShipmentType]                      =  CASE WHEN (@isFormView = 1) THEN @shipmentType WHEN ((@isFormView = 0) AND (@shipmentType='#M4PL#')) THEN NULL ELSE ISNULL(@shipmentType, ShipmentType)   END    
     
   ,[JobDeliveryAnalystContactID]       =  CASE WHEN (@isFormView = 1) THEN @jobDeliveryAnalystContactID WHEN ((@isFormView = 0) AND (@jobDeliveryAnalystContactID=-100)) THEN NULL ELSE ISNULL(@jobDeliveryAnalystContactID, JobDeliveryAnalystContactID)   END    
   ,[JobDeliveryResponsibleContactID]   =  CASE WHEN (@isFormView = 1) THEN @jobDeliveryResponsibleContactID WHEN ((@isFormView = 0) AND (@jobDeliveryResponsibleContactID=-100)) THEN NULL ELSE ISNULL(@jobDeliveryResponsibleContactID, JobDeliveryResponsibleContactID)   END    
   ,[JobDeliverySitePOC]                =  CASE WHEN (@isFormView = 1) THEN @jobDeliverySitePOC WHEN ((@isFormView = 0) AND (@jobDeliverySitePOC='#M4PL#')) THEN NULL ELSE ISNULL(@jobDeliverySitePOC, JobDeliverySitePOC)   END    
   ,[JobDeliverySitePOCPhone]           =  CASE WHEN (@isFormView = 1) THEN @jobDeliverySitePOCPhone WHEN ((@isFormView = 0) AND (@jobDeliverySitePOCPhone='#M4PL#')) THEN NULL ELSE ISNULL(@jobDeliverySitePOCPhone, JobDeliverySitePOCPhone)   END    
   ,[JobDeliverySitePOCEmail]           =  CASE WHEN (@isFormView = 1) THEN @jobDeliverySitePOCEmail WHEN ((@isFormView = 0) AND (@jobDeliverySitePOCEmail='#M4PL#')) THEN NULL ELSE ISNULL(@jobDeliverySitePOCEmail, JobDeliverySitePOCEmail)   END    
   ,[JobDeliverySiteName]               =  CASE WHEN (@isFormView = 1) THEN @jobDeliverySiteName WHEN ((@isFormView = 0) AND (@jobDeliverySiteName='#M4PL#')) THEN NULL ELSE ISNULL(@jobDeliverySiteName, JobDeliverySiteName)   END    
   ,[JobDeliveryStreetAddress]          =  CASE WHEN (@isFormView = 1) THEN @jobDeliveryStreetAddress WHEN ((@isFormView = 0) AND (@jobDeliveryStreetAddress='#M4PL#')) THEN NULL ELSE ISNULL(@jobDeliveryStreetAddress, JobDeliveryStreetAddress) END      
   ,[JobDeliveryStreetAddress2]         =  CASE WHEN (@isFormView = 1) THEN @jobDeliveryStreetAddress2 WHEN ((@isFormView = 0) AND (@jobDeliveryStreetAddress2='#M4PL#')) THEN NULL ELSE ISNULL(@jobDeliveryStreetAddress2, JobDeliveryStreetAddress2)   END   
 
   ,[JobDeliveryCity]                   =  CASE WHEN (@isFormView = 1) THEN @jobDeliveryCity WHEN ((@isFormView = 0) AND (@jobDeliveryCity='#M4PL#')) THEN NULL ELSE ISNULL(@jobDeliveryCity, JobDeliveryCity)   END    
   ,[JobDeliveryState]                  =  CASE WHEN (@isFormView = 1) THEN @jobDeliveryState WHEN ((@isFormView = 0) AND (@jobDeliveryState='#M4PL#')) THEN NULL ELSE ISNULL(@jobDeliveryState, JobDeliveryState) END      
   ,[JobDeliveryPostalCode]             =  CASE WHEN (@isFormView = 1) THEN @jobDeliveryPostalCode WHEN ((@isFormView = 0) AND (@jobDeliveryPostalCode='#M4PL#')) THEN NULL ELSE ISNULL(@jobDeliveryPostalCode, JobDeliveryPostalCode) END      
   ,[JobDeliveryCountry]              =  CASE WHEN (@isFormView = 1) THEN @jobDeliveryCountry WHEN ((@isFormView = 0) AND (@jobDeliveryCountry='#M4PL#')) THEN NULL ELSE ISNULL(@jobDeliveryCountry, JobDeliveryCountry)   END    
   ,[JobDeliveryTimeZone]               =  CASE WHEN (@isFormView = 1) THEN @jobDeliveryTimeZone WHEN ((@isFormView = 0) AND (@jobDeliveryTimeZone='#M4PL#')) THEN NULL ELSE ISNULL(@jobDeliveryTimeZone, JobDeliveryTimeZone)   END    
   ,[JobDeliveryDateTimePlanned]        =  CASE WHEN (@isFormView = 1) THEN @jobDeliveryDateTimePlanned WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @jobDeliveryDateTimePlanned, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@jobDeliveryDateTimePlanned, JobDeliveryDateTimePlanned)   END    
       
   ,[JobDeliveryDateTimeActual]         =  CASE WHEN (@isFormView = 1) THEN CASE WHEN ISNULL(@jobCompleted, 0) = 1 AND  @jobDeliveryDateTimeActual IS NULL THEN GETUTCDATE() ELSE @jobDeliveryDateTimeActual END     
            WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @jobDeliveryDateTimeActual, 103)='01/01/1753')) THEN NULL     
            ELSE ISNULL(@jobDeliveryDateTimeActual, JobDeliveryDateTimeActual)       
             END    
       
       
   ,[JobDeliveryDateTimeBaseline]       =  CASE WHEN (@isFormView = 1) THEN @jobDeliveryDateTimeBaseline WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @jobDeliveryDateTimeBaseline, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@jobDeliveryDateTimeBaseline, JobDeliveryDateTimeBaseline)   END    
   ,[JobDeliveryRecipientPhone]         =  CASE WHEN (@isFormView = 1) THEN @jobDeliveryRecipientPhone WHEN ((@isFormView = 0) AND (@jobDeliveryRecipientPhone='#M4PL#')) THEN NULL ELSE ISNULL(@jobDeliveryRecipientPhone, JobDeliveryRecipientPhone)   END   
 
   ,[JobDeliveryRecipientEmail]         =  CASE WHEN (@isFormView = 1) THEN @jobDeliveryRecipientEmail WHEN ((@isFormView = 0) AND (@jobDeliveryRecipientEmail='#M4PL#')) THEN NULL ELSE ISNULL(@jobDeliveryRecipientEmail, JobDeliveryRecipientEmail)   END   
 
   ,[JobLatitude]                       =  CASE WHEN (@isFormView = 1) THEN @jobLatitude WHEN ((@isFormView = 0) AND (@jobLatitude='#M4PL#')) THEN NULL ELSE ISNULL(@jobLatitude, JobLatitude)   END    
   ,[JobLongitude]                      =  CASE WHEN (@isFormView = 1) THEN @jobLongitude WHEN ((@isFormView = 0) AND (@jobLongitude='#M4PL#')) THEN NULL ELSE ISNULL(@jobLongitude, JobLongitude)   END    
   ,[JobOriginResponsibleContactID]     =  CASE WHEN (@isFormView = 1) THEN @jobOriginResponsibleContactID WHEN ((@isFormView = 0) AND (@jobOriginResponsibleContactID=-100)) THEN NULL ELSE ISNULL(@jobOriginResponsibleContactID, JobOriginResponsibleContactID)   END    
   ,[JobOriginSitePOC]                  =  CASE WHEN (@isFormView = 1) THEN @jobOriginSitePOC WHEN ((@isFormView = 0) AND (@jobOriginSitePOC='#M4PL#')) THEN NULL ELSE ISNULL(@jobOriginSitePOC, JobOriginSitePOC)   END    
   ,[JobOriginSitePOCPhone]             =  CASE WHEN (@isFormView = 1) THEN @jobOriginSitePOCPhone WHEN ((@isFormView = 0) AND (@jobOriginSitePOCPhone='#M4PL#')) THEN NULL ELSE ISNULL(@jobOriginSitePOCPhone, JobOriginSitePOCPhone) END      
   ,[JobOriginSitePOCEmail]             =  CASE WHEN (@isFormView = 1) THEN @jobOriginSitePOCEmail WHEN ((@isFormView = 0) AND (@jobOriginSitePOCEmail='#M4PL#')) THEN NULL ELSE ISNULL(@jobOriginSitePOCEmail, JobOriginSitePOCEmail)   END    
   ,[JobOriginSiteName]                 =  CASE WHEN (@isFormView = 1) THEN @jobOriginSiteName WHEN ((@isFormView = 0) AND (@jobOriginSiteName='#M4PL#')) THEN NULL ELSE ISNULL(@jobOriginSiteName, JobOriginSiteName)   END    
   ,[JobOriginStreetAddress]            =  CASE WHEN (@isFormView = 1) THEN @jobOriginStreetAddress WHEN ((@isFormView = 0) AND (@jobOriginStreetAddress='#M4PL#')) THEN NULL ELSE ISNULL(@jobOriginStreetAddress, JobOriginStreetAddress) END      
   ,[JobOriginStreetAddress2]           =  CASE WHEN (@isFormView = 1) THEN @jobOriginStreetAddress2 WHEN ((@isFormView = 0) AND (@jobOriginStreetAddress2='#M4PL#')) THEN NULL ELSE ISNULL(@jobOriginStreetAddress2, JobOriginStreetAddress2)   END    
   ,[JobOriginCity]                     =  CASE WHEN (@isFormView = 1) THEN @jobOriginCity WHEN ((@isFormView = 0) AND (@jobOriginCity='#M4PL#')) THEN NULL ELSE ISNULL(@jobOriginCity, JobOriginCity)   END    
   ,[JobOriginState]     =  CASE WHEN (@isFormView = 1) THEN @jobOriginState WHEN ((@isFormView = 0) AND (@jobOriginState='#M4PL#')) THEN NULL ELSE ISNULL(@jobOriginState, JobOriginState) END      
   ,[JobOriginPostalCode]               =  CASE WHEN (@isFormView = 1) THEN @jobOriginPostalCode WHEN ((@isFormView = 0) AND (@jobOriginPostalCode='#M4PL#')) THEN NULL ELSE ISNULL(@jobOriginPostalCode, JobOriginPostalCode) END      
   ,[JobOriginCountry]                =  CASE WHEN (@isFormView = 1) THEN @jobOriginCountry WHEN ((@isFormView = 0) AND (@jobOriginCountry='#M4PL#')) THEN NULL ELSE ISNULL(@jobOriginCountry, JobOriginCountry)   END    
   ,[JobOriginTimeZone]                 =  CASE WHEN (@isFormView = 1) THEN @jobOriginTimeZone WHEN ((@isFormView = 0) AND (@jobOriginTimeZone='#M4PL#')) THEN NULL ELSE ISNULL(@jobOriginTimeZone, JobOriginTimeZone)   END    
   ,[JobOriginDateTimePlanned]          =  CASE WHEN (@isFormView = 1) THEN @jobOriginDateTimePlanned WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @jobOriginDateTimePlanned, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@jobOriginDateTimePlanned, JobOriginDateTimePlanned)   END    
       
   ,[JobOriginDateTimeActual]           =  CASE WHEN (@isFormView = 1) THEN CASE WHEN ISNULL(@jobCompleted, 0) = 1 AND  @jobOriginDateTimeActual IS NULL THEN GETUTCDATE() ELSE @jobOriginDateTimeActual END      
                                                WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @jobOriginDateTimeActual, 103)='01/01/1753')) THEN NULL     
            ELSE ISNULL(@jobOriginDateTimeActual, JobOriginDateTimeActual)   END    
       
       
   ,[JobOriginDateTimeBaseline]         =  CASE WHEN (@isFormView = 1) THEN @jobOriginDateTimeBaseline WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @jobOriginDateTimeBaseline, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@jobOriginDateTimeBaseline, JobOriginDateTimeBaseline)   END    
   ,[JobProcessingFlags]                =  CASE WHEN (@isFormView = 1) THEN @jobProcessingFlags WHEN ((@isFormView = 0) AND (@jobProcessingFlags='#M4PL#')) THEN NULL ELSE ISNULL(@jobProcessingFlags, JobProcessingFlags)   END    
   ,[JobDeliverySitePOC2]               =  CASE WHEN (@isFormView = 1) THEN @jobDeliverySitePOC2 WHEN ((@isFormView = 0) AND (@jobDeliverySitePOC2='#M4PL#')) THEN NULL ELSE ISNULL(@jobDeliverySitePOC2, JobDeliverySitePOC2)   END    
   ,[JobDeliverySitePOCPhone2]          =  CASE WHEN (@isFormView = 1) THEN @jobDeliverySitePOCPhone2 WHEN ((@isFormView = 0) AND (@jobDeliverySitePOCPhone2='#M4PL#')) THEN NULL ELSE ISNULL(@jobDeliverySitePOCPhone2, JobDeliverySitePOCPhone2) END      
   ,[JobDeliverySitePOCEmail2]          =  CASE WHEN (@isFormView = 1) THEN @jobDeliverySitePOCEmail2 WHEN ((@isFormView = 0) AND (@jobDeliverySitePOCEmail2='#M4PL#')) THEN NULL ELSE ISNULL(@jobDeliverySitePOCEmail2, JobDeliverySitePOCEmail2)   END    
   ,[JobOriginSitePOC2]                 =  CASE WHEN (@isFormView = 1) THEN @jobOriginSitePOC2 WHEN ((@isFormView = 0) AND (@jobOriginSitePOC2='#M4PL#')) THEN NULL ELSE ISNULL(@jobOriginSitePOC2, JobOriginSitePOC2)   END    
   ,[JobOriginSitePOCPhone2]            =  CASE WHEN (@isFormView = 1) THEN @jobOriginSitePOCPhone2 WHEN ((@isFormView = 0) AND (@jobOriginSitePOCPhone2='#M4PL#')) THEN NULL ELSE ISNULL(@jobOriginSitePOCPhone2, JobOriginSitePOCPhone2) END      
   ,[JobOriginSitePOCEmail2]            =  CASE WHEN (@isFormView = 1) THEN @jobOriginSitePOCEmail2 WHEN ((@isFormView = 0) AND (@jobOriginSitePOCEmail2='#M4PL#')) THEN NULL ELSE ISNULL(@jobOriginSitePOCEmail2, JobOriginSitePOCEmail2)   END    
   ,[JobSellerCode]                     =  CASE WHEN (@isFormView = 1) THEN @jobSellerCode WHEN ((@isFormView = 0) AND (@jobSellerCode='#M4PL#')) THEN NULL ELSE ISNULL(@jobSellerCode, JobSellerCode)   END    
   ,[JobSellerSitePOC]     =  CASE WHEN (@isFormView = 1) THEN @jobSellerSitePOC WHEN ((@isFormView = 0) AND (@jobSellerSitePOC='#M4PL#')) THEN NULL ELSE ISNULL(@jobSellerSitePOC, JobSellerSitePOC) END      
   ,[JobSellerSitePOCPhone]    =  CASE WHEN (@isFormView = 1) THEN @jobSellerSitePOCPhone WHEN ((@isFormView = 0) AND (@jobSellerSitePOCPhone='#M4PL#')) THEN NULL ELSE ISNULL(@jobSellerSitePOCPhone, JobSellerSitePOCPhone) END      
   ,[JobSellerSitePOCEmail]    =  CASE WHEN (@isFormView = 1) THEN @jobSellerSitePOCEmail WHEN ((@isFormView = 0) AND (@jobSellerSitePOCEmail='#M4PL#')) THEN NULL ELSE ISNULL(@jobSellerSitePOCEmail, JobSellerSitePOCEmail)   END    
   ,[JobSellerSitePOC2]     =  CASE WHEN (@isFormView = 1) THEN @jobSellerSitePOC2 WHEN ((@isFormView = 0) AND (@jobSellerSitePOC2='#M4PL#')) THEN NULL ELSE ISNULL(@jobSellerSitePOC2,JobSellerSitePOC2)   END    
   ,[JobSellerSitePOCPhone2]   =  CASE WHEN (@isFormView = 1) THEN @jobSellerSitePOCPhone2 WHEN ((@isFormView = 0) AND (@jobSellerSitePOCPhone2='#M4PL#')) THEN NULL ELSE ISNULL(@jobSellerSitePOCPhone2, JobSellerSitePOCPhone2) END      
   ,[JobSellerSitePOCEmail2]   =  CASE WHEN (@isFormView = 1) THEN @jobSellerSitePOCEmail2 WHEN ((@isFormView = 0) AND (@jobSellerSitePOCEmail2='#M4PL#')) THEN NULL ELSE ISNULL(@jobSellerSitePOCEmail2, JobSellerSitePOCEmail2)   END    
   ,[JobSellerSiteName]     =  CASE WHEN (@isFormView = 1) THEN @jobSellerSiteName WHEN ((@isFormView = 0) AND (@jobSellerSiteName='#M4PL#')) THEN NULL ELSE ISNULL(@jobSellerSiteName, JobSellerSiteName)   END    
   ,[JobSellerStreetAddress]   =  CASE WHEN (@isFormView = 1) THEN @jobSellerStreetAddress WHEN ((@isFormView = 0) AND (@jobSellerStreetAddress='#M4PL#')) THEN NULL ELSE ISNULL(@jobSellerStreetAddress, JobSellerStreetAddress) END      
   ,[JobSellerStreetAddress2]   =  CASE WHEN (@isFormView = 1) THEN @jobSellerStreetAddress2 WHEN ((@isFormView = 0) AND (@jobSellerStreetAddress2='#M4PL#')) THEN NULL ELSE ISNULL(@jobSellerStreetAddress2, JobSellerStreetAddress2)   END    
   ,[JobSellerCity]      =  CASE WHEN (@isFormView = 1) THEN @jobSellerCity WHEN ((@isFormView = 0) AND (@jobSellerCity='#M4PL#')) THEN NULL ELSE ISNULL(@jobSellerCity, JobSellerCity)   END    
   ,[JobSellerState]     =  CASE WHEN (@isFormView = 1) THEN @jobSellerState WHEN ((@isFormView = 0) AND (@jobSellerState='#M4PL#')) THEN NULL ELSE ISNULL(@jobSellerState, JobSellerState) END      
   ,[JobSellerPostalCode]    =  CASE WHEN (@isFormView = 1) THEN @jobSellerPostalCode WHEN ((@isFormView = 0) AND (@jobSellerPostalCode='#M4PL#')) THEN NULL ELSE ISNULL(@jobSellerPostalCode, JobSellerPostalCode) END      
   ,[JobSellerCountry]    =  CASE WHEN (@isFormView = 1) THEN @jobSellerCountry WHEN ((@isFormView = 0) AND (@jobSellerCountry='#M4PL#')) THEN NULL ELSE ISNULL(@jobSellerCountry, JobSellerCountry)   END    
   ,[JobUser01]       =  CASE WHEN (@isFormView = 1) THEN @jobUser01 WHEN ((@isFormView = 0) AND (@jobUser01='#M4PL#')) THEN NULL ELSE ISNULL(@jobUser01, JobUser01)   END    
   ,[JobUser02]       =  CASE WHEN (@isFormView = 1) THEN @jobUser02 WHEN ((@isFormView = 0) AND (@jobUser02='#M4PL#')) THEN NULL ELSE ISNULL(@jobUser02, JobUser02)   END    
   ,[JobUser03]       =  CASE WHEN (@isFormView = 1) THEN @jobUser03 WHEN ((@isFormView = 0) AND (@jobUser03='#M4PL#')) THEN NULL ELSE ISNULL(@jobUser03, JobUser03)   END    
   ,[JobUser04]       =  CASE WHEN (@isFormView = 1) THEN @jobUser04 WHEN ((@isFormView = 0) AND (@jobUser04='#M4PL#')) THEN NULL ELSE ISNULL(@jobUser04, JobUser04)   END    
   ,[JobUser05]       =  CASE WHEN (@isFormView = 1) THEN @jobUser05 WHEN ((@isFormView = 0) AND (@jobUser05='#M4PL#')) THEN NULL ELSE ISNULL(@jobUser05, JobUser05)   END    
   ,[JobStatusFlags]     =  ISNULL(@jobStatusFlags, JobStatusFlags)      
   ,[JobScannerFlags]     =  ISNULL(@jobScannerFlags, JobScannerFlags)  
   ,[PlantIDCode]     =  CASE WHEN (@isFormView = 1) THEN @plantIDCode WHEN ((@isFormView = 0) AND (@plantIDCode='#M4PL#')) THEN NULL ELSE ISNULL(@plantIDCode, PlantIDCode)   END    
   ,[CarrierID]       =  CASE WHEN (@isFormView = 1) THEN @carrierID WHEN ((@isFormView = 0) AND (@carrierID='#M4PL#')) THEN NULL ELSE ISNULL(@carrierID, CarrierID)   END    
   ,[JobDriverId]          =  CASE WHEN (@isFormView = 1) THEN @jobDriverId WHEN ((@isFormView = 0) AND (@jobDriverId=-100)) THEN NULL ELSE ISNULL(@jobDriverId, JobDriverId)   END 
   ,[WindowDelStartTime]          =  CASE WHEN (@isFormView = 1) THEN @windowDelStartTime WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @windowDelStartTime, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@windowDelStartTime, WindowDelStartTime)   END 
   ,[WindowDelEndTime]          =  CASE WHEN (@isFormView = 1) THEN @windowDelEndTime WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @windowDelEndTime, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@windowDelEndTime, WindowDelEndTime)   END 
   ,[WindowPckStartTime]           =  CASE WHEN (@isFormView = 1) THEN @windowPckStartTime WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @windowPckStartTime, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@windowPckStartTime, WindowPckStartTime)   END 
   ,[WindowPckEndTime]          =  CASE WHEN (@isFormView = 1) THEN @windowPckEndTime WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @windowPckEndTime, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@windowPckEndTime, WindowPckEndTime)   END 
   ,[JobRouteId]          =  CASE WHEN (@isFormView = 1) THEN @jobRouteId WHEN ((@isFormView = 0) AND (@jobRouteId=-100)) THEN NULL ELSE ISNULL(@jobRouteId, JobRouteId)   END 
   ,[JobStop]           =  CASE WHEN (@isFormView = 1) THEN @jobStop WHEN ((@isFormView = 0) AND (@jobStop='#M4PL#')) THEN NULL ELSE ISNULL(@jobStop, JobStop)   END 
   ,[JobSignText]          =  CASE WHEN (@isFormView = 1) THEN @jobSignText WHEN ((@isFormView = 0) AND (@jobSignText='#M4PL#')) THEN NULL ELSE ISNULL(@jobSignText, JobSignText)   END 
   ,[JobSignLatitude]         =  CASE WHEN (@isFormView = 1) THEN @jobSignLatitude WHEN ((@isFormView = 0) AND (@jobSignLatitude='#M4PL#')) THEN NULL ELSE ISNULL(@jobSignLatitude, JobSignLatitude)   END 
   ,[JobSignLongitude]     =  CASE WHEN (@isFormView = 1) THEN @jobSignLongitude WHEN ((@isFormView = 0) AND (@jobSignLongitude='#M4PL#')) THEN NULL ELSE ISNULL(@jobSignLongitude, JobSIgnLongitude)   END 
   ,[ChangedBy]                         =  @changedBy      
   ,[DateChanged]                       =  @dateChanged      
  WHERE   [Id] = @id  ;    
    
    
  --Update Job Gateways    
    
  UPDATE [dbo].[JOBDL020Gateways] Set StatusId  = 195,[GwyCompleted] =1 WHERE JobID = @id And StatusId <> 196;    
   
    EXEC [dbo].[GetJob] @userId,@roleId,0,@id,@programId    ;
     
END TRY                      
BEGIN CATCH                      
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                      
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                      
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                   
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                      
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdJobAttribute]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Upd a Job Attribute
-- Execution:                 EXEC [dbo].[UpdJobAttribute]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[UpdJobAttribute]
(@userId BIGINT
,@roleId BIGINT  
,@entity NVARCHAR(100)
,@id bigint
,@jobId bigint = NULL
,@ajbLineOrder int = NULL
,@ajbAttributeCode nvarchar(20) = NULL
,@ajbAttributeTitle nvarchar(50) = NULL
,@ajbAttributeQty decimal(18, 2) = NULL
,@ajbUnitTypeId int = NULL
,@ajbDefault bit = NULL
,@statusId int = NULL
,@dateChanged datetime2(7) = NULL
,@changedBy nvarchar(50) = NULL
,@isFormView BIT = 0) 
AS
BEGIN TRY                
 SET NOCOUNT ON; 
 DECLARE @updatedItemNumber INT      
   EXEC [dbo].[ResetItemNumber] @userId, @id, @jobId, @entity, @ajbLineOrder, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT 
   
 UPDATE [dbo].[JOBDL030Attributes]
		SET  [JobID]                     = CASE WHEN (@isFormView = 1) THEN @jobId WHEN ((@isFormView = 0) AND (@jobId=-100)) THEN NULL ELSE ISNULL(@jobId, JobID) END
			,[AjbLineOrder]              = CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, AjbLineOrder) END
			,[AjbAttributeCode]          = CASE WHEN (@isFormView = 1) THEN @ajbAttributeCode WHEN ((@isFormView = 0) AND (@ajbAttributeCode='#M4PL#')) THEN NULL ELSE ISNULL(@ajbAttributeCode, AjbAttributeCode) END
			,[AjbAttributeTitle]         = CASE WHEN (@isFormView = 1) THEN @ajbAttributeTitle WHEN ((@isFormView = 0) AND (@ajbAttributeTitle='#M4PL#')) THEN NULL ELSE ISNULL(@ajbAttributeTitle, AjbAttributeTitle) END
			,[AjbAttributeQty]           = CASE WHEN (@isFormView = 1) THEN @ajbAttributeQty WHEN ((@isFormView = 0) AND (@ajbAttributeQty=-100.00)) THEN NULL ELSE ISNULL(@ajbAttributeQty, AjbAttributeQty) END
			,[AjbUnitTypeId]			 = CASE WHEN (@isFormView = 1) THEN @ajbUnitTypeId WHEN ((@isFormView = 0) AND (@ajbUnitTypeId=-100)) THEN NULL ELSE ISNULL(@ajbUnitTypeId, AjbUnitTypeId) END
			,[AjbDefault]                = ISNULL(@ajbDefault, AjbDefault)
			,[StatusId]		             = CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
			,[DateChanged]               = @dateChanged
			,[ChangedBy]                 = @changedBy
	 WHERE   [Id] = @id
	SELECT job.[Id]
		,job.[JobID]
		,job.[AjbLineOrder]
		,job.[AjbAttributeCode]
		,job.[AjbAttributeTitle]
		,job.[AjbAttributeQty]
		,job.[AjbUnitTypeId]
		,job.[AjbDefault]
		,job.[StatusId]
		,job.[DateEntered]
		,job.[EnteredBy]
		,job.[DateChanged]
		,job.[ChangedBy]
  FROM   [dbo].[JOBDL030Attributes] job
 WHERE   [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdJobCargo]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Upd a Job Cargo
-- Execution:                 EXEC [dbo].[UpdJobCargo]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[UpdJobCargo]
	(@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id bigint
	,@jobId bigint  = NULL
	,@cgoLineItem int= NULL
	,@cgoPartNumCode nvarchar(30)= NULL
	,@cgoTitle nvarchar(50)= NULL
	,@cgoSerialNumber nvarchar(255)= NULL
	,@cgoPackagingType nvarchar(20)= NULL
	,@cgoMasterCartonLabel nvarchar(30) = NULL
	,@cgoWeight decimal(18, 2)  = NULL
	,@cgoWeightUnits NVARCHAR(20)= NULL  
	,@cgoLength decimal(18, 2)  = NULL
	,@cgoWidth decimal(18, 2)  = NULL
	,@cgoHeight decimal(18, 2)  = NULL
	,@cgoVolumeUnits NVARCHAR(20)= NULL
	,@cgoCubes decimal(18, 2)  = NULL
	,@cgoQtyExpected decimal(18, 2)= NULL
	,@cgoQtyOnHand decimal(18, 2)= NULL
	,@cgoQtyDamaged decimal(18, 2)= NULL
	,@cgoQtyOnHold decimal(18, 2)= NULL
	,@cgoQtyShortOver decimal(18, 2) = NULL
	,@cgoQtyUnits nvarchar(20)= NULL
	,@cgoReasonCodeOSD nvarchar(20) = NULL 
	,@cgoReasonCodeHold nvarchar(20)  = NULL
	,@cgoSeverityCode int= NULL
	,@cgoLatitude NVARCHAR(50) = NULL
	,@cgoLongitude NVARCHAR(50) = NULL
	,@statusId int = NULL
	,@cgoProcessingFlags nvarchar(20)= NULL
	,@changedBy nvarchar(50) = NULL
	,@dateChanged datetime2(7) = NULL
	,@isFormView BIT = 0) 
AS
BEGIN TRY                
 SET NOCOUNT ON;
 
  DECLARE @updatedItemNumber INT      
   EXEC [dbo].[ResetItemNumber] @userId, @id, @jobId, @entity, @cgoLineItem, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT  
  
 UPDATE [dbo].[JOBDL010Cargo]
		SET  [JobID]                 = CASE WHEN (@isFormView = 1) THEN @jobId WHEN ((@isFormView = 0) AND (@jobId=-100)) THEN NULL ELSE ISNULL(@jobId, JobID) END
			,[CgoLineItem]           = CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, CgoLineItem) END
			,[CgoPartNumCode]        = CASE WHEN (@isFormView = 1) THEN @cgoPartNumCode WHEN ((@isFormView = 0) AND (@cgoPartNumCode='#M4PL#')) THEN NULL ELSE ISNULL(@cgoPartNumCode, CgoPartNumCode) END
			,[CgoTitle]              = CASE WHEN (@isFormView = 1) THEN @cgoTitle WHEN ((@isFormView = 0) AND (@cgoTitle='#M4PL#')) THEN NULL ELSE ISNULL(@cgoTitle, CgoTitle) END
			,[CgoSerialNumber]       = CASE WHEN (@isFormView = 1) THEN @cgoSerialNumber WHEN ((@isFormView = 0) AND (@cgoSerialNumber='#M4PL#')) THEN NULL ELSE ISNULL(@cgoSerialNumber, CgoSerialNumber) END
			,[CgoPackagingType]      = CASE WHEN (@isFormView = 1) THEN @cgoPackagingType WHEN ((@isFormView = 0) AND (@cgoPackagingType='#M4PL#')) THEN NULL ELSE ISNULL(@cgoPackagingType,CgoPackagingType) END
			,[CgoMasterCartonLabel]  = CASE WHEN (@isFormView = 1) THEN @cgoMasterCartonLabel WHEN ((@isFormView = 0) AND (@cgoMasterCartonLabel='#M4PL#')) THEN NULL ELSE ISNULL(@cgoMasterCartonLabel, CgoMasterCartonLabel) END
			,[CgoWeight]             = CASE WHEN (@isFormView = 1) THEN @cgoWeight WHEN ((@isFormView = 0) AND (@cgoWeight=-100.00)) THEN NULL ELSE ISNULL(@cgoWeight,CgoWeight) END  
            ,[CgoWeightUnits]        = CASE WHEN (@isFormView = 1) THEN @cgoWeightUnits WHEN ((@isFormView = 0) AND (@cgoWeightUnits='#M4PL#')) THEN NULL ELSE ISNULL(@cgoWeightUnits,CgoWeightUnits) END  
            ,[CgoLength]             = CASE WHEN (@isFormView = 1) THEN @cgoLength WHEN ((@isFormView = 0) AND (@cgoLength=-100.00)) THEN NULL ELSE ISNULL(@cgoLength,CgoLength) END  
            ,[CgoWidth]              = CASE WHEN (@isFormView = 1) THEN @cgoWidth WHEN ((@isFormView = 0) AND (@cgoWidth=-100.00)) THEN NULL ELSE ISNULL(@cgoWidth,CgoWidth) END  
            ,[CgoHeight]             = CASE WHEN (@isFormView = 1) THEN @cgoHeight WHEN ((@isFormView = 0) AND (@cgoHeight=-100.00)) THEN NULL ELSE ISNULL(@cgoHeight,CgoHeight) END  
            ,[CgoVolumeUnits]        = CASE WHEN (@isFormView = 1) THEN @cgoVolumeUnits WHEN ((@isFormView = 0) AND (@cgoVolumeUnits='#M4PL#')) THEN NULL ELSE ISNULL(@cgoVolumeUnits,CgoVolumeUnits) END  
            ,[CgoCubes]              = CASE WHEN (@isFormView = 1) THEN @cgoCubes WHEN ((@isFormView = 0) AND (@cgoCubes=-100.00)) THEN NULL ELSE ISNULL(@cgoCubes,CgoCubes) END  
            ,[CgoQtyExpected]	     = CASE WHEN (@isFormView = 1) THEN @cgoQtyExpected WHEN ((@isFormView = 0) AND (@cgoQtyExpected=-100.00)) THEN NULL ELSE ISNULL(@cgoQtyExpected, CgoQtyExpected) END
			,[CgoQtyOnHand]		     = CASE WHEN (@isFormView = 1) THEN @cgoQtyOnHand WHEN ((@isFormView = 0) AND (@cgoQtyOnHand=-100.00)) THEN NULL ELSE ISNULL(@cgoQtyOnHand, CgoQtyOnHand) END
			,[CgoQtyDamaged]	     = CASE WHEN (@isFormView = 1) THEN @cgoQtyDamaged WHEN ((@isFormView = 0) AND (@cgoQtyDamaged=-100.00)) THEN NULL ELSE ISNULL(@cgoQtyDamaged, CgoQtyDamaged) END
			,[CgoQtyOnHold]		     = CASE WHEN (@isFormView = 1) THEN @cgoQtyOnHold WHEN ((@isFormView = 0) AND (@cgoQtyOnHold=-100.00)) THEN NULL ELSE ISNULL(@cgoQtyOnHold, CgoQtyOnHold) END
			,[CgoQtyShortOver]	     = CASE WHEN (@isFormView = 1) THEN @cgoQtyShortOver WHEN ((@isFormView = 0) AND (@cgoQtyShortOver=-100.00)) THEN NULL ELSE ISNULL(@cgoQtyShortOver, CgoQtyShortOver) END
			,[CgoQtyUnits]		     = CASE WHEN (@isFormView = 1) THEN @cgoQtyUnits WHEN ((@isFormView = 0) AND (@cgoQtyUnits='#M4PL#')) THEN NULL ELSE ISNULL(@cgoQtyUnits, CgoQtyUnits) END
	        ,[CgoReasonCodeOSD]      = CASE WHEN (@isFormView = 1) THEN @cgoReasonCodeOSD WHEN ((@isFormView = 0) AND (@cgoReasonCodeOSD='#M4PL#')) THEN NULL ELSE ISNULL(@cgoReasonCodeOSD,CgoReasonCodeOSD) END  
            ,[CgoReasonCodeHold]     = CASE WHEN (@isFormView = 1) THEN @cgoReasonCodeHold WHEN ((@isFormView = 0) AND (@cgoReasonCodeHold='#M4PL#')) THEN NULL ELSE ISNULL(@cgoReasonCodeHold,CgoReasonCodeHold) END  
			,[CgoSeverityCode]       = CASE WHEN (@isFormView = 1) THEN @cgoSeverityCode WHEN ((@isFormView = 0) AND (@cgoSeverityCode=-100)) THEN NULL ELSE ISNULL(@cgoSeverityCode, CgoSeverityCode) END
            ,[CgoLatitude]     = CASE WHEN (@isFormView = 1) THEN @cgoLatitude WHEN ((@isFormView = 0) AND (@cgoLatitude='#M4PL#')) THEN NULL ELSE ISNULL(@cgoLatitude,CgoLatitude) END  
            ,[CgoLongitude]     = CASE WHEN (@isFormView = 1) THEN @cgoLongitude WHEN ((@isFormView = 0) AND (@cgoLongitude='#M4PL#')) THEN NULL ELSE ISNULL(@cgoLongitude,CgoLongitude) END  
			--,[CgoProcessingFlags]    = CASE WHEN (@isFormView = 1) THEN @cgoProcessingFlags WHEN ((@isFormView = 0) AND (@cgoProcessingFlags='#M4PL#')) THEN NULL ELSE ISNULL(@cgoProcessingFlags, CgoProcessingFlags) END
			,[StatusId]			     = CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
			,[ChangedBy]             = @changedBy
			,[DateChanged]           = @dateChanged
	 WHERE   [Id] = @id;

  -- Below line to update ShortOver(Doing here because in GridView BatchEdit ShortOver was not getting updated)
	UPDATE [dbo].[JOBDL010Cargo] SET [CgoQtyShortOver] = (ISNULL([CgoQtyExpected], 0) - (ISNULL([CgoQtyOnHand], 0) + ISNULL([CgoQtyDamaged], 0) + ISNULL([CgoQtyOnHold], 0))) WHERE [Id] = @id;

	SELECT  job.[Id]
		,job.[JobID]
      ,job.[CgoLineItem]
      ,job.[CgoPartNumCode]
      ,job.[CgoTitle]
      ,job.[CgoSerialNumber]
      ,job.[CgoPackagingType]
      ,job.[CgoWeight]
      ,job.[CgoWeightUnits]
      ,job.[CgoLength]
      ,job.[CgoWidth]
      ,job.[CgoHeight]
      ,job.[CgoVolumeUnits]
      ,job.[CgoCubes]
      ,job.[CgoNotes]
      ,job.[CgoQtyExpected]
      ,job.[CgoQtyOnHand]
      ,job.[CgoQtyDamaged]
      ,job.[CgoQtyOnHold]
	  ,job.[CgoQtyShortOver]
      ,job.[CgoQtyUnits]
      ,job.[CgoReasonCodeOSD]
      ,job.[CgoReasonCodeHold]
      ,job.[CgoSeverityCode]
	  ,job.[CgoLatitude]
      ,job.[CgoLongitude]
      ,job.[StatusId]
     -- ,job.[CgoProcessingFlags]
      ,job.[EnteredBy]
      ,job.[DateEntered]
      ,job.[ChangedBy]
      ,job.[DateChanged]
  FROM   [dbo].[JOBDL010Cargo] job
 WHERE   [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdJobDocReference]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Upd a Job Doc Reference
-- Execution:                 EXEC [dbo].[UpdJobDocReference]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================    
ALTER PROCEDURE  [dbo].[UpdJobDocReference]  
	(@userId BIGINT  
	,@roleId BIGINT  
	,@entity NVARCHAR(100)  
	,@id bigint  
	,@jobId bigint = NULL 
	,@jdrItemNumber int = NULL  
	,@jdrCode nvarchar(20) = NULL  
	,@jdrTitle nvarchar(50) = NULL  
	,@docTypeId INT = NULL  
	,@jdrAttachment int = NULL  
	,@jdrDateStart datetime2(7) = NULL  
	,@jdrDateEnd datetime2(7) = NULL  
	,@jdrRenewal bit = NULL  
	,@statusId int = NULL  
	,@changedBy nvarchar(50) = NULL  
	,@dateChanged datetime2(7) = NULL
	,@isFormView BIT = 0 )   
AS  
BEGIN TRY                  
 SET NOCOUNT ON;     
 DECLARE @updatedItemNumber INT        

 DECLARE  @olddocTypeId INT 
 DECLARE  @primaryId INT 
 SET @primaryId =@id;
 SELECT @olddocTypeId = DocTypeId from JOBDL040DocumentReference WHERE id= @id;
 IF @olddocTypeId <> @docTypeId
 BEGIN
    SET @primaryId = 0
 END
 DECLARE @where NVARCHAR(MAX) =  ' AND DocTypeId ='  +  CAST(@docTypeId AS VARCHAR)   
  EXEC [dbo].[ResetItemNumber] @userId, @primaryId, @jobId, @entity, @jdrItemNumber, @statusId, NULL, @where,  @updatedItemNumber OUTPUT 
 UPDATE [dbo].[JOBDL040DocumentReference]  
  SET  [JobID]              = CASE WHEN (@isFormView = 1) THEN @jobId WHEN ((@isFormView = 0) AND (@jobId=-100)) THEN NULL ELSE ISNULL(@jobId, JobID) END  
      ,[JdrItemNumber]      = CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, JdrItemNumber)  END
   ,[JdrCode]               = CASE WHEN (@isFormView = 1) THEN @JdrCode WHEN ((@isFormView = 0) AND (@JdrCode='#M4PL#')) THEN NULL ELSE ISNULL(@JdrCode, JdrCode)  END
   ,[JdrTitle]              = CASE WHEN (@isFormView = 1) THEN @JdrTitle WHEN ((@isFormView = 0) AND (@JdrTitle='#M4PL#')) THEN NULL ELSE ISNULL(@JdrTitle, JdrTitle)  END
   ,[DocTypeId]             = CASE WHEN (@isFormView = 1) THEN @docTypeId WHEN ((@isFormView = 0) AND (@docTypeId=-100)) THEN NULL ELSE ISNULL(@docTypeId, DocTypeId)  END
   ,[StatusId]				= CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId )  END
   --,[JdrAttachment]         = CASE WHEN (@isFormView = 1) THEN @JdrAttachment WHEN ((@isFormView = 0) AND (@JdrAttachment=-100)) THEN NULL ELSE ISNULL(@JdrAttachment, JdrAttachment) END 
   ,[JdrDateStart]          = CASE WHEN (@isFormView = 1) THEN @JdrDateStart WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @JdrDateStart, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@JdrDateStart, JdrDateStart)  END
   ,[JdrDateEnd]            = CASE WHEN (@isFormView = 1) THEN @JdrDateEnd WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @JdrDateEnd, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@JdrDateEnd , JdrDateEnd)  END
   ,[JdrRenewal]            = ISNULL(@JdrRenewal, JdrRenewal)  
   ,[ChangedBy]             = @changedBy  
   ,[DateChanged]           = @dateChanged  
  WHERE   [Id] = @id  
 SELECT job.[Id]  
  ,job.[JobID]  
  ,job.[JdrItemNumber]  
  ,job.[JdrCode]  
  ,job.[JdrTitle]  
  ,job.[DocTypeId]  
  ,job.[StatusId]  
  ,job.[JdrAttachment]  
  ,job.[JdrDateStart]  
  ,job.[JdrDateEnd]  
  ,job.[JdrRenewal]  
  ,job.[EnteredBy]  
  ,job.[DateEntered]  
  ,job.[ChangedBy]  
  ,job.[DateChanged]  
  FROM   [dbo].[JOBDL040DocumentReference] job  
 WHERE   [Id] = @id  
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdJobGateway]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */  
-- =============================================          
-- Author:                    Akhil Chauhan           
-- Create date:               08/16/2018        
-- Description:               Upd a Job Gateway   
-- Execution:                 EXEC [dbo].[UpdJobGateway]  
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)               04/27/2018
-- Modified Desc:             
-- =============================================      
ALTER PROCEDURE  [dbo].[UpdJobGateway]      
	(@userId BIGINT      
	,@roleId BIGINT  
	,@entity NVARCHAR(100)      
	,@id bigint      
	,@jobId bigint = NULL      
	,@programId bigint = NULL      
	,@gwyGatewaySortOrder int = NULL      
	,@gwyGatewayCode nvarchar(20) = NULL      
	,@gwyGatewayTitle nvarchar(50) = NULL      
	,@gwyGatewayDuration decimal(18, 2) = NULL      
	,@gwyGatewayDefault bit = NULL      
	,@gatewayTypeId int = NULL      
	,@gwyGatewayAnalyst bigint = NULL      
	,@gwyGatewayResponsible bigint = NULL      
	,@gwyGatewayPCD datetime2(7) = NULL      
	,@gwyGatewayECD datetime2(7) = NULL      
	,@gwyGatewayACD datetime2(7) = NULL      
	,@gwyCompleted bit = NULL      
	,@gatewayUnitId int = NULL      
	,@gwyAttachments int = NULL      
	,@gwyProcessingFlags nvarchar(20) = NULL      
	,@gwyDateRefTypeId int = NULL      
	,@scanner bit = NULL   
	,@gwyShipApptmtReasonCode nvarchar(20)     
	,@gwyShipStatusReasonCode nvarchar(20)   
	,@gwyOrderType nvarchar(20)     
	,@gwyShipmentType nvarchar(20)          
	,@statusId int = NULL      
	--,@gwyUpdatedStatusOn  datetime2(7)    =NULL    
	,@gwyUpdatedById int = NULL      
	,@gwyClosedOn datetime2(7) = NULL      
	,@gwyClosedBy nvarchar(50) = NULL    
	,@gwyPerson  NVARCHAR(50) = NULL
	,@gwyPhone   NVARCHAR(25) = NULL 
	,@gwyEmail    NVARCHAR(25) = NULL
	,@gwyTitle    NVARCHAR(50) = NULL
	,@gwyDDPCurrent datetime2(7) = NULL        
	,@gwyDDPNew datetime2(7) = NULL        
	,@gwyUprWindow decimal(18, 2) = NULL 
	,@gwyLwrWindow decimal(18, 2) = NULL  
	,@gwyUprDate datetime2(7) = NULL        
	,@gwyLwrDate datetime2(7) = NULL        
	,@dateChanged datetime2(7) = NULL      
	,@changedBy nvarchar(50) = NULL  
	,@isFormView BIT = 0 )       
AS      
BEGIN TRY                      
 SET NOCOUNT ON;         
   DECLARE @updatedItemNumber INT            
  DECLARE @where NVARCHAR(MAX) = ' AND GatewayTypeId ='  +  CAST(@gatewayTypeId AS VARCHAR)                    
  EXEC [dbo].[ResetItemNumber] @userId, @id, @jobId, @entity, @gwyGatewaySortOrder, @statusId, NULL, @where,  @updatedItemNumber OUTPUT  
      
 UPDATE [dbo].[JOBDL020Gateways]      
  SET  [JobID]              = CASE WHEN (@isFormView = 1) THEN @jobId WHEN ((@isFormView = 0) AND (@jobId=-100)) THEN NULL ELSE ISNULL(@jobId, JobID) END     
   ,[ProgramID]             = CASE WHEN (@isFormView = 1) THEN @programId WHEN ((@isFormView = 0) AND (@programId=-100)) THEN NULL ELSE ISNULL(@programId, ProgramID)   END   
   ,[GwyGatewaySortOrder]   = CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, GwyGatewaySortOrder)    END  
   ,[GwyGatewayCode]        = CASE WHEN (@isFormView = 1) THEN @gwyGatewayCode WHEN ((@isFormView = 0) AND (@gwyGatewayCode='#M4PL#')) THEN NULL ELSE ISNULL(@gwyGatewayCode, GwyGatewayCode)    END  
   ,[GwyGatewayTitle]       = CASE WHEN (@isFormView = 1) THEN @gwyGatewayTitle WHEN ((@isFormView = 0) AND (@gwyGatewayTitle='#M4PL#')) THEN NULL ELSE ISNULL(@gwyGatewayTitle, GwyGatewayTitle)    END  
   ,[GwyGatewayDuration]    = CASE WHEN (@isFormView = 1) THEN @gwyGatewayDuration WHEN ((@isFormView = 0) AND (@gwyGatewayDuration=-100.00)) THEN NULL ELSE ISNULL(@gwyGatewayDuration, GwyGatewayDuration) END     
   ,[GwyGatewayDefault]     = ISNULL(@gwyGatewayDefault, GwyGatewayDefault)  
   ,[GatewayTypeId]         = CASE WHEN (@isFormView = 1) THEN @gatewayTypeId WHEN ((@isFormView = 0) AND (@gatewayTypeId=-100)) THEN NULL ELSE ISNULL(@gatewayTypeId, GatewayTypeId)    END  
   ,[GwyGatewayAnalyst]     = CASE WHEN (@isFormView = 1) THEN @gwyGatewayAnalyst WHEN ((@isFormView = 0) AND (@gwyGatewayAnalyst=-100)) THEN NULL ELSE ISNULL(@gwyGatewayAnalyst, GwyGatewayAnalyst) END      
   ,[GwyGatewayResponsible] = CASE WHEN (@isFormView = 1) THEN @gwyGatewayResponsible WHEN ((@isFormView = 0) AND (@gwyGatewayResponsible=-100)) THEN NULL ELSE ISNULL(@gwyGatewayResponsible, GwyGatewayResponsible) END     
   ,[GwyGatewayPCD]         = CASE WHEN (@isFormView = 1) THEN @gwyGatewayPCD WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @gwyGatewayPCD, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@gwyGatewayPCD, GwyGatewayPCD)    END  
   ,[GwyGatewayECD]         = CASE WHEN (@isFormView = 1) THEN @gwyGatewayECD WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @gwyGatewayECD, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@gwyGatewayECD, GwyGatewayECD)    END  
   ,[GwyGatewayACD]         = CASE WHEN (@isFormView = 1) THEN @gwyGatewayACD WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @gwyGatewayACD, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@gwyGatewayACD, GwyGatewayACD)    END  
   ,[GwyCompleted]          = ISNULL(@gwyCompleted, GwyCompleted)  
   ,[GatewayUnitId]         = CASE WHEN (@isFormView = 1) THEN @gatewayUnitId WHEN ((@isFormView = 0) AND (@gatewayUnitId=-100)) THEN NULL ELSE ISNULL(@gatewayUnitId, GatewayUnitId)    END  
   --,[GwyAttachments]        = CASE WHEN (@isFormView = 1) THEN @gwyAttachments WHEN ((@isFormView = 0) AND (@gwyAttachments=-100)) THEN NULL ELSE ISNULL(@gwyAttachments, GwyAttachments)    END  
   ,[GwyProcessingFlags]    = CASE WHEN (@isFormView = 1) THEN @gwyProcessingFlags WHEN ((@isFormView = 0) AND (@gwyProcessingFlags='#M4PL#')) THEN NULL ELSE ISNULL(@gwyProcessingFlags, GwyProcessingFlags) END     


   ,[GwyDateRefTypeId]      = CASE WHEN (@isFormView = 1) THEN @gwyDateRefTypeId WHEN ((@isFormView = 0) AND (@gwyDateRefTypeId=-100)) THEN NULL ELSE ISNULL(@gwyDateRefTypeId, GwyDateRefTypeId)    END  
   ,[Scanner]          = ISNULL(@scanner, Scanner)  

   ,GwyShipApptmtReasonCode    = CASE WHEN (@isFormView = 1) THEN @gwyShipApptmtReasonCode WHEN ((@isFormView = 0) AND (@gwyShipApptmtReasonCode='#M4PL#')) THEN NULL ELSE ISNULL(@gwyShipApptmtReasonCode, GwyShipApptmtReasonCode) END     
   ,GwyShipStatusReasonCode    = CASE WHEN (@isFormView = 1) THEN @gwyShipStatusReasonCode WHEN ((@isFormView = 0) AND (@gwyShipStatusReasonCode='#M4PL#')) THEN NULL ELSE ISNULL(@gwyShipStatusReasonCode, GwyShipStatusReasonCode) END     
   ,[GwyOrderType]           = CASE WHEN (@isFormView = 1) THEN @gwyOrderType WHEN ((@isFormView = 0) AND (@gwyOrderType='#M4PL#')) THEN NULL ELSE ISNULL(@gwyOrderType, GwyOrderType) END  
   ,[GwyShipmentType]           = CASE WHEN (@isFormView = 1) THEN @gwyShipmentType WHEN ((@isFormView = 0) AND (@gwyShipmentType='#M4PL#')) THEN NULL ELSE ISNULL(@gwyShipmentType, GwyShipmentType) END  



   ,[StatusId]              = CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId)    END  
   --,[GwyUpdatedStatusOn]     =ISNULL(@gwyUpdatedStatusOn,GwyUpdatedStatusOn)    
   ,[GwyUpdatedById]        = CASE WHEN (@isFormView = 1) THEN @gwyUpdatedById WHEN ((@isFormView = 0) AND (@gwyUpdatedById=-100)) THEN NULL ELSE ISNULL(@gwyUpdatedById, GwyUpdatedById)  END    
   ,[GwyClosedOn]           = CASE WHEN (@isFormView = 1) THEN @gwyClosedOn WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @gwyClosedOn, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@gwyClosedOn, GwyClosedOn)  END    
   ,[GwyClosedBy]           = CASE WHEN (@isFormView = 1) THEN @gwyClosedBy WHEN ((@isFormView = 0) AND (@gwyClosedBy='#M4PL#')) THEN NULL ELSE ISNULL(@gwyClosedBy, GwyClosedBy)   END   
   
   ,[GwyPerson]           = CASE WHEN (@isFormView = 1) THEN @gwyPerson WHEN ((@isFormView = 0) AND (@gwyPerson='#M4PL#')) THEN NULL ELSE ISNULL(@gwyPerson, GwyPerson) END  
   ,[GwyPhone]           = CASE WHEN (@isFormView = 1) THEN @gwyPhone WHEN ((@isFormView = 0) AND (@gwyPhone='#M4PL#')) THEN NULL ELSE ISNULL(@gwyPhone, GwyPhone) END  
   ,[GwyEmail]           = CASE WHEN (@isFormView = 1) THEN @gwyEmail WHEN ((@isFormView = 0) AND (@gwyEmail='#M4PL#')) THEN NULL ELSE ISNULL(@gwyEmail, GwyEmail) END  
   ,[GwyTitle]           = CASE WHEN (@isFormView = 1) THEN @gwyTitle WHEN ((@isFormView = 0) AND (@gwyTitle='#M4PL#')) THEN NULL ELSE ISNULL(@gwyTitle, GwyTitle) END  
   ,[GwyDDPCurrent]         = CASE WHEN (@isFormView = 1) THEN @gwyDDPCurrent WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @gwyDDPCurrent, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@gwyDDPCurrent, GwyDDPCurrent)    END  
   ,[GwyDDPNew]         = CASE WHEN (@isFormView = 1) THEN @gwyDDPNew WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @gwyDDPNew, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@gwyDDPNew, GwyDDPNew)    END  
   ,[GwyUprDate]         = CASE WHEN (@isFormView = 1) THEN @gwyUprDate WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @gwyUprDate, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@gwyUprDate, GwyUprDate)    END  
   ,[GwyLwrDate]         = CASE WHEN (@isFormView = 1) THEN @gwyLwrDate WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @gwyLwrDate, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@gwyLwrDate, GwyLwrDate)    END  
   ,[GwyUprWindow]             = CASE WHEN (@isFormView = 1) THEN @gwyUprWindow WHEN ((@isFormView = 0) AND (@gwyUprWindow=-100.00)) THEN NULL ELSE ISNULL(@gwyUprWindow,GwyUprWindow) END  
   ,[GwyLwrWindow]             = CASE WHEN (@isFormView = 1) THEN @gwyLwrWindow WHEN ((@isFormView = 0) AND (@gwyLwrWindow=-100.00)) THEN NULL ELSE ISNULL(@gwyLwrWindow,GwyLwrWindow) END  
   
   ,[DateChanged]           = @dateChanged      
   ,[ChangedBy]             = @changedBy      
  WHERE   [Id] = @id      ;

  UPDATE  [JOBDL020Gateways] SET [GwyGatewayACD] = GETUTCDATE()
  WHERE [GwyGatewayACD] IS NULL AND [GwyCompleted] = 1 AND [Id] = @id      ;

  UPDATE  [JOBDL020Gateways] SET [GwyCompleted] = 1
  WHERE [GwyGatewayACD] IS NOT NULL AND [GwyCompleted] = 0 AND [Id] = @id      ;


 SELECT job.[Id]      
  ,job.[JobID]      
  ,job.[ProgramID]      
  ,job.[GwyGatewaySortOrder]      
  ,job.[GwyGatewayCode]      
  ,job.[GwyGatewayTitle]      
  ,job.[GwyGatewayDuration]      
  ,job.[GwyGatewayDefault]      
  ,job.[GatewayTypeId]      
  ,job.[GwyGatewayAnalyst]      
  ,job.[GwyGatewayResponsible]      
  ,job.[GwyGatewayPCD]      
  ,job.[GwyGatewayECD]      
  ,job.[GwyGatewayACD]      
  ,job.[GwyCompleted]      
  ,job.[GatewayUnitId]      
  ,job.[GwyAttachments]      
  ,job.[GwyProcessingFlags]      
  ,job.[GwyDateRefTypeId]      
  ,job.[Scanner]
  ,job.[StatusId]
  ,job.[GwyUpdatedById]      
  ,job.[GwyClosedOn]      
  ,job.[GwyClosedBy]      
  ,job.[DateEntered]      
  ,job.[EnteredBy]      
  ,job.[DateChanged]      
  ,job.[ChangedBy]  
   ,job.[GwyShipApptmtReasonCode]
  ,job.[GwyShipStatusReasonCode]
   ,job.[GwyOrderType]
  ,job.[GwyShipmentType]
      
  FROM   [dbo].[JOBDL020Gateways] job      
 WHERE   [Id] = @id      
END TRY                      
BEGIN CATCH                      
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                      
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                      
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                      
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                      
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdJobGatewayAction]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */  
-- =============================================          
-- Author:                    Akhil Chauhan           
-- Create date:               10/31/2018        
-- Description:               Upd a Job Gateway For Action fields
-- Execution:                 EXEC [dbo].[UpdJobGateway]  
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)               04/27/2018
-- Modified Desc:             
-- =============================================      
ALTER PROCEDURE  [dbo].[UpdJobGatewayAction]      
	(@userId BIGINT      
	,@roleId BIGINT  
	,@entity NVARCHAR(100)      
	,@id bigint      
	,@jobId bigint = NULL      
	,@programId bigint = NULL      
	,@gwyGatewayACD datetime2(7) = NULL      
	,@gwyCompleted bit = NULL      
	,@gwyDateRefTypeId int = NULL      
	,@gwyShipApptmtReasonCode nvarchar(20) = NULL
	,@gwyShipStatusReasonCode nvarchar(20) = NULL   
	,@gwyClosedOn datetime2(7) = NULL      
	,@gwyClosedBy nvarchar(50) = NULL    
	,@gwyPerson  NVARCHAR(50) = NULL
	,@gwyPhone   NVARCHAR(25) = NULL 
	,@gwyEmail    NVARCHAR(25) = NULL
	,@gwyTitle    NVARCHAR(50) = NULL
	,@gwyDDPCurrent datetime2(7) = NULL        
	,@gwyDDPNew datetime2(7) = NULL        
	,@gwyUprWindow decimal(18, 2) = NULL 
	,@gwyLwrWindow decimal(18, 2) = NULL  
	,@gwyUprDate datetime2(7) = NULL        
	,@gwyLwrDate datetime2(7) = NULL        
	,@dateChanged datetime2(7) = NULL      
	,@changedBy nvarchar(50) = NULL  
	,@isFormView BIT = 0 )       
AS      
BEGIN TRY                      
 SET NOCOUNT ON;         
      
 UPDATE [dbo].[JOBDL020Gateways]      
  SET  [JobID]              = CASE WHEN (@isFormView = 1) THEN @jobId WHEN ((@isFormView = 0) AND (@jobId=-100)) THEN NULL ELSE ISNULL(@jobId, JobID) END     
   ,[ProgramID]             = CASE WHEN (@isFormView = 1) THEN @programId WHEN ((@isFormView = 0) AND (@programId=-100)) THEN NULL ELSE ISNULL(@programId, ProgramID)   END   
   ,[GwyGatewayACD]         = CASE WHEN (@isFormView = 1) THEN @gwyGatewayACD WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @gwyGatewayACD, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@gwyGatewayACD, GwyGatewayACD)    END  
   ,[GwyCompleted]          = ISNULL(@gwyCompleted, GwyCompleted)  
   ,[GwyDateRefTypeId]      = CASE WHEN (@isFormView = 1) THEN @gwyDateRefTypeId WHEN ((@isFormView = 0) AND (@gwyDateRefTypeId=-100)) THEN NULL ELSE ISNULL(@gwyDateRefTypeId, GwyDateRefTypeId)    END  
   ,GwyShipApptmtReasonCode    = CASE WHEN (@isFormView = 1) THEN @gwyShipApptmtReasonCode WHEN ((@isFormView = 0) AND (@gwyShipApptmtReasonCode='#M4PL#')) THEN NULL ELSE ISNULL(@gwyShipApptmtReasonCode, GwyShipApptmtReasonCode) END     
   ,GwyShipStatusReasonCode    = CASE WHEN (@isFormView = 1) THEN @gwyShipStatusReasonCode WHEN ((@isFormView = 0) AND (@gwyShipStatusReasonCode='#M4PL#')) THEN NULL ELSE ISNULL(@gwyShipStatusReasonCode, GwyShipStatusReasonCode) END     
   ,[GwyClosedOn]           = CASE WHEN (@isFormView = 1) THEN @gwyClosedOn WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @gwyClosedOn, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@gwyClosedOn, GwyClosedOn)  END    
   ,[GwyClosedBy]           = CASE WHEN (@isFormView = 1) THEN @gwyClosedBy WHEN ((@isFormView = 0) AND (@gwyClosedBy='#M4PL#')) THEN NULL ELSE ISNULL(@gwyClosedBy, GwyClosedBy)   END   
   ,[GwyPerson]           = CASE WHEN (@isFormView = 1) THEN @gwyPerson WHEN ((@isFormView = 0) AND (@gwyPerson='#M4PL#')) THEN NULL ELSE ISNULL(@gwyPerson, GwyPerson) END  
   ,[GwyPhone]           = CASE WHEN (@isFormView = 1) THEN @gwyPhone WHEN ((@isFormView = 0) AND (@gwyPhone='#M4PL#')) THEN NULL ELSE ISNULL(@gwyPhone, GwyPhone) END  
   ,[GwyEmail]           = CASE WHEN (@isFormView = 1) THEN @gwyEmail WHEN ((@isFormView = 0) AND (@gwyEmail='#M4PL#')) THEN NULL ELSE ISNULL(@gwyEmail, GwyEmail) END  
   ,[GwyTitle]           = CASE WHEN (@isFormView = 1) THEN @gwyTitle WHEN ((@isFormView = 0) AND (@gwyTitle='#M4PL#')) THEN NULL ELSE ISNULL(@gwyTitle, GwyTitle) END  
   ,[GwyDDPCurrent]         = CASE WHEN (@isFormView = 1) THEN @gwyDDPCurrent WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @gwyDDPCurrent, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@gwyDDPCurrent, GwyDDPCurrent)    END  
   ,[GwyDDPNew]         = CASE WHEN (@isFormView = 1) THEN @gwyDDPNew WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @gwyDDPNew, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@gwyDDPNew, GwyDDPNew)    END  
   ,[GwyUprDate]         = CASE WHEN (@isFormView = 1) THEN @gwyUprDate WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @gwyUprDate, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@gwyUprDate, GwyUprDate)    END  
   ,[GwyLwrDate]         = CASE WHEN (@isFormView = 1) THEN @gwyLwrDate WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @gwyLwrDate, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@gwyLwrDate, GwyLwrDate)    END  
   ,[GwyUprWindow]             = CASE WHEN (@isFormView = 1) THEN @gwyUprWindow WHEN ((@isFormView = 0) AND (@gwyUprWindow=-100.00)) THEN NULL ELSE ISNULL(@gwyUprWindow,GwyUprWindow) END  
   ,[GwyLwrWindow]             = CASE WHEN (@isFormView = 1) THEN @gwyLwrWindow WHEN ((@isFormView = 0) AND (@gwyLwrWindow=-100.00)) THEN NULL ELSE ISNULL(@gwyLwrWindow,GwyLwrWindow) END  
   ,[DateChanged]           = @dateChanged      
   ,[ChangedBy]             = @changedBy      
  WHERE   [Id] = @id;

 SELECT job.[Id]      
  ,job.[JobID]      
  ,job.[ProgramID]      
  ,job.[GwyGatewaySortOrder]      
  ,job.[GwyGatewayCode]      
  ,job.[GwyGatewayTitle]      
  ,job.[GwyGatewayDuration]      
  ,job.[GwyGatewayDefault]      
  ,job.[GatewayTypeId]      
  ,job.[GwyGatewayAnalyst]      
  ,job.[GwyGatewayResponsible]      
  ,job.[GwyGatewayPCD]      
  ,job.[GwyGatewayECD]      
  ,job.[GwyGatewayACD]      
  ,job.[GwyCompleted]      
  ,job.[GatewayUnitId]      
  ,job.[GwyAttachments]      
  ,job.[GwyProcessingFlags]      
  ,job.[GwyDateRefTypeId]      
  ,job.[Scanner]
  ,job.[StatusId]
  ,job.[GwyUpdatedById]      
  ,job.[GwyClosedOn]      
  ,job.[GwyClosedBy]      
  ,job.[DateEntered]      
  ,job.[EnteredBy]      
  ,job.[DateChanged]      
  ,job.[ChangedBy]  
   ,job.[GwyShipApptmtReasonCode]
  ,job.[GwyShipStatusReasonCode]
   ,job.[GwyOrderType]
  ,job.[GwyShipmentType]
      
  FROM   [dbo].[JOBDL020Gateways] job      
 WHERE   [Id] = @id      
END TRY                      
BEGIN CATCH                      
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                      
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                      
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                      
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                      
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdJobGatewayComplete]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */  
-- =============================================          
-- Author:                    Janardana Behara         
-- Create date:               06/01/2018        
-- Description:               Get a update job Gateway  on complete check
-- Execution:                 EXEC [dbo].[UpdJobGatewayComplete]    
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)    
-- Modified Desc:    
-- =============================================  
ALTER PROCEDURE  [dbo].[UpdJobGatewayComplete]  
	@userId BIGINT 
	,@roleId NVARCHAR(25)
	,@orgId BIGINT  
	,@id BIGINT  
	,@jobId BIGINT 
	,@gwyGatewayCode NVARCHAR(25)  =NULL
	,@gwyGatewayTitle NVARCHAR(50) =NULL
	,@gwyShipApptmtReasonCode  NVARCHAR(25)  =NULL
	,@gwyShipStatusReasonCode   NVARCHAR(25)  =NULL
	,@dateChanged datetime2(7) = NULL      
	,@changedBy nvarchar(50) = NULL  
	,@isFormView BIT = 0
AS  
BEGIN TRY                  
 SET NOCOUNT ON;    
   
   
   UPDATE  JOBDL020Gateways 
    SET   GwyGatewayCode    =       @gwyGatewayCode 
	     ,GwyGatewayTitle  =         @gwyGatewayTitle 
	     ,GwyShipApptmtReasonCode =   @gwyShipApptmtReasonCode   
         ,GwyShipStatusReasonCode  =  @gwyShipStatusReasonCode   
		 ,GwyCompleted = 1
		 ,DateChanged = @dateChanged
		 ,ChangedBy = @changedBy
   WHERE Id = @id;
     
   SELECT job.[Id]  
  ,job.[JobID]  
  ,job.[ProgramID]
  ,job.[GwyGatewayCode]  
  ,job.[GwyGatewayTitle]
  ,job.GwyShipApptmtReasonCode  
  ,job.GwyShipStatusReasonCode  
  
  FROM   [dbo].[JOBDL020Gateways] job  
  
 WHERE   job.[Id] = @id 
    
   
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdJobRefCostSheet]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Upd a Job Ref Cost Sheet
-- Execution:                 EXEC [dbo].[UpdJobRefCostSheet]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[UpdJobRefCostSheet]
	(@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@Id bigint
	,@JobId bigint = NULL
	,@CstLineItem nvarchar(20) = NULL
	,@CstChargeId int = NULL
	,@CstChargeCode nvarchar(25) = NULL
	,@CstTitle nvarchar(50) = NULL
	,@CstSurchargeOrder bigint = NULL
	,@CstSurchargePercent float = NULL
	,@chargeTypeId int = NULL
	,@CstNumberUsed int = NULL
	,@CstDuration decimal(18, 2) = NULL
	,@CstQuantity decimal(18, 2) = NULL
	,@costUnitId int = NULL
	,@CstCostRate decimal(18, 2) = NULL
	,@CstCost decimal(18, 2) = NULL
	,@CstMarkupPercent float = NULL
	,@CstRevenueRate decimal(18, 2) = NULL
	,@CstRevDuration decimal(18, 2) = NULL
	,@CstRevQuantity decimal(18, 2) = NULL
	,@CstRevBillable decimal(18, 2) = NULL
	,@statusId int = NULL
	,@ChangedBy nvarchar(50) = NULL
	,@DateChanged datetime2(7) = NULL
	,@isFormView BIT = 0) 
AS
BEGIN TRY                
 SET NOCOUNT ON;  
    DECLARE @updatedItemNumber INT      
   EXEC [dbo].[ResetItemNumber] @userId, @id, @jobId, @entity, @cstLineItem, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT 
  
 UPDATE [dbo].[JOBDL060Ref_CostSheetJob]
		SET  [JobID]                 = CASE WHEN (@isFormView = 1) THEN @JobID WHEN ((@isFormView = 0) AND (@JobID=-100)) THEN NULL ELSE ISNULL(@JobID, JobID) END
			,[CstLineItem]           = CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, CstLineItem)END
			,[CstChargeID]           = CASE WHEN (@isFormView = 1) THEN @CstChargeID WHEN ((@isFormView = 0) AND (@CstChargeID=-100)) THEN NULL ELSE ISNULL(@CstChargeID, CstChargeID) END
			,[CstChargeCode]         = CASE WHEN (@isFormView = 1) THEN @CstChargeCode WHEN ((@isFormView = 0) AND (@CstChargeCode='#M4PL#')) THEN NULL ELSE ISNULL(@CstChargeCode, CstChargeCode) END
			,[CstTitle]              = CASE WHEN (@isFormView = 1) THEN @CstTitle WHEN ((@isFormView = 0) AND (@CstTitle='#M4PL#')) THEN NULL ELSE ISNULL(@CstTitle, CstTitle) END
			,[CstSurchargeOrder]     = CASE WHEN (@isFormView = 1) THEN @CstSurchargeOrder WHEN ((@isFormView = 0) AND (@CstSurchargeOrder=-100)) THEN NULL ELSE ISNULL(@CstSurchargeOrder, CstSurchargeOrder) END
			,[CstSurchargePercent]   = CASE WHEN (@isFormView = 1) THEN @CstSurchargePercent WHEN ((@isFormView = 0) AND (@CstSurchargePercent=-100.00)) THEN NULL ELSE ISNULL(@CstSurchargePercent, CstSurchargePercent) END
			,[ChargeTypeId]          = CASE WHEN (@isFormView = 1) THEN @chargeTypeId WHEN ((@isFormView = 0) AND (@chargeTypeId=-100)) THEN NULL ELSE ISNULL(@chargeTypeId, ChargeTypeId) END
			,[CstNumberUsed]         = CASE WHEN (@isFormView = 1) THEN @CstNumberUsed WHEN ((@isFormView = 0) AND (@CstNumberUsed=-100)) THEN NULL ELSE ISNULL(@CstNumberUsed, CstNumberUsed) END
			,[CstDuration]           = CASE WHEN (@isFormView = 1) THEN @CstDuration WHEN ((@isFormView = 0) AND (@CstDuration=-100.00)) THEN NULL ELSE ISNULL(@CstDuration, CstDuration) END
			,[CstQuantity]           = CASE WHEN (@isFormView = 1) THEN @CstQuantity WHEN ((@isFormView = 0) AND (@CstQuantity=-100.00)) THEN NULL ELSE ISNULL(@CstQuantity, CstQuantity) END
			,[CostUnitId]            = CASE WHEN (@isFormView = 1) THEN @costUnitId WHEN ((@isFormView = 0) AND (@costUnitId=-100)) THEN NULL ELSE ISNULL(@costUnitId, CostUnitId) END
			,[CstCostRate]           = CASE WHEN (@isFormView = 1) THEN @CstCostRate WHEN ((@isFormView = 0) AND (@CstCostRate=-100.00)) THEN NULL ELSE ISNULL(@CstCostRate, CstCostRate) END
			,[CstCost]               = CASE WHEN (@isFormView = 1) THEN @CstCost WHEN ((@isFormView = 0) AND (@CstCost=-100.00)) THEN NULL ELSE ISNULL(@CstCost, CstCost) END
			,[CstMarkupPercent]      = CASE WHEN (@isFormView = 1) THEN @CstMarkupPercent WHEN ((@isFormView = 0) AND (@CstMarkupPercent=-100.00)) THEN NULL ELSE ISNULL(@CstMarkupPercent, CstMarkupPercent) END
			,[CstRevenueRate]        = CASE WHEN (@isFormView = 1) THEN @CstRevenueRate WHEN ((@isFormView = 0) AND (@CstRevenueRate=-100.00)) THEN NULL ELSE ISNULL(@CstRevenueRate, CstRevenueRate) END
			,[CstRevDuration]        = CASE WHEN (@isFormView = 1) THEN @CstRevDuration WHEN ((@isFormView = 0) AND (@CstRevDuration=-100.00)) THEN NULL ELSE ISNULL(@CstRevDuration, CstRevDuration) END
			,[CstRevQuantity]        = CASE WHEN (@isFormView = 1) THEN @CstRevQuantity WHEN ((@isFormView = 0) AND (@CstRevQuantity=-100.00)) THEN NULL ELSE ISNULL(@CstRevQuantity, CstRevQuantity) END
			,[CstRevBillable]        = CASE WHEN (@isFormView = 1) THEN @CstRevBillable WHEN ((@isFormView = 0) AND (@CstRevBillable=-100.00)) THEN NULL ELSE ISNULL(@CstRevBillable, CstRevBillable) END
			,[StatusId]              = CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
			,[ChangedBy]             = @ChangedBy
			,[DateChanged]           = @DateChanged
	 WHERE   [Id] = @id
	SELECT job.[Id]
		,job.[JobID]
		,job.[CstLineItem]
		,job.[CstChargeID]
		,job.[CstChargeCode]
		,job.[CstTitle]
		,job.[CstSurchargeOrder]
		,job.[CstSurchargePercent]
		,job.[ChargeTypeId]
		,job.[CstNumberUsed]
		,job.[CstDuration]
		,job.[CstQuantity]
		,job.[CostUnitId]
		,job.[CstCostRate]
		,job.[CstCost]
		,job.[CstMarkupPercent]
		,job.[CstRevenueRate]
		,job.[CstRevDuration]
		,job.[CstRevQuantity]
		,job.[CstRevBillable]
		,job.[StatusId]
		,job.[EnteredBy]
		,job.[DateEntered]
		,job.[ChangedBy]
		,job.[DateChanged]
  FROM   [dbo].[JOBDL060Ref_CostSheetJob] job WHERE [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdJobRefStatus]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Upd a Job Ref Status
-- Execution:                 EXEC [dbo].[UpdJobRefStatus]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[UpdJobRefStatus]
	(@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id bigint
	,@jobId bigint = NULL
	,@jbsOutlineCode nvarchar(20) = NULL
	,@jbsStatusCode nvarchar(25) = NULL
	,@jbsTitle nvarchar(50) = NULL
	,@statusId int = NULL
	,@severityId int = NULL
	,@changedBy nvarchar(50) = NULL
	,@dateChanged datetime2(7) = NULL
	,@isFormView BIT = 0) 
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 UPDATE [dbo].[JOBDL050Ref_Status]
		SET  [JobID]          = CASE WHEN (@isFormView = 1) THEN @jobId WHEN ((@isFormView = 0) AND (@jobId=-100)) THEN NULL ELSE ISNULL(@jobId, JobID) END
			,[JbsOutlineCode] = CASE WHEN (@isFormView = 1) THEN @jbsOutlineCode WHEN ((@isFormView = 0) AND (@jbsOutlineCode='#M4PL#')) THEN NULL ELSE ISNULL(@jbsOutlineCode, JbsOutlineCode) END
			,[JbsStatusCode]  = CASE WHEN (@isFormView = 1) THEN @jbsStatusCode WHEN ((@isFormView = 0) AND (@jbsStatusCode='#M4PL#')) THEN NULL ELSE ISNULL(@jbsStatusCode, JbsStatusCode ) END
			,[JbsTitle]       = CASE WHEN (@isFormView = 1) THEN @jbsTitle WHEN ((@isFormView = 0) AND (@jbsTitle='#M4PL#')) THEN NULL ELSE ISNULL(@jbsTitle, JbsTitle) END
			,[StatusId]		  = CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId)  END
			,[SeverityId]	  = CASE WHEN (@isFormView = 1) THEN @severityId WHEN ((@isFormView = 0) AND (@severityId=-100)) THEN NULL ELSE ISNULL(@severityId, SeverityId) END
			,[ChangedBy]      = @changedBy
			,[DateChanged]    = @dateChanged
	 WHERE   [Id] = @id
	SELECT job.[Id]
		,job.[JobID]
		,job.[JbsOutlineCode]
		,job.[JbsStatusCode]
		,job.[JbsTitle]
		,job.[StatusId]
		,job.[SeverityId]
		,job.[EnteredBy]
		,job.[DateEntered]
		,job.[ChangedBy]
		,job.[DateChanged]
  FROM   [dbo].[JOBDL050Ref_Status] job WHERE   [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdLookup]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana Behara     
-- Create date:               12/05/2018      
-- Description:               Upd a sys lookup table and columnalias  
-- Execution:                 EXEC [dbo].[UpdLookup]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================  
ALTER PROCEDURE  [dbo].[UpdLookup]
	@userId BIGINT    
	,@roleId BIGINT  
	,@langCode NVARCHAR(10)    
	,@entity NVARCHAR(100) = NULL -- table    
	,@entityColumn NVARCHAR(100) = NULL -- column field    
	,@lookupId INT = NULL -- lookupname    
	,@isGlobal BIT    
AS    
BEGIN TRY    
        
  BEGIN TRANSACTION      
    
 SET NOCOUNT ON;    
 DECLARE @success BIT  = 0      
 -- set lookup as global     
 IF @isGlobal = 1    
 BEGIN    
  IF NOT EXISTS (SELECT Id FROM [SYSTM000Ref_Lookup] WHERE Id = @lookupId)    
  BEGIN   
    INSERT INTO [SYSTM000Ref_Lookup] (Id,LkupTableName)VALUES (@lookupId,'Global')    
  END    
  ELSE    
  BEGIN    
      UPDATE [SYSTM000Ref_Lookup] SET LkupTableName = 'Global' WHERE  Id=@lookupId;    
  END    
        UPDATE [SYSTM000ColumnsAlias]    
      SET [ColLookupId] = @lookupId    
   WHERE [ColTableName] = @entity    
    AND [ColColumnName] = @entityColumn;    
      
  SET @success = 1    
 END    
 ELSE    
 BEGIN    
  UPDATE [SYSTM000ColumnsAlias]    
  SET [ColLookupId] = @lookupId    
  WHERE [ColTableName] = @entity    
   AND [ColColumnName] = @entityColumn;    
   SET @success = 1    
 END    
    
  COMMIT TRANSACTION      
    
 SELECT  @success     
END TRY    
    
BEGIN CATCH    
 DECLARE @ErrorMessage VARCHAR(MAX) = (    
   SELECT ERROR_MESSAGE()    
   )    
  ,@ErrorSeverity VARCHAR(MAX) = (    
   SELECT ERROR_SEVERITY()    
   )    
  ,@RelatedTo VARCHAR(100) = (    
   SELECT OBJECT_NAME(@@PROCID)    
   )    
    
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo    
  ,NULL    
  ,@ErrorMessage    
  ,NULL    
  ,NULL    
  ,@ErrorSeverity    
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdMenuAccessLevel]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan   
-- Create date:               08/16/2018      
-- Description:               Upd a sys menu access level
-- Execution:                 EXEC [dbo].[UpdMenuAccessLevel]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[UpdMenuAccessLevel]		  
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@langCode NVARCHAR(10)
	,@id INT
	,@sysRefId INT
	,@malOrder INT  = NULL
	,@malTitle NVARCHAR(50) = NULL 
	,@dateChanged DATETIME2(7) = NULL 
	,@changedBy NVARCHAR(50) = NULL
	,@isFormView BIT = 0
AS
BEGIN TRY                
 SET NOCOUNT ON;   
   UPDATE  [dbo].[SYSTM010MenuAccessLevel]
    SET     LangCode		=  CASE WHEN (@isFormView = 1) THEN @langCode WHEN ((@isFormView = 0) AND (@langCode='#M4PL#')) THEN LangCode ELSE ISNULL(@langCode, LangCode)  END  
           ,SysRefId 		=  @sysRefId  
           ,MalOrder 		=  CASE WHEN (@isFormView = 1) THEN @malOrder WHEN ((@isFormView = 0) AND (@malOrder=-100)) THEN NULL ELSE ISNULL(@malOrder, MalOrder) END
           ,MalTitle 		=  CASE WHEN (@isFormView = 1) THEN @malTitle WHEN ((@isFormView = 0) AND (@malTitle='#M4PL#')) THEN NULL ELSE ISNULL(@malTitle, MalTitle) END   
           ,DateChanged 	=  @dateChanged  
           ,ChangedBy		=  @changedBy    
      WHERE Id =  @id
	SELECT syst.[Id]
      ,syst.[LangCode]
      ,syst.[SysRefId]
      ,syst.[MalOrder]
      ,syst.[MalTitle]
      ,syst.[DateEntered]
      ,syst.[EnteredBy]
      ,syst.[DateChanged]
      ,syst.[ChangedBy]
  FROM [dbo].[SYSTM010MenuAccessLevel] syst
 WHERE [Id]=@id  
END TRY       
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdMenuDriver]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan   
-- Create date:               08/16/2018      
-- Description:               Upd a Org Ref Role  
-- Execution:                 EXEC [dbo].[UpdMenuDriver]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[UpdMenuDriver]      
	@userId BIGINT  
	,@roleId BIGINT  
	,@entity NVARCHAR(100)  
	,@langCode NVARCHAR(10)  
	,@id BIGINT   
	,@mnuModuleId BIGINT = NULL  
	,@mnuBreakDownStructure NVARCHAR(20) = NULL  
	,@mnuTableName NVARCHAR(100) = NULL  
	,@mnuTitle NVARCHAR(50) = NULL  
	,@mnuTabOver NVARCHAR(25) = NULL  
	,@mnuRibbon BIT = NULL  
	,@mnuMenuItem BIT = NULL  
	,@mnuExecuteProgram NVARCHAR(255) = NULL  
	,@mnuClassificationId BIGINT = NULL  
	,@mnuProgramTypeId BIGINT = NULL  
	,@mnuOptionLevelId BIGINT = NULL  
	,@mnuAccessLevelId BIGINT = NULL  
	,@statusId int = NULL  
	,@dateChanged DATETIME2(7) = NULL  
	,@changedBy NVARCHAR(50) = NULL  
	,@isFormView BIT = 0  
	,@moduleName NVARCHAR(50) = null  
AS  
BEGIN TRY                  
 SET NOCOUNT ON;     
 IF(ISNULL(@mnuModuleId,0) = 0 AND  LEN(@moduleName) > 0 AND NOT EXISTS(SELECT Id FROM  [SYSTM000Ref_Options] WHERE SysLookupId= 22 AND SysOptionName=@moduleName))
   BEGIN         
		DECLARE @order INT
		SELECT @order = MAX(SysSortOrder) FROM [SYSTM000Ref_Options] WHERE SysLookupId= 22;
			INSERT INTO [dbo].[SYSTM000Ref_Options]([SysLookupId],[SysLookupCode],[SysOptionName],[SysSortOrder],[SysDefault],[IsSysAdmin],[StatusId],[DateEntered],[EnteredBy])
				 VALUES(22,'MainModule',@moduleName,ISNULL(@order,0) +1,0,0,1,@dateChanged,@changedBy)
           SET @mnuModuleId = SCOPE_IDENTITY();
   END


  UPDATE [dbo].[SYSTM000MenuDriver]  
       SET   [LangCode]      =  CASE WHEN (@isFormView = 1) THEN @langCode WHEN ((@isFormView = 0) AND (@langCode='#M4PL#')) THEN LangCode ELSE ISNULL(@langCode, LangCode)  END  
   ,[MnuBreakDownStructure]  =  CASE WHEN (@isFormView = 1) THEN @mnuBreakDownStructure WHEN ((@isFormView = 0) AND (@mnuBreakDownStructure='#M4PL#')) THEN NULL ELSE ISNULL(@mnuBreakDownStructure, MnuBreakDownStructure) END  
   ,[MnuModuleId]     =  CASE WHEN (@isFormView = 1) THEN @mnuModuleId WHEN ((@isFormView = 0) AND (@mnuModuleId=-100)) THEN NULL ELSE ISNULL(@mnuModuleId, MnuModuleId) END  
   ,[MnuTableName]     =  CASE WHEN (@isFormView = 1) THEN @mnuTableName WHEN ((@isFormView = 0) AND (@mnuTableName='#M4PL#')) THEN NULL ELSE ISNULL(@mnuTableName, MnuTableName) END  
   ,[MnuTitle]               =  CASE WHEN (@isFormView = 1) THEN @mnuTitle WHEN ((@isFormView = 0) AND (@mnuTitle='#M4PL#')) THEN NULL ELSE ISNULL(@mnuTitle, MnuTitle) END  
   ,[MnuTabOver]             =  CASE WHEN (@isFormView = 1) THEN @mnuTabOver WHEN ((@isFormView = 0) AND (@mnuTabOver='#M4PL#')) THEN NULL ELSE ISNULL(@mnuTabOver, MnuTabOver) END  
   ,[MnuRibbon]              =  ISNULL(@mnuRibbon, MnuRibbon)  
   ,[MnuMenuItem]            =  ISNULL(@mnuMenuItem, MnuMenuItem)  
   ,[MnuExecuteProgram]      =  CASE WHEN (@isFormView = 1) THEN @mnuExecuteProgram WHEN ((@isFormView = 0) AND (@mnuExecuteProgram='#M4PL#')) THEN NULL ELSE ISNULL(@mnuExecuteProgram, MnuExecuteProgram) END  
   ,[MnuClassificationId]    =  CASE WHEN (@isFormView = 1) THEN @mnuClassificationId WHEN ((@isFormView = 0) AND (@mnuClassificationId=-100)) THEN NULL ELSE ISNULL(@mnuClassificationId, MnuClassificationId) END  
   ,[MnuProgramTypeId]       =  CASE WHEN (@isFormView = 1) THEN @mnuProgramTypeId WHEN ((@isFormView = 0) AND (@mnuProgramTypeId=-100)) THEN NULL ELSE ISNULL(@mnuProgramTypeId, MnuProgramTypeId) END  
   ,[MnuOptionLevelId]       =  CASE WHEN (@isFormView = 1) THEN @mnuOptionLevelId WHEN ((@isFormView = 0) AND (@mnuOptionLevelId=-100)) THEN NULL ELSE ISNULL(@mnuOptionLevelId, MnuOptionLevelId) END  
   ,[MnuAccessLevelId]       =  CASE WHEN (@isFormView = 1) THEN @mnuAccessLevelId WHEN ((@isFormView = 0) AND (@mnuAccessLevelId=-100)) THEN NULL ELSE ISNULL(@mnuAccessLevelId, MnuAccessLevelId) END  
   ,[StatusId]         =  CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END  
   ,[DateChanged]            =  @dateChanged  
   ,[ChangedBy]              =  @changedBy      
     WHERE   [Id] = @id     
 SELECT mnu.[Id]  
  ,mnu.[LangCode]   
  ,mnu.[MnuModuleId]  
  ,mnu.[MnuTableName]  
  ,mnu.[MnuBreakDownStructure]  
  ,mnu.[MnuTitle]  
  ,mnu.[MnuTabOver]  
  ,mnu.[MnuMenuItem]  
  ,mnu.[MnuRibbon]  
  ,mnu.[MnuRibbonTabName]  
  ,mnu.[MnuIconVerySmall]  
  ,mnu.[MnuIconSmall]  
  ,mnu.[MnuIconMedium]  
  ,mnu.[MnuIconLarge]  
  ,mnu.[MnuExecuteProgram]  
  ,mnu.[MnuClassificationId]  
  ,mnu.[MnuProgramTypeId]  
  ,mnu.[MnuOptionLevelId]  
  ,mnu.[MnuAccessLevelId]  
  ,mnu.[MnuHelpFile]  
  ,mnu.[MnuHelpBookMark]  
  ,mnu.[MnuHelpPageNumber]    ,mnu.[StatusId]  
  ,mnu.[DateEntered]  
  ,mnu.[DateChanged]  
  ,mnu.[EnteredBy]  
  ,mnu.[ChangedBy]  
 FROM [dbo].[SYSTM000MenuDriver] (NOLOCK) mnu  
 WHERE mnu.[LangCode] = @langCode   
 AND mnu.Id=@id  
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdMenuOptionLevel]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan   
-- Create date:               08/16/2018      
-- Description:               Upd a Sys menu Option level
-- Execution:                 EXEC [dbo].[UpdMenuOptionLevel]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[UpdMenuOptionLevel]		  
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@langCode NVARCHAR(10)
	,@id INT
	,@sysRefId INt
	,@molOrder int = NULL 
	,@molMenuLevelTitle nvarchar(50) = NULL 
	,@molMenuAccessDefault int = NULL 
	,@molMenuAccessOnly bit = NULL  
	,@dateChanged datetime2(7) = NULL 
	,@changedBy nvarchar(50) = NULL
	,@isFormView BIT = 0
AS
BEGIN TRY                
 SET NOCOUNT ON;   
   UPDATE [dbo].[SYSTM010MenuOptionLevel]
     SET    LangCode 			 = CASE WHEN (@isFormView = 1) THEN @langCode WHEN ((@isFormView = 0) AND (@langCode='#M4PL#')) THEN LangCode ELSE ISNULL(@langCode, LangCode)  END  
           ,SysRefId 			 = @sysRefId   
           ,MolOrder 			 = CASE WHEN (@isFormView = 1) THEN @molOrder WHEN ((@isFormView = 0) AND (@molOrder=-100)) THEN NULL ELSE ISNULL(@molOrder, MolOrder) END
           ,MolMenuLevelTitle 	 = CASE WHEN (@isFormView = 1) THEN @molMenuLevelTitle WHEN ((@isFormView = 0) AND (@molMenuLevelTitle='#M4PL#')) THEN NULL ELSE ISNULL(@molMenuLevelTitle, MolMenuLevelTitle) END
           ,MolMenuAccessDefault = CASE WHEN (@isFormView = 1) THEN @molMenuAccessDefault WHEN ((@isFormView = 0) AND (@molMenuAccessDefault=-100)) THEN NULL ELSE ISNULL(@molMenuAccessDefault, MolMenuAccessDefault) END 
           ,MolMenuAccessOnly  	 = ISNULL(@molMenuAccessOnly, MolMenuAccessOnly)
           ,DateChanged 		 = @dateChanged  
           ,ChangedBy			 = @changedBy    
      WHERE Id = @id
	SELECT syst.[Id]
      ,syst.[LangCode]
      ,syst.[SysRefId]
      ,syst.[MolOrder]
      ,syst.[MolMenuLevelTitle]
      ,syst.[MolMenuAccessDefault]
      ,syst.[MolMenuAccessOnly]
      ,syst.[DateEntered]
      ,syst.[EnteredBy]
      ,syst.[DateChanged]
      ,syst.[ChangedBy]
  FROM [dbo].[SYSTM010MenuOptionLevel] syst
 WHERE [Id]=@id 
END TRY   
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdMessageType]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan   
-- Create date:               09/22/2018      
-- Description:               Upd a message type 
-- Execution:                 EXEC [dbo].[UpdMessageType]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[UpdMessageType]
	(@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@langCode NVARCHAR(10)
	,@id bigint
	,@sysRefId int
	,@sysMsgtypeTitle nvarchar(50)
	,@statusId int = NULL
	,@dateChanged datetime2(7) = NULL
	,@changedBy nvarchar(50) = NULL
	,@isFormView BIT = 0) 
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 UPDATE [dbo].[SYSMS010Ref_MessageTypes]
		SET  [LangCode]              =  CASE WHEN (@isFormView = 1) THEN @langCode WHEN ((@isFormView = 0) AND (@langCode='#M4PL#')) THEN LangCode ELSE ISNULL(@langCode, LangCode)  END
			,[SysRefId]              =  @sysRefId
			,[SysMsgtypeTitle]       =  @sysMsgtypeTitle
			,[StatusId]		         =  CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
			,[DateChanged]           =  @dateChanged
			,[ChangedBy]             =  @changedBy
	 WHERE	 [Id] = @id
	SELECT syst.[Id]
		,syst.[LangCode]
		,syst.[SysRefId]
		,syst.[SysMsgtypeTitle]
		,syst.[StatusId]
		,syst.[DateEntered]
		,syst.[EnteredBy]
		,syst.[DateChanged]
		,syst.[ChangedBy]
  FROM [dbo].[SYSMS010Ref_MessageTypes] syst
 WHERE [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdOrgActRole]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan   
-- Create date:               08/16/2018      
-- Description:               Upd a Org act role 
-- Execution:                 EXEC [dbo].[UpdOrgActRole]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================     
ALTER PROCEDURE  [dbo].[UpdOrgActRole]      
	@userId BIGINT  
	,@roleId BIGINT  
	,@entity NVARCHAR(100)  
	,@id BIGINT   
	,@orgId BIGINT = NULL  
	,@orgRoleSortOrder INT  = NULL  
	,@orgRefRoleId BIGINT = NULL   
	,@orgRoleDefault BIT  = NULL  
	,@orgRoleTitle NVARCHAR(50)  = NULL  
	,@orgRoleContactId BIGINT  = NULL  
	,@roleTypeId INT  = NULL  
	,@orgLogical BIT  = NULL  
	,@prgLogical BIT  = NULL  
	,@prjLogical BIT  = NULL  
	,@phsLogical BIT  = NULL  
	,@jobLogical BIT  = NULL  
	,@prxContactDefault BIT  = NULL  
	,@prxJobDefaultAnalyst BIT  = NULL  
	,@prxJobDefaultResponsible BIT  = NULL  
	,@prxJobGWDefaultAnalyst BIT  = NULL  
	,@prxJobGWDefaultResponsible BIT  = NULL  
	,@statusId INT = NULL
	,@dateChanged DATETIME2(7)  = NULL  
	,@changedBy NVARCHAR(50)  = NULL 
	,@isFormView BIT = 0
AS  
BEGIN TRY                  
 SET NOCOUNT ON;
  DECLARE @updatedItemNumber INT 
  DECLARE @oldContactId BIGINT = NULL
  EXEC [dbo].[ResetItemNumber] @userId, @id, @orgId, @entity, @orgRoleSortOrder, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT
	  SELECT @oldContactId=OrgRoleContactId FROM [dbo].[ORGAN020Act_Roles] WHERE Id = @id AND OrgID = @orgId
  
	IF(ISNULL(@oldContactId, 0) < 1) -- If no contact present then add security for it in actrole security
		BEGIN
			EXEC [dbo].[CopyActRoleContactSecurity] @orgId, @orgRefRoleId, @id, @orgRoleContactId, @changedBy
		END
	ELSE IF(ISNULL(@orgRoleContactId, 0) > 0) 
		BEGIN
		  UPDATE [dbo].[ORGAN021Act_SecurityByRole] SET [ContactId] = @orgRoleContactId  WHERE OrgId = @orgId AND OrgActRoleId = @id
		END
      
  UPDATE [dbo].[ORGAN020Act_Roles]  
    SET     OrgId						= CASE WHEN (@isFormView = 1) THEN @orgId WHEN ((@isFormView = 0) AND (@orgId=-100)) THEN NULL ELSE ISNULL(@orgId, OrgId) END 
           ,OrgRoleSortOrder			= CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, OrgRoleSortOrder) END  
           ,[OrgRefRoleId]				= CASE WHEN (@isFormView = 1) THEN @orgRefRoleId WHEN ((@isFormView = 0) AND (@orgRefRoleId=-100)) THEN NULL ELSE ISNULL(@orgRefRoleId, [OrgRefRoleId]) END  
           ,OrgRoleDefault				= ISNULL(@orgRoleDefault, OrgRoleDefault)  
           ,OrgRoleTitle				= CASE WHEN (@isFormView = 1) THEN @orgRoleTitle WHEN ((@isFormView = 0) AND (@orgRoleTitle='#M4PL#')) THEN NULL ELSE ISNULL(@orgRoleTitle, OrgRoleTitle) END  
           ,OrgRoleContactId			= CASE WHEN (@isFormView = 1) THEN @orgRoleContactId WHEN ((@isFormView = 0) AND (@orgRoleContactId=-100)) THEN NULL ELSE ISNULL(@orgRoleContactId, OrgRoleContactId) END  
           ,RoleTypeId					= CASE WHEN (@isFormView = 1) THEN @roleTypeId WHEN ((@isFormView = 0) AND (@roleTypeId=-100)) THEN NULL ELSE ISNULL(@roleTypeId, RoleTypeId) END  
           ,OrgLogical					= ISNULL(@orgLogical, OrgLogical)  
           ,PrgLogical					= ISNULL(@prgLogical, PrgLogical)  
           ,PrjLogical					= ISNULL(@prjLogical, PrjLogical)  
           ,PhsLogical					= ISNULL(@phsLogical, PhsLogical)  
           ,JobLogical					= ISNULL(@jobLogical, JobLogical)  
           ,PrxContactDefault			= ISNULL(@prxContactDefault, PrxContactDefault)  
           ,PrxJobDefaultAnalyst		= ISNULL(@prxJobDefaultAnalyst, PrxJobDefaultAnalyst)  
		   ,PrxJobDefaultResponsible		= ISNULL(@prxJobDefaultResponsible, PrxJobDefaultResponsible)  
           ,PrxJobGWDefaultAnalyst		= ISNULL(@prxJobGWDefaultAnalyst, PrxJobGWDefaultAnalyst)  
           ,PrxJobGWDefaultResponsible  = ISNULL(@prxJobGWDefaultResponsible, PrxJobGWDefaultResponsible)     
           ,StatusId					= CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END     
           ,DateChanged					= @dateChanged    
           ,ChangedBy					= @changedBy     
     WHERE Id = @id  ;

 
  EXEC [dbo].[GetOrgActRole] @userId, @roleId, @orgId, @id


END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdOrgActSecurityByRole]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan   
-- Create date:               08/16/2018      
-- Description:               Upd a org act security by role 
-- Execution:                 EXEC [dbo].[UpdOrgActSecurityByRole]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================     
ALTER PROCEDURE  [dbo].[UpdOrgActSecurityByRole]
	(@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id bigint
	,@orgId bigint = NULL
	,@secLineOrder int  = NULL
	,@mainModuleId int = NULL
	,@menuOptionLevelId int = NULL
	,@menuAccessLevelId int = NULL
	,@statusId int = NULL
	,@actRoleId BIGINT = NULL
	,@dateChanged datetime2(7) = NULL
	,@changedBy nvarchar(50) = NULL
	,@isFormView BIT = 0) 
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 DECLARE @updatedItemNumber INT      
 DECLARE @savedRoleCode NVARCHAR(25)
 DECLARE @where NVARCHAR(MAX) = ' AND [OrgActRoleId]=' +  CAST(@actRoleId AS VARCHAR)     
 EXEC [dbo].[ResetItemNumber] @userId, @id, @orgId, @entity, @secLineOrder, @statusId, NULL, @where,  @updatedItemNumber OUTPUT  

 UPDATE [dbo].[ORGAN021Act_SecurityByRole]
		SET  [OrgId]                 = CASE WHEN (@isFormView = 1) THEN @orgId WHEN ((@isFormView = 0) AND (@orgId=-100)) THEN NULL ELSE ISNULL(@orgId, OrgId) END
			,[SecLineOrder]          = CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, SecLineOrder) END
			,[SecMainModuleId]       = CASE WHEN (@isFormView = 1) THEN @mainModuleId WHEN ((@isFormView = 0) AND (@mainModuleId=-100)) THEN NULL ELSE ISNULL(@mainModuleId, SecMainModuleId) END
			,[SecMenuOptionLevelId]  = CASE WHEN (@isFormView = 1) THEN @menuOptionLevelId WHEN ((@isFormView = 0) AND (@menuOptionLevelId=-100)) THEN NULL ELSE ISNULL(@menuOptionLevelId, SecMenuOptionLevelId) END
			,[SecMenuAccessLevelId]  = CASE WHEN (@isFormView = 1) THEN @menuAccessLevelId WHEN ((@isFormView = 0) AND (@menuAccessLevelId=-100)) THEN NULL ELSE ISNULL(@menuAccessLevelId, SecMenuAccessLevelId) END
			,[StatusId]			     = CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
			,[DateChanged]           = @dateChanged
			,[ChangedBy]             = @changedBy
	 WHERE	 [Id] = @id

	EXECUTE  GetOrgActSecurityByRole @userId,@roleId,@orgId,@id;
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdOrgActSubSecurityByRole]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan   
-- Create date:               08/16/2018      
-- Description:               Upd a org act subsecurity by role 
-- Execution:                 EXEC [dbo].[UpdOrgActSubSecurityByRole]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================   
ALTER PROCEDURE  [dbo].[UpdOrgActSubSecurityByRole]
	(@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id bigint
	,@secByRoleId bigint = NULL
	,@refTableName nvarchar(100) = NULL
	,@menuOptionLevelId int = NULL
	,@menuAccessLevelId int = NULL
	,@statusId int = NULL
	,@dateChanged datetime2(7) = NULL
	,@changedBy nvarchar(50) = NULL
	,@isFormView BIT = 0) 
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 UPDATE [dbo].[ORGAN022Act_SubSecurityByRole]
		SET  [OrgSecurityByRoleId]		= CASE WHEN (@isFormView = 1) THEN @secByRoleId WHEN ((@isFormView = 0) AND (@secByRoleId=-100)) THEN NULL ELSE ISNULL(@secByRoleId, [OrgSecurityByRoleId]) END
			,[RefTableName]				= CASE WHEN (@isFormView = 1) THEN @refTableName WHEN ((@isFormView = 0) AND (@refTableName='#M4PL#')) THEN NULL ELSE ISNULL(@refTableName, RefTableName) END
			,[SubsMenuOptionLevelId]	= CASE WHEN (@isFormView = 1) THEN @menuOptionLevelId WHEN ((@isFormView = 0) AND (@menuOptionLevelId=-100)) THEN NULL ELSE ISNULL(@menuOptionLevelId,SubsMenuOptionLevelId) END
			,[SubsMenuAccessLevelId]	= CASE WHEN (@isFormView = 1) THEN @menuAccessLevelId WHEN ((@isFormView = 0) AND (@menuAccessLevelId=-100)) THEN NULL ELSE ISNULL(@menuAccessLevelId, SubsMenuAccessLevelId) END
			,[StatusId]					= CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
			,[DateChanged]				= @dateChanged
			,[ChangedBy]				= @changedBy
	 WHERE	 [Id] = @id
	SELECT syst.[Id]
		 ,syst.[OrgSecurityByRoleId]  
		  ,syst.[RefTableName]
		  ,syst.[SubsMenuOptionLevelId]  
		  ,syst.[SubsMenuAccessLevelId]  
		  ,syst.[StatusId]  
		  ,syst.[DateEntered]  
		  ,syst.[EnteredBy]  
		  ,syst.[DateChanged]  
		  ,syst.[ChangedBy]  
  FROM [dbo].[ORGAN022Act_SubSecurityByRole] syst  
 WHERE syst.[Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdOrganization]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan   
-- Create date:               08/16/2018      
-- Description:               Upd a organization
-- Execution:                 EXEC [dbo].[UpdOrganization]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[UpdOrganization]		  
	(@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id BIGINT 
	,@orgCode NVARCHAR(25) = NULL
	,@orgTitle NVARCHAR(50)  = NULL
	,@orgGroupId INT = NULL 
	,@orgSortOrder INT  = NULL
	,@statusId INT  = NULL
	,@dateChanged DATETIME2(7)  = NULL
	,@changedBy NVARCHAR(50)  = NULL
	,@orgContactId BIGINT  = NULL
	,@isFormView BIT = 0  )
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  DECLARE @updatedItemNumber INT      
  DECLARE @where NVARCHAR(MAX) = null

  DECLARE @isSysAdmin BIT
  SELECT @isSysAdmin = IsSysAdmin FROM SYSTM000OpnSezMe WHERE id=@userId;
  IF @isSysAdmin = 1 
  BEGIN
     EXEC [dbo].[ResetItemNumber] @userId, @id, NULL, @entity, @orgSortOrder, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT  
  END  
    
  

   UPDATE   [dbo].[ORGAN000Master]
    SET     OrgCode 		=  CASE WHEN (@isFormView = 1) THEN @orgCode WHEN ((@isFormView = 0) AND (@orgCode='#M4PL#')) THEN NULL ELSE ISNULL(@orgCode, OrgCode) END
           ,OrgTitle 		=  CASE WHEN (@isFormView = 1) THEN @orgTitle WHEN ((@isFormView = 0) AND (@orgTitle='#M4PL#')) THEN NULL ELSE ISNULL(@orgTitle, OrgTitle) END
           ,OrgGroupId 		=  CASE WHEN (@isFormView = 1) THEN @orgGroupId WHEN ((@isFormView = 0) AND (@orgGroupId=-100)) THEN NULL ELSE ISNULL(@orgGroupId, OrgGroupId) END	
           ,OrgSortOrder 	=  CASE WHEN @isSysAdmin = 1 THEN  
		                                                  CASE WHEN (@isFormView = 1) THEN @updatedItemNumber 
														       WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL 
															   ELSE ISNULL(@updatedItemNumber, OrgSortOrder) END 
		                            ELSE OrgSortOrder  END
           ,StatusId 		=  CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
           ,OrgContactId 	=  CASE WHEN (@isFormView = 1) THEN @orgContactId WHEN ((@isFormView = 0) AND (@orgContactId=-100)) THEN NULL ELSE ISNULL(@orgContactId, OrgContactId) END
           ,DateChanged 	=  @dateChanged  
           ,ChangedBy		=  @changedBy 
   WHERE	Id   =  @id
	 EXEC [dbo].[GetOrganization] @userId , @orgCode, @id, @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdOrgCredential]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Upd a org Credential
-- Execution:                 EXEC [dbo].[UpdOrgCredential]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[UpdOrgCredential]		  
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id BIGINT 
	,@orgId BIGINT = NULL
	,@creItemNumber INT = NULL 
	,@creCode NVARCHAR(20) = NULL 
	,@creTitle NVARCHAR(50) = NULL 
	,@statusId INT = NULL
	,@creExpDate DATETIME2(7) = NULL 
	,@dateChanged DATETIME2(7) = NULL 
	,@changedBy NVARCHAR(50) = NULL  
	,@isFormView BIT = 0
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 DECLARE @updatedItemNumber INT      
 EXEC [dbo].[ResetItemNumber] @userId, @id, @orgId, @entity, @creItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT 
  UPDATE  [dbo].[ORGAN030Credentials]
   SET   OrgId 			  = CASE WHEN (@isFormView = 1) THEN @orgId WHEN ((@isFormView = 0) AND (@orgId=-100)) THEN NULL ELSE ISNULL(@orgId, OrgId) END
        ,CreItemNumber 	  = CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, CreItemNumber)  END
        ,CreCode 		  = CASE WHEN (@isFormView = 1) THEN @creCode WHEN ((@isFormView = 0) AND (@creCode='#M4PL#')) THEN NULL ELSE ISNULL(@creCode, CreCode) END
        ,CreTitle 		  = CASE WHEN (@isFormView = 1) THEN @creTitle WHEN ((@isFormView = 0) AND (@creTitle='#M4PL#')) THEN NULL ELSE ISNULL(@creTitle, CreTitle) END
        ,CreExpDate 	  = CASE WHEN (@isFormView = 1) THEN @creExpDate WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @creExpDate, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@creExpDate, CreExpDate ) END
        ,StatusId	 	  = CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId ) END
        ,DateChanged	  = @dateChanged  
        ,ChangedBy		  = @changedBy
  WHERE  Id = @id  
 EXEC [dbo].[GetOrgCredential] @userId, @roleId, @orgId, @id

	 END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdOrgFinacialCalender]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Upd a org finacial cal
-- Execution:                 EXEC [dbo].[UpdOrgFinacialCalender]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[UpdOrgFinacialCalender]		  
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id BIGINT 
	,@orgId BIGINT = NULL
	,@fclPeriod INT = NULL 
	,@fclPeriodCode NVARCHAR(20)  = NULL
	,@fclPeriodStart DATETIME2(7)  = NULL
	,@fclPeriodEnd DATETIME2(7)  = NULL
	,@fclPeriodTitle NVARCHAR(50)  = NULL
	,@fclAutoShortCode NVARCHAR(15)  = NULL
	,@fclWorkDays INT  = NULL
	,@finCalendarTypeId BIGINT  = NULL
	,@statusId INT = NULL
	,@dateChanged DATETIME2(7)  = NULL
	,@changedBy NVARCHAR(50)  = NULL
	,@isFormView BIT = 0
AS
BEGIN TRY                
 SET NOCOUNT ON;   
   DECLARE @updatedItemNumber INT      
 EXEC [dbo].[ResetItemNumber] @userId, @id, @orgId, @entity, @fclPeriod, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT 


    UPDATE [dbo].[ORGAN020Financial_Cal]
     SET   OrgId 				= CASE WHEN (@isFormView = 1) THEN @orgId WHEN ((@isFormView = 0) AND (@orgId=-100)) THEN NULL ELSE ISNULL(@orgId, OrgId) END 
          ,FclPeriod 			= CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, FclPeriod) END  
          ,FclPeriodCode 		= CASE WHEN (@isFormView = 1) THEN @fclPeriodCode WHEN ((@isFormView = 0) AND (@fclPeriodCode='#M4PL#')) THEN NULL ELSE ISNULL(@fclPeriodCode, FclPeriodCode) END 
          ,FclPeriodStart 		= CASE WHEN (@isFormView = 1) THEN @fclPeriodStart WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @fclPeriodStart, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@fclPeriodStart, FclPeriodStart) END 
          ,FclPeriodEnd 		= CASE WHEN (@isFormView = 1) THEN @fclPeriodEnd WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @fclPeriodEnd, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@fclPeriodEnd, FclPeriodEnd) END 
          ,FclPeriodTitle 		= CASE WHEN (@isFormView = 1) THEN @fclPeriodTitle WHEN ((@isFormView = 0) AND (@fclPeriodTitle='#M4PL#')) THEN NULL ELSE ISNULL(@fclPeriodTitle, FclPeriodTitle) END 
          ,FclAutoShortCode		= CASE WHEN (@isFormView = 1) THEN @fclAutoShortCode WHEN ((@isFormView = 0) AND (@fclAutoShortCode='#M4PL#')) THEN NULL ELSE ISNULL(@fclAutoShortCode, FclAutoShortCode) END  
          ,FclWorkDays 			= CASE WHEN (@isFormView = 1) THEN @fclWorkDays WHEN ((@isFormView = 0) AND (@fclWorkDays=-100)) THEN NULL ELSE ISNULL(@fclWorkDays, FclWorkDays) END 
          ,FinCalendarTypeId 	= CASE WHEN (@isFormView = 1) THEN @finCalendarTypeId WHEN ((@isFormView = 0) AND (@finCalendarTypeId=-100)) THEN NULL ELSE ISNULL(@finCalendarTypeId, FinCalendarTypeId) END
          ,StatusId		 		= CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END    
          ,DateChanged 			= @dateChanged  
          ,ChangedBy			= @changedBy 
     WHERE Id 	= @id
 EXEC [dbo].[GetOrgFinacialCalender] @userId, @roleId, @orgId, @id

   END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdOrgMarketSupport]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Upd a Org mrkt org Support
-- Execution:                 EXEC [dbo].[UpdOrgMarketSupport]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[UpdOrgMarketSupport]		  
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id BIGINT 
	,@orgId BIGINT = NULL
	,@mrkOrder INT  = NULL
	,@mrkCode NVARCHAR(20)  = NULL
	,@mrkTitle NVARCHAR(50)  = NULL
	,@dateChanged DATETIME2(7)  = NULL
	,@changedBy NVARCHAR(50) = NULL
	,@isFormView BIT = 0
AS
BEGIN TRY                
 SET NOCOUNT ON;
   DECLARE @updatedItemNumber INT      
EXEC [dbo].[ResetItemNumber] @userId, @id, @orgId, @entity, @mrkOrder, NULL, NULL, NULL,  @updatedItemNumber OUTPUT  
    
   UPDATE [dbo].[ORGAN002MRKT_OrgSupport]
     SET    OrgId 			 = CASE WHEN (@isFormView = 1) THEN @orgId WHEN ((@isFormView = 0) AND (@orgId=-100)) THEN NULL ELSE ISNULL(@orgId, OrgId) END
           ,MrkOrder 		 = CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, MrkOrder) END
           ,MrkCode 		 = CASE WHEN (@isFormView = 1) THEN @mrkCode WHEN ((@isFormView = 0) AND (@mrkCode='#M4PL#')) THEN NULL ELSE ISNULL(@mrkCode, MrkCode) END
           ,MrkTitle 		 = CASE WHEN (@isFormView = 1) THEN @mrkTitle WHEN ((@isFormView = 0) AND (@mrkTitle='#M4PL#')) THEN NULL ELSE ISNULL(@mrkTitle, MrkTitle) END
           ,DateChanged 	 = @dateChanged 
           ,ChangedBy		 = @changedBy
 EXEC [dbo].[GetOrgMarketSupport] @userId, @roleId, @orgId, @id

  END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdOrgPocContact]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Upd a org POC contact
-- Execution:                 EXEC [dbo].[UpdOrgPocContact]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[UpdOrgPocContact] 	  
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id BIGINT 
	,@orgId BIGINT = NULL
	,@contactId BIGINT = NULL
	,@pocCode NVARCHAR(20) = NULL
	,@pocTitle NVARCHAR(50) = NULL
	,@pocTypeId INT = NULL
	,@pocDefault BIT = NULL
	,@statusId INT = NULL
	,@dateChanged DATETIME2(7) = NULL
	,@changedBy NVARCHAR(50) = NULL
	,@pocSortOrder INT = NULL
	,@isFormView BIT = 0
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  DECLARE @updatedItemNumber INT      
  EXEC [dbo].[ResetItemNumber] @userId, @id, @orgId, @entity, @pocSortOrder, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT

  UPDATE  [dbo].[ORGAN001POC_Contacts]
      SET  OrgId 		    = CASE WHEN (@isFormView = 1) THEN @orgId WHEN ((@isFormView = 0) AND (@orgId=-100)) THEN NULL ELSE ISNULL(@orgId, OrgId) END
          ,ContactID 		= CASE WHEN (@isFormView = 1) THEN @contactId WHEN ((@isFormView = 0) AND (@contactId=-100)) THEN NULL ELSE ISNULL(@contactId, ContactID) END
          ,PocCode 		    = CASE WHEN (@isFormView = 1) THEN @pocCode WHEN ((@isFormView = 0) AND (@pocCode='#M4PL#')) THEN NULL ELSE ISNULL(@pocCode, PocCode) END
          ,PocTitle 	    = CASE WHEN (@isFormView = 1) THEN @pocTitle WHEN ((@isFormView = 0) AND (@pocTitle='#M4PL#')) THEN NULL ELSE ISNULL(@pocTitle, PocTitle) END
          ,PocTypeId 		= CASE WHEN (@isFormView = 1) THEN @pocTypeId WHEN ((@isFormView = 0) AND (@pocTypeId=-100)) THEN NULL ELSE ISNULL(@pocTypeId, PocTypeId) END
          ,PocDefault 	    = ISNULL(@pocDefault, PocDefault)
          ,PocSortOrder 	= CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, PocSortOrder) END
          ,StatusId		 	= CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
          ,DateChanged		= @dateChanged  
          ,ChangedBy		= @changedBy  
	 WHERE Id = @id

   EXEC [dbo].[GetOrgPocContact] @userId, @roleId, @orgId, @id

	END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdOrgRefRole]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Upd a Org Ref Role
-- Execution:                 EXEC [dbo].[UpdOrgRefRole]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[UpdOrgRefRole]		  
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id BIGINT 
	,@orgId BIGINT = NULL
	,@orgRoleSortOrder INT = NULL 
	,@orgRoleCode NVARCHAR(25) = NULL 
	,@orgRoleDefault BIT = NULL 
	,@orgRoleTitle NVARCHAR(50) = NULL 
	,@orgRoleContactId BIGINT = NULL 
	,@roleTypeId INT = NULL 
	,@orgLogical BIT = NULL 
	,@prgLogical BIT = NULL 
	,@prjLogical BIT  = NULL
	,@jobLogical BIT = NULL 
	,@prxContactDefault BIT = NULL 
	,@prxJobDefaultAnalyst BIT  = NULL
	,@prxJobDefaultResponsible BIT  = NULL  
	,@prxJobGWDefaultAnalyst BIT  = NULL
	,@prxJobGWDefaultResponsible BIT  = NULL
	,@dateChanged DATETIME2(7)  = NULL
	,@changedBy NVARCHAR(50) = NULL 
	,@phsLogical BIT  = NULL
	,@statusId INT = NULL
	,@isFormView BIT = 0
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  DECLARE @updatedItemNumber INT      
  EXEC [dbo].[ResetItemNumber] @userId, @id, NULL, @entity, @orgRoleSortOrder, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT  

  UPDATE [dbo].[ORGAN010Ref_Roles]
       SET     OrgId 						=	NULL
              ,OrgRoleSortOrder 			=	CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, OrgRoleSortOrder) END
              ,OrgRoleCode 					=	CASE WHEN (@isFormView = 1) THEN @orgRoleCode WHEN ((@isFormView = 0) AND (@orgRoleCode='#M4PL#')) THEN NULL ELSE ISNULL(@orgRoleCode, OrgRoleCode) END
              ,OrgRoleDefault 				=	ISNULL(@orgRoleDefault, OrgRoleDefault)
              ,OrgRoleTitle 				=	CASE WHEN (@isFormView = 1) THEN @orgRoleTitle WHEN ((@isFormView = 0) AND (@orgRoleTitle='#M4PL#')) THEN NULL ELSE ISNULL(@orgRoleTitle, OrgRoleTitle) END
              ,OrgRoleContactId 			=	CASE WHEN (@isFormView = 1) THEN @orgRoleContactId WHEN ((@isFormView = 0) AND (@orgRoleContactId=-100)) THEN NULL ELSE ISNULL(@orgRoleContactId, OrgRoleContactId) END
              ,RoleTypeId 					=	CASE WHEN (@isFormView = 1) THEN @roleTypeId WHEN ((@isFormView = 0) AND (@roleTypeId=-100)) THEN NULL ELSE ISNULL(@roleTypeId, RoleTypeId) END
              ,OrgLogical 					=	ISNULL(@orgLogical, OrgLogical)
              ,PrgLogical 					=	ISNULL(@prgLogical, PrgLogical)
              ,PrjLogical 					=	ISNULL(@PrjLogical, PrjLogical)
              ,JobLogical 					=	ISNULL(@jobLogical, JobLogical)
              ,PrxContactDefault 			=	ISNULL(@prxContactDefault, PrxContactDefault)
              ,PrxJobDefaultAnalyst 		=	ISNULL(@prxJobDefaultAnalyst, PrxJobDefaultAnalyst)
			  ,PrxJobDefaultResponsible 	=	ISNULL(@prxJobDefaultResponsible, PrxJobDefaultResponsible)
              ,PrxJobGWDefaultAnalyst 		=	ISNULL(@prxJobGWDefaultAnalyst, PrxJobGWDefaultAnalyst)
              ,PrxJobGWDefaultResponsible	=	ISNULL(@prxJobGWDefaultResponsible, PrxJobGWDefaultResponsible)  
              ,PhsLogical  					=	ISNULL(@phsLogical, PhsLogical)
              ,StatusId  					=	CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
              ,DateChanged 					=	@dateChanged  
              ,ChangedBy 					=	@changedBy 
     WHERE Id =	@id		
	 
	 --DECLARE @actRoleId BIGINT;
	 --SELECT @actRoleId = actRole.Id FROM [dbo].[ORGAN020Act_Roles] actRole WHERE actRole.OrgRefRoleId=@id AND actRole.OrgID=@orgId AND ISNULL(actRole.OrgRoleContactID,0) = 0
	 --IF(ISNULL(@orgRoleContactId,0)>0 AND ISNULL(@actRoleId, 0) > 0)
		-- BEGIN
		--  UPDATE [dbo].[ORGAN020Act_Roles]  SET OrgRoleContactID = @orgRoleContactId WHERE OrgRefRoleId=@id AND OrgID=@orgId AND ISNULL(OrgRoleContactID,0) = 0
		--  EXEC [dbo].[CopyActRoleContactSecurity] @orgId, @id, @actRoleId, @orgRoleContactId, @changedBy
		-- END
	  
 EXEC [dbo].[GetOrgRefRole] @userId, @roleId, @orgId, @id

END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdPrgEdiHeader]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Upd a Program EDI header
-- Execution:                 EXEC [dbo].[UpdPrgEdiHeader]
-- Modified Desc:             Added OrderType and SetPurpose fields
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)               05/10/2018
-- =============================================
ALTER PROCEDURE  [dbo].[UpdPrgEdiHeader]
	(@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id bigint
	,@pehProgramId bigint = NULL
	,@pehItemNumber int = NULL
	,@pehEdiCode nvarchar(20) = NULL
	,@pehEdiTitle nvarchar(50) = NULL
	,@pehTradingPartner nvarchar(20) = NULL
	,@pehEdiDocument nvarchar(20) = NULL
	,@pehEdiVersion nvarchar(20) = NULL
	,@pehSCACCode nvarchar(20) = NULL
	,@pehInsertCode   nvarchar(20)
	,@pehUpdateCode   nvarchar(20)
	,@pehCancelCode   nvarchar(20)
	,@pehHoldCode     nvarchar(20)
	,@pehOriginalCode nvarchar(20)
	,@pehReturnCode	  nvarchar(20)
	,@uDF01 nvarchar(20)
	,@uDF02 nvarchar(20)
	,@uDF03 nvarchar(20)
	,@uDF04 nvarchar(20)
	,@uDF05 nvarchar(20)
	,@uDF06 nvarchar(20)
	,@uDF07 nvarchar(20)
	,@uDF08 nvarchar(20)
	,@uDF09 nvarchar(20)
	,@uDF10 nvarchar(20)           
	,@pehAttachments int = NULL
	,@statusId int = NULL
	,@pehDateStart datetime2(7) = NULL
	,@pehDateEnd datetime2(7) = NULL
	,@pehSndRcv bit =NULL
	,@changedBy nvarchar(50) = NULL
	,@dateChanged datetime2(7) = NULL
	,@isFormView BIT = 0) 
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  DECLARE @updatedItemNumber INT      
  EXEC [dbo].[ResetItemNumber] @userId, @id, @pehProgramId, @entity, @pehItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT

 UPDATE [dbo].[PRGRM070EdiHeader]
		SET  [PehProgramID]          =  CASE WHEN (@isFormView = 1) THEN @pehProgramId WHEN ((@isFormView = 0) AND (@pehProgramId=-100)) THEN NULL ELSE ISNULL(@pehProgramId, PehProgramID) END
			,[PehItemNumber]         =  CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, PehItemNumber) END
			,[PehEdiCode]            =  CASE WHEN (@isFormView = 1) THEN @pehEdiCode WHEN ((@isFormView = 0) AND (@pehEdiCode='#M4PL#')) THEN NULL ELSE ISNULL(@pehEdiCode, PehEdiCode) END
			,[PehEdiTitle]           =  CASE WHEN (@isFormView = 1) THEN @pehEdiTitle WHEN ((@isFormView = 0) AND (@pehEdiTitle='#M4PL#')) THEN NULL ELSE ISNULL(@pehEdiTitle, PehEdiTitle) END
			,[PehTradingPartner]     =  CASE WHEN (@isFormView = 1) THEN @pehTradingPartner WHEN ((@isFormView = 0) AND (@pehTradingPartner='#M4PL#')) THEN NULL ELSE ISNULL(@pehTradingPartner, PehTradingPartner) END
			,[PehEdiDocument]        =  CASE WHEN (@isFormView = 1) THEN @pehEdiDocument WHEN ((@isFormView = 0) AND (@pehEdiDocument='#M4PL#')) THEN NULL ELSE ISNULL(@pehEdiDocument, PehEdiDocument) END
			,[PehEdiVersion]         =  CASE WHEN (@isFormView = 1) THEN @pehEdiVersion WHEN ((@isFormView = 0) AND (@pehEdiVersion='#M4PL#')) THEN NULL ELSE ISNULL(@pehEdiVersion, PehEdiVersion) END
			,[PehSCACCode]           =  CASE WHEN (@isFormView = 1) THEN @pehSCACCode WHEN ((@isFormView = 0) AND (@pehSCACCode='#M4PL#')) THEN NULL ELSE ISNULL(@pehSCACCode, PehSCACCode) END
			,[PehInsertCode]         =  CASE WHEN (@isFormView = 1) THEN @pehInsertCode WHEN ((@isFormView = 0) AND (@pehInsertCode='#M4PL#')) THEN NULL ELSE ISNULL(@pehInsertCode, PehInsertCode) END
			,[PehUpdateCode]         =  CASE WHEN (@isFormView = 1) THEN @pehUpdateCode WHEN ((@isFormView = 0) AND (@pehUpdateCode='#M4PL#')) THEN NULL ELSE ISNULL(@pehUpdateCode, PehUpdateCode) END
			,[PehCancelCode]         =  CASE WHEN (@isFormView = 1) THEN @pehCancelCode WHEN ((@isFormView = 0) AND (@pehCancelCode='#M4PL#')) THEN NULL ELSE ISNULL(@pehCancelCode, PehCancelCode) END
			,[PehHoldCode]           =  CASE WHEN (@isFormView = 1) THEN @pehHoldCode WHEN ((@isFormView = 0) AND (@pehHoldCode='#M4PL#')) THEN NULL ELSE ISNULL(@pehHoldCode, PehHoldCode) END
			,[PehOriginalCode]       =  CASE WHEN (@isFormView = 1) THEN @pehOriginalCode WHEN ((@isFormView = 0) AND (@pehOriginalCode='#M4PL#')) THEN NULL ELSE ISNULL(@pehOriginalCode, PehOriginalCode) END
			,[PehReturnCode]         =  CASE WHEN (@isFormView = 1) THEN @pehReturnCode WHEN ((@isFormView = 0) AND (@pehReturnCode='#M4PL#')) THEN NULL ELSE ISNULL(@pehReturnCode, PehReturnCode) END
			,[UDF01]         =  CASE WHEN (@isFormView = 1) THEN @uDF01 WHEN ((@isFormView = 0) AND (@uDF01='#M4PL#')) THEN NULL ELSE ISNULL(@uDF01, UDF01) END
			,[UDF02]         =  CASE WHEN (@isFormView = 1) THEN @uDF02 WHEN ((@isFormView = 0) AND (@uDF02='#M4PL#')) THEN NULL ELSE ISNULL(@uDF02, UDF02) END
			,[UDF03]         =  CASE WHEN (@isFormView = 1) THEN @uDF03 WHEN ((@isFormView = 0) AND (@uDF03='#M4PL#')) THEN NULL ELSE ISNULL(@uDF03, UDF03) END
			,[UDF04]         =  CASE WHEN (@isFormView = 1) THEN @uDF04 WHEN ((@isFormView = 0) AND (@uDF04='#M4PL#')) THEN NULL ELSE ISNULL(@uDF04, UDF04) END
			,[UDF05]         =  CASE WHEN (@isFormView = 1) THEN @uDF05 WHEN ((@isFormView = 0) AND (@uDF05='#M4PL#')) THEN NULL ELSE ISNULL(@uDF05, UDF05) END
			,[UDF06]         =  CASE WHEN (@isFormView = 1) THEN @uDF06 WHEN ((@isFormView = 0) AND (@uDF06='#M4PL#')) THEN NULL ELSE ISNULL(@uDF06, UDF06) END
			,[UDF07]         =  CASE WHEN (@isFormView = 1) THEN @uDF07 WHEN ((@isFormView = 0) AND (@uDF07='#M4PL#')) THEN NULL ELSE ISNULL(@uDF07, UDF07) END
			,[UDF08]         =  CASE WHEN (@isFormView = 1) THEN @uDF08 WHEN ((@isFormView = 0) AND (@uDF08='#M4PL#')) THEN NULL ELSE ISNULL(@uDF08, UDF08) END
			,[UDF09]         =  CASE WHEN (@isFormView = 1) THEN @uDF09 WHEN ((@isFormView = 0) AND (@uDF09='#M4PL#')) THEN NULL ELSE ISNULL(@uDF09, UDF09) END
			,[UDF10]         =  CASE WHEN (@isFormView = 1) THEN @uDF10 WHEN ((@isFormView = 0) AND (@uDF10='#M4PL#')) THEN NULL ELSE ISNULL(@uDF10, UDF10) END
			

			--,[PehAttachments]        =  CASE WHEN (@isFormView = 1) THEN @pehAttachments WHEN ((@isFormView = 0) AND (@pehAttachments=-100)) THEN NULL ELSE ISNULL(@pehAttachments, PehAttachments) END
			,[StatusId]              =  CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
			,[PehDateStart]          =  CASE WHEN (@isFormView = 1) THEN @pehDateStart WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @pehDateStart, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@pehDateStart, PehDateStart) END
			,[PehDateEnd]            =  CASE WHEN (@isFormView = 1) THEN @pehDateEnd WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @pehDateEnd, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@pehDateEnd, PehDateEnd) END
			,[PehSndRcv]            =  ISNULL(@pehSndRcv, PehSndRcv)  
			,[ChangedBy]             =  @changedBy
			,[DateChanged]           =  @dateChanged
	 WHERE   [Id] = @id
	SELECT prg.[Id]
		,prg.[PehProgramID]
		,prg.[PehItemNumber]
		,prg.[PehEdiCode]
		,prg.[PehEdiTitle]
		,prg.[PehTradingPartner]
		,prg.[PehEdiDocument]
		,prg.[PehEdiVersion]
		,prg.[PehSCACCode]
		,prg.[UDF01]  
		,prg.[UDF02]  
		,prg.[UDF03]  
		,prg.[UDF04]
		,prg.[PehAttachments]
		,prg.[StatusId]
		,prg.[PehDateStart]
		,prg.[PehDateEnd]
		,prg.[PehSndRcv]
		,prg.[EnteredBy]
		,prg.[DateEntered]
		,prg.[ChangedBy]
		,prg.[DateChanged]
  FROM   [dbo].[PRGRM070EdiHeader] prg
 WHERE   [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdPrgEdiMapping]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Upd a Program EDI mapping
-- Execution:                 EXEC [dbo].[UpdPrgEdiMapping]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[UpdPrgEdiMapping]
	(@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id bigint
	,@pemHeaderID bigint
	,@pemEdiTableName  NVARCHAR(50)=NULL
	,@pemEdiFieldName NVARCHAR(50)=NULL
	,@pemEdiFieldDataType NVARCHAR(20)=NULL
	,@pemSysTableName NVARCHAR(50)=NULL
	,@pemSysFieldName NVARCHAR(50)=NULL
	,@pemSysFieldDataType NVARCHAR(20) =NULL
	,@statusId  int=NULL
	,@pemInsertUpdate int=NULL
	,@pemDateStart datetime2(7)=NULL
	,@pemDateEnd datetime2(7) =NULL
	,@changedBy nvarchar(50) = NULL
	,@dateChanged datetime2(7) = NULL
	,@isFormView BIT = 0) 
AS
BEGIN TRY                
 SET NOCOUNT ON; 
 
 --SELECT @pemSysFieldDataType =  DATA_TYPE from INFORMATION_SCHEMA.COLUMNS IC where TABLE_NAME = @pemSysTableName and COLUMN_NAME = @pemSysFieldName
 --SELECT @pemEdiFieldDataType =  DATA_TYPE from INFORMATION_SCHEMA.COLUMNS IC where TABLE_NAME = @pemEdiTableName and COLUMN_NAME = @pemEdiFieldName
 
   
 UPDATE [dbo].[PRGRM071EdiMapping]
		SET  [PemHeaderID]       = CASE WHEN (@isFormView = 1) THEN @pemHeaderID WHEN ((@isFormView = 0) AND (@pemHeaderID=-100)) THEN NULL ELSE ISNULL(@pemHeaderID, PemHeaderID) END
			,[PemEdiTableName]   = CASE WHEN (@isFormView = 1) THEN @pemEdiTableName WHEN ((@isFormView = 0) AND (@pemEdiTableName='#M4PL#')) THEN NULL ELSE ISNULL(@pemEdiTableName, PemEdiTableName) END
			,[PemEdiFieldName]   = CASE WHEN (@isFormView = 1) THEN @pemEdiFieldName WHEN ((@isFormView = 0) AND (@pemEdiFieldName='#M4PL#')) THEN NULL ELSE ISNULL(@pemEdiFieldName, PemEdiFieldName) END
			,[PemEdiFieldDataType] = CASE WHEN (@isFormView = 1) THEN @pemEdiFieldDataType WHEN ((@isFormView = 0) AND (@pemEdiFieldDataType='#M4PL#')) THEN @pemEdiFieldDataType ELSE ISNULL(@pemEdiFieldDataType, PemEdiFieldDataType) END


			,[PemSysTableName]    = CASE WHEN (@isFormView = 1) THEN @pemSysTableName WHEN ((@isFormView = 0) AND (@pemSysTableName='#M4PL#')) THEN NULL ELSE ISNULL(@pemSysTableName, PemSysTableName) END
			,[PemSysFieldName]   = CASE WHEN (@isFormView = 1) THEN @pemSysFieldName WHEN ((@isFormView = 0) AND (@pemSysFieldName='#M4PL#')) THEN NULL ELSE ISNULL(@pemSysFieldName, PemSysFieldName) END
			,[PemSysFieldDataType] = CASE WHEN (@isFormView = 1) THEN @pemSysFieldDataType WHEN ((@isFormView = 0) AND (@pemSysFieldDataType='#M4PL#')) THEN @pemSysFieldDataType ELSE ISNULL(@pemSysFieldDataType, PemSysFieldDataType) END
			
			,[StatusId]          = CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
			,[PemInsertUpdate]   = CASE WHEN (@isFormView = 1) THEN @pemInsertUpdate WHEN ((@isFormView = 0) AND (@pemInsertUpdate=-100)) THEN NULL ELSE ISNULL(@pemInsertUpdate, PemInsertUpdate) END
			,[PemDateStart]      = CASE WHEN (@isFormView = 1) THEN @pemDateStart WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @pemDateStart, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@pemDateStart, PemDateStart) END
			,[PemDateEnd]        = CASE WHEN (@isFormView = 1) THEN @pemDateEnd WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @pemDateEnd, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@pemDateEnd, PemDateEnd) END
			,[ChangedBy]         = @changedBy
			,[DateChanged]       = @dateChanged
	 WHERE   [Id] = @id;
	SELECT  prg.[Id]
		 ,prg.[PemHeaderID]
         ,prg.[PemEdiTableName]
         ,prg.[PemEdiFieldName]
         ,prg.[PemEdiFieldDataType]
         ,prg.[PemSysTableName]
         ,prg.[PemSysFieldName]
         ,prg.[PemSysFieldDataType]
         ,prg.[StatusId]
         ,prg.[PemInsertUpdate]
         ,prg.[PemDateStart]
         ,prg.[PemDateEnd]
         ,prg.[EnteredBy]
         ,prg.[DateEntered]
         ,prg.[ChangedBy]
         ,prg.[DateChanged]
  FROM   [dbo].[PRGRM071EdiMapping] prg
 WHERE   [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdPrgMvoc]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/26/2018      
-- Description:               Upd a Program MVOC
-- Execution:                 EXEC [dbo].[UpdPrgMvoc]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[UpdPrgMvoc]
	(@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id bigint
	,@vocOrgID bigint = NULL
	,@vocProgramID bigint = NULL
	,@vocSurveyCode nvarchar(20) = NULL
	,@vocSurveyTitle nvarchar(50) = NULL
	,@statusId int = NULL
	,@vocDateOpen datetime2(7) = NULL
	,@vocDateClose datetime2(7) = NULL
	,@dateChanged datetime2(7) = NULL
	,@changedBy nvarchar(50) = NULL
	,@isFormView BIT = 0) 
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 UPDATE [dbo].[MVOC000Program]
		SET  VocOrgID        = CASE WHEN (@isFormView = 1) THEN @vocOrgID WHEN ((@isFormView = 0) AND (@vocOrgID=-100)) THEN NULL ELSE ISNULL(@vocOrgID, VocOrgID) END
			,VocProgramID    = CASE WHEN (@isFormView = 1) THEN @vocProgramID WHEN ((@isFormView = 0) AND (@vocProgramID=-100)) THEN NULL ELSE ISNULL(@vocProgramID, VocProgramID) END
			,VocSurveyCode   = CASE WHEN (@isFormView = 1) THEN @vocSurveyCode WHEN ((@isFormView = 0) AND (@vocSurveyCode='#M4PL#')) THEN NULL ELSE ISNULL(@vocSurveyCode, VocSurveyCode) END
			,VocSurveyTitle  = CASE WHEN (@isFormView = 1) THEN @vocSurveyTitle WHEN ((@isFormView = 0) AND (@vocSurveyTitle='#M4PL#')) THEN NULL ELSE ISNULL(@vocSurveyTitle, VocSurveyTitle) END
			,StatusId        = CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
			,VocDateOpen     = CASE WHEN (@isFormView = 1) THEN @vocDateOpen WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @vocDateOpen, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@vocDateOpen, VocDateOpen) END
			,VocDateClose    = CASE WHEN (@isFormView = 1) THEN @vocDateClose WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @vocDateClose, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@vocDateClose, VocDateClose) END
			,DateChanged     = @dateChanged
			,ChangedBy       = @changedBy
	 WHERE   [Id] = @id
	SELECT prg.Id
		,prg.VocOrgID
		,prg.VocProgramID
		,prg.VocSurveyCode
		,prg.VocSurveyTitle
		,prg.StatusId
		,prg.VocDateOpen
		,prg.VocDateClose
		,prg.DateEntered
		,prg.EnteredBy
		,prg.DateChanged
		,prg.ChangedBy
  FROM   [dbo].[MVOC000Program] prg
 WHERE   [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdPrgMvocRefQuestion]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/26/2018      
-- Description:               Upd a MVOC ref question
-- Execution:                 EXEC [dbo].[UpdPrgMvocRefQuestion]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[UpdPrgMvocRefQuestion]
	(@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id bigint
	,@mVOCID bigint = NULL
	,@queQuestionNumber int = NULL
	,@queCode nvarchar(20) = NULL
	,@queTitle nvarchar(50) = NULL
	,@quesTypeId int = NULL
	,@queType_YNAnswer bit = NULL
	,@queType_YNDefault bit = NULL
	,@queType_RangeLo int = NULL
	,@queType_RangeHi int = NULL
	,@queType_RangeAnswer int = NULL
	,@queType_RangeDefault int = NULL
	,@statusId int = NULL
	,@dateChanged datetime2(7) = NULL
	,@changedBy nvarchar(50) = NULL
	,@isFormView BIT = 0) 
AS
BEGIN TRY                
 SET NOCOUNT ON;  
  DECLARE @updatedItemNumber INT      
  EXEC [dbo].[ResetItemNumber] @userId, @id, @mVOCID, @entity, @queQuestionNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT 
 UPDATE [dbo].[MVOC010Ref_Questions]
		SET  MVOCID                  = CASE WHEN (@isFormView = 1) THEN @mVOCID WHEN ((@isFormView = 0) AND (@mVOCID=-100)) THEN NULL ELSE ISNULL(@mVOCID, MVOCID) END
			,QueQuestionNumber       = CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, QueQuestionNumber) END
			,QueCode                 = CASE WHEN (@isFormView = 1) THEN @queCode WHEN ((@isFormView = 0) AND (@queCode='#M4PL#')) THEN NULL ELSE ISNULL(@queCode, QueCode) END
			,QueTitle                = CASE WHEN (@isFormView = 1) THEN @queTitle WHEN ((@isFormView = 0) AND (@queTitle='#M4PL#')) THEN NULL ELSE ISNULL(@queTitle, QueTitle) END
			,StatusId		         = CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
			,QuesTypeId              = CASE WHEN (@isFormView = 1) THEN @quesTypeId WHEN ((@isFormView = 0) AND (@quesTypeId=-100)) THEN NULL ELSE ISNULL(@quesTypeId, QuesTypeId) END
			,QueType_YNAnswer        = ISNULL(@queType_YNAnswer, QueType_YNAnswer)
			,QueType_YNDefault       = ISNULL(@queType_YNDefault, QueType_YNDefault)
			,QueType_RangeLo         = CASE WHEN (@isFormView = 1) THEN @queType_RangeLo WHEN ((@isFormView = 0) AND (@queType_RangeLo=-100)) THEN NULL ELSE ISNULL(@queType_RangeLo, QueType_RangeLo) END
			,QueType_RangeHi         = CASE WHEN (@isFormView = 1) THEN @queType_RangeHi WHEN ((@isFormView = 0) AND (@queType_RangeHi=-100)) THEN NULL ELSE ISNULL(@queType_RangeHi, QueType_RangeHi) END
			,QueType_RangeAnswer     = CASE WHEN (@isFormView = 1) THEN @queType_RangeAnswer WHEN ((@isFormView = 0) AND (@queType_RangeAnswer=-100)) THEN NULL ELSE ISNULL(@queType_RangeAnswer, QueType_RangeAnswer) END
			,QueType_RangeDefault    = CASE WHEN (@isFormView = 1) THEN @queType_RangeDefault WHEN ((@isFormView = 0) AND (@queType_RangeDefault=-100)) THEN NULL ELSE ISNULL(@queType_RangeDefault, QueType_RangeDefault) END
			,DateChanged             = @dateChanged
			,ChangedBy               = @changedBy
	 WHERE   [Id] = @id
		
	EXEC [dbo].[GetPrgMvocRefQuestion] @userId, @roleId, 0, @id

END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdPrgRefAttributeDefault]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Upd a Program Ref Attributes
-- Execution:                 EXEC [dbo].[UpdPrgRefAttributeDefault]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[UpdPrgRefAttributeDefault]
	(@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id bigint
	,@programId bigint = NULL
	,@attItemNumber int = NULL
	,@attCode nvarchar(20) = NULL
	,@attTitle nvarchar(50) = NULL
	,@attQuantity int = NULL
	,@unitTypeId int = NULL
	,@statusId int = NULL
	,@attDefault bit = NULL
	,@dateChanged datetime2(7) = NULL
	,@changedBy nvarchar(50) = NULL
	,@isFormView BIT = 0) 
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 DECLARE @updatedItemNumber INT      
 EXEC [dbo].[ResetItemNumber] @userId, @id, @programId, @entity, @attItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT
 UPDATE [dbo].[PRGRM020Ref_AttributesDefault]
		SET  [ProgramID]         = CASE WHEN (@isFormView = 1) THEN @programId WHEN ((@isFormView = 0) AND (@programId=-100)) THEN NULL ELSE ISNULL(@programId, ProgramID) END
			,[AttItemNumber]     = CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, AttItemNumber) END
			,[AttCode]           = CASE WHEN (@isFormView = 1) THEN @attCode WHEN ((@isFormView = 0) AND (@attCode='#M4PL#')) THEN NULL ELSE ISNULL(@attCode, AttCode) END
			,[AttTitle]          = CASE WHEN (@isFormView = 1) THEN @attTitle WHEN ((@isFormView = 0) AND (@attTitle='#M4PL#')) THEN NULL ELSE ISNULL(@attTitle, AttTitle) END
			,[AttQuantity]       = CASE WHEN (@isFormView = 1) THEN @attQuantity WHEN ((@isFormView = 0) AND (@attQuantity=-100)) THEN NULL ELSE ISNULL(@attQuantity, AttQuantity) END
			,[UnitTypeId]        = CASE WHEN (@isFormView = 1) THEN @unitTypeId WHEN ((@isFormView = 0) AND (@unitTypeId=-100)) THEN NULL ELSE ISNULL(@unitTypeId, UnitTypeId) END
			,[AttDefault]        = ISNULL(@attDefault, AttDefault)
			,[StatusId]          = CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
			,[DateChanged]       = @dateChanged
			,[ChangedBy]         = @changedBy
	 WHERE   [Id] = @id
	SELECT prg.[Id]
		,prg.[ProgramID]
		,prg.[AttItemNumber]
		,prg.[AttCode]
		,prg.[AttTitle]
		,prg.[AttQuantity]
		,prg.[UnitTypeId]
		,prg.[AttDefault]
		,prg.[DateEntered]
		,prg.[EnteredBy]
		,prg.[DateChanged]
		,prg.[ChangedBy]
  FROM   [dbo].[PRGRM020Ref_AttributesDefault] prg
 WHERE   [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdPrgRefGatewayDefault]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */  
-- =============================================          
-- Author:                    Akhil Chauhan           
-- Create date:               08/16/2018        
-- Description:               Upd a Program Ref Gateway Default  
-- Execution:                 EXEC [dbo].[UpdPrgRefGatewayDefault]  
-- Modified on:               04/27/2018
-- Modified Desc:             Added Scanner Field
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.) 
-- =============================================  
ALTER PROCEDURE  [dbo].[UpdPrgRefGatewayDefault]  
(@userId BIGINT  
,@roleId BIGINT  
,@entity NVARCHAR(100)  
,@id bigint  
,@pgdProgramId bigint = NULL  
,@pgdGatewaySortOrder int = NULL  
,@pgdGatewayCode nvarchar(20) = NULL  
,@pgdGatewayTitle nvarchar(50) = NULL  
,@pgdGatewayDuration decimal(18, 0) = NULL  
,@unitTypeId int = NULL  
,@pgdGatewayDefault bit = NULL  
,@gatewayTypeId int = NULL  
,@scanner bit = NULL  
,@pgdShipApptmtReasonCode nvarchar(20)    = NULL
,@pgdShipStatusReasonCode nvarchar(20)  = NULL
,@pgdOrderType nvarchar(20)      = NULL
,@pgdShipmentType nvarchar(20)    = NULL
,@pgdGatewayResponsible bigint = NULL
,@pgdGatewayAnalyst bigint = NULL
,@statusId int = NULL  
,@gatewayDateRefTypeId int = NULL  
,@dateChanged datetime2(7) = NULL  
,@changedBy nvarchar(50) = NULL  
,@isFormView BIT = 0)   
AS  
BEGIN TRY                  
 SET NOCOUNT ON;   
 DECLARE @updatedItemNumber INT        
DECLARE @where NVARCHAR(MAX) =' AND GatewayTypeId ='  +  CAST(@gatewayTypeId AS VARCHAR) + ' AND PgdOrderType ='''  +  CAST(@pgdOrderType AS VARCHAR)  +''' AND PgdShipmentType ='''  +  CAST(@pgdShipmentType AS VARCHAR) +''''
 EXEC [dbo].[ResetItemNumber] @userId, @id, @pgdProgramId, @entity, @pgdGatewaySortOrder, @statusId, NULL, @where,  @updatedItemNumber OUTPUT  
 
     
 UPDATE [dbo].[PRGRM010Ref_GatewayDefaults]  
  SET  [PgdProgramID]              = CASE WHEN (@isFormView = 1) THEN @pgdProgramId WHEN ((@isFormView = 0) AND (@pgdProgramId=-100)) THEN NULL ELSE ISNULL(@pgdProgramId, PgdProgramID) END  
   ,[PgdGatewaySortOrder]       = CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, PgdGatewaySortOrder) END  
   ,[PgdGatewayCode]            = CASE WHEN (@isFormView = 1) THEN @pgdGatewayCode WHEN ((@isFormView = 0) AND (@pgdGatewayCode='#M4PL#')) THEN NULL ELSE ISNULL(@pgdGatewayCode, PgdGatewayCode) END  
   ,[PgdGatewayTitle]           = CASE WHEN (@isFormView = 1) THEN @pgdGatewayTitle WHEN ((@isFormView = 0) AND (@pgdGatewayTitle='#M4PL#')) THEN NULL ELSE ISNULL(@pgdGatewayTitle, PgdGatewayTitle) END  
   ,[PgdGatewayDuration]        = CASE WHEN (@isFormView = 1) THEN @pgdGatewayDuration WHEN ((@isFormView = 0) AND (@pgdGatewayDuration=-100.00)) THEN NULL ELSE ISNULL(@pgdGatewayDuration, PgdGatewayDuration) END  
   ,[UnitTypeId]     = CASE WHEN (@isFormView = 1) THEN @unitTypeId WHEN ((@isFormView = 0) AND (@unitTypeId=-100)) THEN NULL ELSE ISNULL(@unitTypeId, UnitTypeId) END  
   ,[PgdGatewayDefault]         = ISNULL(@pgdGatewayDefault, PgdGatewayDefault)  
   ,[GatewayTypeId]             = CASE WHEN (@isFormView = 1) THEN @gatewayTypeId WHEN ((@isFormView = 0) AND (@gatewayTypeId=-100)) THEN NULL ELSE ISNULL(@gatewayTypeId, GatewayTypeId) END  
   ,[GatewayDateRefTypeId]      = CASE WHEN (@isFormView = 1) THEN @gatewayDateRefTypeId WHEN ((@isFormView = 0) AND (@gatewayDateRefTypeId=-100)) THEN NULL ELSE ISNULL(@gatewayDateRefTypeId, GatewayDateRefTypeId) END  
   ,[Scanner]          = ISNULL(@scanner, Scanner) 

   ,[PgdShipApptmtReasonCode]           = CASE WHEN (@isFormView = 1) THEN @pgdShipApptmtReasonCode WHEN ((@isFormView = 0) AND (@pgdShipApptmtReasonCode='#M4PL#')) THEN NULL ELSE ISNULL(@pgdShipApptmtReasonCode, PgdShipApptmtReasonCode) END  
   ,[PgdShipStatusReasonCode]           = CASE WHEN (@isFormView = 1) THEN @pgdShipStatusReasonCode WHEN ((@isFormView = 0) AND (@pgdShipStatusReasonCode='#M4PL#')) THEN NULL ELSE ISNULL(@pgdShipStatusReasonCode, PgdShipStatusReasonCode) END  
   ,[PgdOrderType]           = CASE WHEN (@isFormView = 1) THEN @pgdOrderType WHEN ((@isFormView = 0) AND (@pgdOrderType='#M4PL#')) THEN NULL ELSE ISNULL(@pgdOrderType, PgdOrderType) END  
   ,[PgdShipmentType]           = CASE WHEN (@isFormView = 1) THEN @pgdShipmentType WHEN ((@isFormView = 0) AND (@pgdShipmentType='#M4PL#')) THEN NULL ELSE ISNULL(@pgdShipmentType, PgdShipmentType) END  
   ,[PgdGatewayResponsible]     = CASE WHEN (@isFormView = 1) THEN @pgdGatewayResponsible WHEN ((@isFormView = 0) AND (@pgdGatewayResponsible=-100)) THEN NULL ELSE ISNULL(@pgdGatewayResponsible, PgdGatewayResponsible) END  
   ,[PgdGatewayAnalyst]     = CASE WHEN (@isFormView = 1) THEN @pgdGatewayAnalyst WHEN ((@isFormView = 0) AND (@pgdGatewayAnalyst=-100)) THEN NULL ELSE ISNULL(@pgdGatewayAnalyst, PgdGatewayAnalyst) END  


   ,[StatusId]                  = CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END  
   ,[DateChanged]               = @dateChanged  
   ,[ChangedBy]                 = @changedBy  
  WHERE   [Id] = @id  
 SELECT prg.[Id]  
  ,prg.[PgdProgramID]  
  ,prg.[PgdGatewaySortOrder]  
  ,prg.[PgdGatewayCode]  
  ,prg.[PgdGatewayTitle]  
  ,prg.[PgdGatewayDuration]  
  ,prg.[UnitTypeId]  
  ,prg.[PgdGatewayDefault]  
  ,prg.[GatewayTypeId]  
  ,prg.[GatewayDateRefTypeId]  
  ,prg.[Scanner]  
  ,prg.[PgdShipApptmtReasonCode]
  ,prg.[PgdShipStatusReasonCode]
  ,prg.[PgdOrderType]
  ,prg.[PgdShipmentType]
  ,prg.[PgdGatewayResponsible]
  ,prg.[PgdGatewayAnalyst]
  ,prg.[StatusId]   
  ,prg.[DateEntered]  
  ,prg.[EnteredBy]  
  ,prg.[DateChanged]  
  ,prg.[ChangedBy]  
  FROM   [dbo].[PRGRM010Ref_GatewayDefaults] prg  
 WHERE   [Id] = @id  
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdPrgShipApptmtReasonCode]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Upd a Program Ship Apptmt Reason Code
-- Execution:                 EXEC [dbo].[UpdPrgShipApptmtReasonCode]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[UpdPrgShipApptmtReasonCode]
	(@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id bigint
	,@pacOrgId bigint = NULL
	,@pacProgramId bigint = NULL
	,@pacApptItem int = NULL
	,@pacApptReasonCode nvarchar(20) = NULL
	,@pacApptLength int = NULL
	,@pacApptInternalCode nvarchar(20) = NULL
	,@pacApptPriorityCode nvarchar(20) = NULL
	,@pacApptTitle nvarchar(50) = NULL
	,@pacApptCategoryCode nvarchar(20) = NULL
	,@pacApptUser01Code nvarchar(20) = NULL
	,@pacApptUser02Code nvarchar(20) = NULL
	,@pacApptUser03Code nvarchar(20) = NULL
	,@pacApptUser04Code nvarchar(20) = NULL
	,@pacApptUser05Code nvarchar(20) = NULL
	,@statusId int = NULL
	,@dateChanged datetime2(7) = NULL
	,@changedBy nvarchar(50) = NULL
	,@isFormView BIT = 0) 
AS
BEGIN TRY                
 SET NOCOUNT ON;   
   DECLARE @updatedItemNumber INT      
 EXEC [dbo].[ResetItemNumber] @userId, @id, @pacProgramId, @entity, @pacApptItem, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT 

 UPDATE [dbo].[PRGRM031ShipApptmtReasonCodes]
		SET  [PacOrgID]              = CASE WHEN (@isFormView = 1) THEN @pacOrgID WHEN ((@isFormView = 0) AND (@pacOrgID=-100)) THEN NULL ELSE ISNULL(@pacOrgID, PacOrgID) END
			,[PacProgramID]          = CASE WHEN (@isFormView = 1) THEN @pacProgramID WHEN ((@isFormView = 0) AND (@pacProgramID=-100)) THEN NULL ELSE ISNULL(@pacProgramID, PacProgramID) END
			,[PacApptItem]           = CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, PacApptItem) END
			,[PacApptReasonCode]     = CASE WHEN (@isFormView = 1) THEN @pacApptReasonCode WHEN ((@isFormView = 0) AND (@pacApptReasonCode='#M4PL#')) THEN NULL ELSE ISNULL(@pacApptReasonCode, PacApptReasonCode) END
			,[PacApptLength]         = CASE WHEN (@isFormView = 1) THEN @pacApptLength WHEN ((@isFormView = 0) AND (@pacApptLength=-100)) THEN NULL ELSE ISNULL(@pacApptLength, PacApptLength) END
			,[PacApptInternalCode]   = CASE WHEN (@isFormView = 1) THEN @pacApptInternalCode WHEN ((@isFormView = 0) AND (@pacApptInternalCode='#M4PL#')) THEN NULL ELSE ISNULL(@pacApptInternalCode, PacApptInternalCode) END
			,[PacApptPriorityCode]   = CASE WHEN (@isFormView = 1) THEN @pacApptPriorityCode WHEN ((@isFormView = 0) AND (@pacApptPriorityCode='#M4PL#')) THEN NULL ELSE ISNULL(@pacApptPriorityCode, PacApptPriorityCode) END
			,[PacApptTitle]          = CASE WHEN (@isFormView = 1) THEN @pacApptTitle WHEN ((@isFormView = 0) AND (@pacApptTitle='#M4PL#')) THEN NULL ELSE ISNULL(@pacApptTitle, PacApptTitle) END
			,[PacApptCategoryCode]   = CASE WHEN (@isFormView = 1) THEN @pacApptCategoryCode WHEN ((@isFormView = 0) AND (@pacApptCategoryCode='#M4PL#')) THEN NULL ELSE ISNULL(@pacApptCategoryCode, PacApptCategoryCode) END
			,[PacApptUser01Code]     = CASE WHEN (@isFormView = 1) THEN @pacApptUser01Code WHEN ((@isFormView = 0) AND (@pacApptUser01Code='#M4PL#')) THEN NULL ELSE ISNULL(@pacApptUser01Code, PacApptUser01Code) END
			,[PacApptUser02Code]     = CASE WHEN (@isFormView = 1) THEN @pacApptUser02Code WHEN ((@isFormView = 0) AND (@pacApptUser02Code='#M4PL#')) THEN NULL ELSE ISNULL(@pacApptUser02Code, PacApptUser02Code) END
			,[PacApptUser03Code]     = CASE WHEN (@isFormView = 1) THEN @pacApptUser03Code WHEN ((@isFormView = 0) AND (@pacApptUser03Code='#M4PL#')) THEN NULL ELSE ISNULL(@pacApptUser03Code, PacApptUser03Code) END
			,[PacApptUser04Code]     = CASE WHEN (@isFormView = 1) THEN @pacApptUser04Code WHEN ((@isFormView = 0) AND (@pacApptUser04Code='#M4PL#')) THEN NULL ELSE ISNULL(@pacApptUser04Code, PacApptUser04Code) END
			,[PacApptUser05Code]     = CASE WHEN (@isFormView = 1) THEN @pacApptUser05Code WHEN ((@isFormView = 0) AND (@pacApptUser05Code='#M4PL#')) THEN NULL ELSE ISNULL(@pacApptUser05Code, PacApptUser05Code) END
			,[StatusId]				 = CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId)	 END
			,[DateChanged]           = @dateChanged
			,[ChangedBy]             = @changedBy
	 WHERE   [Id] = @id
	SELECT prg.[Id]
		,prg.[PacOrgID]
		,prg.[PacProgramID]
		,prg.[PacApptItem]
		,prg.[PacApptReasonCode]
		,prg.[PacApptLength]
		,prg.[PacApptInternalCode]
		,prg.[PacApptPriorityCode]
		,prg.[PacApptTitle]
		,prg.[PacApptCategoryCode]
		,prg.[PacApptUser01Code]
		,prg.[PacApptUser02Code]
		,prg.[PacApptUser03Code]
		,prg.[PacApptUser04Code]
		,prg.[PacApptUser05Code]
		,prg.[StatusId]
		,prg.[DateEntered]
		,prg.[EnteredBy]
		,prg.[DateChanged]
		,prg.[ChangedBy]
  FROM   [dbo].[PRGRM031ShipApptmtReasonCodes] prg
 WHERE   [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdPrgShipStatusReasonCode]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Upd a Program Ship Status Reason Code
-- Execution:                 EXEC [dbo].[UpdPrgShipStatusReasonCode]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[UpdPrgShipStatusReasonCode]
	(@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id bigint
	,@pscOrgId bigint = NULL
	,@pscProgramId bigint = NULL
	,@pscShipItem int = NULL
	,@pscShipReasonCode nvarchar(20) = NULL
	,@pscShipLength int = NULL
	,@pscShipInternalCode nvarchar(20) = NULL
	,@pscShipPriorityCode nvarchar(20) = NULL
	,@pscShipTitle nvarchar(50) = NULL
	,@pscShipCategoryCode nvarchar(20) = NULL
	,@pscShipUser01Code nvarchar(20) = NULL
	,@pscShipUser02Code nvarchar(20) = NULL
	,@pscShipUser03Code nvarchar(20) = NULL
	,@pscShipUser04Code nvarchar(20) = NULL
	,@pscShipUser05Code nvarchar(20) = NULL
	,@statusId int = NULL
	,@dateChanged datetime2(7) = NULL
	,@changedBy nvarchar(50) = NULL
	,@isFormView BIT = 0) 
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 DECLARE @updatedItemNumber INT      
 EXEC [dbo].[ResetItemNumber] @userId, @id, @pscProgramId, @entity, @pscShipItem, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT

 UPDATE [dbo].[PRGRM030ShipStatusReasonCodes]
		SET  [PscOrgID]              = CASE WHEN (@isFormView = 1) THEN @pscOrgID WHEN ((@isFormView = 0) AND (@pscOrgID=-100)) THEN NULL ELSE ISNULL(@pscOrgID, PscOrgID) END
			,[PscProgramID]          = CASE WHEN (@isFormView = 1) THEN @pscProgramID WHEN ((@isFormView = 0) AND (@pscProgramID=-100)) THEN NULL ELSE ISNULL(@pscProgramID, PscProgramID) END
			,[PscShipItem]           = CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, PscShipItem) END
			,[PscShipReasonCode]     = CASE WHEN (@isFormView = 1) THEN @pscShipReasonCode WHEN ((@isFormView = 0) AND (@pscShipReasonCode='#M4PL#')) THEN NULL ELSE ISNULL(@pscShipReasonCode, PscShipReasonCode) END
			,[PscShipLength]         = CASE WHEN (@isFormView = 1) THEN @pscShipLength WHEN ((@isFormView = 0) AND (@pscShipLength=-100)) THEN NULL ELSE ISNULL(@pscShipLength, PscShipLength) END
			,[PscShipInternalCode]   = CASE WHEN (@isFormView = 1) THEN @pscShipInternalCode WHEN ((@isFormView = 0) AND (@pscShipInternalCode='#M4PL#')) THEN NULL ELSE ISNULL(@pscShipInternalCode, PscShipInternalCode) END
			,[PscShipPriorityCode]   = CASE WHEN (@isFormView = 1) THEN @pscShipPriorityCode WHEN ((@isFormView = 0) AND (@pscShipPriorityCode='#M4PL#')) THEN NULL ELSE ISNULL(@pscShipPriorityCode, PscShipPriorityCode) END
			,[PscShipTitle]          = CASE WHEN (@isFormView = 1) THEN @pscShipTitle WHEN ((@isFormView = 0) AND (@pscShipTitle='#M4PL#')) THEN NULL ELSE ISNULL(@pscShipTitle, PscShipTitle) END
			,[PscShipCategoryCode]   = CASE WHEN (@isFormView = 1) THEN @pscShipCategoryCode WHEN ((@isFormView = 0) AND (@pscShipCategoryCode='#M4PL#')) THEN NULL ELSE ISNULL(@pscShipCategoryCode, PscShipCategoryCode) END
			,[PscShipUser01Code]     = CASE WHEN (@isFormView = 1) THEN @pscShipUser01Code WHEN ((@isFormView = 0) AND (@pscShipUser01Code='#M4PL#')) THEN NULL ELSE ISNULL(@pscShipUser01Code, PscShipUser01Code) END
			,[PscShipUser02Code]     = CASE WHEN (@isFormView = 1) THEN @pscShipUser02Code WHEN ((@isFormView = 0) AND (@pscShipUser02Code='#M4PL#')) THEN NULL ELSE ISNULL(@pscShipUser02Code, PscShipUser02Code) END
			,[PscShipUser03Code]     = CASE WHEN (@isFormView = 1) THEN @pscShipUser03Code WHEN ((@isFormView = 0) AND (@pscShipUser03Code='#M4PL#')) THEN NULL ELSE ISNULL(@pscShipUser03Code, PscShipUser03Code) END
			,[PscShipUser04Code]     = CASE WHEN (@isFormView = 1) THEN @pscShipUser04Code WHEN ((@isFormView = 0) AND (@pscShipUser04Code='#M4PL#')) THEN NULL ELSE ISNULL(@pscShipUser04Code, PscShipUser04Code) END
			,[PscShipUser05Code]     = CASE WHEN (@isFormView = 1) THEN @pscShipUser05Code WHEN ((@isFormView = 0) AND (@pscShipUser05Code='#M4PL#')) THEN NULL ELSE ISNULL(@pscShipUser05Code, PscShipUser05Code) END
			,[StatusId]				 = CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END	
			,[DateChanged]           = @dateChanged
			,[ChangedBy]             = @changedBy
	 WHERE   [Id] = @id
	SELECT prg.[Id]
		,prg.[PscOrgID]
		,prg.[PscProgramID]
		,prg.[PscShipItem]
		,prg.[PscShipReasonCode]
		,prg.[PscShipLength]
		,prg.[PscShipInternalCode]
		,prg.[PscShipPriorityCode]
		,prg.[PscShipTitle]
		,prg.[PscShipCategoryCode]
		,prg.[PscShipUser01Code]
		,prg.[PscShipUser02Code]
		,prg.[PscShipUser03Code]
		,prg.[PscShipUser04Code]
		,prg.[PscShipUser05Code]
		,prg.[StatusId]
		,prg.[DateEntered]
		,prg.[EnteredBy]
		,prg.[DateChanged]
		,prg.[ChangedBy]
  FROM   [dbo].[PRGRM030ShipStatusReasonCodes] prg
 WHERE   [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdPrgVendLocation]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Upd a Program vendor location
-- Execution:                 EXEC [dbo].[UpdPrgVendLocation]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================  
ALTER PROCEDURE  [dbo].[UpdPrgVendLocation]
	(@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id bigint
	,@pvlProgramID bigint = NULL
	,@pvlVendorID bigint = NULL
	,@pvlItemNumber int = NULL
	,@pvlLocationCode nvarchar(20) = NULL
	,@pvlLocationCodeCustomer nvarchar(20) = NULL
	,@pvlLocationTitle nvarchar(50) = NULL
	,@pvlContactMSTRID bigint = NULL
	,@statusId int = NULL
	,@pvlDateStart datetime2(7) = NULL
	,@pvlDateEnd datetime2(7) = NULL
	,@pvlUserCode1 NVARCHAR(20) = NULL
	,@pvlUserCode2 NVARCHAR(20) = NULL
	,@pvlUserCode3 NVARCHAR(20) = NULL
	,@pvlUserCode4 NVARCHAR(20) = NULL
	,@pvlUserCode5 NVARCHAR(20) = NULL
	,@changedBy nvarchar(50) = NULL
	,@dateChanged datetime2(7) = NULL
	,@isFormView BIT = 0) 
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  DECLARE @updatedItemNumber INT      
  EXEC [dbo].[ResetItemNumber] @userId, @id, @pvlProgramID, @entity, @pvlItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT 
 UPDATE [dbo].[PRGRM051VendorLocations]
		SET  [PvlProgramID]              =  CASE WHEN (@isFormView = 1) THEN @pvlProgramID WHEN ((@isFormView = 0) AND (@pvlProgramID=-100)) THEN NULL ELSE ISNULL(@pvlProgramID, PvlProgramID) END
			,[PvlVendorID]               =  CASE WHEN (@isFormView = 1) THEN @pvlVendorID WHEN ((@isFormView = 0) AND (@pvlVendorID=-100)) THEN NULL ELSE ISNULL(@pvlVendorID, PvlVendorID) END
			,[PvlItemNumber]             =  CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, PvlItemNumber) END
			,[PvlLocationCode]           =  CASE WHEN (@isFormView = 1) THEN @pvlLocationCode WHEN ((@isFormView = 0) AND (@pvlLocationCode='#M4PL#')) THEN NULL ELSE ISNULL(@pvlLocationCode, PvlLocationCode) END
			,[PvlLocationCodeCustomer]   =  CASE WHEN (@isFormView = 1) THEN @pvlLocationCodeCustomer WHEN ((@isFormView = 0) AND (@pvlLocationCodeCustomer='#M4PL#')) THEN NULL ELSE ISNULL(@pvlLocationCodeCustomer, PvlLocationCodeCustomer) END
			,[PvlLocationTitle]          =  CASE WHEN (@isFormView = 1) THEN @pvlLocationTitle WHEN ((@isFormView = 0) AND (@pvlLocationTitle='#M4PL#')) THEN NULL ELSE ISNULL(@pvlLocationTitle, PvlLocationTitle) END
			,[PvlContactMSTRID]          =  CASE WHEN (@isFormView = 1) THEN @pvlContactMSTRID WHEN ((@isFormView = 0) AND (@pvlContactMSTRID=-100)) THEN NULL ELSE ISNULL(@pvlContactMSTRID, PvlContactMSTRID) END
			,[StatusId]                  =  CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
			,[PvlDateStart]              =  CASE WHEN (@isFormView = 1) THEN @pvlDateStart WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @pvlDateStart, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@pvlDateStart, PvlDateStart) END
			,[PvlDateEnd]                =  CASE WHEN (@isFormView = 1) THEN @pvlDateEnd WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @pvlDateEnd, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@pvlDateEnd, PvlDateEnd) END
			,[PvlUserCode1]           =  CASE WHEN (@isFormView = 1) THEN @pvlUserCode1 WHEN ((@isFormView = 0) AND (@pvlUserCode1='#M4PL#')) THEN NULL ELSE ISNULL(@pvlUserCode1, PvlUserCode1) END
			,[PvlUserCode2]           =  CASE WHEN (@isFormView = 1) THEN @pvlUserCode2 WHEN ((@isFormView = 0) AND (@pvlUserCode2='#M4PL#')) THEN NULL ELSE ISNULL(@pvlUserCode2, PvlUserCode2) END
			,[PvlUserCode3]           =  CASE WHEN (@isFormView = 1) THEN @pvlUserCode3 WHEN ((@isFormView = 0) AND (@pvlUserCode3='#M4PL#')) THEN NULL ELSE ISNULL(@pvlUserCode3, PvlUserCode3) END
			,[PvlUserCode4]           =  CASE WHEN (@isFormView = 1) THEN @pvlUserCode4 WHEN ((@isFormView = 0) AND (@pvlUserCode4='#M4PL#')) THEN NULL ELSE ISNULL(@pvlUserCode4, PvlUserCode4) END
			,[PvlUserCode5]           =  CASE WHEN (@isFormView = 1) THEN @pvlUserCode5 WHEN ((@isFormView = 0) AND (@pvlUserCode5='#M4PL#')) THEN NULL ELSE ISNULL(@pvlUserCode5, PvlUserCode5) END
			,[ChangedBy]                 =  @changedBy
			,[DateChanged]               =  @dateChanged
	 WHERE   [Id] = @id
	SELECT prg.[Id]
		,prg.[PvlProgramID]
		,prg.[PvlVendorID]
		,prg.[PvlItemNumber]
		,prg.[PvlLocationCode]
		,prg.[PvlLocationCodeCustomer]
		,prg.[PvlLocationTitle]
		,prg.[PvlContactMSTRID]
		,prg.[StatusId]
		,prg.[PvlDateStart]
		,prg.[PvlDateEnd]
		,prg.[PvlUserCode1]
		,prg.[PvlUserCode2]
		,prg.[PvlUserCode3]
		,prg.[PvlUserCode4]
		,prg.[PvlUserCode5]
		,prg.[EnteredBy]
		,prg.[DateEntered]
		,prg.[ChangedBy]
		,prg.[DateChanged]
  FROM   [dbo].[PRGRM051VendorLocations] prg
 WHERE   [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdProgram]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Upd a Program  
-- Execution:                 EXEC [dbo].[UpdProgram]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[UpdProgram]  
	(@userId BIGINT  
	,@roleId BIGINT  
	,@entity NVARCHAR(100)  
	,@id bigint
	,@parentId bigint  
	,@prgOrgId bigint  
	,@prgCustId bigint  
	,@prgItemNumber nvarchar(20)  
	,@prgProgramCode nvarchar(20)  
	,@prgProjectCode nvarchar(20)  
	,@prgPhaseCode nvarchar(20)  
	,@prgProgramTitle nvarchar(50)  
	,@prgAccountCode nvarchar(50)  
	,@delEarliest decimal(18,2) = NULL
	,@delLatest decimal(18,2) = NULL
	,@delDay BIT
	,@pckEarliest decimal(18,2)  = NULL
	,@pckLatest decimal(18,2) = NULL
	,@pckDay BIT
	,@statusId INT  
	,@prgDateStart datetime2(7)  
	,@prgDateEnd datetime2(7)  
	,@prgDeliveryTimeDefault datetime2(7)  
	,@prgPickUpTimeDefault datetime2(7)  
	,@dateChanged datetime2(7)  
	,@changedBy nvarchar(50)
	,@isFormView BIT = 0  )   
AS  
BEGIN TRY                  
 SET NOCOUNT ON;     
 --DECLARE @parentNode hierarchyid, @lc hierarchyid, @currentId BIGINT      
 --   SELECT @parentNode = [PrgHierarchyID]      
 --   FROM  [dbo].[PRGRM000Master]      
 --   WHERE [Id] = @parentPrgId      
 --   SET TRANSACTION ISOLATION LEVEL SERIALIZABLE      
 --   BEGIN TRANSACTION      
 --   SELECT @lc = max(PrgHierarchyID)       
 --   FROM   [dbo].[PRGRM000Master]     
 --   WHERE PrgHierarchyID.GetAncestor(1)  =@parentNode ;  
 --INSERT INTO [dbo].[PRGRM000Master]  
 --          ([PrgOrgId]    
 --          ,[PrgCustId]    
 --          ,[PrgItemNumber]    
 --          ,[PrgProgramCode]    
 --          ,[PrgProjectCode]    
 --          ,[PrgPhaseCode]    
 --          ,[PrgProgramTitle]    
 --          ,[PrgAccountCode]    
 --          ,[StatusId]    
 --          ,[PrgDateStart]    
 --          ,[PrgDateEnd]    
 --          ,[PrgDeliveryTimeDefault]    
 --          ,[PrgPickUpTimeDefault]    
 --          ,[PrgDescription]    
 --          ,[PrgNotes]    
 --          ,[PrgHierarchyID]    
 --          ,[DateEntered]    
 --          ,[EnteredBy])  
 --    VALUES  
 --          (@prgOrgId    
 --          ,@prgCustId    
 --          ,@prgItemNumber    
 --          ,@prgProgramCode    
 --          ,@prgProjectCode    
 --          ,@prgPhaseCode    
 --          ,@prgProgramTitle    
 --          ,@prgAccountCode    
 --          ,@statusId    
 --          ,@prgDateStart    
 --          ,@prgDateEnd    
 --          ,@prgDeliveryTimeDefault    
 --          ,@prgPickUpTimeDefault    
 --          ,@prgDescription    
 --          ,@prgNotes    
 --          ,@parentNode.GetDescendant(@lc, NULL)    
 --          ,@dateEntered    
 --          ,@enteredBy)   
  
 --SET @currentId = SCOPE_IDENTITY();  

 UPDATE PRGRM000Master
        SET PrgOrgID				= CASE WHEN (@isFormView = 1) THEN @prgOrgId WHEN ((@isFormView = 0) AND (@prgOrgId=-100)) THEN NULL ELSE ISNULL(@prgOrgId,PrgOrgID) END
		   ,PrgCustId				= CASE WHEN (@isFormView = 1) THEN @prgCustId WHEN ((@isFormView = 0) AND (@prgCustId=-100)) THEN NULL ELSE ISNULL(@prgCustId,PrgCustID) END
		   ,PrgItemNumber			= CASE WHEN (@isFormView = 1) THEN @prgItemNumber WHEN ((@isFormView = 0) AND (@prgItemNumber='#M4PL#')) THEN NULL ELSE ISNULL(@prgItemNumber,PrgItemNumber) END
		   ,PrgProgramCode			= CASE WHEN (@isFormView = 1) THEN @prgProgramCode WHEN ((@isFormView = 0) AND (@prgProgramCode='#M4PL#')) THEN NULL ELSE ISNULL(@prgProgramCode,PrgProgramCode) END
		   ,PrgProjectCode			= CASE WHEN (@isFormView = 1) THEN @prgProjectCode WHEN ((@isFormView = 0) AND (@prgProjectCode='#M4PL#')) THEN NULL ELSE ISNULL(@prgProjectCode,PrgProjectCode) END
		   ,PrgPhaseCode			= CASE WHEN (@isFormView = 1) THEN @prgPhaseCode WHEN ((@isFormView = 0) AND (@prgPhaseCode='#M4PL#')) THEN NULL ELSE ISNULL(@prgPhaseCode,PrgPhaseCode) END
		   ,PrgProgramTitle			= CASE WHEN (@isFormView = 1) THEN @prgProgramTitle WHEN ((@isFormView = 0) AND (@prgProgramTitle='#M4PL#')) THEN NULL ELSE ISNULL(@prgProgramTitle,PrgProgramTitle) END
		   ,PrgAccountCode			= CASE WHEN (@isFormView = 1) THEN @prgAccountCode WHEN ((@isFormView = 0) AND (@prgAccountCode='#M4PL#')) THEN NULL ELSE ISNULL(@prgAccountCode,PrgAccountCode) END
		   ,DelEarliest				= CASE WHEN (@isFormView = 1) THEN @delEarliest WHEN ((@isFormView = 0) AND (@delEarliest=-100)) THEN NULL ELSE ISNULL(@delEarliest, DelEarliest) END
		   ,DelLatest				= CASE WHEN (@isFormView = 1) THEN @delLatest WHEN ((@isFormView = 0) AND (@delLatest=-100)) THEN NULL ELSE ISNULL(@delLatest, DelLatest) END
		   ,DelDay					= ISNULL(@delDay, DelDay)
		   ,PckEarliest				= CASE WHEN (@isFormView = 1) THEN @pckEarliest WHEN ((@isFormView = 0) AND (@pckEarliest=-100)) THEN NULL ELSE ISNULL(@pckEarliest, PckEarliest) END
		   ,PckLatest				= CASE WHEN (@isFormView = 1) THEN @pckLatest WHEN ((@isFormView = 0) AND (@pckLatest=-100)) THEN NULL ELSE ISNULL(@pckLatest, PckLatest) END
		   ,PckDay					= ISNULL(@pckDay, PckDay)
		   ,StatusId				= CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId,StatusId) END
		   ,PrgDateStart			= CASE WHEN (@isFormView = 1) THEN @prgDateStart WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @prgDateStart, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@prgDateStart,PrgDateStart) END
		   ,PrgDateEnd				= CASE WHEN (@isFormView = 1) THEN @prgDateEnd WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @prgDateEnd, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@prgDateEnd,PrgDateEnd) END
		   ,PrgDeliveryTimeDefault  = CASE WHEN (@isFormView = 1) THEN @prgDeliveryTimeDefault WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @prgDeliveryTimeDefault, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@prgDeliveryTimeDefault,PrgDeliveryTimeDefault) END
		   ,PrgPickUpTimeDefault	= CASE WHEN (@isFormView = 1) THEN @prgPickUpTimeDefault WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @prgPickUpTimeDefault, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@prgPickUpTimeDefault,PrgPickUpTimeDefault) END
		   ,DateChanged				= ISNULL(@dateChanged,DateChanged)
		   ,ChangedBy				= ISNULL(@changedBy,ChangedBy)
		   WHERE Id = @id

  SELECT prg.[Id]        
  ,prg.[PrgOrgID]        
  ,prg.[PrgCustID]        
  ,prg.[PrgItemNumber]        
  ,prg.[PrgProgramCode]        
  ,prg.[PrgProjectCode]        
  ,prg.[PrgPhaseCode]        
  ,prg.[PrgProgramTitle]        
  ,prg.[PrgAccountCode] 
  ,prg.[DelEarliest] 
  ,prg.[DelLatest] 
  ,prg.[DelDay] 
  ,prg.[PckEarliest] 
  ,prg.[PckLatest] 
  ,prg.[PckDay]        
  ,prg.[StatusId]        
  ,prg.[PrgDateStart]        
  ,prg.[PrgDateEnd]        
  ,prg.[PrgDeliveryTimeDefault]        
  ,prg.[PrgPickUpTimeDefault]        
  ,prg.[PrgHierarchyID].ToString() As PrgHierarchyID         
  ,prg.[PrgHierarchyLevel]        
  ,prg.[DateEntered]        
  ,prg.[EnteredBy]        
  ,prg.[DateChanged]        
  ,prg.[ChangedBy]        
  FROM   [dbo].[PRGRM000Master] prg   WHERE prg.Id = @id  
  
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdProgramBillableRate]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Upd a Program Billable Rate
-- Execution:                 EXEC [dbo].[UpdProgramBillableRate]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[UpdProgramBillableRate]
	(@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@Id bigint
	,@pbrPrgrmId bigint = NULL
	,@pbrCode nvarchar(20) = NULL
	,@pbrCustomerCode nvarchar(20) = NULL
	,@pbrEffectiveDate datetime2(7) = NULL
	,@pbrTitle nvarchar(50) = NULL
	,@rateCategoryTypeId INT = NULL
	,@rateTypeId INT = NULL
	,@pbrBillablePrice decimal(18, 2) = NULL
	,@rateUnitTypeId INT = NULL
	,@pbrFormat nvarchar(20) = NULL
	,@pbrExpression01 nvarchar(255) = NULL
	,@pbrLogic01 nvarchar(255) = NULL
	,@pbrExpression02 nvarchar(255) = NULL
	,@pbrLogic02 nvarchar(255) = NULL
	,@pbrExpression03 nvarchar(255) = NULL
	,@pbrLogic03 nvarchar(255) = NULL
	,@pbrExpression04 nvarchar(255) = NULL
	,@pbrLogic04 nvarchar(255) = NULL
	,@pbrExpression05 nvarchar(255) = NULL
	,@pbrLogic05 nvarchar(255) = NULL
	,@statusId INT = NULL
	,@pbrVendLocationId bigint = NULL
	,@changedBy nvarchar(50) = NULL
	,@dateChanged datetime2(7) = NULL
	,@isFormView BIT = 0) 
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 UPDATE [dbo].[PRGRM040ProgramBillableRate]
		SET  [PbrPrgrmID]			= CASE WHEN (@isFormView = 1) THEN @pbrPrgrmID WHEN ((@isFormView = 0) AND (@pbrPrgrmID=-100)) THEN NULL ELSE ISNULL(@pbrPrgrmID, PbrPrgrmID) END
			,[PbrCode]				= CASE WHEN (@isFormView = 1) THEN @pbrCode WHEN ((@isFormView = 0) AND (@pbrCode='#M4PL#')) THEN NULL ELSE ISNULL(@pbrCode, PbrCode) END
			,[PbrCustomerCode]		= CASE WHEN (@isFormView = 1) THEN @pbrCustomerCode WHEN ((@isFormView = 0) AND (@pbrCustomerCode='#M4PL#')) THEN NULL ELSE ISNULL(@pbrCustomerCode, PbrCustomerCode) END
			,[PbrEffectiveDate]		= CASE WHEN (@isFormView = 1) THEN @pbrEffectiveDate WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @pbrEffectiveDate, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@pbrEffectiveDate, PbrEffectiveDate) END
			,[PbrTitle]				= CASE WHEN (@isFormView = 1) THEN @pbrTitle WHEN ((@isFormView = 0) AND (@pbrTitle='#M4PL#')) THEN NULL ELSE ISNULL(@pbrTitle, PbrTitle) END
			,[RateCategoryTypeId]   = CASE WHEN (@isFormView = 1) THEN @rateCategoryTypeId WHEN ((@isFormView = 0) AND (@rateCategoryTypeId=-100)) THEN NULL ELSE ISNULL(@rateCategoryTypeId, RateCategoryTypeId) END
			,[RateTypeId]           = CASE WHEN (@isFormView = 1) THEN @rateTypeId WHEN ((@isFormView = 0) AND (@rateTypeId=-100)) THEN NULL ELSE ISNULL(@rateTypeId, RateTypeId) END
			,[PbrBillablePrice]		= CASE WHEN (@isFormView = 1) THEN @pbrBillablePrice WHEN ((@isFormView = 0) AND (@pbrBillablePrice=-100.00)) THEN NULL ELSE ISNULL(@pbrBillablePrice, PbrBillablePrice) END
			,[RateUnitTypeId]		= CASE WHEN (@isFormView = 1) THEN @rateUnitTypeId WHEN ((@isFormView = 0) AND (@rateUnitTypeId=-100)) THEN NULL ELSE ISNULL(@rateUnitTypeId, RateUnitTypeId) END
			,[PbrFormat]			= CASE WHEN (@isFormView = 1) THEN @pbrFormat WHEN ((@isFormView = 0) AND (@pbrFormat='#M4PL#')) THEN NULL ELSE ISNULL(@pbrFormat, PbrFormat) END
			,[PbrExpression01]		= CASE WHEN (@isFormView = 1) THEN @pbrExpression01 WHEN ((@isFormView = 0) AND (@pbrExpression01='#M4PL#')) THEN NULL ELSE ISNULL(@pbrExpression01, PbrExpression01) END
			,[PbrLogic01]			= CASE WHEN (@isFormView = 1) THEN @pbrLogic01 WHEN ((@isFormView = 0) AND (@pbrLogic01='#M4PL#')) THEN NULL ELSE ISNULL(@pbrLogic01, PbrLogic01) END
			,[PbrExpression02]		= CASE WHEN (@isFormView = 1) THEN @pbrExpression02 WHEN ((@isFormView = 0) AND (@pbrExpression02='#M4PL#')) THEN NULL ELSE ISNULL(@pbrExpression02, PbrExpression02) END
			,[PbrLogic02]			= CASE WHEN (@isFormView = 1) THEN @pbrLogic02 WHEN ((@isFormView = 0) AND (@pbrLogic02='#M4PL#')) THEN NULL ELSE ISNULL(@pbrLogic02, PbrLogic02) END
			,[PbrExpression03]		= CASE WHEN (@isFormView = 1) THEN @pbrExpression03 WHEN ((@isFormView = 0) AND (@pbrExpression03='#M4PL#')) THEN NULL ELSE ISNULL(@pbrExpression03, PbrExpression03) END
			,[PbrLogic03]			= CASE WHEN (@isFormView = 1) THEN @pbrLogic03 WHEN ((@isFormView = 0) AND (@pbrLogic03='#M4PL#')) THEN NULL ELSE ISNULL(@pbrLogic03, PbrLogic03) END
			,[PbrExpression04]		= CASE WHEN (@isFormView = 1) THEN @pbrExpression04 WHEN ((@isFormView = 0) AND (@pbrExpression04='#M4PL#')) THEN NULL ELSE ISNULL(@pbrExpression04, PbrExpression04) END
			,[PbrLogic04]			= CASE WHEN (@isFormView = 1) THEN @pbrLogic04 WHEN ((@isFormView = 0) AND (@pbrLogic04='#M4PL#')) THEN NULL ELSE ISNULL(@pbrLogic04, PbrLogic04) END
			,[PbrExpression05]		= CASE WHEN (@isFormView = 1) THEN @pbrExpression05 WHEN ((@isFormView = 0) AND (@pbrExpression05='#M4PL#')) THEN NULL ELSE ISNULL(@pbrExpression05, PbrExpression05) END
			,[PbrLogic05]			= CASE WHEN (@isFormView = 1) THEN @pbrLogic05 WHEN ((@isFormView = 0) AND (@pbrLogic05='#M4PL#')) THEN NULL ELSE ISNULL(@pbrLogic05, PbrLogic05) END
			,[StatusId]				= CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
			,[PbrVendLocationID]	= CASE WHEN (@isFormView = 1) THEN @pbrVendLocationID WHEN ((@isFormView = 0) AND (@pbrVendLocationID=-100)) THEN NULL ELSE ISNULL(@pbrVendLocationID, PbrVendLocationID) END
			,[ChangedBy]			= @changedBy
			,[DateChanged]			= @dateChanged
	 WHERE   [Id] = @id
	SELECT prg.[Id]
		,prg.[PbrPrgrmID]
		,prg.[PbrCode]
		,prg.[PbrCustomerCode]
		,prg.[PbrEffectiveDate]
		,prg.[PbrTitle]
		,prg.[RateCategoryTypeId]
		,prg.[RateTypeId]
		,prg.[PbrBillablePrice]
		,prg.[RateUnitTypeId]
		,prg.[PbrFormat]
		,prg.[PbrExpression01]
		,prg.[PbrLogic01]
		,prg.[PbrExpression02]
		,prg.[PbrLogic02]
		,prg.[PbrExpression03]
		,prg.[PbrLogic03]
		,prg.[PbrExpression04]
		,prg.[PbrLogic04]
		,prg.[PbrExpression05]
		,prg.[PbrLogic05]
		,prg.[StatusId]
		,prg.[PbrVendLocationID]
		,prg.[EnteredBy]
		,prg.[DateEntered]
		,prg.[ChangedBy]
		,prg.[DateChanged]
  FROM   [dbo].[PRGRM040ProgramBillableRate] prg
 WHERE   [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdProgramCostRate]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Upd a Program Cost Rate
-- Execution:                 EXEC [dbo].[UpdProgramCostRate]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[UpdProgramCostRate]
	(@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id bigint
	,@pcrPrgrmId bigint = NULL
	,@pcrCode nvarchar(20) = NULL
	,@pcrVendorCode nvarchar(20) = NULL
	,@pcrEffectiveDate datetime2(7) = NULL
	,@pcrTitle nvarchar(50) = NULL
	,@rateCategoryTypeId INT = NULL
	,@rateTypeId INT = NULL
	,@pcrCostRate decimal(18, 2) = NULL
	,@rateUnitTypeId INT = NULL
	,@pcrFormat nvarchar(20) = NULL
	,@pcrExpression01 nvarchar(255) = NULL
	,@pcrLogic01 nvarchar(255) = NULL
	,@pcrExpression02 nvarchar(255) = NULL
	,@pcrLogic02 nvarchar(255) = NULL
	,@pcrExpression03 nvarchar(255) = NULL
	,@pcrLogic03 nvarchar(255) = NULL
	,@pcrExpression04 nvarchar(255) = NULL
	,@pcrLogic04 nvarchar(255) = NULL
	,@pcrExpression05 nvarchar(255) = NULL
	,@pcrLogic05 nvarchar(255) = NULL
	,@statusId INT = NULL
	,@pcrCustomerId bigint = NULL
	,@changedBy nvarchar(50) = NULL
	,@dateChanged datetime2(7) = NULL
	,@isFormView BIT = 0) 
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 UPDATE [dbo].[PRGRM041ProgramCostRate]
		SET  [PcrPrgrmID]            = CASE WHEN (@isFormView = 1) THEN @pcrPrgrmID WHEN ((@isFormView = 0) AND (@pcrPrgrmID=-100)) THEN NULL ELSE ISNULL(@pcrPrgrmID, PcrPrgrmID) END
			,[PcrCode]               = CASE WHEN (@isFormView = 1) THEN @pcrCode WHEN ((@isFormView = 0) AND (@pcrCode='#M4PL#')) THEN NULL ELSE ISNULL(@pcrCode, PcrCode) END
			,[PcrVendorCode]         = CASE WHEN (@isFormView = 1) THEN @pcrVendorCode WHEN ((@isFormView = 0) AND (@pcrVendorCode='#M4PL#')) THEN NULL ELSE ISNULL(@pcrVendorCode, PcrVendorCode) END
			,[PcrEffectiveDate]      = CASE WHEN (@isFormView = 1) THEN @pcrEffectiveDate WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @pcrEffectiveDate, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@pcrEffectiveDate, PcrEffectiveDate) END
			,[PcrTitle]              = CASE WHEN (@isFormView = 1) THEN @pcrTitle WHEN ((@isFormView = 0) AND (@pcrTitle='#M4PL#')) THEN NULL ELSE ISNULL(@pcrTitle, PcrTitle) END
			,[RateCategoryTypeId]    = CASE WHEN (@isFormView = 1) THEN @rateCategoryTypeId WHEN ((@isFormView = 0) AND (@rateCategoryTypeId=-100)) THEN NULL ELSE ISNULL(@rateCategoryTypeId, RateCategoryTypeId) END
			,[RateTypeId]            = CASE WHEN (@isFormView = 1) THEN @rateTypeId WHEN ((@isFormView = 0) AND (@rateTypeId=-100)) THEN NULL ELSE ISNULL(@rateTypeId, RateTypeId) END
			,[PcrCostRate]           = CASE WHEN (@isFormView = 1) THEN @pcrCostRate WHEN ((@isFormView = 0) AND (@pcrCostRate=-100.00)) THEN NULL ELSE ISNULL(@pcrCostRate, PcrCostRate) END
			,[RateUnitTypeId]		 = CASE WHEN (@isFormView = 1) THEN @rateUnitTypeId WHEN ((@isFormView = 0) AND (@rateUnitTypeId=-100)) THEN NULL ELSE ISNULL(@rateUnitTypeId, RateUnitTypeId) END
			,[PcrFormat]             = CASE WHEN (@isFormView = 1) THEN @pcrFormat WHEN ((@isFormView = 0) AND (@pcrFormat='#M4PL#')) THEN NULL ELSE ISNULL(@pcrFormat, PcrFormat) END
			,[PcrExpression01]       = CASE WHEN (@isFormView = 1) THEN @pcrExpression01 WHEN ((@isFormView = 0) AND (@pcrExpression01='#M4PL#')) THEN NULL ELSE ISNULL(@pcrExpression01, PcrExpression01) END
			,[PcrLogic01]            = CASE WHEN (@isFormView = 1) THEN @pcrLogic01 WHEN ((@isFormView = 0) AND (@pcrLogic01='#M4PL#')) THEN NULL ELSE ISNULL(@pcrLogic01, PcrLogic01) END
			,[PcrExpression02]       = CASE WHEN (@isFormView = 1) THEN @pcrExpression02 WHEN ((@isFormView = 0) AND (@pcrExpression02='#M4PL#')) THEN NULL ELSE ISNULL(@pcrExpression02, PcrExpression02) END
			,[PcrLogic02]            = CASE WHEN (@isFormView = 1) THEN @pcrLogic02 WHEN ((@isFormView = 0) AND (@pcrLogic02='#M4PL#')) THEN NULL ELSE ISNULL(@pcrLogic02, PcrLogic02) END
			,[PcrExpression03]       = CASE WHEN (@isFormView = 1) THEN @pcrExpression03 WHEN ((@isFormView = 0) AND (@pcrExpression03='#M4PL#')) THEN NULL ELSE ISNULL(@pcrExpression03, PcrExpression03) END
			,[PcrLogic03]            = CASE WHEN (@isFormView = 1) THEN @pcrLogic03 WHEN ((@isFormView = 0) AND (@pcrLogic03='#M4PL#')) THEN NULL ELSE ISNULL(@pcrLogic03, PcrLogic03) END
			,[PcrExpression04]       = CASE WHEN (@isFormView = 1) THEN @pcrExpression04 WHEN ((@isFormView = 0) AND (@pcrExpression04='#M4PL#')) THEN NULL ELSE ISNULL(@pcrExpression04, PcrExpression04) END
			,[PcrLogic04]            = CASE WHEN (@isFormView = 1) THEN @pcrLogic04 WHEN ((@isFormView = 0) AND (@pcrLogic04='#M4PL#')) THEN NULL ELSE ISNULL(@pcrLogic04, PcrLogic04) END
			,[PcrExpression05]       = CASE WHEN (@isFormView = 1) THEN @pcrExpression05 WHEN ((@isFormView = 0) AND (@pcrExpression05='#M4PL#')) THEN NULL ELSE ISNULL(@pcrExpression05, PcrExpression05) END
			,[PcrLogic05]            = CASE WHEN (@isFormView = 1) THEN @pcrLogic05 WHEN ((@isFormView = 0) AND (@pcrLogic05='#M4PL#')) THEN NULL ELSE ISNULL(@pcrLogic05, PcrLogic05) END
			,[StatusId]              = CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
			,[PcrCustomerID]         = CASE WHEN (@isFormView = 1) THEN @pcrCustomerID WHEN ((@isFormView = 0) AND (@pcrCustomerID=-100)) THEN NULL ELSE ISNULL(@pcrCustomerID, PcrCustomerID) END
			,[ChangedBy]             = @changedBy
			,[DateChanged]           = @dateChanged
	 WHERE   [Id] = @id
	SELECT prg.[Id]
		,prg.[PcrPrgrmID]
		,prg.[PcrCode]
		,prg.[PcrVendorCode]
		,prg.[PcrEffectiveDate]
		,prg.[PcrTitle]
		,prg.[RateCategoryTypeId]
		,prg.[RateTypeId]
		,prg.[PcrCostRate]
		,prg.[RateUnitTypeId]
		,prg.[PcrFormat]
		,prg.[PcrExpression01]
		,prg.[PcrLogic01]
		,prg.[PcrExpression02]
		,prg.[PcrLogic02]
		,prg.[PcrExpression03]
		,prg.[PcrLogic03]
		,prg.[PcrExpression04]
		,prg.[PcrLogic04]
		,prg.[PcrExpression05]
		,prg.[PcrLogic05]
		,prg.[StatusId]
		,prg.[PcrCustomerID]
		,prg.[EnteredBy]
		,prg.[DateEntered]
		,prg.[ChangedBy]
		,prg.[DateChanged]
  FROM   [dbo].[PRGRM041ProgramCostRate] prg
 WHERE   [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdProgramRole]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Upd a Program Role
-- Execution:                 EXEC [dbo].[UpdProgramRole]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[UpdProgramRole]
	(@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id bigint
	,@orgId bigint = NULL
	,@programId bigint = NULL
	,@prgRoleSortOrder int = NULL
	,@orgRoleId BIGINT = NULL
	,@prgRoleid BIGINT = NULL
	,@prgRoleCode nvarchar(25) = NULL
	,@prgRoleTitle nvarchar(50) = NULL
	,@prgRoleContactId bigint = NULL
	,@roleTypeId int = NULL
	,@statusId int = NULL

	,@prgLogical BIT  =NULL
	,@jobLogical BIT =NULL
	,@prxJobDefaultAnalyst BIT  =NULL
	,@prxJobDefaultResponsible BIT  =NULL
	,@prxJobGWDefaultAnalyst BIT  =NULL
	,@prxJobGWDefaultResponsible BIT  =NULL

	,@dateChanged datetime2(7) = NULL
	,@changedBy nvarchar(50) = NULL
	,@isFormView BIT = 0) 
AS
BEGIN TRY                
 SET NOCOUNT ON; 
 DECLARE @updatedItemNumber INT      
 EXEC [dbo].[ResetItemNumber] @userId, @id, @programId, @entity, @prgRoleSortOrder, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT 
  IF @prgRoleid > 0
  BEGIN
    UPDATE PRGRM020_Roles SET PrgRoleCode = @prgRoleCode WHERE Id =@prgRoleid AND ProgramID = @programId
  END

 IF NOT EXISTS(SELECT Id  FROM PRGRM020_Roles WHERE ProgramID =@programId AND PrgRoleCode = @prgRoleCode) AND ISNULL(@prgRoleid,0) = 0 AND @prgRoleCode IS NOT NULL
  BEGIN
     INSERT INTO PRGRM020_Roles(OrgID,ProgramID,PrgRoleCode,PrgRoleTitle,StatusId,DateEntered,EnteredBy)
	 VALUES (@orgId,@programId,@prgRoleCode,@prgRoleTitle,ISNULL(@statusId,1),@dateChanged,@changedBy)

	 SET @prgRoleid = SCOPE_IDENTITY();
  END

   
 UPDATE [dbo].[PRGRM020Program_Role]
		SET  [OrgID]                 = CASE WHEN (@isFormView = 1) THEN @orgID WHEN ((@isFormView = 0) AND (@orgID=-100)) THEN NULL ELSE ISNULL(@orgID, OrgID) END
			,[ProgramID]             = CASE WHEN (@isFormView = 1) THEN @programID WHEN ((@isFormView = 0) AND (@programID=-100)) THEN NULL ELSE ISNULL(@programID, ProgramID) END
			,[PrgRoleSortOrder]      = CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, PrgRoleSortOrder) END
			,[OrgRefRoleId]			 = CASE WHEN (@isFormView = 1) THEN @orgRoleId WHEN ((@isFormView = 0) AND (@orgRoleId=-100)) THEN NULL ELSE ISNULL(@orgRoleId, [OrgRefRoleId]) END
			,[PrgRoleId]			 = CASE WHEN (@isFormView = 1) THEN @prgRoleId WHEN ((@isFormView = 0) AND (@prgRoleId=-100)) THEN NULL ELSE ISNULL(@prgRoleId, PrgRoleId) END
			,[PrgRoleTitle]          = CASE WHEN (@isFormView = 1) THEN @prgRoleTitle WHEN ((@isFormView = 0) AND (@prgRoleTitle='#M4PL#')) THEN NULL ELSE ISNULL(@prgRoleTitle, PrgRoleTitle) END
			,[PrgRoleContactID]      = CASE WHEN (@isFormView = 1) THEN @prgRoleContactID WHEN ((@isFormView = 0) AND (@prgRoleContactID=-100)) THEN NULL ELSE ISNULL(@prgRoleContactID, PrgRoleContactID) END
			,[RoleTypeId]            = CASE WHEN (@isFormView = 1) THEN @roleTypeId WHEN ((@isFormView = 0) AND (@roleTypeId=-100)) THEN NULL ELSE ISNULL(@roleTypeId, RoleTypeId) END
			,[StatusId]				 = CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END

			,[PrgLogical]					= ISNULL(@prgLogical, PrgLogical)  
			,[JobLogical]					= ISNULL(@jobLogical, JobLogical)  
            ,[PrxJobDefaultAnalyst]		    = ISNULL(@prxJobDefaultAnalyst, PrxJobDefaultAnalyst)  
		    ,[PrxJobDefaultResponsible]  	= ISNULL(@prxJobDefaultResponsible, PrxJobDefaultResponsible)  
            ,[PrxJobGWDefaultAnalyst]		= ISNULL(@prxJobGWDefaultAnalyst, PrxJobGWDefaultAnalyst)  
            ,[PrxJobGWDefaultResponsible]   = ISNULL(@prxJobGWDefaultResponsible, PrxJobGWDefaultResponsible)     

			,[DateChanged]           = @dateChanged
			,[ChangedBy]             = @changedBy
	 WHERE   [Id] = @id
	SELECT prg.[Id]
		,prg.[OrgID]
		,prg.[ProgramID]
		,prg.[PrgRoleSortOrder]
		,prg.[OrgRefRoleId]
		,prg.[PrgRoleId]
		,prg.[PrgRoleTitle]
		,prg.[PrgRoleContactID]
		,prg.[RoleTypeId]
		,prg.[PrgLogical]
		,prg.[JobLogical]
		,prg.[PrxJobDefaultAnalyst]
		,prg.[PrxJobDefaultResponsible]
		,prg.[PrxJobGWDefaultAnalyst]
		,prg.[PrxJobGWDefaultResponsible]
		,prg.[DateEntered]
		,prg.[EnteredBy]
		,prg.[DateChanged]
		,prg.[ChangedBy]
  FROM   [dbo].[PRGRM020Program_Role] prg
 WHERE   [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdReport]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               12/01/2018      
-- Description:               Upd a Report
-- Execution:                 EXEC [dbo].[UpdReport]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================  
ALTER PROCEDURE  [dbo].[UpdReport]      
	@userId BIGINT  
	,@roleId BIGINT  
	,@entity NVARCHAR(100)  
	,@id BIGINT   
	,@orgId BIGINT = NULL  
	,@mainModuleId INT = NULL  
	,@reportName NVARCHAR(100) = NULL  
	,@reportDesc NVARCHAR(255) = NULL  
	,@isDefault BIT = NULL  
	,@statusId INT = NULL 
	,@dateChanged DATETIME2(7) = NULL  
	,@changedBy NVARCHAR(50) = NULL  
	,@isFormView BIT = 0
AS  
BEGIN TRY                  
 SET NOCOUNT ON;     
  UPDATE [dbo].[SYSTM000Ref_Report]  
   SET [OrganizationId]   =  CASE WHEN (@isFormView = 1) THEN @orgId WHEN ((@isFormView = 0) AND (@orgId=-100)) THEN NULL ELSE ISNULL(@orgId, OrganizationId)  END
   ,[RprtMainModuleId]    =  CASE WHEN (@isFormView = 1) THEN @mainModuleId WHEN ((@isFormView = 0) AND (@mainModuleId=-100)) THEN NULL ELSE ISNULL(@mainModuleId, RprtMainModuleId)   END 
   ,[RprtName]            =  CASE WHEN (@isFormView = 1) THEN @reportName WHEN ((@isFormView = 0) AND (@reportName='#M4PL#')) THEN NULL ELSE ISNULL(@reportName, RprtName)    END
   ,[RprtDescription]     =  CASE WHEN (@isFormView = 1) THEN @reportDesc WHEN ((@isFormView = 0) AND (@reportDesc='#M4PL#')) THEN NULL ELSE ISNULL(@reportDesc, RprtDescription)  END  
   ,[RprtIsDefault]       =  ISNULL(@isDefault, RprtIsDefault)
   ,[StatusId]			  =  CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId)  END
   ,[DateChanged]         =  @dateChanged  
   ,[ChangedBy]           =  @changedBy      
     WHERE   [Id] = @id     
 EXEC [dbo].[GetReport] @userId, @roleId,  @orgId,  'EN', @id    
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdScnCargo]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/09/2018      
-- Description:               Update a ScnCargo
-- Execution:                 EXEC [dbo].[UpdScnCargo]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================

ALTER PROCEDURE  [dbo].[UpdScnCargo]
	(@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id bigint
	,@cargoID BIGINT = NULL
	,@jobID BIGINT = NULL
	,@cgoLineItem INT = NULL
	,@cgoPartNumCode NVARCHAR(30) = NULL
	,@cgoQtyOrdered DECIMAL(18, 2) = NULL
	,@cgoQtyExpected DECIMAL(18, 2) = NULL
	,@cgoQtyCounted DECIMAL(18, 2) = NULL
	,@cgoQtyDamaged DECIMAL(18, 2) = NULL
	,@cgoQtyOnHold DECIMAL(18, 2) = NULL
	,@cgoQtyShort DECIMAL(18, 2) = NULL
	,@cgoQtyOver DECIMAL(18, 2) = NULL
	,@cgoQtyUnits NVARCHAR(20) = NULL
	,@cgoStatus NVARCHAR(20) = NULL
	,@cgoInfoID NVARCHAR(50) = NULL
	,@colorCD INT = NULL
	,@cgoSerialCD NVARCHAR(255) = NULL
	,@cgoLong NVARCHAR(30) = NULL
	,@cgoLat NVARCHAR(30) = NULL
	,@cgoProFlag01 NVARCHAR(1) = NULL
	,@cgoProFlag02 NVARCHAR(1) = NULL
	,@cgoProFlag03 NVARCHAR(1) = NULL
	,@cgoProFlag04 NVARCHAR(1) = NULL
	,@cgoProFlag05 NVARCHAR(1) = NULL
	,@cgoProFlag06 NVARCHAR(1) = NULL
	,@cgoProFlag07 NVARCHAR(1) = NULL
	,@cgoProFlag08 NVARCHAR(1) = NULL
	,@cgoProFlag09 NVARCHAR(1) = NULL
	,@cgoProFlag10 NVARCHAR(1) = NULL
	,@cgoProFlag11 NVARCHAR(1) = NULL
	,@cgoProFlag12 NVARCHAR(1) = NULL
	,@cgoProFlag13 NVARCHAR(1) = NULL
	,@cgoProFlag14 NVARCHAR(1) = NULL
	,@cgoProFlag15 NVARCHAR(1) = NULL
	,@cgoProFlag16 NVARCHAR(1) = NULL
	,@cgoProFlag17 NVARCHAR(1) = NULL
	,@cgoProFlag18 NVARCHAR(1) = NULL
	,@cgoProFlag19 NVARCHAR(1) = NULL
	,@cgoProFlag20 NVARCHAR(1) = NULL
	,@changedBy NVARCHAR(50) = NULL
	,@dateChanged DATETIME2(7) = NULL
	,@isFormView BIT = 0  )
AS
BEGIN TRY                
 SET NOCOUNT ON;   

 UPDATE [dbo].[SCN005Cargo]
      SET  [CargoID]			= CASE WHEN (@isFormView = 1) THEN @cargoID WHEN ((@isFormView = 0) AND (@cargoID=-100)) THEN NULL ELSE ISNULL(@cargoID, [CargoID]) END
		   ,[JobID]				= CASE WHEN (@isFormView = 1) THEN @jobID WHEN ((@isFormView = 0) AND (@jobID=-100)) THEN NULL ELSE ISNULL(@jobID, [JobID]) END
		   ,[CgoLineItem]		= CASE WHEN (@isFormView = 1) THEN @cgoLineItem WHEN ((@isFormView = 0) AND (@cgoLineItem=-100)) THEN NULL ELSE ISNULL(@cgoLineItem, [CgoLineItem]) END 
		   ,[CgoPartNumCode]	= CASE WHEN (@isFormView = 1) THEN @cgoPartNumCode WHEN ((@isFormView = 0) AND (@cgoPartNumCode='#M4PL#')) THEN NULL ELSE ISNULL(@cgoPartNumCode, [CgoPartNumCode]) END
           ,[CgoQtyOrdered]		= CASE WHEN (@isFormView = 1) THEN @cgoQtyOrdered WHEN ((@isFormView = 0) AND (@cgoQtyOrdered=-100.00)) THEN NULL ELSE ISNULL(@cgoQtyOrdered, [CgoQtyOrdered]) END
           ,[CgoQtyExpected]	= CASE WHEN (@isFormView = 1) THEN @cgoQtyExpected WHEN ((@isFormView = 0) AND (@cgoQtyExpected=-100.00)) THEN NULL ELSE ISNULL(@cgoQtyExpected, [CgoQtyExpected]) END
           ,[CgoQtyCounted]		= CASE WHEN (@isFormView = 1) THEN @cgoQtyCounted WHEN ((@isFormView = 0) AND (@cgoQtyCounted=-100.00)) THEN NULL ELSE ISNULL(@cgoQtyCounted, [CgoQtyCounted]) END
           ,[CgoQtyDamaged]		= CASE WHEN (@isFormView = 1) THEN @cgoQtyDamaged WHEN ((@isFormView = 0) AND (@cgoQtyDamaged=-100.00)) THEN NULL ELSE ISNULL(@cgoQtyDamaged, [CgoQtyDamaged]) END
           ,[CgoQtyOnHold]		= CASE WHEN (@isFormView = 1) THEN @cgoQtyOnHold WHEN ((@isFormView = 0) AND (@cgoQtyOnHold=-100.00)) THEN NULL ELSE ISNULL(@cgoQtyOnHold, [CgoQtyOnHold]) END
           ,[CgoQtyShort]		= CASE WHEN (@isFormView = 1) THEN @cgoQtyShort WHEN ((@isFormView = 0) AND (@cgoQtyShort=-100.00)) THEN NULL ELSE ISNULL(@cgoQtyShort, [CgoQtyShort]) END
           ,[CgoQtyOver]		= CASE WHEN (@isFormView = 1) THEN @cgoQtyOver WHEN ((@isFormView = 0) AND (@cgoQtyOver=-100.00)) THEN NULL ELSE ISNULL(@cgoQtyOver, [CgoQtyOver]) END
           ,[CgoQtyUnits]		= CASE WHEN (@isFormView = 1) THEN @cgoQtyUnits WHEN ((@isFormView = 0) AND (@cgoQtyUnits='#M4PL#')) THEN NULL ELSE ISNULL(@cgoQtyUnits, [CgoQtyUnits]) END
           ,[CgoStatus]			= CASE WHEN (@isFormView = 1) THEN @cgoStatus WHEN ((@isFormView = 0) AND (@cgoStatus='#M4PL#')) THEN NULL ELSE ISNULL(@cgoStatus, [CgoStatus]) END
           ,[CgoInfoID]			= CASE WHEN (@isFormView = 1) THEN @cgoInfoID WHEN ((@isFormView = 0) AND (@cgoInfoID='#M4PL#')) THEN NULL ELSE ISNULL(@cgoInfoID, [CgoInfoID]) END
		   ,[ColorCD]			= CASE WHEN (@isFormView = 1) THEN @colorCD WHEN ((@isFormView = 0) AND (@colorCD=-100)) THEN NULL ELSE ISNULL(@colorCD, [ColorCD]) END 
           ,[CgoSerialCD]		= CASE WHEN (@isFormView = 1) THEN @cgoSerialCD WHEN ((@isFormView = 0) AND (@cgoSerialCD='#M4PL#')) THEN NULL ELSE ISNULL(@cgoSerialCD, [CgoSerialCD]) END
           ,[CgoLong]			= CASE WHEN (@isFormView = 1) THEN @cgoLong WHEN ((@isFormView = 0) AND (@cgoLong='#M4PL#')) THEN NULL ELSE ISNULL(@cgoLong, [CgoLong]) END
           ,[CgoLat]			= CASE WHEN (@isFormView = 1) THEN @cgoLat WHEN ((@isFormView = 0) AND (@cgoLat='#M4PL#')) THEN NULL ELSE ISNULL(@cgoLat, [CgoLat]) END
           ,[CgoProFlag01]		= CASE WHEN (@isFormView = 1) THEN @cgoProFlag01 WHEN ((@isFormView = 0) AND (@cgoProFlag01='#M4PL#')) THEN NULL ELSE ISNULL(@cgoProFlag01, [CgoProFlag01]) END
           ,[CgoProFlag02]		= CASE WHEN (@isFormView = 1) THEN @cgoProFlag02 WHEN ((@isFormView = 0) AND (@cgoProFlag02='#M4PL#')) THEN NULL ELSE ISNULL(@cgoProFlag02, [CgoProFlag02]) END
           ,[CgoProFlag03]		= CASE WHEN (@isFormView = 1) THEN @cgoProFlag03 WHEN ((@isFormView = 0) AND (@cgoProFlag03='#M4PL#')) THEN NULL ELSE ISNULL(@cgoProFlag03, [CgoProFlag03]) END
           ,[CgoProFlag04]		= CASE WHEN (@isFormView = 1) THEN @cgoProFlag04 WHEN ((@isFormView = 0) AND (@cgoProFlag04='#M4PL#')) THEN NULL ELSE ISNULL(@cgoProFlag04, [CgoProFlag04]) END
           ,[CgoProFlag05]		= CASE WHEN (@isFormView = 1) THEN @cgoProFlag05 WHEN ((@isFormView = 0) AND (@cgoProFlag05='#M4PL#')) THEN NULL ELSE ISNULL(@cgoProFlag05, [CgoProFlag05]) END
           ,[CgoProFlag06]		= CASE WHEN (@isFormView = 1) THEN @cgoProFlag06 WHEN ((@isFormView = 0) AND (@cgoProFlag06='#M4PL#')) THEN NULL ELSE ISNULL(@cgoProFlag06, [CgoProFlag06]) END
           ,[CgoProFlag07]		= CASE WHEN (@isFormView = 1) THEN @cgoProFlag07 WHEN ((@isFormView = 0) AND (@cgoProFlag07='#M4PL#')) THEN NULL ELSE ISNULL(@cgoProFlag07, [CgoProFlag07]) END
           ,[CgoProFlag08]		= CASE WHEN (@isFormView = 1) THEN @cgoProFlag08 WHEN ((@isFormView = 0) AND (@cgoProFlag08='#M4PL#')) THEN NULL ELSE ISNULL(@cgoProFlag08, [CgoProFlag08]) END
           ,[CgoProFlag09]		= CASE WHEN (@isFormView = 1) THEN @cgoProFlag09 WHEN ((@isFormView = 0) AND (@cgoProFlag09='#M4PL#')) THEN NULL ELSE ISNULL(@cgoProFlag09, [CgoProFlag09]) END
           ,[CgoProFlag10]		= CASE WHEN (@isFormView = 1) THEN @cgoProFlag10 WHEN ((@isFormView = 0) AND (@cgoProFlag10='#M4PL#')) THEN NULL ELSE ISNULL(@cgoProFlag10, [CgoProFlag10]) END
           ,[CgoProFlag11]		= CASE WHEN (@isFormView = 1) THEN @cgoProFlag11 WHEN ((@isFormView = 0) AND (@cgoProFlag11='#M4PL#')) THEN NULL ELSE ISNULL(@cgoProFlag11, [CgoProFlag11]) END
           ,[CgoProFlag12]		= CASE WHEN (@isFormView = 1) THEN @cgoProFlag12 WHEN ((@isFormView = 0) AND (@cgoProFlag12='#M4PL#')) THEN NULL ELSE ISNULL(@cgoProFlag12, [CgoProFlag12]) END
           ,[CgoProFlag13]		= CASE WHEN (@isFormView = 1) THEN @cgoProFlag13 WHEN ((@isFormView = 0) AND (@cgoProFlag13='#M4PL#')) THEN NULL ELSE ISNULL(@cgoProFlag13, [CgoProFlag13]) END
           ,[CgoProFlag14]		= CASE WHEN (@isFormView = 1) THEN @cgoProFlag14 WHEN ((@isFormView = 0) AND (@cgoProFlag14='#M4PL#')) THEN NULL ELSE ISNULL(@cgoProFlag14, [CgoProFlag14]) END
           ,[CgoProFlag15]		= CASE WHEN (@isFormView = 1) THEN @cgoProFlag15 WHEN ((@isFormView = 0) AND (@cgoProFlag15='#M4PL#')) THEN NULL ELSE ISNULL(@cgoProFlag15, [CgoProFlag15]) END
           ,[CgoProFlag16]		= CASE WHEN (@isFormView = 1) THEN @cgoProFlag16 WHEN ((@isFormView = 0) AND (@cgoProFlag16='#M4PL#')) THEN NULL ELSE ISNULL(@cgoProFlag16, [CgoProFlag16]) END
           ,[CgoProFlag17]		= CASE WHEN (@isFormView = 1) THEN @cgoProFlag17 WHEN ((@isFormView = 0) AND (@cgoProFlag17='#M4PL#')) THEN NULL ELSE ISNULL(@cgoProFlag17, [CgoProFlag17]) END
           ,[CgoProFlag18]		= CASE WHEN (@isFormView = 1) THEN @cgoProFlag18 WHEN ((@isFormView = 0) AND (@cgoProFlag18='#M4PL#')) THEN NULL ELSE ISNULL(@cgoProFlag18, [CgoProFlag18]) END
           ,[CgoProFlag19]		= CASE WHEN (@isFormView = 1) THEN @cgoProFlag19 WHEN ((@isFormView = 0) AND (@cgoProFlag19='#M4PL#')) THEN NULL ELSE ISNULL(@cgoProFlag19, [CgoProFlag19]) END
           ,[CgoProFlag20]		= CASE WHEN (@isFormView = 1) THEN @cgoProFlag20 WHEN ((@isFormView = 0) AND (@cgoProFlag20='#M4PL#')) THEN NULL ELSE ISNULL(@cgoProFlag20, [CgoProFlag20]) END
	WHERE	[CargoID] = @id

	EXEC [dbo].[GetScnCargo] @userId, @roleId,0 ,@id 
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdScnCargoDetail]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/09/2018      
-- Description:               Update a ScnCargoDetail
-- Execution:                 EXEC [dbo].[UpdScnCargoDetail]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================

ALTER PROCEDURE  [dbo].[UpdScnCargoDetail]
	(@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id bigint
	,@cargoDetailID BIGINT = NULL
	,@cargoID BIGINT = NULL
	,@detSerialNumber NVARCHAR(255) = NULL
	,@detQtyCounted DECIMAL(18, 2) = NULL
	,@detQtyDamaged  DECIMAL(18, 2) = NULL
	,@detQtyShort  DECIMAL(18, 2) = NULL
	,@detQtyOver  DECIMAL(18, 2) = NULL
	,@detPickStatus NVARCHAR(20) = NULL
	,@detLong NVARCHAR(30) = NULL
	,@detLat NVARCHAR(30) = NULL
	,@changedBy NVARCHAR(50) = NULL
	,@dateChanged DATETIME2(7) = NULL
	,@isFormView BIT = 0)
AS
BEGIN TRY                
 SET NOCOUNT ON;   

 UPDATE [dbo].[SCN006CargoDetail]
      --SET   [CargoDetailID]		= CASE WHEN (@isFormView = 1) THEN @cargoDetailID WHEN ((@isFormView = 0) AND (@cargoDetailID=-100)) THEN NULL ELSE ISNULL(@cargoDetailID, [CargoDetailID]) END
      SET   [CargoID]			= CASE WHEN (@isFormView = 1) THEN @cargoID WHEN ((@isFormView = 0) AND (@cargoID=-100)) THEN NULL ELSE ISNULL(@cargoID, [CargoID]) END
		   ,[DetSerialNumber]	= CASE WHEN (@isFormView = 1) THEN @detSerialNumber WHEN ((@isFormView = 0) AND (@detSerialNumber='#M4PL#')) THEN NULL ELSE ISNULL(@detSerialNumber, [DetSerialNumber]) END
           ,[DetQtyCounted]		= CASE WHEN (@isFormView = 1) THEN @detQtyCounted WHEN ((@isFormView = 0) AND (@detQtyCounted=-100.00)) THEN NULL ELSE ISNULL(@detQtyCounted, [DetQtyCounted]) END
           ,[DetQtyDamaged]		= CASE WHEN (@isFormView = 1) THEN @detQtyDamaged WHEN ((@isFormView = 0) AND (@detQtyDamaged=-100.00)) THEN NULL ELSE ISNULL(@detQtyDamaged, [DetQtyDamaged]) END
           ,[DetQtyShort]		= CASE WHEN (@isFormView = 1) THEN @detQtyShort WHEN ((@isFormView = 0) AND (@detQtyShort=-100.00)) THEN NULL ELSE ISNULL(@detQtyShort, [DetQtyShort]) END
           ,[DetQtyOver]		= CASE WHEN (@isFormView = 1) THEN @detQtyOver WHEN ((@isFormView = 0) AND (@detQtyOver=-100.00)) THEN NULL ELSE ISNULL(@detQtyOver, [DetQtyOver]) END
           ,[DetPickStatus]		= CASE WHEN (@isFormView = 1) THEN @detPickStatus WHEN ((@isFormView = 0) AND (@detPickStatus='#M4PL#')) THEN NULL ELSE ISNULL(@detPickStatus, [DetPickStatus]) END
           ,[DetLong]			= CASE WHEN (@isFormView = 1) THEN @detLong WHEN ((@isFormView = 0) AND (@detLong='#M4PL#')) THEN NULL ELSE ISNULL(@detLong, [DetLong]) END
           ,[DetLat]			= CASE WHEN (@isFormView = 1) THEN @detLat WHEN ((@isFormView = 0) AND (@detLat='#M4PL#')) THEN NULL ELSE ISNULL(@detLat, [DetLat]) END
	WHERE	[CargoDetailID] = @id

	EXEC [dbo].[GetScnCargoDetail] @userId, @roleId,0 ,@id 
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdScnDriverList]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/09/2018      
-- Description:               Update a ScnDriverList
-- Execution:                 EXEC [dbo].[UpdScnDriverList]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================

ALTER PROCEDURE  [dbo].[UpdScnDriverList]
	(@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id bigint
	,@driverID BIGINT = NULL
	,@firstName NVARCHAR(50) = NULL
	,@lastName NVARCHAR(50) = NULL
	,@programID BIGINT = NULL
	,@locationNumber NVARCHAR(20) = NULL
	,@changedBy NVARCHAR(50) = NULL
	,@dateChanged DATETIME2(7) = NULL
	,@isFormView BIT = 0  )
AS
BEGIN TRY                
 SET NOCOUNT ON;   

 UPDATE [dbo].[SCN016DriverList]
      SET   [DriverID]			= CASE WHEN (@isFormView = 1) THEN @driverID WHEN ((@isFormView = 0) AND (@driverID=-100)) THEN NULL ELSE ISNULL(@driverID, [DriverID]) END
           ,[FirstName]			= CASE WHEN (@isFormView = 1) THEN @firstName WHEN ((@isFormView = 0) AND (@firstName='#M4PL#')) THEN NULL ELSE ISNULL(@firstName  , [FirstName]) END
           ,[LastName]			= CASE WHEN (@isFormView = 1) THEN @lastName WHEN ((@isFormView = 0) AND (@lastName='#M4PL#')) THEN NULL ELSE ISNULL(@lastName, [LastName]) END
           ,[ProgramID]			= CASE WHEN (@isFormView = 1) THEN @programID WHEN ((@isFormView = 0) AND (@programID=-100)) THEN NULL ELSE ISNULL(@programID, [ProgramID]) END
           ,[LocationNumber]	= CASE WHEN (@isFormView = 1) THEN @locationNumber WHEN ((@isFormView = 0) AND (@locationNumber='#M4PL#')) THEN NULL ELSE ISNULL(@locationNumber, [LocationNumber]) END
	WHERE	[DriverID] = @id

	EXEC [dbo].[GetScnDriverList] @userId, @roleId, 0 ,@driverID 
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdScnOrder]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/09/2018      
-- Description:               Update a ScnOrder
-- Execution:                 EXEC [dbo].[UpdScnOrder]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================

ALTER PROCEDURE  [dbo].[UpdScnOrder]
(@userId BIGINT
,@roleId BIGINT  
,@entity NVARCHAR(100)
,@id bigint
,@jobID BIGINT = NULL
,@programID BIGINT = NULL
,@routeID INT = NULL
,@driverID BIGINT = NULL
,@jobDeviceID NVARCHAR(30) = NULL
,@jobStop INT = NULL
,@jobOrderID NVARCHAR(30) = NULL
,@jobManifestID NVARCHAR(30) = NULL
,@jobCarrierID NVARCHAR(30) = NULL
,@jobReturnReasonID INT = NULL
,@jobStatusCD NVARCHAR(30) = NULL
,@jobOriginSiteCode NVARCHAR(30) = NULL
,@jobOriginSiteName NVARCHAR(50) = NULL
,@jobDeliverySitePOC NVARCHAR(75) = NULL
,@jobDeliverySitePOC2 NVARCHAR(75) = NULL
,@jobDeliveryStreetAddress NVARCHAR(100) = NULL
,@jobDeliveryStreetAddress2 NVARCHAR(100) = NULL
,@jobDeliveryCity NVARCHAR(50) = NULL
,@jobDeliveryStateProvince NVARCHAR(50) = NULL
,@jobDeliveryPostalCode NVARCHAR(50) = NULL
,@jobDeliveryCountry NVARCHAR(50) = NULL
,@jobDeliverySitePOCPhone NVARCHAR(50) = NULL
,@jobDeliverySitePOCPhone2 NVARCHAR(50) = NULL
,@jobDeliveryPhoneHm  NVARCHAR(50) = NULL
,@jobDeliverySitePOCEmail NVARCHAR(50) = NULL
,@jobDeliverySitePOCEmail2 NVARCHAR(50) = NULL
,@jobOriginStreetAddress NVARCHAR(100) = NULL
,@jobOriginCity NVARCHAR(50) = NULL
,@jobOriginStateProvince NVARCHAR(50) = NULL
,@jobOriginPostalCode NVARCHAR(50) = NULL
,@jobOriginCountry NVARCHAR(50) = NULL
,@jobLongitude NVARCHAR(30) = NULL
,@jobLatitude NVARCHAR(30) = NULL
,@jobSignLongitude NVARCHAR(30) = NULL
,@jobSignLatitude NVARCHAR(30) = NULL
,@jobSignText NVARCHAR(50) = NULL
,@jobScheduledDate DATETIME2(7) = NULL
,@jobScheduledTime DATETIME2(7) = NULL
,@jobEstimatedDate DATETIME2(7) = NULL
,@jobEstimatedTime DATETIME2(7) = NULL
,@jobActualDate DATETIME2(7) = NULL
,@jobActualTime DATETIME2(7) = NULL
,@colorCD INT = NULL
,@jobFor NVARCHAR(50) = NULL
,@jobFrom NVARCHAR(50) = NULL
,@windowStartTime DATETIME2(7) = NULL
,@windowEndTime DATETIME2(7) = NULL
,@jobFlag01 NVARCHAR(1) = NULL
,@jobFlag02 NVARCHAR(1) = NULL
,@jobFlag03 NVARCHAR(1) = NULL
,@jobFlag04 NVARCHAR(1) = NULL
,@jobFlag05 NVARCHAR(1) = NULL
,@jobFlag06 NVARCHAR(1) = NULL
,@jobFlag07 NVARCHAR(1) = NULL
,@jobFlag08 NVARCHAR(1) = NULL
,@jobFlag09 NVARCHAR(1) = NULL
,@jobFlag10 NVARCHAR(1) = NULL
,@jobFlag11 NVARCHAR(1) = NULL
,@jobFlag12 NVARCHAR(1) = NULL
,@jobFlag13 NVARCHAR(1) = NULL
,@jobFlag14 NVARCHAR(1) = NULL
,@jobFlag15 NVARCHAR(1) = NULL
,@jobFlag16 NVARCHAR(1) = NULL
,@jobFlag17 NVARCHAR(1) = NULL
,@jobFlag18 NVARCHAR(1) = NULL
,@jobFlag19 NVARCHAR(1) = NULL
,@jobFlag20 NVARCHAR(1) = NULL
,@jobFlag21 INT = NULL
,@jobFlag22 BIGINT = NULL
,@jobFlag23 INT = NULL
,@changedBy NVARCHAR(50) = NULL
,@dateChanged DATETIME2(7) = NULL
,@isFormView BIT = 0)
AS
BEGIN TRY                
 SET NOCOUNT ON;   

 UPDATE [dbo].[SCN000Order]
      SET   [JobID]						= CASE WHEN (@isFormView = 1) THEN @jobID WHEN ((@isFormView = 0) AND (@jobID=-100)) THEN NULL ELSE ISNULL(@jobID, [JobID]) END
		   ,[ProgramID]					= CASE WHEN (@isFormView = 1) THEN @programID WHEN ((@isFormView = 0) AND (@programID=-100)) THEN NULL ELSE ISNULL(@programID, [ProgramID]) END
		   ,[RouteID]					= CASE WHEN (@isFormView = 1) THEN @routeID WHEN ((@isFormView = 0) AND (@routeID=-100)) THEN NULL ELSE ISNULL(@routeID, [RouteID]) END
		   ,[DriverID]					= CASE WHEN (@isFormView = 1) THEN @driverID WHEN ((@isFormView = 0) AND (@driverID=-100)) THEN NULL ELSE ISNULL(@driverID, [DriverID]) END
           ,[JobDeviceID]				= CASE WHEN (@isFormView = 1) THEN @jobDeviceID WHEN ((@isFormView = 0) AND (@jobDeviceID='#M4PL#')) THEN NULL ELSE ISNULL(@jobDeviceID, [JobDeviceID]) END
		   ,[JobStop]					= CASE WHEN (@isFormView = 1) THEN @jobStop WHEN ((@isFormView = 0) AND (@jobStop=-100)) THEN NULL ELSE ISNULL(@jobStop, [JobStop]) END
           ,[JobOrderID]				= CASE WHEN (@isFormView = 1) THEN @jobOrderID WHEN ((@isFormView = 0) AND (@jobOrderID='#M4PL#')) THEN NULL ELSE ISNULL(@jobOrderID, [JobOrderID]) END
           ,[JobManifestID]				= CASE WHEN (@isFormView = 1) THEN @jobManifestID WHEN ((@isFormView = 0) AND (@jobManifestID='#M4PL#')) THEN NULL ELSE ISNULL(@jobManifestID, [JobManifestID]) END
           ,[JobCarrierID]				= CASE WHEN (@isFormView = 1) THEN @jobCarrierID WHEN ((@isFormView = 0) AND (@jobCarrierID='#M4PL#')) THEN NULL ELSE ISNULL(@jobCarrierID, [JobCarrierID]) END
		   ,[JobReturnReasonID]			= CASE WHEN (@isFormView = 1) THEN @jobReturnReasonID WHEN ((@isFormView = 0) AND (@jobReturnReasonID=-100)) THEN NULL ELSE ISNULL(@jobReturnReasonID, [JobReturnReasonID]) END
           ,[JobStatusCD]				= CASE WHEN (@isFormView = 1) THEN @jobStatusCD WHEN ((@isFormView = 0) AND (@jobStatusCD='#M4PL#')) THEN NULL ELSE ISNULL(@jobStatusCD, [JobStatusCD]) END
           ,[JobOriginSiteCode]			= CASE WHEN (@isFormView = 1) THEN @jobOriginSiteCode WHEN ((@isFormView = 0) AND (@jobOriginSiteCode='#M4PL#')) THEN NULL ELSE ISNULL(@jobOriginSiteCode, [JobOriginSiteCode]) END
           ,[JobOriginSiteName]			= CASE WHEN (@isFormView = 1) THEN @jobOriginSiteName WHEN ((@isFormView = 0) AND (@jobOriginSiteName='#M4PL#')) THEN NULL ELSE ISNULL(@jobOriginSiteName, [JobOriginSiteName]) END
           ,[JobDeliverySitePOC]		= CASE WHEN (@isFormView = 1) THEN @jobDeliverySitePOC WHEN ((@isFormView = 0) AND (@jobDeliverySitePOC='#M4PL#')) THEN NULL ELSE ISNULL(@jobDeliverySitePOC, [JobDeliverySitePOC]) END
           ,[JobDeliverySitePOC2]		= CASE WHEN (@isFormView = 1) THEN @jobDeliverySitePOC2 WHEN ((@isFormView = 0) AND (@jobDeliverySitePOC2='#M4PL#')) THEN NULL ELSE ISNULL(@jobDeliverySitePOC2, [JobDeliverySitePOC2]) END
           ,[JobDeliveryStreetAddress]	= CASE WHEN (@isFormView = 1) THEN @jobDeliveryStreetAddress WHEN ((@isFormView = 0) AND (@jobDeliveryStreetAddress='#M4PL#')) THEN NULL ELSE ISNULL(@jobDeliveryStreetAddress, [JobDeliveryStreetAddress]) END
           ,[JobDeliveryStreetAddress2]	= CASE WHEN (@isFormView = 1) THEN @jobDeliveryStreetAddress2 WHEN ((@isFormView = 0) AND (@jobDeliveryStreetAddress2='#M4PL#')) THEN NULL ELSE ISNULL(@jobDeliveryStreetAddress2, [JobDeliveryStreetAddress2]) END
           ,[JobDeliveryCity]			= CASE WHEN (@isFormView = 1) THEN @jobDeliveryCity WHEN ((@isFormView = 0) AND (@jobDeliveryCity='#M4PL#')) THEN NULL ELSE ISNULL(@jobDeliveryCity, [JobDeliveryCity]) END
           ,[JobDeliveryStateProvince]	= CASE WHEN (@isFormView = 1) THEN @jobDeliveryStateProvince WHEN ((@isFormView = 0) AND (@jobDeliveryStateProvince='#M4PL#')) THEN NULL ELSE ISNULL(@jobDeliveryStateProvince, [JobDeliveryStateProvince]) END
           ,[JobDeliveryPostalCode]		= CASE WHEN (@isFormView = 1) THEN @jobDeliveryPostalCode WHEN ((@isFormView = 0) AND (@jobDeliveryPostalCode='#M4PL#')) THEN NULL ELSE ISNULL(@jobDeliveryPostalCode, [JobDeliveryPostalCode]) END
           ,[JobDeliveryCountry]		= CASE WHEN (@isFormView = 1) THEN @jobDeliveryCountry WHEN ((@isFormView = 0) AND (@jobDeliveryCountry='#M4PL#')) THEN NULL ELSE ISNULL(@jobDeliveryCountry, [JobDeliveryCountry]) END
           ,[JobDeliverySitePOCPhone]	= CASE WHEN (@isFormView = 1) THEN @jobDeliverySitePOCPhone WHEN ((@isFormView = 0) AND (@jobDeliverySitePOCPhone='#M4PL#')) THEN NULL ELSE ISNULL(@jobDeliverySitePOCPhone, [JobDeliverySitePOCPhone]) END
           ,[JobDeliverySitePOCPhone2]	= CASE WHEN (@isFormView = 1) THEN @jobDeliverySitePOCPhone2 WHEN ((@isFormView = 0) AND (@jobDeliverySitePOCPhone2='#M4PL#')) THEN NULL ELSE ISNULL(@jobDeliverySitePOCPhone2, [JobDeliverySitePOCPhone2]) END
           ,[JobDeliveryPhoneHm]		= CASE WHEN (@isFormView = 1) THEN @jobDeliveryPhoneHm WHEN ((@isFormView = 0) AND (@jobDeliveryPhoneHm='#M4PL#')) THEN NULL ELSE ISNULL(@jobDeliveryPhoneHm, [JobDeliveryPhoneHm]) END
           ,[JobDeliverySitePOCEmail]	= CASE WHEN (@isFormView = 1) THEN @jobDeliverySitePOCEmail WHEN ((@isFormView = 0) AND (@jobDeliverySitePOCEmail='#M4PL#')) THEN NULL ELSE ISNULL(@jobDeliverySitePOCEmail, [JobDeliverySitePOCEmail]) END
           ,[JobDeliverySitePOCEmail2]	= CASE WHEN (@isFormView = 1) THEN @jobDeliverySitePOCEmail2 WHEN ((@isFormView = 0) AND (@jobDeliverySitePOCEmail2='#M4PL#')) THEN NULL ELSE ISNULL(@jobDeliverySitePOCEmail2, [JobDeliverySitePOCEmail2]) END
           ,[JobOriginStreetAddress]	= CASE WHEN (@isFormView = 1) THEN @jobOriginStreetAddress WHEN ((@isFormView = 0) AND (@jobOriginStreetAddress='#M4PL#')) THEN NULL ELSE ISNULL(@jobOriginStreetAddress, [JobOriginStreetAddress]) END
           ,[JobOriginCity]				= CASE WHEN (@isFormView = 1) THEN @jobOriginCity WHEN ((@isFormView = 0) AND (@jobOriginCity='#M4PL#')) THEN NULL ELSE ISNULL(@jobOriginCity, [JobOriginCity]) END
           ,[JobOriginStateProvince]	= CASE WHEN (@isFormView = 1) THEN @jobOriginStateProvince WHEN ((@isFormView = 0) AND (@jobOriginStateProvince='#M4PL#')) THEN NULL ELSE ISNULL(@jobOriginStateProvince, [JobOriginStateProvince]) END
           ,[JobOriginPostalCode]		= CASE WHEN (@isFormView = 1) THEN @jobOriginPostalCode WHEN ((@isFormView = 0) AND (@jobOriginPostalCode='#M4PL#')) THEN NULL ELSE ISNULL(@jobOriginPostalCode, [JobOriginPostalCode]) END
           ,[JobOriginCountry]			= CASE WHEN (@isFormView = 1) THEN @jobOriginCountry WHEN ((@isFormView = 0) AND (@jobOriginCountry='#M4PL#')) THEN NULL ELSE ISNULL(@jobOriginCountry, [JobOriginCountry]) END
           ,[JobLongitude]				= CASE WHEN (@isFormView = 1) THEN @jobLongitude WHEN ((@isFormView = 0) AND (@jobLongitude='#M4PL#')) THEN NULL ELSE ISNULL(@jobLongitude, [JobLongitude]) END
           ,[JobLatitude]				= CASE WHEN (@isFormView = 1) THEN @jobLatitude WHEN ((@isFormView = 0) AND (@jobLatitude='#M4PL#')) THEN NULL ELSE ISNULL(@jobLatitude, [JobLatitude]) END
           ,[JobSignLongitude]			= CASE WHEN (@isFormView = 1) THEN @jobSignLongitude WHEN ((@isFormView = 0) AND (@jobSignLongitude='#M4PL#')) THEN NULL ELSE ISNULL(@jobSignLongitude, [JobSignLongitude]) END
           ,[JobSignLatitude]			= CASE WHEN (@isFormView = 1) THEN @jobSignLatitude WHEN ((@isFormView = 0) AND (@jobSignLatitude='#M4PL#')) THEN NULL ELSE ISNULL(@jobSignLatitude, [JobSignLatitude]) END
           ,[JobSignText]				= CASE WHEN (@isFormView = 1) THEN @jobSignText WHEN ((@isFormView = 0) AND (@jobSignText='#M4PL#')) THEN NULL ELSE ISNULL(@jobSignText, [JobSignText]) END
		   ,[JobScheduledDate]			= CASE WHEN (@isFormView = 1) THEN @jobScheduledDate WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @jobScheduledDate, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@jobScheduledDate, [JobScheduledDate]) END    
		   ,[JobScheduledTime]			= CASE WHEN (@isFormView = 1) THEN @jobScheduledTime WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @jobScheduledTime, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@jobScheduledTime, [JobScheduledTime]) END    
		   ,[JobEstimatedDate]			= CASE WHEN (@isFormView = 1) THEN @jobEstimatedDate WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @jobEstimatedDate, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@jobEstimatedDate, [JobEstimatedDate]) END    
		   ,[JobEstimatedTime]			= CASE WHEN (@isFormView = 1) THEN @jobEstimatedTime WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @jobEstimatedTime, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@jobEstimatedTime, [JobEstimatedTime]) END    
		   ,[JobActualDate]				= CASE WHEN (@isFormView = 1) THEN @jobActualDate WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @jobActualDate, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@jobActualDate, [JobActualDate]) END    
		   ,[JobActualTime]				= CASE WHEN (@isFormView = 1) THEN @jobActualTime WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @jobActualTime, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@jobActualTime, [JobActualTime]) END    
		   ,[ColorCD]					= CASE WHEN (@isFormView = 1) THEN @colorCD WHEN ((@isFormView = 0) AND (@colorCD=-100)) THEN NULL ELSE ISNULL(@colorCD, [ColorCD]) END
           ,[JobFor]					= CASE WHEN (@isFormView = 1) THEN @jobFor WHEN ((@isFormView = 0) AND (@jobFor='#M4PL#')) THEN NULL ELSE ISNULL(@jobFor, [JobFor]) END
           ,[JobFrom]					= CASE WHEN (@isFormView = 1) THEN @jobFrom WHEN ((@isFormView = 0) AND (@jobFrom='#M4PL#')) THEN NULL ELSE ISNULL(@jobFrom, [JobFrom]) END
		   ,[WindowStartTime]			= CASE WHEN (@isFormView = 1) THEN @windowStartTime WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @windowStartTime, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@windowStartTime, [WindowStartTime]) END    
		   ,[WindowEndTime]				= CASE WHEN (@isFormView = 1) THEN @windowEndTime WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @windowEndTime, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@windowEndTime, [WindowEndTime]) END    
           ,[JobFlag01]					= CASE WHEN (@isFormView = 1) THEN @jobFlag01 WHEN ((@isFormView = 0) AND (@jobFlag01='#M4PL#')) THEN NULL ELSE ISNULL(@jobFlag01, [JobFlag01]) END
           ,[JobFlag02]					= CASE WHEN (@isFormView = 1) THEN @jobFlag02 WHEN ((@isFormView = 0) AND (@jobFlag02='#M4PL#')) THEN NULL ELSE ISNULL(@jobFlag02, [JobFlag02]) END
           ,[JobFlag03]					= CASE WHEN (@isFormView = 1) THEN @jobFlag03 WHEN ((@isFormView = 0) AND (@jobFlag03='#M4PL#')) THEN NULL ELSE ISNULL(@jobFlag03, [JobFlag03]) END
           ,[JobFlag04]					= CASE WHEN (@isFormView = 1) THEN @jobFlag04 WHEN ((@isFormView = 0) AND (@jobFlag04='#M4PL#')) THEN NULL ELSE ISNULL(@jobFlag04, [JobFlag04]) END
           ,[JobFlag05]					= CASE WHEN (@isFormView = 1) THEN @jobFlag05 WHEN ((@isFormView = 0) AND (@jobFlag05='#M4PL#')) THEN NULL ELSE ISNULL(@jobFlag05, [JobFlag05]) END
           ,[JobFlag06]					= CASE WHEN (@isFormView = 1) THEN @jobFlag06 WHEN ((@isFormView = 0) AND (@jobFlag06='#M4PL#')) THEN NULL ELSE ISNULL(@jobFlag06, [JobFlag06]) END
           ,[JobFlag07]					= CASE WHEN (@isFormView = 1) THEN @jobFlag07 WHEN ((@isFormView = 0) AND (@jobFlag07='#M4PL#')) THEN NULL ELSE ISNULL(@jobFlag07, [JobFlag07]) END
           ,[JobFlag08]					= CASE WHEN (@isFormView = 1) THEN @jobFlag08 WHEN ((@isFormView = 0) AND (@jobFlag08='#M4PL#')) THEN NULL ELSE ISNULL(@jobFlag08, [JobFlag08]) END
           ,[JobFlag09]					= CASE WHEN (@isFormView = 1) THEN @jobFlag09 WHEN ((@isFormView = 0) AND (@jobFlag09='#M4PL#')) THEN NULL ELSE ISNULL(@jobFlag09, [JobFlag09]) END
           ,[JobFlag10]					= CASE WHEN (@isFormView = 1) THEN @jobFlag10 WHEN ((@isFormView = 0) AND (@jobFlag10='#M4PL#')) THEN NULL ELSE ISNULL(@jobFlag10, [JobFlag10]) END
           ,[JobFlag11]					= CASE WHEN (@isFormView = 1) THEN @jobFlag11 WHEN ((@isFormView = 0) AND (@jobFlag11='#M4PL#')) THEN NULL ELSE ISNULL(@jobFlag11, [JobFlag11]) END
           ,[JobFlag12]					= CASE WHEN (@isFormView = 1) THEN @jobFlag12 WHEN ((@isFormView = 0) AND (@jobFlag12='#M4PL#')) THEN NULL ELSE ISNULL(@jobFlag12, [JobFlag12]) END
           ,[JobFlag13]					= CASE WHEN (@isFormView = 1) THEN @jobFlag13 WHEN ((@isFormView = 0) AND (@jobFlag13='#M4PL#')) THEN NULL ELSE ISNULL(@jobFlag13, [JobFlag13]) END
           ,[JobFlag14]					= CASE WHEN (@isFormView = 1) THEN @jobFlag14 WHEN ((@isFormView = 0) AND (@jobFlag14='#M4PL#')) THEN NULL ELSE ISNULL(@jobFlag14, [JobFlag14]) END
           ,[JobFlag15]					= CASE WHEN (@isFormView = 1) THEN @jobFlag15 WHEN ((@isFormView = 0) AND (@jobFlag15='#M4PL#')) THEN NULL ELSE ISNULL(@jobFlag15, [JobFlag15]) END
           ,[JobFlag16]					= CASE WHEN (@isFormView = 1) THEN @jobFlag16 WHEN ((@isFormView = 0) AND (@jobFlag16='#M4PL#')) THEN NULL ELSE ISNULL(@jobFlag16, [JobFlag16]) END
           ,[JobFlag17]					= CASE WHEN (@isFormView = 1) THEN @jobFlag17 WHEN ((@isFormView = 0) AND (@jobFlag17='#M4PL#')) THEN NULL ELSE ISNULL(@jobFlag17, [JobFlag17]) END
           ,[JobFlag18]					= CASE WHEN (@isFormView = 1) THEN @jobFlag18 WHEN ((@isFormView = 0) AND (@jobFlag18='#M4PL#')) THEN NULL ELSE ISNULL(@jobFlag18, [JobFlag18]) END
           ,[JobFlag19]					= CASE WHEN (@isFormView = 1) THEN @jobFlag19 WHEN ((@isFormView = 0) AND (@jobFlag19='#M4PL#')) THEN NULL ELSE ISNULL(@jobFlag19, [JobFlag19]) END
           ,[JobFlag20]					= CASE WHEN (@isFormView = 1) THEN @jobFlag20 WHEN ((@isFormView = 0) AND (@jobFlag20='#M4PL#')) THEN NULL ELSE ISNULL(@jobFlag20, [JobFlag20]) END
		   ,[JobFlag21]					= CASE WHEN (@isFormView = 1) THEN @jobFlag21 WHEN ((@isFormView = 0) AND (@jobFlag21=-100)) THEN NULL ELSE ISNULL(@jobFlag21, [JobFlag21]) END
		   ,[JobFlag22]					= CASE WHEN (@isFormView = 1) THEN @jobFlag22 WHEN ((@isFormView = 0) AND (@jobFlag22=-100)) THEN NULL ELSE ISNULL(@jobFlag22, [JobFlag22]) END
		   ,[JobFlag23]					= CASE WHEN (@isFormView = 1) THEN @jobFlag23 WHEN ((@isFormView = 0) AND (@jobFlag23=-100)) THEN NULL ELSE ISNULL(@jobFlag23, [JobFlag23]) END
	WHERE	[JobID] = @id

	EXEC [dbo].[GetScnOrder] @userId, @roleId, 0, @id 
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdScnOrderOSD]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/09/2018      
-- Description:               Update a ScnOrderOSD
-- Execution:                 EXEC [dbo].[UpdScnOrderOSD]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================

ALTER PROCEDURE  [dbo].[UpdScnOrderOSD]
	(@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id BIGINT
	,@cargoOSDID BIGINT = NULL
	,@oSDID BIGINT = NULL
	,@dateTime DATETIME2(7) = NULL
	,@cargoDetailID BIGINT = NULL
	,@cargoID BIGINT = NULL
	,@cgoSerialNumber NVARCHAR(255) = NULL
	,@oSDReasonID BIGINT = NULL
	,@oSDQty DECIMAL(18, 2) = NULL
	,@notes NVARCHAR(MAX) = NULL
	,@editCD NVARCHAR(50) = NULL
	,@statusID NVARCHAR(30) = NULL
	,@cgoSeverityCode NVARCHAR(20) = NULL
	,@changedBy NVARCHAR(50) = NULL
	,@dateChanged DATETIME2(7) = NULL
	,@isFormView BIT = 0  )
AS
BEGIN TRY                
 SET NOCOUNT ON;   

 UPDATE [dbo].[SCN014OrderOSD]
      SET   [CargoOSDID] = CASE WHEN (@isFormView = 1) THEN @cargoOSDID WHEN ((@isFormView = 0) AND (@cargoOSDID=-100)) THEN NULL ELSE ISNULL(@cargoOSDID, [CargoOSDID]) END
		   ,[OSDID] = CASE WHEN (@isFormView = 1) THEN @oSDID WHEN ((@isFormView = 0) AND (@oSDID=-100)) THEN NULL ELSE ISNULL(@oSDID, [OSDID]) END
		   ,[DateTime] = CASE WHEN (@isFormView = 1) THEN @dateTime WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @dateTime, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@dateTime, [DateTime]) END    
		   ,[CargoDetailID] = CASE WHEN (@isFormView = 1) THEN @cargoDetailID WHEN ((@isFormView = 0) AND (@cargoDetailID=-100)) THEN NULL ELSE ISNULL(@cargoDetailID, [CargoDetailID]) END
		   ,[CargoID] = CASE WHEN (@isFormView = 1) THEN @cargoID WHEN ((@isFormView = 0) AND (@cargoID=-100)) THEN NULL ELSE ISNULL(@cargoID, [CargoID]) END
		   ,[CgoSerialNumber] = CASE WHEN (@isFormView = 1) THEN @cgoSerialNumber WHEN ((@isFormView = 0) AND (@cgoSerialNumber='#M4PL#')) THEN NULL ELSE ISNULL(@cgoSerialNumber, [CgoSerialNumber]) END
		   ,[OSDReasonID] = CASE WHEN (@isFormView = 1) THEN @oSDReasonID WHEN ((@isFormView = 0) AND (@oSDReasonID=-100)) THEN NULL ELSE ISNULL(@oSDReasonID, [OSDReasonID]) END
		   ,[OSDQty] = CASE WHEN (@isFormView = 1) THEN @oSDQty WHEN ((@isFormView = 0) AND (@oSDQty=-100.00)) THEN NULL ELSE ISNULL(@oSDQty, [OSDQty]) END
		   ,[Notes] = CASE WHEN (@isFormView = 1) THEN @notes WHEN ((@isFormView = 0) AND (@notes='#M4PL#')) THEN NULL ELSE ISNULL(@notes, [Notes]) END
		   ,[EditCD] = CASE WHEN (@isFormView = 1) THEN @editCD WHEN ((@isFormView = 0) AND (@editCD='#M4PL#')) THEN NULL ELSE ISNULL(@editCD, [EditCD]) END
		   ,[StatusID] = CASE WHEN (@isFormView = 1) THEN @statusID WHEN ((@isFormView = 0) AND (@statusID='#M4PL#')) THEN NULL ELSE ISNULL(@statusID, [StatusID]) END
		   ,[CgoSeverityCode] = CASE WHEN (@isFormView = 1) THEN @cgoSeverityCode WHEN ((@isFormView = 0) AND (@cgoSeverityCode='#M4PL#')) THEN NULL ELSE ISNULL(@cgoSeverityCode, [CgoSeverityCode]) END
	WHERE	[CargoOSDID] = @id

	EXEC [dbo].[GetScnOrderOSD] @userId, @roleId,0 ,@cargoOSDID 
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdScnOrderRequirement]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/09/2018      
-- Description:               Update a ScnOrderRequirement
-- Execution:                 EXEC [dbo].[UpdScnOrderRequirement]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================

ALTER PROCEDURE  [dbo].[UpdScnOrderRequirement]
	(@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id bigint
	,@requirementID BIGINT = NULL
	,@requirementCode NVARCHAR(20) = NULL
	,@jobID BIGINT = NULL
	,@notes NVARCHAR(MAX) = NULL
	,@complete NVARCHAR(1) = NULL
	,@changedBy NVARCHAR(50) = NULL
	,@dateChanged DATETIME2(7) = NULL
	,@isFormView BIT = 0  )
AS
BEGIN TRY                
 SET NOCOUNT ON;   

 UPDATE [dbo].[SCN015OrderRequirement]
      SET   [RequirementID]		= CASE WHEN (@isFormView = 1) THEN @requirementID WHEN ((@isFormView = 0) AND (@requirementID=-100)) THEN NULL ELSE ISNULL(@requirementID, [RequirementID]) END
		   ,[RequirementCode]	= CASE WHEN (@isFormView = 1) THEN @requirementCode WHEN ((@isFormView = 0) AND (@requirementCode='#M4PL#')) THEN NULL ELSE ISNULL(@requirementCode, [RequirementCode]) END
           ,[JobID]				= CASE WHEN (@isFormView = 1) THEN @jobID WHEN ((@isFormView = 0) AND (@jobID=-100)) THEN NULL ELSE ISNULL(@jobID  , [JobID]) END
           ,[Notes]				= CASE WHEN (@isFormView = 1) THEN @notes WHEN ((@isFormView = 0) AND (@notes='#M4PL#')) THEN NULL ELSE ISNULL(@notes, [Notes]) END
           ,[Complete]			= CASE WHEN (@isFormView = 1) THEN @complete WHEN ((@isFormView = 0) AND (@complete='#M4PL#')) THEN NULL ELSE ISNULL(@complete, [Complete]) END
	WHERE	[RequirementID]		= @id

	EXEC [dbo].[GetScnOrderRequirement] @userId, @roleId, 0 ,@requirementID 
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdScnOrderService]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/09/2018      
-- Description:               Update a ScnOrderService
-- Execution:                 EXEC [dbo].[UpdScnOrderService]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================

ALTER PROCEDURE  [dbo].[UpdScnOrderService]
	(@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id bigint
	,@servicesID BIGINT = NULL
	,@servicesCode NVARCHAR(50) = NULL
	,@jobID BIGINT = NULL
	,@notes NVARCHAR(MAX) = NULL
	,@complete NVARCHAR(1) = NULL
	,@changedBy NVARCHAR(50) = NULL
	,@dateChanged DATETIME2(7) = NULL
	,@isFormView BIT = 0  )
AS
BEGIN TRY                
 SET NOCOUNT ON;   

 UPDATE [dbo].[SCN013OrderServices]
      SET   [ServicesID]	= CASE WHEN (@isFormView = 1) THEN @servicesID WHEN ((@isFormView = 0) AND (@servicesID=-100)) THEN NULL ELSE ISNULL(@servicesID, [ServicesID]) END
		   ,[ServicesCode]	= CASE WHEN (@isFormView = 1) THEN @servicesCode WHEN ((@isFormView = 0) AND (@servicesCode='#M4PL#')) THEN NULL ELSE ISNULL(@servicesCode, [ServicesCode]) END
           ,[JobID]			= CASE WHEN (@isFormView = 1) THEN @jobID WHEN ((@isFormView = 0) AND (@jobID=-100)) THEN NULL ELSE ISNULL(@jobID, [JobID]) END
           ,[Notes]			= CASE WHEN (@isFormView = 1) THEN @notes WHEN ((@isFormView = 0) AND (@notes='#M4PL#')) THEN NULL ELSE ISNULL(@notes, [Notes]) END
           ,[Complete]		= CASE WHEN (@isFormView = 1) THEN @complete WHEN ((@isFormView = 0) AND (@complete='#M4PL#')) THEN NULL ELSE ISNULL(@complete, [Complete]) END
	WHERE	[ServicesID] = @id

	EXEC [dbo].[GetScnOrderService] @userId, @roleId,0 ,@servicesID 
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdScnRouteList]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/09/2018      
-- Description:               Update a ScnRouteList
-- Execution:                 EXEC [dbo].[UpdScnRouteList]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================

ALTER PROCEDURE  [dbo].[UpdScnRouteList]
	(@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id bigint
	,@routeID BIGINT = NULL
	,@routeName NVARCHAR(50) = NULL
	,@programID BIGINT = NULL
	,@changedBy NVARCHAR(50) = NULL
	,@dateChanged DATETIME2(7) = NULL
	,@isFormView BIT = 0)
AS
BEGIN TRY                
 SET NOCOUNT ON;   

 UPDATE [dbo].[SCN016RouteList]
      SET   [RouteID]			= CASE WHEN (@isFormView = 1) THEN @routeID WHEN ((@isFormView = 0) AND (@routeID=-100)) THEN NULL ELSE ISNULL(@routeID, [RouteID]) END
           ,[RouteName]			= CASE WHEN (@isFormView = 1) THEN @routeName WHEN ((@isFormView = 0) AND (@routeName='#M4PL#')) THEN NULL ELSE ISNULL(@routeName, [RouteName]) END
           ,[ProgramID]			= CASE WHEN (@isFormView = 1) THEN @programID WHEN ((@isFormView = 0) AND (@programID=-100)) THEN NULL ELSE ISNULL(@programID, [ProgramID]) END
	WHERE	[RouteID] = @id

	EXEC [dbo].[GetScnRouteList] @userId, @roleId, 0 ,@id 
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdScrCatalogList]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/29/2018      
-- Description:               Upd a Scr Catalog List
-- Execution:                 EXEC [dbo].[UpdScrCatalogList]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[UpdScrCatalogList]		  
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id  BIGINT
	,@catalogProgramID bigint = NULL
	,@catalogItemNumber int = NULL
	,@catalogCode nvarchar(20) = NULL
	,@catalogTitle nvarchar(50) = NULL
	,@catalogCustCode nvarchar(20) = NULL
	,@catalogUoMCode	nvarchar(20) = NULL
	,@catalogCubes	DECIMAL(18,2) = NULL
	,@catalogWidth	DECIMAL(18,2) = NULL
	,@catalogLength	DECIMAL(18,2) = NULL
	,@catalogHeight	DECIMAL(18,2) = NULL
	,@catalogWLHUoM	nvarchar(20) = NULL
	,@catalogWeight	nvarchar(20) = NULL
	,@statusId int = NULL
	,@changedBy  NVARCHAR(50)
	,@dateChanged  DATETIME2(7)
	,@isFormView BIT = 0
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  DECLARE @updatedItemNumber INT      
  EXEC [dbo].[ResetItemNumber] @userId, @id, @catalogProgramID, @entity, @catalogItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT  

   UPDATE  [dbo].[SCR010CatalogList] 
      SET    CatalogProgramID    =   CASE WHEN (@isFormView = 1) THEN @catalogProgramID WHEN ((@isFormView = 0) AND (@catalogProgramID=-100)) THEN NULL ELSE ISNULL(@catalogProgramID, CatalogProgramID) END
			,CatalogItemNumber   =   CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, CatalogItemNumber) END
			,CatalogCode         =   CASE WHEN (@isFormView = 1) THEN @catalogCode WHEN ((@isFormView = 0) AND (@catalogCode='#M4PL#')) THEN NULL ELSE ISNULL(@catalogCode, CatalogCode) END      
			,CatalogTitle        =   CASE WHEN (@isFormView = 1) THEN @catalogTitle WHEN ((@isFormView = 0) AND (@catalogTitle='#M4PL#')) THEN NULL ELSE ISNULL(@catalogTitle, CatalogTitle) END     

			,CatalogCustCode        =   CASE WHEN (@isFormView = 1) THEN @catalogCustCode WHEN ((@isFormView = 0) AND (@catalogCustCode='#M4PL#')) THEN NULL ELSE ISNULL(@catalogCustCode, CatalogCustCode) END     
			,CatalogUoMCode        =   CASE WHEN (@isFormView = 1) THEN @catalogUoMCode WHEN ((@isFormView = 0) AND (@catalogUoMCode='#M4PL#')) THEN NULL ELSE ISNULL(@catalogUoMCode, CatalogUoMCode) END     
			--,CatalogCubes	      =   CASE WHEN (@isFormView = 1) THEN @catalogCubes WHEN ((@isFormView = 0) AND (@catalogCubes=-100)) THEN NULL ELSE ISNULL(@catalogCubes, CatalogCubes) END     
			,CatalogWidth	      =   CASE WHEN (@isFormView = 1) THEN @catalogWidth WHEN ((@isFormView = 0) AND (@catalogWidth=-100)) THEN NULL ELSE ISNULL(@catalogWidth, CatalogWidth) END     
			,CatalogLength      =   CASE WHEN (@isFormView = 1) THEN @catalogLength WHEN ((@isFormView = 0) AND (@catalogLength=-100)) THEN NULL ELSE ISNULL(@catalogLength, CatalogLength) END     
			,CatalogHeight      =   CASE WHEN (@isFormView = 1) THEN @catalogHeight WHEN ((@isFormView = 0) AND (@catalogHeight=-100)) THEN NULL ELSE ISNULL(@catalogHeight, CatalogHeight) END     
			,CatalogWLHUoM      =   CASE WHEN (@isFormView = 1) THEN @catalogWLHUoM WHEN ((@isFormView = 0) AND (@catalogWLHUoM='#M4PL#')) THEN NULL ELSE ISNULL(@catalogWLHUoM, CatalogWLHUoM) END     
			,CatalogWeight      =   CASE WHEN (@isFormView = 1) THEN @catalogWeight WHEN ((@isFormView = 0) AND (@catalogWeight='#M4PL#')) THEN NULL ELSE ISNULL(@catalogWeight, CatalogWeight) END     

			,StatusId            =   CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END         
			,DateChanged         =   ISNULL(@dateChanged, DateChanged)      
			,ChangedBy           =   ISNULL(@changedBy, ChangedBy)
       WHERE Id = @id		;   

	   UPDATE [SCR010CatalogList] SET CatalogCubes = (CatalogWidth *CatalogHeight *CatalogLength)   WHERE Id = @id		;   


SELECT scr.[Id]
		,scr.[CatalogProgramID]
		,scr.[CatalogItemNumber]
		,scr.[CatalogCode]
		,scr.[CatalogCustCode]
		,scr.[CatalogTitle]
		,scr.[CatalogPhoto]
		,scr.[CatalogUoMCode]
		,scr.[CatalogCubes]
		,scr.[CatalogWidth]
		,scr.[CatalogLength]
		,scr.[CatalogHeight]
		,scr.[CatalogWLHUoM]
		,scr.[CatalogWeight]
		,scr.[StatusId]
		,scr.[DateEntered]
		,scr.[EnteredBy]
		,scr.[DateChanged]
		,scr.[ChangedBy]

		,CASE WHEN pgm.PrgHierarchyLevel = 1 THEN     pgm.[PrgProgramCode]
		 WHEN pgm.PrgHierarchyLevel = 2 THEN     pgm.[PrgProjectCode]
		  WHEN pgm.PrgHierarchyLevel = 3 THEN     pgm.PrgPhaseCode
		  ELSE pgm.[PrgProgramTitle] END AS CatalogProgramIDName


   FROM [dbo].[SCR010CatalogList] scr
   INNER JOIN PRGRM000Master pgm ON scr.CatalogProgramID = pgm.Id
  WHERE scr.[Id]=@id

END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdScrGatewayList]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/09/2018      
-- Description:               Update a ScrGatewayList
-- Execution:                 EXEC [dbo].[UpdScrGatewayList]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================

ALTER PROCEDURE  [dbo].[UpdScrGatewayList]
	(@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id bigint
	,@gatewayStatusID BIGINT = NULL
	,@programID BIGINT = NULL
	,@gatewayCode NVARCHAR(20) = NULL
	,@changedBy NVARCHAR(50) = NULL
	,@dateChanged DATETIME2(7) = NULL
	,@isFormView BIT = 0  )
AS
BEGIN TRY                
 SET NOCOUNT ON;   

 UPDATE [dbo].[SCR016GatewayList]
      SET   [GatewayStatusID]	= CASE WHEN (@isFormView = 1) THEN @gatewayStatusID WHEN ((@isFormView = 0) AND (@gatewayStatusID=-100)) THEN NULL ELSE ISNULL(@gatewayStatusID, [GatewayStatusID]) END
           ,[ProgramID]			= CASE WHEN (@isFormView = 1) THEN @programID WHEN ((@isFormView = 0) AND (@programID=-100)) THEN NULL ELSE ISNULL(@programID  , [ProgramID]) END
           ,[GatewayCode]		= CASE WHEN (@isFormView = 1) THEN @gatewayCode WHEN ((@isFormView = 0) AND (@gatewayCode='#M4PL#')) THEN NULL ELSE ISNULL(@gatewayCode, [GatewayCode]) END
	WHERE	[GatewayStatusID]   = @id

	EXEC [dbo].[GetScrGatewayList] @userId, @roleId, 0 ,@gatewayStatusID 
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdScrInfoList]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/09/2018      
-- Description:               Update a ScrInfoList
-- Execution:                 EXEC [dbo].[UpdScrInfoList]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================

ALTER PROCEDURE  [dbo].[UpdScrInfoList]
	(@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id bigint
	,@infoListID BIGINT = NULL
	,@infoListDesc NVARCHAR(MAX) = NULL
	,@changedBy NVARCHAR(50) = NULL
	,@dateChanged DATETIME2(7) = NULL
	,@isFormView BIT = 0  )
AS
BEGIN TRY                
 SET NOCOUNT ON;   

 UPDATE [dbo].[SCR010InfoList]
      SET   [InfoListID]	= CASE WHEN (@isFormView = 1) THEN @infoListID WHEN ((@isFormView = 0) AND (@infoListID=-100)) THEN NULL ELSE ISNULL(@infoListID, [InfoListID]) END
           ,[InfoListDesc]	= CASE WHEN (@isFormView = 1) THEN @infoListDesc WHEN ((@isFormView = 0) AND (@infoListDesc='#M4PL#')) THEN NULL ELSE ISNULL(@infoListDesc, [InfoListDesc]) END
	WHERE	[InfoListID] = @id

	EXEC [dbo].[GetScrInfoList] @userId, @roleId,0 ,@id 
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdScrOsdList]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/29/2018      
-- Description:               Upd a Scr Osd List
-- Execution:                 EXEC [dbo].[UpdScrOsdList]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[UpdScrOsdList]		  
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id  BIGINT
	,@programID bigint = NULL
	,@osdItemNumber int = NULL
	,@osdCode nvarchar(20) = NULL
	,@osdTitle nvarchar(50) = NULL
	,@oSDType nvarchar(20) = NULL
	,@statusId int = NULL
	,@changedBy  NVARCHAR(50)
	,@dateChanged  DATETIME2(7)
	,@isFormView BIT = 0
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  DECLARE @updatedItemNumber INT      
 EXEC [dbo].[ResetItemNumber] @userId, @id, @programID, @entity, @osdItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT  

   UPDATE  [dbo].[SCR011OSDList] 
      SET    ProgramID        =	CASE WHEN (@isFormView = 1) THEN @programID WHEN ((@isFormView = 0) AND (@programID=-100)) THEN NULL ELSE ISNULL(@programID, ProgramID) END
			,OSDItemNumber       =	CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, OSDItemNumber) END
			,OSDCode             =	CASE WHEN (@isFormView = 1) THEN @osdCode WHEN ((@isFormView = 0) AND (@osdCode='#M4PL#')) THEN NULL ELSE ISNULL(@osdCode, OSDCode) END
			,OSDTitle            =	CASE WHEN (@isFormView = 1) THEN @osdTitle WHEN ((@isFormView = 0) AND (@osdTitle='#M4PL#')) THEN NULL ELSE ISNULL(@osdTitle, OSDTitle) END
			,OSDType           =	CASE WHEN (@isFormView = 1) THEN @oSDType WHEN ((@isFormView = 0) AND (@oSDType='#M4PL#')) THEN NULL ELSE ISNULL(@oSDType, OSDType) END
			,StatusId            =	CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
			,DateChanged         =	ISNULL(@dateChanged, DateChanged)
			,ChangedBy           =	ISNULL(@changedBy, ChangedBy)
       WHERE OSDID = @id		   


EXEC GetScrOsdList @userId,@roleId,0,@id;

	

END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdScrOsdReasonList]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/29/2018      
-- Description:               Upd a Scr Osd Reason List
-- Execution:                 EXEC [dbo].[UpdScrOsdReasonList]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[UpdScrOsdReasonList]		  
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id  BIGINT
	,@programID bigint = NULL
	,@reasonItemNumber int = NULL
	,@reasonIDCode nvarchar(20) = NULL
	,@reasonTitle nvarchar(50) = NULL
	,@statusId int = NULL
	,@changedBy  NVARCHAR(50)
	,@dateChanged  DATETIME2(7)
	,@isFormView BIT = 0
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  DECLARE @updatedItemNumber INT      
EXEC [dbo].[ResetItemNumber] @userId, @id, @programID, @entity, @reasonItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT 
   UPDATE  [dbo].[SCR011OSDReasonList] 
      SET    ProgramID     =	CASE WHEN (@isFormView = 1) THEN @programID WHEN ((@isFormView = 0) AND (@programID=-100)) THEN NULL ELSE ISNULL(@programID, ProgramID) END
			,ReasonItemNumber    =	CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, ReasonItemNumber) END
			,ReasonIDCode          =	CASE WHEN (@isFormView = 1) THEN @reasonIDCode WHEN ((@isFormView = 0) AND (@reasonIDCode='#M4PL#')) THEN NULL ELSE ISNULL(@reasonIDCode, ReasonIDCode) END
			,ReasonTitle         =	CASE WHEN (@isFormView = 1) THEN @reasonTitle WHEN ((@isFormView = 0) AND (@reasonTitle='#M4PL#')) THEN NULL ELSE ISNULL(@reasonTitle, ReasonTitle) END
			,StatusId            =	CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
			,DateChanged         =	ISNULL(@dateChanged, DateChanged)
			,ChangedBy           =	ISNULL(@changedBy, ChangedBy)
       WHERE ReasonID = @id		   

	EXEC GetScrOsdReasonList @userId,@roleId,0,@id;

END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdScrRequirementList]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/29/2018      
-- Description:               Upd a Scr Requirement List
-- Execution:                 EXEC [dbo].[UpdScrRequirementList]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[UpdScrRequirementList]		  
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id  BIGINT
	,@programID bigint = NULL
	,@requirementLineItem int = NULL
	,@requirementCode nvarchar(20) = NULL
	,@requirementTitle nvarchar(50) = NULL
	,@statusId int = NULL
	,@changedBy  NVARCHAR(50)
	,@dateChanged  DATETIME2(7)
	,@isFormView BIT = 0
AS
BEGIN TRY                
 SET NOCOUNT ON;  
  DECLARE @updatedItemNumber INT      
 EXEC [dbo].[ResetItemNumber] @userId, @id, @programID, @entity, @requirementLineItem, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT
   UPDATE  [dbo].[SCR012RequirementList] 
      SET    ProgramID    =	CASE WHEN (@isFormView = 1) THEN @programID WHEN ((@isFormView = 0) AND (@programID=-100)) THEN NULL ELSE ISNULL(@programID, ProgramID) END
			,RequirementLineItem     =	CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, RequirementLineItem) END
			,RequirementCode         =	CASE WHEN (@isFormView = 1) THEN @requirementCode WHEN ((@isFormView = 0) AND (@requirementCode='#M4PL#')) THEN NULL ELSE ISNULL(@requirementCode, RequirementCode) END
			,RequirementTitle        =	CASE WHEN (@isFormView = 1) THEN @requirementTitle WHEN ((@isFormView = 0) AND (@requirementTitle='#M4PL#')) THEN NULL ELSE ISNULL(@requirementTitle, RequirementTitle) END
			,StatusId                =	CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
			,DateChanged             =	ISNULL(@dateChanged, DateChanged)
			,ChangedBy               =	ISNULL(@changedBy, ChangedBy)
       WHERE RequirementID = @id		   

	EXEC GetScrRequirementList @userId, @roleId, 0, @id;

END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdScrReturnReasonList]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/29/2018      
-- Description:               Upd a Scr Return Reason List
-- Execution:                 EXEC [dbo].[UpdScrReturnReasonList]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[UpdScrReturnReasonList]		  
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id  BIGINT
	,@programID bigint = NULL
	,@returnReasonLineItem int = NULL
	,@returnReasonCode nvarchar(20) = NULL
	,@returnReasonTitle nvarchar(50) = NULL
	,@statusId INT = NULL
	,@changedBy  NVARCHAR(50)
	,@dateChanged  DATETIME2(7)
	,@isFormView BIT = 0
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  DECLARE @updatedItemNumber INT      
  EXEC [dbo].[ResetItemNumber] @userId, @id, @programID, @entity, @returnReasonLineItem, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT  
   UPDATE  [dbo].[SCR014ReturnReasonList] 
      SET    ProgramID       =	CASE WHEN (@isFormView = 1) THEN @programID WHEN ((@isFormView = 0) AND (@programID=-100)) THEN NULL ELSE ISNULL(@programID, ProgramID) END
			,ReturnReasonLineItem        =	CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, ReturnReasonLineItem) END
			,ReturnReasonCode            =	CASE WHEN (@isFormView = 1) THEN @returnReasonCode WHEN ((@isFormView = 0) AND (@returnReasonCode='#M4PL#')) THEN NULL ELSE ISNULL(@returnReasonCode, ReturnReasonCode) END
			,ReturnReasonTitle           =	CASE WHEN (@isFormView = 1) THEN @returnReasonTitle WHEN ((@isFormView = 0) AND (@returnReasonTitle='#M4PL#')) THEN NULL ELSE ISNULL(@returnReasonTitle, ReturnReasonTitle) END
			,StatusId                    =	CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
			,DateChanged                 =	ISNULL(@dateChanged, DateChanged)
			,ChangedBy                   =	ISNULL(@changedBy, ChangedBy)
       WHERE ReturnReasonID = @id		   

	EXEC GetScrReturnReasonList @userId, @roleId, 0, @id;  

END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdScrServiceList]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/29/2018      
-- Description:               Upd a Scr Service List
-- Execution:                 EXEC [dbo].[UpdScrServiceList]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[UpdScrServiceList]		  
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id  BIGINT
	,@programID bigint = NULL
	,@serviceLineItem int = NULL
	,@serviceCode nvarchar(20) = NULL
	,@serviceTitle nvarchar(50) = NULL
	,@statusId int = NULL
	,@changedBy  NVARCHAR(50)
	,@dateChanged  DATETIME2(7)
	,@isFormView BIT = 0
AS
BEGIN TRY                
 SET NOCOUNT ON; 
 DECLARE @updatedItemNumber INT      
   EXEC [dbo].[ResetItemNumber] @userId, @id, @programID, @entity, @serviceLineItem, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT
   UPDATE  [dbo].[SCR013ServiceList] 
      SET    ProgramID        =	CASE WHEN (@isFormView = 1) THEN @programID WHEN ((@isFormView = 0) AND (@programID=-100)) THEN NULL ELSE ISNULL(@programID, ProgramID) END
			,ServiceLineItem         =	CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, ServiceLineItem) END
			,ServiceCode             =	CASE WHEN (@isFormView = 1) THEN @serviceCode WHEN ((@isFormView = 0) AND (@serviceCode='#M4PL#')) THEN NULL ELSE ISNULL(@serviceCode, ServiceCode) END
			,ServiceTitle            =	CASE WHEN (@isFormView = 1) THEN @serviceTitle WHEN ((@isFormView = 0) AND (@serviceTitle='#M4PL#')) THEN NULL ELSE ISNULL(@serviceTitle, ServiceTitle) END
			,StatusId                =	CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
			,DateChanged             =	ISNULL(@dateChanged, DateChanged)
			,ChangedBy               =	ISNULL(@changedBy, ChangedBy)
       WHERE [ServiceID] = @id		   

	EXEC GetScrServiceList @userId, @roleId, 0, @id

END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdSecByRoleItemNumberAfterDelete]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana B   
-- Create date:               03/27/2018      
-- Description:               Update Item Number after delete for SecurityByRole   
-- Execution:                 EXEC [dbo].[UpdSecByRoleItemNumberAfterDelete]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================   
ALTER PROCEDURE [dbo].[UpdSecByRoleItemNumberAfterDelete]
	@entity NVARCHAR(100),      
	@ids NVARCHAR(MAX),      
	@itemFieldName NVARCHAR(100),      
	@where NVARCHAR(MAX) = NULL,
	@parentId BIGINT = 0      
AS      
BEGIN TRY                      
 SET NOCOUNT ON;        
       
   DECLARE @leastId BIGINT,       
		   @nextId BIGINT ,      
		   @sqlCommand NVARCHAR(MAX),      
		   @statues NVARCHAR(100),      
		   @itemNo INT      
   SELECT  @statues = SysStatusesIn  FROM SYSTM000Ref_Settings         
   
   SELECT @parentId = OrgRefRoleId FROM [dbo].[ORGAN020Act_Roles] WHERE Id = @parentId;
   SET @where = ' AND [OrgRefRoleId] = ' + CAST(@parentId AS NVARCHAR(50))
    
   CREATE TABLE #tempTable(Id BIGINT,ItemNumber INT) ;
			SET @sqlCommand ='Insert Into  #tempTable (Id,ItemNumber)
			SELECT  '+@entity+'.Id ,ROW_NUMBER() OVER(ORDER BY '+@entity+'.'+@itemFieldName+') 
			FROM [dbo].[SYSTM000SecurityByRole] ' + @entity +
			' JOIN [dbo].[fnSplitString](''' + @statues + ''', '','') sts ON ' + @entity + '.StatusId = sts.Item
			WHERE 1=1 ' + ISNULL(@where,'') +'  Order By '+@entity+'.'+@itemFieldName;
				
			EXEC sp_executesql @sqlCommand;

			SET @sqlCommand='MERGE INTO [dbo].[SYSTM000SecurityByRole] c1
			USING #temptable c2
			ON c1.Id=c2.Id
			WHEN MATCHED THEN
			UPDATE SET c1.'+@itemFieldName+' = c2.ItemNumber;';

			EXEC sp_executesql @sqlCommand;
            DROP TABLE #tempTable;
	END TRY                      
BEGIN CATCH                      
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                      
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                      
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                      
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                      
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdSecurityByRole]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan  
-- Create date:               09/22/2018      
-- Description:               Upd a security by role 
-- Execution:                 EXEC [dbo].[UpdSecurityByRole]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[UpdSecurityByRole]
	(@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id bigint
	,@orgId bigint = NULL
	,@secLineOrder int  = NULL
	,@mainModuleId int = NULL
	,@menuOptionLevelId int = NULL
	,@menuAccessLevelId int = NULL
	,@statusId int = NULL
	,@actRoleId BIGINT = NULL
	,@dateChanged datetime2(7) = NULL
	,@changedBy nvarchar(50) = NULL
	,@isFormView BIT = 0) 
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 DECLARE @updatedItemNumber INT      
 DECLARE @savedRoleCode NVARCHAR(25)
EXEC [dbo].[ResetItemNumber] @userId, @id, @actRoleId, @entity, @secLineOrder, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT
 UPDATE [dbo].[SYSTM000SecurityByRole]
		SET 
			 [SecLineOrder]          = CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, SecLineOrder) END
			,[SecMainModuleId]       = CASE WHEN (@isFormView = 1) THEN @mainModuleId WHEN ((@isFormView = 0) AND (@mainModuleId=-100)) THEN NULL ELSE ISNULL(@mainModuleId, SecMainModuleId) END
			,[SecMenuOptionLevelId]  = CASE WHEN (@isFormView = 1) THEN @menuOptionLevelId WHEN ((@isFormView = 0) AND (@menuOptionLevelId=-100)) THEN NULL ELSE ISNULL(@menuOptionLevelId, SecMenuOptionLevelId) END
			,[SecMenuAccessLevelId]  = CASE WHEN (@isFormView = 1) THEN @menuAccessLevelId WHEN ((@isFormView = 0) AND (@menuAccessLevelId=-100)) THEN NULL ELSE ISNULL(@menuAccessLevelId, SecMenuAccessLevelId) END
			,[StatusId]			     = CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
			,[DateChanged]           = @dateChanged
			,[ChangedBy]             = @changedBy
	 WHERE	 [Id] = @id

	EXECUTE  GetSecurityByRole @userId,@roleId,@orgId,@id;
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdSubSecurityByRole]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan  
-- Create date:               09/22/2018      
-- Description:               Upd a subsecurity by role 
-- Execution:                 EXEC [dbo].[UpdSubSecurityByRole]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================  
ALTER PROCEDURE  [dbo].[UpdSubSecurityByRole]
	(@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id bigint
	,@secByRoleId bigint = NULL
	,@refTableName nvarchar(100) = NULL
	,@menuOptionLevelId int = NULL
	,@menuAccessLevelId int = NULL
	,@statusId int = NULL
	,@dateChanged datetime2(7) = NULL
	,@changedBy nvarchar(50) = NULL
	,@isFormView BIT = 0) 
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 UPDATE [dbo].[SYSTM010SubSecurityByRole]
		SET  [SecByRoleId]				= CASE WHEN (@isFormView = 1) THEN @secByRoleId WHEN ((@isFormView = 0) AND (@secByRoleId=-100)) THEN NULL ELSE ISNULL(@secByRoleId, SecByRoleId) END
			,[RefTableName]				= CASE WHEN (@isFormView = 1) THEN @refTableName WHEN ((@isFormView = 0) AND (@refTableName='#M4PL#')) THEN NULL ELSE ISNULL(@refTableName, RefTableName) END
			,[SubsMenuOptionLevelId]	= CASE WHEN (@isFormView = 1) THEN @menuOptionLevelId WHEN ((@isFormView = 0) AND (@menuOptionLevelId=-100)) THEN NULL ELSE ISNULL(@menuOptionLevelId,SubsMenuOptionLevelId) END
			,[SubsMenuAccessLevelId]	= CASE WHEN (@isFormView = 1) THEN @menuAccessLevelId WHEN ((@isFormView = 0) AND (@menuAccessLevelId=-100)) THEN NULL ELSE ISNULL(@menuAccessLevelId, SubsMenuAccessLevelId) END
			,[StatusId]					= CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
			,[DateChanged]				= @dateChanged
			,[ChangedBy]				= @changedBy
	 WHERE	 [Id] = @id
	SELECT syst.[Id]
		 ,syst.[SecByRoleId]  
		  ,syst.[RefTableName]
		  ,syst.[SubsMenuOptionLevelId]  
		  ,syst.[SubsMenuAccessLevelId]  
		  ,syst.[StatusId]  
		  ,syst.[DateEntered]  
		  ,syst.[EnteredBy]  
		  ,syst.[DateChanged]  
		  ,syst.[ChangedBy]  
  FROM [dbo].[SYSTM010SubSecurityByRole] syst  
 WHERE syst.[Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdSysRefOption]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan  
-- Create date:               09/22/2018      
-- Description:               Upd a sys ref option  
-- Execution:                 EXEC [dbo].[UpdSysRefOption]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================   
ALTER PROCEDURE  [dbo].[UpdSysRefOption]      
	@userId BIGINT  
	,@roleId BIGINT  
	,@entity NVARCHAR(100)  
	,@langCode NVARCHAR(10)  
	,@id int  
	,@lookupId INT = NULL  
	,@lookupName NVARCHAR(100) =NULL
	,@sysOptionName nvarchar(100) = NULL  
	,@sysSortOrder int = NULL  
	,@sysDefault bit = NULL  
	,@isSysAdmin bit = NULL
	,@statusId INT = NULL 
	,@dateChanged datetime2(7) = NULL  
	,@changedBy nvarchar(50) = NULL  	   
	,@isFormView BIT = 0
AS  
BEGIN TRY                  
 SET NOCOUNT ON;     
   DECLARE @updatedItemNumber INT        
   DECLARE @where NVARCHAR(MAX) =    ' AND SysLookupId ='''  +  CAST(@lookupId AS VARCHAR)+''''  
  EXEC [dbo].[ResetItemNumber] @userId, @id, NULL, @entity, @sysSortOrder, @statusId, NULL, @where,  @updatedItemNumber OUTPUT  
    --INSERT INTO REF TABLE If @lookupName NOt EXISTS  
 IF NOT EXISTS( SELECT Id FROM SYSTM000Ref_Lookup WHERE LkupCode=@lookupName)    
 BEGIN    
        INSERT INTO [dbo].[SYSTM000Ref_Lookup](LkupCode,LkupTableName) VALUES(@lookupId,'Global');   
		SET @lookupId = SCOPE_IDENTITY(); 
 END    


   UPDATE [dbo].[SYSTM000Ref_Options]  
    SET      [SysLookupId]  = CASE WHEN (@isFormView = 1) THEN @lookupId WHEN ((@isFormView = 0) AND (@lookupId=-100)) THEN NULL ELSE ISNULL(@lookupId, [SysLookupId]) END 
   ,[SysLookupCode]			= CASE WHEN (@isFormView = 1) THEN @lookupName WHEN ((@isFormView = 0) AND (@lookupName='#M4PL#')) THEN NULL ELSE ISNULL(@lookupName, [SysLookupCode])  END 
   ,[SysOptionName]			= CASE WHEN (@isFormView = 1) THEN @sysOptionName WHEN ((@isFormView = 0) AND (@sysOptionName='#M4PL#')) THEN NULL ELSE ISNULL(@sysOptionName, SysOptionName)   END
   ,[SysSortOrder]			= CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, SysSortOrder)   END
   ,[SysDefault]			= ISNULL(@sysDefault, SysDefault)
   ,[StatusId]				= CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId)   END
   ,[IsSysAdmin]			= ISNULL(@isSysAdmin, IsSysAdmin)
   ,[DateChanged]			= @dateChanged  
   ,[ChangedBy]				= @changedBy    
      WHERE Id   = @id     
      
   EXEC  [dbo].[GetSysRefOption] @userId, @roleId, 1, @langCode, @id  
   
 END TRY       
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdSysRefTabPageName]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan  
-- Create date:               09/22/2018      
-- Description:               Upd a Sys ref tab page name 
-- Execution:                 EXEC [dbo].[UpdSysRefTabPageName]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[UpdSysRefTabPageName]		  
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@langCode NVARCHAR(10)
	,@id bigint
	,@refTableName nvarchar(100)=NULL
	,@tabSortOrder int =NULL
	,@tabTableName nvarchar(100) =NULL
	,@tabPageTitle nvarchar(50)= NULL
	,@tabExecuteProgram nvarchar(50) = NULL
	,@statusId int = NULL
	,@dateChanged datetime2(7) = NULL
	,@changedBy nvarchar(50) = NULL
	,@isFormView BIT = 0
AS
BEGIN TRY                
 SET NOCOUNT ON;  
  DECLARE @updatedItemNumber INT      
  DECLARE @where NVARCHAR(MAX) = ' AND RefTableName = '  + @refTableName;   
  EXEC [dbo].[ResetItemNumber] @userId, @id, NULL, @entity, @tabSortOrder, @statusId, NULL, @where,  @updatedItemNumber OUTPUT  
  
   UPDATE [dbo].[SYSTM030Ref_TabPageName]
		SET  [RefTableName]			= CASE WHEN (@isFormView = 1) THEN @refTableName WHEN ((@isFormView = 0) AND (@refTableName='#M4PL#')) THEN NULL ELSE ISNULL(@refTableName, RefTableName) END
			,[LangCode]				= CASE WHEN (@isFormView = 1) THEN @langCode WHEN ((@isFormView = 0) AND (@langCode='#M4PL#')) THEN NULL ELSE ISNULL(@langCode, LangCode) END
			,[TabSortOrder]			= CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, TabSortOrder) END
			,[TabTableName]			= CASE WHEN (@isFormView = 1) THEN @tabTableName WHEN ((@isFormView = 0) AND (@tabTableName='#M4PL#')) THEN NULL ELSE ISNULL(@tabTableName, TabTableName) END
			,[TabPageTitle]			= CASE WHEN (@isFormView = 1) THEN @tabPageTitle WHEN ((@isFormView = 0) AND (@tabPageTitle='#M4PL#')) THEN NULL ELSE ISNULL(@tabPageTitle, TabPageTitle) END
			,[TabExecuteProgram]    = CASE WHEN (@isFormView = 1) THEN @tabExecuteProgram WHEN ((@isFormView = 0) AND (@tabExecuteProgram='#M4PL#')) THEN NULL ELSE ISNULL(@tabExecuteProgram, TabExecuteProgram) END
			,[StatusId]				= CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
			,[DateChanged]			= @dateChanged
			,[ChangedBy]			= @changedBy
      WHERE Id = @id
	SELECT refTpn.[Id]
		,refTpn.[LangCode]
		,refTpn.[RefTableName]
		,refTpn.[TabSortOrder]
		,refTpn.[TabTableName]
		,refTpn.[TabPageTitle]
		,refTpn.[TabExecuteProgram]
		,refTpn.[StatusId]
		,refTpn.[DateEntered]
		,refTpn.[EnteredBy]
		,refTpn.[DateChanged]
		,refTpn.[ChangedBy]
 FROM [dbo].[SYSTM030Ref_TabPageName] refTpn
 WHERE [Id]=@id AND refTpn.LangCode= @langCode
END TRY        
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdSystemAccount]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan  
-- Create date:               09/22/2018      
-- Description:               Ins a System Account
-- Execution:                 EXEC [dbo].[UpdSystemAccount]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[UpdSystemAccount]      
	@userId BIGINT  
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id BIGINT = NULL  
	,@sysUserContactId BIGINT = NULL   
	,@sysScreenName NVARCHAR(50) = NULL 
	,@sysPassword NVARCHAR(250) = NULL   
	,@sysOrgId BIGINT = NULL   
	,@actRoleId BIGINT = NULL   
	,@isSysAdmin BIT = NULL 
	,@sysAttempts INT = NULL     
	,@statusId INT = NULL      
	,@dateChanged DATETIME2(7) = NULL  
	,@changedBy NVARCHAR(50) = NULL       
	,@isFormView BIT = 0
AS  
BEGIN TRY                  
 SET NOCOUNT ON;     

  DECLARE @oldPassword Nvarchar(255)
  SELECT @oldPassword = SysPassword FROM SYSTM000OpnSezMe   WHERE Id = @id;

   UPDATE [dbo].[SYSTM000OpnSezMe] SET
               SysUserContactID			= CASE WHEN (@isFormView = 1) THEN @sysUserContactId WHEN ((@isFormView = 0) AND (@sysUserContactId=-100)) THEN NULL ELSE ISNULL(@sysUserContactId,SysUserContactID) END
			  ,SysScreenName			= CASE WHEN (@isFormView = 1) THEN @sysScreenName WHEN ((@isFormView = 0) AND (@sysScreenName='#M4PL#')) THEN NULL ELSE ISNULL(@sysScreenName,SysScreenName) END
			  ,SysPassword				= CASE WHEN (@isFormView = 1) THEN @sysPassword WHEN ((@isFormView = 0) AND (@sysPassword='#M4PL#')) THEN NULL ELSE ISNULL(@sysPassword,SysPassword)  END
			  ,SysOrgId					= CASE WHEN (@isFormView = 1) THEN @sysOrgId WHEN ((@isFormView = 0) AND (@sysOrgId=-100)) THEN NULL ELSE ISNULL(@sysOrgId,SysOrgId)  END
			  ,SysOrgRefRoleId					= CASE WHEN (@isFormView = 1) THEN @roleId WHEN ((@isFormView = 0) AND (@roleId=-100)) THEN NULL ELSE ISNULL(@roleId,SysOrgRefRoleId)  END
			  ,IsSysAdmin				= ISNULL(@isSysAdmin,IsSysAdmin)
			  ,SysAttempts				= CASE WHEN (@isFormView = 1) THEN @sysAttempts WHEN ((@isFormView = 0) AND (@sysAttempts=-100)) THEN NULL ELSE ISNULL(@sysAttempts,SysAttempts)  END
			 ,StatusId					= CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId,StatusId)  END
			  ,DateChanged				= @dateChanged
			  ,ChangedBy				= @changedBy 
			  WHERE Id = @id;



 --update sezme user password security tables
 UPDATE  [Security].[AUTH050_UserPassword]
 SET [Password] = @sysPassword 
    ,UpdatedBy  = @userId
	,UpdatedDatetime = GETUTCDATE()
 WHERE UserId = @id AND  @oldPassword <> @sysPassword
			    
 EXEC [dbo].[InsOrUpdOrgActRole] @userId, @roleId, @actRoleId, @sysOrgId, @sysUserContactId, @statusId, @dateChanged, @changedBy
   
 SELECT [Id]  
      ,[SysUserContactID]  
      ,[SysScreenName]  
      ,[SysPassword]  
      ,[SysOrgId]  
      ,[SysOrgRefRoleId]  
      ,[IsSysAdmin]  
      ,[SysAttempts]  
      ,[SysLoggedIn]  
	  ,[SysLoggedInCount]  
      ,[SysDateLastAttempt]  
      ,[SysLoggedInStart]  
      ,[SysLoggedInEnd]  
      ,[StatusId]  
      ,[DateEntered]  
      ,[EnteredBy]  
      ,[DateChanged]  
      ,[ChangedBy] 
  FROM [dbo].[SYSTM000OpnSezMe]  
 WHERE [Id]=@id;  
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdSystemMessage]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana Behara
-- Create date:               09/22/2018      
-- Description:               Upd a system message
-- Execution:                 EXEC [dbo].[UpdSystemMessage]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[UpdSystemMessage]
	(@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@langCode NVARCHAR(10)
	,@id bigint
	,@sysMessageCode nvarchar(25) = NULL
	,@sysRefId int
	,@sysMessageScreenTitle nvarchar(50) = NULL
	,@sysMessageTitle nvarchar(50) = NULL
	,@sysMessageDescription nvarchar(MAX) = NULL
	,@sysMessageInstruction nvarchar(MAX) = NULL
	,@sysMessageButtonSelection nvarchar(100) = NULL
	,@statusId INT = NULL      
	,@dateChanged datetime2(7) = NULL
	,@changedBy nvarchar(50) = NULL
	,@isFormView BIT = 0) 
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 UPDATE [dbo].[SYSTM000Master]
		SET  [LangCode]                      = CASE WHEN (@isFormView = 1) THEN @langCode WHEN ((@isFormView = 0) AND (@langCode='#M4PL#')) THEN LangCode ELSE ISNULL(@langCode, LangCode)  END
			,[SysMessageCode]                = CASE WHEN (@isFormView = 1) THEN @sysMessageCode WHEN ((@isFormView = 0) AND (@sysMessageCode='#M4PL#')) THEN NULL ELSE ISNULL(@sysMessageCode, SysMessageCode) END
			,[SysRefId]                      = @sysRefId
			,[SysMessageScreenTitle]         = CASE WHEN (@isFormView = 1) THEN @sysMessageScreenTitle WHEN ((@isFormView = 0) AND (@sysMessageScreenTitle='#M4PL#')) THEN NULL ELSE ISNULL(@sysMessageScreenTitle, SysMessageScreenTitle) END
			,[SysMessageTitle]               = CASE WHEN (@isFormView = 1) THEN @sysMessageTitle WHEN ((@isFormView = 0) AND (@sysMessageTitle='#M4PL#')) THEN NULL ELSE ISNULL(@sysMessageTitle, SysMessageTitle) END
			,[SysMessageDescription]         = CASE WHEN (@isFormView = 1) THEN @sysMessageDescription WHEN ((@isFormView = 0) AND (@sysMessageDescription='#M4PL#')) THEN NULL ELSE ISNULL(@sysMessageDescription, SysMessageDescription) END
			,[SysMessageInstruction]         = CASE WHEN (@isFormView = 1) THEN @sysMessageInstruction WHEN ((@isFormView = 0) AND (@sysMessageInstruction='#M4PL#')) THEN NULL ELSE ISNULL(@sysMessageInstruction, SysMessageInstruction) END
			,[SysMessageButtonSelection]     = CASE WHEN (@isFormView = 1) THEN @sysMessageButtonSelection WHEN ((@isFormView = 0) AND (@sysMessageButtonSelection='#M4PL#')) THEN NULL ELSE ISNULL(@sysMessageButtonSelection, SysMessageButtonSelection) END
			,[StatusId]					     = CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
			,[DateChanged]                   = @dateChanged
			,[ChangedBy]                     = @changedBy
	 WHERE	 [Id] = @id
	SELECT syst.[Id]
		,syst.[LangCode]
		,syst.[SysMessageCode]
		,syst.[SysRefId]
		,syst.[SysMessageScreenTitle]
		,syst.[SysMessageTitle]
		,syst.[SysMessageButtonSelection]
		,syst.[StatusId]
		,syst.[DateEntered]
		,syst.[EnteredBy]
		,syst.[DateChanged]
		,syst.[ChangedBy]
  FROM [dbo].[SYSTM000Master] syst
 WHERE [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdSysZipCode]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan    
-- Create date:               08/16/2018      
-- Description:               Upd a Sys ZipCode
-- Execution:                 EXEC [dbo].[UpdSysZipCode]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================  
ALTER PROCEDURE  [dbo].[UpdSysZipCode]		  
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@zipcode NVARCHAR(15) = NULL
	,@zipCity NVARCHAR(50) =  NULL
	,@zipState NVARCHAR(50) =  NULL
	,@zipLatitude FLOAT =  NULL
	,@zipLongitude FLOAT = NULL 
	,@zipTimezone FLOAT =  NULL
	,@zipDST FLOAT =  NULL
	,@mrktId BIGINT  =  NULL
	,@dateChanged DATETIME2(7)  = NULL
	,@changedBy NVARCHAR(50) = NULL
AS
BEGIN TRY                
 SET NOCOUNT ON;   
   UPDATE [dbo].[SYSTM000ZipcodeMaster]
     SET    ZipCity 		    = ISNULL(@zipCity, ZipCity)  
           ,ZipState 	        = ISNULL(@zipState, ZipState)  
           ,ZipLatitude 	    = ISNULL(@zipLatitude, ZipLatitude) 
           ,ZipLongitude        = ISNULL(@zipLongitude, ZipLongitude)  
           ,ZipTimezone 	    = ISNULL(@zipTimezone, ZipTimezone)   
           ,ZipDST 		        = ISNULL(@zipDST, ZipDST)   
           ,MrktID 		        = ISNULL(@mrktID, MrktID) 
           ,DateChanged      =   @dateChanged  
           ,ChangedBy    = @changedBy
      WHERE Zipcode = @zipcode               
	SELECT * FROM [dbo].[SYSTM000ZipcodeMaster] WHERE Zipcode = @zipcode
END TRY      
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdUserSystemSettings]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan 
-- Create date:               06/08/2018      
-- Description:               Update user system settings
-- Execution:                 EXEC [dbo].[UpdUserSystemSettings]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE [dbo].[UpdUserSystemSettings]
	@orgId BIGINT,
	@userId BIGINT,
	@langCode NVARCHAR(20),
	@sysMainModuleId INT = NULL,
	@sysDefaultAction NVARCHAR(100) = NULL,
	@sysStatusesIn NVARCHAR(100) = NULL,
	@sysGridViewPageSizes NVARCHAR(100) = NULL,
	@sysPageSize INT = NULL,
	@sysComboBoxPageSize INT = NULL,
	@sysThresholdPercentage INT = NULL
AS
BEGIN TRY                
 SET NOCOUNT ON;  
 
 DECLARE @sysMainModuleId_Local INT = NULL, @sysDefaultAction_Local NVARCHAR(100) = NULL, @sysStatusesIn_Local NVARCHAR(100) = NULL, @sysGridViewPageSizes_Local NVARCHAR(100) = NULL,
		@sysPageSize_Local INT = NULL, @sysComboBoxPageSize_Local INT = NULL, @sysThresholdPercentage_Local INT = NULL;
 
 IF(@sysPageSize = 0)
   SET @sysPageSize = NULL;
 IF(@sysComboBoxPageSize = 0)
   SET @sysComboBoxPageSize = NULL;
 IF(@sysThresholdPercentage = 0)
   SET @sysThresholdPercentage = NULL;
 IF(@sysMainModuleId = 0)
   SET @sysMainModuleId = NULL;

 IF EXISTS( SELECT TOP 1 1 FROM [dbo].[SYSTM000Ref_UserSettings] (NOLOCK) usys WHERE usys.UserId=@userId AND usys.OrganizationId=@orgId AND usys.LangCode = @langCode)            
	BEGIN       
		
		SELECT @sysMainModuleId_Local = usys.[SysMainModuleId], 
		@sysDefaultAction_Local = usys.[SysDefaultAction],
		@sysStatusesIn_Local = usys.[SysStatusesIn],
		@sysGridViewPageSizes_Local = usys.[SysGridViewPageSizes],
		@sysPageSize_Local = usys.[SysPageSize],
		@sysComboBoxPageSize_Local = usys.[SysComboBoxPageSize],
		@sysThresholdPercentage_Local = usys.[SysThresholdPercentage]
		FROM [dbo].[SYSTM000Ref_UserSettings] (NOLOCK) usys WHERE usys.UserId=@userId AND usys.OrganizationId=@orgId AND usys.LangCode = @langCode; 

		UPDATE [dbo].[SYSTM000Ref_UserSettings] 
		SET [SysMainModuleId] = ISNULL(@sysMainModuleId, @sysMainModuleId_Local),
			[SysDefaultAction] = ISNULL(@sysDefaultAction, @sysDefaultAction_Local),
			[SysStatusesIn] = ISNULL(@sysStatusesIn, @sysStatusesIn_Local),
			[SysGridViewPageSizes] = ISNULL(@sysGridViewPageSizes, @sysGridViewPageSizes_Local),
			[SysPageSize] = ISNULL(@sysPageSize, @sysPageSize_Local),
			[SysComboBoxPageSize] = ISNULL(@sysComboBoxPageSize, @sysComboBoxPageSize_Local),
			[SysThresholdPercentage] = ISNULL(@sysThresholdPercentage, @sysThresholdPercentage_Local)
		WHERE UserId=@userId AND OrganizationId=@orgId AND LangCode = @langCode;  

	END
 ELSE
	BEGIN

		SELECT @sysMainModuleId_Local = usys.[SysMainModuleId], 
		@sysDefaultAction_Local = usys.[SysDefaultAction],
		@sysStatusesIn_Local = usys.[SysStatusesIn],
		@sysGridViewPageSizes_Local = usys.[SysGridViewPageSizes],
		@sysPageSize_Local = usys.[SysPageSize],
		@sysComboBoxPageSize_Local = usys.[SysComboBoxPageSize],
		@sysThresholdPercentage_Local = usys.[SysThresholdPercentage]
		FROM [dbo].[SYSTM000Ref_Settings] (NOLOCK) usys; 
		
		INSERT INTO [dbo].[SYSTM000Ref_UserSettings](OrganizationId, UserId, LangCode, SysMainModuleId, SysDefaultAction, SysStatusesIn, SysGridViewPageSizes, SysPageSize, SysComboBoxPageSize, SysThresholdPercentage) 
		VALUES(@orgId, @userId, @langCode, @sysMainModuleId_Local, @sysDefaultAction_Local, @sysStatusesIn_Local, @sysGridViewPageSizes_Local, @sysPageSize_Local, @sysComboBoxPageSize_Local, @sysThresholdPercentage_Local);

	END

END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdValidation]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Upd a sys validation
-- Execution:                 EXEC [dbo].[UpdValidation]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[UpdValidation]		  
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@langCode NVARCHAR(10)
	,@id BIGINT
	,@valTableName NVARCHAR(100) 
	,@refTabPageId BIGINT 
	,@valFieldName NVARCHAR(50)  = NULL
	,@valRequired BIT   = NULL
	,@valRequiredMessage NVARCHAR(255)   = NULL
	,@valUnique BIT   = NULL
	,@valUniqueMessage NVARCHAR(255)   = NULL
	,@valRegExLogic0 NVARCHAR(255)   = NULL
	,@valRegEx1 NVARCHAR(255)   = NULL
	,@valRegExMessage1 NVARCHAR(255)   = NULL
	,@valRegExLogic1 NVARCHAR(255)  = NULL 
	,@valRegEx2 NVARCHAR(255)   = NULL
	,@valRegExMessage2 NVARCHAR(255)  = NULL 
	,@valRegExLogic2 NVARCHAR(255)   = NULL
	,@valRegEx3 NVARCHAR(255)   = NULL
	,@valRegExMessage3 NVARCHAR(255)   = NULL
	,@valRegExLogic3 NVARCHAR(255)   = NULL
	,@valRegEx4 NVARCHAR(255)   = NULL
	,@valRegExMessage4 NVARCHAR(255)   = NULL
	,@valRegExLogic4 NVARCHAR(255)   = NULL
	,@valRegEx5 NVARCHAR(255)   = NULL
	,@valRegExMessage5 NVARCHAR(255)   = NULL
	,@statusId INT = NULL      
	,@dateChanged DATETIME2(7)   = NULL
	,@changedBy NVARCHAR(50)    = NULL
	,@isFormView BIT = 0
AS
BEGIN TRY                
 SET NOCOUNT ON;   
   UPDATE [dbo].[SYSTM000Validation]
     SET    LangCode		   = CASE WHEN (@isFormView = 1) THEN @langCode WHEN ((@isFormView = 0) AND (@langCode='#M4PL#')) THEN LangCode ELSE ISNULL(@langCode, LangCode)  END 
           ,ValTableName 	   = @valTableName  
           ,RefTabPageId 	   = ISNull(@refTabPageId,RefTabPageId)  
           ,ValFieldName 	   = CASE WHEN (@isFormView = 1) THEN @valFieldName WHEN ((@isFormView = 0) AND (@valFieldName='#M4PL#')) THEN NULL ELSE ISNULL(@valFieldName, ValFieldName) END
           ,ValRequired 	   = ISNULL(@valRequired, ValRequired)
           ,ValRequiredMessage = CASE WHEN (@isFormView = 1) THEN @valRequiredMessage WHEN ((@isFormView = 0) AND (@valRequiredMessage='#M4PL#')) THEN NULL ELSE ISNULL(@valRequiredMessage, ValRequiredMessage) END  
           ,ValUnique 		   = ISNULL(@valUnique, ValUnique)
           ,ValUniqueMessage   = CASE WHEN (@isFormView = 1) THEN @valUniqueMessage WHEN ((@isFormView = 0) AND (@valUniqueMessage='#M4PL#')) THEN NULL ELSE ISNULL(@valUniqueMessage, ValUniqueMessage) END
           ,ValRegExLogic0 	   = CASE WHEN (@isFormView = 1) THEN @valRegExLogic0 WHEN ((@isFormView = 0) AND (@valRegExLogic0='-100')) THEN NULL ELSE ISNULL(@valRegExLogic0, ValRegExLogic0) END
           ,ValRegEx1 		   = CASE WHEN (@isFormView = 1) THEN @valRegEx1 WHEN ((@isFormView = 0) AND (@valRegEx1='#M4PL#')) THEN NULL ELSE ISNULL(@valRegEx1, ValRegEx1) END
           ,ValRegExMessage1   = CASE WHEN (@isFormView = 1) THEN @valRegExMessage1 WHEN ((@isFormView = 0) AND (@valRegExMessage1='#M4PL#')) THEN NULL ELSE ISNULL(@valRegExMessage1, ValRegExMessage1) END
           ,ValRegExLogic1 	   = CASE WHEN (@isFormView = 1) THEN @valRegExLogic1 WHEN ((@isFormView = 0) AND (@valRegExLogic1='-100')) THEN NULL ELSE ISNULL(@valRegExLogic1, ValRegExLogic1) END
           ,ValRegEx2 		   = CASE WHEN (@isFormView = 1) THEN @valRegEx2 WHEN ((@isFormView = 0) AND (@valRegEx2='#M4PL#')) THEN NULL ELSE ISNULL(@valRegEx2, ValRegEx2) END
           ,ValRegExMessage2   = CASE WHEN (@isFormView = 1) THEN @valRegExMessage2 WHEN ((@isFormView = 0) AND (@valRegExMessage2='#M4PL#')) THEN NULL ELSE ISNULL(@valRegExMessage2, ValRegExMessage2) END
           ,ValRegExLogic2 	   = CASE WHEN (@isFormView = 1) THEN @valRegExLogic2 WHEN ((@isFormView = 0) AND (@valRegExLogic2='-100')) THEN NULL ELSE ISNULL(@valRegExLogic2, ValRegExLogic2) END
           ,ValRegEx3 		   = CASE WHEN (@isFormView = 1) THEN @valRegEx3 WHEN ((@isFormView = 0) AND (@valRegEx3='#M4PL#')) THEN NULL ELSE ISNULL(@valRegEx3, ValRegEx3) END
           ,ValRegExMessage3   = CASE WHEN (@isFormView = 1) THEN @valRegExMessage3 WHEN ((@isFormView = 0) AND (@valRegExMessage3='#M4PL#')) THEN NULL ELSE ISNULL(@valRegExMessage3, ValRegExMessage3) END 
           ,ValRegExLogic3 	   = CASE WHEN (@isFormView = 1) THEN @valRegExLogic3 WHEN ((@isFormView = 0) AND (@valRegExLogic3='-100')) THEN NULL ELSE ISNULL(@valRegExLogic3, ValRegExLogic3) END
           ,ValRegEx4 		   = CASE WHEN (@isFormView = 1) THEN @valRegEx4 WHEN ((@isFormView = 0) AND (@valRegEx4='#M4PL#')) THEN NULL ELSE ISNULL(@valRegEx4, ValRegEx4) END
           ,ValRegExMessage4   = CASE WHEN (@isFormView = 1) THEN @valRegExMessage4 WHEN ((@isFormView = 0) AND (@valRegExMessage4='#M4PL#')) THEN NULL ELSE ISNULL(@valRegExMessage4, ValRegExMessage4) END
           ,ValRegExLogic4 	   = CASE WHEN (@isFormView = 1) THEN @valRegExLogic4 WHEN ((@isFormView = 0) AND (@valRegExLogic4='-100')) THEN NULL ELSE ISNULL(@valRegExLogic4, ValRegExLogic4) END
           ,ValRegEx5 		   = CASE WHEN (@isFormView = 1) THEN @valRegEx5 WHEN ((@isFormView = 0) AND (@valRegEx5='#M4PL#')) THEN NULL ELSE ISNULL(@valRegEx5, ValRegEx5) END
           ,ValRegExMessage5   = CASE WHEN (@isFormView = 1) THEN @valRegExMessage5 WHEN ((@isFormView = 0) AND (@valRegExMessage5='#M4PL#')) THEN NULL ELSE ISNULL(@valRegExMessage5, ValRegExMessage5) END
           ,StatusId		   = CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
           ,DateChanged 	   = @dateChanged  
           ,ChangedBy  		   = @changedBy 
     WHERE Id  = @id		
	SELECT syst.[Id]
      ,syst.[LangCode]
      ,syst.[ValTableName]
      ,syst.[RefTabPageId]
      ,syst.[ValFieldName]
      ,syst.[ValRequired]
      ,syst.[ValRequiredMessage]
      ,syst.[ValUnique]
      ,syst.[ValUniqueMessage]
      ,syst.[ValRegExLogic0]
      ,syst.[ValRegEx1]
      ,syst.[ValRegExMessage1]
      ,syst.[ValRegExLogic1]
      ,syst.[ValRegEx2]
      ,syst.[ValRegExMessage2]
      ,syst.[ValRegExLogic2]
      ,syst.[ValRegEx3]
      ,syst.[ValRegExMessage3]
      ,syst.[ValRegExLogic3]
      ,syst.[ValRegEx4]
      ,syst.[ValRegExMessage4]
      ,syst.[ValRegExLogic4]
      ,syst.[ValRegEx5]
      ,syst.[ValRegExMessage5]
	  ,syst.[StatusId]
      ,syst.[DateEntered]
      ,syst.[EnteredBy]
      ,syst.[DateChanged]
      ,syst.[ChangedBy]
  FROM [dbo].[SYSTM000Validation] syst
 WHERE [Id]=@id 
END TRY      
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo,  NULL, @ErrorMessage,  NULL,  NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdVendBusinessTerm]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan    
-- Create date:               08/16/2018      
-- Description:               Upd a vend business tTerm
-- Execution:                 EXEC [dbo].[UpdVendBusinessTerm]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================  
ALTER PROCEDURE  [dbo].[UpdVendBusinessTerm]		  
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@langCode NVARCHAR(10)
	,@id BIGINT
	,@vbtOrgId BIGINT = NULL
	,@vbtVendorId BIGINT = NULL 
	,@vbtItemNumber INT  = NULL
	,@vbtCode NVARCHAR(20)  = NULL
	,@vbtTitle NVARCHAR(50)  = NULL
	,@businessTermTypeId INT  = NULL
	,@vbtActiveDate DATETIME2(7)  = NULL
	,@vbtValue DECIMAL(18,2)  = NULL
	,@vbtHiThreshold DECIMAL(18,2)  = NULL
	,@vbtLoThreshold DECIMAL(18,2)  = NULL
	,@vbtAttachment INT  = NULL
	,@statusId INT   = NULL
	,@changedBy NVARCHAR(50)  = NULL
	,@dateChanged DATETIME2(7)  = NULL
	,@isFormView BIT = 0
AS
BEGIN TRY                
 SET NOCOUNT ON; 
  DECLARE @updatedItemNumber INT      
 EXEC [dbo].[ResetItemNumber] @userId, @id, @vbtVendorId, @entity, @vbtItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT
   
   UPDATE [dbo].[VEND020BusinessTerms]
    SET     LangCode			=	CASE WHEN (@isFormView = 1) THEN @langCode WHEN ((@isFormView = 0) AND (@langCode='#M4PL#')) THEN LangCode ELSE ISNULL(@langCode, LangCode)  END 
           ,VbtOrgId 			=	CASE WHEN (@isFormView = 1) THEN @vbtOrgId WHEN ((@isFormView = 0) AND (@vbtOrgId=-100)) THEN NULL ELSE ISNULL(@vbtOrgId, VbtOrgId) END
           ,VbtVendorId 		=	CASE WHEN (@isFormView = 1) THEN @vbtVendorId WHEN ((@isFormView = 0) AND (@vbtVendorId=-100)) THEN NULL ELSE ISNULL(@vbtVendorId, VbtVendorId) END
           ,VbtItemNumber 		=	CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, VbtItemNumber) END
           ,VbtCode 			=	CASE WHEN (@isFormView = 1) THEN @vbtCode WHEN ((@isFormView = 0) AND (@vbtCode='#M4PL#')) THEN NULL ELSE ISNULL(@vbtCode, VbtCode) END
           ,VbtTitle 			=	CASE WHEN (@isFormView = 1) THEN @vbtTitle WHEN ((@isFormView = 0) AND (@vbtTitle='#M4PL#')) THEN NULL ELSE ISNULL(@vbtTitle, VbtTitle) END
           ,BusinessTermTypeId 	=	CASE WHEN (@isFormView = 1) THEN @businessTermTypeId WHEN ((@isFormView = 0) AND (@businessTermTypeId=-100)) THEN NULL ELSE ISNULL(@businessTermTypeId, BusinessTermTypeId) END  
           ,VbtActiveDate 		=	CASE WHEN (@isFormView = 1) THEN @vbtActiveDate WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @vbtActiveDate, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@vbtActiveDate, VbtActiveDate) END
           ,VbtValue 			=	CASE WHEN (@isFormView = 1) THEN @vbtValue WHEN ((@isFormView = 0) AND (@vbtValue=-100.00)) THEN NULL ELSE ISNULL(@vbtValue, VbtValue) END
           ,VbtHiThreshold 		=	CASE WHEN (@isFormView = 1) THEN @vbtHiThreshold WHEN ((@isFormView = 0) AND (@vbtHiThreshold=-100.00)) THEN NULL ELSE ISNULL(@vbtHiThreshold, VbtHiThreshold) END
           ,VbtLoThreshold 		=	CASE WHEN (@isFormView = 1) THEN @vbtLoThreshold WHEN ((@isFormView = 0) AND (@vbtLoThreshold=-100.00)) THEN NULL ELSE ISNULL(@vbtLoThreshold, VbtLoThreshold) END
           --,VbtAttachment 		=	CASE WHEN (@isFormView = 1) THEN @vbtAttachment WHEN ((@isFormView = 0) AND (@vbtAttachment=-100)) THEN NULL ELSE ISNULL(@vbtAttachment, VbtAttachment) END
           ,StatusId 			=	CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
           ,ChangedBy 			=	@changedBy  
           ,DateChanged			= 	@dateChanged 
      WHERE Id   = 	@id
		EXEC [dbo].[GetVendBusinessTerm] @userId, @roleId, @vbtOrgId ,@langCode, @id 
END TRY      
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdVendContact]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan    
-- Create date:               08/16/2018      
-- Description:               Upd a vend contact
-- Execution:                 EXEC [dbo].[UpdVendContact]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[UpdVendContact]		  
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id BIGINT
	,@vendVendorId BIGINT = NULL
	,@vendItemNumber INT  = NULL
	,@vendContactCode NVARCHAR(20)  = NULL
	,@vendContactTitle NVARCHAR(50)  = NULL
	,@vendContactMSTRId BIGINT  = NULL
	,@statusId INT  = NULL
	,@changedBy NVARCHAR(50)  = NULL
	,@dateChanged DATETIME2(7)  = NULL
	,@isFormView BIT = 0
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  DECLARE @updatedItemNumber INT      
 EXEC [dbo].[ResetItemNumber] @userId, @id, @vendVendorId, @entity, @vendItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT 

   UPDATE  [dbo].[VEND010Contacts]
     SET    VendVendorId 	  = CASE WHEN (@isFormView = 1) THEN @vendVendorId WHEN ((@isFormView = 0) AND (@vendVendorId=-100)) THEN NULL ELSE ISNULL(@vendVendorId, VendVendorId) END
           ,VendItemNumber 	  = CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, VendItemNumber) END
           ,VendContactCode   = CASE WHEN (@isFormView = 1) THEN @vendContactCode WHEN ((@isFormView = 0) AND (@vendContactCode='#M4PL#')) THEN NULL ELSE ISNULL(@vendContactCode, VendContactCode)  END
           ,VendContactTitle  = CASE WHEN (@isFormView = 1) THEN @vendContactTitle WHEN ((@isFormView = 0) AND (@vendContactTitle='#M4PL#')) THEN NULL ELSE ISNULL(@vendContactTitle, VendContactTitle)  END
           ,VendContactMSTRId = CASE WHEN (@isFormView = 1) THEN @vendContactMSTRId WHEN ((@isFormView = 0) AND (@vendContactMSTRId=-100)) THEN NULL ELSE ISNULL(@vendContactMSTRId, VendContactMSTRId)  END
           ,StatusId 		  = CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
           ,ChangedBy 		  = @changedBy  
           ,DateChanged		  = @dateChanged 
      WHERE Id = @id	
	  
		IF(ISNULL(@statusId, 1) <> -100)
		BEGIN
			IF(ISNULL(@statusId, 1) > 2)
			BEGIN
				EXEC [dbo].[UpdateColumnCount] @tableName = 'VEND000Master', @columnName = 'VendContacts',  @rowId = @vendVendorId, @countToChange = -1
			END
		END  


		SELECT vend.[Id]
		,vend.[VendVendorID]
		,vend.[VendItemNumber]
		,vend.[VendContactCode]
		,vend.[VendContactTitle]
		,vend.[VendContactMSTRID]
		,vend.[StatusId]
		,vend.[EnteredBy]
		,vend.[DateEntered]
		,vend.[ChangedBy]
		,vend.[DateChanged]
		FROM [dbo].[VEND010Contacts] vend
		WHERE [Id]=@id 
END TRY    
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdVendDCLocation]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan    
-- Create date:               08/16/2018      
-- Description:               Upd a vend dc loc
-- Execution:                 EXEC [dbo].[UpdVendDCLocation]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[UpdVendDCLocation]		  
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id BIGINT
	,@vdcVendorId BIGINT = NULL
	,@vdcItemNumber INT  = NULL
	,@vdcLocationCode NVARCHAR(20)  = NULL
	,@vdcCustomerCode NVARCHAR(20) = NULL 
	,@vdcLocationTitle NVARCHAR(50)  = NULL
	,@vdcContactMSTRId BIGINT  = NULL
	,@statusId INT  = NULL
	,@changedBy NVARCHAR(50)  = NULL
	,@dateChanged DATETIME2(7)   = NULL
	,@isFormView BIT = 0
AS
BEGIN TRY                
 SET NOCOUNT ON; 
  DECLARE @updatedItemNumber INT      
 EXEC [dbo].[ResetItemNumber] @userId, @id, @vdcVendorId, @entity, @vdcItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT
   
   UPDATE [dbo].[VEND040DCLocations]
    SET     VdcVendorId 		= CASE WHEN (@isFormView = 1) THEN @vdcVendorId WHEN ((@isFormView = 0) AND (@vdcVendorId=-100)) THEN NULL ELSE ISNULL(@vdcVendorId, VdcVendorId) END
           ,VdcItemNumber 		= CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, VdcItemNumber) END
           ,VdcLocationCode 	= CASE WHEN (@isFormView = 1) THEN @vdcLocationCode WHEN ((@isFormView = 0) AND (@vdcLocationCode='#M4PL#')) THEN NULL ELSE ISNULL(@vdcLocationCode, VdcLocationCode)  END
		   ,VdcCustomerCode 	= CASE WHEN (@isFormView = 1) THEN ISNULL(@vdcCustomerCode,@vdcLocationCode) WHEN ((@isFormView = 0) AND (@vdcCustomerCode='#M4PL#')) THEN @vdcLocationCode ELSE ISNULL(@vdcCustomerCode,VdcCustomerCode)  END
           ,VdcLocationTitle 	= CASE WHEN (@isFormView = 1) THEN @vdcLocationTitle WHEN ((@isFormView = 0) AND (@vdcLocationTitle='#M4PL#')) THEN NULL ELSE ISNULL(@vdcLocationTitle, VdcLocationTitle)  END
           ,VdcContactMSTRId 	= CASE WHEN (@isFormView = 1) THEN @vdcContactMSTRId WHEN ((@isFormView = 0) AND (@vdcContactMSTRId=-100)) THEN NULL ELSE ISNULL(@vdcContactMSTRId, VdcContactMSTRId)  END
           ,StatusId 			= CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
           ,ChangedBy 			= @changedBy 
           ,DateChanged   		= @dateChanged 
      WHERE Id = @id 	
	  
	  /*Below to update DcLocationContact Code*/
	 UPDATE vdcContact SET vdcContact.VlcContactCode = vdc.VdcLocationCode 
	 FROM [dbo].[VEND041DCLocationContacts] vdcContact
	 INNER JOIN [dbo].[VEND040DCLocations] vdc ON vdcContact.VlcVendDcLocationId = vdc.Id
	  	  
		EXEC [dbo].[GetVendDCLocation] @userId, @roleId, 1 ,@id 
END TRY    
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdVendDcLocationContact]    Script Date: 11/27/2018 12:43:09 PM ******/
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
	  SET  ConCompany					= CASE WHEN (@isFormView = 1) THEN @conCompany WHEN ((@isFormView = 0) AND (@conCompany='#M4PL#')) THEN NULL ELSE ISNULL(@conCompany,ConCompany) END
			,ConTitleId					= ISNULL(@conTitleId,ConTitleId)
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
GO
/****** Object:  StoredProcedure [dbo].[UpdVendDocReference]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan    
-- Create date:               08/16/2018      
-- Description:               Upd a vend doc ref
-- Execution:                 EXEC [dbo].[UpdVendDocReference]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[UpdVendDocReference]		  
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id BIGINT	 
	,@vdrOrgId BIGINT = NULL
	,@vdrVendorId BIGINT = NULL
	,@vdrItemNumber INT = NULL
	,@vdrCode NVARCHAR(20) = NULL
	,@vdrTitle NVARCHAR(50) = NULL
	,@docRefTypeId INT = NULL
	,@docCategoryTypeId INT = NULL
	,@vdrAttachment INT = NULL
	,@vdrDateStart DATETIME2(7) = NULL
	,@vdrDateEnd DATETIME2(7) = NULL
	,@vdrRenewal BIT = NULL
	,@statusId INT = NULL 
	,@changedBy NVARCHAR(50) = NULL
	,@dateChanged DATETIME2(7) = NULL
	,@isFormView BIT = 0
AS
BEGIN TRY                
 SET NOCOUNT ON;   
      DECLARE @updatedItemNumber INT      
  EXEC [dbo].[ResetItemNumber] @userId, @id, @vdrVendorId, @entity, @vdrItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT
   UPDATE [dbo].[VEND030DocumentReference]
    SET     VdrOrgId 			 = CASE WHEN (@isFormView = 1) THEN @vdrOrgId WHEN ((@isFormView = 0) AND (@vdrOrgId=-100)) THEN NULL ELSE ISNULL(@vdrOrgId, VdrOrgId) END
           ,VdrVendorId 		 = CASE WHEN (@isFormView = 1) THEN @vdrVendorId WHEN ((@isFormView = 0) AND (@vdrVendorId=-100)) THEN NULL ELSE ISNULL(@vdrVendorId, VdrVendorId) END
           ,VdrItemNumber 		 = CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, VdrItemNumber) END
           ,VdrCode 			 = CASE WHEN (@isFormView = 1) THEN @vdrCode WHEN ((@isFormView = 0) AND (@vdrCode='#M4PL#')) THEN NULL ELSE ISNULL(@vdrCode, VdrCode) END
           ,VdrTitle 			 = CASE WHEN (@isFormView = 1) THEN @vdrTitle WHEN ((@isFormView = 0) AND (@vdrTitle='#M4PL#')) THEN NULL ELSE ISNULL(@vdrTitle, VdrTitle) END
           ,DocRefTypeId 		 = CASE WHEN (@isFormView = 1) THEN @docRefTypeId WHEN ((@isFormView = 0) AND (@docRefTypeId=-100)) THEN NULL ELSE ISNULL(@docRefTypeId, DocRefTypeId) END
           ,DocCategoryTypeId 	 = CASE WHEN (@isFormView = 1) THEN @docCategoryTypeId WHEN ((@isFormView = 0) AND (@docCategoryTypeId=-100)) THEN NULL ELSE ISNULL(@docCategoryTypeId, DocCategoryTypeId)  END
           --,VdrAttachment 		 = CASE WHEN (@isFormView = 1) THEN @vdrAttachment WHEN ((@isFormView = 0) AND (@vdrAttachment=-100)) THEN NULL ELSE ISNULL(@vdrAttachment, VdrAttachment) END
           ,VdrDateStart 		 = CASE WHEN (@isFormView = 1) THEN @vdrDateStart WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @vdrDateStart, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@vdrDateStart, VdrDateStart) END
           ,VdrDateEnd 			 = CASE WHEN (@isFormView = 1) THEN @vdrDateEnd WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @vdrDateEnd, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@vdrDateEnd, VdrDateEnd) END
           ,VdrRenewal 			 = ISNULL(@vdrRenewal, VdrRenewal)
           ,StatusId 			 = CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
           ,ChangedBy 			 = @changedBy   
           ,DateChanged			 = @dateChanged  
      WHERE Id = @id
		EXEC [dbo].[GetVendDocReference] @userId, @roleId, @vdrOrgId ,@id 
END TRY       
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdVendFinancialCalender]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan    
-- Create date:               08/16/2018      
-- Description:               Upd a vend fin cal
-- Execution:                 EXEC [dbo].[UpdVendFinancialCalender]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[UpdVendFinancialCalender]		  
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id BIGINT	
	,@orgId BIGINT = NULL
	,@vendId BIGINT = NULL
	,@fclPeriod INT = NULL
	,@fclPeriodCode NVARCHAR(20) = NULL
	,@fclPeriodStart DATETIME2(7) = NULL 
	,@fclPeriodEnd DATETIME2(7) = NULL
	,@fclPeriodTitle NVARCHAR(50) = NULL
	,@fclAutoShortCode NVARCHAR(15) = NULL
	,@fclWorkDays INT = NULL
	,@finCalendarTypeId INT = NULL
	,@statusId INT = NULL 
	,@dateChanged DATETIME2(7) = NULL
	,@changedBy NVARCHAR(50)  = NULL
	,@isFormView BIT = 0
AS
BEGIN TRY                
 SET NOCOUNT ON; 
   DECLARE @updatedItemNumber INT      
  EXEC [dbo].[ResetItemNumber] @userId, @id, @vendId, @entity, @fclPeriod, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT 
   
  UPDATE  [dbo].[VEND050Finacial_Cal]
    SET     OrgId 				= CASE WHEN (@isFormView = 1) THEN @orgId WHEN ((@isFormView = 0) AND (@orgId=-100)) THEN NULL ELSE ISNULL(@orgId, OrgId) END
           ,VendId 				= CASE WHEN (@isFormView = 1) THEN @vendId WHEN ((@isFormView = 0) AND (@vendId=-100)) THEN NULL ELSE ISNULL(@vendId, VendId) END
           ,FclPeriod 			= CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, FclPeriod) END
           ,FclPeriodCode 		= CASE WHEN (@isFormView = 1) THEN @fclPeriodCode WHEN ((@isFormView = 0) AND (@fclPeriodCode='#M4PL#')) THEN NULL ELSE ISNULL(@fclPeriodCode, FclPeriodCode) END
           ,FclPeriodStart 		= CASE WHEN (@isFormView = 1) THEN @fclPeriodStart WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @fclPeriodStart, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@fclPeriodStart, FclPeriodStart) END
           ,FclPeriodEnd 		= CASE WHEN (@isFormView = 1) THEN @fclPeriodEnd WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @fclPeriodEnd, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@fclPeriodEnd, FclPeriodEnd) END
           ,FclPeriodTitle 		= CASE WHEN (@isFormView = 1) THEN @fclPeriodTitle WHEN ((@isFormView = 0) AND (@fclPeriodTitle='#M4PL#')) THEN NULL ELSE ISNULL(@fclPeriodTitle, FclPeriodTitle) END
           ,FclAutoShortCode	= CASE WHEN (@isFormView = 1) THEN @fclAutoShortCode WHEN ((@isFormView = 0) AND (@fclAutoShortCode='#M4PL#')) THEN NULL ELSE ISNULL(@fclAutoShortCode, FclAutoShortCode) END
           ,FclWorkDays 		= CASE WHEN (@isFormView = 1) THEN @fclWorkDays WHEN ((@isFormView = 0) AND (@fclWorkDays=-100)) THEN NULL ELSE ISNULL(@fclWorkDays, FclWorkDays) END
           ,FinCalendarTypeId 	= CASE WHEN (@isFormView = 1) THEN @finCalendarTypeId WHEN ((@isFormView = 0) AND (@finCalendarTypeId=-100)) THEN NULL ELSE ISNULL(@finCalendarTypeId, FinCalendarTypeId) END  
           ,StatusId	 		= CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
           ,DateChanged 		= @dateChanged  
           ,ChangedBy  			= @changedBy 
      WHERE Id = @id
		EXEC [dbo].[GetVendFinancialCalender] @userId, @roleId, @orgId ,@id 
END TRY   
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UpdVendor]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan    
-- Create date:               08/16/2018      
-- Description:               Upd a vender
-- Execution:                 EXEC [dbo].[UpdVendor]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[UpdVendor]		  
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id BIGINT	
	,@vendERPId NVARCHAR(10) = NULL
	,@vendOrgId BIGINT  = NULL
	,@vendItemNumber INT  = NULL
	,@vendCode NVARCHAR(20)  = NULL
	,@vendTitle NVARCHAR(50)  = NULL
	,@vendWorkAddressId BIGINT  = NULL
	,@vendBusinessAddressId BIGINT  = NULL
	,@vendCorporateAddressId BIGINT  = NULL
	,@vendContacts INT  = NULL
	,@vendTypeId INT  = NULL
	,@vendTypeCode NVARCHAR(100) = NULL
	,@vendWebPage NVARCHAR(100)  = NULL
	,@statusId INT   = NULL
	,@changedBy NVARCHAR(50)  = NULL
	,@dateChanged DATETIME2(7)  = NULL
	,@isFormView BIT = 0
AS
BEGIN TRY                
 SET NOCOUNT ON;   
    DECLARE @updatedItemNumber INT      
  EXEC [dbo].[ResetItemNumber] @userId, @id, @vendOrgId, @entity, @vendItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT

  IF NOT EXISTS(SELECT Id  FROM [dbo].[SYSTM000Ref_Options] WHERE SysOptionName = @vendTypeCode) AND ISNULL(@vendTypeId,0) = 0
  BEGIN
     DECLARE @highestTypeCodeSortOrder INT;
	 SELECT @highestTypeCodeSortOrder = MAX(SysSortOrder) FROM [dbo].[SYSTM000Ref_Options] WHERE SysLookupId=8; 
	 SET @highestTypeCodeSortOrder = ISNULL(@highestTypeCodeSortOrder, 0) + 1;
     INSERT INTO [dbo].[SYSTM000Ref_Options](SysLookupId, SysLookupCode, SysOptionName, SysSortOrder, StatusId, DateEntered, EnteredBy)
	 VALUES(50, 'VendorType', @vendTypeCode, @highestTypeCodeSortOrder , ISNULL(@statusId,1), @dateChanged, @changedBy)
	 SET @vendTypeId = SCOPE_IDENTITY();
  END
  ELSE IF ((@vendTypeId > 0) AND (ISNULL(@vendTypeCode, '') <> ''))
  BEGIN
    UPDATE [dbo].[SYSTM000Ref_Options] SET SysOptionName =@vendTypeCode WHERE Id =@vendTypeId
  END

   UPDATE  [dbo].[VEND000Master]
        SET  
		    VendERPId 				= CASE WHEN (@isFormView = 1) THEN @vendERPId WHEN ((@isFormView = 0) AND (@vendERPId='#M4PL#')) THEN NULL ELSE ISNULL(@vendERPId, VendERPId) END
           ,VendOrgId 				= CASE WHEN (@isFormView = 1) THEN @vendOrgId WHEN ((@isFormView = 0) AND (@vendOrgId=-100)) THEN NULL ELSE ISNULL(@vendOrgId, VendOrgId) END
           ,VendItemNumber 			= CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, VendItemNumber) END
           ,VendCode 				= CASE WHEN (@isFormView = 1) THEN @vendCode WHEN ((@isFormView = 0) AND (@vendCode='#M4PL#')) THEN NULL ELSE ISNULL(@vendCode, VendCode) END
           ,VendTitle 				= CASE WHEN (@isFormView = 1) THEN @vendTitle WHEN ((@isFormView = 0) AND (@vendTitle='#M4PL#')) THEN NULL ELSE ISNULL(@vendTitle, VendTitle) END
           ,VendWorkAddressId 		= CASE WHEN(@vendWorkAddressId = 0) THEN NULL ELSE ISNULL(@vendWorkAddressId, VendWorkAddressId) END
           ,VendBusinessAddressId	= CASE WHEN(@vendBusinessAddressId = 0) THEN NULL ELSE ISNULL(@vendBusinessAddressId, VendBusinessAddressId) END
           ,VendCorporateAddressId	= CASE WHEN(@vendCorporateAddressId = 0) THEN NULL ELSE ISNULL(@vendCorporateAddressId, VendCorporateAddressId) END
           --,VendContacts 			= CASE WHEN (@isFormView = 1) THEN @vendContacts WHEN ((@isFormView = 0) AND (@vendContacts=-100)) THEN NULL ELSE ISNULL(@vendContacts, VendContacts) END
           ,VendTypeId 				= CASE WHEN (@isFormView = 1) THEN @vendTypeId WHEN ((@isFormView = 0) AND (@vendTypeId=-100)) THEN NULL ELSE ISNULL(@vendTypeId, VendTypeId) END
           ,VendWebPage 			= CASE WHEN (@isFormView = 1) THEN @vendWebPage WHEN ((@isFormView = 0) AND (@vendWebPage='#M4PL#')) THEN NULL ELSE ISNULL(@vendWebPage, VendWebPage) END
           ,StatusId 				= CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
           ,ChangedBy 				= @changedBy  
           ,DateChanged   			= @dateChanged  
      WHERE Id = @id 
		EXEC [dbo].[GetVendor] @userId, @roleId, @vendOrgId ,@id 
END TRY     
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[UploadFiles]    Script Date: 11/27/2018 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana Behara         
-- Create date:               11/08/2018      
-- Description:               UploadFiles
-- Execution:                 EXEC [dbo].[UploadFiles]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[UploadFiles]      
      @userId BIGINT  
     ,@roleId BIGINT  
 	 ,@entity NVARCHAR(100)  
     ,@langCode NVARCHAR(10)  
     ,@recordId BIGINT  
     ,@refTableName NVARCHAR(50) = NULL  
     ,@fieldName NVARCHAR(100) = NULL  
     ,@fieldValue IMAGE = NULL  
      
AS  
BEGIN TRY                  
 SET NOCOUNT ON;
 DECLARE @tableName NVARCHAR(100)  
 SELECT @tableName = TblTableName FROM SYSTM000Ref_Table WHERE SysRefName = @refTableName;  
 DECLARE @sqlQuery NVARCHAR(MAX)  

 SET @sqlQuery='UPDATE  '+@tableName+'   SET  '+ @fieldName + '= @fieldValue  WHERE Id = @recordId';    
 EXEC sp_executesql @sqlQuery, N'@fieldValue IMAGE, @id BIGINT' , 
     @fieldValue= @fieldValue,  
     @recordId = @recordId;  
   SELECT  @@ROWCOUNT;
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
