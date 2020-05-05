IF NOT EXISTS (Select 1 FROM [dbo].[SYSTM000Ref_Options] Where SysOptionName='Archive' AND [SysLookupCode] = 'GatewayStatus')
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
   SELECT [SysLookupId]
      ,[SysLookupCode]
      ,'Archive'
      ,[SysSortOrder]
      ,[SysDefault]
      ,[IsSysAdmin]
      ,[StatusId]
      ,[DateEntered]
      ,[EnteredBy]
      ,[DateChanged]
      ,[ChangedBy]
  FROM [M4PL_DEV].[dbo].[SYSTM000Ref_Options] Where SysOptionName='Discarded'
END