SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/25/2018      
-- Description:               Ins a cust dc locations Contact
-- Execution:                 EXEC [dbo].[InsCustDcLocationContact]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- Modified on:				  26th Apr 2019 (Parthiban M)
-- Modified Desc:			  Changes done for related to contact bridge implementation
-- =============================================  
CREATE PROCEDURE [dbo].[InsCustDcLocationContact] @userId BIGINT
	,@roleId BIGINT
	,@entity NVARCHAR(100)
	,@enteredBy NVARCHAR(50) = NULL
	,@dateEntered DATETIME2(7) = NULL
	,@conCodeId BIGINT
	,@conCustDcLocationId BIGINT = NULL
	,@conItemNumber INT = NULL
	,@conContactTitle NVARCHAR(50) = NULL
	,@conContactMSTRID BIGINT = NULL
	,@statusId INT = NULL
	,@conOrgId BIGINT
AS
BEGIN TRY
	SET NOCOUNT ON;

   DECLARE @updatedItemNumber INT      
  EXEC [dbo].[ResetItemNumber] @userId, 0, @conCustDcLocationId, @entity, @conItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT  

  DECLARE @conTableTypeId INT  
  SELECT @conTableTypeId = Id FROM [dbo].[SYSTM000Ref_Options] WHERE SysLookupCode = 'ContactType' AND SysOptionName = 'Consultant' AND StatusId = 1

  DECLARE @conTypeId INT
  SELECT @conTypeId = Id FROM [dbo].[SYSTM000Ref_Options] WHERE SysLookupCode = 'ContactType' AND SysOptionName = 'Customer' AND StatusId = 1

	DECLARE @currentId BIGINT;;

	INSERT INTO [dbo].[CONTC010Bridge] (
		[ConOrgId]
		,[ContactMSTRID]
		,[ConTableName]
		,[ConPrimaryRecordId]
		,[ConTableTypeId]
		,[ConTypeId]
		,[ConItemNumber]
		,[ConCodeId]
		,[ConTitle]
		,[StatusId]
		,[EnteredBy]
		,[DateEntered]
		)
	VALUES (
		 @conOrgId
		,@conContactMSTRID
		,@entity
		,@conCustDcLocationId
		,@conTableTypeId
		,@conTypeId
		,@updatedItemNumber
		,@conCodeId
		,@conContactTitle
		,@statusId
		,@enteredBy
		,@dateEntered
		)

	SET @currentId = SCOPE_IDENTITY();

	EXEC [dbo].[GetCustDcLocationContact] @userId
		,@roleId
		,@conOrgId
		,@currentId
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
