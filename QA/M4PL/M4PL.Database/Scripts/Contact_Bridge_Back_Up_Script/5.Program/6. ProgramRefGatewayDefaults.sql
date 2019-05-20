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
     SELECT PF.[Id]
           ,TS.[PgdGatewaySortOrder]
           ,TS.[PgdGatewayCode]
           ,TS.[PgdGatewayTitle]
           ,TS.[PgdGatewayDescription]
           ,TS.[PgdGatewayDuration]
           ,B.Id--TS.[UnitTypeId]
           ,TS.[PgdGatewayDefault]
           ,A.Id--TS.[GatewayTypeId]
           ,PSR.Id--TS.[GatewayDateRefTypeId]
           ,TS.[Scanner]
           ,TS.[PgdShipStatusReasonCode]
           ,TS.[PgdShipApptmtReasonCode]
           ,TS.[PgdOrderType]
           ,TS.[PgdShipmentType]
           ,fc.Id--TS.[PgdGatewayResponsible]
           ,f.Id--TS.[PgdGatewayAnalyst]
           ,C.Id--TS.[StatusId]
           ,TS.[PgdGatewayComment]
           ,TS.[DateEntered]
           ,TS.[EnteredBy]
           ,TS.[DateChanged]
           ,TS.[ChangedBy]
		   FROM [M4PL_3030_Test].[dbo].[PRGRM010Ref_GatewayDefaults] TS
		   INNER join [M4PL_3030_Test].[dbo].[PRGRM000Master] PM on TS.PgdProgramID = PM.Id
		   INNER JOIN [dbo].[PRGRM000Master] PF ON PF.PrgProgramCode = PM.PrgProgramCode

		   LEFT JOIN [M4PL_3030_Test].[dbo].[CONTC000Master] CM ON CM.Id = TS.PgdGatewayAnalyst
		   LEFT JOIN [dbo].[CONTC000Master] f ON f.ConEmailAddress = CM.ConEmailAddress

		   LEFT JOIN [M4PL_3030_Test].[dbo].[CONTC000Master] CCM ON CCM.Id = TS.PgdGatewayResponsible
		   LEFT JOIN [dbo].[CONTC000Master] fc ON fc.ConEmailAddress = CCM.ConEmailAddress

		   LEFT JOIN [M4PL_3030_Test].[dbo].[SYSTM000Ref_Options] RPS ON TS.GatewayDateRefTypeId = RPS.Id
			LEFT JOIN [dbo].[SYSTM000Ref_Options] PSR ON PSR.SysLookupId = RPS.SysLookupId AND PSR.SysLookupCode = RPS.SysLookupCode AND PSR.SysOptionName = RPS.SysOptionName

			 LEFT JOIN [M4PL_3030_Test].[dbo].[SYSTM000Ref_Options] RP ON TS.GatewayTypeId = RP.Id
			LEFT JOIN [dbo].[SYSTM000Ref_Options] A ON A.SysLookupId = RP.SysLookupId AND A.SysLookupCode = RP.SysLookupCode AND A.SysOptionName = RP.SysOptionName

			LEFT JOIN [M4PL_3030_Test].[dbo].[SYSTM000Ref_Options] PS ON TS.UnitTypeId = PS.Id
			LEFT JOIN [dbo].[SYSTM000Ref_Options] B ON B.SysLookupId = PS.SysLookupId AND B.SysLookupCode = PS.SysLookupCode AND B.SysOptionName = PS.SysOptionName

			LEFT JOIN [M4PL_3030_Test].[dbo].[SYSTM000Ref_Options] SP ON TS.StatusId = SP.Id
			LEFT JOIN [dbo].[SYSTM000Ref_Options] C ON C.SysLookupId = SP.SysLookupId AND C.SysLookupCode = SP.SysLookupCode AND C.SysOptionName = SP.SysOptionName
		   where PM.PrgOrgID = 1