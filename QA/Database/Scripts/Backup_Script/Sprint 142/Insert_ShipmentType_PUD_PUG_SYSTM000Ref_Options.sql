
DECLARE @LookupId INT 

SELECT @LookupId = Id from [dbo].[SYSTM000Ref_Lookup] where lkupcode = 'ShipmentType'

IF NOT EXISTS (SELECT 1 FROM [dbo].[SYSTM000Ref_Options] WHERE [SysLookupId] = @LookupId AND [SysOptionName] = 'PUG')
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
           (@LookupId
           ,'ShipmentType'
           ,'PUG'
           ,3
           ,0
           ,0
           ,1
           ,GETDATE()
           ,'nfujimoto'
           ,NULL
           ,NULL)
END


IF NOT EXISTS (SELECT 1 FROM [dbo].[SYSTM000Ref_Options] WHERE [SysLookupId] = @LookupId AND [SysOptionName] = 'PUD')
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
           (@LookupId
           ,'ShipmentType'
           ,'PUD'
           ,3
           ,0
           ,0
           ,1
           ,GETDATE()
           ,'nfujimoto'
           ,NULL
           ,NULL)
END