UPDATE dbo.SYSTM000Ref_Options SET SysDefault = 0 Where SysLookupCode = 'UnitType' AND SysOptionName = 'Cabs'
IF NOT EXISTS(Select 1 From dbo.SYSTM000Ref_Options Where SysLookupCode = 'UnitType' AND SysOptionName = 'Each')
BEGIN
INSERT INTO dbo.SYSTM000Ref_Options (SysLookupId, SysLookupCode, SysOptionName, SysSortOrder, SysDefault, IsSysAdmin, StatusId, DateEntered, EnteredBy, DateChanged, ChangedBy)
VALUES (46, 'UnitType', 'Each', 9, 1, 0, 1, GetUTCDate(), NULL, NULL, NULL)
END