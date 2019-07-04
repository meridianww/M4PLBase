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
-- Modified on:				  26th Apr 2019 (Parthiban M)
-- Modified Desc:			  Changes done for related to contact bridge implementation
-- Modified on:				  6th Jun 2019 (Kirty)
-- Modified Desc:			  Removed unused parameters
-- =============================================
CREATE PROCEDURE  [dbo].[UpdCustDcLocationContact]		  
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
