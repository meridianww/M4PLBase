INSERT INTO [dbo].[PRGRM020_Roles]
           ([OrgID]
           ,[ProgramID]
           ,[PrgRoleCode]
           ,[PrgRoleTitle]
           ,[StatusId]
           ,[DateEntered]
           ,[EnteredBy]
           ,[DateChanged]
           ,[ChangedBy])
     SELECT PR.[OrgID]
           ,PF.Id
           ,PR.[PrgRoleCode]
           ,PR.[PrgRoleTitle]
           ,PSR.[Id]--PR.[StatusId]
           ,PR.[DateEntered]
           ,PR.[EnteredBy]
           ,PR.[DateChanged]
           ,PR.[ChangedBy]
		   FROM [M4PL_3030_Test].[dbo].[PRGRM020_Roles] PR
		   LEFT JOIN [M4PL_3030_Test].[dbo].[PRGRM000Master] P ON P.Id = PR.ProgramID
		   LEFT JOIN [dbo].[PRGRM000Master] PF ON PF.PrgProgramCode = P.PrgProgramCode
		   LEFT JOIN [M4PL_3030_Test].[dbo].[SYSTM000Ref_Options] RPS ON PR.StatusId = RPS.Id
		   LEFT JOIN [dbo].[SYSTM000Ref_Options] PSR ON PSR.SysLookupId = RPS.SysLookupId AND PSR.SysLookupCode = RPS.SysLookupCode AND PSR.SysOptionName = RPS.SysOptionName
		   WHERE PR.OrgID=1