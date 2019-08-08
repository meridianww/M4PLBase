SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Prashant Aggarwal        
-- Create date:               07/30/2019   
-- Description:               Update Partial Information For Vendor
-- =============================================
CREATE PROCEDURE [dbo].[UpdPartialVendor] @userId BIGINT
	,@roleId BIGINT
	,@entity NVARCHAR(100)
	,@id BIGINT
	,@vendERPId NVARCHAR(10) = NULL
	,@vendOrgId BIGINT = NULL
	,@vendItemNumber INT = NULL
	,@vendCode NVARCHAR(20) = NULL
	,@vendTitle NVARCHAR(50) = NULL
	,@vendWorkAddressId BIGINT = NULL
	,@vendBusinessAddressId BIGINT = NULL
	,@vendCorporateAddressId BIGINT = NULL
	,@vendContacts INT = NULL
	,@vendTypeId INT = NULL
	,@vendTypeCode NVARCHAR(100) = NULL
	,@vendWebPage NVARCHAR(100) = NULL
	,@statusId INT = NULL
	,@changedBy NVARCHAR(50) = NULL
	,@dateChanged DATETIME2(7) = NULL
	,@isFormView BIT = 0
AS
BEGIN TRY
	SET NOCOUNT ON;

	DECLARE @updatedItemNumber INT
		,@CompanyId BIGINT

	SELECT @CompanyId = Id
	FROM [dbo].[COMP000Master]
	WHERE [CompTableName] = @entity
		AND [CompPrimaryRecordId] = @Id

	EXEC [dbo].[ResetItemNumber] @userId
		,@id
		,@vendOrgId
		,@entity
		,@vendItemNumber
		,@statusId
		,NULL
		,NULL
		,@updatedItemNumber OUTPUT

	IF NOT EXISTS (
			SELECT Id
			FROM [dbo].[SYSTM000Ref_Options]
			WHERE SysOptionName = @vendTypeCode
			)
		AND ISNULL(@vendTypeId, 0) = 0
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
			50
			,'VendorType'
			,@vendTypeCode
			,@highestTypeCodeSortOrder
			,ISNULL(@statusId, 1)
			,@dateChanged
			,@changedBy
			)

		SET @vendTypeId = SCOPE_IDENTITY();
	END
	ELSE IF (
			(@vendTypeId > 0)
			AND (ISNULL(@vendTypeCode, '') <> '')
			)
	BEGIN
		UPDATE [dbo].[SYSTM000Ref_Options]
		SET SysOptionName = @vendTypeCode
		WHERE Id = @vendTypeId
	END

	UPDATE [dbo].[VEND000Master]
	SET VendERPId = @vendERPId
		,VendOrgId = ISNULL(@vendOrgId, VendOrgId)
		,VendItemNumber = ISNULL(@updatedItemNumber, VendItemNumber)
		,VendCode = ISNULL(@vendCode, VendCode)
		,VendTitle = @vendTitle
		,VendTypeId = @vendTypeId
		,VendWebPage = @vendWebPage
		,StatusId = ISNULL(@statusId, StatusId)
		,ChangedBy = @changedBy
		,DateChanged = @dateChanged
	WHERE Id = @id

	UPDATE [dbo].[COMP000Master]
	SET [CompOrgId] = @vendOrgId
		,[CompCode] = @vendCode
		,[CompTitle] = @vendTitle
		,[StatusId] = @StatusId
		,DateChanged = @dateChanged
		,ChangedBy = @changedBy
	WHERE ID = @CompanyId

	EXEC [dbo].[GetVendor] @userId
		,@roleId
		,@vendOrgId
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

