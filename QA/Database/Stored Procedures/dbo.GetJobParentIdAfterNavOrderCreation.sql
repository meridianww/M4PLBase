SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 05/20/2020
-- Description:	Get Job Delivery Charge Removal Required
-- =============================================
CREATE PROCEDURE [dbo].[GetJobParentIdAfterNavOrderCreation] 
(
@JobId BIGINT,
@customerId BIGINT,
@ParentJobId BIGINT OUTPUT
)
AS
BEGIN
	DECLARE @JobDeliveryDateTimeActual DATETIME2(7)
		,@JobDeliveryStreetAddress NVARCHAR(150)
		,@JobDeliveryPostalCode NVARCHAR(50)
		,@JobDeliveryCity NVARCHAR(50)
		,@JobDeliveryState NVARCHAR(50)
		,@IsDeliveryChargeRemovalRequired BIT = 0
		,@JobCustomerId BIGINT

	SELECT @JobDeliveryDateTimeActual = JobDeliveryDateTimeActual
		,@JobDeliveryStreetAddress = JobDeliveryStreetAddress
		,@JobDeliveryPostalCode = JobDeliveryPostalCode
		,@JobDeliveryCity = JobDeliveryCity
		,@JobDeliveryState = JobDeliveryState
		,@JobCustomerId = Prg.PrgCustId
	FROM dbo.JOBDL000Master Job WITH (NOLOCK)
	INNER JOIN PRGRM000MASTER prg WITH (NOLOCK) ON job.ProgramID = prg.Id
	WHERE Job.Id = @JobId

	IF (
			ISNULL(@JobDeliveryStreetAddress, '') <> ''
			AND ISNULL(@JobDeliveryDateTimeActual, '') <> ''
			AND @customerId = @JobCustomerId
			)
	BEGIN
	SELECT TOP 1 @ParentJobId = JobId
				FROM dbo.JOBDL000Master Job WITH (NOLOCK)
				INNER JOIN dbo.NAV000JobSalesOrderMapping JSO WITH (NOLOCK) ON JSO.JobId = Job.Id
				WHERE Job.Id <> @JobId
					AND CAST(Job.JobDeliveryDateTimeActual AS Date) = CAST(@JobDeliveryDateTimeActual AS Date)
					AND Job.JobDeliveryStreetAddress = @JobDeliveryStreetAddress
					AND Job.JobDeliveryPostalCode = @JobDeliveryPostalCode
					AND Job.JobDeliveryCity = @JobDeliveryCity
					AND Job.JobDeliveryState = @JobDeliveryState
					ORDER BY JSO.DateEntered ASC
	END
END

GO
