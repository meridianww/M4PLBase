  UPDATE [dbo].[SYSTM000ColumnsAlias] SET ColAliasName = 'Arrival Date Planned', ColCaption = 'Arrival Date Planned',ColGridAliasName = 'Arrival Date Planned'
  Where ColAliasName = 'Origin Date Planned'

  UPDATE [dbo].[SYSTM000ColumnsAlias] SET ColAliasName = 'Site Code', ColCaption = 'Site Code',ColGridAliasName = 'Site Code'
  Where ColTableName='JobAdvanceReport' AND ColColumnName = 'JobSiteCode'