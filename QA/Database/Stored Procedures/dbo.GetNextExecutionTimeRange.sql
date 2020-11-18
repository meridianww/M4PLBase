SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetNextExecutionTimeRange]
@Adjustment int
AS
BEGIN
	DECLARE @EndDatetime DATETIME, @AdjustedEndDateTime DATETIME
	DECLARE @EndLsn BINARY(10)
	SET @EndDatetime = GETDATE()
	SET @AdjustedEndDateTime = DATEADD(SECOND, (-1)*@Adjustment, @EndDatetime)
	SET @EndLsn = sys.fn_cdc_map_time_to_lsn('largest less than or equal',@AdjustedEndDateTime)


	SELECT
	EC.EntityName
		, sys.fn_cdc_increment_lsn(LastLSN) as BeginLSN 
		, @EndLSN as EndLSN
		, DATEADD(SECOND, (-1)*@Adjustment, EC.LastExecutedDatetime) as AdjustedStartDateTime
		, @AdjustedEndDateTime AS AdjustedEndDateTime
		, @EndDatetime AS EndDateTime
	FROM [dbo].[OrderSearchConfig] EC WITH (NOLOCK)
	WHERE @EndLSN > EC.LastLSN
	AND DATEADD(MINUTE, ISNULL(ec.interval,0), (DATEADD(SECOND, (-1)*@Adjustment, EC.LastExecutedDatetime))) <= @AdjustedEndDateTime
END
GO
