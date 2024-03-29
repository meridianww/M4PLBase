SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               01/31/2018      
-- Description:               Get a JobSeller 
-- Execution:                 EXEC [dbo].[GetJobSeller]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================  
CREATE PROCEDURE [dbo].[GetJobSeller] @userId BIGINT
	,@roleId BIGINT
	,@orgId BIGINT
	,@id BIGINT
	,@parentId BIGINT
	,@Pacifictime DATETIME2(7)
AS
BEGIN TRY
	SET NOCOUNT ON;

	IF @id = 0
	BEGIN
		DECLARE @pickupTime TIME
			,@deliveryTime TIME

		SELECT @pickupTime = CAST(PrgPickUpTimeDefault AS TIME)
			,@deliveryTime = CAST(PrgDeliveryTimeDefault AS TIME)
		FROM PRGRM000MASTER
		WHERE Id = @parentId;

		SELECT @parentId AS ProgramID
			,CAST(CAST(@Pacifictime AS DATE) AS DATETIME) + CAST(@pickupTime AS DATETIME) AS JobOriginDateTimePlanned
			,CAST(CAST(@Pacifictime AS DATE) AS DATETIME) + CAST(@pickupTime AS DATETIME) AS JobOriginDateTimeActual
			,CAST(CAST(@Pacifictime AS DATE) AS DATETIME) + CAST(@pickupTime AS DATETIME) AS JobOriginDateTimeBaseline
	END
	ELSE
	BEGIN
		SELECT job.Id
			,job.StatusId
			,job.JobSellerCode
			,job.JobSellerSitePOC
			,job.JobSellerSitePOCPhone
			,job.JobSellerSitePOCEmail
			,job.JobSellerSitePOC2
			,job.JobSellerSitePOCPhone2
			,job.JobSellerSitePOCEmail2
			,job.JobSellerSiteName
			,job.JobSellerStreetAddress
			,job.JobSellerStreetAddress2
			,job.JobSellerStreetAddress3
			,job.JobSellerStreetAddress4
			,job.JobSellerCity
			,job.JobSellerState
			,job.JobSellerPostalCode
			,job.JobSellerCountry
			,job.JobShipFromSiteName
			,job.JobShipFromStreetAddress
			,job.JobShipFromStreetAddress2
			,job.JobShipFromStreetAddress3
			,job.JobShipFromStreetAddress4
			,job.JobShipFromCity
			,job.JobShipFromState
			,job.JobShipFromPostalCode
			,job.JobShipFromCountry
			,job.JobShipFromSitePOC
			,job.JobShipFromSitePOCPhone
			,job.JobShipFromSitePOCEmail
			,job.JobShipFromSitePOC2
			,job.JobShipFromSitePOCPhone2
			,job.JobShipFromSitePOCEmail2
			,job.[JobCompleted]
			,job.[EnteredBy]
			,job.[DateEntered]
			,job.[ChangedBy]
			,job.[DateChanged]
		FROM [dbo].[JOBDL000Master] job
		WHERE [Id] = @id
	END
END TRY

BEGIN CATCH
	DECLARE @ErrorMessage VARCHAR(MAX) = (
			SELECT ERROR_MESSAGE()
			)
		,@ErrorSeverity VARCHAR(MAX) = (
			SELECT ERROR_SEVERITY()
			)
		,@RelatedTo VARCHAR(100) = (
			SELECT OBJECT_NAME(@@PROCID)
			)

	EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo
		,NULL
		,@ErrorMessage
		,NULL
		,NULL
		,@ErrorSeverity
END CATCH

GO
