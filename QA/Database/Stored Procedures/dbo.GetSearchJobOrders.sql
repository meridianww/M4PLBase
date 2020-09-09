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
-- Exec :					  Exec GetSearchJobOrders null,0,0,'july'   
-- ============================================= 
ALTER PROCEDURE GetSearchJobOrders @userId BIGINT
	,@roleId BIGINT
	,@orgId BIGINT = 1
	,@search NVARCHAR(200)
AS
BEGIN
	IF (
			@userId = 0
			AND @roleId = 0
			AND @orgId = 0
			)
	BEGIN
		SELECT JOB.Id
			,JOB.JobCustomerSalesOrder AS CustomerSalesOrder
			,JOB.JobGatewayStatus AS GatewayStatus
			,JOB.JobDeliveryDateTimePlanned AS DeliveryDatePlanned
			,JOB.JobOriginDateTimePlanned AS ArrivalDatePlanned
		FROM JOBDL000Master JOB
		WHERE JOB.JobCustomerSalesOrder = @search
	END
	ELSE
	BEGIN
		DECLARE @IsJobAdmin BIT = 0

		IF OBJECT_ID('tempdb..#EntityIdTemp') IS NOT NULL
		BEGIN
			DROP TABLE #EntityIdTemp
		END

		CREATE TABLE #EntityIdTemp (EntityId BIGINT)

		INSERT INTO #EntityIdTemp
		EXEC [dbo].[GetCustomEntityIdByEntityName] @userId
			,@roleId
			,@orgId
			,'JOB'

		IF EXISTS (
				SELECT 1
				FROM #EntityIdTemp
				WHERE ISNULL(EntityId, 0) = - 1
				)
		BEGIN
			SET @IsJobAdmin = 1
		END

		IF (@IsJobAdmin = 0)
		BEGIN
			SELECT JOB.Id
				,JOB.JobCustomerSalesOrder AS CustomerSalesOrder
				,JOB.JobGatewayStatus AS GatewayStatus
				,JOB.JobDeliveryDateTimePlanned AS DeliveryDatePlanned
				,JOB.JobOriginDateTimePlanned AS ArrivalDatePlanned
			FROM CUST000Master CUST
			INNER JOIN PRGRM000Master PRG ON PRG.PrgCustID = CUST.Id
				AND CUST.StatusId = 1
			INNER JOIN JOBDL000Master JOB ON JOB.ProgramID = PRG.ID
				AND PRG.StatusId = 1
				AND JOB.StatusId = 1
			INNER JOIN #EntityIdTemp tmp ON tmp.[EntityId] = JOB.[Id]
			WHERE (
					CUST.CustTitle LIKE '%' + @search + '%'
					OR JOB.JobCustomerSalesOrder LIKE '%' + @search + '%'
					OR JobBOL LIKE '%' + @search + '%'
					OR JobBOLMaster LIKE '%' + @search + '%'
					OR JobManifestNo LIKE '%' + @search + '%'
					OR JobGatewayStatus LIKE '%' + @search + '%'
					OR JobSiteCode LIKE '%' + @search + '%'
					OR JobDeliveryStreetAddress LIKE '%' + @search + '%'
					OR JobDeliveryStreetAddress2 LIKE '%' + @search + '%'
					OR JobDeliveryStreetAddress3 LIKE '%' + @search + '%'
					OR JobDeliveryCity LIKE '%' + @search + '%'
					OR JobDeliveryState LIKE '%' + @search + '%'
					OR JobDeliveryPostalCode LIKE '%' + @search + '%'
					OR JobCarrierContract LIKE '%' + @search + '%'
					OR JobDeliverySitePOC LIKE '%' + @search + '%'
					OR JobDeliverySiteName LIKE '%' + @search + '%'
					OR PlantIDCode LIKE '%' + @search + '%'
					OR JobSellerSiteName LIKE '%' + @search + '%'
					)
		END
		ELSE
		BEGIN
			SELECT JOB.Id
				,JOB.JobCustomerSalesOrder AS CustomerSalesOrder
				,JOB.JobGatewayStatus AS GatewayStatus
				,JOB.JobDeliveryDateTimePlanned AS DeliveryDatePlanned
				,JOB.JobOriginDateTimePlanned AS ArrivalDatePlanned
			FROM CUST000Master CUST
			INNER JOIN PRGRM000Master PRG ON PRG.PrgCustID = CUST.Id
				AND CUST.StatusId = 1
			INNER JOIN JOBDL000Master JOB ON JOB.ProgramID = PRG.ID
				AND PRG.StatusId = 1
				AND JOB.StatusId = 1
			WHERE (
					CUST.CustTitle LIKE '%' + @search + '%'
					OR JOB.JobCustomerSalesOrder LIKE '%' + @search + '%'
					OR JobBOL LIKE '%' + @search + '%'
					OR JobBOLMaster LIKE '%' + @search + '%'
					OR JobManifestNo LIKE '%' + @search + '%'
					OR JobGatewayStatus LIKE '%' + @search + '%'
					OR JobSiteCode LIKE '%' + @search + '%'
					OR JobDeliveryStreetAddress LIKE '%' + @search + '%'
					OR JobDeliveryStreetAddress2 LIKE '%' + @search + '%'
					OR JobDeliveryStreetAddress3 LIKE '%' + @search + '%'
					OR JobDeliveryCity LIKE '%' + @search + '%'
					OR JobDeliveryState LIKE '%' + @search + '%'
					OR JobDeliveryPostalCode LIKE '%' + @search + '%'
					OR JobCarrierContract LIKE '%' + @search + '%'
					OR JobDeliverySitePOC LIKE '%' + @search + '%'
					OR JobDeliverySiteName LIKE '%' + @search + '%'
					OR PlantIDCode LIKE '%' + @search + '%'
					OR JobSellerSiteName LIKE '%' + @search + '%'
					)
		END
	END
END