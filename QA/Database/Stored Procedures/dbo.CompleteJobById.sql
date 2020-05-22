SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Manoj Kumar.S
-- Create date: 21/May/2020
-- Description:	Complete a Job
-- =============================================
CREATE PROCEDURE [dbo].[CompleteJobById] (
	@JobId BIGINT NULL
	,@ProgramId BIGINT NULL
	,@CustId BIGINT NULL
	,@User VARCHAR(100)
	,@DeliveryDate DATETIME2(7)
	,@IncludeNullableDeliveryDate BIT
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @JOB AS TABLE (Id INT)

	SET @JobId = NULLIF(@JobId, 0)
	SET @ProgramId = NULLIF(@ProgramId, 0)
	SET @CustId = NULLIF(@CustId, 0)

	INSERT INTO @JOB
	SELECT job.Id
	FROM [dbo].[CUST000Master] customer
	INNER JOIN [dbo].[PRGRM000Master] program ON customer.Id = Program.PrgCustId
	INNER JOIN [dbo].[JOBDL000Master] job ON program.Id = job.ProgramId
	WHERE customer.StatusId = 1
		AND Program.StatusId = 1
		AND job.StatusId = 1
		AND 1 = CASE 
			WHEN @CustId IS NULL
				OR @CustId = customer.Id
				THEN 1
			ELSE 0
			END
		AND 1 = CASE 
			WHEN @ProgramId IS NULL
				OR @ProgramId = program.Id
				THEN 1
			ELSE 0
			END
		AND 1 = CASE 
			WHEN @JobId IS NULL
				OR @JobId = Job.Id
				THEN 1
			ELSE 0
			END

	UPDATE job
	SET job.JobCompleted = 1
		,job.StatusId = 3
		,job.DateChanged = GETUTCDATE()
		,job.ChangedBy = @User
	FROM [dbo].[JOBDL000Master] job
	INNER JOIN @JOB tJob ON job.Id = tJob.Id

	UPDATE gateway
	SET gateway.StatusID = 195
		,gateway.GwyCompleted = 1
	FROM JOBDL020Gateways gateway
	INNER JOIN @JOB tJob ON gateway.JobID = tJob.Id
	WHERE StatusId = 1
		AND 1 = CASE 
			WHEN @IncludeNullableDeliveryDate = 1
				AND (
					(GwyGatewayPCD IS NULL)
					OR GwyGatewayPCD < @DeliveryDate
					)
				THEN 1
			ELSE CASE 
					WHEN GwyGatewayPCD < @DeliveryDate
						THEN 1
					ELSE 0
					END
			END
END