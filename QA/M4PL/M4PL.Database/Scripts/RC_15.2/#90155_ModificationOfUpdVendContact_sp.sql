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
-- Modified on:				  26th Apr 2019 (Parthiban M)
-- Modified Desc:			  Changes done for related to contact bridge implementation
-- ============================================= 
ALTER PROCEDURE  [dbo].[UpdVendContact]		  
	@userId BIGINT
	,@roleId BIGINT 
	,@orgId BIGINT 
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
	  
	 UPDATE [dbo].[CONTC010Bridge]
	    SET ConPrimaryRecordId    = CASE WHEN (@isFormView = 1) THEN @vendVendorId WHEN ((@isFormView = 0) AND (@vendVendorId=-100)) THEN NULL ELSE ISNULL(@vendVendorId, ConPrimaryRecordId) END
           ,ConItemNumber	  = CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, ConItemNumber) END
           ,ConCode	  = CASE WHEN (@isFormView = 1) THEN @vendContactCode WHEN ((@isFormView = 0) AND (@vendContactCode='#M4PL#')) THEN NULL ELSE ISNULL(@vendContactCode, ConCode) END
           ,ConTitle  = CASE WHEN (@isFormView = 1) THEN @vendContactTitle WHEN ((@isFormView = 0) AND (@vendContactTitle='#M4PL#')) THEN NULL ELSE ISNULL(@vendContactTitle, ConTitle) END
           ,ContactMSTRID = CASE WHEN (@isFormView = 1) THEN @vendContactMSTRId WHEN ((@isFormView = 0) AND (@vendContactMSTRId=-100)) THEN NULL ELSE ISNULL(@vendContactMSTRId, ContactMSTRID) END
		   ,StatusId		  = CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
           ,ChangedBy		  = @changedBy 
           ,DateChanged		  = @dateChanged 	
      WHERE Id = @id	
	  
		IF(ISNULL(@statusId, 1) <> -100)
		BEGIN
			IF NOT EXISTS(SELECT TOP 1 1 FROM [dbo].[fnGetUserStatuses](@userId) WHERE StatusId = @statusId)
			BEGIN
				EXEC [dbo].[UpdateColumnCount] @tableName = 'VEND000Master', @columnName = 'VendContacts',  @rowId = @vendVendorId, @countToChange = -1
			END
		END  


		EXEC [dbo].[GetVendContact] @userId, @roleId, @orgId ,@id
END TRY    
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH