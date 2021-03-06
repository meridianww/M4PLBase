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
CREATE PROCEDURE [dbo].[UpdateEntityField] @userId BIGINT
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
				AND  @entity NOT IN ('SystemAccount','VendDcLocation','CustDcLocation')
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

		UPDATE CDCL
        SET CDCL.CdcContactMSTRID = NULL
        FROM dbo.CUST040DCLocations CDCL 
        INNER JOIN dbo.CONTC010Bridge CB ON CB.ContactMstrId = CDCL.CdcContactMSTRID
        INNER JOIN [dbo].[fnSplitString](@ids, @separator) FSP On FSP.Item = CB.Id
        Where CB.ContableName = 'CustContact'


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

		UPDATE VDCL
        SET VDCL.VdcContactMSTRID = NULL
        FROM dbo.VEND040DCLocations VDCL 
        INNER JOIN dbo.CONTC010Bridge CB ON CB.ContactMstrId = VDCL.VdcContactMSTRID
        INNER JOIN [dbo].[fnSplitString](@ids, @separator) FSP On FSP.Item = CB.Id
        Where CB.ContableName = 'VendContact'

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

	IF (@entity = 'PrgBillableLocation')
	BEGIN
		DECLARE @PblProgramId INT

		SELECT @PblProgramId = PBL.PblProgramId
		FROM dbo.PRGRM042ProgramBillableLocations PBL
		INNER JOIN [dbo].[fnSplitString](@ids, @separator) FN ON FN.Item = PBL.Id

		CREATE TABLE #pbltemptable (
			Id BIGINT
			,PvlItemNumber INT
			)

		INSERT INTO #pbltemptable (
			Id
			,PvlItemNumber
			)
		SELECT Id
			,ROW_NUMBER() OVER (
				ORDER BY PblItemNumber
				)
		FROM [PRGRM042ProgramBillableLocations]
		WHERE PblProgramID = @PblProgramId
			AND StatusId IN (
				1
				,2
				)
		ORDER BY Id

		MERGE INTO [PRGRM042ProgramBillableLocations] c1
		USING #pbltemptable c2
			ON c1.Id = c2.Id
		WHEN MATCHED
			THEN
				UPDATE
				SET c1.PblItemNumber = c2.PvlItemNumber;

		DROP TABLE #pbltemptable
	END

	IF (@entity = 'PrgCostLocation')
	BEGIN
		DECLARE @PclProgramID INT

		SELECT @PclProgramID = PCL.PclProgramID
		FROM dbo.PRGRM043ProgramCostLocations PCL
		INNER JOIN [dbo].[fnSplitString](@ids, @separator) FN ON FN.Item = PCL.Id

		CREATE TABLE #tempPclProgramtable (
			Id BIGINT
			,PvlItemNumber INT
			)

		INSERT INTO #tempPclProgramtable (
			Id
			,PvlItemNumber
			)
		SELECT Id
			,ROW_NUMBER() OVER (
				ORDER BY PclItemNumber
				)
		FROM PRGRM043ProgramCostLocations
		WHERE PclProgramID = @PclProgramID
			AND StatusId IN (
				1
				,2
				)
		ORDER BY Id

		MERGE INTO PRGRM043ProgramCostLocations c1
		USING #tempPclProgramtable c2
			ON c1.Id = c2.Id
		WHEN MATCHED
			THEN
				UPDATE
				SET c1.PclItemNumber = c2.PvlItemNumber;

		DROP TABLE #tempPclProgramtable
	END

	IF(@entity = 'JobCostSheet')
	BEGIN
	EXEC [dbo].[UpdateJobCostSheetItem] @ids
	END

	IF(@entity = 'JobBillableSheet')
	BEGIN
	EXEC [dbo].[UpdateJobBillableSheetItem] @ids
	END

	IF(@entity = 'PrgVendLocation' AND ISNULL(@statusId, 0) = 3)
	BEGIN
	UPDATE Billable
			SET Billable.StatusId = @statusId
			FROM PRGRM042ProgramBillableLocations Billable
			INNER JOIN [dbo].[PRGRM051VendorLocations] PVL ON PVL.VendDCLocationId = Billable.PblVenderDCLocationId
			INNER JOIN dbo.fnSplitString(@ids, ',') TM ON TM.Item = PVL.Id

			UPDATE Location
			SET Location.StatusId = @statusId
			FROM PRGRM043ProgramCostLocations Location
			INNER JOIN [dbo].[PRGRM051VendorLocations] PVL ON PVL.VendDCLocationId = Location.PclVenderDCLocationId
			INNER JOIN dbo.fnSplitString(@ids, ',') TM ON TM.Item = PVL.Id

			EXEC [dbo].[UpdatePrgCostLocationItemByVendor] @ids
			EXEC [dbo].[UpdatePrgBillableLocationItemByVendor] @ids

			Update Job
			SET Job.JobSiteCode = NULL, Job.VendDCLocationId = NULL
			From JOBDL000Master Job
			INNER JOIN [dbo].[PRGRM051VendorLocations] PVL ON PVL.VendDCLocationId = Job.VendDCLocationId
			INNER JOIN dbo.fnSplitString(@ids, ',') TM ON TM.Item = PVL.Id
	END

	IF(@entity = 'PrgRefGatewayDefault' AND ISNULL(@statusId, 0) = 3)
	BEGIN
	DECLARE @Count INT, @Counter BIGINT = 1,@CurrentPgdProgramID BIGINT,@CurrentGatewayTypeId INT
	,@CurrentPgdOrderType NVARCHAR(20),@CurrentPgdShipmentType  NVARCHAR(20)
	CREATE TABLE #ProgramGatewayTemp
	(
	 Id INT IDENTITY(1,1)
	,PgdProgramID BIGINT
	,GatewayTypeId INT
	,PgdOrderType NVARCHAR(20)
	,PgdShipmentType  NVARCHAR(20)
	)

	INSERT INTO #ProgramGatewayTemp (PgdProgramID,GatewayTypeId,PgdOrderType,PgdShipmentType)
	Select DISTINCT PgdProgramID,GatewayTypeId,PgdOrderType,PgdShipmentType
	From dbo.PRGRM010Ref_GatewayDefaults Gateway
	INNER JOIN [dbo].[fnSplitString](@ids, @separator) allIds ON Gateway.Id = allIds.Item

	Select @Count = ISNULL(Count(Id), 0) From #ProgramGatewayTemp
	IF (@Count > 0)
	BEGIN
		WHILE (@Count > 0)
		BEGIN
		Select @CurrentPgdProgramID = PgdProgramID,
		@CurrentGatewayTypeId = GatewayTypeId,
		@CurrentPgdOrderType = PgdOrderType,
		@CurrentPgdShipmentType = PgdShipmentType 
		From #ProgramGatewayTemp Where Id = @Counter
		EXEC [dbo].[UpdateLineNumberForProgramGateways] @CurrentPgdProgramID,@CurrentGatewayTypeId,@CurrentPgdOrderType,@CurrentPgdShipmentType
		SET @Counter = @Counter + 1
		SET @Count = @Count - 1
		END
    END

	DROP TABLE #ProgramGatewayTemp

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
