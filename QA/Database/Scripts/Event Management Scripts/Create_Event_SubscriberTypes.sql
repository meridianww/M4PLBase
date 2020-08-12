IF NOT EXISTS(Select 1 From [dbo].[EventSubscriberType] Where Id = 1)
BEGIN
INSERT INTO [dbo].[EventSubscriberType] (Id, [EventSubscriberTypeName])
Values (1,'To')
END
IF NOT EXISTS(Select 1 From [dbo].[EventSubscriberType] Where Id = 2)
BEGIN
INSERT INTO [dbo].[EventSubscriberType] (Id, [EventSubscriberTypeName])
Values (2,'CC')
END