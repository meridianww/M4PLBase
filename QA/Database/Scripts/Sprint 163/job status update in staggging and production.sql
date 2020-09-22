
UPDATE PRGRM010Ref_GatewayDefaults SET PgdGatewayCode='Schedule Pick Up'
WHERE PgdGatewayCode = 'Sched Pick Up'

WITH CTE AS 
(
   SELECT ID, 
          GwyGatewayCode,
		  JobID,
		  GatewayTypeId,
          ROW_NUMBER() OVER (PARTITION BY ID ORDER BY ID DESC) rn
   FROM JOBDL020Gateways
)


UPDATE JOB SET JobGatewayStatus = GATEWAY.GwyGatewayCode
FROM JOBDL000Master JOB
INNER JOIN CTE GATEWAY ON GATEWAY.JobID = JOB.Id 
AND GATEWAY.rn = 1 AND GATEWAY.GatewayTypeId =85


     
