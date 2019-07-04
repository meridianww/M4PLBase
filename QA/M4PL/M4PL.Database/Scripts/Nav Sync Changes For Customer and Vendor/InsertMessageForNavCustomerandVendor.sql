IF NOT EXISTS (Select 1 From dbo.SYSTM000Master Where SysMessageCode = 'NavVendor')
BEGIN
INSERT INTO dbo.SYSTM000Master (LangCode, SysMessageCode, SysRefId, SysMessageScreenTitle, SysMessageTitle, SysMessageDescription, SysMessageInstruction, SysMessageButtonSelection, StatusId, DateEntered, EnteredBy, DateChanged, ChangedBy)
VALUES ('EN', 'NavVendor', 41, 'Info', 'Data Updated', 'Vendor records have been synced successfully with Dynamics NAV.', NULL, 'Ok', 1, GETUTCDATE(), 'SimonDekker', NULL, NULL)
END

IF NOT EXISTS (Select 1 From dbo.SYSTM000Master Where SysMessageCode = 'NavCustomer')
BEGIN
INSERT INTO dbo.SYSTM000Master (LangCode, SysMessageCode, SysRefId, SysMessageScreenTitle, SysMessageTitle, SysMessageDescription, SysMessageInstruction, SysMessageButtonSelection, StatusId, DateEntered, EnteredBy, DateChanged, ChangedBy)
VALUES ('EN', 'NavCustomer', 41, 'Info', 'Data Updated', 'Customer records have been synced successfully with Dynamics NAV.', NULL, 'Ok', 1, GETUTCDATE(), 'SimonDekker', NULL, NULL)
END