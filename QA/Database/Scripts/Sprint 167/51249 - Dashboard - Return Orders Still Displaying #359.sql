	
	DECLARE @dashboardCategoryRelationId BIGINT=0;
	
	SELECT @dashboardCategoryRelationId=DashboardCategoryRelationId   	
	FROM DashboardCategoryRelation DCR
	INNER JOIN dbo.Dashboard D ON D.DashboardId = DCR.DashboardId
	INNER JOIN dbo.DashboardCategory DC ON DC.DashboardCategoryId = DCR.DashboardCategoryId
	INNER JOIN dbo.DashboardSubCategory DSC ON DSC.DashboardSubCategoryId = DCR.DashboardSubCategory AND DSC.IsActive = 1
	WHERE DashboardCategoryName='NotScheduled'
	AND DashboardSubCategoryName='Returns'
	PRINT @dashboardCategoryRelationId

	UPDATE DashboardCategoryRelation 
	SET CustomQuery=' AND (JOBDL000Master.JobCompleted=0 AND JOBDL000Master.JobType = ''RETURN'' AND JOBDL000Master.JobIsSchedule=0)'
	WHERE DashboardCategoryRelationId=@dashboardCategoryRelationId