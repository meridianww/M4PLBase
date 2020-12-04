
IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'DockSize' AND Object_ID = Object_ID(N'dbo.LocationProjectedCapacity'))
BEGIN
	ALTER TABLE LocationProjectedCapacity
	ADD DockSize BIGINT NULL 
END


UPDATE LocationProjectedCapacity SET DockSize=0