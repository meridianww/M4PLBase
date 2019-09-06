  Declare @ColLookupId INT, @ColLookupCode Varchar(50)
  Select @ColLookupId = [ColLookupId], @ColLookupCode = [ColLookupCode] From [dbo].[SYSTM000ColumnsAlias] Where ColTableName='JobCargo' AND ColColumnName='CgoQtyUnits'
  UPDATE [dbo].[SYSTM000ColumnsAlias] SET [ColLookupId] = @ColLookupId, [ColLookupCode] = @ColLookupCode Where ColTableName='Job' AND ColColumnName='JobQtyUnitTypeId'

  UPDATE [dbo].[SYSTM000ColumnsAlias] SET [ColIsReadOnly] = 0 Where ColTableName='Job' AND ColColumnName='JobQtyOrdered'