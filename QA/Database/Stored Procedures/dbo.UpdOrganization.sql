SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan   
-- Create date:               08/16/2018      
-- Description:               Upd a organization
-- Execution:                 EXEC [dbo].[UpdOrganization]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- Modified on:               05/02/2019(Nikhil) 
-- Modified Desc:			  Removed #M4PL# and -100  implementation for Update Query
-- =============================================
CREATE PROCEDURE [dbo].[UpdOrganization] (
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
	,@orgWorkAddressId BIGINT = NULL
	,@orgBusinessAddressId BIGINT = NULL
	,@orgCorporateAddressId BIGINT = NULL
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
		,OrgWorkAddressId = @orgWorkAddressId
		,OrgBusinessAddressId = @orgBusinessAddressId
		,OrgCorporateAddressId = @orgCorporateAddressId
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

	EXEC [dbo].[UpdateCOMPADD000Master] @addCompId = @CompanyId
		,@changedBy = @changedBy
		,@dateChanged = @dateChanged
		,@dateEntered = NULL
		,@enteredBy = NULL
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
