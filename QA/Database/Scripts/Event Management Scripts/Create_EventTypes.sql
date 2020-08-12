IF NOT EXISTS(Select 1 From [dbo].[EventType] Where Id = 1)
BEGIN
INSERT INTO dbo.EventType (Id,EventName,EventDisplayName)
Values (1, 'Admin', 'Admin')
END
IF NOT EXISTS(Select 1 From [dbo].[EventType] Where Id = 2)
BEGIN
INSERT INTO dbo.EventType (Id,EventName,EventDisplayName)
Values (2, 'Customer', 'Customer')
END
IF NOT EXISTS(Select 1 From [dbo].[EventType] Where Id = 3)
BEGIN
INSERT INTO dbo.EventType (Id,EventName,EventDisplayName)
Values (3, 'Vendor', 'Vendor')
END
IF NOT EXISTS(Select 1 From [dbo].[EventType] Where Id = 4)
BEGIN
INSERT INTO dbo.EventType (Id,EventName,EventDisplayName)
Values (4, 'Program', 'Program')
END