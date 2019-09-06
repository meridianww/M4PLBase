SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Prashant Aggarwal         
-- Create date:               08/26/2019      
-- Description:               Upd a cust DCLocation Contact
-- =============================================
CREATE PROCEDURE [dbo].[BatchUpdateCustDcLocationContact] @userId BIGINT
	,@roleId BIGINT
	,@entity NVARCHAR(100)
	,@id BIGINT
	,@conCodeId BIGINT = NULL
	,@conCustDcLocationId BIGINT = NULL
	,@conItemNumber INT = NULL
	,@conContactTitle NVARCHAR(50) = NULL
	,@conContactMSTRID BIGINT = NULL
	,@statusId INT = NULL
	,@conTitleId INT = NULL
	,@conLastName NVARCHAR(25) = NULL
	,@conFirstName NVARCHAR(25) = NULL
	,@conMiddleName NVARCHAR(25) = NULL
	,@conJobTitle NVARCHAR(50) = NULL
	,@conOrgId BIGINT = NULL
	,@conTypeId INT = NULL
	,@conTableTypeId INT = NULL
	,@conBusinessPhone NVARCHAR(25) = NULL
	,@conBusinessPhoneExt NVARCHAR(15) = NULL
	,@conMobilePhone NVARCHAR(25) = NULL
	,@conEmailAddress NVARCHAR(100) = NULL
	,@conEmailAddress2 NVARCHAR(100) = NULL
	,@changedBy NVARCHAR(50) = NULL
	,@dateChanged DATETIME2(7) = NULL
	,@isFormView BIT = 0
	,@conCompanyId BIGINT = NULL
AS
BEGIN TRY
	SET NOCOUNT ON;

	DECLARE @updatedItemNumber INT
	IF(ISNULL(@conContactMSTRID, 0) = 0)
	BEGIN
	Select @conContactMSTRID = [ContactMSTRID] From [dbo].[CONTC010Bridge] WHERE [Id] = @id
	END

	EXEC [dbo].[ResetItemNumber] @userId
		,@id
		,@conCustDcLocationId
		,@entity
		,@conItemNumber
		,@statusId
		,NULL
		,NULL
		,@updatedItemNumber OUTPUT

	--First Update Contact
	IF (@isFormView = 0)
	BEGIN
		UPDATE [dbo].[CONTC000Master]
		SET ConTitleId = CASE 
				WHEN @conTitleId = - 100
					THEN NULL
				ELSE ISNULL(@conTitleId, ConTitleId)
				END
			,ConLastName = CASE 
				WHEN @conLastName = '#M4PL#'
					THEN NULL
				ELSE ISNULL(@conLastName, ConLastName)
				END
			,ConFirstName = CASE 
				WHEN @conFirstName = '#M4PL#'
					THEN NULL
				ELSE ISNULL(@conFirstName, ConFirstName)
				END
			,ConMiddleName = CASE 
				WHEN @conMiddleName = '#M4PL#'
					THEN NULL
				ELSE ISNULL(@conMiddleName, ConMiddleName)
				END
			,ConEmailAddress = CASE 
				WHEN @conEmailAddress = '#M4PL#'
					THEN NULL
				ELSE ISNULL(@conEmailAddress, ConEmailAddress)
				END
			,ConEmailAddress2 = CASE 
				WHEN @conEmailAddress2 = '#M4PL#'
					THEN NULL
				ELSE ISNULL(@conEmailAddress2, ConEmailAddress2)
				END
			,ConJobTitle = CASE 
				WHEN @conJobTitle = '#M4PL#' 
					THEN NULL
				ELSE ISNULL(@conJobTitle, ConJobTitle)
				END
			,ConBusinessPhone = CASE 
				WHEN @conBusinessPhone = '#M4PL#'
					THEN NULL
				ELSE ISNULL(@conBusinessPhone, ConBusinessPhone)
				END
			,ConBusinessPhoneExt = CASE 
				WHEN @conBusinessPhoneExt = '#M4PL#'
					THEN NULL
				ELSE ISNULL(@conBusinessPhoneExt, ConBusinessPhoneExt)
				END
			,ConMobilePhone = CASE 
				WHEN @conMobilePhone = '#M4PL#'
					THEN NULL
				ELSE ISNULL(@conMobilePhone, ConMobilePhone)
				END
			,ConUDF01 = CASE 
				WHEN @conTableTypeId = - 100
					THEN NULL
				ELSE ISNULL(@conTableTypeId, ConUDF01)
				END
			,StatusId = CASE 
				WHEN @statusId = - 100
					THEN NULL
				ELSE ISNULL(@statusId, StatusId)
				END
			,ConTypeId = CASE 
				WHEN @conTypeId = - 100
					THEN NULL
				ELSE ISNULL(@conTypeId, ConTypeId)
				END
			,DateChanged = ISNULL(@dateChanged, DateChanged)
			,ChangedBy = ISNULL(@changedBy, ChangedBy)
		WHERE Id = @conContactMSTRID

		--Then Update Cust Dc Location
		UPDATE [dbo].[CONTC010Bridge]
		SET [ConPrimaryRecordId] = CASE 
				WHEN (
						(@isFormView = 0)
						AND (@conCustDcLocationId = - 100)
						)
					THEN NULL
				ELSE ISNULL(@conCustDcLocationId, ConPrimaryRecordId)
				END
			,[ConItemNumber] = @updatedItemNumber
			,[ConTitle] = CASE 
				WHEN @conContactTitle = '#M4PL#'
					THEN NULL
				ELSE ISNULL(@conContactTitle, ConTitle)
				END
			,[ContactMSTRID] = CASE 
				WHEN @conContactMSTRID = - 100
					THEN NULL
				ELSE ISNULL(@conContactMSTRID, [ContactMSTRID])
				END
			,[ConTableTypeId] = CASE 
				WHEN @conTableTypeId = - 100
					THEN NULL
				ELSE ISNULL(@conTableTypeId, ConTableTypeId)
				END
			,[ConTypeId] = CASE 
				WHEN @conTypeId = - 100
					THEN NULL
				ELSE ISNULL(@conTypeId, ConTypeId)
				END
			,[StatusId] = CASE 
				WHEN @statusId = - 100
					THEN NULL
				ELSE ISNULL(@statusId, StatusId)
				END
			,[ChangedBy] = ISNULL(@changedBy, ChangedBy)
			,[DateChanged] = ISNULL(@dateChanged, DateChanged)
		WHERE [Id] = @id
	END

		EXEC [dbo].[GetCustDcLocationContact] @userId
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

