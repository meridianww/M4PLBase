Declare @StatusId INT
SELECT @StatusId=ID FROM SYSTM000Ref_Options WHERE SysLookupCode='GatewayStatus' AND SysOptionName='Archive'
print @StatusId

UPDATE dupgateway SET dupgateway.StatusId = @StatusId
FROM JOBDL000Master job
INNER JOIN dbo.JOBDL020Gateways gateway ON gateway.JobId = Job.Id
AND gateway.GwyGatewayCode = 'POD Completion'
INNER JOIN dbo.JOBDL020Gateways dupgateway ON dupgateway.JobId = Job.Id
AND dupgateway.GwyGatewayCode ='POD Completion'
WHERE gateway.GwyGatewayACD < dupgateway.GwyGatewayACD

