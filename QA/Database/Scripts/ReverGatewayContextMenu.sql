IF NOT EXISTS(SELECT 1 FROM [dbo].[SYSTM000Ref_Options] WHERE [SysOptionName] = 'RevertGateway' AND [SysLookupCode] = 'OperationType' and [StatusId] = 1)
BEGIN
INSERT INTO [dbo].[SYSTM000Ref_Options]
           ([SysLookupId]
           ,[SysLookupCode]
           ,[SysOptionName]
           ,[SysSortOrder]
           ,[SysDefault]
           ,[IsSysAdmin]
           ,[StatusId]
           ,[DateEntered]
           ,[EnteredBy]
           ,[DateChanged]
           ,[ChangedBy])
     VALUES
           (29
           ,'OperationType'
           ,'RevertGateway'
           ,1
           ,0
           ,0
           ,1
           ,GETUTCDATE()
           ,NULL
           ,NULL
           ,NULL)
END

DECLARE @sysRefId INT
SELECT @sysRefId = ID FROM [dbo].[SYSTM000Ref_Options] WHERE [SysOptionName] = 'RevertGateway' AND [SysLookupCode] = 'OperationType'

IF NOT EXISTS(SELECT 1 FROM [dbo].[SYSMS010Ref_MessageTypes] WHERE sysmsgtypetitle = 'Revert Gateway' AND [SysRefId] = @sysRefId)
BEGIN
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
           ,@sysRefId
           ,'Revert Gateway'
           ,NULL
           ,NULL
           ,NULL
           ,1
           ,GETUTCDATE()
           ,NULL
           ,NULL
           ,NULL)
END
