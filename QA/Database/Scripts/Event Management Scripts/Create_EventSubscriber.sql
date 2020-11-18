IF NOT EXISTS(Select 1 From dbo.EventSubscriber Where SubscriberId = 1)
BEGIN
INSERT INTO dbo.EventSubscriber (SubscriberId, SubscriberDescription)
Values (1,'Customer')
END
IF NOT EXISTS(Select 1 From dbo.EventSubscriber Where SubscriberId = 2)
BEGIN
INSERT INTO dbo.EventSubscriber (SubscriberId, SubscriberDescription)
Values (2,'Vendor')
END
IF NOT EXISTS(Select 1 From dbo.EventSubscriber Where SubscriberId = 3)
BEGIN
INSERT INTO dbo.EventSubscriber (SubscriberId, SubscriberDescription)
Values (3,'Custom')
END