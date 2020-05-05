Declare @SysLookupId BIGINT
IF NOT EXISTS(Select 1 From SYSTM000Ref_Lookup Where LkupCode = 'AgreementType')
BEGIN
INSERT INTO SYSTM000Ref_Lookup (LkupCode,LkUpTableName)
Values ('AgreementType','Global')
END
Select @SysLookupId = Id From SYSTM000Ref_Lookup Where LkupCode = 'AgreementType'

IF NOT EXISTS(Select 1 From SYSTM000Ref_Options Where SysLookupId = @SysLookupId AND SysLookupCode = 'AgreementType' AND SysOptionName = 'Yes')
BEGIN
INSERT INTO SYSTM000Ref_Options (SysLookupId, SysLookupCode,SysOptionName,SysSortOrder, SysDefault,IsSysAdmin,StatusId,DateEntered)
Values (@SysLookupId, 'AgreementType', 'Yes', 1, 1, 0, 1, getutcdate())
END

IF NOT EXISTS(Select 1 From SYSTM000Ref_Options Where SysLookupId = @SysLookupId AND SysLookupCode = 'AgreementType' AND SysOptionName = 'No')
BEGIN
INSERT INTO SYSTM000Ref_Options (SysLookupId, SysLookupCode,SysOptionName,SysSortOrder, SysDefault,IsSysAdmin,StatusId,DateEntered)
Values (@SysLookupId, 'AgreementType', 'No', 1, 1, 0, 1, getutcdate())
END

