SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================================
-- Author:		Prashant Aggarwal
-- Create date: 02/10/2020
-- Description:	Update Line Number Column For JOBDL020Gateways
-- =============================================================
ALTER PROCEDURE [dbo].[UpdateLineNumberForJOBDL020Gateways] 
	(
	@JobId BIGINT
	,@GatewayTypeId INT
	,@gwyOrderType NVARCHAR(20)
	,@gwyShipmentType NVARCHAR(20)
	)
AS
BEGIN TRY
	SET NOCOUNT ON;

	DECLARE @Count INT
		,@Counter INT = 1
		,@LineNumber INT
		,@CurrentId BIGINT

	CREATE TABLE #Temp (
		TempId INT IDENTITY(1, 1)
		,Id BIGINT
		,JobId BIGINT
		,LineNumber INT
		)

	INSERT INTO #Temp (
		Id
		,JobId
		)
	SELECT Id
		,JobId
	FROM dbo.JOBDL020Gateways
	WHERE JobId = @JobId
		AND GatewayTypeId = @GatewayTypeId
		AND GwyOrderType = @gwyOrderType
		AND GwyShipmentType = @gwyShipmentType
	ORDER BY Id

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
	SET Gateway.GwyGatewaySortOrder = tmp.LineNumber
	FROM dbo.JOBDL020Gateways Gateway
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