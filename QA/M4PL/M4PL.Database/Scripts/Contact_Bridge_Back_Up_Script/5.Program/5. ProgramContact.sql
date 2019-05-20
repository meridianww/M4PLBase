INSERT INTO [dbo].[PRGRM020Program_Role]
           ([OrgID]
           ,[ProgramID]
           ,[PrgRoleSortOrder]
           ,[OrgRefRoleId]
           ,[PrgRoleId]
           ,[PrgRoleTitle]
           ,[PrgRoleContactID]
           ,[RoleTypeId]
           ,[StatusId]
           ,[PrxJobDefaultAnalyst]
           ,[PrxJobDefaultResponsible]
           ,[PrxJobGWDefaultAnalyst]
           ,[PrxJobGWDefaultResponsible]
           ,[PrgRoleDescription]
           ,[PrgComments]
           ,[DateEntered]
           ,[EnteredBy]
           ,[DateChanged]
           ,[ChangedBy])
    SELECT  prg.[OrgID]
		,P.Id--prg.[ProgramID]
		,prg.[PrgRoleSortOrder]
		,R.Id --prg.[OrgRefRoleId]
		,prf.Id--prg.[PrgRoleId]
		,prg.[PrgRoleTitle]
		,f.Id as PrgRoleContactID --prg.[PrgRoleContactID]
		,SRP.Id--prg.[RoleTypeId]
		,PSR.Id--prg.[StatusId]
		,prg.[PrxJobDefaultAnalyst]
		,prg.[PrxJobDefaultResponsible]
		,prg.[PrxJobGWDefaultAnalyst]
		,prg.[PrxJobGWDefaultResponsible]
		,prg.[PrgRoleDescription]
        ,prg.[PrgComments]
		,prg.[DateEntered]
		,prg.[EnteredBy]
		,prg.[DateChanged]
		,prg.[ChangedBy]
  FROM   [M4PL_3030_Test].[dbo].[PRGRM020Program_Role] prg
	
	INNER join [M4PL_3030_Test].[dbo].[PRGRM000Master] PM on prg.ProgramID = PM.Id
	INNER join [dbo].[PRGRM000Master] P on P.PrgProgramCode = PM.PrgProgramCode 
  
  LEFT JOIN [M4PL_3030_Test].[dbo].[PRGRM020_Roles] pr on pr.Id = prg.PrgRoleId
  LEFT JOIN [dbo].[PRGRM020_Roles] prf on prf.PrgRoleCode = pr.PrgRoleCode AND prf.ProgramID = p.Id

	LEFT JOIN [M4PL_3030_Test].[dbo].[CONTC000Master] m ON m.Id = prg.PrgRoleContactID
	LEFT JOIN [dbo].[CONTC000Master] f ON f.ConEmailAddress = m.ConEmailAddress

	LEFT JOIN [M4PL_3030_Test].[dbo].[ORGAN010Ref_Roles] RR ON RR.Id = prg.OrgRefRoleId
	LEFT JOIN [dbo].[ORGAN010Ref_Roles] R ON RR.OrgRoleCode = r.OrgRoleCode

	LEFT JOIN [M4PL_3030_Test].[dbo].[SYSTM000Ref_Options] RP ON prg.RoleTypeId = RP.Id
	LEFT JOIN [dbo].[SYSTM000Ref_Options] SRP ON SRP.SysLookupId = RP.SysLookupId AND SRP.SysLookupCode = RP.SysLookupCode AND SRP.SysOptionName = RP.SysOptionName

	LEFT JOIN [M4PL_3030_Test].[dbo].[SYSTM000Ref_Options] RPS ON prg.StatusId = RPS.Id
	LEFT JOIN [dbo].[SYSTM000Ref_Options] PSR ON PSR.SysLookupId = RPS.SysLookupId AND PSR.SysLookupCode = RPS.SysLookupCode AND PSR.SysOptionName = RPS.SysOptionName
	where PM.PrgOrgID = 1 