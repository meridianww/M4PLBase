SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Copyright (2018) Meridian Worldwide Transportation Group
-- All Rights Reserved Worldwide
-- Author:		Nathan Fujimoto
-- Create date: 6/2/2018
-- Description:	The stored procedure returns the completed active gateways for jobs that have EDI Status codes and have not been processed yet.
-- =============================================
CREATE PROCEDURE [dbo].[ediGetActiveCompleteEdiGateways]  
 -- Add the parameters for the stored procedure here  
 @ProgramId bigint,  
 @JobStatusId int,  
 @GatewayStatusId int  
  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  
    -- Insert statements for procedure here  
 SELECT JOBDL000Master.ProgramID, JOBDL000Master.Id, JOBDL020Gateways.Id,  JOBDL000Master.JobBOL, JOBDL000Master.JobManifestNo,   
  JOBDL000Master.JobCustomerSalesOrder, JOBDL000Master.JobSiteCode, JOBDL000Master.JobDeliverySiteName, JOBDL000Master.JobDeliveryStreetAddress,   
  JOBDL000Master.JobDeliveryStreetAddress2, JOBDL000Master.JobDeliveryCity, JOBDL000Master.JobDeliveryState, JOBDL000Master.JobDeliveryPostalCode,   
  JOBDL000Master.JobDeliveryCountry, JOBDL000Master.JobOriginCity, JOBDL000Master.JobOriginState, JOBDL000Master.JobOriginCountry,   
  JOBDL000Master.JobLatitude, JOBDL000Master.JobLongitude, JOBDL020Gateways.Id, JOBDL020Gateways.GwyGatewayCode, JOBDL020Gateways.GwyGatewayACD,   
  JOBDL020Gateways.GwyCompleted, JOBDL020Gateways.StatusId, JOBDL020Gateways.GwyShipStatusReasonCode, JOBDL020Gateways.GwyShipApptmtReasonCode,   
     JOBDL000Master.JobRouteId, JOBDL000Master.JobSignText, JOBDL020Gateways.ProFlags02, JOBDL000Master.CarrierID, JOBDL000Master.JobType, 
	 JOBDL000Master.JobWeightUnitTypeId, JOBDL000Master.JobTotalWeight, JOBDL000Master.JobQtyActual, JOBDL000Master.JobPartsActual, JOBDL000Master.JobTotalCubes, JOBDL000Master.JobCubesUnitTypeId
 FROM JOBDL020Gateways INNER JOIN JOBDL000Master ON JOBDL020Gateways.JobID = JOBDL000Master.Id  
 WHERE JOBDL000Master.ProgramID=@ProgramId AND JOBDL000Master.StatusId=@JobStatusId AND JOBDL020Gateways.StatusId=@GatewayStatusId AND JOBDL020Gateways.GwyCompleted = 1   
  AND JOBDL020Gateways.ProFlags02 Is Null AND JOBDL020Gateways.GwyShipStatusReasonCode Is Not NUll AND JOBDL020Gateways.GwyShipApptmtReasonCode IS NOT NULL  
END
GO
