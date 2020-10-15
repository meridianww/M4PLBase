-- =============================================        

-- Author:                    Kamal         
-- Create date:               13/10/2020     
-- Description:               Get all job Actions
-- Execution:                 EXEC [dbo].[GetMultiJobActions] '154728'
-- Modified on:  
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE [dbo].[GetMultiJobActions] @jobIds NVARCHAR(MAX)
AS
BEGIN
    DECLARE @JobTypeCount INT =0, @ShipmentTypeCount INT =0;
    DECLARE @TempJobIds AS TABLE (JobId BIGINT)
	INSERT INTO @TempJobIds
		SELECT Item
		FROM fnSplitString(@jobIds, ',')

	SELECT @JobTypeCount = COUNT(DISTINCT JobType),@ShipmentTypeCount=COUNT(DISTINCT ShipmentType) FROM JOBDL000Master JOB 
	INNER JOIN @TempJobIds TMP ON TMP.JobId = JOB.Id
	IF(	@JobTypeCount = 1 AND @ShipmentTypeCount = 1)
	BEGIN
	    DECLARE @IsSchedule BIT = NULL,@IsScheduleCount INT =0;
		SELECT @IsScheduleCount=COUNT(DISTINCT JobIsSchedule) FROM JOBDL000Master JOB
		INNER JOIN @TempJobIds TMP ON TMP.JobId = JOB.Id
		IF(@IsScheduleCount =1)
		BEGIN
		   SELECT TOP 1 @IsSchedule = JobIsSchedule FROM JOBDL000Master JOB
		   INNER JOIN @TempJobIds TMP ON TMP.JobId = JOB.Id
		END
		IF(@IsSchedule IS NOT NULL AND @IsSchedule =1 )
		BEGIN
			SELECT DISTINCT GATEWAY.PgdGatewayCode Code,GATEWAY.PgdGatewayTitle Title FROM PRGRM010Ref_GatewayDefaults GATEWAY
			INNER JOIN JOBDL000Master JOB ON JOB.ProgramID = GATEWAY.PgdProgramID 
			INNER JOIN @TempJobIds TMP ON TMP.JobId = JOB.Id
			WHERE GATEWAY.GatewayTypeId = 86 AND GATEWAY.StatusId IN (1,2)
			AND GATEWAY.PgdGatewayCode NOT IN (
							'Schedule-NS'
							,'Schedule'
							,'XCBL-Schedule New'
							,'XCBL-Schedule'
							,'xCBL-Schedule Change'
							,'Schedule Pick Up'
							)
		END
		ELSE IF(@IsSchedule IS NOT NULL AND @IsSchedule =0 )
		BEGIN
			SELECT DISTINCT GATEWAY.PgdGatewayCode Code,GATEWAY.PgdGatewayTitle Title FROM PRGRM010Ref_GatewayDefaults GATEWAY
			INNER JOIN JOBDL000Master JOB ON JOB.ProgramID = GATEWAY.PgdProgramID 
			INNER JOIN @TempJobIds TMP ON TMP.JobId = JOB.Id
			WHERE GATEWAY.GatewayTypeId = 86 AND GATEWAY.StatusId IN (1,2)
			AND GATEWAY.PgdGatewayCode <> 'Delivery Window'
			AND GATEWAY.PgdGatewayCode NOT IN (
				SELECT PgdGatewayCode
				FROM [PRGRM010Ref_GatewayDefaults]
				WHERE PgdGatewayCode LIKE '%Reschedule%'
				)
		END
		ELSE BEGIN
			SELECT DISTINCT GATEWAY.PgdGatewayCode Code,GATEWAY.PgdGatewayTitle Title FROM PRGRM010Ref_GatewayDefaults GATEWAY
			INNER JOIN JOBDL000Master JOB ON JOB.ProgramID = GATEWAY.PgdProgramID 
			INNER JOIN @TempJobIds TMP ON TMP.JobId = JOB.Id
			WHERE GATEWAY.GatewayTypeId = 86 AND GATEWAY.StatusId IN (1,2)
			AND GATEWAY.PgdGatewayCode NOT IN (
							'Schedule-NS'
							,'Schedule'
							,'XCBL-Schedule New'
							,'XCBL-Schedule'
							,'xCBL-Schedule Change'
							,'Schedule Pick Up'
							)
			AND GATEWAY.PgdGatewayCode <> 'Delivery Window'
			AND GATEWAY.PgdGatewayCode NOT IN (
				SELECT PgdGatewayCode
				FROM [PRGRM010Ref_GatewayDefaults]
				WHERE PgdGatewayCode LIKE '%Reschedule%'
				)
		END
	END
END