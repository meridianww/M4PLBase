SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Copyright (2018) Meridian Worldwide Transportation Group
-- All Rights Reserved Worldwide
-- Author:		Nathan Fujimoto
-- Create date: 6/9/2018
-- Description:	The stored procedure returns the jobs that are ready to be uploaded from the Scanner Tables and Update the Job Tables
-- =============================================
CREATE PROCEDURE [dbo].[scanUpdateJobHeaderComplete] 
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	MERGE INTO JOBDL000Master jobs
	USING SCN000Order scanJobs
	ON jobs.Id = scanJobs.JobId AND scanJobs.[JobFlag12] = 'U'
	WHEN MATCHED THEN
		UPDATE SET
		 JobRouteId = scanJobs.[RouteID],
		JobDriverId = scanJobs.[DriverID],
		JobStop = scanJobs.[JobStop],
		JobSignLongitude = scanJobs.[JobLongitude],
		JobSignLatitude = scanJobs.[JobLatitude],
		JobSignText = scanJobs.[JobSignText],
		JobCompleted = 1,
		JobDeliveryDateTimeActual = convert(datetime, scanJobs.[JobActualDate],103) + CAST(scanJobs.[JobActualTime] as DATETIME), --scanJobs.[JobActualDate] + scanJobs.[JobActualTime],
		ProFlags12 = scanJobs.[JobFlag12], 
		ProFlags13 = scanJobs.[JobFlag13];

END
GO
