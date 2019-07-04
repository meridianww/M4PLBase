


GO
PRINT N'Altering [dbo].[UpdCustContact]...';


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
-- Modified on:				  26th Apr 2019 (Parthiban M)
-- Modified Desc:			  Changes done for related to contact bridge implementation
-- ============================================= 
ALTER PROCEDURE  [dbo].[UpdCustContact]
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@orgId BIGINT
	,@id BIGINT
	,@custCustomerId BIGINT   = NULL
	,@custItemNumber INT   = NULL
	,@custContactCodeId BIGINT  = NULL
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
  SELECT  @recordId=Id, @custItemNumber=ISNULL(@custItemNumber, ConItemNumber)  FROM [dbo].[CONTC010Bridge] WHERE Id = @id

 IF(@recordId=@id)
 BEGIN
   
   UPDATE [dbo].[CONTC010Bridge]
	    SET ConPrimaryRecordId    =  ISNULL(@custCustomerId, ConPrimaryRecordId) 
           ,ConItemNumber	      =  ISNULL(@updatedItemNumber, ConItemNumber) 
           ,ConCodeId	          =  ISNULL(@custContactCodeId, ConCodeId) 
           ,ConTitle              =  ISNULL(@custContactTitle, ConTitle) 
           ,ContactMSTRID         =  ISNULL(@custContactMSTRId, ContactMSTRID) 
		   ,StatusId		      =  ISNULL(@statusId, StatusId) 
           ,ChangedBy		      =  ISNULL(@changedBy,ChangedBy)
           ,DateChanged		      =  ISNULL(@dateChanged,DateChanged)	
      WHERE Id = @id				  
 END
IF(ISNULL(@statusId, 1) <> -100)
BEGIN
	IF NOT EXISTS(SELECT TOP 1 1 FROM [dbo].[fnGetUserStatuses](@userId) WHERE StatusId = @statusId)
	BEGIN
		EXEC [dbo].[UpdateColumnCount] @tableName = 'CUST000Master', @columnName = 'CustContacts',  @rowId = @custCustomerId, @countToChange = -1
	END
END
EXEC [dbo].[GetCustContact] @userId, @roleId, @orgId ,@id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
PRINT N'Altering [dbo].[UpdCustDcLocation]...';


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
-- Modified on:				  2nd May 2019
-- Modified Desc:			  Implemented contact bridge related item by Parthiban M    
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
       SET   CdcCustomerId	  =  ISNULL(@cdcCustomerId, CdcCustomerId) 
            ,CdcItemNumber	  =  ISNULL(@updatedItemNumber, CdcItemNumber) 
            ,CdcLocationCode  =  ISNULL(@cdcLocationCode, CdcLocationCode)  
			,CdcCustomerCode  =  ISNULL(@cdcCustomerCode,CdcCustomerCode)  
            ,CdcLocationTitle =  ISNULL(@cdcLocationTitle, CdcLocationTitle)   
            ,CdcContactMSTRId =  ISNULL(@cdcContactMSTRId, CdcContactMSTRId) 
            ,StatusId		  =  ISNULL(@statusId, StatusId) 
            ,ChangedBy		  =  ISNULL(@changedBy,ChangedBy)
            ,DateChanged	  =  ISNULL(@dateChanged, DateChanged)
	  WHERE  Id = @id 
	              
	EXEC [dbo].[GetCustDcLocation] @userId, @roleId, 1 ,@id 
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
PRINT N'Altering [dbo].[UpdCustDcLocationContact]...';


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
-- Modified on:				  26th Apr 2019 (Parthiban M)
-- Modified Desc:			  Changes done for related to contact bridge implementation
-- Modified on:				  6th Jun 2019 (Kirty)
-- Modified Desc:			  Removed unused parameters
-- =============================================
ALTER PROCEDURE  [dbo].[UpdCustDcLocationContact]		  
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id BIGINT
	,@clcCustDcLocationId BIGINT = NULL
	,@clcItemNumber INT = NULL
	,@clcContactTitle NVARCHAR(50)  = NULL
	,@clcContactMSTRID BIGINT   = NULL
	,@statusId INT = NULL
	,@conTitleId INT = NULL
	,@conLastName NVARCHAR(25) = NULL
	,@conFirstName NVARCHAR(25) = NULL
	,@conMiddleName NVARCHAR(25) = NULL
	,@conJobTitle NVARCHAR(50) = NULL
	,@conOrgId BIGINT = NULL
	,@conTypeId INT = NULL
	,@conUDF01 INT = NULL
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
  EXEC [dbo].[ResetItemNumber] @userId, @id, @clcCustDcLocationId, @entity, @clcItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT  
  --First Update Contact
  IF((ISNULL(@clcContactMSTRID, 0) <> 0) AND (@isFormView = 1))
  BEGIN
	UPDATE  [dbo].[CONTC000Master]
	  SET    ConTitleId					= ISNULL(@conTitleId,ConTitleId)
			,ConLastName				= ISNULL(@conLastName,ConLastName) 
			,ConFirstName				= ISNULL(@conFirstName,ConFirstName) 
			,ConMiddleName				= ISNULL(@conMiddleName,ConMiddleName) 
			,ConEmailAddress			= ISNULL(@conEmailAddress,ConEmailAddress) 
			,ConEmailAddress2			= ISNULL(@conEmailAddress2,ConEmailAddress2) 
			,ConJobTitle				= ISNULL(@conJobTitle,ConJobTitle) 
			,ConBusinessPhone			= ISNULL(@conBusinessPhone,ConBusinessPhone) 
			,ConBusinessPhoneExt		= ISNULL(@conBusinessPhoneExt,ConBusinessPhoneExt) 
			,ConMobilePhone				= ISNULL(@conMobilePhone,ConMobilePhone) 
			,ConUDF01					= ISNULL(@conUDF01,ConUDF01)
			,StatusId					= ISNULL(@statusId ,StatusId)
			,ConTypeId					= ISNULL(@conTypeId,ConTypeId)
			,DateChanged				= ISNULL(@dateChanged,DateChanged)
			,ChangedBy					= ISNULL(@changedBy,ChangedBy)
	WHERE  Id = @clcContactMSTRID
  END

  --Then Update Cust Dc Location
    UPDATE  [dbo].[CONTC010Bridge]
       SET  [ConPrimaryRecordId]		= ISNULL(@clcCustDcLocationId, ConPrimaryRecordId) 
			,[ConItemNumber]			= @updatedItemNumber
			,[ConTitle]		          	= ISNULL(@clcContactTitle, ConTitle)   
			,[ContactMSTRID]			= ISNULL(@clcContactMSTRID, [ContactMSTRID]) 
			,[ConTableTypeId]			= ISNULL(@conUDF01, ConTableTypeId)
			,[ConTypeId]				= ISNULL(@conTypeId, ConTypeId)
			,[StatusId]					= ISNULL(@statusId, StatusId) 
            ,[ChangedBy]				= ISNULL(@changedBy,ChangedBy)   
            ,[DateChanged]				= ISNULL(@dateChanged,DateChanged) 
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
PRINT N'Altering [dbo].[UpdCustDocReference]...';


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
        SET  CdrOrgId				=  ISNULL(@cdrOrgId, CdrOrgId) 
            ,CdrCustomerId			=  ISNULL(@cdrCustomerId, CdrCustomerId) 
            ,CdrItemNumber			=  ISNULL(@updatedItemNumber, CdrItemNumber)
            ,CdrCode				=  ISNULL(@cdrCode, CdrCode) 
            ,CdrTitle				=  ISNULL(@cdrTitle, CdrTitle) 
            ,DocRefTypeId			=  ISNULL(@docRefTypeId, DocRefTypeId) 
            ,DocCategoryTypeId		=  ISNULL(@docCategoryTypeId, DocCategoryTypeId)  
            ,CdrDateStart			=  CASE WHEN (@isFormView = 1) THEN @cdrDateStart WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @cdrDateStart, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@cdrDateStart, CdrDateStart) END
            ,CdrDateEnd				=  CASE WHEN (@isFormView = 1) THEN @cdrDateEnd WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @cdrDateEnd, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@cdrDateEnd, CdrDateEnd) END
            ,CdrRenewal				=  ISNULL(@cdrRenewal, CdrRenewal)	  
            ,StatusId				=  ISNULL(@statusId, StatusId) 	  
            ,ChangedBy				=  ISNULL(@changedBy, ChangedBy)
            ,DateChanged			=  ISNULL(@dateChanged,	DateChanged)	
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
PRINT N'Altering [dbo].[UpdCustFinacialCalender]...';


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
      SET  OrgId				= ISNULL(@orgId, OrgId)
          ,CustId				= ISNULL(@custId, CustId) 
          ,FclPeriod			= ISNULL(@updatedItemNumber, FclPeriod) 
          ,FclPeriodCode		= ISNULL(@fclPeriodCode, FclPeriodCode) 
          ,FclPeriodStart		= CASE WHEN (@isFormView = 1) THEN @fclPeriodStart WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @fclPeriodStart, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@fclPeriodStart, FclPeriodStart) END
          ,FclPeriodEnd			= CASE WHEN (@isFormView = 1) THEN @fclPeriodEnd WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @fclPeriodEnd, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@fclPeriodEnd, FclPeriodEnd) END
          ,FclPeriodTitle		= ISNULL(@fclPeriodTitle, FclPeriodTitle) 
          ,FclAutoShortCode		= ISNULL(@fclAutoShortCode, FclAutoShortCode) 
          ,FclWorkDays			= ISNULL(@fclWorkDays, FclWorkDays) 
          ,FinCalendarTypeId	= ISNULL(@finCalendarTypeId, FinCalendarTypeId)   
          ,StatusId				= ISNULL(@statusId, StatusId) 
          ,DateChanged			= ISNULL(@dateChanged,DateChanged)
          ,ChangedBy 			= ISNULL(@changedBy, ChangedBy)	
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
PRINT N'Altering [dbo].[UpdCustomer]...';


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
      SET   [CustERPId]					=  ISNULL(@custERPId, CustERPId)
           ,[CustOrgId]					=  ISNULL(@custOrgId, CustOrgId) 
           ,[CustItemNumber]			=  ISNULL(@updatedItemNumber  , CustItemNumber) 
           ,[CustCode]					=  ISNULL(@custCode, CustCode) 
           ,[CustTitle]					=  ISNULL(@custTitle, CustTitle) 
           ,[CustWorkAddressId]			=  ISNULL(@custWorkAddressId, CustWorkAddressId) 
           ,[CustBusinessAddressId]		=  ISNULL(@custBusinessAddressId, CustBusinessAddressId) 
           ,[CustCorporateAddressId]	=  ISNULL(@custCorporateAddressId, CustCorporateAddressId) 
           ,[CustTypeId]				=  ISNULL(@custTypeId  , CustTypeId) 
           ,[CustWebPage]				=  ISNULL(@custWebPage , CustWebPage) 
           ,[StatusId]					=  ISNULL(@statusId, StatusId) 
           ,[ChangedBy]					=  ISNULL(@changedBy,ChangedBy)
           ,[DateChanged]				=  ISNULL(@dateChanged,DateChanged)
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
PRINT N'Altering [dbo].[UpdCustBusinessTerm]...';

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
      SET    LangCode				= 	  ISNULL(@langCode, LangCode)  
			,CbtOrgId				= 	  ISNULL(@cbtOrgId, CbtOrgId) 
			,CbtCustomerId			= 	  ISNULL(@cbtCustomerId, CbtCustomerId)  
			,CbtItemNumber			= 	  ISNULL(@updatedItemNumber, CbtItemNumber)  
			,CbtCode				= 	  ISNULL(@cbtCode, CbtCode)  
			,CbtTitle				= 	  ISNULL(@cbtTitle, CbtTitle)  
			,BusinessTermTypeId     = 	  ISNULL(@businessTermTypeId, BusinessTermTypeId)  
			,CbtActiveDate			= 	  CASE WHEN (@isFormView = 1) THEN @cbtActiveDate WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @cbtActiveDate, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@cbtActiveDate, CbtActiveDate) END
			,CbtValue				= 	  ISNULL(@cbtValue, CbtValue)  
			,CbtHiThreshold			= 	  ISNULL(@cbtHiThreshold, CbtHiThreshold)  
			,CbtLoThreshold			= 	  ISNULL(@cbtLoThreshold, CbtLoThreshold)  
			,StatusId				= 	  ISNULL(@statusId, StatusId)  
			,ChangedBy				= 	  ISNULL(@changedBy, ChangedBy) 
			,DateChanged			= 	  ISNULL(@dateChanged, DateChanged)	
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
PRINT N'Update complete.';


GO
