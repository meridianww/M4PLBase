SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a Vender
-- Execution:                 EXEC [dbo].[InsVendor]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified on:               07/10/2019( Prashant Aggarwal - Added parameters for Business, Corporate and Work Addresses and Call the Address Update Stored Procedure To Update The Record.)  
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[InsVendor] @userId BIGINT
	,@roleId BIGINT
	,@entity NVARCHAR(100)
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
AS
BEGIN TRY
	SET NOCOUNT ON;

	DECLARE @updatedItemNumber INT

	EXEC [dbo].[ResetItemNumber] @userId
		,0
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
		AND ISNULL(@vendTypeCode, '') <> ''
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
			,@dateEntered
			,@enteredBy
			)

		SET @vendTypeId = SCOPE_IDENTITY();
	END
	ELSE IF (
			(ISNULL(@vendTypeId, 0) > 0)
			AND (ISNULL(@vendTypeCode, '') <> '')
			)
	BEGIN
		UPDATE [dbo].[SYSTM000Ref_Options]
		SET SysOptionName = @vendTypeCode
		WHERE Id = @vendTypeId
	END

	IF (ISNULL(@vendWorkAddressId, 0) = 0)
		SET @vendWorkAddressId = NULL;

	IF (ISNULL(@vendBusinessAddressId, 0) = 0)
		SET @vendBusinessAddressId = NULL;

	IF (ISNULL(@vendCorporateAddressId, 0) = 0)
		SET @vendCorporateAddressId = NULL;

	DECLARE @currentId BIGINT, @CompanyId BIGINT;

	INSERT INTO [dbo].[VEND000Master] (
		[VendERPId]
		,[VendOrgId]
		,[VendItemNumber]
		,[VendCode]
		,[VendTitle]
		,[VendWorkAddressId]
		,[VendBusinessAddressId]
		,[VendCorporateAddressId]
		,[VendContacts]
		,[VendTypeId]
		,[VendWebPage]
		,[StatusId]
		,[EnteredBy]
		,[DateEntered]
		)
	VALUES (
		@vendERPId
		,@vendOrgId
		,@updatedItemNumber
		,@vendCode
		,@vendTitle
		,@vendWorkAddressId
		,@vendBusinessAddressId
		,@vendCorporateAddressId
		,@vendContacts
		,@vendTypeId
		,@vendWebPage
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
		@vendOrgId
		,@entity
		,@currentId
		,@vendCode
		,@vendTitle
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

	EXEC [dbo].[GetVendor] @userId
		,@roleId
		,@vendOrgId
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