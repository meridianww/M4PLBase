	DELETE FROM DashboardCategoryRelation
	DBCC CHECKIDENT ('DashboardCategoryRelation', RESEED, 0)
DECLARE @DashboardId INT,@DashboardCategoryId INT,@DashboardSubCategoryId INT ; 
SELECT @DashboardId = DashboardId FROM Dashboard WHERE DashboardName = 'Default_Job'
SELECT @DashboardCategoryId=DashboardCategoryId FROM dbo.DashboardCategory WHERE DashboardCategoryName = 'NotScheduled'
SELECT @DashboardSubCategoryId=DashboardSubCategoryId FROM DashboardSubCategory WHERE DashboardSubCategoryName = 'InTransit'

------------------ Start--- Not Scheduled  ------------------------------------------------------------------------------
IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.DashboardCategoryRelation WHERE DashboardSubCategory = @DashboardSubCategoryId AND DashboardCategoryId = @DashboardCategoryId )
BEGIN
	INSERT INTO dbo.DashboardCategoryRelation (DashboardId, DashboardCategoryId, DashboardSubCategory, CustomQuery,BackGroundColor,FontColor)
	VALUES  (@DashboardId, @DashboardCategoryId, @DashboardSubCategoryId,
	 ' AND JobCard.JobDeliveryDateTimePlanned is null and Gateway.Id IN (SELECT MAX(Id) LatestGatewayId FROM JOBDL020Gateways WHERE ISNULL(GwyCompleted,0) = 1  GROUP BY JobID ) AND Gateway.GwyOrderType <> ''RETURN'' AND Gateway.GwyGatewayCode = ''In Transit'' AND ISNULL(Gateway.GwyCompleted,0) = 1 ','#FFFF00' , '#000000')
END


SELECT @DashboardSubCategoryId=DashboardSubCategoryId FROM DashboardSubCategory WHERE DashboardSubCategoryName = 'OnHand'


IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.DashboardCategoryRelation WHERE DashboardSubCategory = @DashboardSubCategoryId AND DashboardCategoryId = @DashboardCategoryId )
BEGIN
	INSERT INTO dbo.DashboardCategoryRelation (DashboardId, DashboardCategoryId, DashboardSubCategory, CustomQuery ,BackGroundColor,FontColor)
	VALUES (@DashboardId, @DashboardCategoryId, @DashboardSubCategoryId,
	 ' AND JobCard.JobDeliveryDateTimePlanned is null AND Gateway.Id IN (SELECT MAX(Id) LatestGatewayId FROM JOBDL020Gateways WHERE ISNULL(GwyCompleted,0) = 1  GROUP BY JobID ) AND Gateway.GwyOrderType <> ''RETURN'' AND Gateway.GwyGatewayCode = ''On Hand'' AND ISNULL(Gateway.GwyCompleted,0) = 1 ','#FF0000','#ffffff')
 END


SELECT @DashboardSubCategoryId=DashboardSubCategoryId FROM DashboardSubCategory WHERE DashboardSubCategoryName = 'LoadOnTruck'
IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.DashboardCategoryRelation WHERE DashboardSubCategory = @DashboardSubCategoryId AND DashboardCategoryId = @DashboardCategoryId )
BEGIN
	INSERT INTO dbo.DashboardCategoryRelation (DashboardId, DashboardCategoryId, DashboardSubCategory, CustomQuery,BackGroundColor,FontColor)
	VALUES (@DashboardId, @DashboardCategoryId, @DashboardSubCategoryId,
	 ' AND JobCard.JobDeliveryDateTimePlanned is null AND Gateway.Id IN (SELECT MAX(Id) LatestGatewayId FROM JOBDL020Gateways WHERE ISNULL(GwyCompleted,0) = 1  GROUP BY JobID ) AND Gateway.GwyOrderType <> ''RETURN'' AND Gateway.GwyGatewayCode = ''On Truck'' AND ISNULL(Gateway.GwyCompleted,0) = 1 ','#149414','#ffffff')
END


SELECT @DashboardSubCategoryId=DashboardSubCategoryId FROM DashboardSubCategory WHERE DashboardSubCategoryName = 'Returns'
IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.DashboardCategoryRelation WHERE DashboardSubCategory = @DashboardSubCategoryId AND DashboardCategoryId = @DashboardCategoryId )
BEGIN
	INSERT INTO dbo.DashboardCategoryRelation (DashboardId, DashboardCategoryId, DashboardSubCategory, CustomQuery,BackGroundColor,FontColor)
	VALUES  (@DashboardId, @DashboardCategoryId, @DashboardSubCategoryId,' AND JobCard.JobDeliveryDateTimePlanned is null AND (Gateway.GwyOrderType = ''RETURN'' OR JobCard.JobType=''RETURN'') ','#FFFF00' , '#000000')
END


------------------ End--- Not Scheduled  ------------------------------------------------------------------------------



------------------ Start--- Schedule Past Due ------------------------------------------------------------------------------
--Schedule Past Due--
SELECT @DashboardCategoryId=DashboardCategoryId FROM dbo.DashboardCategory WHERE DashboardCategoryName = 'SchedulePastDue'

SELECT @DashboardSubCategoryId=DashboardSubCategoryId FROM DashboardSubCategory WHERE DashboardSubCategoryName = 'InTransit'

IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.DashboardCategoryRelation WHERE DashboardSubCategory = @DashboardSubCategoryId AND DashboardCategoryId = @DashboardCategoryId )
BEGIN
    INSERT INTO dbo.DashboardCategoryRelation (DashboardId, DashboardCategoryId, DashboardSubCategory, CustomQuery,BackGroundColor,FontColor)
	VALUES  (@DashboardId, @DashboardCategoryId, @DashboardSubCategoryId,
	 ' AND JobCard.JobDeliveryDateTimePlanned < DATEADD(DD, 0 , GETUTCDATE()) AND Gateway.Id IN (SELECT MAX(Id) LatestGatewayId FROM JOBDL020Gateways WHERE ISNULL(GwyCompleted,0) = 1 AND GatewayTypeId = 85  GROUP BY JobID ) AND Gateway.GwyOrderType <> ''RETURN'' AND Gateway.GwyGatewayCode = ''In Transit'' AND ISNULL(Gateway.GwyCompleted,0) = 1 ','#FF0000','#ffffff')
END

SELECT @DashboardSubCategoryId=DashboardSubCategoryId FROM DashboardSubCategory WHERE DashboardSubCategoryName = 'OnHand'

IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.DashboardCategoryRelation WHERE DashboardSubCategory = @DashboardSubCategoryId AND DashboardCategoryId = @DashboardCategoryId )
BEGIN
	INSERT INTO dbo.DashboardCategoryRelation (DashboardId, DashboardCategoryId, DashboardSubCategory, CustomQuery,BackGroundColor,FontColor)
	VALUES (@DashboardId, @DashboardCategoryId, @DashboardSubCategoryId,
	 ' AND JobCard.JobDeliveryDateTimePlanned < DATEADD(DD, 0 , GETUTCDATE()) AND Gateway.Id IN (SELECT MAX(Id) LatestGatewayId FROM JOBDL020Gateways WHERE ISNULL(GwyCompleted,0) = 1 AND GatewayTypeId = 85 GROUP BY JobID ) AND Gateway.GwyOrderType <> ''RETURN'' AND Gateway.GwyGatewayCode = ''On Hand'' AND ISNULL(Gateway.GwyCompleted,0) = 1 ','#149414','#ffffff')
 END


SELECT @DashboardSubCategoryId=DashboardSubCategoryId FROM DashboardSubCategory WHERE DashboardSubCategoryName = 'LoadOnTruck'
IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.DashboardCategoryRelation WHERE DashboardSubCategory = @DashboardSubCategoryId AND DashboardCategoryId = @DashboardCategoryId )
BEGIN
	INSERT INTO dbo.DashboardCategoryRelation (DashboardId, DashboardCategoryId, DashboardSubCategory, CustomQuery,BackGroundColor,FontColor)
	VALUES (@DashboardId, @DashboardCategoryId, @DashboardSubCategoryId,
	 ' AND JobCard.JobDeliveryDateTimePlanned < DATEADD(DD, 0 , GETUTCDATE()) AND Gateway.Id IN (SELECT MAX(Id) LatestGatewayId FROM JOBDL020Gateways WHERE ISNULL(GwyCompleted,0) = 1 AND GatewayTypeId = 85 GROUP BY JobID ) AND Gateway.GwyOrderType <> ''RETURN'' AND Gateway.GwyGatewayCode = ''On Truck'' AND ISNULL(Gateway.GwyCompleted,0) = 1 ','#149414','#ffffff')
END


SELECT @DashboardSubCategoryId=DashboardSubCategoryId FROM DashboardSubCategory WHERE DashboardSubCategoryName = 'Returns'
IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.DashboardCategoryRelation WHERE DashboardSubCategory = @DashboardSubCategoryId AND DashboardCategoryId = @DashboardCategoryId )
BEGIN
	INSERT INTO dbo.DashboardCategoryRelation (DashboardId, DashboardCategoryId, DashboardSubCategory, CustomQuery,BackGroundColor,FontColor)
	VALUES  (@DashboardId, @DashboardCategoryId, @DashboardSubCategoryId, ' AND JobCard.JobDeliveryDateTimePlanned < DATEADD(DD, 0 , GETUTCDATE()) AND (Gateway.GwyOrderType = ''RETURN'' OR JobCard.JobType=''RETURN'') ','#149414','#ffffff')
END


------------------ End--- Schedule Past Due ------------------------------------------------------------------------------


---------------------Start ScheduledForToday ---------------------------------------------------------------------------------


SELECT @DashboardCategoryId=DashboardCategoryId FROM dbo.DashboardCategory WHERE DashboardCategoryName = 'ScheduledForToday'
SELECT @DashboardSubCategoryId=DashboardSubCategoryId FROM DashboardSubCategory WHERE DashboardSubCategoryName = 'InTransit'

IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.DashboardCategoryRelation WHERE DashboardSubCategory = @DashboardSubCategoryId AND DashboardCategoryId = @DashboardCategoryId )
BEGIN
	INSERT INTO dbo.DashboardCategoryRelation (DashboardId, DashboardCategoryId, DashboardSubCategory, CustomQuery,BackGroundColor,FontColor)
	VALUES  (@DashboardId, @DashboardCategoryId, @DashboardSubCategoryId,
	 ' AND DATEDIFF(DD, JobCard.JobDeliveryDateTimePlanned , GETDATE()) = 0 AND Gateway.Id IN (SELECT MAX(Id) LatestGatewayId FROM JOBDL020Gateways WHERE ISNULL(GwyCompleted,0) = 1 AND GatewayTypeId = 85 GROUP BY JobID ) AND Gateway.GwyOrderType <> ''RETURN'' AND Gateway.GwyGatewayCode = ''In Transit'' AND ISNULL(Gateway.GwyCompleted,0) = 1 ','#FFFF00' , '#000000')
END

SELECT @DashboardSubCategoryId=DashboardSubCategoryId FROM DashboardSubCategory WHERE DashboardSubCategoryName = 'OnHand'
IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.DashboardCategoryRelation WHERE DashboardSubCategory = @DashboardSubCategoryId AND DashboardCategoryId = @DashboardCategoryId )
BEGIN
	INSERT INTO dbo.DashboardCategoryRelation (DashboardId, DashboardCategoryId, DashboardSubCategory, CustomQuery,BackGroundColor,FontColor)
	VALUES (@DashboardId, @DashboardCategoryId, @DashboardSubCategoryId,
	 ' AND DATEDIFF(DD, JobCard.JobDeliveryDateTimePlanned , GETDATE()) = 0 AND Gateway.Id IN (SELECT MAX(Id) LatestGatewayId FROM JOBDL020Gateways WHERE ISNULL(GwyCompleted,0) = 1 AND GatewayTypeId = 85 GROUP BY JobID ) AND Gateway.GwyOrderType <> ''RETURN'' AND Gateway.GwyGatewayCode = ''On Hand'' AND ISNULL(Gateway.GwyCompleted,0) = 1 ','#FFFF00' , '#000000')
 END


SELECT @DashboardSubCategoryId=DashboardSubCategoryId FROM DashboardSubCategory WHERE DashboardSubCategoryName = 'LoadOnTruck'
IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.DashboardCategoryRelation WHERE DashboardSubCategory = @DashboardSubCategoryId AND DashboardCategoryId = @DashboardCategoryId )
BEGIN
	INSERT INTO dbo.DashboardCategoryRelation (DashboardId, DashboardCategoryId, DashboardSubCategory, CustomQuery,BackGroundColor,FontColor)
	VALUES (@DashboardId, @DashboardCategoryId, @DashboardSubCategoryId,
	 ' AND DATEDIFF(DD, JobCard.JobDeliveryDateTimePlanned , GETDATE()) = 0 AND Gateway.Id IN (SELECT MAX(Id) LatestGatewayId FROM JOBDL020Gateways WHERE ISNULL(GwyCompleted,0) = 1 AND GatewayTypeId = 85 GROUP BY JobID ) AND Gateway.GwyOrderType <> ''RETURN'' AND Gateway.GwyGatewayCode = ''On Truck'' AND ISNULL(Gateway.GwyCompleted,0) = 1 ','#FFFF00' , '#000000')
END


SELECT @DashboardSubCategoryId=DashboardSubCategoryId FROM DashboardSubCategory WHERE DashboardSubCategoryName = 'Returns'
IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.DashboardCategoryRelation WHERE DashboardSubCategory = @DashboardSubCategoryId AND DashboardCategoryId = @DashboardCategoryId )
BEGIN
	INSERT INTO dbo.DashboardCategoryRelation (DashboardId, DashboardCategoryId, DashboardSubCategory, CustomQuery,BackGroundColor,FontColor)
	VALUES  (@DashboardId, @DashboardCategoryId, @DashboardSubCategoryId, ' AND DATEDIFF(DD, JobCard.JobDeliveryDateTimePlanned , GETDATE()) = 0 AND (Gateway.GwyOrderType = ''RETURN'' OR JobCard.JobType=''RETURN'') ','#FFFF00' , '#000000')
END
GO


---------------------End ScheduledForToday ---------------------------------------------------------------------------------
