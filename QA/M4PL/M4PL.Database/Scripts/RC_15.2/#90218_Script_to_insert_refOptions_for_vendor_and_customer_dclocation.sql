USE [M4PL_DEV]
GO
INSERT INTO [dbo].[SYSTM000Ref_Options]
           ([SysLookupId]
           ,[SysLookupCode]
           ,[SysOptionName]
           ,[SysSortOrder]
           ,[SysDefault]
           ,[IsSysAdmin]
           ,[StatusId]
         )
     VALUES
           (7
           ,'ContactType'
           ,'CustDcLocationContact'
           ,6
           ,0
           ,0
           ,1
           )
GO

INSERT INTO [dbo].[SYSTM000Ref_Options]
           ([SysLookupId]
           ,[SysLookupCode]
           ,[SysOptionName]
           ,[SysSortOrder]
           ,[SysDefault]
           ,[IsSysAdmin]
           ,[StatusId]
         )
     VALUES
           (7
           ,'ContactType'
           ,'VendDcLocationContact'
           ,7
           ,0
           ,0
           ,1
           )
GO




