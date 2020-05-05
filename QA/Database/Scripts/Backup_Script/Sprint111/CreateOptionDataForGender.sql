Declare @SysLookupId BIGINT
IF NOT EXISTS(Select 1 From SYSTM000Ref_Lookup Where LkupCode = 'Gender')
BEGIN
INSERT INTO SYSTM000Ref_Lookup (LkupCode,LkUpTableName)
Values ('Gender','Global')
END
Select @SysLookupId = Id From SYSTM000Ref_Lookup Where LkupCode = 'Gender'

IF NOT EXISTS(Select 1 From SYSTM000Ref_Options Where SysLookupId = @SysLookupId AND SysLookupCode = 'Gender' AND SysOptionName = 'Male')
BEGIN
INSERT INTO SYSTM000Ref_Options (SysLookupId, SysLookupCode,SysOptionName,SysSortOrder, SysDefault,IsSysAdmin,StatusId,DateEntered)
Values (@SysLookupId, 'Gender', 'Male', 1, 1, 0, 1, getutcdate())
END

IF NOT EXISTS(Select 1 From SYSTM000Ref_Options Where SysLookupId = @SysLookupId AND SysLookupCode = 'Gender' AND SysOptionName = 'Female')
BEGIN
INSERT INTO SYSTM000Ref_Options (SysLookupId, SysLookupCode,SysOptionName,SysSortOrder, SysDefault,IsSysAdmin,StatusId,DateEntered)
Values (@SysLookupId, 'Gender', 'Female', 1, 1, 0, 1, getutcdate())
END

IF NOT EXISTS(Select 1 From SYSTM000Ref_Options Where SysLookupId = @SysLookupId AND SysLookupCode = 'Gender' AND SysOptionName = 'Other')
BEGIN
INSERT INTO SYSTM000Ref_Options (SysLookupId, SysLookupCode,SysOptionName,SysSortOrder, SysDefault,IsSysAdmin,StatusId,DateEntered)
Values (@SysLookupId, 'Gender', 'Other', 1, 1, 0, 1, getutcdate())
END