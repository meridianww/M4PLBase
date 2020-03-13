/****** Object:  StoredProcedure [dbo].[GetJobMapRoute]    Script Date: 13-03-2020 13:00:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               01/31/2018      
-- Description:               Get a JobMapRoute
-- Execution:                 EXEC [dbo].[GetJobMapRoute]  
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================   
ALTER PROCEDURE [dbo].[GetJobMapRoute] @userId BIGINT
	,@roleId BIGINT
	,@orgId BIGINT
	,@id BIGINT
AS
BEGIN TRY
	SET NOCOUNT ON;

	DECLARE @OriginFullAddress VARCHAR(500)
		,@DeliveryFullAddress VARCHAR(500)

	SELECT @DeliveryFullAddress = CONCAT (
			IIF(JobDeliveryStreetAddress IS NULL, '', JobDeliveryStreetAddress + ',')
			,IIF(JobDeliveryStreetAddress2 IS NULL, '', JobDeliveryStreetAddress2 + ',')
			,IIF(JobDeliveryStreetAddress3 IS NULL, '', JobDeliveryStreetAddress3 + ',')
			,IIF(JobDeliveryStreetAddress4 IS NULL, '', JobDeliveryStreetAddress4 + ',')
			,IIF(JobDeliveryCity IS NULL, '', JobDeliveryCity + ',')
			,IIF(JobDeliveryState IS NULL, '', JobDeliveryState + ',')
			,IIF(JobDeliveryPostalCode IS NULL, '', JobDeliveryPostalCode + ',')
			,IIF(JobDeliveryCountry IS NULL, '', JobDeliveryCountry)
			)
		,@OriginFullAddress = CONCAT (
			IIF(JobOriginStreetAddress IS NULL, '', JobOriginStreetAddress + ',')
			,IIF(JobOriginStreetAddress2 IS NULL, '', JobOriginStreetAddress2 + ',')
			,IIF(JobOriginStreetAddress3 IS NULL, '', JobOriginStreetAddress3 + ',')
			,IIF(JobOriginStreetAddress4 IS NULL, '', JobOriginStreetAddress4 + ',')
			,IIF(JobOriginCity IS NULL, '', JobOriginCity + ',')
			,IIF(JobOriginState IS NULL, '', JobOriginState + ',')
			,IIF(JobOriginPostalCode IS NULL, '', JobOriginPostalCode + ',')
			,IIF(JobOriginCountry IS NULL, '', JobOriginCountry)
			)
	FROM [dbo].[JOBDL000Master] job
	WHERE [Id] = @id

	SELECT job.[Id]
		,job.[StatusId]
		,job.[JobLatitude]
		,job.[JobLongitude]
		,job.[JobMileage]
		,job.[EnteredBy]
		,job.[DateEntered]
		,job.[ChangedBy]
		,job.[DateChanged]
		,CASE 
			WHEN @DeliveryFullAddress LIKE ',%,'
				THEN SUBSTRING(@DeliveryFullAddress, 2, LEN(@DeliveryFullAddress) - 2)
			WHEN @DeliveryFullAddress LIKE ',%'
				THEN RIGHT(@DeliveryFullAddress, LEN(@DeliveryFullAddress) - 1)
			WHEN @DeliveryFullAddress LIKE '%,'
				THEN LEFT(@DeliveryFullAddress, LEN(@DeliveryFullAddress) - 1)
			ELSE @DeliveryFullAddress
			END DeliveryFullAddress
		,CASE 
			WHEN @OriginFullAddress LIKE ',%,'
				THEN SUBSTRING(@OriginFullAddress, 2, LEN(@OriginFullAddress) - 2)
			WHEN @OriginFullAddress LIKE ',%'
				THEN RIGHT(@OriginFullAddress, LEN(@OriginFullAddress) - 1)
			WHEN @OriginFullAddress LIKE '%,'
				THEN LEFT(@OriginFullAddress, LEN(@OriginFullAddress) - 1)
			ELSE @OriginFullAddress
			END OriginFullAddress
	FROM [dbo].[JOBDL000Master] job
	WHERE [Id] = @id
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