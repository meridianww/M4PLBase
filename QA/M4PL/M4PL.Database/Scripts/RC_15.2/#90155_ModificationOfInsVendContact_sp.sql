SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a Vend Contact
-- Execution:                 EXEC [dbo].[InsVendContact]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- Modified on:				  26th Apr 2019 (Parthiban M)
-- Modified Desc:			  Changes done for related to contact bridge implementation
-- =============================================
ALTER PROCEDURE  [dbo].[InsVendContact]
	@userId BIGINT
	,@roleId BIGINT 
	,@orgId BIGINT
	,@entity NVARCHAR(100)
	,@vendVendorId BIGINT = NULL
	,@vendItemNumber INT  = NULL
	,@vendContactCode NVARCHAR(20) = NULL 
	,@vendContactTitle NVARCHAR(50) = NULL 
	,@vendContactMSTRId BIGINT = NULL 
	,@statusId INT = NULL 
	,@enteredBy NVARCHAR(50) = NULL 
	,@dateEntered DATETIME2(7) = NULL 
AS
BEGIN TRY                
 SET NOCOUNT ON;  
  DECLARE @updatedItemNumber INT      
  EXEC [dbo].[ResetItemNumber] @userId, 0, @vendVendorId, @entity, @vendItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT 
  
 DECLARE @currentId BIGINT;

	INSERT INTO [dbo].[CONTC010Bridge]
           ([ConOrgId]
		   ,[ContactMSTRID]
           ,[ConTableName]
           ,[ConPrimaryRecordId]
           ,[ConTableTypeId]
           ,[ConTypeId]
           ,[ConItemNumber]
           ,[ConCode]
           ,[ConTitle]
		   ,[StatusId]
           ,[EnteredBy]
           ,[DateEntered])
     VALUES
           (@orgId
		   ,@vendContactMSTRId
		   ,@entity
		   ,@vendVendorId
		   ,183
		   ,63
		   ,@updatedItemNumber
		   ,@vendContactCode
		   ,@vendContactTitle
		   ,@statusId
		   ,@enteredBy
		   ,@dateEntered 
		   )
		   SET @currentId = SCOPE_IDENTITY();
		
		IF EXISTS(SELECT TOP 1 1 FROM [dbo].[fnGetUserStatuses](@userId) WHERE StatusId = @statusId)
		BEGIN
			EXEC [dbo].[UpdateColumnCount] @tableName = 'VEND000Master', @columnName = 'VendContacts',  @rowId = @vendVendorId, @countToChange = 1
		END

		EXEC [dbo].[GetVendContact] @userId, @roleId, @orgId ,@currentId
END TRY    
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH



/***** Object:  StoredProcedure [dbo].[UpdVendContact]    Script Date: 8/16/2017 1:30:20 PM *****/
SET ANSI_NULLS ON