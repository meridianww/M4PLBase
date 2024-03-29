SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/25/2018     
-- Description:               Ins a vend dc location Contact
-- Execution:                 EXEC [dbo].[InsVendDcLocationContact]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId   and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- Modified on:				  04/26/2019(Nikhil)   
-- Modified Desc:			  Removed comments and Updated old vendorDClocationcontact table references with new contact bridge table
-- Modified on:				  6th Jun 2019 (Kirty)
-- Modified Desc:			  Removed unused parameters
-- Modified on:				  11 Jun 2019 (Kirty)
-- Modified Desc:			  Added conCodeId
-- =============================================  
CREATE PROCEDURE  [dbo].[InsVendDcLocationContact]		  
	 @userId BIGINT
	,@roleId BIGINT
	,@entity NVARCHAR(100)
	,@enteredBy NVARCHAR(50) = NULL
	,@dateEntered DATETIME2(7) = NULL
	,@conCodeId BIGINT
	,@conVendDcLocationId BIGINT = NULL
	,@conItemNumber INT = NULL
	,@conContactTitle NVARCHAR(50) = NULL
	,@conContactMSTRID BIGINT = NULL
	,@statusId INT = NULL
	,@conOrgId BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  DECLARE @updatedItemNumber INT      
  EXEC [dbo].[ResetItemNumber] @userId, 0, @conVendDcLocationId, @entity, @conItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT  

  DECLARE @conTableTypeId INT  
  SELECT @conTableTypeId = Id FROM [dbo].[SYSTM000Ref_Options] WHERE SysLookupCode = 'ContactType' AND SysOptionName = 'Consultant' AND StatusId = 1

  DECLARE @conTypeId INT
  SELECT @conTypeId = Id FROM [dbo].[SYSTM000Ref_Options] WHERE SysLookupCode = 'ContactType' AND SysOptionName = 'Vendor' AND StatusId = 1
 DECLARE @currentId BIGINT;

   INSERT INTO [dbo].[CONTC010Bridge]
          (  [ContactMSTRID]
			,[ConOrgId]
			,[ConTableName]
			,[ConPrimaryRecordId]
			,[ConItemNumber]
			,[ConCodeId]
			,[ConTitle]
			,[ConTypeId]
			,[StatusId]
			,[ConTableTypeId]       
			,[EnteredBy]
			,[DateEntered]
			)
     VALUES
				(@conContactMSTRID
				,@conOrgId
				,@entity
				,@conVendDcLocationId
				,@updatedItemNumber 
				,@conCodeId
				,@conContactTitle
				,@conTypeId
				,@statusId  
				,@conTableTypeId 
				,@enteredBy 
				,@dateEntered)

	SET @currentId = SCOPE_IDENTITY();
	EXEC [dbo].[GetVendDcLocationContact] @userId, @roleId, @conOrgId ,@currentId 
	
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
