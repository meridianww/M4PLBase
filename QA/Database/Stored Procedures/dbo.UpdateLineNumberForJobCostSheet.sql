SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================================
-- Author:		Prashant Aggarwal
-- Create date: 01/07/2020
-- Description:	Update Line Number Column For JobCostSheet
-- =============================================================
CREATE PROCEDURE [dbo].[UpdateLineNumberForJobCostSheet] 
(
@JobId BIGINT
)
AS
BEGIN TRY
	SET NOCOUNT ON;

	DECLARE @Count INT
		,@Counter INT = 1
		,@CurrentCstElectronicBilling BIT
		,@LineNumber INT
		,@CurrentJobId BIGINT
		,@CurrentId BIGINT
		,@IsJobElectronicInvoiced BIT

	SELECT @IsJobElectronicInvoiced = ISNULL(JobElectronicInvoice, 0)
	FROM [dbo].[JOBDL000Master]
	WHERE Id = @JobId

	CREATE TABLE #Temp (
		TempId INT IDENTITY(1, 1)
		,Id BIGINT
		,JobId BIGINT
		,CstElectronicBilling BIT
		,LineNumber INT
		)

	INSERT INTO #Temp (
		Id
		,CstElectronicBilling
		,JobId
		)
	SELECT Id
		,CstElectronicBilling
		,JobId
	FROM dbo.JOBDL062CostSheet
	WHERE JobId = @JobId
		AND StatusId IN (
			1
			,2
			)
	ORDER BY Id

	SELECT @Count = ISNULL(Count(Id), 0)
	FROM #Temp

	IF (@Count > 0)
	BEGIN
		WHILE (@Count > 0)
		BEGIN
			SELECT @CurrentCstElectronicBilling = CstElectronicBilling
				,@CurrentJobId = JobId
				,@CurrentId = ID
			FROM #Temp
			WHERE TempId = @Counter

			IF (@IsJobElectronicInvoiced = 1)
			BEGIN
				SELECT @LineNumber = CASE 
						WHEN ISNULL(MAX(LineNumber), 0) = 0
							THEN 10000
						ELSE MAX(LineNumber) + 1
						END
				FROM #Temp
				WHERE JobId = @CurrentJobId
					AND CstElectronicBilling = @CurrentCstElectronicBilling
			END
			ELSE
			BEGIN
				SELECT @LineNumber = CASE 
						WHEN ISNULL(MAX(LineNumber), 0) = 0
							THEN 10000
						ELSE MAX(LineNumber) + 1
						END
				FROM #Temp
				WHERE JobId = @CurrentJobId
			END

			UPDATE #Temp
			SET LineNumber = @LineNumber
			WHERE ID = @CurrentId

			SET @Count = @Count - 1
			SET @Counter = @Counter + 1
		END
	END

	UPDATE CostSheet
	SET CostSheet.LineNumber = tmp.LineNumber
	FROM dbo.JOBDL062CostSheet CostSheet
	INNER JOIN #Temp tmp ON tmp.Id = CostSheet.Id

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

