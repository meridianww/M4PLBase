IF NOT EXISTS(SELECT 1 FROM DashboardType WHERE DashboardName='IT')
BEGIN
	INSERT INTO dbo.DashboardType (DashboardName, DashboardDisplayName)
	VALUES ('IT', 'IT')
END

IF NOT EXISTS(SELECT 1 FROM Dashboard WHERE DashboardName='IT')
BEGIN
	INSERT INTO dbo.Dashboard (DashboardTypeId, CreatedDate, DashboardName)
	VALUES (2, GETUTCDATE(), 'IT')
END
DECLARE @Dashboard_Id INT
SELECT @Dashboard_Id = DashboardId FROM dbo.Dashboard WHERE DashboardName='IT'
DECLARE @COUNT INT;
SELECT @COUNT = MAX(DashboardCategoryId) + 1 FROM DashboardCategory
IF NOT EXISTS(SELECT 1 FROM DashboardCategory WHERE DashboardCategoryName='EDI')
BEGIN
	INSERT INTO dbo.DashboardCategory (DashboardCategoryName, DashboardCategoryDisplayName, SortOrder)
	VALUES ('EDI ', 'EDI', @COUNT)
END

IF NOT EXISTS(SELECT 1 FROM DashboardSubCategory WHERE DashboardSubCategoryName='EDIFailuer')
BEGIN
	INSERT INTO dbo.DashboardSubCategory (DashboardSubCategoryName, DashboardSubCategoryDisplayName, IsActive)
	VALUES ('EDIFailuer', 'EDI Failuer', 1)
END

IF NOT EXISTS(SELECT 1 FROM DashboardSubCategory WHERE DashboardSubCategoryName='xCBLFailuer')
BEGIN
	INSERT INTO dbo.DashboardSubCategory (DashboardSubCategoryName, DashboardSubCategoryDisplayName, IsActive)
	VALUES ('xCBLFailuer', 'xCBL Failuer', 1)	
END
DECLARE @DashBoardId INT,@SubDashBoardId INT
SELECT @DashBoardId = DashboardCategoryId FROM DashboardCategory WHERE DashboardCategoryName='EDI'
SELECT @SubDashBoardId = DashboardSubCategoryId FROM DashboardSubCategory WHERE DashboardSubCategoryName='EDIFailuer'
IF NOT EXISTS(SELECT 1 FROM DashboardCategoryRelation WHERE DashboardCategoryId=@DashBoardId AND DashboardSubCategory=@SubDashBoardId)
BEGIN
	INSERT INTO dbo.DashboardCategoryRelation (DashboardId, DashboardCategoryId, DashboardSubCategory, CustomQuery, BackGroundColor, FontColor)
	VALUES (@Dashboard_Id, @DashBoardId, @SubDashBoardId, ' ', '#FFFF00', '#000000')
END

SELECT @DashBoardId = DashboardCategoryId  FROM DashboardCategory WHERE DashboardCategoryName='xCBL';
SELECT @SubDashBoardId = DashboardSubCategoryId FROM DashboardSubCategory WHERE DashboardSubCategoryName='xCBLFailuer'
IF NOT EXISTS(SELECT 1 FROM DashboardCategoryRelation WHERE DashboardCategoryId=@DashBoardId AND DashboardSubCategory=@SubDashBoardId)
BEGIN
    SELECT @SubDashBoardId = MAX(DashboardSubCategoryId) FROM DashboardSubCategory
	INSERT INTO dbo.DashboardCategoryRelation (DashboardId, DashboardCategoryId, DashboardSubCategory, CustomQuery, BackGroundColor, FontColor)
	VALUES (@Dashboard_Id, @DashBoardId, @SubDashBoardId, ' ', '#FFFF00', '#000000')
END
