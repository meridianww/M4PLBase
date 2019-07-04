USE [M4PL_DEV]
GO

INSERT INTO [dbo].[SYSTM000Ref_Table]
           ([SysRefName]
           ,[LangCode]
           ,[TblLangName]
           ,[TblTableName]
           ,[TblMainModuleId]
           ,[TblIcon]
           ,[TblTypeId]
           ,[TblPrimaryKeyName]
           ,[TblParentIdFieldName]
           ,[TblItemNumberFieldName]
           ,[DateEntered]
           ,[EnteredBy]
           ,[DateChanged]
           ,[ChangedBy])
     VALUES
           ('NavCustomer'
           ,'EN'
           ,'NAV Customer'
           ,'NAV000Customer'
           ,7
           ,NULL
           ,null
           ,'Id'
           ,nULL
           ,NULL
           ,GETUTCDATE()
           ,NULL
           ,NULL
           ,nULL)


