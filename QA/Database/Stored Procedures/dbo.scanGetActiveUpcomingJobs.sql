SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Copyright (2018) Meridian Worldwide Transportation Group
-- All Rights Reserved Worldwide
-- Author:		Nathan Fujimoto
-- Create date: 6/9/2018
-- Description:	The stored procedure returns the active upcoming jobs within the next X amount of days
-- =============================================
CREATE PROCEDURE [dbo].[scanGetActiveUpcomingJobs]
	-- Add the parameters for the stored procedure here
	@JobStatusId int,
	@NumberOfDaysOut nvarchar,
	@ShortDateFormat int,
	@ShortTimeFormat int 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT
           ID
		   ,ProgramID
           ,JobRouteId
           ,JobDriverId
           ,JobStop
           ,JobCustomerSalesOrder           
		   ,JobBOL
		   ,JobManifestNo
		   ,JobBOLMaster
		   ,JobBOLChild
           ,JobSiteCode
           ,JobOriginSiteCode
           ,JobOriginSiteName
           ,JobDeliverySitePOC
           ,JobDeliverySitePOC2
           ,JobDeliveryStreetAddress
           ,JobDeliveryStreetAddress2
           ,JobDeliveryCity
           ,JobDeliveryState
           ,JobDeliveryPostalCode
           ,JobDeliveryCountry
           ,JobDeliverySitePOCPhone
           ,JobDeliverySitePOCPhone2
           ,JobDeliveryRecipientPhone
           ,JobDeliverySitePOCEmail
           ,JobDeliverySitePOCEmail2
           ,JobLongitude
           ,JobLatitude
           ,JobDeliveryDateTimeBaseline
           ,JobDeliveryDateTimePlanned 
           ,'JobFor'
           ,'JobFrom'
		   FROM JOBDL000Master 
		   WHERE JOBDL000Master.JobDeliveryDateTimePlanned < DATEADD(day,Convert(Int,@NumberOfDaysOut),GETDATE()) 
		   AND JOBDL000Master.ProFlags12 Is NULL AND JOBDL000Master.StatusId = @JobStatusId
		   

END
GO
