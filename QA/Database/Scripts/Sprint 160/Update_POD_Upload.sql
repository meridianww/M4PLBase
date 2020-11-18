UPDATE [dbo].[JOBDL000Master] SET [JobGatewayStatus] = 'POD Completion' Where [JobGatewayStatus] ='POD Upload'
UPDATE [dbo].[JOBDL000Master] SET [JobGatewayStatus] = '4-POD Completion' Where [JobGatewayStatus] ='4-POD Upload'

UPDATE [dbo].[JOBDL020Gateways] SET [GwyGatewayCode] = 'POD Completion' Where [GwyGatewayCode] = 'POD Upload'
UPDATE [dbo].[JOBDL020Gateways] SET [GwyGatewayTitle] = 'POD Completion' Where [GwyGatewayTitle] = 'POD Upload'
UPDATE [dbo].[JOBDL020Gateways] SET [GwyGatewayCode] = 'DS POD Completion' Where [GwyGatewayCode] = 'DS POD Upload'

UPDATE [dbo].[PRGRM010Ref_GatewayDefaults] SET [PgdGatewayCode] = 'POD Completion' Where [PgdGatewayCode] = 'POD Upload'
UPDATE [dbo].[PRGRM010Ref_GatewayDefaults] SET [PgdGatewayTitle] = 'POD Completion' Where [PgdGatewayTitle] = 'POD Upload'
UPDATE [dbo].[PRGRM010Ref_GatewayDefaults] SET [PgdGatewayCode] = 'DS POD Completion' Where [PgdGatewayCode] = 'DS POD Upload'

UPDATE [dbo].[DashboardSubCategory] SET [DashboardSubCategoryDisplayName] = 'No POD Completion' Where [DashboardSubCategoryDisplayName] = 'No POD Upload'

UPDATE [dbo].[TestJobGateway] SET [GwyGatewayCode] = 'POD Completion' Where [GwyGatewayCode] = 'POD Upload'

UPDATE [SYSTM000Ref_Options] SET [SysOptionName]='POD Completion' Where SysLookupCode = 'TransitionStatus' AND [SysOptionName] = 'POD Upload'