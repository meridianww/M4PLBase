
UPDATE dbo.DashboardCategoryRelation
SET CustomQuery = ' AND JOBDL000Master.JobType <> ''RETURN'' AND JOBDL000Master.JobGatewayStatus = ''In Transit'''
WHERE DashboardCategoryRelationId = 1

UPDATE dbo.DashboardCategoryRelation
SET CustomQuery = ' AND JOBDL000Master.JobType <> ''RETURN'' AND JOBDL000Master.JobGatewayStatus = ''On Hand'''
WHERE DashboardCategoryRelationId = 2

UPDATE dbo.DashboardCategoryRelation
SET CustomQuery = ' AND JOBDL000Master.JobType <> ''RETURN'' AND JOBDL000Master.JobGatewayStatus = ''On Truck'''
WHERE DashboardCategoryRelationId = 3

UPDATE dbo.DashboardCategoryRelation
SET CustomQuery = ' AND (JOBDL000Master.JobType = ''RETURN'')'
WHERE DashboardCategoryRelationId = 4

UPDATE dbo.DashboardCategoryRelation
SET CustomQuery = ' AND JOBDL000Master.JobDeliveryDateTimePlanned < DATEADD(DD, 0 , GETUTCDATE()) AND JOBDL000Master.JobType <> ''RETURN'' AND JOBDL000Master.JobGatewayStatus = ''In Transit''  '
WHERE DashboardCategoryRelationId = 5

UPDATE dbo.DashboardCategoryRelation
SET CustomQuery = ' AND JOBDL000Master.JobDeliveryDateTimePlanned < DATEADD(DD, 0 , GETUTCDATE()) AND JOBDL000Master.JobType <> ''RETURN'' AND JOBDL000Master.JobGatewayStatus = ''On Hand''  '
WHERE DashboardCategoryRelationId = 6

UPDATE dbo.DashboardCategoryRelation
SET CustomQuery = ' AND JOBDL000Master.JobDeliveryDateTimePlanned < DATEADD(DD, 0 , GETUTCDATE()) AND JOBDL000Master.JobType <> ''RETURN'' AND JOBDL000Master.JobGatewayStatus = ''On Truck''  '
WHERE DashboardCategoryRelationId = 7

UPDATE dbo.DashboardCategoryRelation
SET CustomQuery = ' AND JOBDL000Master.JobDeliveryDateTimePlanned < DATEADD(DD, 0 , GETUTCDATE()) AND (JOBDL000Master.JobType = ''RETURN'') '
WHERE DashboardCategoryRelationId = 8

UPDATE dbo.DashboardCategoryRelation
SET CustomQuery = ' AND DATEDIFF(DD, JOBDL000Master.JobDeliveryDateTimePlanned , GETDATE()) = 0 AND JOBDL000Master.JobType <> ''RETURN'' AND JOBDL000Master.JobGatewayStatus = ''In Transit''  '
WHERE DashboardCategoryRelationId = 9

UPDATE dbo.DashboardCategoryRelation
SET CustomQuery = ' AND DATEDIFF(DD, JOBDL000Master.JobDeliveryDateTimePlanned , GETDATE()) = 0 AND JOBDL000Master.JobType <> ''RETURN'' AND JOBDL000Master.JobGatewayStatus = ''On Hand''  '
WHERE DashboardCategoryRelationId = 10

UPDATE dbo.DashboardCategoryRelation
SET CustomQuery = ' AND DATEDIFF(DD, JOBDL000Master.JobDeliveryDateTimePlanned , GETDATE()) = 0 AND JOBDL000Master.JobType <> ''RETURN'' AND JOBDL000Master.JobGatewayStatus = ''On Truck''  '
WHERE DashboardCategoryRelationId = 11

UPDATE dbo.DashboardCategoryRelation
SET CustomQuery = ' AND DATEDIFF(DD, JOBDL000Master.JobDeliveryDateTimePlanned , GETDATE()) = 0 AND (JOBDL000Master.JobType = ''RETURN'') '
WHERE DashboardCategoryRelationId = 12


