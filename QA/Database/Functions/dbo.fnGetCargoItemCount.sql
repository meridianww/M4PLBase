SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 3/5/2021
-- Description:	Get Cargo Item with Count
-- =============================================
CREATE FUNCTION [dbo].[fnGetCargoItemCount] (
	@JobId BIGINT
	,@GatewayCode VARCHAR(50)
	)
RETURNS @OUTPUT TABLE (
	JobId BIGINT
	,CargoId BIGINT
	,ActualCount INT
	,ExceptionCount INT
	)
AS
BEGIN
	IF (ISNULL(@GatewayCode, '') = 'On Hand')
	BEGIN
		INSERT INTO @OUTPUT (
			JobId
			,CargoId
			,ActualCount
			,ExceptionCount
			)
		SELECT JobId
			,Id
			,ISNULL(CgoQTYOrdered, 0) ActualCount
			,(ISNULL(CgoQtyDamaged, 0) + ISNULL(CgoQtyShortOver, 0) + ISNULL(CgoQtyOver, 0)) ExceptionCount
		FROM JobDL010Cargo
		WHERE JobId = @JobId
	END
	ELSE IF (ISNULL(@GatewayCode, '') = 'On Truck')
	BEGIN
		INSERT INTO @OUTPUT (
			JobId
			,CargoId
			,ActualCount
			,ExceptionCount
			)
		SELECT JobId
			,Id
			,CASE 
				WHEN ISNULL(CgoQtyOnHand, 0) > 0
					THEN ISNULL(CgoQtyOnHand, 0)
				ELSE ISNULL(CgoQTYOrdered, 0)
				END ActualCount
			,(ISNULL(CgoQtyDamaged, 0) + ISNULL(CgoQtyShortOver, 0) + ISNULL(CgoQtyOver, 0)) ExceptionCount
		FROM JobDL010Cargo
		WHERE JobId = @JobId
	END
	ELSE IF (ISNULL(@GatewayCode, '') = 'Delivered')
	BEGIN
		INSERT INTO @OUTPUT (
			JobId
			,CargoId
			,ActualCount
			,ExceptionCount
			)
		SELECT JobId
			,Id
			,CASE 
				WHEN ISNULL(CgoQtyExpected, 0) > 0
					THEN ISNULL(CgoQtyExpected, 0)
				WHEN ISNULL(CgoQtyOnHand, 0) > 0
					THEN ISNULL(CgoQtyOnHand, 0)
				ELSE ISNULL(CgoQTYOrdered, 0)
				END ActualCount
			,(ISNULL(CgoQtyDamaged, 0) + ISNULL(CgoQtyShortOver, 0) + ISNULL(CgoQtyOver, 0)) ExceptionCount
		FROM JobDL010Cargo
		WHERE JobId = @JobId
	END

	RETURN
END
GO

