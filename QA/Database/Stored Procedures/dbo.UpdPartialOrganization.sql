SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Prashant Aggarwal        
-- Create date:               07/30/2019   
-- Description:               Update Partial Information For Organization
-- =============================================
CREATE PROCEDURE [dbo].[UpdPartialOrganization] (
	@userId BIGINT
	,@roleId BIGINT
	,@entity NVARCHAR(100)
	,@id BIGINT
	,@orgCode NVARCHAR(25) = NULL
	,@orgTitle NVARCHAR(50) = NULL
	,@orgGroupId INT = NULL
	,@orgSortOrder INT = NULL
	,@statusId INT = NULL
	,@dateChanged DATETIME2(7) = NULL
	,@changedBy NVARCHAR(50) = NULL
	,@orgContactId BIGINT = NULL
	,@isFormView BIT = 0
	)
AS
BEGIN TRY
	SET NOCOUNT ON;

	DECLARE @updatedItemNumber INT
		,@CompanyId BIGINT
	DECLARE @where NVARCHAR(MAX) = NULL
	DECLARE @isSysAdmin BIT

	SELECT @isSysAdmin = IsSysAdmin
	FROM SYSTM000OpnSezMe
	WHERE id = @userId;

	SELECT @CompanyId = Id
	FROM [dbo].[COMP000Master]
	WHERE [CompTableName] = @entity
		AND [CompPrimaryRecordId] = @Id

	IF @isSysAdmin = 1
	BEGIN
		EXEC [dbo].[ResetItemNumber] @userId
			,@id
			,NULL
			,@entity
			,@orgSortOrder
			,@statusId
			,NULL
			,NULL
			,@updatedItemNumber OUTPUT
	END

	UPDATE [dbo].[ORGAN000Master]
	SET OrgCode = ISNULL(@orgCode, OrgCode)
		,OrgTitle = ISNULL(@orgTitle, OrgTitle)
		,OrgGroupId = ISNULL(@orgGroupId, OrgGroupId)
		,OrgSortOrder = CASE 
			WHEN @isSysAdmin = 1
				THEN ISNULL(@updatedItemNumber, OrgSortOrder)
			ELSE OrgSortOrder
			END
		,StatusId = ISNULL(@statusId, StatusId)
		,OrgContactId = ISNULL(@orgContactId, OrgContactId)
		,DateChanged = @dateChanged
		,ChangedBy = @changedBy
	WHERE Id = @id

	UPDATE [dbo].[COMP000Master]
	SET [CompOrgId] = @id
		,[CompCode] = @orgCode
		,[CompTitle] = @orgTitle
		,[StatusId] = @StatusId
		,DateChanged = @dateChanged
		,ChangedBy = @changedBy
	WHERE ID = @CompanyId

	EXEC [dbo].[GetOrganization] @userId
		,@roleId
		,@id
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

