SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a customer 
-- Execution:                 EXEC [dbo].[InsCustomer]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified on:               07/10/2019( Prashant Aggarwal - Added parameters for Business, Corporate and Work Addresses and Call the Address Update Stored Procedure To Update The Record.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE [dbo].[InsCustomer] (
	@userId BIGINT
	,@roleId BIGINT
	,@entity NVARCHAR(100)
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
	,@enteredBy NVARCHAR(50) = NULL
	,@dateEntered DATETIME2(7) = NULL
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

	DECLARE @updatedItemNumber INT

	EXEC [dbo].[ResetItemNumber] @userId
		,0
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
		AND ISNULL(@custTypeCode, '') <> ''
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
			,@dateEntered
			,@enteredBy
			)

		SET @custTypeId = SCOPE_IDENTITY();
	END
	ELSE IF (
			(ISNULL(@custTypeId, 0) > 0)
			AND (ISNULL(@custTypeCode, '') <> '')
			)
	BEGIN
		UPDATE [dbo].[SYSTM000Ref_Options]
		SET SysOptionName = @custTypeCode
		WHERE Id = @custTypeId
	END

	IF (ISNULL(@custWorkAddressId, 0) = 0)
		SET @custWorkAddressId = NULL;

	IF (ISNULL(@custBusinessAddressId, 0) = 0)
		SET @custBusinessAddressId = NULL;

	IF (ISNULL(@custCorporateAddressId, 0) = 0)
		SET @custCorporateAddressId = NULL;

	DECLARE @currentId BIGINT
		,@CompanyId BIGINT

	INSERT INTO [dbo].[CUST000Master] (
		[CustERPId]
		,[CustOrgId]
		,[CustItemNumber]
		,[CustCode]
		,[CustTitle]
		,[CustWorkAddressId]
		,[CustBusinessAddressId]
		,[CustCorporateAddressId]
		,[CustContacts]
		,[CustTypeId]
		,[CustWebPage]
		,[StatusId]
		,[EnteredBy]
		,[DateEntered]
		)
	VALUES (
		@custERPId
		,@custOrgId
		,@updatedItemNumber -- @custItemNumber 
		,@custCode
		,@custTitle
		,@custWorkAddressId
		,@custBusinessAddressId
		,@custCorporateAddressId
		,@custContacts
		,@custTypeId
		,@custWebPage
		,@statusId
		,@enteredBy
		,@dateEntered
		)

	SET @currentId = SCOPE_IDENTITY();

	INSERT INTO [dbo].[COMP000Master] (
		[CompOrgId]
		,[CompTableName]
		,[CompPrimaryRecordId]
		,[CompCode]
		,[CompTitle]
		,[StatusId]
		,[DateEntered]
		,[EnteredBy]
		)
	VALUES (
		@custOrgId
		,@entity
		,@currentId
		,@custCode
		,@custTitle
		,@StatusId
		,@dateEntered
		,@enteredBy
		)

	SET @CompanyId = SCOPE_IDENTITY();

	EXEC [dbo].[UpdateCOMPADD000Master] @addCompId = @CompanyId
		,@changedBy = NULL
		,@dateChanged = NULL
		,@dateEntered = @dateEntered
		,@enteredBy = @enteredBy
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