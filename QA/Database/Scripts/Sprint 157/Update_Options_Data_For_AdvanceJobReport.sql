Declare @LookupId INT
IF NOT EXISTS(Select 1 From dbo.SYSTM000Ref_Lookup Where LkupCode = 'JobReportType')
BEGIN
INSERT INTO dbo.SYSTM000Ref_Lookup (LkupCode, LkupTableName)
VALUES ('JobReportType', 'Global')
END

Select @LookupId = Id From dbo.SYSTM000Ref_Lookup Where LkupCode = 'JobReportType'
IF NOT EXISTS (Select 1 From dbo.SYSTM000Ref_Options Where SysLookupCode = 'JobReportType' AND SysOptionName = 'Job Advance Report')
BEGIN
INSERT INTO dbo.SYSTM000Ref_Options (SysLookupId, SysLookupCode, SysOptionName, SysSortOrder, SysDefault,StatusId)
VALUES (@LookupId, 'JobReportType', 'Job Advance Report', 1, 1,1)
END
IF NOT EXISTS (Select 1 From dbo.SYSTM000Ref_Options Where SysLookupCode = 'JobReportType' AND SysOptionName = 'Manifest Report')
BEGIN
INSERT INTO dbo.SYSTM000Ref_Options (SysLookupId, SysLookupCode, SysOptionName, SysSortOrder, SysDefault,StatusId)
VALUES (@LookupId, 'JobReportType', 'Manifest Report', 2, 0,1)
END
IF NOT EXISTS (Select 1 From dbo.SYSTM000Ref_Options Where SysLookupCode = 'JobReportType' AND SysOptionName = 'Transaction Summary')
BEGIN
INSERT INTO dbo.SYSTM000Ref_Options (SysLookupId, SysLookupCode, SysOptionName, SysSortOrder, SysDefault,StatusId)
VALUES (@LookupId, 'JobReportType', 'Transaction Summary', 3, 0,1)
END
IF NOT EXISTS (Select 1 From dbo.SYSTM000Ref_Options Where SysLookupCode = 'JobReportType' AND SysOptionName = 'Transaction Locations')
BEGIN
INSERT INTO dbo.SYSTM000Ref_Options (SysLookupId, SysLookupCode, SysOptionName, SysSortOrder, SysDefault,StatusId)
VALUES (@LookupId, 'JobReportType', 'Transaction Locations', 4, 0,1)
END
IF NOT EXISTS (Select 1 From dbo.SYSTM000Ref_Options Where SysLookupCode = 'JobReportType' AND SysOptionName = 'Transaction Jobs')
BEGIN
INSERT INTO dbo.SYSTM000Ref_Options (SysLookupId, SysLookupCode, SysOptionName, SysSortOrder, SysDefault,StatusId)
VALUES (@LookupId, 'JobReportType', 'Transaction Jobs', 5, 0,1)
END
