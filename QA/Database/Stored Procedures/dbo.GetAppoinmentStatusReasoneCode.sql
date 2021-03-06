SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */
-- =============================================          
-- Author:                    Kamal           
-- Create date:               01/29/2020        
-- Description:               Get reasone code and appoinment code  
-- Execution:                 EXEC [dbo].[GetAppoinmentStatusReasoneCode]  37079,'Consignee Initiated Change'  
-- Modified on:				  
-- Modified Desc:    
CREATE PROCEDURE [dbo].[GetAppoinmentStatusReasoneCode] @jobID BIGINT
	,@pgdGatewayTitle NVARCHAR(200)
	,@isDayLightSavingEnable BIT = 0
AS
BEGIN
	DECLARE @DeliveryUTCValue INT
		,@IsDeliveryDayLightSaving BIT
		,@jobDeliveryTimeZone NVARCHAR(15)

	SELECT TOP 1 @JobDeliveryTimeZone = JobDeliveryTimeZone
	FROM [dbo].[JOBDL000Master]
	WHERE Id = @JobId

	IF (ISNULL(@JobDeliveryTimeZone, 'Unknown') = 'Unknown')
	BEGIN
		SELECT TOP 1 @DeliveryUTCValue = UTC
			,@IsDeliveryDayLightSaving = IsDayLightSaving
		FROM Location000Master
		WHERE TimeZoneShortName = 'Pacific'
	END
	ELSE
	BEGIN
		SELECT TOP 1 @DeliveryUTCValue = UTC
			,@IsDeliveryDayLightSaving = IsDayLightSaving
		FROM Location000Master
		WHERE TimeZoneShortName = @JobDeliveryTimeZone
	END

	SELECT @DeliveryUTCValue = CASE 
			WHEN @IsDeliveryDayLightSaving = 1
				AND @isDayLightSavingEnable = 1
				THEN @DeliveryUTCValue + 1
			ELSE @DeliveryUTCValue
			END

	SELECT TOP 1 PgdShipStatusReasonCode
		,PgdShipApptmtReasonCode
		,@DeliveryUTCValue UTCValue
	FROM PRGRM010Ref_GatewayDefaults
	WHERE PgdProgramID IN (
			SELECT DISTINCT ProgramID
			FROM JOBDL020Gateways
			WHERE jobid = @jobID
				AND ProgramID IS NOT NULL
			)
		AND PgdShipApptmtReasonCode IS NOT NULL
		AND PgdShipStatusReasonCode IS NOT NULL
		AND PgdGatewayTitle LIKE '%' + @pgdGatewayTitle + '%'
END
GO
