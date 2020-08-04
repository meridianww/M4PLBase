SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */
-- =============================================          
-- Author:                    Kamal          
-- Create date:               07/27/2020      
-- Description:               Get a Job Details by job id  
-- Exec :					  Exec GetSearchJobOrders 'pod'   
-- ============================================= 
ALTER PROCEDURE GetSearchJobOrders 
--@userId BIGINT,
--@roleId BIGINT,
--@orgId BIGINT = 1,
@search NVARCHAR(200)
AS
BEGIN
   SELECT Id
		 ,JobCustomerSalesOrder AS CustomerSalesOrder
         ,JobGatewayStatus AS GatewayStatus
		 ,JobDeliveryDateTimePlanned AS DeliveryDatePlanned
		 ,JobOriginDateTimePlanned AS ArrivalDatePlanned FROM JOBDL000Master 
   WHERE StatusId = 1 AND --JobCompleted =0 
    (JobCustomerSalesOrder LIKE '%'+ @search +'%'
   OR JobBOL LIKE '%'+ @search +'%'
   OR JobManifestNo LIKE '%'+ @search +'%'
   OR JobGatewayStatus LIKE '%'+ @search +'%'
   OR JobSiteCode LIKE '%'+ @search +'%')
END

