IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.DashboardSubCategory WHERE DashboardSubcategoryName = 'LoadOnTruck' AND DashboardSubcategoryDisplayName='Load On Truck')
BEGIN
	INSERT INTO dbo.DashboardSubCategory (DashboardSubcategoryName, DashboardSubcategoryDisplayName)
	VALUES ('LoadOnTruck', 'Load On Truck')
END
GO