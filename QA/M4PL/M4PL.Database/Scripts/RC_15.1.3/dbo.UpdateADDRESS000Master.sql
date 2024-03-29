SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 7/9/2019
-- Description:	Update Customer Address Information
-- =============================================
CREATE PROCEDURE [dbo].[UpdateADDRESS000Master] (
	@entity NVARCHAR(100)
	,@id BIGINT
	,@custOrgId BIGINT = NULL
	,@custCode NVARCHAR(20) = NULL
	,@custTitle NVARCHAR(50) = NULL
	,@custWorkAddressId BIGINT = NULL
	,@custBusinessAddressId BIGINT = NULL
	,@custCorporateAddressId BIGINT = NULL
	,@statusId INT = NULL
	,@changedBy NVARCHAR(50) = NULL
	,@dateChanged DATETIME2(7) = NULL
	,@dateEntered DATETIME2(7) = NULL
	,@enteredBy NVARCHAR(50) = NULL
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
BEGIN
	SET NOCOUNT ON;

	DECLARE @BusinessAddressType INT
		,@CorporateAddressType INT
		,@WorkAddressType INT

	SELECT @BusinessAddressType = ID
	FROM [dbo].[SYSTM000Ref_Options]
	WHERE SysLookupCode = 'AddressType'
		AND SysOptionName = 'Business'

	SELECT @CorporateAddressType = ID
	FROM [dbo].[SYSTM000Ref_Options]
	WHERE SysLookupCode = 'AddressType'
		AND SysOptionName = 'Corporate'

	SELECT @WorkAddressType = ID
	FROM [dbo].[SYSTM000Ref_Options]
	WHERE SysLookupCode = 'AddressType'
		AND SysOptionName = 'Work'

	IF NOT EXISTS (
			SELECT 1
			FROM [dbo].[ADDRESS000Master]
			WHERE [AddTypeId] = @BusinessAddressType
				AND [AddPrimaryRecordId] = @id
				AND [AddTableName] = @entity
			)
	BEGIN
		INSERT INTO [dbo].[ADDRESS000Master] (
			[AddOrgId]
			,[AddTableName]
			,[AddPrimaryRecordId]
			,[AddPrimaryContactId]
			,[AddItemNumber]
			,[AddCode]
			,[AddTitle]
			,[StatusId]
			,[Address1]
			,[Address2]
			,[City]
			,[StateId]
			,[ZipPostal]
			,[CountryId]
			,[AddTypeId]
			,[DateEntered]
			,[EnteredBy]
			)
		VALUES (
			@custOrgId
			,@entity
			,@id
			,@custBusinessAddressId
			,2
			,@custCode
			,@custTitle
			,@statusId
			,@BusinessAddress1
			,@BusinessAddress2
			,@BusinessCity
			,@BusinessStateId
			,@BusinessZipPostal
			,@BusinessCountryId
			,@BusinessAddressType
			,ISNULL(@dateEntered, @dateChanged)
			,ISNULL(@enteredBy, @changedBy)
			)
	END
	ELSE
	BEGIN
		UPDATE dbo.ADDRESS000Master
		SET AddOrgId = @custOrgId
			,AddTableName = @entity
			,AddPrimaryRecordId = @id
			,AddPrimaryContactId = @custBusinessAddressId
			,AddItemNumber = 2
			,AddCode = @custCode
			,AddTitle = @custTitle
			,StatusId = @statusId
			,Address1 = @BusinessAddress1
			,Address2 = @BusinessAddress2
			,City = @BusinessCity
			,StateId = @BusinessStateId
			,ZipPostal = @BusinessZipPostal
			,CountryId = @BusinessCountryId
			,DateChanged = @dateChanged
			,ChangedBy = @changedBy
		WHERE [AddTypeId] = @BusinessAddressType
			AND [AddPrimaryRecordId] = @id
			AND [AddTableName] = @entity
	END

	IF NOT EXISTS (
			SELECT 1
			FROM [dbo].[ADDRESS000Master]
			WHERE [AddTypeId] = @CorporateAddressType
				AND [AddPrimaryRecordId] = @id
				AND [AddTableName] = @entity
			)
	BEGIN
		INSERT INTO [dbo].[ADDRESS000Master] (
			[AddOrgId]
			,[AddTableName]
			,[AddPrimaryRecordId]
			,[AddPrimaryContactId]
			,[AddItemNumber]
			,[AddCode]
			,[AddTitle]
			,[StatusId]
			,[Address1]
			,[Address2]
			,[City]
			,[StateId]
			,[ZipPostal]
			,[CountryId]
			,[AddTypeId]
			,[DateEntered]
			,[EnteredBy]
			)
		VALUES (
			@custOrgId
			,@entity
			,@id
			,@custCorporateAddressId
			,1
			,@custCode
			,@custTitle
			,@statusId
			,@CorporateAddress1
			,@CorporateAddress2
			,@CorporateCity
			,@CorporateStateId
			,@CorporateZipPostal
			,@CorporateCountryId
			,@CorporateAddressType
			,ISNULL(@dateEntered, @dateChanged)
			,ISNULL(@enteredBy, @changedBy)
			)
	END
	ELSE
	BEGIN
		UPDATE dbo.ADDRESS000Master
		SET AddOrgId = @custOrgId
			,AddTableName = @entity
			,AddPrimaryRecordId = @id
			,AddPrimaryContactId = @custCorporateAddressId
			,AddItemNumber = 1
			,AddCode = @custCode
			,AddTitle = @custTitle
			,StatusId = @statusId
			,Address1 = @CorporateAddress1
			,Address2 = @CorporateAddress2
			,City = @CorporateCity
			,StateId = @CorporateStateId
			,ZipPostal = @CorporateZipPostal
			,CountryId = @CorporateCountryId
			,DateChanged = @dateChanged
			,ChangedBy = @changedBy
		WHERE [AddTypeId] = @CorporateAddressType
			AND [AddPrimaryRecordId] = @id
			AND [AddTableName] = @entity
	END

	IF NOT EXISTS (
			SELECT 1
			FROM [dbo].[ADDRESS000Master]
			WHERE [AddTypeId] = @WorkAddressType
				AND [AddPrimaryRecordId] = @id
				AND [AddTableName] = @entity
			)
	BEGIN
		INSERT INTO [dbo].[ADDRESS000Master] (
			[AddOrgId]
			,[AddTableName]
			,[AddPrimaryRecordId]
			,[AddPrimaryContactId]
			,[AddItemNumber]
			,[AddCode]
			,[AddTitle]
			,[StatusId]
			,[Address1]
			,[Address2]
			,[City]
			,[StateId]
			,[ZipPostal]
			,[CountryId]
			,[AddTypeId]
			,[DateEntered]
			,[EnteredBy]
			)
		VALUES (
			@custOrgId
			,@entity
			,@id
			,@custWorkAddressId
			,3
			,@custCode
			,@custTitle
			,@statusId
			,@WorkAddress1
			,@WorkAddress2
			,@WorkCity
			,@WorkStateId
			,@WorkZipPostal
			,@WorkCountryId
			,@WorkAddressType
			,ISNULL(@dateEntered, @dateChanged)
			,ISNULL(@enteredBy, @changedBy)
			)
	END
	ELSE
	BEGIN
		UPDATE dbo.ADDRESS000Master
		SET AddOrgId = @custOrgId
			,AddTableName = @entity
			,AddPrimaryRecordId = @id
			,AddPrimaryContactId = @custWorkAddressId
			,AddItemNumber = 3
			,AddCode = @custCode
			,AddTitle = @custTitle
			,StatusId = @statusId
			,Address1 = @WorkAddress1
			,Address2 = @WorkAddress2
			,City = @WorkCity
			,StateId = @WorkStateId
			,ZipPostal = @WorkZipPostal
			,CountryId = @WorkCountryId
			,DateChanged = @dateChanged
			,ChangedBy = @changedBy
		WHERE [AddTypeId] = @WorkAddressType
			AND [AddPrimaryRecordId] = @id
			AND [AddTableName] = @entity
	END
END
GO
