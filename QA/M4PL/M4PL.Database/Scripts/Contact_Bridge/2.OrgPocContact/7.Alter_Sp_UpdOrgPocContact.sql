USE [M4PL_Test]
GO
/****** Object:  StoredProcedure [dbo].[UpdOrgPocContact]    Script Date: 5/9/2019 5:11:31 PM ******/
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
-- Modified on:				  04/26/2019(Nikhil)   
-- Modified Desc:			  Removed comments and Updated old orgPocContact table references with new contact bridge table
-- =============================================
ALTER PROCEDURE  [dbo].[UpdOrgPocContact] 	  
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id BIGINT 
	,@orgId BIGINT = NULL
	,@contactId BIGINT = NULL
	,@pocCodeId BIGINT = NULL
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
  If (ISNULL(@id,0)!=0)
  BEGIN

     UPDATE [dbo].[CONTC010Bridge]
			SET  ConPrimaryRecordId    = CASE WHEN (@isFormView = 1) THEN @orgId WHEN ((@isFormView = 0) AND (@orgId=-100)) THEN NULL ELSE ISNULL(@orgId, ConPrimaryRecordId) END
				,ConOrgId 		    = CASE WHEN (@isFormView = 1) THEN @orgId WHEN ((@isFormView = 0) AND (@orgId=-100)) THEN NULL ELSE ISNULL(@orgId, ConOrgId) END
				,ConItemNumber	  = CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, ConItemNumber) END
				,ConCodeId	  = CASE WHEN (@isFormView = 1) THEN @pocCodeId WHEN ((@isFormView = 0) AND (@pocCodeId=-100)) THEN NULL ELSE ISNULL(@pocCodeId, ConCodeId) END
				,ConTitle  = CASE WHEN (@isFormView = 1) THEN @pocTitle WHEN ((@isFormView = 0) AND (@pocTitle='#M4PL#')) THEN NULL ELSE ISNULL(@pocTitle, ConTitle) END
				,ContactMSTRID = CASE WHEN (@isFormView = 1) THEN @contactId WHEN ((@isFormView = 0) AND (@contactId=-100)) THEN NULL ELSE ISNULL(@contactId, ContactMSTRID) END
				,ConTableTypeId = CASE WHEN (@isFormView = 1) THEN @pocTypeId WHEN ((@isFormView = 0) AND (@pocTypeId=-100)) THEN NULL ELSE ISNULL(@pocTypeId, @pocTypeId) END
				,ConIsDefault 	    = ISNULL(@pocDefault, ConIsDefault)
				,StatusId		  = CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
				,ChangedBy		  = @changedBy 
				,DateChanged		  = @dateChanged 	
      WHERE Id = @id
	  END
   EXEC [dbo].[GetOrgPocContact] @userId, @roleId, @orgId, @id
 

	END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
