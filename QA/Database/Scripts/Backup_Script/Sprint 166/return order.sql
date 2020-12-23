

UPDATE DashboardCategoryRelation SET CustomQuery=' AND (JOBDL000Master.JobCompleted=0 AND JOBDL000Master.JobType = ''RETURN'')' WHERE DashboardCategoryRelationId=4
UPDATE DashboardCategoryRelation SET CustomQuery
=' AND JOBDL000Master.JobCompleted=0 AND JOBDL000Master.JobDeliveryDateTimePlanned < DATEADD(DD, 0 , GETUTCDATE()) AND (JOBDL000Master.JobType = ''RETURN'') '
WHERE DashboardCategoryRelationId=8
UPDATE DashboardCategoryRelation SET CustomQuery
=' AND JOBDL000Master.JobCompleted=0 AND DATEDIFF(DD, JOBDL000Master.JobDeliveryDateTimePlanned , GETDATE()) = 0 AND (JOBDL000Master.JobType = ''RETURN'') '
WHERE DashboardCategoryRelationId=12
