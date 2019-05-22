INSERT INTO [dbo].[PRGRM010Ref_GatewayDefaults]
           ([PgdProgramID]
           ,[PgdGatewaySortOrder]
           ,[PgdGatewayCode]
           ,[PgdGatewayTitle]
           ,[PgdGatewayDescription]
           ,[PgdGatewayDuration]
           ,[UnitTypeId]
           ,[PgdGatewayDefault]
           ,[GatewayTypeId]
           ,[GatewayDateRefTypeId]
           ,[Scanner]
           ,[PgdShipStatusReasonCode]
           ,[PgdShipApptmtReasonCode]
           ,[PgdOrderType]
           ,[PgdShipmentType]
           ,[PgdGatewayResponsible]
           ,[PgdGatewayAnalyst]
           ,[StatusId]
           ,[PgdGatewayComment]
           ,[DateEntered]
           ,[EnteredBy]
           ,[DateChanged]
           ,[ChangedBy])
     SELECT PM.[Id]
           ,TS.[PgdGatewaySortOrder]
           ,TS.[PgdGatewayCode]
           ,TS.[PgdGatewayTitle]
           ,TS.[PgdGatewayDescription]
           ,TS.[PgdGatewayDuration]
           ,TS.[UnitTypeId]
           ,TS.[PgdGatewayDefault]
           ,TS.[GatewayTypeId]
           ,TS.[GatewayDateRefTypeId]
           ,TS.[Scanner]
           ,TS.[PgdShipStatusReasonCode]
           ,TS.[PgdShipApptmtReasonCode]
           ,TS.[PgdOrderType]
           ,TS.[PgdShipmentType]
           ,CCM.Id--TS.[PgdGatewayResponsible]
           ,CM.Id--TS.[PgdGatewayAnalyst]
           ,TS.[StatusId]
           ,TS.[PgdGatewayComment]
           ,TS.[DateEntered]
           ,TS.[EnteredBy]
           ,TS.[DateChanged]
           ,TS.[ChangedBy]
		   FROM [M4PL_3030_Test].[dbo].[PRGRM010Ref_GatewayDefaults] TS
		   INNER join [dbo].[PRGRM000Master] PM on TS.PgdProgramID = PM.[3030Id]

		   INNER JOIN [dbo].[CONTC000Master] CM ON CM.[3030Id] = TS.PgdGatewayAnalyst

		   INNER JOIN [M4PL_3030_Test].[dbo].[CONTC000Master] CCM ON CCM.[3030Id] = TS.PgdGatewayResponsible

		   where PM.PrgOrgID = 1