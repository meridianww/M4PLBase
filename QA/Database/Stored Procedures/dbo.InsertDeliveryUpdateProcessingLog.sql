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
	,@programId BIGINT
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @jobProgramId BIGINT

	SELECT @jobProgramId = ProgramId
	FROM dbo.JobDL000Master
	WHERE Id = @JobId

	IF NOT EXISTS (
			SELECT 1
			FROM [dbo].[JobDL070DeliveryUpdateProcessingLog]
			WHERE JobId = JobId
				AND ISNULL(IsProcessed, 0) = 0
			)
	BEGIN
		IF (@jobProgramId = @programId)
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

