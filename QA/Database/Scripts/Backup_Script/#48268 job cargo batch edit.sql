  
update SYSTM000ColumnsAlias set ColIsVisible = 0  where  ColTableName = 'jobcargo' and ColColumnName = 'CgoPackagingType'
update SYSTM000ColumnsAlias set ColIsVisible = 0  where  ColTableName = 'jobcargo' and ColColumnName = 'CgoVolumeUnits'
update SYSTM000ColumnsAlias set ColIsVisible = 0  where  ColTableName = 'jobcargo' and ColColumnName = 'CgoWeightUnits'
update SYSTM000ColumnsAlias set ColIsVisible = 0  where  ColTableName = 'jobcargo' and ColColumnName = 'CgoQtyUnits'

  update SYSTM000ColumnSettingsByUser set ColNotVisible = 'JobID,CgoProcessingFlags,EnteredBy,DateEntered,ChangedBy,DateChanged,CgoNotes,CgoQtyCounted,CgoPackagingType,CgoVolumeUnits,CgoQtyUnits,CgoWeightUnits'
  where ColTableName = 'jobcargo'