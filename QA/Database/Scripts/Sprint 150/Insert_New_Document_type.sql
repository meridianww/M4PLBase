IF NOT EXISTS (SELECT 1 FROM dbo.SYSTM000Ref_Options WHERE sysLookupCode ='JobDocReferenceType' AND SysOptionName ='Signature')
BEGIN
INSERT INTO dbo.SYSTM000Ref_Options (SysLookupId, SysLookupCode, SysOptionName, SysSortOrder, SysDefault, IsSysAdmin, StatusId, DateEntered, EnteredBy, DateChanged, ChangedBy)
VALUES (1010, 'JobDocReferenceType', 'Signature', 6, 0, 0, 1, GetDate(), 'system', NULL, NULL)
END

