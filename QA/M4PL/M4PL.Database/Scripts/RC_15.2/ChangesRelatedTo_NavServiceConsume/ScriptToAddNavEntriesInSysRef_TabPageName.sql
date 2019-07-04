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
           ,'Organization'
           ,7
           ,'NavCustomer'
           ,'Nav Customer'
           ,'DataView'
           ,NULL
           ,1
           ,GETUTCDATE()
           ,NULL
           ,NULL
           ,NULL)
GO


