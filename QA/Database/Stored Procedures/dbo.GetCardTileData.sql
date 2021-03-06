SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Kamal
-- Create date: 24-05-2019
-- Description: Get card tile datas
-- EXEC [dbo].[GetCardTileData] 
-- =============================================

CREATE PROCEDURE [dbo].[GetCardTileData] 
AS
BEGIN
	IF OBJECT_ID('tempdb..#TempCount') IS NOT NULL
	BEGIN
		DROP TABLE #TempCount
	END

	CREATE TABLE #TempCount (
		ID INT IDENTITY(1, 1)
		,DashboardCategoryRelationId BIGINT
		,CustomQuery VARCHAR(5000)
		,DashboardName VARCHAR(150)
		,DashboardCategoryDisplayName VARCHAR(150)
		,DashboardSubCategoryDisplayName VARCHAR(150)
		,DashboardCategoryName VARCHAR(150)
		,DashboardSubCategoryName VARCHAR(150)
		,BackGroundColor nvarchar(100) 
		,FontColor nvarchar(100)
		,RecordCount INT
		,SortOrder INT
		)

	INSERT INTO #TempCount (
		 DashboardCategoryRelationId
		,DashboardName
		,DashboardCategoryDisplayName
		,DashboardSubCategoryDisplayName
		,DashboardCategoryName
		,DashboardSubCategoryName
		,BackGroundColor
		,FontColor
		,CustomQuery
		,RecordCount
		,SortOrder
		)
	SELECT DCR.DashboardCategoryRelationId
		,D.DashboardName
		,DC.DashboardCategoryDisplayName
		,DSC.DashboardSubCategoryDisplayName
		,DC.DashboardCategoryName
		,DSC.DashboardSubCategoryName
		,DCR.BackGroundColor
		,DCR.FontColor
		,DCR.CustomQuery
		,0
		,DC.SortOrder
	FROM DashboardCategoryRelation DCR
	INNER JOIN dbo.Dashboard D ON D.DashboardId = DCR.DashboardId
	INNER JOIN dbo.DashboardCategory DC ON DC.DashboardCategoryId = DCR.DashboardCategoryId
	INNER JOIN dbo.DashboardSubCategory DSC ON DSC.DashboardSubCategoryId = DCR.DashboardSubCategory AND DSC.IsActive = 1

	
	SELECT *
	FROM #TempCount

	DROP TABLE #TempCount
END

GO
