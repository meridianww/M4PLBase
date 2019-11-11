/****** Object:  StoredProcedure [dbo].[GetVocReportData]    Script Date: 11/11/2019 12:55:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- EXEC [dbo].[GetVocReportData] 10007,'ADVRLALBR',NULL,NULL
-- =============================================
CREATE PROCEDURE [dbo].[GetVocReportData] 
@CompanyId BIGINT, 
@LocationCode NVARCHAR(50),
@StartDate DATETIME2,
@EndDate DATETIME2
AS
BEGIN
	SET NOCOUNT ON;

CREATE TABLE #LocationCodes(JobSiteCode NVARCHAR(50));

IF(@LocationCode IS NULL OR @LocationCode = '')
BEGIN
	IF(@CompanyId IS NOT NULL AND @CompanyId>0)
	BEGIN
		INSERT INTO #LocationCodes 
		SELECT DISTINCT JobSiteCode FROM JOBDL000Master 
		WHERE ProgramID IN (
		   SELECT ID FROM PRGRM000Master WHERE StatusId IN (1,2) AND PrgCustID =@CompanyId
		 )
		 AND JobSiteCode IS NOT NULL 
		 AND JobSiteCode <> '' 
		 AND StatusId IN (1,2)
    END
END
ELSE
BEGIN
   INSERT INTO #LocationCodes VALUES(@LocationCode)
END

SELECT SVYUSER000Master.Id UserID,MVOC000Program.Id,LocationCode AS Location
	,EntityTypeId AS 'JobID'
	,Max(SVYUSER000Master.DriverId) AS Driver
	,sum(CASE 
			WHEN MVOC010Ref_Questions.QueTitle = 'Delivery Satisfaction'
				THEN SelectedAnswer * 4
			ELSE 0
			END) 'DeliverySatisfaction'
	,sum(CASE 
			WHEN MVOC010Ref_Questions.QueTitle = 'CSR Professionalism'
				THEN SelectedAnswer * 4
			ELSE 0
			END) 'CSRProfessionalism'
	,sum(CASE 
			WHEN MVOC010Ref_Questions.QueTitle = 'Advance Delivery Time'
				THEN SelectedAnswer * 4
			ELSE 0
			END) 'AdvanceDeliveryTime'
	,sum(CASE 
			WHEN MVOC010Ref_Questions.QueTitle = 'Driver Professionalism'
				THEN SelectedAnswer * 4
			ELSE 0
			END) 'DriverProfessionalism'
	,sum(CASE 
			WHEN MVOC010Ref_Questions.QueTitle = 'Delivery Team Helpfulness'
				THEN SelectedAnswer * 4
			ELSE 0
			END) 'DeliveryTeamHelpfulness'
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
		) * 4 AS 'OverallScore'
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
		AND LocationCode IN (SELECT JobSiteCode FROM #LocationCodes) 		
		OR ( VocDateOpen>=@StartDate AND VocDateClose<=@EndDate )
		
GROUP BY LocationCode
	,EntityTypeId,MVOC000Program.Id,SVYUSER000Master.Id

	DROP TABLE #LocationCodes;
END
