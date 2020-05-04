
create VIEW LatestSceduleGatewayIds
AS
SELECT MAX(Id) LatestGatewayId, JobID FROM JOBDL020Gateways (NOLOCK) WHERE ISNULL(GwyCompleted,0) = 1 
		AND GatewayTypeId =  (SELECT TOP 1 Id FROM SYSTM000Ref_Options (NOLOCK) WHERE SysLookupCode = 'GatewayType' AND SysOptionName = 'Gateway') 
		AND JobId IN	
			(SELECT DISTINCT JobId FROM JOBDL020Gateways (NOLOCK)
				WHERE GatewayTypeId = (SELECT TOP 1 Id FROM SYSTM000Ref_Options (NOLOCK) WHERE SysLookupCode = 'GatewayType' AND SysOptionName = 'Action') 
				AND JobId IS NOT NULL) 
	GROUP BY JobID


create VIEW LatestNotSceduleGatewayIds
AS
SELECT MAX(Id) LatestGatewayId, JobID FROM JOBDL020Gateways (NOLOCK)
			WHERE ISNULL(GwyCompleted,0) = 1 
			AND JobId NOT IN 
					(SELECT DISTINCT JobId FROM JOBDL020Gateways (NOLOCK)
							WHERE GatewayTypeId = (SELECT TOP 1 Id FROM SYSTM000Ref_Options (NOLOCK) WHERE SysLookupCode = 'GatewayType' AND SysOptionName = 'Action') 
								AND JobId IS NOT NULL)  GROUP BY JobID


