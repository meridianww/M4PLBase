IF NOT EXISTS (Select 1 From dbo.SYSTM000Master Where SysMessageCode = 'CreateSalesOrder')
BEGIN
INSERT INTO dbo.SYSTM000Master (LangCode, SysMessageCode, SysRefId, SysMessageScreenTitle, SysMessageTitle, SysMessageDescription, SysMessageInstruction, SysMessageButtonSelection, StatusId, DateEntered, EnteredBy)
VALUES ('EN', 'CreateSalesOrder', 41, 'Info', 'Data Created', 'Sales Order Generated Successfully in Dynamics NAV, Created Sales Order Id is: {0}.', NULL, 'Ok', 1, GetDate(), 'nfujimoto')
END

IF NOT EXISTS (Select 1 From dbo.SYSTM000Master Where SysMessageCode = 'UpdateSalesOrder')
BEGIN
INSERT INTO dbo.SYSTM000Master (LangCode, SysMessageCode, SysRefId, SysMessageScreenTitle, SysMessageTitle, SysMessageDescription, SysMessageInstruction, SysMessageButtonSelection, StatusId, DateEntered, EnteredBy)
VALUES ('EN', 'UpdateSalesOrder', 41, 'Info', 'Data Created', 'Sales Order Updated Successfully in Dynamics NAV, Updated Sales Order Id is: {0}.', NULL, 'Ok', 1, GetDate(), 'nfujimoto')
END


