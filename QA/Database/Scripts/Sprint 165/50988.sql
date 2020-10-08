SELECT *
INTO #tempJob
FROM (
	SELECT ROW_NUMBER() OVER (
			PARTITION BY jobGateway.JobId ORDER BY jobGateway.Id DESC
			) AS ROWNUM
		,jobGateway.GwyGatewayCode
		,job.Id AS JobId
		,job.JobGatewayStatus
	FROM [dbo].[JOBDL020Gateways] jobGateway
	INNER JOIN JOBDL000Master job ON job.Id = jobGateway.JobID
		AND JobGatewayStatus LIKE '%xcbl%'
	INNER JOIN [SYSTM000Ref_Options] refOpt ON jobGateway.GatewayTypeId = refOpt.Id
		AND refOpt.SysOptionName = 'Gateway'
	INNER JOIN JobUpdateDecisionMaker dm ON dm.ActionCode = job.JobGatewayStatus
		AND XcblTableName <> 'UserDefinedField'
	) sub
WHERE sub.ROWNUM = 1

SELECT job.Id 'JobId'
	,job.JobGatewayStatus
	,TEMP.GwyGatewayCode
	,'BeforeUpdate' AS 'GatewayStatusUpdate'
FROM JOBDL000Master job
INNER JOIN #tempJob TEMP ON job.id = TEMP.JobId

UPDATE job
SET job.JobGatewayStatus = TEMP.GwyGatewayCode
FROM JOBDL000Master job
INNER JOIN #tempJob TEMP ON job.id = TEMP.JobId

SELECT job.Id 'JobId'
	,job.JobGatewayStatus
	,TEMP.GwyGatewayCode
	,'AfterUpdate' AS 'GatewayStatusUpdate'
FROM JOBDL000Master job
INNER JOIN #tempJob TEMP ON job.id = TEMP.JobId

DROP TABLE #tempJob