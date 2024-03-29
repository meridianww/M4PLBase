SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a organization
-- Execution:                 EXEC [dbo].[InsOrganization]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================  
ALTER PROCEDURE [dbo].[InsOrganization] (
	@userId BIGINT
	,@roleId BIGINT
	,@entity NVARCHAR(100)
	,@orgCode NVARCHAR(25) = NULL
	,@orgTitle NVARCHAR(50) = NULL
	,@orgWorkAddressId BIGINT = NULL
	,@orgBusinessAddressId BIGINT = NULL
	,@orgCorporateAddressId BIGINT = NULL
	,@orgGroupId INT = NULL
	,@orgSortOrder INT = NULL
	,@statusId INT = NULL
	,@dateEntered DATETIME2(7) = NULL
	,@enteredBy NVARCHAR(50) = NULL
	,@orgContactId BIGINT = NULL
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
	DECLARE @where NVARCHAR(MAX) = NULL

	EXEC [dbo].[ResetItemNumber] @userId
		,0
		,NULL
		,@entity
		,@orgSortOrder
		,@statusId
		,NULL
		,NULL
		,@updatedItemNumber OUTPUT

	DECLARE @currentId BIGINT
		,@CompanyId BIGINT;

	INSERT INTO [dbo].[ORGAN000Master] (
		[OrgCode]
		,[OrgTitle]
		,[OrgGroupId]
		,[OrgSortOrder]
		,[StatusId]
		,[DateEntered]
		,[EnteredBy]
		,[OrgContactId]
		,OrgWorkAddressId
		,OrgBusinessAddressId
		,OrgCorporateAddressId
		)
	VALUES (
		@orgCode
		,@orgTitle
		,@orgGroupId
		,@updatedItemNumber
		,@statusId
		,@dateEntered
		,@enteredBy
		,@orgContactId
		,@orgWorkAddressId
		,@orgBusinessAddressId
		,@orgCorporateAddressId
		)

	SET @currentId = SCOPE_IDENTITY();

	-- Below to insert Ref Roles rows in Act Roles
	EXEC [dbo].[CopyRefRoles] @currentId
		,@enteredBy

	-- INSERT Dashboard
	INSERT INTO [dbo].[SYSTM000Ref_Dashboard] (
		[OrganizationId]
		,[DshMainModuleId]
		,[DshName]
		,[DshTemplate]
		,[DshDescription]
		,[DshIsDefault]
		,[StatusId]
		,[DateEntered]
		,[EnteredBy]
		,[DateChanged]
		,[ChangedBy]
		)
	SELECT @currentId
		,[DshMainModuleId]
		,[DshName]
		,[DshTemplate]
		,[DshDescription]
		,[DshIsDefault]
		,[StatusId]
		,[DateEntered]
		,[EnteredBy]
		,[DateChanged]
		,[ChangedBy]
	FROM [dbo].[SYSTM000Ref_Dashboard]
	WHERE OrganizationId = 0
		AND DshMainModuleId = 0

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
		@currentId
		,@entity
		,@currentId
		,@orgCode
		,@orgTitle
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

	-- Get Organization Data
	EXEC [dbo].[GetOrganization] @userId
		,@roleId
		,@currentId
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