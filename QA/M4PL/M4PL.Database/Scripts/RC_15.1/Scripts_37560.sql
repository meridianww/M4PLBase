INSERT INTO [dbo].[SYSTM000Ref_Options](
[SysLookupId]
      ,[SysLookupCode]
      ,[SysOptionName]
      ,[SysSortOrder]
      ,[SysDefault]
      ,[IsSysAdmin]
      ,[StatusId]
      ,[DateEntered]
)VALUES(28, 'MsgOperationType', 'Save', 5, null, 0, 1, GETDATE()),
(28, 'MsgOperationType', 'DoNotSave', 6, null, 0, 1, GETDATE())

UPDATE [dbo].[SYSTM000Master] SET SysMessageTitle='Warning', SysMessageDescription='You have unsaved data. Do you want to save changes and proceed?', SysMessageButtonSelection='Save,DoNotSave,Cancel' where SYsMessageCode='03.02'

INSERT INTO [dbo].[SYSMS010Ref_MessageTypes](
[LangCode]
      ,[SysRefId]
      ,[SysMsgtypeTitle]
      ,[StatusId]
      ,[DateEntered]
      ,[EnteredBy]
)
SELECT 
'EN',
Id,
'Save',
1,
GETDATE(),
'SimonDekker'
 FROM [dbo].[SYSTM000Ref_Options] WHERE [SysLookupId]=28 AND [SysOptionName]='Save'

 INSERT INTO [dbo].[SYSMS010Ref_MessageTypes](
[LangCode]
      ,[SysRefId]
      ,[SysMsgtypeTitle]
      ,[StatusId]
      ,[DateEntered]
      ,[EnteredBy]
)
SELECT 
'EN',
Id,
'Don''t Save',
1,
GETDATE(),
'SimonDekker'
 FROM [dbo].[SYSTM000Ref_Options] WHERE [SysLookupId]=28 AND [SysOptionName]='DoNotSave'

 