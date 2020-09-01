CREATE VIEW dbo.vwJobPrideMatrixReport
AS
SELECT Job.Id JobId
	,CASE 
		WHEN CAST(Job.JobDeliveryDateTimeActual AS TIME) < '17:00:00'
			THEN 1
		ELSE 0
		END FivePMDeliveryWindow
	,CASE 
		WHEN ISNULL(Job.JobOriginDateTimeActual, '') <> ''
			AND ISNULL(Gateway.GwyGatewayACD, '') <> ''
			AND Job.JobOriginDateTimeActual > Gateway.GwyGatewayACD
			THEN 1
		ELSE 0
		END ApptScheduledReceiving
	,CASE 
		WHEN ISNULL(ISNULL(Cargo.Maxdate, Job.JobDeliveryDateTimeActual),'') <> ''
			AND ISNULL(Job.WindowDelStartTime, '') <> ''
			AND ISNULL(Job.WindowDelEndTime, '') <> ''
			AND CAST(RIGHT(CONVERT(VARCHAR, Job.WindowDelStartTime, 100), 7) AS TIME) >= CAST(RIGHT(CONVERT(VARCHAR, ISNULL(Cargo.Maxdate, Job.JobDeliveryDateTimeActual), 100), 7) AS TIME)
			AND CAST(RIGHT(CONVERT(VARCHAR, Job.WindowDelEndTime, 100), 7) AS TIME) <= CAST(RIGHT(CONVERT(VARCHAR, ISNULL(Cargo.Maxdate, Job.JobDeliveryDateTimeActual), 100), 7) AS TIME)
			THEN 1
		ELSE 0
		END FourHrWindowDelivery
FROM JobDL000Master Job
LEFT JOIN (SELECT  JobId,MAX(CgoDateLastScan) MaxDate FROM dbo.JobDL010Cargo GROUP BY JobId) Cargo ON Cargo.JobId = Job.Id
LEFT JOIN dbo.JOBDL020Gateways Gateway ON Gateway.JobId = Job.Id
	AND GwyGatewayCode = 'Schedule'
	AND Gateway.StatusId = 1