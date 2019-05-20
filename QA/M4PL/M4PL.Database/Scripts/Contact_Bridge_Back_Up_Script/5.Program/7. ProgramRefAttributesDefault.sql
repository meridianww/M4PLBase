INSERT INTO [dbo].[PRGRM020Ref_AttributesDefault]
           ([ProgramID]
           ,[AttItemNumber]
           ,[AttCode]
           ,[AttTitle]
           ,[AttDescription]
           ,[AttComments]
           ,[AttQuantity]
           ,[UnitTypeId]
           ,[AttDefault]
           ,[StatusId]
           ,[DateEntered]
           ,[EnteredBy]
           ,[DateChanged]
           ,[ChangedBy])
     SELECT PF.[Id]
           ,TS.[AttItemNumber]
           ,TS.[AttCode]
           ,TS.[AttTitle]
           ,TS.[AttDescription]
           ,TS.[AttComments]
           ,TS.[AttQuantity]
           ,RP.Id--TS.[UnitTypeId]
           ,TS.[AttDefault]
           ,PSR.Id--TS.[StatusId]
           ,TS.[DateEntered]
           ,TS.[EnteredBy]
           ,TS.[DateChanged]
           ,TS.[ChangedBy]
	FROM [M4PL_3030_Test].[dbo].[PRGRM020Ref_AttributesDefault] TS
		   INNER join [M4PL_3030_Test].[dbo].[PRGRM000Master] PM on TS.ProgramID = PM.Id
		   INNER JOIN [dbo].[PRGRM000Master] PF ON PF.PrgProgramCode = PM.PrgProgramCode
		   LEFT JOIN [M4PL_3030_Test].[dbo].[SYSTM000Ref_Options] RP ON TS.UnitTypeId = RP.Id
		   LEFT JOIN [dbo].[SYSTM000Ref_Options] SRP ON SRP.SysLookupId = RP.SysLookupId AND SRP.SysLookupCode = RP.SysLookupCode AND SRP.SysOptionName = RP.SysOptionName
		   LEFT JOIN [M4PL_3030_Test].[dbo].[SYSTM000Ref_Options] RPS ON TS.StatusId = RPS.Id
		   LEFT JOIN [dbo].[SYSTM000Ref_Options] PSR ON PSR.SysLookupId = RPS.SysLookupId AND PSR.SysLookupCode = RPS.SysLookupCode AND PSR.SysOptionName = RPS.SysOptionName
		   where PM.PrgOrgID = 1