SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 4/30/2020
-- Description:	Insert Delivery Update Processing Log
CREATE PROCEDURE [dbo].[InsertDeliveryUpdateProcessingLog] (
	@JobId BIGINT
	,@customerId BIGINT
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @jobCustomerId BIGINT
	DECLARE @IsLogUpdated BIT = 0

	SELECT @jobCustomerId = Prg.PrgCustId
	FROM dbo.JOBDL000Master Job WITH (NOLOCK)
	INNER JOIN PRGRM000MASTER prg WITH (NOLOCK) ON job.ProgramID = prg.Id
	WHERE Job.Id = @JobId
	Select @IsLogUpdated = CASE WHEN @jobCustomerId = 20047 THEN 1 ELSE 0 END

	IF NOT EXISTS (
			SELECT 1
			FROM [dbo].[JobDL070DeliveryUpdateProcessingLog]
			WHERE JobId = @JobId
				AND ISNULL(IsProcessed, 0) = 0
			)
	BEGIN
		IF (@jobCustomerId = 20047)
		BEGIN
			INSERT INTO [dbo].[JobDL070DeliveryUpdateProcessingLog] (
				JobId
				,IsProcessed
				)
			VALUES (
				@JobId
				,0
				)
		END
	END

	SELECT @IsLogUpdated
END
GO
