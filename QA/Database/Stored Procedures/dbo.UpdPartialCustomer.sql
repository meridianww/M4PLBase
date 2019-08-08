SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Prashant Aggarwal        
-- Create date:               07/30/2019   
-- Description:               Update Partial Information For Customer
-- =============================================
CREATE PROCEDURE [dbo].[UpdPartialCustomer] (
	@userId BIGINT
	,@roleId BIGINT
	,@entity NVARCHAR(100)
	,@id BIGINT
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
	,@isFormView BIT = 0
	)
AS
BEGIN TRY
	SET NOCOUNT ON;

	DECLARE @updatedItemNumber INT
		,@CompanyId BIGINT

	EXEC [dbo].[ResetItemNumber] @userId
		,@id
		,@custOrgId
		,@entity
		,@custItemNumber
		,@statusId
		,NULL
		,NULL
		,@updatedItemNumber OUTPUT

	SELECT @CompanyId = Id
	FROM [dbo].[COMP000Master]
	WHERE [CompTableName] = @entity
		AND [CompPrimaryRecordId] = @Id

	IF NOT EXISTS (
			SELECT Id
			FROM [dbo].[SYSTM000Ref_Options]
			WHERE SysOptionName = @custTypeCode
			)
		AND ISNULL(@custTypeId, 0) = 0
	BEGIN
		DECLARE @highestTypeCodeSortOrder INT;

		SELECT @highestTypeCodeSortOrder = MAX(SysSortOrder)
		FROM [dbo].[SYSTM000Ref_Options]
		WHERE SysLookupId = 8;

		SET @highestTypeCodeSortOrder = ISNULL(@highestTypeCodeSortOrder, 0) + 1;

		INSERT INTO [dbo].[SYSTM000Ref_Options] (
			SysLookupId
			,SysLookupCode
			,SysOptionName
			,SysSortOrder
			,StatusId
			,DateEntered
			,EnteredBy
			)
		VALUES (
			8
			,'CustomerType'
			,@custTypeCode
			,@highestTypeCodeSortOrder
			,ISNULL(@statusId, 1)
			,@dateChanged
			,@changedBy
			)

		SET @custTypeId = SCOPE_IDENTITY();
	END
	ELSE IF (
			(@custTypeId > 0)
			AND (ISNULL(@custTypeCode, '') <> '')
			)
	BEGIN
		UPDATE [dbo].[SYSTM000Ref_Options]
		SET SysOptionName = @custTypeCode
		WHERE Id = @custTypeId
	END

	UPDATE [dbo].[CUST000Master]
	SET [CustERPId] = ISNULL(@custERPId, CustERPId)
		,[CustOrgId] = ISNULL(@custOrgId, CustOrgId)
		,[CustItemNumber] = ISNULL(@updatedItemNumber, CustItemNumber)
		,[CustCode] = ISNULL(@custCode, CustCode)
		,[CustTitle] = ISNULL(@custTitle, CustTitle)
		,[CustTypeId] = ISNULL(@custTypeId, CustTypeId)
		,[CustWebPage] = ISNULL(@custWebPage, CustWebPage)
		,[StatusId] = ISNULL(@statusId, StatusId)
		,[ChangedBy] = ISNULL(@changedBy, ChangedBy)
		,[DateChanged] = ISNULL(@dateChanged, DateChanged)
	WHERE [Id] = @id

	UPDATE [dbo].[COMP000Master]
	SET [CompOrgId] = @custOrgId
		,[CompCode] = @custCode
		,[CompTitle] = @custTitle
		,[StatusId] = @StatusId
		,DateChanged = @dateChanged
		,ChangedBy = @changedBy
	WHERE ID = @CompanyId

	EXEC [dbo].[GetCustomer] @userId
		,@roleId
		,@custOrgId
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

