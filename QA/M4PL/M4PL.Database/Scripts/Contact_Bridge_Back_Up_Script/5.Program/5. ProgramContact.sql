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
		,PM.Id--prg.[ProgramID]
		,prg.[PrgRoleSortOrder]
		,RR.Id --prg.[OrgRefRoleId]
		,pr.Id--prg.[PrgRoleId]
		,prg.[PrgRoleTitle]
		,m.Id as PrgRoleContactID --prg.[PrgRoleContactID]
		,prg.[RoleTypeId]
		,prg.[StatusId]
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
	
	INNER join [dbo].[PRGRM000Master] PM on prg.ProgramID = PM.[3030Id]
  
  INNER JOIN [dbo].[PRGRM020_Roles] pr on pr.[3030Id] = prg.PrgRoleId

	INNER JOIN [dbo].[CONTC000Master] m ON m.[3030Id] = prg.PrgRoleContactID

	INNER JOIN [M4PL_3030_Test].[dbo].[ORGAN010Ref_Roles] RR ON RR.[Id] = prg.OrgRefRoleId

	where PM.PrgOrgID = 1 