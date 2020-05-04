
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
           ('PrgEdiCondition'
           ,'EN'
           ,'Program EDI Condition'
           ,'PRGRM072EdiConditions'
           ,12
           ,null
           ,NUll
           ,'Id'
           ,'PecProgramId'
           ,null
           ,GETUTCDATE()
           ,null
           ,GETUTCDATE()
           ,null)
GO


