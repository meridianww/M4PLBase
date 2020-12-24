If NOT EXISTS (SELECT 1 FROM SYSTM000Ref_Options WHERE SysOptionName = 'All' And SysLookupCode = 'Status')
BEGIN
INSERT INTO dbo.SYSTM000Ref_Options (SysLookupId, SysLookupCode, SysOptionName, SysSortOrder, SysDefault, IsSysAdmin, StatusId, DateEntered, EnteredBy, DateChanged, ChangedBy)
VALUES (39, 'Status', 'All', 1, 1, 0, 1, GETDATE(), NULL, GETDATE(), 'nfujimoto')


UPDATE dbo.SYSTM000Ref_Options 
SET     SysSortOrder = 1 
WHERE 	SysOptionName = 'All' And SysLookupCode = 'Status'

UPDATE dbo.SYSTM000Ref_Options
SET     SysSortOrder = 2 ,SysDefault = 1
WHERE 	SysOptionName = 'Active' And SysLookupCode = 'Status'

UPDATE dbo.SYSTM000Ref_Options
SET     SysSortOrder = 3 
WHERE 	SysOptionName = 'Inactive' And SysLookupCode = 'Status'


UPDATE dbo.SYSTM000Ref_Options
SET     SysSortOrder = 4 
WHERE 	SysOptionName = 'Archive' And SysLookupCode = 'Status'

END