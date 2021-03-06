SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan
-- Create date:               10/10/2018      
-- Description:               Update a contact 
-- Execution:                 EXEC [dbo].[UpdContact]
-- Modified on:               05/03/2019( Kirty - Introduced @conUDF01 and remove #M4PL# check for NULL for values.)  
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE [dbo].[UpdContact] @userId BIGINT
	,@roleId BIGINT
	,@entity NVARCHAR(100)
	,@id BIGINT
	,@conERPId NVARCHAR(50) = NULL
	,@conOrgId BIGINT
	,@conCompanyName NVARCHAR(100)
	,@conTitleId INT = NULL
	,@conLastName NVARCHAR(25) = NULL
	,@conFirstName NVARCHAR(25) = NULL
	,@conMiddleName NVARCHAR(25) = NULL
	,@conEmailAddress NVARCHAR(100) = NULL
	,@conEmailAddress2 NVARCHAR(100) = NULL
	,@conJobTitle NVARCHAR(50) = NULL
	,@conBusinessPhone NVARCHAR(25) = NULL
	,@conBusinessPhoneExt NVARCHAR(15) = NULL
	,@conHomePhone NVARCHAR(25) = NULL
	,@conMobilePhone NVARCHAR(25) = NULL
	,@conFaxNumber NVARCHAR(25) = NULL
	,@conBusinessAddress1 NVARCHAR(255) = NULL
	,@conBusinessAddress2 VARCHAR(150) = NULL
	,@conBusinessCity NVARCHAR(25) = NULL
	,@conBusinessStateId INT = NULL
	,@conBusinessZipPostal NVARCHAR(20) = NULL
	,@conBusinessCountryId INT = NULL
	,@conHomeAddress1 NVARCHAR(150) = NULL
	,@conHomeAddress2 NVARCHAR(150) = NULL
	,@conHomeCity NVARCHAR(25) = NULL
	,@conHomeStateId INT = NULL
	,@conHomeZipPostal NVARCHAR(20) = NULL
	,@conHomeCountryId INT = NULL
	,@conAttachments INT = NULL
	,@conWebPage NTEXT = NULL
	,@conNotes NTEXT = NULL
	,@statusId INT = NULL
	,@conTypeId INT = NULL
	,@conOutlookId NVARCHAR(50) = NULL
	,@dateChanged DATETIME2(7) = NULL
	,@changedBy NVARCHAR(50) = NULL
	,@isFormView BIT = 0
	,@conUDF01 INT = NULL
	,@conCompanyId BIGINT
	,@parentId BIGINT = NULL
	,@jobSiteCode NVARCHAR(50) = NULL
AS
BEGIN TRY
	SET NOCOUNT ON;

	DECLARE @OldComapnyId BIGINT

	SELECT @OldComapnyId = ConCompanyId
	FROM [dbo].[CONTC000Master]
	WHERE Id = @id

	IF (ISNULL(@OldComapnyId, 0) <> ISNULL(@conCompanyId, 0))
	BEGIN
		DECLARE @StartPoint INT = 1
			,@EndCount INT

		CREATE TABLE #PrgRoleTemp (
			ID INT Identity(1, 1)
			,RoleId BIGINT
			)

		INSERT INTO #PrgRoleTemp (RoleId)
		SELECT PR.Id
		FROM PRGRM020Program_Role PR
		WHERE PR.PrgRoleContactID = @id
			AND PR.StatusId IN (
				1
				,2
				)
			AND PR.OrgID = 1

		SELECT @EndCount = Count(RoleId)
		FROM #PrgRoleTemp

		WHILE (@StartPoint <= @EndCount)
		BEGIN
			UPDATE PR
			SET PR.PrgRoleContactID = NULL
			FROM PRGRM020Program_Role PR
			INNER JOIN #PrgRoleTemp TMP ON TMP.RoleId = PR.Id
			WHERE TMP.Id = @StartPoint

			SET @StartPoint = @StartPoint + 1
		END

		DROP TABLE #PrgRoleTemp
	END

	UPDATE [dbo].[CONTC000Master]
	SET ConERPId = @conERPId 
		,ConTitleId = ISNULL(@conTitleId, ConTitleId)
		,ConOrgId = ISNULL(@conOrgId, ConOrgId)
		,ConCompanyName = ISNULL(@conCompanyName, ConCompanyName)
		,ConLastName = @conLastName
		,ConFirstName = @conFirstName
		,ConMiddleName = @conMiddleName
		,ConEmailAddress = @conEmailAddress
		,ConEmailAddress2 = @conEmailAddress2
		,ConJobTitle = @conJobTitle
		,ConBusinessPhone = @conBusinessPhone
		,ConBusinessPhoneExt = @conBusinessPhoneExt
		,ConHomePhone = @conHomePhone
		,ConMobilePhone = @conMobilePhone
		,ConFaxNumber = @conFaxNumber
		,ConBusinessAddress1 = @conBusinessAddress1
		,ConBusinessAddress2 = @conBusinessAddress2
		,ConBusinessCity = @conBusinessCity
		,ConBusinessStateId = ISNULL(@conBusinessStateId, ConBusinessStateId)
		,ConBusinessZipPostal = @conBusinessZipPostal
		,ConBusinessCountryId = ISNULL(@conBusinessCountryId, ConBusinessCountryId)
		,ConHomeAddress1 = @conHomeAddress1
		,ConHomeAddress2 = @conHomeAddress2
		,ConHomeCity = @conHomeCity
		,ConHomeStateId = ISNULL(@conHomeStateId, ConHomeStateId)
		,ConHomeZipPostal = @conHomeZipPostal
		,ConHomeCountryId = ISNULL(@conHomeCountryId, ConHomeCountryId) 
		,ConWebPage = @conWebPage
		,ConNotes = @conNotes
		,StatusId = ISNULL(@statusId, StatusId)
		,ConTypeId = ISNULL(@conTypeId, ConTypeId)
		,ConOutlookId = @conOutlookId
		,DateChanged = @dateChanged
		,ChangedBy = @changedBy
		,ConUDF01 = @conUDF01
		,ConCompanyId = ISNULL(@conCompanyId, ConCompanyId)
	WHERE Id = @id

	EXEC [dbo].[GetContact] @userId
		,@roleId
		,@conOrgId
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
