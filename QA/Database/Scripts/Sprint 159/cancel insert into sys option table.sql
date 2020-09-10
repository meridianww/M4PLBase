DECLARE @MaxCountID INT
IF NOT EXISTS(SELECT 1 FROM SYSTM000Ref_Options WHERE SysLookupCode='Status' AND SysOptionName ='Canceled')
BEGIN
    SELECT @MaxCountID = MAX(ID) FROM SYSTM000Ref_Options WHERE SysLookupCode='Status'
	INSERT INTO dbo.SYSTM000Ref_Options (SysLookupId, SysLookupCode, SysOptionName, SysSortOrder, SysDefault, IsSysAdmin, StatusId, DateEntered, EnteredBy, DateChanged, ChangedBy)
	VALUES (39, 'Status', 'Canceled', @MaxCountID, 0, 0, 1, '2017-05-04 12:50:39.99', NULL, '2019-12-05 10:54:42.613', 'nfujimoto')
END