  update [SYSTM030Ref_TabPageName] set TabTableName = 'PrgCostLocation' where RefTableName = 'Program' and TabTableName= 'PrgCostRate'
  update [SYSTM030Ref_TabPageName] set TabTableName = 'PrgBillableLocation' where RefTableName = 'Program' and TabTableName= 'PrgBillableRate'

