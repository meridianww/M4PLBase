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
           ('PrgBillableLocation'
           ,'EN'
           ,'Price Code'
           ,'PRGRM042ProgramBillableLocations'
           ,12
           ,null
           ,null
           ,'Id'
           ,'ProgramID'
           ,'PblItemNumber'
           ,GETUTCDATE()
           ,null
           ,GETUTCDATE()
           ,null)

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
           ('PrgCostLocation'
           ,'EN'
           ,'Cost Code'
           ,'PRGRM043ProgramCostLocations'
           ,12
           ,null
           ,null
           ,'Id'
           ,'ProgramID'
           ,'PclItemNumber'
           ,GETUTCDATE()
           ,null
           ,GETUTCDATE()
           ,null)

GO


