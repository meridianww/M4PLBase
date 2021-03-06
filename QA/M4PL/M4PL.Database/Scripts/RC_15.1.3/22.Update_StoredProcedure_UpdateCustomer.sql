SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/09/2018      
-- Description:               Update a customer
-- Execution:                 EXEC [dbo].[UpdCustomer]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified on:               07/10/2019( Prashant Aggarwal - Added parameters for Business, Corporate and Work Addresses and Call the Address Update Stored Procedure To Update The Record.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE [dbo].[UpdCustomer] (
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
	,@BusinessAddress1 NVARCHAR(255)
	,@BusinessAddress2 NVARCHAR(150)
	,@BusinessCity NVARCHAR(25)
	,@BusinessZipPostal NVARCHAR(20)
	,@BusinessStateId INT
	,@BusinessCountryId INT
	,@CorporateAddress1 NVARCHAR(255)
	,@CorporateAddress2 NVARCHAR(150)
	,@CorporateCity NVARCHAR(25)
	,@CorporateZipPostal NVARCHAR(20)
	,@CorporateStateId INT
	,@CorporateCountryId INT
	,@WorkAddress1 NVARCHAR(255)
	,@WorkAddress2 NVARCHAR(150)
	,@WorkCity NVARCHAR(25)
	,@WorkZipPostal NVARCHAR(20)
	,@WorkStateId INT
	,@WorkCountryId INT
	)
AS
BEGIN TRY
	SET NOCOUNT ON;

	DECLARE @updatedItemNumber INT, @CompanyId BIGINT
	Select @CompanyId = Id From [dbo].[COMP000Master] WHERE [CompTableName] = @entity AND [CompPrimaryRecordId] = @Id
	EXEC [dbo].[ResetItemNumber] @userId
		,@id
		,@custOrgId
		,@entity
		,@custItemNumber
		,@statusId
		,NULL
		,NULL
		,@updatedItemNumber OUTPUT

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
		,[CustWorkAddressId] = ISNULL(@custWorkAddressId, CustWorkAddressId)
		,[CustBusinessAddressId] = ISNULL(@custBusinessAddressId, CustBusinessAddressId)
		,[CustCorporateAddressId] = ISNULL(@custCorporateAddressId, CustCorporateAddressId)
		,[CustTypeId] = ISNULL(@custTypeId, CustTypeId)
		,[CustWebPage] = ISNULL(@custWebPage, CustWebPage)
		,[StatusId] = ISNULL(@statusId, StatusId)
		,[ChangedBy] = ISNULL(@changedBy, ChangedBy)
		,[DateChanged] = ISNULL(@dateChanged, DateChanged)
	WHERE [Id] = @id

	UPDATE [dbo].[COMP000Master]
		SET [CompOrgId] = ISNULL(@custOrgId, [CompOrgId])
			,[CompCode] = ISNULL(@custCode, [CompCode])
			,[CompTitle] =  ISNULL(@custTitle, [CompTitle])
			,[StatusId] = ISNULL(@statusId, StatusId)
			,DateChanged = ISNULL(@dateChanged, DateChanged)
			,ChangedBy = ISNULL(@changedBy, ChangedBy)
		WHERE ID = @CompanyId

	EXEC [dbo].[UpdateCOMPADD000Master] @addCompId = @CompanyId
		,@changedBy = @changedBy
		,@dateChanged = @dateChanged
		,@dateEntered = null
		,@enteredBy = null
		,@BusinessAddress1 = @BusinessAddress1
		,@BusinessAddress2 = @BusinessAddress2
		,@BusinessCity = @BusinessCity
		,@BusinessZipPostal = @BusinessZipPostal
		,@BusinessStateId = @BusinessStateId
		,@BusinessCountryId = @BusinessCountryId
		,@CorporateAddress1 = @CorporateAddress1
		,@CorporateAddress2 = @CorporateAddress2
		,@CorporateCity = @CorporateCity
		,@CorporateZipPostal = @CorporateZipPostal
		,@CorporateStateId = @CorporateStateId
		,@CorporateCountryId = @CorporateCountryId
		,@WorkAddress1 = @WorkAddress1
		,@WorkAddress2 = @WorkAddress2
		,@WorkCity = @WorkCity
		,@WorkZipPostal = @WorkZipPostal
		,@WorkStateId = @WorkStateId
		,@WorkCountryId = @WorkCountryId

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