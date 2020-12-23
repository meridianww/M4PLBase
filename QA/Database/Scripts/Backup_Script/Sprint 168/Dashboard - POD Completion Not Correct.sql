DECLARE @DashboardCategoryId int, @DashboardSubCategoryId int
SELECT @DashboardCategoryId = DashboardCategoryId FROM DashboardCategory WHERE DashboardCategoryName = 'Other'
SELECT @DashboardSubCategoryId = DashboardSubCategoryId FROM DashboardSubCategory WHERE DashboardSubCategoryName = 'NoPODUpload'
UPDATE DashboardCategoryRelation 
SET CustomQuery = ' AND JOBDL000Master.JobGatewayStatus like ''%Delivered%'' AND JOBDL000Master.Id Not In (SELECT JobRef.JobId FROM [dbo].[JOBDL040DocumentReference] JobRef INNER JOIN [dbo].[SYSTM020Ref_Attachments] Att ON JobRef.Id=Att.AttPrimaryRecordId AND AttTableName=''JobDocReference'' AND AttData IS NOT NULL INNER JOIN [dbo].[SYSTM000Ref_Options] Opt ON Opt.Id = JobRef.DocTypeId AND Opt.SysLookupCode = ''DocReferenceType'' and Opt.SysOptionName = ''POD'' AND Att.StatusId=1 AND JobRef.StatusId=1) '
WHERE DashboardCategoryId = @DashboardCategoryId AND DashboardSubCategory = @DashboardSubCategoryId 