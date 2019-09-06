Declare @EDIConditionFieldId INT, @EDIConditionOperationTypeId INT, @EDIConditionSiteTypeId INT

IF NOT EXISTS (Select 1 From [SYSTM000Ref_Lookup] Where LkupCode = 'EDIConditionField')
BEGIN
INSERT INTO [SYSTM000Ref_Lookup] (LkupCode,LkupTableName) Values ('EDIConditionField', 'Global')
END

IF NOT EXISTS (Select 1 From [SYSTM000Ref_Lookup] Where LkupCode = 'EDIConditionOperationType')
BEGIN
INSERT INTO [SYSTM000Ref_Lookup] (LkupCode,LkupTableName) Values ('EDIConditionOperationType', 'Global')
END

IF NOT EXISTS (Select 1 From [SYSTM000Ref_Lookup] Where LkupCode = 'EDIConditionSiteType')
BEGIN
INSERT INTO [SYSTM000Ref_Lookup] (LkupCode,LkupTableName) Values ('EDIConditionSiteType', 'Global')
END

Select @EDIConditionFieldId = Id From [SYSTM000Ref_Lookup] Where LkupCode = 'EDIConditionField'
Select @EDIConditionOperationTypeId = Id From [SYSTM000Ref_Lookup] Where LkupCode = 'EDIConditionOperationType'
Select @EDIConditionSiteTypeId = Id From [SYSTM000Ref_Lookup] Where LkupCode = 'EDIConditionSiteType'


IF NOT EXISTS(Select 1 From [SYSTM000Ref_Options] Where SysLookupId = @EDIConditionFieldId AND SysOptionName = 'Site Code')
BEGIN
INSERT INTO [SYSTM000Ref_Options] (SysLookupId, SysLookupCode,SysOptionName, SysSortOrder, StatusId, DateEntered, EnteredBy)
Values (@EDIConditionFieldId, 'EDIConditionField', 'Site Code', 1, 1, GetDate(),'nfujimoto')
END

IF NOT EXISTS(Select 1 From [SYSTM000Ref_Options] Where SysLookupId = @EDIConditionFieldId AND SysOptionName = 'Order Prefix')
BEGIN
INSERT INTO [SYSTM000Ref_Options] (SysLookupId, SysLookupCode,SysOptionName, SysSortOrder, StatusId, DateEntered, EnteredBy)
Values (@EDIConditionFieldId, 'EDIConditionField', 'Order Prefix', 1, 1, GetDate(),'nfujimoto')
END

IF NOT EXISTS(Select 1 From [SYSTM000Ref_Options] Where SysLookupId = @EDIConditionOperationTypeId AND SysOptionName = 'AND')
BEGIN
INSERT INTO [SYSTM000Ref_Options] (SysLookupId, SysLookupCode,SysOptionName, SysSortOrder, StatusId, DateEntered, EnteredBy)
Values (@EDIConditionOperationTypeId, 'EDIConditionOperationType', 'AND', 1, 1, GetDate(),'nfujimoto')
END

IF NOT EXISTS(Select 1 From [SYSTM000Ref_Options] Where SysLookupId = @EDIConditionOperationTypeId AND SysOptionName = 'OR')
BEGIN
INSERT INTO [SYSTM000Ref_Options] (SysLookupId, SysLookupCode,SysOptionName, SysSortOrder, StatusId, DateEntered, EnteredBy)
Values (@EDIConditionOperationTypeId, 'EDIConditionOperationType', 'OR', 1, 1, GetDate(),'nfujimoto')
END

IF NOT EXISTS(Select 1 From [SYSTM000Ref_Options] Where SysLookupId = @EDIConditionSiteTypeId AND SysOptionName = 'Site Code')
BEGIN
INSERT INTO [SYSTM000Ref_Options] (SysLookupId, SysLookupCode,SysOptionName, SysSortOrder, StatusId, DateEntered, EnteredBy)
Values (@EDIConditionSiteTypeId, 'EDIConditionSiteType', 'Site Code', 1, 1, GetDate(),'nfujimoto')
END

IF NOT EXISTS(Select 1 From [SYSTM000Ref_Options] Where SysLookupId = @EDIConditionSiteTypeId AND SysOptionName = 'City, State')
BEGIN
INSERT INTO [SYSTM000Ref_Options] (SysLookupId, SysLookupCode,SysOptionName, SysSortOrder, StatusId, DateEntered, EnteredBy)
Values (@EDIConditionSiteTypeId, 'EDIConditionSiteType', 'City, State', 1, 1, GetDate(),'nfujimoto')
END

UPDATE SYSTM000ColumnsAlias 
SET ColLookupId = @EDIConditionFieldId,ColLookupCode = 'EDIConditionField'
Where ColTableName='PrgEdiCondition' AND ColColumnName='PecJobField'

UPDATE SYSTM000ColumnsAlias 
SET ColLookupId = @EDIConditionOperationTypeId,ColLookupCode = 'EDIConditionOperationType'
Where ColTableName='PrgEdiCondition' AND ColColumnName='PecCondition'

UPDATE SYSTM000ColumnsAlias 
SET ColLookupId = @EDIConditionOperationTypeId,ColLookupCode = 'EDIConditionOperationType'
Where ColTableName='PrgEdiCondition' AND ColColumnName='PecCondition2'

UPDATE SYSTM000ColumnsAlias 
SET ColLookupId = @EDIConditionSiteTypeId,ColLookupCode = 'EDIConditionSiteType'
Where ColTableName='PrgEdiCondition' AND ColColumnName='PecJobField2'

