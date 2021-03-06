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

 SELECT 
 @recordId=Id,
 @custItemNumber=ISNULL(@custItemNumber, ConItemNumber) 
 FROM [dbo].[CONTC010Bridge] WHERE Id = @id

 IF(@recordId=@id)
 BEGIN
   
   UPDATE [dbo].[CONTC010Bridge]
	    SET ConPrimaryRecordId    = CASE WHEN (@isFormView = 1) THEN @custCustomerId WHEN ((@isFormView = 0) AND (@custCustomerId=-100)) THEN NULL ELSE ISNULL(@custCustomerId, ConPrimaryRecordId) END
           ,ConItemNumber	  = CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, ConItemNumber) END
           ,ConCodeId	  = CASE WHEN (@isFormView = 1) THEN @custContactCodeId WHEN ((@isFormView = 0) AND (@custContactCodeId=-100)) THEN NULL ELSE ISNULL(@custContactCodeId, ConCodeId) END
           ,ConTitle  = CASE WHEN (@isFormView = 1) THEN @custContactTitle WHEN ((@isFormView = 0) AND (@custContactTitle='#M4PL#')) THEN NULL ELSE ISNULL(@custContactTitle, ConTitle) END
           ,ContactMSTRID = CASE WHEN (@isFormView = 1) THEN @custContactMSTRId WHEN ((@isFormView = 0) AND (@custContactMSTRId=-100)) THEN NULL ELSE ISNULL(@custContactMSTRId, ContactMSTRID) END
		   ,StatusId		  = CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
           ,ChangedBy		  = @changedBy 
           ,DateChanged		  = @dateChanged 	
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
