
IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DashboardCategory' AND COLUMN_NAME = 'SortOrder')
BEGIN
	ALTER TABLE DashboardCategory
	ADD SortOrder INT
END


UPDATE DashboardCategory SET SortOrder=1 WHERE DashboardCategoryId =1
UPDATE DashboardCategory SET SortOrder=2 WHERE DashboardCategoryId =2
UPDATE DashboardCategory SET SortOrder=3 WHERE DashboardCategoryId =3
UPDATE DashboardCategory SET SortOrder=4 WHERE DashboardCategoryId =5
UPDATE DashboardCategory SET SortOrder=5 WHERE DashboardCategoryId =4