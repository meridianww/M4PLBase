SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================================
-- Author:		Prashant Aggarwal
-- Create date: 02/10/2020
-- Description:	Update Line Number Column For ProgramGateways
-- =============================================================
CREATE PROCEDURE [dbo].[UpdateLineNumberForProgramGateways] --67,10001,85,'Original','Cross-Dock Shipment',@GatewayLineNumber OUTPUT
	(
	 @ProgramId BIGINT
	,@GatewayTypeId INT
	,@OrderType NVARCHAR(20)
	,@ShipmentType NVARCHAR(20)
	)
AS
BEGIN TRY
	SET NOCOUNT ON;

	DECLARE @Count INT
		,@Counter INT = 1
		,@LineNumber INT
		,@CurrentId BIGINT
		,@GtyTypeId INT
		,@GtyCommentTypeId INT

		SELECT @GtyTypeId = Id
	FROM SYSTM000Ref_Options
	WHERE SysLookupCode = 'GatewayType'
		AND SysOptionName = 'Action'

		SELECT @GtyCommentTypeId = Id
	FROM SYSTM000Ref_Options
	WHERE SysLookupCode = 'GatewayType'
		AND SysOptionName = 'Comment'

	CREATE TABLE #Temp (
		TempId INT IDENTITY(1, 1)
		,Id BIGINT
		,ProgramId BIGINT
		,LineNumber INT
		)

IF(@GatewayTypeId = @GtyTypeId OR @GatewayTypeId = @GtyCommentTypeId)
BEGIN
	INSERT INTO #Temp (
		Id
		,ProgramId
		)
	SELECT Id
		,PgdProgramID
	FROM dbo.PRGRM010Ref_GatewayDefaults
	WHERE PgdProgramID = @ProgramId
		AND GatewayTypeId = @GatewayTypeId
		AND StatusId IN (1,2)
	ORDER BY Id
END
ELSE
BEGIN
	INSERT INTO #Temp (
		Id
		,ProgramId
		)
	SELECT Id
		,PgdProgramID
	FROM dbo.PRGRM010Ref_GatewayDefaults
	WHERE PgdProgramID = @ProgramId
		AND GatewayTypeId = @GatewayTypeId
		AND PgdOrderType = @OrderType
		AND PgdShipmentType = @ShipmentType
		AND StatusId IN (1,2)
	ORDER BY Id
END

	SELECT @Count = ISNULL(Count(Id), 0)
	FROM #Temp

	IF (@Count > 0)
	BEGIN
		WHILE (@Count > 0)
		BEGIN
			SELECT @CurrentId = ID
			FROM #Temp
			WHERE TempId = @Counter

			SELECT @LineNumber = CASE 
					WHEN ISNULL(MAX(LineNumber), 0) = 0
						THEN 1
					ELSE MAX(LineNumber) + 1
					END
			FROM #Temp

			UPDATE #Temp
			SET LineNumber = @LineNumber
			WHERE ID = @CurrentId

			SET @Count = @Count - 1
			SET @Counter = @Counter + 1
		END
	END

UPDATE Gateway
	SET Gateway.PgdGatewaySortOrder = tmp.LineNumber
	FROM dbo.PRGRM010Ref_GatewayDefaults Gateway
	INNER JOIN #Temp tmp ON tmp.Id = Gateway.Id

	DROP TABLE #Temp
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