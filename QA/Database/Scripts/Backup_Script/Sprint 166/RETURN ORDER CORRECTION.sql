
UPDATE job
SET job.JobIsSchedule = 1
FROM JOBDL020Gateways gateway
INNER JOIN JOBDL000Master job ON job.Id = gateway.JobID
WHERE gateway.GwyGatewayCode IN ('Schedule Pick Up','Sched Pick Up')