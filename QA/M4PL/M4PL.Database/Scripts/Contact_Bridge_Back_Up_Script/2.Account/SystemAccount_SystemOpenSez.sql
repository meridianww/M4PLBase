INSERT INTO [dbo].[SYSTM000OpnSezMe]
           ([SysUserContactID]
           ,[SysScreenName]
           ,[SysPassword]
           ,[SysComments]
           ,[SysOrgId]
           ,[SysOrgRefRoleId]
           ,[IsSysAdmin]
           ,[SysAttempts]
           ,[SysLoggedIn]
           ,[SysLoggedInCount]
           ,[SysDateLastAttempt]
           ,[SysLoggedInStart]
           ,[SysLoggedInEnd]
           ,[StatusId]
           ,[DateEntered]
           ,[EnteredBy]
           ,[DateChanged]
           ,[ChangedBy])
     
           SELECT (SELECT CM.ID FROM [dbo].[CONTC000Master] CM WHERE CM.[3030Id] = TS.SysUserContactID)
           ,[SysScreenName]
           ,[SysPassword]
           ,[SysComments]
           ,[SysOrgId]
           ,[SysOrgRefRoleId]
           ,[IsSysAdmin]
           ,[SysAttempts]
           ,[SysLoggedIn]
           ,[SysLoggedInCount]
           ,[SysDateLastAttempt]
           ,[SysLoggedInStart]
           ,[SysLoggedInEnd]
           ,[StatusId]
           ,[DateEntered]
           ,[EnteredBy]
           ,[DateChanged]
           ,[ChangedBy] FROM [M4PL_3030_Test].[dbo].[SYSTM000OpnSezMe] TS
		   WHERE TS.SysOrgId = 1 
		   AND TS.SysOrgId IN('mark','trioux','iestrada','jhirsch','sbenson')

GO


