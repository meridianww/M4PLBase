CREATE NONCLUSTERED INDEX [NCI_JOBDL020Gateway_GatewayTypeId]
ON [dbo].[JOBDL020Gateways] ([GatewayTypeId])
INCLUDE ([Id],[JobID],[GwyCompleted])