SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[JobSurveyByLocationView]
AS 
SELECT ISNULL(Job.Id,0) JobId
	,CASE 
		WHEN (svyusr.LocationCode IS NULL)
			THEN 'Unknown'
		ELSE svyusr.LocationCode
		END AS LocationCode
	, CASE WHEN (Count(svyusr.ContractNumber) / 5) = 0 THEN 0 ELSE (Sum(IIf([mvoqns].[QueTitle] = 'Delivery Satisfaction', [SelectedAnswer] * 4, 0)) + Sum(IIf([mvoqns].[QueTitle] = 'CSR Professionalism', [SelectedAnswer] * 4, 0)) + Sum(IIf([mvoqns].[QueTitle] = 'Advance Delivery Time', [SelectedAnswer] * 4, 0)) + Sum(IIf([mvoqns].[QueTitle] = 'Driver Professionalism', [SelectedAnswer] * 4, 0)) + Sum(IIf([mvoqns].[QueTitle] = 'Delivery Team Helpfulness', [SelectedAnswer] * 4, 0))) / (Count(svyusr.ContractNumber) / 5) END AS [OverallScore]
FROM MVOC000Program prgm
INNER JOIN SVYUSER000Master svyusr ON prgm.Id = svyusr.SurveyId
INNER JOIN SVYANS000Master svyans ON svyans.SurveyUserId = svyusr.Id
INNER JOIN MVOC010Ref_Questions mvoqns ON svyans.QuestionId = mvoqns.Id
INNER JOIN dbo.JobDL000Master Job ON Job.JobSiteCode = svyusr.LocationCode
WHERE (
		((svyusr.LocationCode) IS NOT NULL)
		OR ((svyusr.DriverId) IS NOT NULL)
		OR ((svyusr.ContractNumber) IS NOT NULL)
		)
GROUP BY svyusr.LocationCode
	,Job.Id
GO


