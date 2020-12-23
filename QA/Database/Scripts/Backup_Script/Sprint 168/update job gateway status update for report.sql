

UPDATE SYSTM000ColumnsAlias SET ColAliasName='Job Gateway Status',ColCaption ='Job Gateway Status',ColGridAliasName ='Job Gateway Status'
WHERE ColTableName='JobAdvanceReport' AND ColColumnName='JobGatewayStatus'

CREATE NONCLUSTERED INDEX [Idx_JobGateways_JobGateway]
ON [dbo].[JOBDL020Gateways] ([ID],[JOBID])