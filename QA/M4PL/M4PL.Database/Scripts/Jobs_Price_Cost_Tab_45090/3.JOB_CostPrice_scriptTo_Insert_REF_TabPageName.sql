USE [M4PL_DEV]
GO

INSERT INTO [dbo].[SYSTM030Ref_TabPageName]
           ([LangCode]
           ,[RefTableName]
           ,[TabSortOrder]
           ,[TabTableName]
           ,[TabPageTitle]
           ,[TabExecuteProgram]
           ,[TabPageIcon]
           ,[StatusId]
           ,[DateEntered]
           ,[EnteredBy]
           ,[DateChanged]
           ,[ChangedBy])
     VALUES
           ('EN'
           ,'Job'
           ,9
           ,'JobCostSheet'
           ,'Cost'
           ,'DataView'
           ,NULL
           ,1
           ,NULL
           ,NULL
           ,NULL
           ,NULL)
GO

INSERT INTO [dbo].[SYSTM030Ref_TabPageName]
           ([LangCode]
           ,[RefTableName]
           ,[TabSortOrder]
           ,[TabTableName]
           ,[TabPageTitle]
           ,[TabExecuteProgram]
           ,[TabPageIcon]
           ,[StatusId]
           ,[DateEntered]
           ,[EnteredBy]
           ,[DateChanged]
           ,[ChangedBy])
     VALUES
           ('EN'
           ,'Job'
           ,10
           ,'JobBillableSheet'
           ,'Price'
           ,'DataView'
           ,NULL
           ,1
           ,NULL
           ,NULL
           ,NULL
           ,NULL)
GO



