SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */
-- =============================================================
-- Author:		Prashant Aggarwal
-- Create date: 02/10/2020
-- Description:	Update Line Number Column For ProgramGateways
-- =============================================================
CREATE PROCEDURE [dbo].[GetLineNumberForJobGateways] (
	@GatewayId BIGINT
	,@JobId BIGINT
	,@GatewayTypeId INT
	,@OrderType NVARCHAR(20)
	,@ShipmentType NVARCHAR(20)
	,@GatewayLineNumber INT OUTPUT
	)
AS
BEGIN 
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
		AND StatusId IN (
			194
			,195
			)
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

		SELECT @GatewayLineNumber = LineNumber + 1
		FROM #Temp
	END

		DROP TABLE #Temp 
END 
GO
