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
-- Modified on:				  14th Jun 2019 (Nikhil) 
-- Modified Desc:			  Add @conCodeId for contact bridge table
-- =============================================
CREATE PROCEDURE [dbo].[UpdCustDcLocationContact] @userId BIGINT
	,@roleId BIGINT
	,@entity NVARCHAR(100)
	,@id BIGINT
	,@changedBy NVARCHAR(50) = NULL
	,@dateChanged DATETIME2(7) = NULL
	,@conCodeId BIGINT
	,@conCustDcLocationId BIGINT = NULL
	,@conItemNumber INT = NULL
	,@conContactTitle NVARCHAR(50) = NULL
	,@conContactMSTRID BIGINT = NULL
	,@statusId INT = NULL
	,@conOrgId BIGINT
	,@isFormView BIT = 0
AS
BEGIN TRY
	SET NOCOUNT ON;

	DECLARE @updatedItemNumber INT

	EXEC [dbo].[ResetItemNumber] @userId
		,0
		,@conCustDcLocationId
		,@entity
		,@conItemNumber
		,@statusId
		,NULL
		,NULL
		,@updatedItemNumber OUTPUT

	DECLARE @conTableTypeId INT

	SELECT @conTableTypeId = Id
	FROM [dbo].[SYSTM000Ref_Options]
	WHERE SysLookupCode = 'ContactType'
		AND SysOptionName = 'Consultant'
		AND StatusId = 1

	--Then Update Cust Dc Location
	UPDATE [dbo].[CONTC010Bridge]
	SET [ConPrimaryRecordId] = ISNULL(@conCustDcLocationId, ConPrimaryRecordId)
		,[ConItemNumber] = @updatedItemNumber
		,[ConCodeId] = @conCodeId
		,[ConTitle] = @conContactTitle
		,[ConTableTypeId] = @conTableTypeId
		,[StatusId] = ISNULL(@statusId, StatusId)
		,[ContactMSTRID] = @conContactMSTRID
		,[ChangedBy] = @changedBy
		,[DateChanged] = @dateChanged
	WHERE [Id] = @id

	EXEC [dbo].[GetCustDcLocationContact] @userId
		,@roleId
		,@conOrgId
		,@id
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
