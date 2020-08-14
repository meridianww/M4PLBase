
  UPDATE [SYSTM000Ref_Options] SET sysDefault = 0 where [SysOptionName] = 'All' and [SysLookupCode] = 'Status'
  UPDATE [SYSTM000Ref_Options] SET sysDefault = 1 where [SysOptionName] = 'Active' and [SysLookupCode] = 'Status'