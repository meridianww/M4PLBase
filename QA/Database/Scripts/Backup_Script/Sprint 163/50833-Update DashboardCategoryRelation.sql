

DECLARE @dashboardCategoryRelationId BIGINT=0;

	SELECT @dashboardCategoryRelationId=DashboardCategoryRelationId
	FROM DashboardCategoryRelation DCR
	INNER JOIN dbo.Dashboard D ON D.DashboardId = DCR.DashboardId
	INNER JOIN dbo.DashboardCategory DC ON DC.DashboardCategoryId = DCR.DashboardCategoryId
	INNER JOIN dbo.DashboardSubCategory DSC ON DSC.DashboardSubCategoryId = DCR.DashboardSubCategory AND DSC.IsActive = 1
	WHERE DashboardCategoryName='Other' AND DashboardSubCategoryName='NoPODUpload'
	select @dashboardCategoryRelationId

	UPDATE DashboardCategoryRelation 
	SET CustomQuery=' AND JOBDL000Master.JobGatewayStatus like ''%Delivered%'' AND 
	  JOBDL000Master.Id Not In (SELECT JobRef.JobId
	  FROM [dbo].[JOBDL040DocumentReference] JobRef
	  INNER JOIN [dbo].[SYSTM020Ref_Attachments] Att
	  ON JobRef.Id=Att.AttPrimaryRecordId AND AttTableName=''JobDocReference'' AND AttData IS NOT NULL
	  AND Att.StatusId=1
	  AND JobRef.StatusId=1) '
	WHERE DashboardCategoryRelationId=@dashboardCategoryRelationId
