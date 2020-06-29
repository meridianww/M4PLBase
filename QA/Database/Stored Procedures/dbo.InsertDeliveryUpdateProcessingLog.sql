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

	Select @jobCustomerId = Prg.PrgCustId
	FROM dbo.JOBDL000Master Job WITH (NOLOCK)
	INNER JOIN PRGRM000MASTER prg WITH (NOLOCK) ON job.ProgramID = prg.Id
	WHERE Job.Id = @JobId

	IF NOT EXISTS (
			SELECT 1
			FROM [dbo].[JobDL070DeliveryUpdateProcessingLog]
			WHERE JobId = @JobId
				AND ISNULL(IsProcessed, 0) = 0
			)
	BEGIN
		IF (@jobCustomerId = @customerId)
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
END


GO
