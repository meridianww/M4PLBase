IF NOT EXISTS (Select 1 From dbo.SYSTM000Master Where SysMessageCode = 'CreateSalesOrder')
BEGIN
INSERT INTO dbo.SYSTM000Master (LangCode, SysMessageCode, SysRefId, SysMessageScreenTitle, SysMessageTitle, SysMessageDescription, SysMessageInstruction, SysMessageButtonSelection, StatusId, DateEntered, EnteredBy)
VALUES ('EN', 'CreateSalesOrder', 41, 'Info', 'Data Created', 'Sales Order Generated Successfully in Dynamics NAV.', NULL, 'Ok', 1, GetDate(), 'nfujimoto')
END

IF NOT EXISTS (Select 1 From dbo.SYSTM000Master Where SysMessageCode = 'UpdateSalesOrder')
BEGIN
INSERT INTO dbo.SYSTM000Master (LangCode, SysMessageCode, SysRefId, SysMessageScreenTitle, SysMessageTitle, SysMessageDescription, SysMessageInstruction, SysMessageButtonSelection, StatusId, DateEntered, EnteredBy)
VALUES ('EN', 'UpdateSalesOrder', 41, 'Info', 'Data Created', 'Sales Order Updated Successfully in Dynamics NAV.', NULL, 'Ok', 1, GetDate(), 'nfujimoto')
END

IF NOT EXISTS (Select 1 From dbo.SYSTM000Master Where SysMessageCode = 'SalesOrderExists')
BEGIN
INSERT INTO dbo.SYSTM000Master (LangCode, SysMessageCode, SysRefId, SysMessageScreenTitle, SysMessageTitle, SysMessageDescription, SysMessageInstruction, SysMessageButtonSelection, StatusId, DateEntered, EnteredBy)
VALUES ('EN', 'SalesOrderExists', 41, 'Info', 'Exists', 'There is already a Sales Order Present for the job.', NULL, 'Ok', 1, GetDate(), 'nfujimoto')
END

IF NOT EXISTS (Select 1 From dbo.SYSTM000Master Where SysMessageCode = 'SalesOrderCreationFailure')
BEGIN
INSERT INTO dbo.SYSTM000Master (LangCode, SysMessageCode, SysRefId, SysMessageScreenTitle, SysMessageTitle, SysMessageDescription, SysMessageInstruction, SysMessageButtonSelection, StatusId, DateEntered, EnteredBy)
VALUES ('EN', 'SalesOrderCreationFailure', 41, 'Info', 'Exists', 'Sales order not generated in NAV.', NULL, 'Ok', 1, GetDate(), 'nfujimoto')
END




