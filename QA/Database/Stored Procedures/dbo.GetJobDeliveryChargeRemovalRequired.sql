SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 05/20/2020
-- Description:	Get Job Delivery Charge Removal Required
-- =============================================
CREATE PROCEDURE [dbo].[GetJobDeliveryChargeRemovalRequired] (@JobId BIGINT)
AS
BEGIN
	DECLARE @JobDeliveryDateTimeActual DATETIME2(7)
		,@JobDeliveryStreetAddress NVARCHAR(150)
		,@JobDeliveryPostalCode NVARCHAR(50)
		,@JobDeliveryCity NVARCHAR(50)
		,@JobDeliveryState NVARCHAR(50)
		,@IsDeliveryChargeRemovalRequired BIT = 0

	SELECT @JobDeliveryDateTimeActual = JobDeliveryDateTimeActual
		,@JobDeliveryStreetAddress = JobDeliveryStreetAddress
		,@JobDeliveryPostalCode = JobDeliveryPostalCode
		,@JobDeliveryCity = JobDeliveryCity
		,@JobDeliveryState = JobDeliveryState
	FROM dbo.JOBDL000Master WITH (NOLOCK)
	WHERE Id = @JobId

	IF (
			ISNULL(@JobDeliveryStreetAddress, '') <> ''
			AND ISNULL(@JobDeliveryDateTimeActual, '') <> ''
			)
	BEGIN
		IF EXISTS (
				SELECT 1
				FROM dbo.JOBDL000Master Job WITH (NOLOCK)
				INNER JOIN dbo.NAV000JobSalesOrderMapping JSO WITH (NOLOCK) ON JSO.JobId = Job.Id
				WHERE Job.Id <> @JobId
					AND Job.JobDeliveryDateTimeActual = @JobDeliveryDateTimeActual
					AND Job.JobDeliveryStreetAddress = @JobDeliveryStreetAddress
					AND Job.JobDeliveryPostalCode = @JobDeliveryPostalCode
					AND Job.JobDeliveryCity = @JobDeliveryCity
					AND Job.JobDeliveryState = @JobDeliveryState
				)
		BEGIN
			SET @IsDeliveryChargeRemovalRequired = 1
		END
	END

	SELECT @IsDeliveryChargeRemovalRequired
END
GO
