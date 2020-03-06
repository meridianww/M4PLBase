
Declare @LookupId INT
IF NOT EXISTS (Select 1 From SYSTM000Ref_Lookup Where LkupCode = 'OperationType')
BEGIN
INSERT INTO SYSTM000Ref_Lookup (LkupCode,LkupTableName)
Values ('OperationType', 'DbEnum')
END
Select @LookupId = ID From SYSTM000Ref_Lookup Where LkupCode = 'OperationType'
IF NOT EXISTS (Select 1 From dbo.SYSTM000Ref_Options Where SysLookupId = @LookupId AND SysLookupCode = 'OperationType' AND SysOptionName = 'RemoveFreeze')
BEGIN
INSERT INTO dbo.SYSTM000Ref_Options (SysLookupId,SysLookupCode,SysOptionName,SysSortOrder,SysDefault,IsSysAdmin,StatusId,DateEntered,EnteredBy)
Values (@LookupId,'OperationType','RemoveFreeze',13,0,0,1,GetDate(),NULL)
End

--select @LookupId = ID  from SYSTM000Ref_Options where  SysLookupId = @LookupId AND SysLookupCode =  'OperationType' AND SysOptionName ='RemoveFreeze'
INSERT INTO [dbo].[SYSMS010Ref_MessageTypes]
           ([LangCode]
           ,[SysRefId]
           ,[SysMsgtypeTitle]
           ,[SysMsgTypeDescription]
           ,[SysMsgTypeHeaderIcon]
           ,[SysMsgTypeIcon]
           ,[StatusId]
           ,[DateEntered]
           ,[EnteredBy]
           ,[DateChanged]
           ,[ChangedBy])
     VALUES
           ('EN'
           ,scope_identity()
           ,'RemoveFreeze'
           ,NULL
           ,NULL
           ,NULL
           ,1
           ,GETDATE()
           ,'SimonDekker'
           ,NULL
           ,NULL)
GO

