SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Copyright (2018) Meridian Worldwide Transportation Group
-- All Rights Reserved Worldwide
-- Author:		Nathan Fujimoto
-- Create date: 10/29/2018
-- Description:	The stored procedure Updates the Job Master Route, Driver and Stop fields from the Scanner Order table
-- =============================================
CREATE PROCEDURE [dbo].[scanUpdateJobRouteInfo]
	-- Add the parameters for the stored procedure here
	@JobId bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
BEGIN TRY                  
	SET NOCOUNT ON;

    Update JOBDL000Master 
	Set 
		JobRouteId = ISNULL(scan.JobFlag21, JobRouteId), 
		JobDriverId = ISNULL(scan.JobFlag22, JobDriverId), 
		JobStop = ISNULL(scan.JobFlag23, JobStop)
		
	FROM (
		Select JobID,
				JobFlag21, 
				JobFlag22,
				JobFlag23
		FROM SCN000Order) scan
	WHERE JOBDL000Master.ID = scan.JobID AND scan.JobID = @JobId
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
END
GO
