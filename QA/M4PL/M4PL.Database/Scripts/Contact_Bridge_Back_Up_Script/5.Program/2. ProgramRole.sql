INSERT INTO [dbo].[PRGRM020_Roles]
           ([OrgID]
           ,[ProgramID]
           ,[PrgRoleCode]
           ,[PrgRoleTitle]
           ,[StatusId]
           ,[DateEntered]
           ,[EnteredBy]
           ,[DateChanged]
           ,[ChangedBy]
		   ,[3030Id])
     SELECT PR.[OrgID]
           ,p.Id
           ,PR.[PrgRoleCode]
           ,PR.[PrgRoleTitle]
           ,PR.[StatusId]
           ,PR.[DateEntered]
           ,PR.[EnteredBy]
           ,PR.[DateChanged]
           ,PR.[ChangedBy]
		   ,PR.Id
		   FROM [M4PL_3030_Test].[dbo].[PRGRM020_Roles] PR
		   INNER JOIN [dbo].[PRGRM000Master] P ON P.[3030Id] = PR.ProgramID
		   WHERE PR.OrgID=1