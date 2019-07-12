SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 7/9/2019
-- Description:	Update Company Address Information
-- =============================================
CREATE PROCEDURE [dbo].[UpdateCOMPADD000Master] (
	 @addCompId BIGINT = NULL
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
			FROM [dbo].[COMPADD000Master]
			WHERE [AddTypeId] = @BusinessAddressType
				AND [AddCompId] = @addCompId
			)
	BEGIN
INSERT INTO [dbo].[COMPADD000Master]
           ([AddCompId]
           ,[AddItemNumber]
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
			 @addCompId
			,2
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

UPDATE [dbo].[COMPADD000Master]
   SET [AddItemNumber] = 2
      ,[Address1] = @BusinessAddress1
      ,[Address2] = @BusinessAddress2
      ,[City] = @BusinessCity
      ,[StateId] = @BusinessStateId
      ,[ZipPostal] = @BusinessZipPostal
      ,[CountryId] = @BusinessCountryId
      ,DateChanged = @dateChanged
	  ,ChangedBy = @changedBy
WHERE [AddTypeId] = @BusinessAddressType
			AND [AddCompId] = @addCompId
	END

	IF NOT EXISTS (
			SELECT 1
			FROM [dbo].[COMPADD000Master]
			WHERE [AddTypeId] = @CorporateAddressType
				AND [AddCompId] = @addCompId
			)
	BEGIN
		INSERT INTO [dbo].[COMPADD000Master]
           ([AddCompId]
           ,[AddItemNumber]
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
			 @addCompId
			,1
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

UPDATE [dbo].[COMPADD000Master]
   SET [AddItemNumber] = 1
      ,Address1 = @CorporateAddress1
			,Address2 = @CorporateAddress2
			,City = @CorporateCity
			,StateId = @CorporateStateId
			,ZipPostal = @CorporateZipPostal
			,CountryId = @CorporateCountryId
      ,DateChanged = @dateChanged
	  ,ChangedBy = @changedBy
WHERE [AddTypeId] = @CorporateAddressType
			AND [AddCompId] = @addCompId
	END

	IF NOT EXISTS (
			SELECT 1
			FROM [dbo].[COMPADD000Master]
			WHERE [AddTypeId] = @WorkAddressType
				AND [AddCompId] = @addCompId
			)
	BEGIN
		INSERT INTO [dbo].[COMPADD000Master]
           ([AddCompId]
           ,[AddItemNumber]
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
			 @addCompId
			,3
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

UPDATE [dbo].[COMPADD000Master]
   SET [AddItemNumber] = 1
      ,Address1 = @WorkAddress1
			,Address2 = @WorkAddress2
			,City = @WorkCity
			,StateId = @WorkStateId
			,ZipPostal = @WorkZipPostal
			,CountryId = @WorkCountryId
      ,DateChanged = @dateChanged
	  ,ChangedBy = @changedBy
WHERE [AddTypeId] = @CorporateAddressType
			AND [AddCompId] = @addCompId
	END
END
GO
