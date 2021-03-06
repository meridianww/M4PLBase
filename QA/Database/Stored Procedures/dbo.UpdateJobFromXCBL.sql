SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Manoj Kumar.S
-- Create date: 04/15/2020
-- Description:	Get the xCBL Details
-- =============================================
CREATE PROCEDURE [dbo].[UpdateJobFromXCBL] (
	@columnsAndValues VARCHAR(MAX)
	,@JobId BIGINT
	,@JobGatewayId BIGINT
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @OriginPostalCode VARCHAR(20)
		   ,@DestinationPostalCode VARCHAR(20)
		   ,@UpdatedJobDeliveryPostalCode VARCHAR(20)
		   ,@UpdatedJobOriginPostalCode VARCHAR(20)
		   ,@JobOriginTimeZone NVARCHAR(15) = NULL
		   ,@JobDestinationTimeZone NVARCHAR(15)=NULL

	DECLARE @UpdateQuery VARCHAR(MAX) = 'UPDATE dbo.JOBDL000Master SET ' + @columnsAndValues + ', DateChanged = ''' + CONVERT(VARCHAR, GETDATE()) + '''  WHERE Id = ' + CONVERT(VARCHAR, @JobId)

	--PRINT(@UpdateQuery)
	EXEC (@UpdateQuery)

	SELECT @OriginPostalCode = JobOriginPostalCode
		,@DestinationPostalCode = JobDeliveryPostalCode
	FROM dbo.JobDL000Master
	WHERE Id = @JobId

	IF (ISNULL(@OriginPostalCode, '') <> '' AND LEN(@OriginPostalCode) > 4)
	BEGIN
	IF (dbo.IsCandaPostalCode(@OriginPostalCode) = 0)
	BEGIN
		SET @UpdatedJobOriginPostalCode = @OriginPostalCode
	END
	ELSE
	BEGIN
		SELECT TOP 1 @UpdatedJobOriginPostalCode = Item
		FROM dbo.[fnSplitString](@OriginPostalCode, '-')
	END

	SELECT TOP 1 @JobOriginTimeZone = [TimeZoneShortName]
		FROM [dbo].[Location000Master]
		WHERE PostalCode = @UpdatedJobOriginPostalCode
	END 
	IF (ISNULL(@DestinationPostalCode, '') <> '' AND LEN(@DestinationPostalCode) > 4)
	BEGIN
	IF (dbo.IsCandaPostalCode(@DestinationPostalCode) = 0)
	BEGIN
		SET @UpdatedJobDeliveryPostalCode = @DestinationPostalCode
	END
	ELSE
	BEGIN
		SELECT TOP 1 @UpdatedJobDeliveryPostalCode = Item
		FROM dbo.[fnSplitString](@DestinationPostalCode, '-')
	END

	SELECT TOP 1 @JobDestinationTimeZone = [TimeZoneShortName]
		FROM [dbo].[Location000Master]
		WHERE PostalCode = @UpdatedJobDeliveryPostalCode
	END

	UPDATE JobDL000Master
 SET JobOriginTimeZone = CASE 
		WHEN ISNULL(@JobOriginTimeZone, '') = ''
			THEN 'Pacific'
		ELSE @JobOriginTimeZone
		END
	,JobDeliveryTimeZone = CASE 
		WHEN ISNULL(@JobDestinationTimeZone, '') = ''
			THEN 'Pacific'
		ELSE @JobDestinationTimeZone
		END
 WHERE Id = @JobId

	UPDATE [dbo].[JOBDL020Gateways]
	SET GwyCompleted = 1
	WHERE Id = @JobGatewayId
END
GO
