SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwGetVocReportData]
AS
SELECT MVOC000Program.Id,LocationCode AS Location
	,EntityTypeId AS 'Job ID'
	,Max(SVYUSER000Master.DriverId) AS Driver
	,sum(CASE 
			WHEN MVOC010Ref_Questions.QueTitle = 'Delivery Satisfaction'
				THEN SelectedAnswer * 4
			ELSE 0
			END) 'Delivery Satisfaction'
	,sum(CASE 
			WHEN MVOC010Ref_Questions.QueTitle = 'CSR Professionalism'
				THEN SelectedAnswer * 4
			ELSE 0
			END) 'CSR Professionalism'
	,sum(CASE 
			WHEN MVOC010Ref_Questions.QueTitle = 'Advance Delivery Time'
				THEN SelectedAnswer * 4
			ELSE 0
			END) 'Advance Delivery Time'
	,sum(CASE 
			WHEN MVOC010Ref_Questions.QueTitle = 'Driver Professionalism'
				THEN SelectedAnswer * 4
			ELSE 0
			END) 'Driver Professionalism'
	,sum(CASE 
			WHEN MVOC010Ref_Questions.QueTitle = 'Delivery Team Helpfulness'
				THEN SelectedAnswer * 4
			ELSE 0
			END) 'Delivery Team Helpfulness'
	,(
		sum(CASE 
				WHEN MVOC010Ref_Questions.QueTitle = 'Delivery Satisfaction'
					THEN SelectedAnswer
				ELSE 0
				END) + sum(CASE 
				WHEN MVOC010Ref_Questions.QueTitle = 'CSR Professionalism'
					THEN SelectedAnswer
				ELSE 0
				END) + sum(CASE 
				WHEN MVOC010Ref_Questions.QueTitle = 'Advance Delivery Time'
					THEN SelectedAnswer
				ELSE 0
				END) + sum(CASE 
				WHEN MVOC010Ref_Questions.QueTitle = 'Driver Professionalism'
					THEN SelectedAnswer
				ELSE 0
				END) + sum(CASE 
				WHEN MVOC010Ref_Questions.QueTitle = 'Delivery Team Helpfulness'
					THEN SelectedAnswer
				ELSE 0
				END)
		) * 4 AS 'Overall Score'
FROM (
	MVOC000Program INNER JOIN (
		SVYANS000Master INNER JOIN SVYUSER000Master ON SVYANS000Master.SurveyUserId = SVYUSER000Master.Id
		) ON MVOC000Program.Id = SVYUSER000Master.SurveyId
	)
INNER JOIN MVOC010Ref_Questions ON SVYANS000Master.QuestionId = MVOC010Ref_Questions.Id
WHERE (
		((SVYUSER000Master.EntityTypeId) IS NOT NULL)
		AND ((SVYUSER000Master.LocationCode) IS NOT NULL)
		)
GROUP BY LocationCode
	,EntityTypeId,MVOC000Program.Id

GO
