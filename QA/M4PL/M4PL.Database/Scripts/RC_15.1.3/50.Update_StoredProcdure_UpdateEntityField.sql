SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan 
-- Create date:               11/16/2018      
-- Description:               Update Status By EntityName For given comma separated ids
-- Execution:                 EXEC [dbo].[UpdateEntityField]
-- Modified on:  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE [dbo].[UpdateEntityField] @userId BIGINT
	,@roleId BIGINT
	,@orgId BIGINT
	,@entity NVARCHAR(100)
	,@ids NVARCHAR(MAX)
	,@separator CHAR(1)
	,@statusId INT
	,@fieldName NVARCHAR(100)
AS
BEGIN TRY
	SET NOCOUNT ON;

	DECLARE @sqlCommand NVARCHAR(MAX);
	DECLARE @tableName NVARCHAR(100)
	DECLARE @contactContext NVARCHAR(100)

	SET @contactContext = @entity

	IF EXISTS (
			SELECT 1
			FROM CONTC010Bridge
			WHERE ConTableName = @entity
			)
	BEGIN
		SET @entity = 'ContactBridge' -- this has been added to change entity type to Contactbridge if there is contact mapping.
	END

	SELECT @tableName = TblTableName
	FROM [dbo].[SYSTM000Ref_Table]
	WHERE SysRefName = @entity

	DECLARE @primaryKeyName NVARCHAR(50);

	SELECT @primaryKeyName = TblPrimaryKeyName
	FROM [SYSTM000Ref_Table]
	WHERE SysRefName = @entity

	--SET  @primaryKeyName = CASE @entity 
	--WHEN 'ScrOsdList' THEN 'OSDID' 
	--WHEN 'ScrOsdReasonList' THEN 'ReasonID' 
	--WHEN 'ScrRequirementList' THEN 'RequirementID'
	--WHEN 'ScrReturnReasonList' THEN 'ReturnReasonID'
	--WHEN 'ScrServiceList' THEN 'ServiceID'
	--ELSE 'Id' END;
	SET @sqlCommand = ' UPDATE ' + @entity + ' SET ' + @entity + '.' + @fieldName + ' = ' + CAST(@statusId AS VARCHAR(100)) + ' FROM ' + @tableName + ' ' + @entity + ' JOIN [dbo].[fnSplitString](''' + @ids + ''', ''' + @separator + ''') allIds ON ' + @entity + '.' + @primaryKeyName + ' = allIds.Item '

	EXEC sp_executesql @sqlCommand

	IF (
			(@contactContext = 'CustContact')
			AND (@fieldName = 'StatusId')
			)
	BEGIN
		DECLARE @currentCustContact NVARCHAR(100)

		SELECT TOP 1 @currentCustContact = Item
		FROM [dbo].[fnSplitString](@ids, @separator)

		IF (
				(
					SELECT COUNT(Id)
					FROM [dbo].[CONTC010Bridge]
					WHERE Id = @currentCustContact
					) > 0
				)
		BEGIN
			DECLARE @currentCustomerId BIGINT
			DECLARE @currentCustCountToUpdate INT

			SELECT @currentCustomerId = ConPrimaryRecordId
			FROM [dbo].[CONTC010Bridge]
			WHERE Id = @currentCustContact

			SELECT @currentCustCountToUpdate = (0 - COUNT(Item))
			FROM [dbo].[fnSplitString](@ids, @separator)

			EXEC [dbo].[UpdateColumnCount] @tableName = 'CUST000Master'
				,@columnName = 'CustContacts'
				,@rowId = @currentCustomerId
				,@countToChange = @currentCustCountToUpdate
		END
	END

	IF (
			(@contactContext = 'VendContact')
			AND (@fieldName = 'StatusId')
			)
	BEGIN
		DECLARE @currentVendContact NVARCHAR(100)

		SELECT TOP 1 @currentVendContact = Item
		FROM [dbo].[fnSplitString](@ids, @separator)

		IF (
				(
					SELECT COUNT(Id)
					FROM [dbo].[CONTC010Bridge]
					WHERE Id = @currentVendContact
					) > 0
				)
		BEGIN
			DECLARE @currentVendorId BIGINT
			DECLARE @currentVendCountToUpdate INT

			SELECT @currentVendorId = ConPrimaryRecordId
			FROM [dbo].[CONTC010Bridge]
			WHERE Id = @currentVendContact

			SELECT @currentVendCountToUpdate = (0 - COUNT(Item))
			FROM [dbo].[fnSplitString](@ids, @separator)

			EXEC [dbo].[UpdateColumnCount] @tableName = 'VEND000Master'
				,@columnName = 'VendContacts'
				,@rowId = @currentVendorId
				,@countToChange = @currentVendCountToUpdate
		END
	END

	SET @sqlCommand = ' SELECT ' + @entity + '.' + @fieldName + ' AS SysRefId, 0 as IsDefault, NULL as SysRefName, NULL as LangName, 0 as ParentId' + ' FROM ' + @tableName + ' ' + @entity + ' JOIN [dbo].[fnSplitString](''' + @ids + ''', ''' + @separator + ''') allIds ON ' + @entity + '.' + @primaryKeyName + ' = allIds.Item ' + ' WHERE ' + @entity + '.' + @fieldName + ' != ' + CAST(@statusId AS VARCHAR(100))

	IF (
			@entity = 'Customer'
			OR @entity = 'Vendor'
			OR @entity = 'Organization'
			)
	BEGIN
		UPDATE COMP
		SET COMP.StatusId = @StatusId
		FROM [dbo].[COMP000Master] COMP
		INNER JOIN [dbo].[fnSplitString](@ids, @separator) allIds ON Comp.CompPrimaryRecordId = allIds.Item
			AND [CompTableName] = @entity
	END

	EXEC sp_executesql @sqlCommand
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