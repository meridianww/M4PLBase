
IF NOT EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = 'DashboardSubCategory' AND COLUMN_NAME = 'IsActive') 
BEGIN
	ALTER TABLE DashboardSubCategory
	ADD IsActive BIT NOT NULL DEFAULT 1
END

UPDATE DashboardSubCategory SET IsActive = 0 WHERE DashboardSubCategoryName IN ('GPSCoordinates','ScheduleChange') 